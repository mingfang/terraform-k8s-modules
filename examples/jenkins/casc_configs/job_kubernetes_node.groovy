def get(registryEntries) {
    return [
            name      : "kubernetes-node",
            folder    : "kubernetes",
            scms      : [
                    [
                            url        : "https://github.com/mingfang/docker-kubernetes-node.git",
                            branch     : 'master',
                            credentials: "github"
                    ]
            ],
            registry  : registryEntries.registry,
            promote   : false
    ]
}
