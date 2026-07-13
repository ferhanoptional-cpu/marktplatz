#!/bin/bash

# ============================================
# GATE SYSTEM - Setup Script
# ============================================
# This script sets up the development environment
# Run: ./scripts/setup.sh

set -e

echo "🚀 GATE SYSTEM - Development Setup"
echo "===================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check Node.js
echo "📦 Checking Node.js..."
if ! command -v node &> /dev/null; then
    echo -e "${RED}✗ Node.js not found${NC}"
    echo "Install from: https://nodejs.org/"
    exit 1
fi
echo -e "${GREEN}✓ Node.js $(node -v)${NC}"

# Check pnpm
echo "📦 Checking pnpm..."
if ! command -v pnpm &> /dev/null; then
    echo -e "${YELLOW}Installing pnpm...${NC}"
    npm install -g pnpm
fi
echo -e "${GREEN}✓ pnpm $(pnpm -v)${NC}"

# Install dependencies
echo "📦 Installing dependencies..."
pnpm install
echo -e "${GREEN}✓ Dependencies installed${NC}"

# Setup environment
echo "🔐 Setting up environment variables..."
if [ ! -f .env.local ]; then
    echo -e "${YELLOW}Creating .env.local...${NC}"
    cp .env.example .env.local
    
    # Generate secrets
    SESSION_SECRET=$(openssl rand -base64 32)
    ADMIN_API_KEY=$(openssl rand -hex 32)
    
    # Update .env.local with generated secrets
    sed -i.bak "s/SESSION_SECRET=.*/SESSION_SECRET=$SESSION_SECRET/" .env.local
    sed -i.bak "s/ADMIN_API_KEY=.*/ADMIN_API_KEY=$ADMIN_API_KEY/" .env.local
    
    echo -e "${GREEN}✓ Generated SESSION_SECRET and ADMIN_API_KEY${NC}"
    echo -e "${YELLOW}⚠️  Edit .env.local with your Firebase and Supabase credentials${NC}"
else
    echo -e "${GREEN}✓ .env.local already exists${NC}"
fi

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p artifacts/selinova-web/src/components
mkdir -p artifacts/api-server/src/routes
mkdir -p lib/db/migrations
echo -e "${GREEN}✓ Directories created${NC}"

# Git setup
echo "🔧 Configuring Git..."
git config core.hooksPath .git/hooks 2>/dev/null || true
echo -e "${GREEN}✓ Git configured${NC}"

# Database setup (optional)
echo ""
echo "📊 Database Setup (Optional)"
echo "============================="
read -p "Do you want to setup the database? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Make sure DATABASE_URL is set in .env.local"
    pnpm --filter @workspace/db run push
    echo -e "${GREEN}✓ Database migrations complete${NC}"
fi

echo ""
echo "✅ Setup Complete!"
echo "===================================="
echo ""
echo "Next steps:"
echo "1. Edit .env.local with your credentials:"
echo "   - Firebase API Key and config"
echo "   - Supabase URL and keys"
echo "   - Database URL"
echo ""
echo "2. Run development server:"
echo "   pnpm dev"
echo ""
echo "3. Start coding! 🎉"
echo ""
