#!/bin/bash

# Railway Deployment Script for Zola
# This script helps you deploy Zola to Railway with proper configuration

set -e

echo "🚂 Railway Deployment Script for Zola"
echo "======================================"

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null; then
    echo "❌ Railway CLI not found. Installing..."
    npm install -g @railway/cli
else
    echo "✅ Railway CLI found"
fi

# Check if user is logged in
if ! railway whoami &> /dev/null; then
    echo "🔐 Please log in to Railway:"
    railway login
fi

# Check if project is initialized
if [ ! -f "railway.json" ] && [ ! -f "railway.toml" ]; then
    echo "❌ No Railway configuration found. Please run 'railway init' first."
    exit 1
fi

echo "✅ Railway configuration found"

# Check for required environment variables
echo "🔍 Checking for required environment variables..."

required_vars=(
    "NEXT_PUBLIC_SUPABASE_URL"
    "NEXT_PUBLIC_SUPABASE_ANON_KEY"
    "SUPABASE_SERVICE_ROLE"
    "CSRF_SECRET"
)

missing_vars=()

for var in "${required_vars[@]}"; do
    if ! railway variables get "$var" &> /dev/null; then
        missing_vars+=("$var")
    fi
done

if [ ${#missing_vars[@]} -ne 0 ]; then
    echo "❌ Missing required environment variables:"
    for var in "${missing_vars[@]}"; do
        echo "   - $var"
    done
    echo ""
    echo "Please set these variables using:"
    echo "railway variables set VARIABLE_NAME=value"
    echo ""
    echo "Or set them in the Railway dashboard at:"
    echo "https://railway.app/project/[your-project-id]/variables"
    echo ""
    echo "For CSRF_SECRET, generate a 32-character string:"
    echo "node -e \"console.log(require('crypto').randomBytes(32).toString('hex'))\""
    exit 1
fi

echo "✅ All required environment variables are set"

# Validate CSRF_SECRET length
csrf_secret=$(railway variables get CSRF_SECRET 2>/dev/null || echo "")
if [ ${#csrf_secret} -ne 64 ]; then  # 32 bytes = 64 hex characters
    echo "⚠️  Warning: CSRF_SECRET should be exactly 32 bytes (64 hex characters)"
    echo "   Current length: ${#csrf_secret} characters"
    echo "   Generate a new one with: node -e \"console.log(require('crypto').randomBytes(32).toString('hex'))\""
fi

# Check if Dockerfile exists
if [ ! -f "Dockerfile" ]; then
    echo "❌ Dockerfile not found. This project requires Docker for Railway deployment."
    exit 1
fi

echo "✅ Dockerfile found"

# Deploy to Railway
echo "🚀 Deploying to Railway..."
railway up

echo "✅ Deployment initiated!"
echo ""
echo "📊 Monitor your deployment at:"
echo "https://railway.app/project/[your-project-id]/deployments"
echo ""
echo "🌐 Your app will be available at:"
echo "https://[your-app-name].up.railway.app"
echo ""
echo "💡 Tips:"
echo "   - Check logs if deployment fails: railway logs"
echo "   - Set custom domain in Railway dashboard"
echo "   - Monitor health at: [your-url]/api/health"
echo "   - Update environment variables anytime in Railway dashboard"