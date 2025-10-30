# Usage Examples

Real-world examples and configuration templates for different team types and use cases.

---

## By Team Type

### Frontend Team

Focus on UI changes, styling, and frontend dependencies:

```yaml title=".github/workflows/pr-labeler.yml"
name: Auto Label PRs

on:
  pull_request:
    types: [opened, synchronize, reopened]

permissions:
  contents: read
  pull-requests: write

jobs:
  label:
    uses: workflow-kit/pr-auto-labeler@v0.0.1
    with:
      enabled_rules: '[
        "ui-change",
        "style-change",
        "test-missing",
        "dependency-change",
        "new-dependency",
        "large-pr"
      ]'
      label_overrides: '{
        "ui-change": "area/frontend",
        "test-missing": "needs-tests"
      }'
```

---

### Backend/API Team

Track database, security, and API changes:

```yaml
enabled_rules: '[
  "migration",
  "risky-migration",
  "safe-migration",
  "test-missing",
  "security-change",
  "new-dependency",
  "dependency-downgrade",
  "large-pr"
]'
```

---

### DevOps/Platform Team

Monitor infrastructure and CI/CD:

```yaml
enabled_rules: '[
  "ci-change",
  "docker-change",
  "infra-change",
  "env-change",
  "new-env-variable",
  "dependency-change"
]'
```

---

### Security-Focused

Maximum security coverage:

```yaml
enabled_rules: '[
  "potential-secret-leak",
  "security-change",
  "risky-code",
  "risky-migration",
  "dependency-downgrade",
  "env-change"
]'
```

---

## By Use Case

### Enforce PR Quality Standards

```yaml
enabled_rules: '[
  "large-pr",
  "test-missing",
  "missing-description",
  "no-linked-issue",
  "work-in-progress"
]'
large_pr_threshold: '300'  # Strict
```

---

### Fast-Track Simple Changes

Identify low-risk PRs for faster review:

```yaml
enabled_rules: '[
  "test-only-change",
  "style-change",
  "non-functional-change"
]'
```

---

### High-Risk Change Detection

Flag changes that need extra scrutiny:

```yaml
enabled_rules: '[
  "risky-migration",
  "security-change",
  "risky-code",
  "function-removed",
  "dependency-downgrade"
]'
```

---

## Advanced Integrations

### Auto-Assign Reviewers

```yaml
jobs:
  label:
    uses: workflow-kit/pr-auto-labeler@v0.0.1
    with:
      enabled_rules: '["ui-change", "security-change"]'
      
  assign-reviewers:
    needs: label
    runs-on: ubuntu-latest
    steps:
      - name: Assign frontend team
        if: contains(github.event.pull_request.labels.*.name, 'ui-change')
        uses: actions/github-script@v7
        with:
          script: |
            await github.rest.pulls.requestReviewers({
              ...context.repo,
              pull_number: context.issue.number,
              team_reviewers: ['frontend-team']
            })
            
      - name: Assign security team
        if: contains(github.event.pull_request.labels.*.name, 'security-change')
        uses: actions/github-script@v7
        with:
          script: |
            await github.rest.pulls.requestReviewers({
              ...context.repo,
              pull_number: context.issue.number,
              team_reviewers: ['security-team']
            })
```

---

### Block Risky Changes

Fail the workflow for dangerous patterns:

```yaml
jobs:
  label:
    uses: workflow-kit/pr-auto-labeler@v0.0.1
    with:
      enabled_rules: '["risky-code", "risky-migration"]'
      
  block-risky:
    needs: label
    runs-on: ubuntu-latest
    steps:
      - name: Check for risky patterns
        run: |
          if [[ "${{ contains(github.event.pull_request.labels.*.name, 'risky-code') }}" == "true" ]] ||
             [[ "${{ contains(github.event.pull_request.labels.*.name, 'risky-migration') }}" == "true" ]]; then
            echo "🚫 Risky changes detected - manual approval required"
            exit 1
          fi
```

---

### Trigger Specific Tests

Run tests based on labels:

```yaml
jobs:
  label:
    uses: workflow-kit/pr-auto-labeler@v0.0.1
    with:
      enabled_rules: '["ui-change", "migration"]'
      
  visual-tests:
    needs: label
    if: contains(github.event.pull_request.labels.*.name, 'ui-change')
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run visual regression tests
        run: npm run test:visual
        
  db-tests:
    needs: label
    if: contains(github.event.pull_request.labels.*.name, 'migration')
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run migration tests
        run: npm run test:migrations
```

---

## Real-World Scenarios

### Scenario 1: React Component Change

**PR Changes:**
```
src/components/Button.tsx (modified)
src/styles/button.css (modified)
```

**Configuration:**
```yaml
enabled_rules: '["ui-change", "test-missing"]'
```

**Result:**
- ✅ `ui-change` — Component file modified
- ✅ `test-missing` — No test file changes

---

### Scenario 2: Database Migration

**PR Changes:**
```sql
-- db/migrations/20240130_drop_column.sql
ALTER TABLE users DROP COLUMN legacy_id;
```

**Configuration:**
```yaml
enabled_rules: '["migration", "risky-migration", "schema-change"]'
```

**Result:**
- ✅ `migration` — Migration file detected
- ✅ `risky-migration` — DROP operation
- ✅ `schema-change` — ALTER TABLE

---

### Scenario 3: Security Fix

**PR Changes:**
```javascript
// src/auth/login.ts
- const token = eval(userInput); // Removed dangerous code
+ const token = jwt.sign(payload, secret);
```

**Configuration:**
```yaml
enabled_rules: '["security-change", "risky-code"]'
```

**Result:**
- ✅ `security-change` — Auth file modified
- ❌ `risky-code` — Not applied (eval was removed, not added)

---

[← Back to Overview](index.md){ .md-button }
[Troubleshooting →](troubleshooting.md){ .md-button }

