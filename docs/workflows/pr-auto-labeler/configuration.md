# Configuration

Complete reference for all PR Auto-Labeler configuration options.

---

## Configuration Parameters

### `enabled_rules`

**Type:** JSON Array (string)  
**Required:** Yes  
**Default:** `[]`

List of rule names to enable. All rules are disabled by default.

```yaml
with:
  enabled_rules: '["ui-change", "test-missing", "large-pr"]'
```

!!! warning "Important"
    If `enabled_rules` is empty or not provided, **no labels will be applied**. You must explicitly enable the rules you want.

??? example "All Available Rules"
    ```yaml
    enabled_rules: '[
      "ui-change", "style-change",
      "migration", "risky-migration", "safe-migration", "schema-change",
      "env-change", "new-env-variable", "potential-secret-leak",
      "test-only-change", "test-missing", "test-improvement",
      "dependency-change", "new-dependency", "dependency-downgrade",
      "ci-change", "docker-change", "infra-change",
      "security-change", "risky-code",
      "function-removed", "new-feature", "non-functional-change", "refactor",
      "large-pr", "missing-description", "no-linked-issue", "work-in-progress"
    ]'
    ```

---

### `label_overrides`

**Type:** JSON Object (string)  
**Required:** No  
**Default:** `{}`

Override default label names with custom names.

```yaml
with:
  label_overrides: '{
    "ui-change": "frontend",
    "test-missing": "needs-tests",
    "large-pr": "size/large"
  }'
```

**Use Cases:**

- Match existing label conventions
- Use org-wide label standards
- Apply namespaced labels (e.g., `area/frontend`, `size/large`)

!!! tip "Label Name Requirements"
    Label names can contain alphanumeric characters, hyphens, underscores, and slashes. GitHub will create labels automatically if they don't exist.

---

### `large_pr_threshold`

**Type:** Number (string)  
**Required:** No  
**Default:** `500`

Number of changed lines that triggers the `large-pr` label.

```yaml
with:
  large_pr_threshold: '300'  # More strict
```

```yaml
with:
  large_pr_threshold: '1000'  # More lenient
```

**Recommended Values:**

| Team Type | Threshold | Rationale |
|-----------|-----------|-----------|
| Small teams | 300-400 | Encourage smaller, focused PRs |
| Medium teams | 500 | Balanced default |
| Large teams | 700-1000 | More flexibility for complex features |

---

### `enable_debug`

**Type:** Boolean (string)  
**Required:** No  
**Default:** `false`

Enable verbose debug logging in workflow output.

```yaml
with:
  enable_debug: true
```

**Debug Output Includes:**

- Files analyzed
- Rules evaluated
- Pattern matches found
- Labels applied
- Execution time per rule

!!! tip "When to Use Debug Mode"
    - Testing new rule configurations
    - Troubleshooting why labels aren't applied
    - Understanding rule behavior
    - Reporting issues

    **Disable in production** to reduce log verbosity.

---

## Complete Configuration Example

```yaml title=".github/workflows/pr-labeler.yml" linenums="1"
name: Auto Label PRs

on:
  pull_request:
    types: [opened, synchronize, reopened, ready_for_review]

permissions:
  contents: read
  pull-requests: write

jobs:
  label:
    runs-on: ubuntu-latest
    uses: workflow-kit/pr-auto-labeler/.github/workflows/pr-auto-labeler.yml@v0.0.1
    with:
      # Enable specific rules
      enabled_rules: '[
        "ui-change",
        "test-missing",
        "potential-secret-leak",
        "large-pr",
        "missing-description",
        "risky-code",
        "dependency-change"
      ]'
      
      # Custom label names
      label_overrides: '{
        "ui-change": "area/frontend",
        "test-missing": "needs-tests",
        "large-pr": "size/large",
        "missing-description": "needs-description"
      }'
      
      # Custom threshold for large PRs
      large_pr_threshold: '400'
      
      # Enable debug logging
      enable_debug: false
```

---

## Advanced Configuration

### Conditional Execution

Run the labeler only on specific conditions:

=== "Skip Draft PRs"

    ```yaml
    jobs:
      label:
        if: github.event.pull_request.draft == false
        uses: workflow-kit/pr-auto-labeler/.github/workflows/pr-auto-labeler.yml@v0.0.1
        with:
          enabled_rules: '["ui-change", "test-missing"]'
    ```

