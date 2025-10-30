# Rules Reference

Complete guide to all 30+ labeling rules available in PR Auto-Labeler.

---

## Overview

Rules are organized into **9 categories** based on what they detect. Each rule:

- ✅ Is **disabled by default** — you explicitly enable what you need
- 🎯 Has a **specific purpose** — detects one type of change
- 🏷️ Applies **one or more labels** — can be customized
- 📊 Includes **detailed detection logic** — transparent and predictable

!!! tip "How to Choose Rules"
    **Start small:** Enable 3-5 rules that matter most to your team  
    **Test first:** Use debug mode to see how rules behave  
    **Expand gradually:** Add more rules as you see value

---

## Rule Categories

<div class="grid cards" markdown>

-   :material-palette:{ .lg .middle } __Frontend & UI__

    ---

    Detect changes to UI components and styles

    **2 rules** | [View Details →](frontend.md)

-   :material-database:{ .lg .middle } __Database__

    ---

    Track migrations and schema changes

    **4 rules** | [View Details →](database.md)

-   :material-cog:{ .lg .middle } __Environment & Config__

    ---

    Monitor configuration and environment changes

    **3 rules** | [View Details →](environment.md)

-   :material-test-tube:{ .lg .middle } __Testing__

    ---

    Ensure test coverage and quality

    **3 rules** | [View Details →](testing.md)

-   :material-package:{ .lg .middle } __Dependencies__

    ---

    Track dependency additions and updates

    **3 rules** | [View Details →](dependencies.md)

-   :material-cloud:{ .lg .middle } __CI/CD & Infrastructure__

    ---

    Monitor infrastructure and deployment configs

    **3 rules** | [View Details →](infrastructure.md)

-   :material-shield-lock:{ .lg .middle } __Security__

    ---

    Flag security-sensitive changes

    **2 rules** | [View Details →](security.md)

-   :material-code-braces:{ .lg .middle } __Code Semantics__

    ---

    Detect feature additions, refactors, and breaking changes

    **4 rules** | [View Details →](semantics.md)

-   :material-file-document:{ .lg .middle } __PR Metadata__

    ---

    Check PR size, description, and metadata quality

    **4 rules** | [View Details →](meta.md)

</div>

---

## Quick Reference

### All Rules at a Glance

=== "Frontend & UI (2)"

    | Rule | Label | Detection |
    |------|-------|-----------|
    | `ui-change` | `ui-change` | `.jsx`, `.tsx`, `.vue`, `.html` files |
    | `style-change` | `style-change` | `.css`, `.scss`, `.sass` only (no JS) |

    [Learn More →](frontend.md)

=== "Database (4)"

    | Rule | Label | Detection |
    |------|-------|-----------|
    | `migration` | `migration` | Files in `migrations/` directories |
    | `risky-migration` | `risky-migration` | `DROP`, `TRUNCATE` operations |
    | `safe-migration` | `safe-migration` | `CREATE`, `INSERT`, `ADD` operations |
    | `schema-change` | `schema-change` | `ALTER`, `MODIFY COLUMN` operations |

    [Learn More →](database.md)

=== "Environment (3)"

    | Rule | Label | Detection |
    |------|-------|-----------|
    | `env-change` | `env-change` | `.env`, `config.yml`, `config.json` |
    | `new-env-variable` | `new-env-variable` | New vars in diffs |
    | `potential-secret-leak` | `potential-secret-leak` | `API_KEY`, `PASSWORD`, `SECRET` |

    [Learn More →](environment.md)

=== "Testing (3)"

    | Rule | Label | Detection |
    |------|-------|-----------|
    | `test-only-change` | `test-only-change` | Only test files changed |
    | `test-missing` | `test-missing` | Code changed, no test changes |
    | `test-improvement` | `test-improvement` | Tests + code changed |

    [Learn More →](testing.md)

=== "Dependencies (3)"

    | Rule | Label | Detection |
    |------|-------|-----------|
    | `dependency-change` | `dependency-change` | `package.json`, `requirements.txt`, etc. |
    | `new-dependency` | `new-dependency` | New packages added |
    | `dependency-downgrade` | `dependency-downgrade` | Version downgraded |

    [Learn More →](dependencies.md)

=== "CI/CD & Infra (3)"

    | Rule | Label | Detection |
    |------|-------|-----------|
    | `ci-change` | `ci-change` | `.github/workflows/`, `.gitlab-ci.yml` |
    | `docker-change` | `docker-change` | `Dockerfile`, `docker-compose.yml` |
    | `infra-change` | `infra-change` | Terraform, Kubernetes, Helm configs |

    [Learn More →](infrastructure.md)

