# Getting Started

Welcome to **workflow-kit** — your collection of production-ready GitHub Actions workflows.

---

## What is workflow-kit?

workflow-kit provides battle-tested, reusable GitHub Actions workflows that automate common development tasks. Each workflow is:

- ⚡ **Easy to integrate** — Setup in minutes
- 🔧 **Fully customizable** — Configure to your needs
- 📚 **Well-documented** — Comprehensive guides
- 🚀 **Production-ready** — Used by teams worldwide

---

## Available Workflows

### 🏷️ PR Auto-Labeler

Automatically label pull requests based on code changes, patterns, and metadata.

**Quick Example:**

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
    uses: workflow-kit/pr-auto-labeler/.github/workflows/pr-auto-labeler.yml@v0.0.1
    with:
      enabled_rules: '["ui-change", "test-missing", "large-pr"]'
```

[Get Started with PR Auto-Labeler →](workflows/pr-auto-labeler/quick-start.md){ .md-button .md-button--primary }

---

## Quick Start

=== "Step 1: Choose a Workflow"

    Browse available workflows and choose one that fits your needs.
    
    [:material-tag-multiple: PR Auto-Labeler](workflows/pr-auto-labeler/index.md)

=== "Step 2: Add Workflow File"

    Create `.github/workflows/` directory and add the workflow YAML file.
    
    ```bash
    mkdir -p .github/workflows
    # Copy workflow configuration
    ```

=== "Step 3: Configure"

    Customize the workflow configuration to match your team's needs.
    
    - Enable specific rules
    - Set custom labels
    - Adjust thresholds

=== "Step 4: Test"

    Create a test PR and verify the workflow runs correctly.
    
    Check the Actions tab for execution logs.

---

## Why Use workflow-kit?

<div class="grid cards" markdown>

-   :material-clock-fast:{ .lg .middle } __Save Time__

    ---

    Automate repetitive tasks and focus on what matters — writing code and reviewing PRs.

-   :material-shield-check:{ .lg .middle } __Improve Quality__

    ---

    Catch issues early with automated checks before they reach production.

-   :material-chart-line:{ .lg .middle } __Better Visibility__

    ---

    Get instant insights into PR content with automated labeling and analysis.

-   :material-account-group:{ .lg .middle } __Team Consistency__

    ---

    Standardize processes across repositories and ensure everyone follows best practices.

</div>

---

## Next Steps

1. [:rocket: Explore PR Auto-Labeler](workflows/pr-auto-labeler/index.md)
2. [:books: Read the Documentation](workflows/pr-auto-labeler/quick-start.md)
3. [:bulb: See Usage Examples](workflows/pr-auto-labeler/examples.md)
4. [:material-github: Star on GitHub](https://github.com/workflow-kit)

---

## Support

Need help? We're here for you:

- [:material-book-open: Documentation](workflows/pr-auto-labeler/index.md)
- [:material-chat: GitHub Discussions](https://github.com/workflow-kit/pr-auto-labeler/discussions)
- [:material-bug: Report Issues](https://github.com/workflow-kit/pr-auto-labeler/issues)
