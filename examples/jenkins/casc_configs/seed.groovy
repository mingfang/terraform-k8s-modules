def infraRepo = "https://github.com/mingfang/terraform-inspired.git"
def infraCredential = "github"

def registryEntries = [
        registry: [
                host  : "mingfang",
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
                name            : 'prod',
                autodeploy      : false,
                desc            : 'prod environment',
                releaseCandidate: false,
                icon            : 'star-gold',
        ],
]

def jobEntries = [
        [
                name    : "express-nunjucks-htmx-stack",
                scms    : [
                        [
                                url        : "https://github.com/mingfang/express-nunjucks-htmx-stack",
                                branch     : 'master',
                                credentials: ""
                        ]
                ],
                registry: registryEntries.registry,
                promote : true
        ],
        [
                name    : "inspired-website",
                scms    : [
                        [
                                url        : "https://github.com/mingfang/inspired-website.git",
                                branch     : 'master',
                                credentials: "github"
                        ]
                ],
                registry: registryEntries.registry,
                promote : true
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

    // create folder
    if (!jobEntry.folder) {
        jobEntry.folder = jobEntry.name
    }
    folder(jobEntry.folder)

    // creat job
    job("${jobEntry.folder}/${jobEntry.name}") {
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
                        submoduleOptions{
                            disable(false)
                            parentCredentials(true)
                        }
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
            buildUserVars()

            credentialsBinding {
                usernamePassword("DOCKERHUB_USER", "DOCKERHUB_PASS", "dockerhub")
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
        quietPeriod(0)

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

            // pre build
            jobEntry.preBuild.each { command ->
                shell(command)
            }

            // build
            shell(jobEntry.registry.login)
            shell('echo ${DOCKERHUB_PASS} | docker login --username ${DOCKERHUB_USER} --password-stdin')
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
                            restrict('master')
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
            buildUserVars()
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
        label('master')
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

// Secrets

folder('SECRETS')
envEntries.eachWithIndex { env, i ->
    folder("SECRETS/${env.name}".toUpperCase())
}

// Terraform

folder('TERRAFORM')
envEntries.eachWithIndex { env, i ->
    job("TERRAFORM/APPLY ${env.name}".toUpperCase()) {
        description("DO NOT EDIT: This project was auto generated.  Any changes will be lost.")
        parameters {
            booleanParam('upgrade', false)
            booleanParam('recover_state', false)
            stringParam('taint', '', 'Taint Terraform resource')
        }
        multiscm {
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
            git {
                remote {
                    url("https://github.com/mingfang/terraform-k8s-modules.git")
                }
                branch("*/master")
                extensions {
                    relativeTargetDirectory('terraform-k8s-modules')
                    localBranch()
                }
            }
        }
        triggers {
            scm('* * * * *')
        }
        concurrentBuild(false)
        logRotator(-1, 10)
        label('master')
        wrappers {
            buildUserVars()
            credentialsBinding {
                file("KUBECONFIG", "${env.name}-kubeconfig")
            }
            environmentVariables {
                groovy("def changes = 'Changes:'; currentBuild.getChangeSet().getItems().findAll{ it.getAffectedPaths().any{ it.startsWith('${env.name}') }}.each{ changes <<= '\\n- ' + it.msg +' [' + it.author.displayName + ']' }; return ['CHANGES': changes]")
            }
            ansiColorBuildWrapper {
                colorMapName('xterm')
            }
        }
        label('master')
        steps {
            // create secrets
            systemGroovyCommand("""
            import jenkins.model.Jenkins
            import com.cloudbees.plugins.credentials.Credentials
            import com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl
            import org.jenkinsci.plugins.plaincredentials.impl.StringCredentialsImpl
            import com.cloudbees.hudson.plugins.folder.properties.FolderCredentialsProvider.FolderCredentialsProperty;
            import com.cloudbees.hudson.plugins.folder.Folder
            
            def processFolder(folder) {
              folderName = folder.getFullName()
              matcher = folderName =~ /^SECRETS\\/${env.name.toUpperCase()}\\/(.+)/
              if(!matcher.matches()) return
            
              property = folder.getProperties().get(FolderCredentialsProperty.class)
              if(!property) return

              kubeconfig = build.environment.get("KUBECONFIG")
              env = ['KUBECONFIG=' + kubeconfig]

              namespace = matcher[0][1]
              println('folder=' + folderName + ', namespace=' + namespace)
              println(['kubectl', 'create', 'namespace', namespace].execute(env, null).text)
                      
              args = []
              list = property.getCredentials()
              for (each in list) {
                if(each instanceof StringCredentialsImpl){
                  StringCredentialsImpl c = (StringCredentialsImpl)each
                  args.add('--from-literal=' + c.getId() + '=' + c.getSecret().getPlainText())
                }
              }

              println((['kubectl', '-n', namespace, 'create', 'secret', 'generic', namespace + '-secrets'] + args).execute(env, null).text)
              //println(['kubectl', 'get', 'secrets', '-n', namespace].execute(env, null).text)
            }
            
            Jenkins.instance.getAllItems(Folder.class).each{ f -> processFolder(f) }
            
            return
            """.stripIndent())

            shell("cd ${env.name}; terraform init -input=false -upgrade=\${upgrade}")
            shell("cd ${env.name}; if [ \"\${taint}\" ]; then terraform taint \${taint}; fi")
            shell("cd ${env.name}; terraform plan -out=tfplan -input=false")
            shell("cd ${env.name}; if \${recover_state; then terraform show -json tfplan > plan.json && cat plan.json | jq -r '.resource_changes[] | select(.change.actions[0]==\"create\" and .provider_name==\"registry.terraform.io/mingfang/k8s\") | .address, (.change.after.metadata[0].namespace + \".\" + .type + \".\" + .change.after.metadata[0].name)' | xargs -n 2 -r bash -c 'terraform import \$0 \$1'; fi")
            shell("cd ${env.name}; terraform apply -input=false tfplan")
        }
    }
}
