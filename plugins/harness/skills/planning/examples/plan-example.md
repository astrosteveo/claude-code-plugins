# Implementation Plan: User Authentication

## Overview

Implement JWT + Refresh Token authentication following Approach 1 from research. Each step represents 1-3 logical commits of work.

## Pre-Implementation Checklist

- [x] requirements.md reviewed
- [x] codebase.md created
- [x] research.md created
- [x] design.md approved
- [x] User approval of plan

---

## Step 001-1: Add password and session fields to User model

**Files to modify:**
- `src/models/user.ts`

**Details:**
- Add `passwordHash: string` field
- Add `refreshTokens: RefreshToken[]` embedded document array
- Add `failedLoginAttempts: number` and `lockoutUntil: Date` for rate limiting
- Add indexes for email (unique) and refreshToken lookup

**Commit message:** `feat(auth): add password and session fields to user model`

---

## Step 001-2: Create authentication service

**Files to create:**
- `src/services/auth.ts`
- `src/services/auth.test.ts`

**Details:**
- `hashPassword(password: string): Promise<string>` - bcrypt with cost 12
- `verifyPassword(password, hash): Promise<boolean>` - constant-time comparison
- `generateAccessToken(userId): string` - JWT with 15 min expiry
- `generateRefreshToken(): string` - crypto random bytes
- `verifyAccessToken(token): TokenPayload` - JWT verification

**Tests:**
- Password hashing produces valid bcrypt hash
- Password verification returns true/false correctly
- Tokens are generated with correct expiry
- Invalid tokens throw appropriate errors

**Commit message:** `feat(auth): add authentication service with password and token handling`

---

## Step 001-3: Create auth middleware

**Files to modify:**
- `src/middleware/auth.ts`

**Files to create:**
- `src/middleware/auth.test.ts`

**Details:**
- `requireAuth` middleware - validates access token from Authorization header
- `optionalAuth` middleware - attaches user if token present, continues if not
- Attach decoded user to `req.user`
- Return 401 for missing/invalid tokens

**Tests:**
- Valid token allows request through
- Missing token returns 401
- Invalid token returns 401
- Expired token returns 401

**Commit message:** `feat(auth): add authentication middleware`

---

## Step 001-4: Create registration endpoint

**Files to create:**
- `src/routes/auth.ts`
- `src/controllers/auth.ts`
- `src/controllers/auth.test.ts`

**Details:**
- `POST /auth/register` - email, password in body
- Validate email format and uniqueness
- Validate password requirements (8+ chars, mixed case, number)
- Hash password, create user, send confirmation email
- Return 201 with user info (no password)

**Tests:**
- Valid registration creates user
- Duplicate email returns 409
- Invalid email format returns 400
- Weak password returns 400

**Commit message:** `feat(auth): add user registration endpoint`

---

## Step 001-5: Create login endpoint

**Files to modify:**
- `src/routes/auth.ts`
- `src/controllers/auth.ts`

**Details:**
- `POST /auth/login` - email, password in body
- Rate limit: 5 attempts per 15 minutes per email
- Verify credentials, generate tokens
- Store refresh token in database
- Return access token and refresh token

**Tests:**
- Valid credentials return tokens
- Invalid password returns 401 (same as user not found)
- Rate limiting kicks in after 5 failures
- Lockout expires after 15 minutes

**Commit message:** `feat(auth): add login endpoint with rate limiting`

---

## Step 001-6: Create token refresh endpoint

**Files to modify:**
- `src/routes/auth.ts`
- `src/controllers/auth.ts`

**Details:**
- `POST /auth/refresh` - refresh token in body
- Validate refresh token exists in database
- Generate new access token
- Optionally rotate refresh token

**Tests:**
- Valid refresh token returns new access token
- Invalid refresh token returns 401
- Expired refresh token returns 401

**Commit message:** `feat(auth): add token refresh endpoint`

---

## Step 001-7: Create logout endpoint

**Files to modify:**
- `src/routes/auth.ts`
- `src/controllers/auth.ts`

**Details:**
- `POST /auth/logout` - requires auth, refresh token in body
- Remove refresh token from database
- Optionally support "logout all" to clear all sessions

**Tests:**
- Logout removes refresh token
- Subsequent refresh with that token fails
- Logout all clears all sessions

**Commit message:** `feat(auth): add logout endpoint`

---

## Summary

| Step | Description | Files | Type |
|------|-------------|-------|------|
| 001-1 | User model fields | 1 | modify |
| 001-2 | Auth service | 2 | create |
| 001-3 | Auth middleware | 2 | create/modify |
| 001-4 | Registration | 3 | create |
| 001-5 | Login | 2 | modify |
| 001-6 | Token refresh | 2 | modify |
| 001-7 | Logout | 2 | modify |

**Total: 7 steps, 10 files**

---

## Deferred Items

- [ ] **OAuth/social login** - Out of scope, add after core auth is stable
- [ ] **Password reset flow** - Can be added as follow-up task
- [ ] **Email confirmation** - Email service integration needed first
- [ ] **Active sessions UI** - Frontend work, separate task
