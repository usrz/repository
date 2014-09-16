#!/bin/bash

git config user.email "builds@circleci.com" || exit 1
git config user.name "CircleCI Buil Agent" || exit 1
git checkout "gh-pages" || exit 1
git merge "master" -m "Building new indexes" || exit 1

OLD_DIR=`pwd`;
for DIR in releases libraries ; do
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
      echo "      <li class=\"up\"><a href=\"..\">..</a></li>"
      for FILE in `ls -1` ; do
        if [[ $FILE == "index.html" ]] || [[ $FILE == .* ]] ; then
          continue
        fi
        if test -d "$FILE" ; then
          FILE="${FILE}/"
          CLASS="dir"
        else
          CLASS="file"
        fi
        printf "      <li class=\"%s\"><a href=\"%s\">%s</a></li>\n" "${CLASS}" "${FILE}" "${FILE}"
      done
      echo "    </ul>"
      echo "  </body>"
      echo "</html>"
    } > index.html
    cd "${OLD_DIR}"
  done
  git add "${DIR}" || exit 1
done

git commit --allow-empty -a -m "Built new indexes" || exit 1
git push -u origin gh-pages || exit 1
git checkout "master" || exit 1

