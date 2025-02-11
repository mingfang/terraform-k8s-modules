def get(registryEntries) {
    return [
            name      : "express-nunjucks-htmx-stack",
            folder    : "demo",
            scms      : [
                    [
                            url        : "https://github.com/mingfang/express-nunjucks-htmx-stack",
                            branch     : 'master',
                            credentials: ""
                    ]
            ],
            registry  : registryEntries.registry,
            promote   : true,
            targetEnvs: ['dev']
    ]
}
