def get() {
    def registries = new GroovyShell().parse(new File('/var/jenkins_home/casc_configs/.registries.groovy'))
    def registryEntries = registries.get()

    def jobsList = []
    def jobsGroovy = new File('/var/jenkins_home/casc_configs/')
    jobsGroovy.eachFileMatch( ~/job_.+\.groovy/ ) {
        jobsList << new GroovyShell().parse(it).get(registryEntries)
    }
    return jobsList
}