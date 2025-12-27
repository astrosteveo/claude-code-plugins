# Research: User Authentication

## Best Practices

### Password Storage
- Use bcrypt with cost factor 12+ (adjusts with hardware improvements)
- Never store plaintext passwords or reversible encryption
- Salt is included in bcrypt hash automatically

### Session Management
- JWT for stateless sessions (scalable, but harder to revoke)
- Server-side sessions for revocable sessions (requires storage)
- Hybrid approach: short-lived JWT + refresh token in database

### Rate Limiting
- Implement at multiple levels (IP, user, endpoint)
- Use sliding window algorithm for smoother limiting
- Return 429 status with Retry-After header

### Security Headers
- Set secure, httpOnly, sameSite flags on session cookies
- Use HTTPS only in production
- Implement CSRF protection for cookie-based sessions

## API/Library Documentation

### bcrypt
```typescript
import bcrypt from 'bcrypt';

// Hash password
const hash = await bcrypt.hash(password, 12);

// Verify password
const match = await bcrypt.compare(password, hash);
```

### jsonwebtoken
```typescript
import jwt from 'jsonwebtoken';

// Create token
const token = jwt.sign({ userId }, secret, { expiresIn: '24h' });

// Verify token
const payload = jwt.verify(token, secret);
```

### express-rate-limit
```typescript
import rateLimit from 'express-rate-limit';

const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5, // 5 attempts
  message: 'Too many login attempts'
});
```

## Security Considerations

- **Timing attacks**: Use constant-time comparison for tokens
- **Enumeration**: Same response for "user not found" and "wrong password"
- **Session fixation**: Regenerate session ID after login
- **Token storage**: HttpOnly cookies preferred over localStorage

## Performance Considerations

- bcrypt is intentionally slow (100-500ms per hash)
- Cache user lookups if checking auth on every request
- Use connection pooling for database
- Consider Redis for session storage at scale

## Implementation Approaches

### Approach 1: JWT + Refresh Token (Recommended)

Short-lived JWT (15 min) for API access, long-lived refresh token stored in database for renewal.

**Pros**:
- Stateless for most requests (scalable)
- Can revoke refresh tokens
- Good security/UX balance

**Cons**:
- More complex than pure sessions
- Need to handle token refresh logic

### Approach 2: Server-Side Sessions

Traditional sessions stored in Redis/database.

**Pros**:
- Simple to implement
- Easy to revoke
- Full control over session data

**Cons**:
- Requires session storage infrastructure
- Less scalable (every request hits storage)

### Approach 3: Pure JWT

Stateless JWT-only approach.

**Pros**:
- Simplest implementation
- No session storage needed
- Highly scalable

**Cons**:
- Cannot revoke tokens before expiry
- Larger payload in every request
- Security tradeoffs
