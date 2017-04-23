#!/bin/bash

function die () {
  echo $1
  exit 1
}

cd output
git checkout -q deploy
echo "checked out"
test `git status --porcelain | wc -l` -gt 0 && echo "Ok. Changes Found" || die "ERROR: No Changes Found"
git add .
echo "added"
git commit -m 'site redeployment'
git push origin deploy
cd ../../playbooks
ansible-playbook -i inventory secure-host.yml caddy.yml push-content.yml

