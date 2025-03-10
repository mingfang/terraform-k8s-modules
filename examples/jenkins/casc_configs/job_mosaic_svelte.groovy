def get(registryEntries) {
    return [
            name      : "mosaic-svelte",
            folder    : "mosaic-svelte",
            scms      : [
                    [
                            url        : "https://github.com/mingfang/mosaic-svelte.git",
                            branch     : 'master',
                            credentials: ""
                    ]
            ],
            registry  : registryEntries.registry,
            promote   : true,
            targetEnvs: ['dev','prod'],
            inheritSecrets: ['demo', 'xstate-mermaid']
    ]
}
