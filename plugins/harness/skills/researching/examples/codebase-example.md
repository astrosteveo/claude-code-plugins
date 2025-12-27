# Codebase Analysis: User Authentication

## Relevant Files

| File | Purpose | Lines of Interest |
|------|---------|-------------------|
| `src/models/user.ts` | User model and schema | L12-45 (schema definition) |
| `src/services/email.ts` | Email sending service | L30-55 (sendEmail function) |
| `src/middleware/auth.ts` | Existing auth middleware placeholder | L1-20 (empty implementation) |
| `src/routes/api.ts` | API route definitions | L80-95 (user routes) |
| `src/utils/crypto.ts` | Cryptographic utilities | L10-30 (hash functions) |

## Existing Patterns

### Model Pattern
Models use TypeScript interfaces with Mongoose schemas:
```typescript
interface IUser {
  email: string;
  passwordHash: string;
  createdAt: Date;
}

const UserSchema = new Schema<IUser>({...});
```

### Service Pattern
Services are singleton classes with dependency injection:
```typescript
class EmailService {
  constructor(private config: EmailConfig) {}
  async send(to: string, template: string, data: object): Promise<void>
}
```

### Route Pattern
Routes use Express Router with middleware chain:
```typescript
router.post('/users', validateBody(schema), controller.create);
```

### Error Handling
Custom error classes extend BaseError:
```typescript
class AuthenticationError extends BaseError {
  constructor(message: string) {
    super(message, 401);
  }
}
```

## Git History

| File:Line | Commit | Author | Summary |
|-----------|--------|--------|---------|
| `src/models/user.ts:12` | `a1b2c3d` | alice | Add user model with email field |
| `src/models/user.ts:25` | `e4f5g6h` | bob | Add password field (placeholder) |
| `src/services/email.ts:30` | `i7j8k9l` | alice | Implement email service |
| `src/utils/crypto.ts:10` | `m0n1o2p` | carol | Add bcrypt wrapper utilities |

## Testing Infrastructure

- **Framework**: Jest with ts-jest
- **Pattern**: Colocated tests (`*.test.ts` next to source files)
- **Mocking**: Uses jest.mock for external services
- **Database**: In-memory MongoDB for integration tests
- **Coverage target**: 80% for new code

## Technical Dependencies

| Dependency | Version | Used For |
|------------|---------|----------|
| bcrypt | ^5.1.0 | Password hashing |
| jsonwebtoken | ^9.0.0 | Session tokens |
| express-rate-limit | ^6.7.0 | Rate limiting |
| nodemailer | ^6.9.0 | Email sending |
| mongoose | ^7.0.0 | Database ORM |
