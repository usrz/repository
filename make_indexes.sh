#!/bin/bash

OLD_DIR=`pwd`;
for DIR in releases libraries ; do
  echo ""
  echo "Processing directory \"${DIR}\""
  echo ""
  echo "Deleting files:"
  echo ""
  find "${DIR}" -type f -name index.html -print -delete
  find "${DIR}" -type d  -empty -print -delete
  echo ""
  echo "Creating files:"
  echo ""
  find "${DIR}" -type d | while read NEW_DIR ; do
    echo "${DIR}/${NEW_DIR}"
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
  echo ""
  echo "Adding to git:"
  echo ""
  git add --verbose "${DIR}" || exit 1
done
