# Troubleshooting

Common issues and solutions for PR Auto-Labeler.

---

## Labels Not Applied

### Issue: No labels appear on PR

**Possible Causes:**

1. **No rules enabled**
    ```yaml
    # ❌ Wrong - empty array
    enabled_rules: '[]'
    
    # ✅ Correct - enable rules
    enabled_rules: '["ui-change", "test-missing"]'
    ```

2. **Missing permissions**
    ```yaml
    # ✅ Required permission
    permissions:
      pull-requests: write
    ```

3. **Workflow not triggered**
    ```yaml
    # ✅ Ensure correct trigger
    on:
      pull_request:
        types: [opened, synchronize, reopened]
    ```

**Solution:** Enable debug mode to see what's happening:

```yaml
with:
  enabled_rules: '["ui-change"]'
  enable_debug: true
```

---

## Workflow Not Running

### Issue: Action doesn't execute at all

**Check:**

1. ✅ File location: `.github/workflows/pr-labeler.yml`
2. ✅ GitHub Actions enabled in repository settings
3. ✅ Valid YAML syntax (use a YAML validator)
4. ✅ PR opened (not just pushed to branch)

**Debug Steps:**

1. Go to **Actions** tab in repository
2. Check for workflow runs
3. Look for YAML syntax errors
4. Verify trigger conditions

---

## Specific Rules Not Working

### Issue: Some rules don't trigger

**Troubleshooting:**

1. **Check rule name spelling**
    ```yaml
    # ❌ Wrong
    enabled_rules: '["ui-changes"]'  # Note the 's'
    
    # ✅ Correct
    enabled_rules: '["ui-change"]'
    ```

2. **Verify file patterns match**
   
   Enable debug mode to see file analysis:
   ```yaml
   enable_debug: true
   ```

3. **Check JSON syntax**
    ```yaml
    # ❌ Wrong - missing quotes
    enabled_rules: '[ui-change, test-missing]'
    
    # ✅ Correct - proper JSON
    enabled_rules: '["ui-change", "test-missing"]'
    ```

---

## Permission Errors

### Issue: "Resource not accessible by integration"

**Solution:** Add required permissions:

```yaml
permissions:
  contents: read
  pull-requests: write  # Required for labeling
```

---

## Debug Mode

### Enable Detailed Logging

```yaml
with:
  enabled_rules: '["ui-change"]'
  enable_debug: true  # Enable verbose output
```

### What Debug Mode Shows

- ✅ Files analyzed
- ✅ Rules evaluated
- ✅ Pattern matches
- ✅ Labels applied
- ✅ Execution timing

### Example Debug Output

```
[UI Change Rule] Analyzing 5 files
[UI Change Rule] UI file detected: src/components/Button.tsx
[UI Change Rule] Labels to apply: ui-change
[Test Missing Rule] Source changed: src/components/Button.tsx
[Test Missing Rule] No test changes detected
[Test Missing Rule] Labels to apply: test-missing
✅ Applied labels: ui-change, test-missing
```

---

## Common Errors

### Invalid JSON

```yaml
# ❌ Wrong
enabled_rules: '["ui-change", "test-missing",]'  # Trailing comma

# ✅ Correct
enabled_rules: '["ui-change", "test-missing"]'
```

### Wrong Quotation

```yaml
# ❌ Wrong - unescaped quotes
label_overrides: '{"ui-change": "frontend"}'  # May fail in some YAML parsers

# ✅ Correct - use single quotes for JSON string
label_overrides: '{"ui-change": "frontend"}'
```

---

## FAQ

??? question "Can I use custom label colors?"

    Labels are created automatically by GitHub with default colors. To customize:
    
    1. Create labels manually with desired colors
    2. PR Auto-Labeler will use existing labels

??? question "How do I disable a rule temporarily?"

    Remove it from `enabled_rules`:
    
    ```yaml
    # Before
    enabled_rules: '["ui-change", "test-missing"]'
    
    # After (test-missing disabled)
    enabled_rules: '["ui-change"]'
    ```

??? question "Can I run the action locally?"

    The action requires GitHub context. For local testing:
    
    1. Use [act](https://github.com/nektos/act) to simulate GitHub Actions
    2. Or test directly on a test repository

??? question "Does it work with forks?"

    Yes, but permissions depend on repository settings. For forks:
    
    - Same organization: Usually works
    - External forks: May need approval for first-time contributors

??? question "What's the performance impact?"

    - Average run time: 2-5 seconds
    - No impact on PR creation speed
    - Runs asynchronously after PR is opened

---

## Getting Help

If you're still experiencing issues:

1. **Check debug logs** with `enable_debug: true`
2. **Search existing issues** on [GitHub Issues](https://github.com/workflow-kit/pr-auto-labeler/issues)
3. **Ask in Discussions** at [GitHub Discussions](https://github.com/workflow-kit/pr-auto-labeler/discussions)
4. **Open a new issue** with:
   - Workflow configuration
   - Debug logs
   - PR link (if public)
   - Expected vs actual behavior

---

[← Back to Overview](index.md){ .md-button }
[Configuration Guide →](configuration.md){ .md-button }

