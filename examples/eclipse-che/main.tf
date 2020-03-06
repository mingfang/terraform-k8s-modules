resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
    labels = {
      app       = "che"
      component = "che"
    }
  }
}

module "nfs-server" {
  source    = "../../modules/nfs-server-empty-dir"
  name      = "nfs-server"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "nfs-provisioner" {
  source        = "../../modules/nfs-provisioner-empty-dir"
  name          = "nfs-provisioner"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  storage_class = k8s_core_v1_namespace.this.metadata[0].name
}

module "postgres-storage" {
  source        = "../../modules/kubernetes/storage-nfs"
  name          = "postgres"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  replicas      = 1
  mount_options = module.nfs-server.mount_options
  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  storage       = "1Gi"

  annotations = {
    "nfs-server-uid" = module.nfs-server.deployment.metadata[0].uid
  }
}

module "postgres" {
  source        = "../../modules/postgres"
  name          = "postgres"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  storage_class = module.postgres-storage.storage_class_name
  storage       = module.postgres-storage.storage
  replicas      = module.postgres-storage.replicas

  POSTGRES_USER     = "pgche"
  POSTGRES_PASSWORD = "pgchepassword"
  POSTGRES_DB       = "dbche"
}

resource "k8s_core_v1_persistent_volume" "che-data-volume" {
  metadata {
    name = "${var.namespace}-che-data-volume"
  }
  spec {
    storage_class_name               = "che-data-volume"
    persistent_volume_reclaim_policy = "Retain"
    access_modes                     = ["ReadWriteOnce"]
    capacity = {
      storage = var.user_storage
    }
    nfs {
      path   = "/"
      server = module.nfs-server.service.spec[0].cluster_ip
    }
    mount_options = module.nfs-server.mount_options
  }
}

resource "k8s_core_v1_persistent_volume_claim" "che_data_volume" {
  metadata {
    name        = "che-data-volume"
    namespace   = k8s_core_v1_namespace.this.metadata[0].name
    annotations = { "volume-uid" = k8s_core_v1_persistent_volume.che-data-volume.metadata[0].uid }
  }
  spec {
    storage_class_name = k8s_core_v1_persistent_volume.che-data-volume.spec[0].storage_class_name
    volume_name        = k8s_core_v1_persistent_volume.che-data-volume.metadata[0].name
    access_modes       = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.user_storage
      }
    }
  }
}

module "eclipse-che" {
  source        = "../../modules/eclipse-che/eclipse-che"
  name          = var.name
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  ingress_class = "nginx"

  CHE_INFRA_KUBERNETES_CLUSTER__ROLE__NAME      = "cluster-admin"
  CHE_INFRA_KUBERNETES_NAMESPACE_DEFAULT        = "${var.namespace}-<username>"
  CHE_INFRA_KUBERNETES_PVC_STORAGE__CLASS__NAME = module.nfs-provisioner.storage_class

  CHE_INFRA_KUBERNETES_TLS__ENABLED    = true
  CHE_HOST                             = "che.eclipse-example.rebelsoft.com"
  CHE_WORKSPACE_DEVFILE__REGISTRY__URL = "https://devfile-registry.rebelsoft.com"
  CHE_WORKSPACE_PLUGIN__REGISTRY__URL  = "https://plugin-registry.rebelsoft.com/v3"

  /*
  Ingress strategy
  Domain only needed when strategy is multi-host
  */
  CHE_INFRA_KUBERNETES_SERVER__STRATEGY        = "multi-host"
  CHE_INFRA_KUBERNETES_INGRESS_DOMAIN          = "eclipse-example.rebelsoft.com"
  CHE_INFRA_KUBERNETES_INGRESS_PATH__TRANSFORM = null

  /*
  Depends on examples/keycloak
  */
  CHE_MULTIUSER                  = true
  CHE_KEYCLOAK_AUTH__SERVER__URL = "https://keycloak.rebelsoft.com/auth"
  CHE_KEYCLOAK_REALM             = "eclipse-che"
  CHE_KEYCLOAK_CLIENT__ID        = "eclipse-che"

