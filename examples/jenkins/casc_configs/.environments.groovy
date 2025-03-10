def get() {
        return [
                dev: [
                        name            : 'dev',
                        autodeploy      : true,
                        desc            : 'development environment',
                        releaseCandidate: false,
                        icon            : 'star-green',
                        scm : [
                                url : "https://github.com/mingfang/terraform-rebelsoft-deploy-dev.git",
                                credential : "github"
                        ],
                ],
                prod: [
                        name            : 'prod',
                        autodeploy      : false,
                        desc            : 'production environment',
                        releaseCandidate: false,
                        icon            : 'star-gold',
                        scm : [
                                url : "https://github.com/mingfang/terraform-rebelsoft-deploy-prod.git",
                                credential : "github"
                        ],
                ],
        ]
}