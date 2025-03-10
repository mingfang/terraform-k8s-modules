resource "k8s_core_v1_config_map" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  data = {
    "nginx.conf"   = <<-EOF
      user  nginx;
      worker_processes  1;

      error_log  /var/log/nginx/error.log warn;
      pid        /var/run/nginx.pid;


      events {
          worker_connections  1024;
      }


      http {
          include       /etc/nginx/mime.types;
          default_type  application/octet-stream;

          log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                            '$status $body_bytes_sent "$http_referer" '
                            '"$http_user_agent" "$http_x_forwarded_for"';

          access_log  /var/log/nginx/access.log  main;

          sendfile        on;
          #tcp_nopush     on;

          keepalive_timeout  65;
          fastcgi_read_timeout 1d;
          proxy_read_timeout 1d;

          #gzip  on;

          include /etc/nginx/conf.d/*.conf;
      }
      EOF
    "default.conf" = <<-EOF
      server {
          listen       80;
          server_name  localhost;

          location /api {
            proxy_pass ${var.api};
            proxy_http_version 1.1;
            proxy_set_header Host $http_host;
            proxy_set_header X-scheme $scheme;
            proxy_set_header X-request-uri $request_uri;
            proxy_set_header X-real-ip $remote_addr;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            rewrite ^/api(.*)$ $1 break;
          }

          location / {
            proxy_pass ${var.ui};
            proxy_set_header Host $http_host;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Real-IP $remote_addr;
          }
      }
      EOF
  }
}
