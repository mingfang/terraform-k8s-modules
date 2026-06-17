def get(registryEntries) {
    return [
            name      : "mem0-api-server",
            folder    : "open-source",
            scms      : [
                    [
                            url        : "https://github.com/mem0ai/mem0.git",
                            branch     : 'main',
                            credentials: "github"
                    ]
            ],
            dockerfile: "server/Dockerfile",
            context: "server",
            registry  : registryEntries.registry,
            promote   : false
    ]
}
