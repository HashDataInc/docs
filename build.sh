#!/usr/bin/env bash

set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd ${DIR}

rm -rf _book

npm install markdown-parser2

for d in */; do

  if [ ! -f ${d}/book.json ]; then
    continue
  fi

  echo "Generate PDF for book ${d}"
  cp ./gen_summary.js ${d}
  cd ${d} && node gen_summary.js && rm gen_summary.js && cd ..
  test ! -e node_modules && gitbook install --log error ${d}
  gitbook pdf --log warn ${d} "${d}$(basename ${d}).pdf"
done

echo "Generate website"

test ! -e node_modules && gitbook install --log error
node gen_summary.js
gitbook build --log warn

find _book -name "SUMMARY.md" | xargs rm -f
find _book -name "book.json" | xargs rm -f
cp book.json _book/
