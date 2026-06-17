def get(registryEntries) {
    return [
            name      : "coder-workspace",
            folder    : "coder-workspace",
            scms      : [
                    [
                            url        : "https://github.com/mingfang/docker-coder-workspace.git",
                            branch     : 'master',
                            credentials: "github"
                    ]
            ],
            registry  : registryEntries.registry,
            promote   : false
    ]
}
