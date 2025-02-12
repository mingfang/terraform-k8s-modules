def environments = new GroovyShell().parse(new File('/var/jenkins_home/casc_configs/.environments.groovy'))
def envEntries = environments.get()

def jobs = new GroovyShell().parse(new File('/var/jenkins_home/casc_configs/.jobs.groovy'))
def jobEntries = jobs.get()

jobEntries.each { jobEntry ->
    folder(jobEntry.folder)
    jobEntry.targetEnvs.eachWithIndex { targetEnv, i ->
        def env = envEntries[targetEnv]
        folder("${jobEntry.folder}/${env.name.toUpperCase()}")
        folder("${jobEntry.folder}/${env.name.toUpperCase()}/SECRETS")
    }
}
