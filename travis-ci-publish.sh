#!/bin/bash
set -ev

git clone https://${GH_REF} .deploy_git
cd .deploy_git
git checkout master
cd ../
mv .deploy_git/.git/ ./public/
cd ./public

git config user.name "liuyib"
git config user.email "1656081615@qq.com"

# add commit timestamp
git add -A
git commit -m "Update by Travis CI at `date +"%Y-%m-%d %H:%M"`"
git push --force --quiet "https://${GH_TOKEN}@${GH_REF}" master:master
