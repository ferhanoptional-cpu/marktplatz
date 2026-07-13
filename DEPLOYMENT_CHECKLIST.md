# 🚀 GATE SYSTEM - Deployment Checklist

## Pre-Deployment Setup

### 1. Firebase Configuration

- [ ] Create Firebase Project at https://console.firebase.google.com
- [ ] Enable Google Authentication
- [ ] Download Service Account JSON
- [ ] Add authorized domains:
  - `selinova-tech.at`
  - `www.selinova-tech.at`
  - `your-vercel-deployment.vercel.app`

### 2. Supabase Configuration

```bash
# Create new Supabase project
# 1. Go to https://app.supabase.com
# 2. Create new project
# 3. Run migrations:
DATABASE_URL="postgresql://..." pnpm --filter @workspace/db run push
```

### 3. Environment Variables

```bash
# Copy template
cp .env.example .env.local

# Generate secure secrets
SESSION_SECRET=$(openssl rand -base64 32)
ADMIN_API_KEY=$(openssl rand -hex 32)

# Fill in .env.local with real values
# Never commit .env.local to git
```

### 4. Vercel Deployment

**Step 1: Create Vercel Project**
```bash
# 1. Go to https://vercel.com
# 2. Import repository
# 3. Select: ferhanoptional-cpu/marktplatz
```

**Step 2: Set Environment Variables in Vercel**
```
DATABASE_URL = postgresql://...
SESSION_SECRET = generated-value
ADMIN_API_KEY = generated-value
FIREBASE_PROJECT_ID = your-project
FIREBASE_CLIENT_EMAIL = xxx@iam.gserviceaccount.com
FIREBASE_PRIVATE_KEY = -----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----
VITE_FIREBASE_API_KEY = xxx
VITE_FIREBASE_AUTH_DOMAIN = xxx.firebaseapp.com
VITE_FIREBASE_PROJECT_ID = xxx
VITE_SUPABASE_URL = https://xxx.supabase.co
VITE_SUPABASE_PUBLISHABLE_KEY = xxx
```

### 5. Domain Configuration (internex.at)

**DNS Records to add:**

```
Type: A
Name: @
Value: 76.76.21.21
TTL: 3600

Type: CNAME
Name: www
Value: cname.vercel-dns.com.
TTL: 3600
```

**Verify in Vercel:**
- Settings → Domains
- Add custom domain
- Wait for DNS propagation (15 min - 48h)

### 6. SSL Certificate

✅ Automatically issued by Vercel
- No manual configuration needed
- HTTPS enabled automatically

## Post-Deployment Verification

### Health Check

```bash
# Test API
curl -X GET https://selinova-tech.at/api/healthz
# Expected response: {"status":"ok"}

# Test authentication
curl -X GET https://selinova-tech.at/api/auth/session
# Should return 401 without token
```

### Security Verification

- [ ] `GET /api/healthz` returns 200
- [ ] `POST /api/listings` without key returns 401
- [ ] Firebase authentication working
- [ ] HTTPS enforced (no HTTP)
- [ ] CORS headers present
- [ ] Security headers (helmet) present

```bash
# Check security headers
curl -I https://selinova-tech.at
# Should include:
# X-Content-Type-Options: nosniff
# X-Frame-Options: DENY
# X-XSS-Protection: 1; mode=block
```

## Troubleshooting

### Build Fails

```bash
# Check Vercel logs
vercel logs

# Verify DATABASE_URL format
echo $DATABASE_URL
```

### API Returns 401

```bash
# Check ADMIN_API_KEY
echo $ADMIN_API_KEY

# Test with correct header
curl -X POST https://selinova-tech.at/api/listings \
  -H "X-Api-Key: $ADMIN_API_KEY" \
  -H "Content-Type: application/json"
```

### CORS Errors

1. Check ALLOWED_ORIGINS in env
2. Verify domain is added to Firebase
3. Restart deployment:
   ```bash
   vercel deploy --prod
   ```

## Monitoring

### Daily Checks

```bash
# Monitor API health
# Add to cron job every 5 minutes:
curl -f https://selinova-tech.at/api/healthz || alert

# Check database connection
psql $DATABASE_URL -c "SELECT 1"
```

### Logs

- Vercel: https://vercel.com/dashboard → marktplatz → Deployments
- Firebase: https://console.firebase.google.com → Logs
- Database: Supabase Console → SQL Editor

## Security Checklist

- [ ] All secrets in Vercel (not in code)
- [ ] DATABASE_URL uses pooler connection
- [ ] SESSION_SECRET ≥ 32 characters
- [ ] ADMIN_API_KEY is unique and strong
- [ ] Firebase Service Account restricted to needed permissions
- [ ] HTTPS enforced
- [ ] CORS restricted to known domains
- [ ] Rate limiting enabled
- [ ] No console logs with sensitive data

## GDPR Compliance

- [ ] Privacy Policy updated
- [ ] Terms of Service updated
- [ ] Firebase anonymization rules set
- [ ] Database backups configured (Supabase automatic)
- [ ] Data retention policy documented
- [ ] User data deletion mechanism implemented
- [ ] No tracking cookies without consent

## Support

For issues:
1. Check Vercel logs
2. Review Firebase console
3. Test database connection
4. Verify environment variables
