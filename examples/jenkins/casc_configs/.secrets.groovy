def environments = new GroovyShell().parse(new File('/var/jenkins_home/casc_configs/.environments.groovy'))
def envEntries = environments.get()

def jobs = new GroovyShell().parse(new File('/var/jenkins_home/casc_configs/.jobs.groovy'))
def jobEntries = jobs.get()

def folders = jobEntries.collect {it.folder}.unique(false)

folders.each { f ->
    folder(f)
    envEntries.eachWithIndex { envEntry, i ->
        def env = envEntry.value
        folder("${f}/${env.name.toUpperCase()}")
        folder("${f}/${env.name.toUpperCase()}/SECRETS")
    }
}
