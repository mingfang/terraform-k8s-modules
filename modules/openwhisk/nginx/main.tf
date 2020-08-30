module "nginx" {
  source       = "../../nginx"
  name         = var.name
  namespace    = var.namespace
  ports        = var.ports

  nginx-conf = <<-EOF
      worker_rlimit_nofile 4096;

      events {
        worker_connections  4096;
      }

      http {
        client_max_body_size 50M;

        rewrite_log on;
        # change log format to display the upstream information
        log_format combined-upstream '$remote_addr - $remote_user [$time_local] '
            '[#tid_$request_id] $request $status $body_bytes_sent '
            '$http_referer $http_user_agent $upstream_addr';
        access_log /dev/stdout combined-upstream;
        error_log /dev/stderr error;

        # needed to enable keepalive to upstream controllers
        proxy_http_version 1.1;
        proxy_set_header Connection "";

        server {
          listen 80;

          # match namespace, note while OpenWhisk allows a richer character set for a
          # namespace, not all those characters are permitted in the (sub)domain name;
          # if namespace does not match, no vanity URL rewriting takes place.
          server_name ~^(?<namespace>[0-9a-zA-Z-]+)\.$;

          location /api/v1/web {
              if ($namespace) {
                  rewrite    /(.*) /api/v1/web/$${namespace}/$1 break;
              }
              proxy_pass http://${var.controller_fqdn}:8080;
              proxy_read_timeout 75s; # 70+5 additional seconds to allow controller to terminate request
          }

          location /api/v1 {
              proxy_pass http://${var.controller_fqdn}:8080;
              proxy_read_timeout 75s; # 70+5 additional seconds to allow controller to terminate request
          }

          location /api {
              proxy_pass http://${var.apigateway_fqdn}:8080;
          }

          location /v1/health-check {
              proxy_pass http://${var.apigateway_fqdn}:9000;
          }

          location /v2 {
              proxy_pass http://${var.apigateway_fqdn}:9000;
          }


          location / {
              if ($namespace) {
                rewrite    /(.*) /api/v1/web/$${namespace}/$1 break;
              }
              proxy_pass http://${var.controller_fqdn}:8080;
              proxy_read_timeout 75s; # 70+5 additional seconds to allow controller to terminate request
          }

          location /blackbox.tar.gz {
              return 301 https://github.com/apache/openwhisk-runtime-docker/releases/download/sdk%400.1.0/blackbox-0.1.0.tar.gz;
          }
          # leaving this for a while for clients out there to update to the new endpoint
          location /blackbox-0.1.0.tar.gz {
              return 301 /blackbox.tar.gz;
          }

          location /OpenWhiskIOSStarterApp.zip {
              return 301 https://github.com/openwhisk/openwhisk-client-swift/releases/download/0.2.3/starterapp-0.2.3.zip;
          }

          # redirect requests for specific binaries to the matching one from the latest openwhisk-cli release.
          location /cli/go/download/linux/amd64 {
              return 301 https://github.com/apache/openwhisk-cli/releases/download/latest/OpenWhisk_CLI-latest-linux-amd64.tgz;
          }
          location /cli/go/download/linux/386 {
              return 301 https://github.com/apache/openwhisk-cli/releases/download/latest/OpenWhisk_CLI-latest-linux-386.tgz;
          }
          location /cli/go/download/mac/amd64 {
              return 301 https://github.com/apache/openwhisk-cli/releases/download/latest/OpenWhisk_CLI-latest-mac-amd64.zip;
          }
          location /cli/go/download/mac/386 {
              return 301 https://github.com/apache/openwhisk-cli/releases/download/latest/OpenWhisk_CLI-latest-mac-386.zip;
          }
          location /cli/go/download/windows/amd64 {
              return 301 https://github.com/apache/openwhisk-cli/releases/download/latest/OpenWhisk_CLI-latest-windows-amd64.zip;
          }
          location /cli/go/download/windows/386 {
              return 301 https://github.com/apache/openwhisk-cli/releases/download/latest/OpenWhisk_CLI-latest-windows-386.zip;
          }

          # redirect top-level cli downloads to the latest openwhisk-cli release.
          location /cli/go/download {
              return 301 https://github.com/apache/openwhisk-cli/releases/latest;
          }
        }
      }
    EOF
}
