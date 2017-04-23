#!/bin/bash
cd output
git checkout -q deploy
test `git status --porcelain | wc -l` -gt 0 || echo "No Changes Found" && exit 1
git add .
git commit -m 'site redeployment'
git push origin deploy
cd ../../playbooks
ansible-playbook -i inventory secure-host.yml caddy.yml push-content.yml

