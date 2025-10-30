############################################
# Builder stage: install deps and build site
############################################
FROM python:3.11-slim AS builder

WORKDIR /site

# Install build dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy source and build static site
COPY . .
RUN mkdocs build --strict

############################################
# Runtime stage: serve static site via Nginx
############################################
FROM nginx:alpine AS runtime

# Copy built site to Nginx html directory
COPY --from=builder /site/site /usr/share/nginx/html

EXPOSE 80

# Optional: healthcheck (Nginx default index)
HEALTHCHECK CMD wget -qO- http://localhost/ >/dev/null 2>&1 || exit 1

# Start Nginx (default CMD provided by base image)
