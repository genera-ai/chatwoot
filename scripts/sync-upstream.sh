#!/bin/bash

# Script para sincronizar com o repositório upstream do Chatwoot
# Uso: ./scripts/sync-upstream.sh

set -e

echo "🔄 Iniciando sincronização com upstream..."

# Verificar se estamos na branch develop
current_branch=$(git branch --show-current)
if [ "$current_branch" != "develop" ]; then
    echo "❌ Por favor, mude para a branch develop primeiro"
    echo "git checkout develop"
    exit 1
fi

# Verificar se há mudanças não commitadas
if ! git diff-index --quiet HEAD --; then
    echo "❌ Há mudanças não commitadas. Por favor, faça commit ou stash primeiro"
    exit 1
fi

# Buscar atualizações do upstream
echo "📥 Buscando atualizações do upstream..."
git fetch upstream

# Verificar se há atualizações
behind=$(git rev-list --count HEAD..upstream/develop)
if [ "$behind" -eq 0 ]; then
    echo "✅ Já está atualizado com o upstream"
    exit 0
fi

echo "📊 Encontradas $behind commits novos no upstream"

# Criar branch para sincronização
sync_branch="sync/upstream-$(date +%Y%m%d-%H%M%S)"
echo "🌿 Criando branch: $sync_branch"
git checkout -b "$sync_branch"

# Fazer merge com upstream
echo "🔀 Fazendo merge com upstream/develop..."
git merge upstream/develop

# Verificar se há conflitos
if [ $? -ne 0 ]; then
    echo "❌ Houve conflitos durante o merge. Resolva manualmente e continue"
    echo "git add . && git commit"
    exit 1
fi

# Executar testes
echo "🧪 Executando testes..."
if command -v bundle &> /dev/null; then
    echo "Executando testes Ruby..."
    bundle exec rspec --fail-fast
fi

if command -v pnpm &> /dev/null; then
    echo "Executando testes JavaScript..."
    pnpm test
fi

# Fazer push da branch
echo "📤 Fazendo push da branch..."
git push origin "$sync_branch"

# Criar PR
echo "📝 Criando Pull Request..."
gh pr create --head "$sync_branch" --base develop --title "sync: update develop with upstream Chatwoot changes" --body "## Sincronização com Upstream

Este PR sincroniza a branch \`develop\` com as últimas mudanças do repositório original do Chatwoot.

### Principais mudanças:
- $(git log --oneline upstream/develop..HEAD | head -5 | sed 's/^/- /')

### Arquivos modificados:
- $(git diff --stat upstream/develop..HEAD | tail -1)

### Testes:
- [x] Testes Ruby executados
- [x] Testes JavaScript executados
- [x] Linting verificado

Esta sincronização mantém o projeto atualizado com as últimas funcionalidades e correções de segurança do Chatwoot original."

echo "✅ Sincronização concluída!"
echo "🔗 PR criado: $(gh pr view --json url --jq .url)"
echo ""
echo "Próximos passos:"
echo "1. Revisar o PR no GitHub"
echo "2. Aprovar e fazer merge"
echo "3. Atualizar documentação se necessário"
