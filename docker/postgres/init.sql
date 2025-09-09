-- Genera Atende SaaS PostgreSQL Initialization
-- This script runs when the PostgreSQL container starts for the first time

-- Create development database if it doesn't exist
SELECT 'CREATE DATABASE chatwoot_development'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'chatwoot_development')\gexec

-- Create test database if it doesn't exist
SELECT 'CREATE DATABASE chatwoot_test'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'chatwoot_test')\gexec

-- Grant all privileges to postgres user
GRANT ALL PRIVILEGES ON DATABASE chatwoot_development TO postgres;
GRANT ALL PRIVILEGES ON DATABASE chatwoot_test TO postgres;

-- Create extensions that might be needed
\c chatwoot_development;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";
CREATE EXTENSION IF NOT EXISTS "btree_gin";
CREATE EXTENSION IF NOT EXISTS vector;

\c chatwoot_test;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";
CREATE EXTENSION IF NOT EXISTS "btree_gin";
CREATE EXTENSION IF NOT EXISTS vector;

-- Log successful initialization
\echo 'Genera Atende SaaS PostgreSQL initialization completed successfully!'
