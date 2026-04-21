---
name: write-docs
description: Writes documentation for the current code changes and raises a PR to camunda/camunda-docs — or updates an existing docs PR if one is already open for this branch.
compatibility: Requires gh CLI with write access to camunda/camunda-docs
metadata:
  author: camunda
---

# Write Docs

## When to use

Use this skill when the current code changes need to be documented in the Camunda 8 public documentation at https://docs.camunda.io/. Typical triggers:

- New features, APIs, or configuration options have been added
- Existing behaviour has changed in a user-visible way
- The engineer asks to "write docs", "raise a docs PR", or "update the docs PR"

The skill creates a PR against `camunda/camunda-docs` on first run. On subsequent runs for the same source branch it updates the existing docs PR instead of opening a new one.

## Procedure

### 1. Understand the code changes

Collect the diff and recent commits on the current branch to understand what changed:

```bash
# Summary of changed files
git diff main --stat

# Full diff for context (pipe through head to avoid token overflow on large diffs)
git diff main -- . | head -500

# Recent commits on this branch
git log main..HEAD --oneline
```

Also read the PR description for the current branch if one exists:

```bash
gh pr view --json title,body,url 2>/dev/null || echo "No PR found for current branch"
```

Read any relevant source files touched by the diff to understand the full context of the change.

### 2. Identify what to document

Based on the diff, determine:
- **What** changed (new feature, config option, API endpoint, behaviour change, deprecation)
- **Which docs page(s)** should be updated — search the camunda-docs repo for existing coverage:

```bash
gh search code --repo camunda/camunda-docs "<relevant keyword>" --json path,url | head -20
```

If no existing page covers the topic, plan to create a new `.md` file in the appropriate `/docs/` subtree.

Consult the `/howtos/documentation-guidelines.md` in camunda-docs for naming and linking conventions:

```bash
gh api repos/camunda/camunda-docs/contents/howtos/documentation-guidelines.md \
  --jq '.content' | base64 -d | head -200
```

### 3. Check for an existing docs PR

Look for an open PR in `camunda/camunda-docs` that was previously opened for the same source branch or code PR. Use a consistent branch name derived from the current branch:

```bash
SOURCE_BRANCH=$(git rev-parse --abbrev-ref HEAD)
DOCS_BRANCH="docs/${SOURCE_BRANCH}"

# Check if that branch/PR already exists
gh pr list --repo camunda/camunda-docs --head "$DOCS_BRANCH" --json number,url,title
```

Capture whether a PR already exists — this determines whether step 6 creates or updates.

### 4. Clone or update the docs repo locally

Work in a temporary directory to avoid polluting the current workspace:

```bash
DOCS_DIR=$(mktemp -d)
gh repo clone camunda/camunda-docs "$DOCS_DIR" -- --depth 1 --quiet

cd "$DOCS_DIR"
git checkout -b "$DOCS_BRANCH" 2>/dev/null || git checkout "$DOCS_BRANCH"
```

If the branch already exists remotely, pull it so edits are applied on top:

```bash
git pull origin "$DOCS_BRANCH" --rebase 2>/dev/null || true
```

### 5. Write or update the documentation

Based on your analysis in steps 1–2, edit or create the relevant Markdown files in `$DOCS_DIR`.

**Writing guidelines (from camunda-docs conventions):**
- Place new files under `/docs/` (for the next/unreleased version) unless the change is already in a shipped release, in which case also update the matching `/versioned_docs/version-X.Y/` directory
- File names must be lowercase, hyphen-separated, and match the page title
- Internal links must use `.md` extension; use relative paths within the same subtree, absolute paths across subtrees (without a `/docs/` prefix)
- Images go in `/static/img/` (version-independent) or alongside the `.md` file (versioned)
- Do **not** use GIFs; prefer static images or React video components
- Keep prose objective, organised, clear, and directive (the four style goals from the style guide)
- Do not add front-matter beyond what is already present in surrounding pages

If the change adds or removes a page, update `sidebars.js` accordingly.

### 6. Commit the docs changes

```bash
cd "$DOCS_DIR"
git add -A
git commit -m "docs: document <short description of the code change>"
git push origin "$DOCS_BRANCH"
```

### 7. Create or update the docs PR

**If no PR exists yet** (from step 3), create one:

```bash
# Retrieve the source PR URL for cross-linking
SOURCE_PR_URL=$(gh pr view --json url -q .url 2>/dev/null || echo "")

gh pr create \
  --repo camunda/camunda-docs \
  --head "$DOCS_BRANCH" \
  --base main \
  --title "docs: <concise title matching the code change>" \
  --body "$(cat <<'EOF'
## Summary

<!-- One paragraph describing what this doc change covers and why it is needed -->

## Related

<!-- Link to the source code PR -->
${SOURCE_PR_URL}

## Checklist

- [ ] Prose follows the [technical writing style guide](https://github.com/camunda/camunda-docs/blob/main/howtos/technical-writing-styleguide.md)
- [ ] All internal links include `.md` extension
- [ ] New pages are added to `sidebars.js`
- [ ] Images have alt text
EOF
)"
```

**If a PR already exists**, push to the same branch (already done in step 6) and update its description if the scope changed:

```bash
EXISTING_PR=$(gh pr list --repo camunda/camunda-docs --head "$DOCS_BRANCH" \
  --json number -q '.[0].number')

gh pr edit "$EXISTING_PR" --repo camunda/camunda-docs \
  --body "$(cat <<'EOF'
## Summary

<!-- Updated: <date> — describe what was changed in this iteration -->

## Related

${SOURCE_PR_URL}

## Checklist

- [ ] Prose follows the [technical writing style guide](https://github.com/camunda/camunda-docs/blob/main/howtos/technical-writing-styleguide.md)
- [ ] All internal links include `.md` extension
- [ ] New pages are added to `sidebars.js`
- [ ] Images have alt text
EOF
)"
```

### 8. Report back

Output:
- The URL of the docs PR (created or updated)
- A brief bullet list of which files were changed and why
- Any open questions for the engineer (e.g. which versioned release the change targets, whether screenshots are needed)

Clean up the temporary directory:

```bash
rm -rf "$DOCS_DIR"
```
