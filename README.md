# Remembeer

So that you may never forget how many beers you have consumed.

## Environment

Copy the tracked client template to its untracked counterpart:

```bash
cp .env.client.example .env.client
```

`.env.client` contains client-safe configuration bundled into the Flutter app.
Never put backend secrets in it; users can extract Flutter assets from the
application package.
