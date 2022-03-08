To create *element-config.json* use: <a href="https://develop.element.io/config.json">example file</a>, 
remove `"default_server_name": "matrix.org"` (*deprecated*),  
add custom homeserver block to the top of file:  
*(skip this step, file already exists)*
```
    "default_server_config": {
        "m.homeserver": {
            "base_url": "https://matrix.example.com",
            "server_name": "matrix.example.com"
        },
        "m.identity_server": {
            "base_url": "https://vector.im"
        }
    },
```
  
*element-config.json*  
```
{
    "default_server_config": {
        "m.homeserver": {
            "base_url": "https://matrix.example.com",
            "server_name": "matrix.example.com"
        },
        "m.identity_server": {
            "base_url": "https://vector.im"
        }
    },
    "brand": "Element",
    "integrations_ui_url": "https://scalar.vector.im/",
    "integrations_rest_url": "https://scalar.vector.im/api",
    "integrations_widgets_urls": [
        "https://scalar.vector.im/_matrix/integrations/v1",
        "https://scalar.vector.im/api",
        "https://scalar-staging.vector.im/_matrix/integrations/v1",
        "https://scalar-staging.vector.im/api",
        "https://scalar-staging.riot.im/scalar/api"
    ],
    "hosting_signup_link": "https://element.io/matrix-services?utm_source=element-web&utm_medium=web",
    "bug_report_endpoint_url": "https://element.io/bugreports/submit",
    "uisi_autorageshake_app": "element-auto-uisi",
    "showLabsSettings": true,
    "piwik": {
        "url": "https://piwik.riot.im/",
        "siteId": 1,
        "policyUrl": "https://element.io/cookie-policy"
    },
    "roomDirectory": {
        "servers": [
            "matrix.org",
            "gitter.im",
            "libera.chat"
        ]
    },
    "enable_presence_by_hs_url": {
        "https://matrix.org": false,
        "https://matrix-client.matrix.org": false
    },
    "terms_and_conditions_links": [
        {
            "url": "https://element.io/privacy",
            "text": "Privacy Policy"
        },
        {
            "url": "https://element.io/cookie-policy",
            "text": "Cookie Policy"
        }
    ],
    "hostSignup": {
      "brand": "Element Home",
      "cookiePolicyUrl": "https://element.io/cookie-policy",
      "domains": [
          "matrix.org"
      ],
      "privacyPolicyUrl": "https://element.io/privacy",
      "termsOfServiceUrl": "https://element.io/terms-of-service",
      "url": "https://ems.element.io/element-home/in-app-loader"
    },
    "sentry": {
        "dsn": "https://029a0eb289f942508ae0fb17935bd8c5@sentry.matrix.org/6",
        "environment": "develop"
    },
    "posthog": {
        "projectApiKey": "phc_Jzsm6DTm6V2705zeU5dcNvQDlonOR68XvX2sh1sEOHO",
        "apiHost": "https://posthog.hss.element.io"
    },
    "features": {
        "feature_spotlight": true
    },
    "map_style_url": "https://api.maptiler.com/maps/streets/style.json?key=fU3vlMsMn4Jb6dnEIFsx"
}
```

nginx/matrix.conf
```
server {
  listen         80 default_server;
  server_name    matrix.example.com;

 # Traefik -> nginx -> synapse
 location /_matrix {
    proxy_pass http://<MATRIX-SERVER-IP>:MATRIX-SERVER-PORT;
    proxy_set_header X-Forwarded-For $remote_addr;
    client_max_body_size 128m;
  }

  location /.well-known/matrix/ {
    root /var/www/;
    default_type application/json;
    add_header Access-Control-Allow-Origin  *;
  }
}
```

nginx/www/.well-known/matrix/server
```
{
  "m.server": "matrix.example.com:443"
}
```

nginx/www/.well-known/matrix/client
```
{
  "m.homeserver": {
    "base_url": "https://matrix.example.com"
  }
}
```
