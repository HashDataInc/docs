#!/usr/bin/env bash

set -eo pipefail

BRANCH=gh-pages
TARGET_REPO=HashDataInc/docs.git

echo -e "Testing travis-encrypt"
echo -e "$VARNAME"

if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
    echo -e "Starting to deploy to Github Pages\n"
    if [ "$TRAVIS" == "true" ]; then
        git config --global user.email "travis@travis-ci.org"
        git config --global user.name "Travis"
    fi

    VERSION=$TRAVIS_BRANCH

    if [ "$TRAVIS_BRANCH" == "master" -o "$TRAVIS_BRANCH" == "gitbook" ]; then
        VERSION=latest
    fi

    #using token clone gh-pages branch
    git clone --quiet --branch=$BRANCH https://${GH_TOKEN}@github.com/$TARGET_REPO built_website > /dev/null

    mkdir -p built_website/${VERSION}
    #go into directory and copy data we're interested in to that directory
    cd built_website/${VERSION}

    rm -rf *
    cp -r ../../_book/* .
    #add, commit and push files
    git add -f --all .
    git commit -m "Travis build $TRAVIS_BUILD_NUMBER pushed to Github Pages"
    #git push -fq origin $BRANCH > /dev/null

    if [ -n "${access_key_id}" -a -n "${access_key_secret}" ]; then
        rm -rf .git
        echo "access_key_id: '${access_key_id}'" >~/qsconfig
        echo "secret_access_key: '${access_key_secret}'" >>~/qsconfig
        qsctl rm -r -c ~/qsconfig qs://hashdata-docs-gitbook/${VERSION}/
        qsctl cp -r -c ~/qsconfig `pwd` qs://hashdata-docs-gitbook/${VERSION}/
        rm -f ~/qsconfig
    fi

    echo -e "Deploy completed\n"
fi
