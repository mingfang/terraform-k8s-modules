def get(registryEntries) {
    return [
            name      : "terraform-provider-k8s",
            folder    : "terraform-provider-k8s",
            scms      : [
                    [
                            url        : "https://github.com/mingfang/terraform-provider-k8s.git",
                            branch     : 'master',
                            credentials: "github"
                    ]
            ],
            registry  : registryEntries.registry,
            promote   : false
    ]
}