  // run as root
  CHE_INFRA_KUBERNETES_POD_SECURITY__CONTEXT_FS__GROUP     = "0"
  CHE_INFRA_KUBERNETES_POD_SECURITY__CONTEXT_RUN__AS__USER = "0"

  CHE_INFRA_KUBERNETES_TLS__KEY = base64decode("LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFcEFJQkFBS0NBUUVBc0p1cWw1SlZreTRHT3J1UlVkWWhPYWM5a285cEQvMEZ0cnNXNjlwbnhkQU1HMTRwClhuUUxQWWpTbFNVbWVIMVlmN2tjRG5oNkt6TjBIdVlSb3N5ZlQ1NUZFb29iSnQwaTZUSkFKUCsxRVJFN0NyYVUKRThrcUUxVGo1S05MMDhBY0hia294WUtIaDFmczF2OVlodDhVL0lvNGZwWmJITW1zdFdJVThrbzlsam8rR3VvOAo4Rkh2YlQ3WFFBRENjUVNiMFFvZTU0Mi9QVnI4U2o2b09vT0VMRGp3OWFkcGRFaDZtNHNjeWEyRmtRbzg4OEo2CkY5Um00ekdVVVRNY2huaDhobWwycVNIeHY5M1pNMGlOaFBmbkxJaS9haFJ0Mjd6OHQvVnBzQ3pHd0s5TkxPWmkKSE1ONzd0ZnlJa1RYYTlPWGM2S2JlazVhRlE0TlY0TjZPRHhTRVFJREFRQUJBb0lCQURxVStFcGMzUXY4S1U3VQpKd2taV1Y0UmJxZ3Q3L0RBd21OeHZkR3dXZG5SQUNNWDRlc1YzU0NsUVF6K0RMdk5BRTBscnZ2UjFOeDlyZGdPCkF1MllxSU8xZ1QzOEY3T1ZpTjRIc0NWVnVNOFhneGt6cFB6SExyREk2T3RQaTNpSzhnaWVBYnM2YUJCcUJ3THUKSW9SaWZVaWo1TWVBd21wVEwzbmZOZ21Fdk5jV242Mis1VGpqUmczL2VITUJZaFV0WWlvbTJaU3lLOFBpYWx4MwpDMjZqT011V0xTZGxqRllvbC9yc0xBVmRpRkMrcHdaVFlqZHZaVFRVMlZIN21lT0NFNzVSVFVqN1BJa2hWVmV2Ck1IUjFqQVV4aFUxQ3NGSVQ0MlBjV0ErOG02Yko1N1EwN1oyblNiMTViMGVBdDlIY2ozWVpzTzIzd1RQQU4xWnMKd28zbEhFMENnWUVBMGRITm05TlhmYStoem9GNWZWbXVoMWU2K0NhNm1FSWp3ektXd2Nyb2wvUGV6NWVNa0FzTwpYL3l4dm5zNEpNbTV0Nk1QYWt6MmpleGMzVndFTVRFaUNCamg3bm4wc2tRRjZWZHhTTlU5dyt3a0VsWE5CUEZXClZsaXhyRnNmdjFHY1NjZ212dFZHVmc4dzl3dXFYTzByR08rRkQ0Y0NiV1dSeTVzMU1nanhPZGNDZ1lFQTEzcVQKaTJPTzUra01sV2RnTEJ1RjVnalY5SWliMks1N0QrT3I1N3d0WUdxMytoWndjTjNWbmZ6L09xZHJrb1IyVUJsegovcFAxbDZDOFJBbDhkRlc2Q3NTdS80NFM3eVNocDh6L0xQOURQYWdUUUNFc2dhWHJzTC96QS9uV1hDVnhsOFZPCkQwaFRlc1VuYitWWUd0R3kxRzB2aEVGN1RQWHZ5bSs1aisyNlpsY0NnWUVBb2dCVXVWREhoN0tZd3lJeTFIYnYKQzI3UVhKTkNsUmJVRi8yeWF2U28rOUgrb2RnSVhwczZ3U0FSZU5vWXNrYlN6eGZtYWhQOGRmNGVnWWR2Y1MvWApiOXNPYnB2Wk05N1RsYU8vUXhYcU42RFhCUlVjVkFtbXVNcUlmR1JyTWNQb1lRdFo1eFF5MTNXcFA4WFJCeWpUCmt0QTBzNVZ4YVZmMzV2WHliNng1M0VjQ2dZRUFrcWMrWEJQNll5UmVDQ0UvZDBXVU1DZTdWcDdUVXZvTmo1Ym8Kbk9PYURwRVRmZ1pmcUxHU2ZlQis1VENsS2ljMVR2YkQxM1JrSmpxalo3cjlGVUJ6U25qcWtjdmtYeGFUWDExSwpIeG5zYmI1Q3U5YllMN1Q1WUdhRHd5VDdHK1B3RjllVmRSbElsN292U1J6U2hnNUtwQUZiNGF1ZmU1VzNDaFJZCk92a1ZjQ2tDZ1lCZllGU25DTDlyOWdkWGNXUWNKOWJ4N1krWjhJa2Jmb2JUdjZ4ZnRoenE3TUlQd0ZxQStzWXoKQS9zYU1qWURtczNma01pbjh2aWp1K1U1RDZEWlkyMW1YQ3lzQkRDZGZOdjJyRVVQbTI0MGhld2VLenE1SWVVNgp5NS8yc29DQUdLWnVyY0hQRnd3NHEwMXRrdExBSGM0VUVOY2JGWUJSdW5KR1Y4RHZ0SFFObkE9PQotLS0tLUVORCBSU0EgUFJJVkFURSBLRVktLS0tLQo=")
  CHE_INFRA_KUBERNETES_TLS__CERT = base64decode("LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUZkVENDQkYyZ0F3SUJBZ0lTQkRodHRBSUFkVmdJZ2o1REdYSjA4dS94TUEwR0NTcUdTSWIzRFFFQkN3VUEKTUVveEN6QUpCZ05WQkFZVEFsVlRNUll3RkFZRFZRUUtFdzFNWlhRbmN5QkZibU55ZVhCME1TTXdJUVlEVlFRRApFeHBNWlhRbmN5QkZibU55ZVhCMElFRjFkR2h2Y21sMGVTQllNekFlRncweU1EQXpNRFl3TVRJNE16aGFGdzB5Ck1EQTJNRFF3TVRJNE16aGFNQ294S0RBbUJnTlZCQU1NSHlvdVpXTnNhWEJ6WlMxbGVHRnRjR3hsTG5KbFltVnMKYzI5bWRDNWpiMjB3Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLQW9JQkFRQ3dtNnFYa2xXVApMZ1k2dTVGUjFpRTVwejJTajJrUC9RVzJ1eGJyMm1mRjBBd2JYaWxlZEFzOWlOS1ZKU1o0ZlZoL3VSd09lSG9yCk0zUWU1aEdpeko5UG5rVVNpaHNtM1NMcE1rQWsvN1VSRVRzS3RwUVR5U29UVk9Qa28wdlR3QndkdVNqRmdvZUgKVit6Vy8xaUczeFQ4aWpoK2xsc2N5YXkxWWhUeVNqMldPajRhNmp6d1VlOXRQdGRBQU1KeEJKdlJDaDduamI4OQpXdnhLUHFnNmc0UXNPUEQxcDJsMFNIcWJpeHpKcllXUkNqenp3bm9YMUdiak1aUlJNeHlHZUh5R2FYYXBJZkcvCjNka3pTSTJFOStjc2lMOXFGRzNidlB5MzlXbXdMTWJBcjAwczVtSWN3M3Z1MS9JaVJOZHIwNWR6b3B0NlRsb1YKRGcxWGczbzRQRklSQWdNQkFBR2pnZ0p6TUlJQ2J6QU9CZ05WSFE4QkFmOEVCQU1DQmFBd0hRWURWUjBsQkJZdwpGQVlJS3dZQkJRVUhBd0VHQ0NzR0FRVUZCd01DTUF3R0ExVWRFd0VCL3dRQ01BQXdIUVlEVlIwT0JCWUVGSnhPClA4c0hWL2NpMUsvVDdPT013U3ZlcWUzTk1COEdBMVVkSXdRWU1CYUFGS2hLYW1NRWZkMjY1dEU1dDZaRlplL3oKcU95aE1HOEdDQ3NHQVFVRkJ3RUJCR013WVRBdUJnZ3JCZ0VGQlFjd0FZWWlhSFIwY0RvdkwyOWpjM0F1YVc1MApMWGd6TG14bGRITmxibU55ZVhCMExtOXlaekF2QmdnckJnRUZCUWN3QW9ZamFIUjBjRG92TDJObGNuUXVhVzUwCkxYZ3pMbXhsZEhObGJtTnllWEIwTG05eVp5OHdLZ1lEVlIwUkJDTXdJWUlmS2k1bFkyeHBjSE5sTFdWNFlXMXcKYkdVdWNtVmlaV3h6YjJaMExtTnZiVEJNQmdOVkhTQUVSVEJETUFnR0JtZUJEQUVDQVRBM0Jnc3JCZ0VFQVlMZgpFd0VCQVRBb01DWUdDQ3NHQVFVRkJ3SUJGaHBvZEhSd09pOHZZM0J6TG14bGRITmxibU55ZVhCMExtOXlaekNDCkFRTUdDaXNHQVFRQjFua0NCQUlFZ2ZRRWdmRUE3d0IyQUY2bmMvbmZWc0RudFRaSWZkQko0REo2a1pvTWhLRVMKRW9RWWRaYUJjVVZZQUFBQmNLMnNXV2dBQUFRREFFY3dSUUlnQWpPVXJzdnpUWnZmbWFnSTNWRFlneWdwcFpXSApRQkFvYzQ0dW5QcHBGVjhDSVFEankrc0UzU2RxT2F3Z1F6S3JJMU5BaStpQmMzZVRCSjN4UnI5aURMWGtpUUIxCkFMSWVCY3lMb3MyS0lFNkhadmtydVlvbElHZHIydnB3NTdKSlV5M3ZpNUJlQUFBQmNLMnNXVlFBQUFRREFFWXcKUkFJZ0xiclJSRC9BQko3cDQ5RGp1dlc5MXdmOGxWaGFMdnBkQ0Y2czdTbFoxSDRDSUE0UHpvS1VxSVJkeC9uYwpmTHhnUjk2cUxuYVU1cUR3ZjVNSG9aUFNzMU1CTUEwR0NTcUdTSWIzRFFFQkN3VUFBNElCQVFCQkhrNFVLb0R5ClhSbzBuZWpxVzhQSTI1ejhTVi9Yc1UxWU4rTk9lUFpyWHdhdXpSR25WYnBmU0UxS082L1VaVzJJNDI2UE1SY2kKN0FUdzVCeGY4SXRHQ2EyUW9OVG10MTFHSjAwMnJ6Z3pXTHRvRUZOMGxESFBKSTBEQlVwWUlUNEJET2VXVDJXdwpTeitsQlZZUlBJdmIzV01jRlBla1pEWEdaV2VHTlp6VlRiRUZaZmE3UmFZTzI0MlFkQklPQzZOMmRjZzRUemZoCnRZcGlMZERTaS81MUIwY1doUmZlNmJSckhQZFYzY3VZWTgrdnZTeW10bnFsQ0VwWmN6eTQyQjdqR002Yzd5RVYKQ3puUmcxWjNVTU10WW94V1RyQjR6YmJHNDZGTHlITWhLOEU4TnF2R3BidHd2NG9IbTAwcGY1KzUyN0VCeEdySApJQWo5MEVKQUh0NlcKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQotLS0tLUJFR0lOIENFUlRJRklDQVRFLS0tLS0KTUlJRWtqQ0NBM3FnQXdJQkFnSVFDZ0ZCUWdBQUFWT0ZjMm9MaGV5bkNEQU5CZ2txaGtpRzl3MEJBUXNGQURBLwpNU1F3SWdZRFZRUUtFeHRFYVdkcGRHRnNJRk5wWjI1aGRIVnlaU0JVY25WemRDQkRieTR4RnpBVkJnTlZCQU1UCkRrUlRWQ0JTYjI5MElFTkJJRmd6TUI0WERURTJNRE14TnpFMk5EQTBObG9YRFRJeE1ETXhOekUyTkRBME5sb3cKU2pFTE1Ba0dBMVVFQmhNQ1ZWTXhGakFVQmdOVkJBb1REVXhsZENkeklFVnVZM0o1Y0hReEl6QWhCZ05WQkFNVApHa3hsZENkeklFVnVZM0o1Y0hRZ1FYVjBhRzl5YVhSNUlGZ3pNSUlCSWpBTkJna3Foa2lHOXcwQkFRRUZBQU9DCkFROEFNSUlCQ2dLQ0FRRUFuTk1NOEZybExrZTNjbDAzZzdOb1l6RHExelVtR1NYaHZiNDE4WENTTDdlNFMwRUYKcTZtZU5RaFk3TEVxeEdpSEM2UGpkZVRtODZkaWNicDVnV0FmMTVHYW4vUFFlR2R4eUdrT2xaSFAvdWFaNldBOApTTXgreWsxM0VpU2RSeHRhNjduc0hqY0FISnlzZTZjRjZzNUs2NzFCNVRhWXVjdjliVHlXYU44aktrS1FESVowClo4aC9wWnE0VW1FVUV6OWw2WUtIeTl2NkRsYjJob256aFQrWGhxK3czQnJ2YXcyVkZuM0VLNkJsc3BrRU5uV0EKYTZ4Szh4dVFTWGd2b3BaUEtpQWxLUVRHZE1EUU1jMlBNVGlWRnJxb003aEQ4YkVmd3pCL29ua3hFejB0TnZqagovUEl6YXJrNU1jV3Z4STBOSFdRV002cjZoQ20yMUF2QTJIM0Rrd0lEQVFBQm80SUJmVENDQVhrd0VnWURWUjBUCkFRSC9CQWd3QmdFQi93SUJBREFPQmdOVkhROEJBZjhFQkFNQ0FZWXdmd1lJS3dZQkJRVUhBUUVFY3pCeE1ESUcKQ0NzR0FRVUZCekFCaGlab2RIUndPaTh2YVhOeVp5NTBjblZ6ZEdsa0xtOWpjM0F1YVdSbGJuUnlkWE4wTG1OdgpiVEE3QmdnckJnRUZCUWN3QW9ZdmFIUjBjRG92TDJGd2NITXVhV1JsYm5SeWRYTjBMbU52YlM5eWIyOTBjeTlrCmMzUnliMjkwWTJGNE15NXdOMk13SHdZRFZSMGpCQmd3Rm9BVXhLZXhwSHNzY2ZyYjRVdVFkZi9FRldDRmlSQXcKVkFZRFZSMGdCRTB3U3pBSUJnWm5nUXdCQWdFd1B3WUxLd1lCQkFHQzN4TUJBUUV3TURBdUJnZ3JCZ0VGQlFjQwpBUllpYUhSMGNEb3ZMMk53Y3k1eWIyOTBMWGd4TG14bGRITmxibU55ZVhCMExtOXlaekE4QmdOVkhSOEVOVEF6Ck1ER2dMNkF0aGl0b2RIUndPaTh2WTNKc0xtbGtaVzUwY25WemRDNWpiMjB2UkZOVVVrOVBWRU5CV0RORFVrd3UKWTNKc01CMEdBMVVkRGdRV0JCU29TbXBqQkgzZHV1YlJPYmVtUldYdjg2anNvVEFOQmdrcWhraUc5dzBCQVFzRgpBQU9DQVFFQTNUUFhFZk5qV0RqZEdCWDdDVlcrZGxhNWNFaWxhVWNuZThJa0NKTHhXaDlLRWlrM0pIUlJIR0pvCnVNMlZjR2ZsOTZTOFRpaFJ6WnZvcm9lZDZ0aTZXcUVCbXR6dzNXb2RhdGcrVnlPZXBoNEVZcHIvMXdYS3R4OC8Kd0FwSXZKU3d0bVZpNE1GVTVhTXFyU0RFNmVhNzNNajJ0Y015bzVqTWQ2am1lV1VISzhzby9qb1dVb0hPVWd3dQpYNFBvMVFZeiszZHN6a0RxTXA0ZmtseEJ3WFJzVzEwS1h6UE1UWitzT1BBdmV5eGluZG1qa1c4bEd5K1FzUmxHClBmWitHNlo2aDdtamVtMFkraVdsa1ljVjRQSVdMMWl3Qmk4c2FDYkdTNWpOMnA4TStYK1E3VU5LRWtST2IzTjYKS09xa3FtNTdUSDJIM2VESkFrU25oNi9ETkZ1MFFnPT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=")
}

