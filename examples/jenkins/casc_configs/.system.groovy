folder('SYSTEM')
job('SYSTEM/CASC Reload') {
    label('master')
    configure { project ->
        project / 'triggers' << 'org.jenkinsci.plugins.fstrigger.triggers.FolderContentTrigger' {
            spec '* * * * *'
            path '/var/jenkins_home/casc_configs/'
            includes '**/*.groovy'
            excludeCheckLastModificationDate 'false'
            excludeCheckContent 'true'
            excludeCheckFewerOrMoreFiles 'false'
        }
    }
    steps {
        systemGroovyCommand('''
        import io.jenkins.plugins.casc.ConfigurationAsCode;
        ConfigurationAsCode.get().configure();
        ConfigurationAsCode.get().getLastTimeLoaded();
        '''.stripIndent())
    }
    publishers {
        downstream("Approve Scripts", "FAILURE")
    }
}

job('SYSTEM/Approve Scripts') {
    label('master')
    concurrentBuild(false)
    logRotator(-1, 10)

    steps {
        systemGroovyCommand('''
        import org.jenkinsci.plugins.scriptsecurity.scripts.ScriptApproval

        ScriptApproval scriptApproval = ScriptApproval.get()
        scriptApproval.pendingScripts.each {
            scriptApproval.approveScript(it.hash)
        }
        '''.stripIndent())
    }
    publishers {
        retryBuild {
            fixedDelay(1)
        }
    }
}