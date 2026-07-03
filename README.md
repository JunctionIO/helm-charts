# Junction Helm Charts

Helm charts for deploying [Junction](https://github.com/JunctionIO), a webhook/event routing platform.

## Charts

- [`junction`](charts/junction) — the full self-hosted deployment: API, CLI (migration/keygen Jobs), HTTP destination worker, system worker, and Postgres/RabbitMQ (via Bitnami subcharts).

## Dev Environment

Requires [Nix](https://nixos.org/download/) and [devenv](https://devenv.sh/getting-started/).

```bash
devenv shell
helm dependency update charts/junction
helm lint charts/junction
helm template charts/junction --set secrets.app.jwtSecret=x --set secrets.worker.token=x
```

## Publishing

Pushing a tag matching `[0-9]*` (e.g. `0.1.0`) packages `charts/junction` and pushes it as an OCI artifact to `oci://ghcr.io/junctionio/charts/junction`. See `.github/workflows/publish.yml`.
