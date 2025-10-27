#!/usr/bin/env bash

source ~/.local/bin/prints

last_changes=$(git pull)

if [ "$last_changes" == "Already up-to-date." ]; then
  pgreen "There are no new changes in the remote repository."
  exit 1
fi

for i in {1..30}; do
  commit_name=$(git log --pretty=format:%s -n $i)

  next_commit_name=$(git log --pretty=format:%s -n $((i+1)))

  if [ "$commit_name" == "$next_commit_name" ]; then
    git rebase -i --autosquash HEAD~$i
  fi
done

# Get the name of the branch
branch_name=$(git rev-parse --abbrev-ref HEAD)
remote_name=$(git remote)

git push $remote_name $branch_name --force

pgreen "All commits with the same name have been squashed into one commit and pushed to the remote repository."
exit 0
