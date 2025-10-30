# Security Rules

Flag security-sensitive code changes and potential vulnerabilities.

---

## Rules in this Category

| Rule Name | Label | Severity | Description |
|-----------|-------|----------|-------------|
| `security-change` | `security-change` | 🔴 High | Changes in security-sensitive areas |
| `risky-code` | `risky-code` | 🔴 High | Dangerous code patterns detected |

---

## `security-change`

Detects changes in security-sensitive code areas.

### Detection Logic

Flags changes to files/directories containing:

- `auth` / `authentication`
- `login` / `logout`
- `jwt` / `token`
- `oauth` / `saml`
- `crypto` / `encryption`
- `password` / `credential`
- `session` / `cookie`
- `security` / `permission`

### Use Cases

- 🔒 Require security team review
- 🔒 Extra scrutiny for auth changes
- 🔒 Compliance requirements
- 🔒 Audit trail for sensitive changes

### Examples

=== "Auth Module"

    **Changed Files:**
    ```
    src/auth/login.ts
    src/middleware/authentication.ts
    ```

    **Result:** 🔴 `security-change` label applied

=== "JWT Implementation"

    **Changed Files:**
    ```
    src/utils/jwt-helper.ts
    src/api/token-refresh.ts
    ```

    **Result:** 🔴 `security-change` label applied

=== "Password Handling"

    **Changed Files:**
    ```
    src/services/password-reset.ts
    ```

    **Result:** 🔴 `security-change` label applied

### Configuration

```yaml
enabled_rules: '["security-change"]'
```

### Workflow Integration

Require security team review:

```yaml
jobs:
  label:
    uses: workflow-kit/pr-auto-labeler@v0.0.1
    with:
      enabled_rules: '["security-change"]'
      
  notify-security-team:
    needs: label
    if: contains(github.event.pull_request.labels.*.name, 'security-change')
    runs-on: ubuntu-latest
    steps:
      - name: Notify Security Team
        uses: actions/github-script@v7
        with:
          script: |
            github.rest.issues.createComment({
              ...context.repo,
              issue_number: context.issue.number,
              body: '🔒 **Security Review Required** — @security-team please review'
            })
```

---

## `risky-code`

Detects potentially dangerous code patterns in diffs.

### Detection Patterns

Flags these risky APIs and patterns:

| Pattern | Risk | Reason |
|---------|------|--------|
| `eval(...)` | 🔴 Critical | Arbitrary code execution |
| `new Function(...)` | 🔴 Critical | Dynamic code generation |
| `child_process` | 🔴 High | Shell command execution |
| `exec(...)` / `spawn(...)` | 🔴 High | Process spawning |
| `dangerouslySetInnerHTML` | 🟡 Medium | XSS vulnerability |
| `document.write(...)` | 🟡 Medium | DOM manipulation |
| `crypto.createCipher` | 🟡 Medium | Deprecated crypto API |

### Use Cases

- 🚨 Block dangerous patterns
- 🚨 Security review required
- 🚨 Code audit needed
- 🚨 Alternative solution suggested

### Examples

=== "eval() Usage"

    ```javascript
    // ❌ Dangerous pattern detected
    const result = eval(userInput);
    ```

    **Result:** 🔴 `risky-code` label applied

=== "React XSS Risk"

    ```tsx
    // ❌ XSS vulnerability
    <div dangerouslySetInnerHTML={{__html: userContent}} />
    ```

    **Result:** 🔴 `risky-code` label applied

=== "Node.js Process Spawning"

    ```javascript
    // ❌ Command injection risk
    const { exec } = require('child_process');
    exec(`ls ${userInput}`);
    ```

    **Result:** 🔴 `risky-code` label applied

=== "Safe Alternative"

    ```javascript
    // ✅ Safe: no risky patterns
    const result = JSON.parse(userInput);
    ```

    **Result:** ❌ No `risky-code` label

### Configuration

```yaml
enabled_rules: '["risky-code"]'
```

### Automated Blocking

Block PRs with risky code using GitHub Actions:

```yaml
jobs:
  label:
    uses: workflow-kit/pr-auto-labeler@v0.0.1
    with:
      enabled_rules: '["risky-code"]'
      
  block-risky-code:
    needs: label
    if: contains(github.event.pull_request.labels.*.name, 'risky-code')
    runs-on: ubuntu-latest
    steps:
      - name: Block PR
        run: |
          echo "🚫 Risky code pattern detected - PR blocked"
          exit 1
```

---

## Combined Security Configuration

### Recommended Setup

```yaml
enabled_rules: '[
  "security-change",
  "risky-code",
  "potential-secret-leak",
  "risky-migration"
]'
```

### Security-First Workflow

Complete security-focused configuration:

```yaml
name: Security Checks

on:
  pull_request:
    types: [opened, synchronize, reopened]

permissions:
  contents: read
  pull-requests: write

jobs:
  security-labels:
    runs-on: ubuntu-latest
    uses: workflow-kit/pr-auto-labeler@v0.0.1
    with:
      enabled_rules: '[
        "security-change",
        "risky-code",
        "potential-secret-leak"
      ]'
      enable_debug: true
      
  security-scan:
    needs: security-labels
    if: |
      contains(github.event.pull_request.labels.*.name, 'security-change') ||
      contains(github.event.pull_request.labels.*.name, 'risky-code')
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run security scan
        run: npm run security:scan
        
  require-review:
    needs: security-labels
    if: |
      contains(github.event.pull_request.labels.*.name, 'security-change') ||
      contains(github.event.pull_request.labels.*.name, 'risky-code')
    runs-on: ubuntu-latest
    steps:
      - name: Request security review
        uses: actions/github-script@v7
        with:
          script: |
            await github.rest.pulls.requestReviewers({
              ...context.repo,
              pull_number: context.issue.number,
              reviewers: ['security-lead'],
              team_reviewers: ['security-team']
            })
```

---

## Best Practices

!!! success "Security Do's"
    ✅ Always enable both security rules  
    ✅ Require manual review for security labels  
    ✅ Use branch protection for security changes  
    ✅ Run automated security scans  
    ✅ Document security decisions in PR comments  
    ✅ Maintain a security incident response plan

!!! failure "Security Don'ts"
    ❌ Never bypass security review  
    ❌ Don't disable security rules to "move faster"  
    ❌ Don't merge without security team approval  
    ❌ Don't ignore `risky-code` warnings  
    ❌ Don't use eval() or similar patterns

---

## Troubleshooting

!!! question "False positives?"

    If legitimate code triggers `risky-code`:
    
    1. Document why the pattern is necessary in PR description
    2. Add security review comments
    3. Consider safer alternatives
    4. If no alternative exists, get explicit security team approval

!!! question "Pattern not detected?"

    Enable debug mode to see pattern matching:
    
    ```yaml
    enable_debug: true
    ```
    
    Check the workflow logs for pattern analysis results.

---

## Related Rules

- [**potential-secret-leak**](environment.md#potential-secret-leak) 🔐 — Detect leaked secrets
- [**risky-migration**](database.md#risky-migration) 🗄️ — Database security
- [**test-missing**](testing.md#test-missing) 🧪 — Ensure security tests

[← Back to Rules Overview](index.md){ .md-button }

