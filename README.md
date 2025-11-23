**Lazcar — Car Website**

A Ruby on Rails web application (repository: `car-website`) serving as the codebase for the Lazcar platform.
This document explains how to get the app running locally, run tests and linters, and deploy or contribute to the project.

**Quick Summary**
- **Language & framework:** Ruby on Rails
- **Repository:** `car-website` (owner: `devmuturi`)
- **Purpose:** Rails web app powering the Lazcar site (frontend, backend, jobs, and background processing)

**Prerequisites**
- **Ruby:** Use the project's Ruby version (see `Gemfile` / `.ruby-version`).
- **Bundler:** `gem install bundler`
- **Node & Yarn / npm:** JavaScript build tools required (see `package.json`).
- **Database:** The DB is configured in `config/database.yml` (e.g., PostgreSQL, MySQL, or SQLite depending on environment).
- **Redis / Sidekiq (optional):** If background jobs are used, ensure Redis is available.

**Local development - Setup**
1. Install Ruby gems and JavaScript packages:
```bash
bundle install
yarn install # or `npm install` if you use npm
```
2. Configure environment variables.
- Copy the example env file or create your own: `cp .env.example .env` (if present).
- Secrets and credentials are stored in `config/credentials.yml.enc`. Edit with:
```bash
EDITOR="nano" bin/rails credentials:edit
```
3. Create and prepare the database:
```bash
bin/rails db:create db:migrate db:seed
```
4. Run the asset build process (if using the default Rails asset pipeline / webpacker / jsbundling):
```bash
bin/rails assets:precompile # or your JS build command (e.g. `bin/webpack`)
```

**Start the app (development)**
- Using the Rails server:
```bash
bin/rails server
```
- Using the development Procfile (recommended for multi-process setups):
```bash
# Uses Foreman/Overmind to run web + worker processes
bundle exec foreman start -f Procfile.dev
```

**Docker**
- Build the image (uses the repository `Dockerfile`):
```bash
docker build -t lazcar:dev .
```
- Run with the required env vars and ports exposed:
```bash
docker run --env-file .env -p 3000:3000 lazcar:dev
```
Adjust the commands for your CI/CD or orchestration tooling.

**Running tests & quality checks**
- Run the Rails test suite (Minitest) or RSpec if configured:
```bash
bin/rails test         # Minitest
# or
bundle exec rspec      # if the project uses RSpec and has a `spec/` dir
```
- Run linters/security checks:
```bash
bundle exec rubocop
bundle exec brakeman -A
```

**Common maintenance tasks**
- To edit credentials securely: `bin/rails credentials:edit`.
- Reset the database (destructive): `bin/rails db:drop db:create db:migrate db:seed`.
- Run background jobs locally (Sidekiq):
```bash
bundle exec sidekiq
```

**Deployment**
- The project includes a `Procfile` and `config/puma.rb` for process management and server configuration. Adjust these for your host (Heroku, Dokku, Capistrano, Docker, or Kubernetes).
- Ensure environment variables and `RAILS_MASTER_KEY` (or `credentials`) are available in the target environment.

**Useful files & locations**
- `config/database.yml` — database configuration
- `config/puma.rb` — Puma web server configuration
- `Procfile` / `Procfile.dev` — process definitions for production/dev
- `config/credentials.yml.enc` — encrypted credentials (edit with `bin/rails credentials:edit`)
- `app/` — core application code (controllers, models, views, components)
- `test/` or `spec/` — test suites

**Contributing**
- Fork the repo and send pull requests against `main`.
- Follow existing code style and run linters before opening a PR:
```bash
bundle exec rubocop
bundle exec brakeman -A
```
- Include tests and update documentation when adding features.

**Troubleshooting**
- If migrations fail, inspect `db/schema.rb` and your migration files for issues.
- If assets fail to compile, verify Node/Yarn versions and check `package.json` scripts.
- If credentials are missing in CI, set `RAILS_MASTER_KEY` or supply `credentials.yml.enc` appropriately.

**License & Contact**
- Add a `LICENSE` file to specify the project license.
- For questions, contact the repository owner or maintainers (see repository settings).

If you want, I can:
- Add a `CONTRIBUTING.md` and `CHANGELOG.md` template.
- Add a short architecture diagram or a summary of key services used.

--
Drafter: GitHub Copilot (assisting)
