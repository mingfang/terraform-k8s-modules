def get(registryEntries) {
    return [
            name      : "xstate-mermaid",
            folder    : "xstate-mermaid",
            scms      : [
                    [
                            url        : "https://github.com/mingfang/xstate-mermaid.git",
                            branch     : 'master',
                            credentials: "github"
                    ]
            ],
            registry  : registryEntries.registry,
            promote   : true,
            targetEnvs: ['dev']
    ]
}
