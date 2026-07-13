# 🔒 Security & GDPR Compliance Guide

## Data Protection Principles

### 1. Encryption in Transit

✅ **Implemented:**
- HTTPS/TLS for all connections
- Database connections use SSL mode
- Firebase uses encrypted channels

### 2. Encryption at Rest

✅ **Implemented:**
- Supabase automatic encryption
- Firebase Security Rules restrict access
- Environment variables encrypted in Vercel

### 3. Authentication & Authorization

✅ **Implemented:**
- Google OAuth 2.0 for user authentication
- Firebase JWT tokens for API access
- X-Api-Key for admin operations
- Session management with secure cookies

## Security Architecture

```
┌─────────────────────────────────────────────┐
│          Browser / Frontend                  │
│  (React/Vite - HTTPS only)                  │
└────────────────┬────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────┐
│      Vercel (Express.js API)                │
│  - helmet (security headers)                │
│  - express-rate-limit                       │
│  - Firebase authentication                  │
│  - CORS validation                          │
└────────────────┬────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────┐
│     Supabase PostgreSQL (SSL)               │
│  - Row Level Security (RLS)                 │
│  - Encryption at rest                       │
│  - Automatic backups                        │
│  - Transaction pooler (Port 6543)           │
└─────────────────────────────────────────────┘
```

## API Security

### Public Endpoints (No Auth Required)

```
GET /api/healthz
GET /api/listings
GET /api/listings/:id
GET /api/categories
```

### Protected Endpoints (API Key Required)

```
Header: X-Api-Key: {ADMIN_API_KEY}

POST   /api/listings      (Create)
PATCH  /api/listings/:id  (Update)
DELETE /api/listings/:id  (Delete)
```

### Rate Limiting

```
GET Requests:   120 per minute per IP
Write Requests: 20 per minute per IP
```

## GDPR Compliance

### 1. User Consent

✅ **Required Components:**
- [ ] Cookie consent banner
- [ ] Privacy policy link
- [ ] Terms of service link
- [ ] Opt-in for analytics

**Implementation:**
```tsx
// components/CookieConsent.tsx
export function CookieConsent() {
  // Handle user consent
  // Store in localStorage
  // Only then enable analytics
}
```

### 2. Data Collection

**Collected via Google Authentication:**
- Email address (required)
- Name (optional)
- Profile picture (optional)
- Google ID (for authentication)

**Data NOT Collected:**
- Location tracking
- Device identifiers
- Browsing history
- Behavioral tracking

### 3. Data Access Rights

Users can request:
- ✅ Download their data
- ✅ Delete their account
- ✅ Export their listings

**Implementation:**
```tsx
// API endpoints
GET  /api/user/data        (Download data)
DELETE /api/user/account   (Delete account)
GET  /api/user/export      (Export listings)
```

### 4. Data Retention

```
Active Users:     Data retained indefinitely
Deleted Accounts:  Data purged after 30 days
Inactive (1 year): Automatic deletion notice
```

### 5. Third-Party Data Sharing

❌ **NOT SHARED:**
- Email addresses
- Personal data
- Listing data

✅ **SHARED (Necessary):**
- Firebase: For authentication only
- Supabase: For data storage (encrypted)

## Environment Variable Security

### Never Commit These Files

```
.env
.env.local
.env.*.local
```

### Gitignore Configuration

```bash
# .gitignore
.env
.env.*
!.env.example
```

### Secret Management

**Development:**
```bash
# Create .env.local (NEVER commit)
cp .env.example .env.local
# Edit with real values
```

**Production (Vercel):**
1. Go to Vercel Dashboard
2. Project → Settings → Environment Variables
3. Add each secret
4. Mark as "Encrypted"

## Sensitive Data Handling

### Database Credentials

```javascript
// ❌ WRONG
const connectionString = "postgresql://user:password@host...";
console.log(connectionString);

// ✅ CORRECT
const connectionString = process.env.DATABASE_URL;
// Never log it
```

### Firebase Private Key

```javascript
// ❌ WRONG
const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);

// ✅ CORRECT
const firebaseAdmin = require('firebase-admin');
firebaseAdmin.initializeApp({
  credential: firebaseAdmin.credential.cert({
    projectId: process.env.FIREBASE_PROJECT_ID,
    clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
    privateKey: process.env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, '\n'),
  }),
});
```

### User Data in Logs

```javascript
// ❌ WRONG
console.log('User:', { email, password, token });

// ✅ CORRECT
console.log('User authenticated:', { id: userId });
```

## Security Headers

Verified with `helmet`:

```
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
X-XSS-Protection: 1; mode=block
Strict-Transport-Security: max-age=31536000; includeSubDomains
Content-Security-Policy: default-src 'self'
```

## Incident Response

### If Data Breach Occurs

1. **Immediate Actions (1 hour)**
   - [ ] Isolate affected systems
   - [ ] Review access logs
   - [ ] Contact security team

2. **Assessment (24 hours)**
   - [ ] Identify affected data
   - [ ] Assess breach severity
   - [ ] Determine notification requirement

3. **Notification (72 hours max)**
   - [ ] Notify affected users
   - [ ] Provide breach details
   - [ ] Offer protection measures

4. **Documentation**
   - [ ] Log incident details
   - [ ] Document response actions
   - [ ] Implement preventive measures

## Compliance Checklist

- [ ] Privacy policy published
- [ ] Terms of service published
- [ ] Cookie consent implemented
- [ ] HTTPS/TLS enforced
- [ ] All credentials encrypted
- [ ] Rate limiting enabled
- [ ] CORS properly configured
- [ ] Security headers set
- [ ] User data deletion possible
- [ ] Data export functionality
- [ ] Audit logs maintained
- [ ] Regular security reviews

## Resources

- [GDPR Compliance Checklist](https://gdpr-info.eu/)
- [Firebase Security Rules](https://firebase.google.com/docs/rules)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework/)
