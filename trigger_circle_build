#!/bin/bash

## Example crontab entry:
## put this file in path, put token in ~/.circle_token
##
## 30 0 * * * /bin/bash trigger_nightly_build.sh $(cat ~/.circle_token) 2>&1 | /usr/bin/logger



_project="ropensci/drat"
_branch="gh-pages"
_circle_token=$1

trigger_build_url=https://circleci.com/api/v1.1/project/github/${_project}/tree/${_branch}?circle-token=${_circle_token}

post_data=$(cat <<EOF
{
  "build_parameters": {
    "RUN_NIGHTLY_BUILD": "true",
    "FUNCTIONAL_TEST_TARGET": "staging-dawn-435.herokuapp.com"
  }
}
EOF)

curl \
--header "Accept: application/json" \
--header "Content-Type: application/json" \
--data "${post_data}" \
--request POST ${trigger_build_url}

