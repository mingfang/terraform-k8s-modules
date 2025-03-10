def jobs = new GroovyShell().parse(new File('/var/jenkins_home/casc_configs/.jobs.groovy'))
def jobEntries = jobs.get()

def folders = jobEntries.collect {it.folder}.unique(false)

folders.each { f ->
    folder(f)

    listView("${f}/Overview") {
        recurse(true)
        jobs({

        })
    }
}