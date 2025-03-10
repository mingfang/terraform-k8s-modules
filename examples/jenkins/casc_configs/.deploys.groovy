def environments = new GroovyShell().parse(new File('/var/jenkins_home/casc_configs/.environments.groovy'))
def envEntries = environments.get()

def jobs = new GroovyShell().parse(new File('/var/jenkins_home/casc_configs/.jobs.groovy'))
def jobEntries = jobs.get()

jobEntries.each { jobEntry ->
    folder(jobEntry.folder)
    jobEntry.targetEnvs.eachWithIndex { targetEnv, i ->
        def env = envEntries[targetEnv]
        folder("${jobEntry.folder}/${env.name.toUpperCase()}")
        job("${jobEntry.folder}/${env.name.toUpperCase()}/DEPLOY ${env.name.toUpperCase()}") {
            description("DO NOT EDIT: This project was auto generated.  All changes will be lost.")
            parameters {
                booleanParam('upgrade', false)
                booleanParam('recover_state', false)
                stringParam('taint', '', 'Taint Terraform resource')
            }
            multiscm {
                git {
                    remote {
                        url("${env.scm.url}")
                        credentials("${env.scm.credential}")
                    }
                    branch('*/master')
                    extensions {
                        relativeTargetDirectory("${env.name}")
                        localBranch()
                        pathRestriction {
                            includedRegions("${env.name}/${jobEntry.folder}/.+\n${env.name}/modules/.+")
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
                    groovy("def changes = 'Changes:'; currentBuild.getChangeSet().getItems().findAll{ it.getAffectedPaths().any{ it.startsWith('${env.name}/${jobEntry.folder}') }}.each{ changes <<= '\\n- ' + it.msg +' [' + it.author.displayName + ']' }; return ['CHANGES': changes]")
                }
                ansiColorBuildWrapper {
                    colorMapName('xterm')
                }
            }
            steps {
                // deploy
                shell("cd ${env.name}/${env.name}/${jobEntry.folder}; kubectl version")
                shell("cd ${env.name}/${env.name}/${jobEntry.folder}; terraform init -input=false -upgrade=\${upgrade}")
                shell("cd ${env.name}/${env.name}/${jobEntry.folder}; [ -z \"\${taint}\" ] && echo 'No Taints' || terraform taint \${taint}")

                // plan
                shell("""
                cd ${env.name}/${env.name}/${jobEntry.folder};
                terraform plan -out=tfplan -input=false;
                terraform show -json tfplan > plan.json;
                tf-summarize plan.json > plan-summary.txt;
                """.stripIndent())

                // recover state
                shell("""
                cd ${env.name}/${env.name}/${jobEntry.folder};
                if \${recover_state}; then
                    terraform show -json tfplan > plan.json && cat plan.json | jq -r '.resource_changes[] | select(.change.actions[0]==\"create\" and .provider_name==\"registry.terraform.io/mingfang/k8s\") | .address, (.change.after.metadata[0].namespace + \".\" + .type + \".\" + .change.after.metadata[0].name)' | xargs -n 2 -r bash -c 'terraform import \$0 \$1';
                fi
                """.stripIndent())

                // apply
                shell("cd ${env.name}/${env.name}/${jobEntry.folder}; terraform apply -input=false tfplan")
            }
            properties {
            }
            publishers {
                archiveArtifacts {
                    pattern('**/plan.json')
                    pattern('**/plan-summary.txt')
                }
                downstream("SECRETS/DEPLOY SECRETS", "SUCCESS")
            }
        }
    }
}
