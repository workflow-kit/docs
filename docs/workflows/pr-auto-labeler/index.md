# PR Auto-Labeler

> Automatically label your pull requests based on code changes, patterns, and metadata

---

## Overview

**PR Auto-Labeler** is a GitHub Action that intelligently labels pull requests by analyzing:

- 📁 **Changed files** — Detect frontend, backend, database, config changes
- 🔍 **Code patterns** — Find risky code, security issues, missing tests
- 📊 **PR metadata** — Check size, description quality, linked issues
- 🎯 **Custom rules** — Enable only the rules you need

## Why Use It?

<div class="grid cards" markdown>

-   :material-clock-fast:{ .lg .middle } __Save Time__

    ---

    Stop manually labeling PRs. Let automation handle it while you focus on code review.

-   :material-shield-check:{ .lg .middle } __Catch Issues Early__

    ---

    Flag risky code, missing tests, and security concerns before they reach production.

-   :material-chart-line:{ .lg .middle } __Improve Visibility__

    ---

    See at a glance what each PR changes — frontend, backend, database, tests, etc.

-   :material-cog:{ .lg .middle } __Highly Customizable__

    ---

    Choose from 30+ rules. Enable only what your team needs. Override label names to match your workflow.

</div>

---

## Features

### 🎯 Smart Labeling Rules

Choose from 30+ intelligent rules organized by category:

| Category | Rules | Example Labels |
|----------|-------|----------------|
| **Frontend & UI** | 2 rules | `ui-change`, `style-change` |
| **Database** | 4 rules | `migration`, `risky-migration`, `safe-migration` |
| **Testing** | 3 rules | `test-missing`, `test-only-change` |
| **Security** | 2 rules | `security-change`, `risky-code` |
| **Dependencies** | 3 rules | `dependency-change`, `new-dependency` |
| **CI/CD** | 3 rules | `ci-change`, `docker-change`, `infra-change` |
| **Environment** | 3 rules | `env-change`, `potential-secret-leak` |
| **Code Semantics** | 4 rules | `new-feature`, `refactor`, `function-removed` |
| **PR Metadata** | 4 rules | `large-pr`, `missing-description`, `work-in-progress` |

[View All Rules →](rules/index.md){ .md-button }

### ⚡ Zero-Config Defaults

All rules are **disabled by default** — you explicitly enable only what you need:

```yaml
enabled_rules: '["ui-change", "test-missing", "large-pr"]'
```

### 🎨 Custom Label Names

Override default labels to match your existing workflow:

```yaml
label_overrides: '{
  "ui-change": "frontend",
  "test-missing": "needs-tests"
}'
```

### 🐛 Debug Mode

Enable detailed logging to understand exactly what the action is doing:

```yaml
enable_debug: true
```

---

## Quick Example

=== "Workflow File"

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
          enabled_rules: '["ui-change", "test-missing", "large-pr"]'
    ```

=== "Result"

    When a PR changes `Button.tsx` without test changes:

    **Applied Labels:**
    
    - 🟢 `ui-change` — Frontend component modified
    - 🔴 `test-missing` — No test changes detected

---

## Next Steps

<div class="grid" markdown>

=== "🚀 Quick Start"

    Get up and running in 5 minutes

    [Quick Start Guide →](quick-start.md)

=== "⚙️ Configuration"

    Learn all configuration options

    [Configuration Guide →](configuration.md)

=== "📖 Rules Reference"

    Explore all 30+ available rules

    [Rules Reference →](rules/index.md)

=== "💡 Examples"

    See real-world usage examples

    [Usage Examples →](examples.md)

</div>

---

!!! tip "Need Help?"
    - [:material-book-open: Browse Documentation](quick-start.md)
    - [:material-chat: Ask in Discussions](https://github.com/workflow-kit/pr-auto-labeler/discussions)
    - [:material-bug: Report an Issue](https://github.com/workflow-kit/pr-auto-labeler/issues)

