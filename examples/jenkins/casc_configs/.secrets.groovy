def environments = new GroovyShell().parse(new File('/var/jenkins_home/casc_configs/.environments.groovy'))
def envEntries = environments.get()

def jobs = new GroovyShell().parse(new File('/var/jenkins_home/casc_configs/.jobs.groovy'))
def jobEntries = jobs.get()

jobEntries.each { jobEntry ->
    folder(jobEntry.folder)
    jobEntry.targetEnvs.eachWithIndex { targetEnv, i ->
        def env = envEntries[targetEnv]
        folder("${jobEntry.folder}/${env.name.toUpperCase()}")
        folder("${jobEntry.folder}/${env.name.toUpperCase()}/SECRETS") {
            properties {
                folderCredentialsProperty {
                }
            }
        }

        job("${jobEntry.folder}/${env.name.toUpperCase()}/SECRETS/ADD SECRET") {
            description("DO NOT EDIT: This project was auto generated.  All changes will be lost.")
            concurrentBuild(false)
            logRotator(-1, 10)
            label('master')
            parameters {
                stringParam('secret_name')
                nonStoredPasswordParam('secret_value')
            }
            wrappers {
                buildUserVars()
                ansiColorBuildWrapper {
                    colorMapName('xterm')
                }
            }
            steps {
                // create secrets
                systemGroovyCommand("""
                import jenkins.model.Jenkins
                import org.jenkinsci.plugins.plaincredentials.impl.StringCredentialsImpl
                import com.cloudbees.hudson.plugins.folder.properties.FolderCredentialsProvider.FolderCredentialsProperty;
                import com.cloudbees.hudson.plugins.folder.Folder
                import static com.cloudbees.plugins.credentials.CredentialsScope.GLOBAL
                import hudson.util.Secret

                folder = Jenkins.instance.getItemByFullName('${jobEntry.folder}/${env.name.toUpperCase()}/SECRETS', Folder.class);
                property = folder.getProperties().get(FolderCredentialsProperty.class)
                if(!property) return

                secret_name = build.getBuildVariables().get('secret_name')
                secret_value = build.getBuildVariables().get('secret_value')

                list = property.getCredentials()
                // prevent duplicate
                for (each in list) {
                    if(each.id.equals(secret_name)) return
                }
                // add
                list.add(new StringCredentialsImpl(
                    GLOBAL,
                    secret_name,
                    '',
                    Secret.fromString(secret_value)
                ))

                return
                """.stripIndent())
            }
            publishers {
                downstream("DEPLOY SECRETS", "SUCCESS")
            }
        }

        job("${jobEntry.folder}/${env.name.toUpperCase()}/SECRETS/DEPLOY SECRETS") {
            description("DO NOT EDIT: This project was auto generated.  All changes will be lost.")
            concurrentBuild(false)
            logRotator(-1, 10)
            label('master')
            wrappers {
                buildUserVars()
                credentialsBinding {
                    file("KUBECONFIG", "${env.name}-kubeconfig")
                }
                ansiColorBuildWrapper {
                    colorMapName('xterm')
                }
            }
            steps {
                // deploy secrets
                systemGroovyCommand("""
                import jenkins.model.Jenkins
                import org.jenkinsci.plugins.plaincredentials.impl.StringCredentialsImpl
                import com.cloudbees.hudson.plugins.folder.properties.FolderCredentialsProvider.FolderCredentialsProperty;
                import com.cloudbees.hudson.plugins.folder.Folder

                def getFolderCredentials(folder) {
                    credentials = []
                    property = folder.getProperties().get(FolderCredentialsProperty.class)
                    if(property){
                        for (each in property.getCredentials()) {
                            if(each instanceof StringCredentialsImpl){
                                credentials.add(each)
                            }
                        }
                    }
                    return credentials
                }

                def createSecret(credentials){
                    env = ['KUBECONFIG=' + build.environment.get("KUBECONFIG")]
                    namespace = '${jobEntry.folder}'
                    secretName = namespace + '-secrets'
                    args = credentials.collect{'--from-literal=' + it.getId() + '=' + it.getSecret().getPlainText()}

                    // first delete existing secret
                    println(([
                        'kubectl', '-n', namespace, 'delete', 'secret', secretName
                    ]).execute(env, null).text)

                    // then create new secret
                    println(([
                        'kubectl', '-n', namespace, 'create', 'secret', 'generic', secretName
                    ] + args).execute(env, null).text)

                    // dump
                    println([
                        'kubectl', '-n', namespace, 'describe', 'secrets', secretName
                    ].execute(env, null).text)
                }

                // add credentials from inherited folders
                allCredentials = []
                for(f in ${jobEntry.inheritSecrets.collect{ '"' + it + '"'}}) {
                    println('Inherit from ' + f)
                    allCredentials.addAll(getFolderCredentials(
                        Jenkins.instance.getItemByFullName(f + '/${env.name.toUpperCase()}/SECRETS', Folder.class)
                    ))
                }
                // add credentials from this folders
                allCredentials.addAll(getFolderCredentials(
                    Jenkins.instance.getItemByFullName('${jobEntry.folder}/${env.name.toUpperCase()}/SECRETS', Folder.class)
                ))

                // merge and override
                finalCredentials = allCredentials.groupBy{it.id}.collect{k,v -> v.last()}.flatten()

                // create kubernetes secrets
                createSecret(finalCredentials)

                return
                """.stripIndent())
            }
        }
    }
}
