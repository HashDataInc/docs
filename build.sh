#!/usr/bin/env bash

set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd ${DIR}

for d in */; do

  if [ ! -f ${d}/book.json ]; then
    continue
  fi

  gitbook install ${d}
  gitbook pdf ${d} "${d}$(basename ${d}).pdf"
done

gitbook install
gitbook build
