# Testing Rules

Ensure proper test coverage and quality.

---

## Rules Overview

| Rule | Label | Purpose |
|------|-------|---------|
| `test-only-change` | `test-only-change` | Only test files modified |
| `test-missing` | `test-missing` | Code changed without tests |
| `test-improvement` | `test-improvement` | Tests improved with code |

---

## `test-missing`

**Most Important:** Flags when source code changes without corresponding test changes.

### Detection

- Source files changed (`.js`, `.ts`, `.py`, etc.)
- No test files changed (`.test.js`, `.spec.ts`, `_test.py`, etc.)

### Example

```yaml
enabled_rules: '["test-missing"]'
```

**Changed Files:**
```
src/utils/calculator.ts  ← Source code
```

**Result:** 🔴 `test-missing` label applied

---

## `test-only-change`

Fast-track PRs that only modify tests.

### Example

**Changed Files:**
```
src/__tests__/calculator.test.ts
tests/integration/api.test.ts
```

**Result:** 🟢 `test-only-change` label (fast-track eligible)

---

## `test-improvement`

Acknowledges when tests are added/improved with code changes.

### Example

**Changed Files:**
```
src/utils/calculator.ts
src/__tests__/calculator.test.ts
```

**Result:** 🟡 `test-improvement` label (good practice!)

---

[← Back to Rules Overview](index.md){ .md-button }