=== "Specific Branches Only"

    ```yaml
    on:
      pull_request:
        types: [opened, synchronize, reopened]
        branches:
          - main
          - develop
    ```

=== "Skip Dependabot PRs"

    ```yaml
    jobs:
      label:
        if: github.actor != 'dependabot[bot]'
        uses: workflow-kit/pr-auto-labeler/.github/workflows/pr-auto-labeler.yml@v0.0.1
        with:
          enabled_rules: '["ui-change"]'
    ```

### Multiple Configurations

Run different rule sets based on file paths:

```yaml
jobs:
  label-frontend:
    if: contains(github.event.pull_request.changed_files, 'frontend/')
    uses: workflow-kit/pr-auto-labeler/.github/workflows/pr-auto-labeler.yml@v0.0.1
    with:
      enabled_rules: '["ui-change", "style-change", "test-missing"]'
      
  label-backend:
    if: contains(github.event.pull_request.changed_files, 'backend/')
    uses: workflow-kit/pr-auto-labeler/.github/workflows/pr-auto-labeler.yml@v0.0.1
    with:
      enabled_rules: '["migration", "security-change", "test-missing"]'
```

---

## Environment Variables

PR Auto-Labeler uses these environment variables internally:

| Variable | Description | Set By |
|----------|-------------|--------|
| `GITHUB_TOKEN` | GitHub API token | Automatically by GitHub Actions |
| `ENABLED_RULES` | Enabled rules list | From `enabled_rules` input |
| `LABEL_OVERRIDES` | Custom label mappings | From `label_overrides` input |
| `LARGE_PR_THRESHOLD` | Large PR threshold | From `large_pr_threshold` input |
| `ENABLE_DEBUG` | Debug mode flag | From `enable_debug` input |

!!! note
    You don't need to set these manually — they're managed by the workflow.

---

## Rule Categories

Rules are organized into categories. Here's a quick reference:

| Category | Rule Count | Enable All |
|----------|------------|------------|
| Frontend & UI | 2 | `["ui-change", "style-change"]` |
| Database | 4 | `["migration", "risky-migration", "safe-migration", "schema-change"]` |
| Environment | 3 | `["env-change", "new-env-variable", "potential-secret-leak"]` |
| Testing | 3 | `["test-only-change", "test-missing", "test-improvement"]` |
| Dependencies | 3 | `["dependency-change", "new-dependency", "dependency-downgrade"]` |
| CI/CD | 3 | `["ci-change", "docker-change", "infra-change"]` |
| Security | 2 | `["security-change", "risky-code"]` |
| Semantics | 4 | `["function-removed", "new-feature", "non-functional-change", "refactor"]` |
| Metadata | 4 | `["large-pr", "missing-description", "no-linked-issue", "work-in-progress"]` |

[View Detailed Rules Reference →](rules/index.md){ .md-button }

---

## Best Practices

!!! success "Do's"
    ✅ Start with 3-5 essential rules  
    ✅ Enable debug mode when testing  
    ✅ Use label overrides for consistency  
    ✅ Group related rules together  
    ✅ Document your rule choices for the team

!!! failure "Don'ts"
    ❌ Don't enable all rules at once  
    ❌ Don't forget to set `enabled_rules`  
    ❌ Don't leave debug mode on in production  
    ❌ Don't use invalid JSON in arrays/objects  
    ❌ Don't skip the `pull-requests: write` permission

---

## Migration Guide

### From v0.0.1 to v1.0.0 (Future)

When v1.0.0 is released, update the version reference:

```yaml hl_lines="2"
uses: workflow-kit/pr-auto-labeler/.github/workflows/pr-auto-labeler.yml@v0.0.1
# Change to:
uses: workflow-kit/pr-auto-labeler/.github/workflows/pr-auto-labeler.yml@v1.0.0
```

Check the [Changelog](https://github.com/workflow-kit/pr-auto-labeler/releases) for breaking changes.

---

## Next Steps

- [:material-book-open-variant: Explore All Rules](rules/index.md)
- [:material-lightbulb-on: See Configuration Examples](examples.md)
- [:material-help-circle: Troubleshooting Guide](troubleshooting.md)

