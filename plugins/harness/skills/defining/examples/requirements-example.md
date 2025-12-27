# Requirements: User Authentication

## Vision

Implement secure user authentication so users can register, log in, and maintain sessions across the application. This is foundational infrastructure that enables personalized features and access control.

## Functional Requirements

### Registration
- Users can register with email and password
- Email must be unique and validated format
- Password must meet minimum security requirements (8+ chars, mixed case, number)
- Confirmation email sent after registration

### Login
- Users can log in with email and password
- Failed login attempts are rate-limited (5 attempts per 15 minutes)
- Session token issued on successful login
- "Remember me" option for extended session duration

### Session Management
- Sessions expire after 24 hours (or 30 days with "remember me")
- Users can log out, invalidating their session
- Users can see active sessions and revoke them

### Password Recovery
- Users can request password reset via email
- Reset links expire after 1 hour
- Password history prevents reuse of last 3 passwords

## Constraints

- **Scope boundary**: No OAuth/social login in this phase (deferred to backlog)
- **Compatibility**: Must work with existing user table schema
- **Security**: Passwords stored with bcrypt, minimum cost factor 12
- **Dependencies**: Uses existing email service for notifications
- **Performance**: Login must complete in under 500ms

## Success Criteria

1. User can complete full registration → login → logout flow
2. Invalid credentials are rejected with appropriate error messages
3. Rate limiting prevents brute force attacks
4. Session tokens are properly invalidated on logout
5. Password reset flow works end-to-end
6. All authentication endpoints have test coverage > 80%
