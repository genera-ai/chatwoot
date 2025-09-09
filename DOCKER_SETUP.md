# 🐳 Docker Setup para Genera Atende SaaS

## Configuração Docker para Desenvolvimento

Este projeto inclui configuração Docker para facilitar o desenvolvimento local com PostgreSQL e Redis.

## 📋 Pré-requisitos

- Ubuntu 22.04 (ou similar)
- Docker e Docker Compose
- Git

## 🚀 Setup Rápido

### **1. Verificar/Instalar Docker**
```bash
# Verificar se Docker está instalado e instalar se necessário
chmod +x bin/check_docker.sh
./bin/check_docker.sh
```

### **2. Executar Setup Completo**
```bash
# Setup completo com Docker
chmod +x bin/setup_genera_atende
./bin/setup_genera_atende
```

## 🐳 Gerenciamento de Containers

### **Comandos Disponíveis**
```bash
# Iniciar containers
./bin/docker_dev.sh start

# Parar containers
./bin/docker_dev.sh stop

# Reiniciar containers
./bin/docker_dev.sh restart

# Ver status dos containers
./bin/docker_dev.sh status

# Ver logs dos containers
./bin/docker_dev.sh logs

# Limpar containers e volumes
./bin/docker_dev.sh cleanup
```

## 📊 Serviços Incluídos

### **PostgreSQL 15**
- **Container**: `genera_atende_postgres`
- **Porta**: `5432`
- **Database**: `chatwoot_development`
- **Usuário**: `postgres`
- **Senha**: `postgres`

### **Redis 7**
- **Container**: `genera_atende_redis`
- **Porta**: `6379`
- **URL**: `redis://localhost:6379`

## 🔧 Configuração

### **Arquivo docker-compose.dev.yml**
```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15
    container_name: genera_atende_postgres
    environment:
      POSTGRES_DB: chatwoot_development
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - genera_atende_network

  redis:
    image: redis:7-alpine
    container_name: genera_atende_redis
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    networks:
      - genera_atende_network
```

### **Variáveis de Ambiente**
O arquivo `.env.development` contém as configurações para desenvolvimento com Docker:

```bash
# Database Configuration (Docker)
POSTGRES_HOST=localhost
POSTGRES_USERNAME=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DATABASE=chatwoot_development

# Redis Configuration (Docker)
REDIS_URL=redis://localhost:6379
```

## 🛠️ Desenvolvimento

### **Iniciar Desenvolvimento**
```bash
# 1. Iniciar containers
./bin/docker_dev.sh start

# 2. Iniciar servidor Rails
pnpm dev
```

### **Acessar Aplicação**
- **URL Principal**: http://localhost:3000
- **Genera Atende**: http://localhost:3000/genera_atende/dashboard

### **Conectar ao Banco**
```bash
# Conectar ao PostgreSQL
docker exec -it genera_atende_postgres psql -U postgres -d chatwoot_development

# Conectar ao Redis
docker exec -it genera_atende_redis redis-cli
```

## 🔍 Troubleshooting

### **Container não inicia**
```bash
# Ver logs do container
docker logs genera_atende_postgres
docker logs genera_atende_redis

# Verificar status
docker ps -a
```

### **Porta já em uso**
```bash
# Verificar o que está usando a porta
sudo lsof -i :5432
sudo lsof -i :6379

# Parar processo conflitante
sudo kill -9 <PID>
```

### **Problemas de permissão**
```bash
# Adicionar usuário ao grupo docker
sudo usermod -aG docker $USER

# Reiniciar sessão
newgrp docker
```

### **Limpar tudo e recomeçar**
```bash
# Parar e remover containers
./bin/docker_dev.sh cleanup

# Remover imagens
docker system prune -a

# Recriar containers
./bin/docker_dev.sh start
```

## 📁 Estrutura de Arquivos

```
├── docker-compose.dev.yml          # Configuração Docker
├── docker/
│   └── postgres/
│       └── init.sql                # Script de inicialização
├── bin/
│   ├── docker_dev.sh              # Gerenciador de containers
│   ├── check_docker.sh            # Verificador de Docker
│   └── setup_genera_atende        # Setup completo
├── .env.development               # Configurações de desenvolvimento
└── DOCKER_SETUP.md               # Este arquivo
```

## 🎯 Próximos Passos

1. **Executar setup**: `./bin/setup_genera_atende`
2. **Iniciar desenvolvimento**: `pnpm dev`
3. **Acessar aplicação**: http://localhost:3000/genera_atende/dashboard
4. **Fazer commit**: `./bin/commit_genera_atende.sh`

## 📞 Suporte

Se encontrar problemas:
1. Verifique os logs: `./bin/docker_dev.sh logs`
2. Verifique o status: `./bin/docker_dev.sh status`
3. Consulte a documentação do Docker
4. Verifique se as portas estão livres

---

**Status**: ✅ Configuração Docker completa!
**Tempo de setup**: 2-3 minutos
