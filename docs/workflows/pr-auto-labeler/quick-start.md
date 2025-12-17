# Quick Start

Get PR Auto-Labeler running in your repository in under 5 minutes.

---

## Prerequisites

- GitHub repository with Actions enabled
- Permissions to create workflow files

!!! info "No Installation Required"
    PR Auto-Labeler is a reusable workflow — no separate installation needed!

---

## Step 1: Create Workflow File

Create a new file in your repository:

```
.github/workflows/pr-labeler.yml
```

Add the following configuration:

```yaml title=".github/workflows/pr-labeler.yml" linenums="1"
name: Auto Label PRs

on:
  pull_request:
    types: [opened, synchronize, reopened] # (1)!

permissions:
  contents: read # (2)!
  pull-requests: write # (3)!

jobs:
  label:
    uses: workflow-kit/pr-auto-labeler/.github/workflows/pr-auto-labeler.yml@latest # (4)!
    with:
      enabled_rules: '["ui-change", "test-missing", "large-pr"]' # (5)!
```

1.  Trigger on PR open, update, or reopen
2.  Read access to repository contents
3.  **Required:** Write access to apply labels
4.  Reference the reusable workflow
5.  Enable specific rules (all disabled by default)

---

## Step 2: Commit and Push

```bash
git add .github/workflows/pr-labeler.yml
git commit -m "Add PR auto-labeler workflow"
git push origin main
```

---

## Step 3: Test It Out

Create a test pull request:

=== "Option 1: Quick Test PR"

    ```bash
    # Create a new branch
    git checkout -b test-pr-labeler
    
    # Make a change to a frontend file
    echo "console.log('test');" >> src/App.tsx
    
    # Commit and push
    git add src/App.tsx
    git commit -m "Test PR Auto-Labeler"
    git push origin test-pr-labeler
    ```

    Create the PR on GitHub. You should see:
    - ✅ `ui-change` label applied
    - ✅ `test-missing` label (if no test changes)

=== "Option 2: Large PR Test"

    Create a PR with more than 500 lines changed, and it will get the `large-pr` label automatically.

=== "Option 3: Check Workflow Logs"

    1. Go to **Actions** tab in your repository
    2. Find the "Auto Label PRs" workflow run
    3. Click on it to view execution logs
    4. See which rules were evaluated and which labels were applied

---

## Verify It Works

After creating your test PR, check:

1. **Labels Applied** — Look at your PR, labels should appear automatically
2. **Workflow Run** — Go to Actions tab, verify the workflow completed successfully
3. **Debug Logs** — Check workflow logs to see which rules were evaluated

!!! success "Success Indicators"
    ✅ Workflow status is green  
    ✅ Labels appear on your PR  
    ✅ Logs show `Applied labels: [...]`

---

## Common Starting Configurations

Choose a preset based on your team's needs:

=== "Frontend Team"

    ```yaml
    enabled_rules: '[
      "ui-change",
      "style-change",
      "test-missing",
      "dependency-change"
    ]'
    ```

=== "Backend Team"

    ```yaml
    enabled_rules: '[
      "migration",
      "risky-migration",
      "test-missing",
      "security-change",
      "new-dependency"
    ]'
    ```

=== "Full-Stack Team"

    ```yaml
    enabled_rules: '[
      "ui-change",
      "test-missing",
      "dependency-change",
      "large-pr",
      "missing-description"
    ]'
    ```

=== "Security-Focused"

    ```yaml
    enabled_rules: '[
      "potential-secret-leak",
      "security-change",
      "risky-code",
      "risky-migration",
      "dependency-downgrade"
    ]'
    ```

=== "DevOps/Platform"

    ```yaml
    enabled_rules: '[
      "ci-change",
      "docker-change",
      "infra-change",
      "env-change"
    ]'
    ```

---

## Troubleshooting

!!! warning "Labels Not Applied?"

    **Check these common issues:**

    1. ✅ Workflow file is in `.github/workflows/` directory
    2. ✅ `permissions.pull-requests: write` is set
    3. ✅ `enabled_rules` is not empty (all rules disabled by default!)
    4. ✅ GitHub Actions is enabled in repository settings

    **Still not working?** Enable debug mode:

    ```yaml
    with:
      enabled_rules: '["ui-change"]'
      enable_debug: true  # Add this line
    ```

    Then check the workflow logs for detailed output.

!!! tip "Workflow Not Running?"

    Verify the `on:` trigger is correct:

    ```yaml
    on:
      pull_request:
        types: [opened, synchronize, reopened]
    ```

    PRs from forks may require additional permissions configuration.

---

## Next Steps

Now that you have the basics working:

- [⚙️ Learn All Configuration Options](configuration.md)
- [📖 Explore All Available Rules](rules/index.md)
- [💡 See Real-World Examples](examples.md)
- [❓ View Troubleshooting Guide](troubleshooting.md)

---

!!! question "Need Help?"
    If you run into issues:
    
    1. Check the [Troubleshooting Guide](troubleshooting.md)
    2. Search [GitHub Discussions](https://github.com/workflow-kit/pr-auto-labeler/discussions)
    3. Open an [Issue](https://github.com/workflow-kit/pr-auto-labeler/issues) with debug logs

