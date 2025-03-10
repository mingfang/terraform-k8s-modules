def environments = new GroovyShell().parse(new File('/var/jenkins_home/casc_configs/.environments.groovy'))
def envEntries = environments.get()

def jobs = new GroovyShell().parse(new File('/var/jenkins_home/casc_configs/.jobs.groovy'))
def jobEntries = jobs.get()

jobEntries.each { jobEntry ->
    folder(jobEntry.folder)
    jobEntry.targetEnvs.eachWithIndex { targetEnv, i ->
        def env = envEntries[targetEnv]
        folder("${jobEntry.folder}/${env.name.toUpperCase()}")
        job("${jobEntry.folder}/${env.name.toUpperCase()}/PROMOTE ${env.name.toUpperCase()}") {
            description("DO NOT EDIT: This project was auto generated.  All changes will be lost.")
            parameters {
                stringParam('folder')
                stringParam('registry')
                stringParam('image_name')
                stringParam('image_version')
                stringParam('env_target')
                stringParam('git_name', '${BUILD_USER}', 'Git user name')
                stringParam('git_email', '${BUILD_USER_EMAIL}', 'Git user email')
            }
            wrappers {
                buildName('${image_name}:${image_version}')
                buildUserVars()
                credentialsBinding {}
            }
            scm {
                git {
                    remote {
                        url("${env.scm.url}")
                        credentials("${env.scm.credential}")
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
                shell('mkdir -p ${env_target}/${folder} && echo "${image_name}-image = \\"${registry}/${image_name}:${image_version}\\"" > "${env_target}/${folder}/${image_name}.auto.tfvars"')
                shell('git add "${env_target}/${folder}/${image_name}.auto.tfvars"')
                shell('git config --global user.email "$git_email"')
                shell('git config --global user.name "$git_name"')
                shell('if ! git diff-index --quiet HEAD --; then ' + 'git commit -m "Deploy ${image_name}:${image_version} to ${env_target}."' + ';fi')
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
                downstream("DEPLOY ${env.name.toUpperCase()}", "SUCCESS")
            }
        }
    }
}
