# Adding a New Project to Traefik

The container name in step 2 follows Docker Compose's default naming: `<project-folder>-nginx-1`.

## 1. Add the domain to the cert

Add the domain to `certs/domains.txt`, then run:

```bash
cd ~/path/to/traefik && ./regen-cert.sh
```

Then restart Traefik to pick up the new cert:

```bash
cd ~/path/to/traefik && docker compose restart
```

## 2. Add a router file

Create `~/path/to/traefik/dynamic/newproject.yml`:

```yaml
http:
  routers:
    newproject:
      rule: "Host(`newproject.test`)"
      tls: {}
      service: newproject
      entryPoints:
        - websecure

  services:
    newproject:
      loadBalancer:
        servers:
          - url: "http://newproject-nginx-1:80"
```

Traefik hot-reloads this instantly — no restart needed.

## 3. Update the project's docker-compose.yml

Join the `proxy` network and remove any exposed port 80 from nginx:

```yaml
nginx:
  networks:
    - proxy
    - default

networks:
  proxy:
    external: true
```

## 4. Add to /etc/hosts

```
127.0.0.1 newproject.test
```
