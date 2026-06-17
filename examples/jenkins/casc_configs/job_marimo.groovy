def get(registryEntries) {
    return [
            name      : "marimo",
            folder    : "open-source",
            scms      : [
                    [
                            url        : "https://github.com/marimo-team/marimo.git",
                            branch     : 'main',
                            credentials: "github"
                    ]
            ],
            dockerfile: "docker/Dockerfile",
            context: ".",
            registry  : registryEntries.registry,
            promote   : false
    ]
}