module "devfile-registry" {
  source    = "../../modules/eclipse-che/devfile-registry"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  image     = "registry.rebelsoft.com/devfile-registry:latest"
}

module "plugin-registry" {
  source    = "../../modules/eclipse-che/plugin-registry"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  image     = "registry.rebelsoft.com/plugin-registry:latest"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "wildcard" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"    = "nginx"
      "cert-manager.io/cluster-issuer" = "letsencrypt-prod-dns"
    }
    name      = "${var.name}-wildcard"
    namespace = "default"
  }
  spec {
    rules {
      host = "*.eclipse-example.rebelsoft.com"
    }

    tls {
      hosts = [
        "*.eclipse-example.rebelsoft.com",
      ]
      secret_name = "${var.name}-${var.namespace}-wildcard-tls"
    }
  }
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "che" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                       = "nginx"
      "nginx.ingress.kubernetes.io/proxy-connect-timeout" = "3600"
      "nginx.ingress.kubernetes.io/proxy-read-timeout"    = "3600"
      "nginx.ingress.kubernetes.io/ssl-redirect"          = "false"
      "cert-manager.io/cluster-issuer" = "letsencrypt-prod"
    }
    name      = var.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "che.eclipse-example.rebelsoft.com"
      http {
        paths {
          backend {
            service_name = module.eclipse-che.service.metadata[0].name
            service_port = module.eclipse-che.service.spec[0].ports[0].port
          }
          path = "/"
        }
      }
    }

    tls {
      hosts = [
        "che.eclipse-example.rebelsoft.com",
      ]
      secret_name = "${var.name}-tls"
    }
  }
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "devfile-registry" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                       = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"          = "devfile-registry.*",
      "nginx.ingress.kubernetes.io/proxy-connect-timeout" = "3600"
      "nginx.ingress.kubernetes.io/proxy-read-timeout"    = "3600"
      "nginx.ingress.kubernetes.io/ssl-redirect"          = "false"
      "cert-manager.io/cluster-issuer"                    = "letsencrypt-prod"
    }
    name      = module.devfile-registry.service.metadata[0].name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "devfile-registry.rebelsoft.com"
      http {
        paths {
          backend {
            service_name = module.devfile-registry.service.metadata[0].name
            service_port = module.devfile-registry.service.spec[0].ports[0].port
          }
          path = "/"
        }
      }
    }

    tls {
      hosts = [
        "devfile-registry.rebelsoft.com"
      ]
      secret_name = "${var.name}-devfile-registry-tls"
    }

  }
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "plugin-registry" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                       = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"          = "plugin-registry.*",
      "nginx.ingress.kubernetes.io/proxy-connect-timeout" = "3600"
      "nginx.ingress.kubernetes.io/proxy-read-timeout"    = "3600"
      "nginx.ingress.kubernetes.io/ssl-redirect"          = "false"
      "cert-manager.io/cluster-issuer"                    = "letsencrypt-prod"
    }
    name      = module.plugin-registry.service.metadata[0].name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "plugin-registry.rebelsoft.com"
      http {
        paths {
          backend {
            service_name = module.plugin-registry.service.metadata[0].name
            service_port = module.plugin-registry.service.spec[0].ports[0].port
          }
          path = "/"
        }
      }
    }

    tls {
      hosts = [
        "plugin-registry.rebelsoft.com"
      ]
      secret_name = "${var.name}-plugin-registry-tls"
    }
  }
}