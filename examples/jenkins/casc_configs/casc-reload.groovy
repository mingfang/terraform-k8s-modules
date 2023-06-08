folder('SYSTEM')
job('SYSTEM/CASC Reload') {
    label('master')
    configure { project ->
        project / 'triggers' << 'org.jenkinsci.plugins.fstrigger.triggers.FolderContentTrigger' {
            spec '* * * * *'
            path '/var/jenkins_home/casc_configs/'
            excludeCheckLastModificationDate 'false'
            excludeCheckContent 'true'
            excludeCheckFewerOrMoreFiles 'false'

        }
    }
    steps {
        systemGroovyCommand('import io.jenkins.plugins.casc.ConfigurationAsCode; ConfigurationAsCode.get().configure(); ConfigurationAsCode.get().getLastTimeLoaded();')
    }
}