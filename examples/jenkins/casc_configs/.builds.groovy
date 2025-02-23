def environments = new GroovyShell().parse(new File('/var/jenkins_home/casc_configs/.environments.groovy'))
def envEntries = environments.get()

def jobs = new GroovyShell().parse(new File('/var/jenkins_home/casc_configs/.jobs.groovy'))
def jobEntries = jobs.get()

jobEntries.each { jobEntry ->
    jobEntry.build = jobEntry.build ?: [:]
    jobEntry.build.context = jobEntry.context ?: '.'
    jobEntry.build.dockerfile = jobEntry.dockerfile ?: 'Dockerfile'
    jobEntry.pr = jobEntry.pr ?: false
    jobEntry.image = jobEntry.image ?: jobEntry.name
    jobEntry.push = jobEntry.registry ?: false
    def registry = jobEntry.registry.host
    jobEntry.promote = jobEntry.promote ?: false
    def buildArgs = ""
    (jobEntry.buildArgs ?: [:]).each {
        buildArgs += " --build-arg ${it.key}=\"${it.value}\" "
    }
    jobEntry.dockerArgs = jobEntry.dockerArgs ?: ''
    jobEntry.preBuild = jobEntry.preBuild ?: []

    // defaults target env
    jobEntry.targetEnvs = jobEntry.targetEnvs ?: ["dev", "prod"]

    // create folder
    folder(jobEntry.folder)

    job("${jobEntry.folder}/${jobEntry.name}") {
        description("DO NOT EDIT: This project was auto generated.  All changes will be lost.")
        multiscm {
            jobEntry.scms.eachWithIndex { scm, i ->
                git {
                    remote {
                        name('origin')
                        if (jobEntry.pr) {
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
            if (!jobEntry.pr) {
                scm('* * * * *')
            }
        }
        concurrentBuild(jobEntry.pr)
        throttleConcurrentBuilds {
            maxPerNode(1)
        }
        logRotator(-1, 100)
        quietPeriod(0)
        label('jenkins-slave')

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
            shell('docker build --build-arg BUILD_DISPLAY_NAME=${BUILD_DISPLAY_NAME} $([ "$no_cache" = true ] || [ "$LAST_BUILD_RESULT" != "SUCCESS" ] && echo "--no-cache") --pull ' + " ${buildArgs} " + " ${jobEntry.dockerArgs} " +" -t ${registry}/${jobEntry.image}:" + '${BUILD_DISPLAY_NAME}' + " -f ${jobEntry.build.dockerfile} ${jobEntry.build.context}")
            //push
            if (registry && !jobEntry.pr && jobEntry.push) {
                //create repo
                shell("REPO_NAME=${jobEntry.image}; " + jobEntry.registry.create)
                //push sha
                shell("docker push ${registry}/${jobEntry.image}:" + '${BUILD_DISPLAY_NAME}')
                //push [branch]-latest
                //shell("docker tag ${registry}/${jobEntry.image}:" + '${BUILD_DISPLAY_NAME}' + " ${registry}/${jobEntry.image}:" + '$(echo ${GIT_LOCAL_BRANCH}|tr "/" "_")-latest')
                //shell("docker push ${registry}/${jobEntry.image}:" + '$(echo ${GIT_LOCAL_BRANCH}|tr "/" "_")-latest')
                //push latest (should only for master)
                shell("docker tag ${registry}/${jobEntry.image}:" + '${BUILD_DISPLAY_NAME}' + " ${registry}/${jobEntry.image}:latest")
                shell("docker push ${registry}/${jobEntry.image}:latest")
            }
        }

        //post build
        publishers {
            retryBuild {
                retryLimit(3)
                progressiveDelay(60, 600)
            }
            if (jobEntry.sonar ?: false) {
                downstreamParameterized {
                    trigger("SONAR/${jobEntry.folder}/${jobEntry.name}") {
                        parameters {
                            predefinedProp('extraCmd', jobEntry.sonar.extraCmd ?: '')
                            predefinedProp('extraArgs', jobEntry.sonar.extraArgs ?: '')
                            predefinedProp('projectVersion', '${BUILD_DISPLAY_NAME}')
                            predefinedProp('branch0', '${GIT_COMMIT}')
                        }
                    }
                }
            }
        }

        properties {
            //needed to auto create wehbooks
            if (jobEntry.githubProjectUrl != null) {
                githubProjectUrl(jobEntry.githubProjectUrl)
            }

            //promotions
            if (!jobEntry.pr && jobEntry.push && jobEntry.promote) {
                promotions {
                    jobEntry.targetEnvs.eachWithIndex { targetEnv, i ->
                        def env = envEntries[targetEnv]
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
                                    def targetPrevEnv = jobEntry.targetEnvs[i - 1]
                                    def previousEnv = envEntries[targetPrevEnv]
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
                                        }
                                    }
                                }
                            }
                            restrict('master')
                            actions {
                                downstreamParameterized {
                                    trigger("${env.name.toUpperCase()}/PROMOTE ${env.name.toUpperCase()}") {
                                        block {
                                            buildStepFailure('FAILURE')
                                            failure('FAILURE')
                                            unstable('UNSTABLE')
                                        }
                                        parameters {
                                            if (releaseCandidate) {
                                                predefinedProp('image_name', "${jobEntry.image}-rc")
                                            } else {
                                                predefinedProp('image_name', "${jobEntry.image}")
                                            }
                                            predefinedProp('image_version', '${PROMOTED_DISPLAY_NAME}')
                                            predefinedProp('folder', jobEntry.folder)
                                            predefinedProp('registry', registry)
                                            predefinedProp('env_target', env.name)
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
