# 📚 API Documentation - GATE SYSTEM

## Base URL

```
https://selinova-tech.at/api
```

## Authentication

### For Protected Endpoints

```bash
Header: X-Api-Key: {ADMIN_API_KEY}
```

### For User Endpoints

```bash
Header: Authorization: Bearer {FIREBASE_ID_TOKEN}
```

## Response Format

### Success Response (2xx)

```json
{
  "success": true,
  "data": { /* response data */ },
  "message": "Operation successful"
}
```

### Error Response (4xx, 5xx)

```json
{
  "success": false,
  "error": "ERROR_CODE",
  "message": "Human readable error message"
}
```

## Public Endpoints

### Health Check

```
GET /healthz
```

**Response:**
```json
{
  "status": "ok",
  "timestamp": "2024-01-15T10:30:00Z",
  "uptime": 3600
}
```

### Get All Listings

```
GET /listings?q=search&category=electronics&type=buy&sort=newest&limit=20&offset=0
```

**Query Parameters:**
- `q` (string): Search query
- `category` (string): Filter by category
- `type` (string): 'buy' or 'sell'
- `sort` (string): 'newest', 'price-asc', 'price-desc'
- `limit` (number): Results per page (default: 20, max: 100)
- `offset` (number): Pagination offset (default: 0)

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "listing-123",
      "title": "iPhone 15 Pro",
      "description": "Excellent condition",
      "category": "electronics",
      "type": "sell",
      "price": 899.99,
      "currency": "EUR",
      "images": ["url1", "url2"],
      "location": "Vienna, Austria",
      "seller": {
        "id": "user-456",
        "name": "John Doe",
        "rating": 4.8,
        "reviews": 42
      },
      "created_at": "2024-01-15T10:00:00Z",
      "updated_at": "2024-01-15T10:00:00Z"
    }
  ],
  "pagination": {
    "total": 150,
    "limit": 20,
    "offset": 0,
    "pages": 8
  }
}
```

### Get Single Listing

```
GET /listings/{id}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "listing-123",
    "title": "iPhone 15 Pro",
    "description": "Excellent condition, like new",
    "category": "electronics",
    "subcategory": "mobile-phones",
    "type": "sell",
    "price": 899.99,
    "currency": "EUR",
    "images": ["url1", "url2"],
    "location": "Vienna, Austria",
    "coordinates": { "lat": 48.2082, "lng": 16.3738 },
    "seller": {
      "id": "user-456",
      "name": "John Doe",
      "email": "john@example.com",
      "phone": "+43...",
      "rating": 4.8,
      "reviews": 42,
      "response_time_hours": 2,
      "verified": true
    },
    "condition": "like_new",
    "status": "active",
    "views": 247,
    "favorites": 12,
    "created_at": "2024-01-15T10:00:00Z",
    "updated_at": "2024-01-15T10:00:00Z",
    "expires_at": "2024-02-15T10:00:00Z"
  }
}
```

### Get Categories

```
GET /categories
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "electronics",
      "name": "Electronics",
      "icon": "📱",
      "count": 1542,
      "subcategories": [
        {
          "id": "mobile-phones",
          "name": "Mobile Phones",
          "count": 342
        },
        {
          "id": "laptops",
          "name": "Laptops",
          "count": 198
        }
      ]
    }
  ]
}
```

### Get Statistics

```
GET /listings/stats
```

**Response:**
```json
{
  "success": true,
  "data": {
    "total_listings": 15420,
    "active_listings": 12340,
    "total_users": 3456,
    "total_sales": 45600,
    "average_price": 542.30,
    "categories_count": 12,
    "last_updated": "2024-01-15T10:30:00Z"
  }
}
```

### Featured Listings

```
GET /listings/featured?limit=10
```

**Response:**
```json
{
  "success": true,
  "data": [
    /* Listing objects */
  ]
}
```

## Protected Endpoints (Require X-Api-Key)

### Create Listing

```
POST /listings
Header: X-Api-Key: {ADMIN_API_KEY}
Content-Type: application/json
```

**Request Body:**
```json
{
  "title": "iPhone 15 Pro",
  "description": "Excellent condition",
  "category": "electronics",
  "subcategory": "mobile-phones",
  "type": "sell",
  "price": 899.99,
  "currency": "EUR",
  "location": "Vienna, Austria",
  "images": ["base64-image-1", "base64-image-2"],
  "condition": "like_new",
  "seller_id": "user-123",
  "phone": "+43...",
  "negotiable": true,
  "tags": ["new", "original-packaging"]
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "listing-123",
    "title": "iPhone 15 Pro",
    "status": "active",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

### Update Listing

```
PATCH /listings/{id}
Header: X-Api-Key: {ADMIN_API_KEY}
Content-Type: application/json
```

**Request Body:**
```json
{
  "title": "iPhone 15 Pro - Updated",
  "price": 879.99,
  "status": "active"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "listing-123",
    "title": "iPhone 15 Pro - Updated",
    "updated_at": "2024-01-15T10:35:00Z"
  }
}
```

### Delete Listing

```
DELETE /listings/{id}
Header: X-Api-Key: {ADMIN_API_KEY}
```

**Response:**
```json
{
  "success": true,
  "message": "Listing deleted successfully"
}
```

## User Endpoints (Require Firebase Token)

### Get User Profile

```
GET /user/profile
Header: Authorization: Bearer {FIREBASE_ID_TOKEN}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "user-123",
    "email": "user@example.com",
    "name": "John Doe",
    "profile_picture": "url",
    "verified": true,
    "rating": 4.8,
    "reviews": 42,
    "listings_count": 12,
    "created_at": "2024-01-15T10:00:00Z"
  }
}
```

### Export User Data

```
GET /user/export
Header: Authorization: Bearer {FIREBASE_ID_TOKEN}
```

**Response:** ZIP file containing user data (GDPR Right to Data Portability)

### Delete Account

```
DELETE /user/account
Header: Authorization: Bearer {FIREBASE_ID_TOKEN}
```

**Response:**
```json
{
  "success": true,
  "message": "Account and all data will be deleted within 30 days"
}
```

## Error Codes

| Code | Status | Meaning |
|------|--------|----------|
| `INVALID_REQUEST` | 400 | Malformed request |
| `MISSING_AUTH` | 401 | Missing authentication |
| `INVALID_API_KEY` | 401 | Invalid API key |
| `UNAUTHORIZED` | 403 | Not authorized |
| `NOT_FOUND` | 404 | Resource not found |
| `RATE_LIMITED` | 429 | Too many requests |
| `SERVER_ERROR` | 500 | Internal server error |

## Rate Limiting

**Headers:**
```
X-RateLimit-Limit: 120
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1705315800
```

**Limits:**
- GET requests: 120 per minute
- Write operations: 20 per minute

## CORS

**Allowed Origins:**
- https://selinova-tech.at
- https://www.selinova-tech.at
- https://selinova-builder.vercel.app (development)

**Allowed Methods:** GET, POST, PATCH, DELETE, OPTIONS

**Allowed Headers:** Content-Type, Authorization, X-Api-Key
