# Database Rules

Track database migrations and schema changes.

---

## Rules in this Category

| Rule Name | Label | Risk Level | Description |
|-----------|-------|------------|-------------|
| `migration` | `migration` | 🔵 Info | Any migration file modified |
| `risky-migration` | `risky-migration` | 🔴 High | Destructive operations (DROP, TRUNCATE) |
| `safe-migration` | `safe-migration` | 🟢 Low | Additive operations (CREATE, INSERT) |
| `schema-change` | `schema-change` | 🟡 Medium | Schema modifications (ALTER, MODIFY) |

---

## `migration`

Detects any database migration file changes.

### Detection

Matches files in migration directories:

- `migrations/`
- `db/migrations/`
- `database/migrations/`

### Example

```yaml
enabled_rules: '["migration"]'
```

**Changed Files:**
```
db/migrations/20240130_create_users.sql
```

**Result:** ✅ `migration` label applied

---

## `risky-migration`

Flags **destructive** database operations.

### Detection Patterns

Detects these SQL operations:

- `DROP TABLE`
- `DROP COLUMN`
- `TRUNCATE TABLE`
- `ALTER TABLE ... DROP`
- `DROP INDEX`
- `DROP CONSTRAINT`

### Use Cases

- 🚨 Require senior engineer review
- 🚨 Extra testing before production
- 🚨 Backup verification
- 🚨 Rollback plan required

### Example

=== "Risky Operation"

    ```sql title="db/migrations/20240130_drop_table.sql"
    -- Risky: drops entire table
    DROP TABLE old_users;
    ```

    **Result:** 🔴 `risky-migration` label applied

=== "Safe with Conditional"

    ```sql title="db/migrations/20240130_safe_drop.sql"
    -- Still flagged as risky
    DROP TABLE IF EXISTS temp_table;
    ```

    **Result:** 🔴 `risky-migration` label applied (still destructive)

### Configuration

```yaml
enabled_rules: '["migration", "risky-migration"]'
```

!!! warning "Require Manual Review"
    Use branch protection rules to require additional reviews when `risky-migration` is applied.

---

## `safe-migration`

Identifies **additive** database operations.

### Detection Patterns

- `CREATE TABLE`
- `CREATE INDEX`
- `INSERT INTO`
- `ADD COLUMN`
- `ADD CONSTRAINT`

### Use Cases

- ✅ Fast-track safe migrations
- ✅ Lower review requirements
- ✅ Identify non-breaking changes

### Example

```sql title="db/migrations/20240130_add_column.sql"
ALTER TABLE users
ADD COLUMN email_verified BOOLEAN DEFAULT FALSE;
```

**Result:** 🟢 `safe-migration` label applied

---

## `schema-change`

Detects schema modifications.

### Detection Patterns

- `ALTER TABLE`
- `MODIFY COLUMN`
- `RENAME COLUMN`
- `CHANGE COLUMN`

### Example

```sql title="db/migrations/20240130_modify_column.sql"
ALTER TABLE users
MODIFY COLUMN email VARCHAR(500);
```

**Result:** 🟡 `schema-change` label applied

---

## Combined Usage

### Recommended Configuration

```yaml
enabled_rules: '[
  "migration",
  "risky-migration",
  "safe-migration",
  "schema-change"
]'
```

**Outcome:**

| SQL Operation | Labels Applied |
|---------------|----------------|
| `CREATE TABLE users` | `migration`, `safe-migration` |
| `DROP TABLE users` | `migration`, `risky-migration` |
| `ALTER TABLE users MODIFY email` | `migration`, `schema-change` |
| `INSERT INTO users ...` | `migration`, `safe-migration` |

### Workflow Integration

```yaml
jobs:
  label:
    uses: workflow-kit/pr-auto-labeler@v0.0.1
    with:
      enabled_rules: '["risky-migration"]'
      
  require-dba-review:
    needs: label
    if: contains(github.event.pull_request.labels.*.name, 'risky-migration')
    runs-on: ubuntu-latest
    steps:
      - name: Request DBA Review
        run: echo "🚨 Risky migration detected - DBA review required"
```

---

## Troubleshooting

!!! question "Migration file not detected?"

    **Check:**
    
    1. File path includes `migrations/` directory
    2. File is actually changed in the PR diff
    3. Enable debug mode to see file analysis

!!! question "Comments in SQL triggering false positives?"

    The rules ignore SQL comments:
    
    - `-- single line comments`
    - `/* block comments */`
    
    If you're seeing false positives, please [report it](https://github.com/workflow-kit/pr-auto-labeler/issues).

---

## Best Practices

!!! success "Do's"
    ✅ Always enable `risky-migration` for safety  
    ✅ Combine with `test-missing` to ensure tests  
    ✅ Use branch protection for risky migrations  
    ✅ Document migration rollback procedures

!!! failure "Don'ts"
    ❌ Don't skip review for `risky-migration`  
    ❌ Don't run risky migrations in peak hours  
    ❌ Don't forget database backups  

---

## Related Rules

- [**test-missing**](testing.md#test-missing) 🧪 — Ensure migrations have tests
- [**security-change**](security.md#security-change) 🔒 — Sensitive data access
- [**large-pr**](meta.md#large-pr) 📄 — Large migration files

[← Back to Rules Overview](index.md){ .md-button }

