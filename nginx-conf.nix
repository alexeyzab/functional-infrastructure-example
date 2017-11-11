{ nodes, config, hostname }:
''
upstream frontend {
  server ${nodes.frontend.config.networking.privateIPv4}:80;
}

upstream backend {
  server ${nodes.backend.config.networking.privateIPv4}:3000;
  server ${nodes.backend2.config.networking.privateIPv4}:3000;
  server ${nodes.backend3.config.networking.privateIPv4}:3000;
}

server {
  listen 80;
  listen [::]:80;
  server_name ${hostname};
  server_tokens off;

  location /.well-known/acme-challenge {
    root /var/www/challenges;
  }

  location / {
    return 301 https://$host$request_uri;
  }
}

server {
  listen 443 ssl;
  server_name ${hostname};
  server_tokens off;

  gzip on;
  gzip_vary on;
  gzip_types text/plain text/css application/json application/x-javascript
             text/xml application/xml application/xml+rss text/javascript;

  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_ciphers 'EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH';
  ssl_prefer_server_ciphers on;

  ssl_certificate
    ${config.security.acme.directory}/${hostname}/fullchain.pem;

  ssl_certificate_key
    ${config.security.acme.directory}/${hostname}/key.pem;

  access_log /var/log/nginx-access.log;

  location /api {
    rewrite /api$ /api/ redirect;
    rewrite /api/(.*) /$1 break;
    proxy_pass http://backend;
  }

  location / {
    proxy_pass http://frontend;
  }
}
''
