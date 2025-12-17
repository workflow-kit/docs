# Frontend & UI Rules

Detect changes to user interface components and styling.

---

## Rules in this Category

| Rule Name | Label | Description |
|-----------|-------|-------------|
| `ui-change` | `ui-change` | Frontend component files modified |
| `style-change` | `style-change` | Style-only changes (no logic) |

---

## `ui-change`

Detects changes to frontend and UI component files.

### Detection Logic

Applies the `ui-change` label when any file with these extensions is modified:

- `.html` — HTML templates
- `.css` / `.scss` / `.sass` / `.less` — Stylesheets
- `.jsx` / `.tsx` — React components
- `.vue` — Vue components

### Use Cases

- ✅ Track all UI/frontend changes
- ✅ Route to frontend reviewers
- ✅ Trigger visual regression tests
- ✅ Monitor UI stability

### Configuration

=== "Enable Rule"

    ```yaml
    enabled_rules: '["ui-change"]'
    ```

=== "Custom Label"

    ```yaml
    enabled_rules: '["ui-change"]'
    label_overrides: '{
      "ui-change": "area/frontend"
    }'
    ```

### Examples

=== "React Component"

    **Changed Files:**
    ```
    src/components/Button.tsx
    src/components/Modal.tsx
    ```

    **Result:** ✅ `ui-change` label applied

=== "Vue Component"

    **Changed Files:**
    ```
    src/views/Dashboard.vue
    src/components/Chart.vue
    ```

    **Result:** ✅ `ui-change` label applied

=== "Mixed Changes"

    **Changed Files:**
    ```
    src/components/Header.tsx  ← UI file
    src/api/users.ts           ← Not UI
    ```

    **Result:** ✅ `ui-change` label applied (at least one UI file)

### Code Implementation

??? info "View Source Code"
    ```javascript
    module.exports = function uiChangeRule({ files, pr, enableDebug }) {
      const labels = [];
      const uiExtensions = ['.html', '.css', '.scss', '.sass', '.less', '.jsx', '.tsx', '.vue'];
      
      let hasUIChanges = false;
      
      for (const file of files) {
        if (!file.filename) continue;
        
        const filename = file.filename.toLowerCase();
        const ext = filename.substring(filename.lastIndexOf('.'));
        
        if (uiExtensions.includes(ext)) {
          hasUIChanges = true;
          if (enableDebug) {
            console.log(`[UI Change Rule] UI file detected: ${filename}`);
          }
          break;
        }
      }
      
      if (hasUIChanges) {
        labels.push('ui-change');
      }
      
      return labels;
    };
    ```

---

## `style-change`

Detects style-only changes (CSS/SCSS without JavaScript).

### Detection Logic

Applies the `style-change` label when:

1. **Only style files are changed** (`.css`, `.scss`, `.sass`, `.less`)
2. **No JavaScript/TypeScript files changed**

This rule helps identify purely cosmetic changes that don't affect logic.

### Use Cases

- ✅ Fast-track style-only PRs
- ✅ Skip logic-heavy reviews
- ✅ Identify low-risk changes
- ✅ Separate styling from functionality

### Configuration

=== "Enable Rule"

    ```yaml
    enabled_rules: '["style-change"]'
    ```

=== "Custom Label"

    ```yaml
    enabled_rules: '["style-change"]'
    label_overrides: '{
      "style-change": "cosmetic"
    }'
    ```

=== "Combine with UI Rule"

    ```yaml
    enabled_rules: '["ui-change", "style-change"]'
    ```

    - Both labels may apply if only CSS is changed
    - `ui-change` applies to all UI files
    - `style-change` applies only to pure CSS changes

### Examples

=== "Pure Style Change"

    **Changed Files:**
    ```
    src/styles/button.css
    src/styles/modal.scss
    ```

    **Result:** ✅ `style-change` label applied

=== "Style + Logic"

    **Changed Files:**
    ```
    src/styles/button.css
    src/components/Button.tsx  ← Logic file
    ```

    **Result:** ❌ `style-change` NOT applied (includes logic)

=== "Single CSS File"

    **Changed Files:**
    ```
    public/main.css
    ```

    **Result:** ✅ `style-change` label applied

---

## Common Patterns

### Frontend Team Workflow

Enable both rules to differentiate logic from styling:

```yaml
enabled_rules: '["ui-change", "style-change"]'
```

**Outcome:**

- Pure CSS changes → `ui-change` + `style-change`
- Component changes → `ui-change` only
- Mixed changes → `ui-change` only

### Visual Testing Integration

Trigger visual regression tests on UI changes:

```yaml
jobs:
  label:
    uses: workflow-kit/pr-auto-labeler/.github/workflows/pr-auto-labeler.yml@latest
    with:
      enabled_rules: '["ui-change"]'
      
  visual-tests:
    needs: label
    if: contains(github.event.pull_request.labels.*.name, 'ui-change')
    runs-on: ubuntu-latest
    steps:
      - name: Run visual regression tests
        run: npm run test:visual
```

### Require Frontend Review

Use GitHub branch protection to require reviews:

1. Enable `ui-change` rule
2. In repository settings → Branches → Branch protection
3. Add rule: "Require review from Code Owners"
4. Create `CODEOWNERS` file:

    ```text title="CODEOWNERS"
    # Require frontend team review for UI changes
    *.jsx @frontend-team
    *.tsx @frontend-team
    *.vue @frontend-team
    *.css @frontend-team
    *.scss @frontend-team
    ```

---

## Troubleshooting

!!! question "Rule not triggering?"

    **Check:**
    
    1. ✅ File extensions match (case-insensitive)
    2. ✅ Files are actually in the PR diff
    3. ✅ Enable debug mode to see detected files

!!! question "Both rules applying when I only want one?"

    - `ui-change` applies to **all** UI files (CSS + JS)
    - `style-change` applies **only** to CSS files without JS
    
    If you change only CSS, both rules will match. This is expected behavior.

---

## Related Rules

- [**test-missing**](testing.md#test-missing) 🧪 — Check if UI changes include tests
- [**dependency-change**](dependencies.md#dependency-change) 📦 — Track UI library updates
- [**refactor**](semantics.md#refactor) 🔄 — Detect UI refactoring

---

## Next Steps

- [← Back to Rules Overview](index.md)
- [View All Rule Categories](index.md#rule-categories)
- [See Usage Examples](../examples.md)

