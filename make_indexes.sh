#!/bin/bash

git checkout "gh-pages"
git merge "master"

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
  git add "${DIR}"
done

git commit -a -m "Built new indexes"
git push -u origin gh-pages
git checkout "master"

