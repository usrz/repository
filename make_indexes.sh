#!/bin/bash

DETAILS="Built by `whoami` on `hostname -f` at `date -u`"
if test -n "${CIRCLE_BUILD_NUM}" ; then
  DETAILS="${DETAILS} (CircleCi ${CIRCLE_PROJECT_USERNAME}/${CIRCLE_PROJECT_REPONAME} build ${CIRCLE_BUILD_NUM})"
fi

# Traverse our directory structure...
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
      echo "    <p style=\"font-size: 70%\">${DETAILS}</p>"
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

# Finally create our index...
cat > index.html << EOF
<!DOCTYPE html>
<html>
  <head>
    <title>Repository Home</title>
  </head>
  <body>
    <h1>Repository Home</h1>
    <ul>
      <li class="dir"><a href="libraries">libraries/</a></li>
      <li class="dir"><a href="releases">releases/</a></li>
    </ul>
    <p style="font-size: 70%">${DETAILS}</p>
  </body>
</html>
EOF
git add --verbose "index.html" || exit 1
