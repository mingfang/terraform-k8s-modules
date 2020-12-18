resource "k8s_core_v1_config_map" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  data = {
    "nginx.conf.template" = var.nginx_conf_template != null ? var.nginx_conf_template : <<-EOF
      server {
        listen ${var.ports[0].port};
        client_max_body_size 10m;
        gzip on;
        root /var/www/appsmith;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Host $host;
        location / {
            try_files $uri /index.html =404;
            alias /var/www/appsmith/;
            sub_filter __APPSMITH_SENTRY_DSN__ '${var.APPSMITH_SENTRY_DSN}';
            sub_filter __APPSMITH_SMART_LOOK_ID__ '${var.APPSMITH_SMART_LOOK_ID}';
            sub_filter __APPSMITH_OAUTH2_GOOGLE_CLIENT_ID__ '${var.APPSMITH_OAUTH2_GOOGLE_CLIENT_ID}';
            sub_filter __APPSMITH_OAUTH2_GITHUB_CLIENT_ID__ '${var.APPSMITH_OAUTH2_GITHUB_CLIENT_ID}';
            sub_filter __APPSMITH_MARKETPLACE_ENABLED__ '${var.APPSMITH_MARKETPLACE_ENABLED}';
            sub_filter __APPSMITH_SEGMENT_KEY__ '${var.APPSMITH_SEGMENT_KEY}';
            sub_filter __APPSMITH_OPTIMIZELY_KEY__ '${var.APPSMITH_OPTIMIZELY_KEY}';
            sub_filter __APPSMITH_ALGOLIA_API_ID__ '${var.APPSMITH_ALGOLIA_API_ID}';
            sub_filter __APPSMITH_ALGOLIA_SEARCH_INDEX_NAME__ '${var.APPSMITH_ALGOLIA_SEARCH_INDEX_NAME}';
            sub_filter __APPSMITH_ALGOLIA_API_KEY__ '${var.APPSMITH_ALGOLIA_API_KEY}';
            sub_filter __APPSMITH_CLIENT_LOG_LEVEL__ '${var.APPSMITH_CLIENT_LOG_LEVEL}';
            sub_filter __APPSMITH_GOOGLE_MAPS_API_KEY__ '${var.APPSMITH_GOOGLE_MAPS_API_KEY}';
            sub_filter __APPSMITH_TNC_PP__ '${var.APPSMITH_TNC_PP}';
            sub_filter __APPSMITH_VERSION_ID__ '${var.APPSMITH_VERSION_ID}';
            sub_filter __APPSMITH_VERSION_RELEASE_DATE__ '${var.APPSMITH_VERSION_RELEASE_DATE}';
            sub_filter __APPSMITH_INTERCOM_APP_ID__ '${var.APPSMITH_INTERCOM_APP_ID}';
            sub_filter __APPSMITH_MAIL_ENABLED__ '${var.APPSMITH_MAIL_ENABLED}';
            sub_filter __APPSMITH_DISABLE_TELEMETRY__ '${var.APPSMITH_DISABLE_TELEMETRY}';
        }

        location /f {
           proxy_pass https://cdn.optimizely.com/;
        }
      }
    EOF
  }
}