#!/bin/bash

# Copyright 2019 Google LLC

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
. ${ROOT}/scripts/all-utilities.sh || { echo "Cannot load Bash utilities"; exit 1; }

function usage() {
  [[ -n "${1}" ]] && echo "${1}"
  cat << END_USAGE

Usage: ${BASH_SOURCE[0]}  [-n <current version number>]

This script will release stable ESPv2 docker image with format of:
  $(get_proxy_image_release_name):\${MINOR_BASE_VERSION}
  $(get_serverless_image_release_name):\${MINOR_BASE_VERSION}
  $(get_gcsrunner_image_release_name):\${MINOR_BASE_VERSION}
where:
  MINOR_BASE_VERSION=major.minor

END_USAGE
  exit 1
}


while getopts :n: arg; do
  case ${arg} in
    n) VERSION="${OPTARG}" ;;
    *) usage "Invalid option: -${OPTARG}" ;;
  esac
done
set -x

if [ "${VERSION}" = "" ]; then
  VERSION="$(command cat ${ROOT}/VERSION)" \
    || usage "Cannot determine release version (${ROOT}/VERSION)."
fi

# Minor base is 1.33  if version is 1.33.0
MINOR_BASE_VERSION=${VERSION%.*}

function tag_stable_image() {
  local image=$1

  gcloud container images add-tag "${image}:${VERSION}" \
    "${image}:${MINOR_BASE_VERSION}" --quiet
}

tag_stable_image "$(get_proxy_image_release_name)"
tag_stable_image "$(get_serverless_image_release_name)"
tag_stable_image "$(get_gcsrunner_image_release_name)"

printf '\e[31m
***************************************************************************
*      Please paste the script output verbatim into the release bug.      *
***************************************************************************
\e[0m'
