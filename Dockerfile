# Multi-stage Dockerfile for Professional Muslim Web App

# Stage 1: Build Flutter Web App
FROM cirrusci/flutter:3.16.0 AS flutter-builder

WORKDIR /app

# Copy Flutter project files
COPY pubspec.yaml pubspec.lock ./
COPY lib/ lib/
COPY web/ web/
COPY assets/ assets/

# Get Flutter dependencies
RUN flutter pub get

# Enable web support and build
RUN flutter config --enable-web
RUN flutter build web --release --web-renderer html --base-href /

# Stage 2: Build Standalone Web Version
FROM node:18-alpine AS web-builder

WORKDIR /web

# Copy web version files
COPY web_version/package*.json ./
RUN npm ci --only=production

COPY web_version/ ./
RUN npm run build 2>/dev/null || echo "Build script not found, skipping..."

# Stage 3: Production Image
FROM nginx:alpine

# Install additional tools
RUN apk add --no-cache \
    curl \
    jq \
    tzdata

# Set timezone to UTC (can be overridden)
ENV TZ=UTC

# Copy custom nginx configuration
COPY <<EOF /etc/nginx/conf.d/default.conf
server {
    listen 80;
    server_name localhost;
    root /usr/share/nginx/html;
    index index.html;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval' https://cdn.jsdelivr.net https://cdnjs.cloudflare.com https://fonts.googleapis.com; style-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net https://cdnjs.cloudflare.com https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com https://cdnjs.cloudflare.com; img-src 'self' data: https:; connect-src 'self' https:; manifest-src 'self';" always;

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/javascript
        application/xml+rss
        application/json
        application/manifest+json;

    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Cache manifest files
    location ~* \.(json|xml)$ {
        expires 1d;
        add_header Cache-Control "public";
    }

    # Service worker should not be cached
    location /sw.js {
        expires -1;
        add_header Cache-Control "no-cache, no-store, must-revalidate";
    }

    # Handle SPA routing
    location / {
        try_files \$uri \$uri/ /index.html;
    }

    # Health check endpoint
    location /health {
        access_log off;
        return 200 "healthy\n";
        add_header Content-Type text/plain;
    }

    # API proxy (if needed)
    location /api/ {
        proxy_pass http://backend:3000/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Copy Flutter web build
COPY --from=flutter-builder /app/build/web /usr/share/nginx/html

# Copy standalone web version to subdirectory
COPY --from=web-builder /web /usr/share/nginx/html/standalone

# Create a startup script
COPY <<EOF /docker-entrypoint.sh
#!/bin/sh
set -e

echo "🕌 Starting Professional Muslim Web App..."
echo "Flutter Web: http://localhost"
echo "Standalone Web: http://localhost/standalone"

# Replace environment variables in JavaScript files if needed
if [ -n "\$API_URL" ]; then
    find /usr/share/nginx/html -name "*.js" -exec sed -i "s|API_URL_PLACEHOLDER|\$API_URL|g" {} \;
fi

if [ -n "\$APP_ENV" ]; then
    find /usr/share/nginx/html -name "*.js" -exec sed -i "s|APP_ENV_PLACEHOLDER|\$APP_ENV|g" {} \;
fi

# Start nginx
exec nginx -g 'daemon off;'
EOF

RUN chmod +x /docker-entrypoint.sh

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/health || exit 1

# Expose port
EXPOSE 80

# Set labels
LABEL maintainer="Ahmed Mostafa Ibrahim <gogom8870@gmail.com>"
LABEL description="Professional Muslim Web App - Islamic Azkar and Prayer Times"
LABEL version="1.0.0"

# Start the application
ENTRYPOINT ["/docker-entrypoint.sh"]
