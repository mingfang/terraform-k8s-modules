def infraRepo = "https://github.com/mingfang/terraform-deploy-example.git"
def infraCredential = "github"

def registryEntries = [
        registry: [
                host  : "registry-example.rebelsoft.com",
                login : "",
                create: "",
        ]
]

def envEntries = [
        [
                name            : 'dev',
                autodeploy      : true,
                desc            : 'development environment',
                releaseCandidate: false,
                icon            : 'star-green',
        ],
        [
                name            : 'qa',
                autodeploy      : false,
                desc            : 'qa environment',
                releaseCandidate: false,
                icon            : 'star-blue',
        ],
        [
                name            : 'prod',
                autodeploy      : false,
                desc            : 'prod environment',
                releaseCandidate: false,
                icon            : 'star-gold',
        ],
]

def jobEntries = [
        [
                name      : "springboot-docker",
                scms      : [
                        [
                                url        : "https://github.com/mingfang/docker-springboot.git",
                                branch     : 'master',
                                credentials: ""
                        ]
                ],
                registry  : registryEntries.registry,
                promote   : true
        ],
]

// jobs

def DEFAULT_CONTEXT = '.'
def DEFAULT_DOCKERFILE = 'Dockerfile'

jobEntries.each { jobEntry ->
    def build = jobEntry.build ?: [:]
    build.context = jobEntry.context ?: DEFAULT_CONTEXT
    build.dockerfile = jobEntry.dockerfile ?: DEFAULT_DOCKERFILE
    def pr = jobEntry.pr ?: false
    def image = jobEntry.image ?: jobEntry.name
    def push = jobEntry.registry ?: false
    def registry = jobEntry.registry.host
    def promote = jobEntry.promote ?: false
    def buildArgs = ""
    (jobEntry.buildArgs ?: [:]).each {
        buildArgs += " --build-arg ${it.key}=\"${it.value}\" "
    }
    def jobFolder = ""
    if (jobEntry.folder) {
        jobFolder += "/${jobEntry.folder}"
        folder(jobFolder)
    }
    job("${jobFolder}/${jobEntry.name}") {
        description("DO NOT EDIT: This project was auto generated.  All manual changes will be lost.")
        multiscm {
            jobEntry.scms.eachWithIndex { scm, i ->
                git {
                    remote {
                        name('origin')
                        if (pr) {
                            refspec('+refs/pull/*:refs/remotes/origin/pr/*')
                        } else {
                            refspec('+refs/heads/*:refs/remotes/origin/*')
                        }
                        url("${scm.url}")
                        credentials("${scm.credentials ?: ''}")
                    }
                    branch("\${branch${i}}")
                    extensions {
                        relativeTargetDirectory("${scm.subdir ?: ''}")
                        localBranch()
                    }
                }
            }
        }
        parameters {
            booleanParam('no_cache', false)
            jobEntry.scms.eachWithIndex { scm, i ->
                stringParam("branch${i}", "${scm.branch}")
            }
        }
        wrappers {
            environmentVariables {
                // auto enable no-cache if last build failed
                groovy("return ['LAST_BUILD_RESULT': currentJob.getBuilds().size() > 1 ?  currentJob.getBuilds()[1].result : 'NONE']")
            }
            // build name
            def buildName = ""
            jobEntry.scms.eachWithIndex { _, i ->
                if (i == 0) {
                    buildName += '${GIT_LOCAL_BRANCH}-' + '${GIT_REVISION,length=6}'
                } else {
                    //wait for fix https://issues.jenkins-ci.org/browse/JENKINS-13347
                    //buildName += "-\${GIT_LOCAL_BRANCH_${i}}-" + "\${GIT_REVISION_${i},length=6}"
                }
            }
            buildName += '-${BUILD_NUMBER}'
            buildNameSetter {
                template(buildName)
                runAtStart(true)
                runAtEnd(false)
            }

            credentialsBinding {
            }

            ansiColorBuildWrapper {
                colorMapName('xterm')
            }
        }

        triggers {
            if (jobEntry.githubProjectUrl != null) {
                githubPullRequest {
                    useGitHubHooks()
                    permitAll()
                }
            }
            if (!pr) {
                scm('* * * * *')
            }
        }
        concurrentBuild(pr)
        throttleConcurrentBuilds {
            maxPerNode(1)
        }
        logRotator(-1, 100)

        steps {
            shell('echo "$(echo ${BUILD_DISPLAY_NAME}|tr "/" "_")" > version.txt')
            buildNameUpdater {
                fromFile(true)
                buildName('version.txt')
                fromMacro(false)
                macroTemplate('')
                macroFirst(false)
            }
            shell('rm version.txt || true')

            shell(jobEntry.registry.login)
            shell('docker build --build-arg BUILD_DISPLAY_NAME=${BUILD_DISPLAY_NAME} $([ "$no_cache" = true ] || [ "$LAST_BUILD_RESULT" != "SUCCESS" ] && echo "--no-cache") --pull ' + "${buildArgs}" + " -t ${registry}/${image}:" + '${BUILD_DISPLAY_NAME}' + " -f ${build.dockerfile} ${build.context}")
            //push
            if (registry && !pr && push) {
                //create repo
                shell("REPO_NAME=${image}; " + jobEntry.registry.create)
                //push sha
                shell("docker push ${registry}/${image}:" + '${BUILD_DISPLAY_NAME}')
                //push [branch]-latest
                //shell("docker tag ${registry}/${image}:" + '${BUILD_DISPLAY_NAME}' + " ${registry}/${image}:" + '$(echo ${GIT_LOCAL_BRANCH}|tr "/" "_")-latest')
                //shell("docker push ${registry}/${image}:" + '$(echo ${GIT_LOCAL_BRANCH}|tr "/" "_")-latest')
                //push latest (should only for master)
                shell("docker tag ${registry}/${image}:" + '${BUILD_DISPLAY_NAME}' + " ${registry}/${image}:latest")
                shell("docker push ${registry}/${image}:latest")
            }
        }

        //post build
        publishers {
            retryBuild {
                retryLimit(3)
                progressiveDelay(60, 600)
            }
            chucknorris()
        }

        properties {
            //needed to auto create wehbooks
            if (jobEntry.githubProjectUrl != null) {
                githubProjectUrl(jobEntry.githubProjectUrl)
            }

            //promotions
            if (!pr && push && promote) {
                promotions {
                    envEntries.eachWithIndex { env, i ->
                        def releaseCandidate = jobEntry.withReleaseCandidate && env.releaseCandidate
                        promotion {
                            if (releaseCandidate) {
                                name("${i}_${env.name}_rc")
                            } else {
                                name("${i}_${env.name}")
                            }
                            icon(env.icon)
                            conditions {
                                if (i > 0) {
                                    def previousEnv = envEntries[i - 1]
                                    if (previousEnv.releaseCandidate) {
                                        upstream("${i - 1}_${previousEnv.name}_rc")
                                    } else {
                                        upstream("${i - 1}_${previousEnv.name}")
                                    }
                                }
                                if (env.autodeploy) {
                                    selfPromotion(true)
                                } else {
                                    manual('') {
                                        parameters {
                                            stringParam('git_name', '', 'Git user name')
                                            stringParam('git_email', '', 'Git user email')
                                        }
                                    }
                                }
                            }
                            actions {
                                downstreamParameterized {
                                    trigger("PROMOTIONS/PROMOTE TO ${env.name}".toUpperCase()) {
                                        block {
                                            buildStepFailure('FAILURE')
                                            failure('FAILURE')
                                            unstable('UNSTABLE')
                                        }
                                        parameters {
                                            if (releaseCandidate) {
                                                predefinedProp('image_name', "${image}-rc")
                                            } else {
                                                predefinedProp('image_name', "${image}")
                                            }
                                            predefinedProp('image_version', '${PROMOTED_DISPLAY_NAME}')
                                            predefinedProp('registry', registry)
                                            predefinedProp('env_target', env.name)
                                            predefinedProp('git_name', '$git_name')
                                            predefinedProp('git_email', '$git_email')
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

// promotions

folder('PROMOTIONS')
envEntries.eachWithIndex { env, i ->
    job("PROMOTIONS/PROMOTE TO ${env.name}".toUpperCase()) {
        description("DO NOT EDIT: This project was auto generated.  Any changes will be lost.")
        parameters {
            stringParam('registry')
            stringParam('image_name')
            stringParam('image_version')
            stringParam('env_target')
            stringParam('git_name', '', 'Git user name')
            stringParam('git_email', '', 'Git user email')
        }
        wrappers {
            buildName('${env_target}-${image_name}:${image_version}')
            credentialsBinding {
            }
        }
        scm {
            git {
                remote {
                    url(infraRepo)
                    credentials(infraCredential)
                }
                branch('*/master')
                extensions {
                    localBranch()
                }
            }
        }
        concurrentBuild(false)
        logRotator(-1, 10)
        steps {
            shell('echo "${image_name}-image = \\"${registry}/${image_name}:${image_version}\\"" > "${env_target}/${image_name}.auto.tfvars"')
            shell('git add "${env_target}/${image_name}.auto.tfvars"')
            shell('git config --global user.email "$git_email"')
            shell('git config --global user.name "$git_name"')
            shell('git commit -m "Deploy ${image_name}:${image_version} to ${env_target}."')
        }
        publishers {
            gitPublisher {
                pushOnlyIfSuccess(true)
                branchesToPush {
                    branchToPush {
                        targetRepoName('origin')
                        branchName('master')
                    }
                }
                pushMerge(false)
                forcePush(false)
            }
            downstream("TERRAFORM/APPLY ${env.name}".toUpperCase(), "SUCCESS")
        }
    }
}

// Terraform
folder('TERRAFORM')
envEntries.eachWithIndex { env, i ->
    job("TERRAFORM/APPLY ${env.name}".toUpperCase()) {
        description("DO NOT EDIT: This project was auto generated.  Any changes will be lost.")
        scm {
            git {
                remote {
                    url(infraRepo)
                    credentials(infraCredential)
                }
                branch('*/master')
                extensions {
                    relativeTargetDirectory('')
                    localBranch()
                    pathRestriction {
                        includedRegions("$env.name/.*")
                        excludedRegions("")
                    }
                }
            }
        }
        triggers {
        }
        concurrentBuild(false)
        logRotator(-1, 10)
        wrappers {
            credentialsBinding {
                file("kubeconfig", "${env.name}-kubeconfig")
            }
            environmentVariables {
                groovy("def changes = 'Changes:'; currentBuild.getChangeSet().getItems().findAll{ it.getAffectedPaths().any{ it.startsWith('${env.name}') }}.each{ changes <<= '\\n- ' + it.msg +' [' + it.author.displayName + ']' }; return ['CHANGES': changes]")
            }
            ansiColorBuildWrapper {
                colorMapName('xterm')
            }
        }
        steps {
            shell("cd ${env.name}; KUBECONFIG=\${kubeconfig} terraform init -input=false")
            shell("cd ${env.name}; KUBECONFIG=\${kubeconfig} terraform plan -out=tfplan -input=false")
            shell("cd ${env.name}; KUBECONFIG=\${kubeconfig} terraform apply -input=false tfplan")
        }
        publishers {
        }
    }
}
