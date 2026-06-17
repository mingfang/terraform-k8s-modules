def get(registryEntries) {
    return [
            name      : "kubernetes-master",
            folder    : "kubernetes",
            scms      : [
                    [
                            url        : "https://github.com/mingfang/docker-kubernetes-master.git",
                            branch     : 'master',
                            credentials: "github"
                    ]
            ],
            registry  : registryEntries.registry,
            promote   : false
    ]
}
