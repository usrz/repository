#!/bin/bash

git config user.email "builds@circleci.com" || exit 1
git config user.name "CircleCI Buil Agent" || exit 1
git checkout "gh-pages" || exit 1
git merge "master" -m "Building new indexes" || exit 1

OLD_DIR=`pwd`;
for DIR in releases ; do
  find "${DIR}" -type f -name index.html -delete
  find "${DIR}" -type d | while read NEW_DIR ; do
    cd "${NEW_DIR}"
    {
      echo "<!DOCTYPE html>"
      echo "<html>"
      echo "  <head>"
      echo "    <title>Index of: ${NEW_DIR}</title>"
      echo "  </head>"
      echo "  <body>"
      echo "    <h1>Index of: ${NEW_DIR}</h1>"
      echo "    <ul>"
      echo "      <li><a href=\"..\">..</a></li>"
    printf "      <li><a href=\"%s\">%s</a></li>" "${NEW_DIR}" "${NEW_DIR}"
      echo "    </ul>"
      echo "  </body>"
      echo "</html>"
    } > index.html
    cd "${OLD_DIR}"
  done
  git add "${DIR}" || exit 1
done

git commit -a -m "Built new indexes" || exit 1
git push -u origin gh-pages || exit 1
git checkout "master" || exit 1

