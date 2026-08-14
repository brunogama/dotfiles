#!/usr/bin/env bash
# shellcheck shell=bash

set -euo pipefail

# shellcheck source=/dev/null
source "$HOME/.local/bin/prints"

sequence_editor="$(mktemp)"
trap 'rm -f "$sequence_editor"' EXIT
cat >"$sequence_editor" <<'EDITOR'
#!/usr/bin/awk -f
BEGIN { previous_subject = "" }
/^(pick|reword|edit|squash|fixup|drop) / {
    subject = $0
    sub(/^[^ ]+ [^ ]+ /, "", subject)
    if (subject == previous_subject) {
        sub(/^[^ ]+/, "squash")
    }
    previous_subject = subject
}
{ print }
EDITOR
chmod +x "$sequence_editor"

for ((i = 0; i < 30; i++)); do
	commit_name="$(git log --first-parent --format=%s -n 1 --skip="$i")"
	next_commit_name="$(git log --first-parent --format=%s -n 1 --skip="$((i + 1))")"

	[[ -z "$next_commit_name" ]] && break

	if [[ "$commit_name" == "$next_commit_name" ]]; then
		# Check if the calculated ancestor exists; use --root if it doesn't
		if git rev-parse --verify "HEAD~$((i + 2))" >/dev/null 2>&1; then
			GIT_SEQUENCE_EDITOR="$sequence_editor" git rebase -i "HEAD~$((i + 2))"
		else
			GIT_SEQUENCE_EDITOR="$sequence_editor" git rebase -i --root
		fi
		break
	fi
done

branch_name="$(git branch --show-current)"
upstream_remote="$(git config "branch.$branch_name.remote" || true)"
upstream_ref="$(git config "branch.$branch_name.merge" || true)"

if [[ -z "$upstream_remote" || -z "$upstream_ref" ]]; then
	echo "Current branch has no configured upstream" >&2
	exit 1
fi

upstream_branch="${upstream_ref#refs/heads/}"
git push "$upstream_remote" "$branch_name:$upstream_branch" --force-with-lease
pgreen "Adjacent commits with the same name (within last 30 commits) were squashed and pushed."
