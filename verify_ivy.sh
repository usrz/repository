#!/bin/bash

exec find . -type f -name ivy.xml -print0 | xargs -0 xmllint --noout --schema http://ant.apache.org/ivy/schemas/ivy.xsd
