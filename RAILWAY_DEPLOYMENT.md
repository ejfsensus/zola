# Railway Deployment Guide for Zola

This guide will help you deploy Zola to Railway, addressing the issues you've encountered with Vercel.

## Prerequisites

1. A Railway account (sign up at [railway.app](https://railway.app))
2. Railway CLI installed (optional but recommended)
3. Your environment variables ready

## Deployment Steps

### 1. Create a New Railway Project

1. Go to [railway.app](https://railway.app) and sign in
2. Click "New Project"
3. Choose "Deploy from GitHub repo" and select your Zola repository
4. Railway will automatically detect the Dockerfile and start building

### 2. Configure Environment Variables

In your Railway project dashboard, go to the "Variables" tab and add the following environment variables:

#### Required Variables
```
NEXT_PUBLIC_SUPABASE_URL=your_supabase_project_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE=your_supabase_service_role_key
CSRF_SECRET=your_32_character_random_string
```

#### AI Model API Keys (add the ones you need)
```
OPENAI_API_KEY=sk-your_openai_api_key
MISTRAL_API_KEY=your_mistral_api_key
GOOGLE_GENERATIVE_AI_API_KEY=your_gemini_api_key
ANTHROPIC_API_KEY=your_anthropic_api_key
XAI_API_KEY=your_xai_api_key
PERPLEXITY_API_KEY=your_perplexity_api_key
OPENROUTER_API_KEY=your_openrouter_api_key
```

#### Optional Variables
```
OLLAMA_BASE_URL=http://localhost:11434
EXA_API_KEY=your_exa_api_key
GITHUB_TOKEN=your_github_token
ANALYZE=false
```

#### Production Variables (Railway will set these automatically)
```
NODE_ENV=production
NEXT_TELEMETRY_DISABLED=1
PORT=3000
HOSTNAME=0.0.0.0
```

### 3. Generate a Secure CSRF Secret

If you don't have a 32-character CSRF secret, generate one using:

```bash
# Using Node.js
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"

# Using OpenSSL
openssl rand -hex 32

# Using Python
python3 -c "import secrets; print(secrets.token_hex(32))"
```

### 4. Deploy

Once you've added all the environment variables:

1. Railway will automatically redeploy when you push changes to your repository
2. You can also manually trigger a deployment from the Railway dashboard
3. Monitor the build logs to ensure everything deploys successfully

### 5. Access Your Application

After deployment:
1. Railway will provide you with a public URL (e.g., `https://your-app-name.up.railway.app`)
2. You can also set up a custom domain in the Railway dashboard

## Troubleshooting

### Common Issues and Solutions

1. **Build Failures**
   - Check that all required environment variables are set
   - Ensure your CSRF_SECRET is exactly 32 characters
   - Review build logs for specific error messages

2. **Runtime Errors**
   - Verify Supabase configuration is correct
   - Check that API keys are valid and have proper permissions
   - Monitor application logs in Railway dashboard

3. **CSRF Token Issues**
   - Ensure CSRF_SECRET is set and is a 32-character hex string
   - Verify the secret is the same across all instances

### Advantages of Railway over Vercel

1. **Better Docker Support**: Railway natively supports Dockerfile deployments
2. **Persistent Storage**: Better handling of file uploads and storage
3. **Environment Variables**: More reliable environment variable handling
4. **Build Process**: More predictable build and deployment process
5. **Debugging**: Better logging and debugging capabilities

## CLI Deployment (Alternative)

If you prefer using the CLI:

```bash
# Install Railway CLI
npm install -g @railway/cli

# Login to Railway
railway login

# Initialize project
railway init

# Set environment variables
railway variables set CSRF_SECRET=your_32_character_secret
railway variables set NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
# ... add other variables

# Deploy
railway up
```

## Monitoring

Railway provides:
- Real-time logs
- Metrics and analytics
- Health checks (using the `/api/health` endpoint)
- Automatic SSL certificates
- Custom domain support

Your application should now be successfully deployed on Railway with proper environment variable handling and Docker support!