=== "Security (2)"

    | Rule | Label | Detection |
    |------|-------|-----------|
    | `security-change` | `security-change` | Auth, crypto, JWT, OAuth changes |
    | `risky-code` | `risky-code` | `eval`, `exec`, `dangerouslySetInnerHTML` |

    [Learn More →](security.md)

=== "Code Semantics (4)"

    | Rule | Label | Detection |
    |------|-------|-----------|
    | `function-removed` | `function-removed` | Functions/classes deleted |
    | `new-feature` | `new-feature` | New files, "feat:" commits |
    | `non-functional-change` | `non-functional-change` | Docs/text only |
    | `refactor` | `refactor` | Multiple renames, restructuring |

    [Learn More →](semantics.md)

=== "PR Metadata (4)"

    | Rule | Label | Detection |
    |------|-------|-----------|
    | `large-pr` | `large-pr` | >500 lines changed (configurable) |
    | `missing-description` | `missing-description` | PR description <30 chars |
    | `no-linked-issue` | `no-linked-issue` | No "Closes #123" or "Fixes #456" |
    | `work-in-progress` | `work-in-progress` | Draft PR or "WIP"/"DNM" in title |

    [Learn More →](meta.md)

---

## Common Rule Combinations

### 🎨 Frontend Team

Focus on UI changes, testing, and dependencies:

```yaml
enabled_rules: '[
  "ui-change",
  "style-change",
  "test-missing",
  "dependency-change"
]'
```

### 🗄️ Backend Team

Track database, security, and testing:

```yaml
enabled_rules: '[
  "migration",
  "risky-migration",
  "test-missing",
  "security-change",
  "new-dependency"
]'
```

### 🔒 Security-Focused

Flag all security-related changes:

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

### ⚙️ DevOps Team

Monitor infrastructure and CI/CD:

```yaml
enabled_rules: '[
  "ci-change",
  "docker-change",
  "infra-change",
  "env-change",
  "dependency-change"
]'
```

### 📊 Quality Enforcement

Enforce PR quality standards:

```yaml
enabled_rules: '[
  "large-pr",
  "test-missing",
  "missing-description",
  "no-linked-issue",
  "work-in-progress"
]'
```

---

## Rule Behavior

### Detection Logic

Each rule:

1. **Analyzes PR data** — Changed files, diffs, metadata
2. **Applies detection patterns** — File paths, content patterns, PR properties
3. **Returns labels** — List of labels to apply (can be empty)
4. **Logs activity** — When debug mode is enabled

### Label Application

- Labels are **applied cumulatively** — multiple rules can add labels
- Labels are **added, not replaced** — existing labels remain
- Labels are **created automatically** — if they don't exist in the repo
- Labels can be **customized** — via `label_overrides`

### Performance

- All rules run in **parallel** where possible
- Average execution time: **2-5 seconds** for typical PRs
- Rules are **stateless** — no side effects or dependencies

---

## Customization

### Override Label Names

Match your team's existing label conventions:

```yaml
label_overrides: '{
  "ui-change": "area/frontend",
  "test-missing": "needs-tests",
  "large-pr": "size/XL",
  "security-change": "security-review-required"
}'
```

### Adjust Thresholds

Customize the large PR threshold:

```yaml
large_pr_threshold: '300'  # Default is 500
```

---

## Debug Mode

Enable detailed logging to understand rule execution:

```yaml
enable_debug: true
```

**Debug output includes:**

- Files being analyzed
- Rules being evaluated
- Pattern matches found
- Labels being applied
- Execution time per rule

!!! example "Debug Output Example"
    ```
    [UI Change Rule] UI file detected: src/components/Button.tsx
    [UI Change Rule] Labels to apply: ui-change
    [Test Missing Rule] Source changed: src/components/Button.tsx
    [Test Missing Rule] No test changes detected
    [Test Missing Rule] Labels to apply: test-missing
    ✅ Applied labels: ui-change, test-missing
    ```

---

## Next Steps

Explore detailed documentation for each rule category:

1. [:material-palette: Frontend & UI Rules](frontend.md)
2. [:material-database: Database Rules](database.md)
3. [:material-cog: Environment & Config Rules](environment.md)
4. [:material-test-tube: Testing Rules](testing.md)
5. [:material-package: Dependency Rules](dependencies.md)
6. [:material-cloud: CI/CD & Infrastructure Rules](infrastructure.md)
7. [:material-shield-lock: Security Rules](security.md)
8. [:material-code-braces: Code Semantics Rules](semantics.md)
9. [:material-file-document: PR Metadata Rules](meta.md)

Or jump to:

- [:material-lightbulb-on: Usage Examples](../examples.md)
- [:material-cog: Configuration Guide](../configuration.md)
- [:material-help-circle: Troubleshooting](../troubleshooting.md)

