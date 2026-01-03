---
date: YYYY-MM-DDTHH:MM:SSZ
researcher: Claude
topic: "[Brief Topic Description]"
tags: [research, feature-name, relevant-tags]
status: in_progress
context: "[What task this research supports]"
feature_directory: ".harness/NNN-feature-slug/"
---

# Research: [Feature Name]

---

## Codebase Exploration

### Existing Patterns

| Pattern | Location | Used For |
|---------|----------|----------|
| [Pattern 1] | `path/to/file.ts:line` | [Purpose] |
| [Pattern 2] | `path/to/file.ts:line` | [Purpose] |

### Related Code

| File/Module | Relevance |
|-------------|-----------|
| `path/to/file.ts` | [How it relates] |
| `path/to/other.ts` | [How it relates] |

### Testing Approach

- **Test Location:** `path/to/tests/`
- **Test Pattern:** [Describe how similar features are tested]
- **Test Utilities:** [Any shared test helpers]

### Recent Activity

```bash
# Recent commits affecting this area
git log --oneline -10 -- path/to/area/
```

- [Relevant recent change 1]
- [Relevant recent change 2]

### Key Observations

- [Observation 1 that affects design]
- [Observation 2 that affects design]
- [Observation 3 that affects design]

---

## External Research

### [Library/Framework Name]

**Current Version:** X.Y.Z (released YYYY-MM-DD)
**Documentation:** [URL]
**Used in Project:** [Yes/No, where]

**Key Findings:**
- [Important discovery 1]
- [Important discovery 2]

**API Details:**
```typescript
// Relevant method signatures
methodName(param: Type): ReturnType
```

**Recommendations:**
- [What to use]
- [How to use it]

**Avoid:**
- [What's deprecated]
- [Common pitfalls]

### [Another Technology]

**Current Version:** X.Y.Z
**Documentation:** [URL]

**Key Findings:**
- [Finding 1]
- [Finding 2]

---

## Alternative Approaches Considered

| Approach | Pros | Cons | Verdict |
|----------|------|------|---------|
| [Approach 1] | | | Consider |
| [Approach 2] | | | Rejected |
| [Approach 3] | | | Selected |

---

## Key Insights

1. **[Insight 1]:** [Details that will affect the design]
2. **[Insight 2]:** [Details that will affect the design]
3. **[Insight 3]:** [Details that will affect the design]

---

## Questions Resolved

| Question | Answer | Source |
|----------|--------|--------|
| [Question 1] | [Answer] | [Where found] |
| [Question 2] | [Answer] | [Where found] |

---

## Open Questions

- [ ] [Question 1 that still needs clarification]
- [ ] [Question 2 that still needs clarification]

---

## Next Steps

After this research:
1. `/superharness:create-plan` to design implementation
2. Review with user before proceeding
