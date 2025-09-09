#!/bin/bash

# Run Now Script - Execute everything
echo "🚀 Running Genera Atende SaaS setup now..."

# Ensure bashrc is sourced for rbenv/go paths if present
if [ -f "$HOME/.bashrc" ]; then
  source "$HOME/.bashrc"
fi

# Initialize rbenv if available
if command -v rbenv >/dev/null 2>&1; then
  eval "$(rbenv init - bash)"
  rbenv global 3.2.0 || true
  rbenv rehash || true
fi

# Force PATH to use Linux executables (avoid Windows paths in WSL)
export PATH="/usr/local/go/bin:${GOPATH:+$GOPATH/bin:}$HOME/.rbenv/shims:/usr/local/bin:/usr/bin:/bin"

# Show which executables will be used
echo "🔍 Binaries in use:"
echo "   - ruby: $(command -v ruby)"
echo "   - rails: $(command -v rails || echo 'not found')"
echo "   - node: $(command -v node)"
echo "   - pnpm: $(command -v pnpm || echo 'not found')"
echo "   - overmind: $(command -v overmind || echo 'not found')"

# Ensure pnpm via corepack (Node >=16)
if ! command -v pnpm >/dev/null 2>&1; then
  if command -v corepack >/dev/null 2>&1; then
    echo "📦 Enabling pnpm via corepack..."
    corepack enable || true
    corepack prepare pnpm@10.2.0 --activate || true
  else
    echo "⚠️ corepack not found; attempting npm -g pnpm (may need sudo)"
    npm install -g pnpm || true
  fi
fi

echo "📦 Installing dependencies..."
bundle install
pnpm install || true

echo "🗄️ Running migrations..."
bundle exec rails db:migrate

echo "🌱 Seeding database..."
bundle exec rails db:seed || true

echo "✅ Setup completed!"

echo "🚀 Starting development server..."
if command -v overmind >/dev/null 2>&1; then
  overmind start -f ./Procfile.dev | cat
else
  if command -v foreman >/dev/null 2>&1; then
    foreman start -f Procfile.dev | cat
  else
    echo "⚠️ overmind/foreman indisponíveis. Iniciando rails + vite diretamente."
    (bundle exec rails server -p 3000 -b 0.0.0.0 &) 
    (pnpm vite --host 0.0.0.0 --port 3036 &)
    wait
  fi
fi