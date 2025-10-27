

# Context Tree - Sources Directory Structure

## Sources Tree

**RUN:**
```bash
npx --yes tree-sitter-tree --dir Sources/ --gitignore || \
  (command -v tree > /dev/null && command -v git > /dev/null && \
    git ls-files --others --cached --exclude-standard --directory Sources/ | \
    sed 's|/[^/]*$|/|' | sort -u | xargs -I{} tree -a -I '.git' {} ) || \
  echo "No suitable tool found. Try installing 'tree' and 'git'."
```

## Tests Tree

**RUN:**
```bash
npx --yes tree-sitter-tree --dir Tests/ --gitignore || \
  (command -v tree > /dev/null && command -v git > /dev/null && \
    git ls-files --others --cached --exclude-standard --directory Tests/ | \
    sed 's|/[^/]*$|/|' | sort -u | xargs -I{} tree -a -I '.git' {} ) || \
  echo "No suitable tool found. Try installing 'tree' and 'git'."
```

## Package

**RUN:**

```bash
cat Package.swift
```
