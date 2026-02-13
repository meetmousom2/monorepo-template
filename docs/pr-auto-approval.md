# PR Auto-Approval for Safe Changes

Auto-approve PRs that only touch test files or docs when CI passes. All other PRs require human review.

## How It Works

1. Branch protection requires **1 approval** (generic, not CODEOWNERS-specific) + CI to pass
2. CODEOWNERS triggers review requests from the right people for all PRs
3. A GitHub Action auto-approves PRs that only touch tests/docs after CI passes
4. The bot's approval counts as the 1 required approval for safe PRs
5. PRs touching source code still need a human to approve

## Setup

### 1. Branch Protection (GitHub UI)

Settings > Branches > Add rule for `main`:

| Setting | Value |
|---------|-------|
| Require a pull request before merging | Checked |
| Required approvals | 1 |
| Require review from Code Owners | **Unchecked** |
| Require status checks to pass | Checked (select your CI workflow) |

> **Why not "Require review from Code Owners"?** The auto-approve action uses `GITHUB_TOKEN`, which submits the approval as `github-actions[bot]`. That bot isn't in CODEOWNERS, so its approval wouldn't satisfy a CODEOWNERS requirement. By requiring only a generic approval, the bot's approval counts for safe PRs while humans still review everything else.

### 2. CODEOWNERS

CODEOWNERS still works — it controls who gets **requested** for review, even though the branch protection doesn't enforce CODEOWNERS-specific approval.

```
# .github/CODEOWNERS
*    @your-org/your-team
```

### 3. Auto-Approve Workflow

```yaml
# .github/workflows/auto-approve.yml
name: Auto Approve Safe PRs

on:
  workflow_run:
    workflows: ["CI"]
    types: [completed]

permissions:
  pull-requests: write

jobs:
  auto-approve:
    runs-on: ubuntu-latest
    if: github.event.workflow_run.conclusion == 'success'
    steps:
      - name: Get changed files
        id: changed
        uses: actions/github-script@v7
        with:
          script: |
            const pr = context.payload.workflow_run.pull_requests[0];
            if (!pr) return core.setOutput('safe', 'false');

            const files = await github.paginate(
              github.rest.pulls.listFiles,
              { owner: context.repo.owner, repo: context.repo.repo, pull_number: pr.number }
            );

            const safe = files.every(f =>
              f.filename.match(/^tests?\//) ||
              f.filename.match(/\.(md|txt|rst)$/) ||
              f.filename.match(/^docs\//)
            );

            core.setOutput('safe', String(safe));
            core.setOutput('pr_number', String(pr.number));

      - name: Auto approve
        if: steps.changed.outputs.safe == 'true'
        uses: hmarr/auto-approve-action@v4
        with:
          pull-request-number: ${{ steps.changed.outputs.pr_number }}
```

## What Happens

| PR changes | CI | Result |
|---|---|---|
| Only tests/docs | Passes | Bot auto-approves, mergeable immediately |
| Only tests/docs | Fails | No approval, blocked by CI |
| Source code | Passes | No auto-approval, team gets review request via CODEOWNERS, waits for human |
| Mixed (src + tests) | Passes | No auto-approval, needs human review |

## Customizing Safe Paths

Edit the `safe` check in the workflow to match your repo structure. For this monorepo, you might want:

```javascript
const safe = files.every(f =>
  f.filename.match(/^tests?\//) ||           // test directories
  f.filename.match(/\.test\.(ts|tsx|py)$/) || // test files anywhere
  f.filename.match(/_test\.py$/) ||           // python test files
  f.filename.match(/\.(md|txt|rst)$/) ||      // documentation files
  f.filename.match(/^docs\//) ||              // docs directory
  f.filename.match(/^e2e\//)                  // e2e tests
);
```
