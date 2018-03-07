#!/usr/bin/env bash

set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd ${DIR}

for d in */; do

  if [ ! -f ${d}/book.json ]; then
    continue
  fi

  echo "Generate PDF for book ${d}"

  gitbook install --log error ${d}
  gitbook pdf --log warn ${d} "${d}$(basename ${d}).pdf"
done

echo "Generate website"

gitbook install --log error
gitbook build --log warn
