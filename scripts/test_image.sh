#!/bin/bash

set -euo pipefail

## Script generally appropriated from https://github.com/buildkite/docker-buildkite-agent/blob/master/scripts/test_image.sh
## Tests a built image to check it has everything we expect
##
## Usage:
##   test_image.sh gorillastack/buildkite-agent-node

docker_label() {
  local image="$1"
  local label="$2"
  docker inspect --format "{{ index .Config.Labels \"$label\" }}" "$image"
}

DOCKER_IMAGE_NAME="$1"

echo "--- :hammer: Testing ${DOCKER_IMAGE_NAME}"

echo ">> Buildkite version: "
docker run --rm --entrypoint "buildkite-agent" "${DOCKER_IMAGE_NAME}" --version
echo -e "\033[33;32mOk\033[0m"

echo -e ">> Checking that the AWS CLI is installed on ${DOCKER_IMAGE_NAME}"
docker run --rm --entrypoint "/bin/bash" "${DOCKER_IMAGE_NAME}"  -c 'aws --version'
echo -e "\033[33;32mOk\033[0m"

echo -e ">> Checking that the serverless is installed on ${DOCKER_IMAGE_NAME}"
docker run --rm --entrypoint "/bin/bash" "${DOCKER_IMAGE_NAME}"  -c 'serverless --version'
echo -e "\033[33;32mOk\033[0m"

echo -e ">> Checking that the sls alias for serverless is available on ${DOCKER_IMAGE_NAME}"
docker run --rm --entrypoint "/bin/bash" "${DOCKER_IMAGE_NAME}"  -c 'sls --version'
echo -e "\033[33;32mOk\033[0m"

docker_version=$(docker_label $DOCKER_IMAGE_NAME "com.buildkite.docker_version")

if [[ -n "$docker_version" ]] ; then
  echo -e ">> Checking docker client is installed on ${DOCKER_IMAGE_NAME}"
  docker run --rm --entrypoint "docker" "${DOCKER_IMAGE_NAME}" --version | grep --color ${docker_version}
  echo -e "\033[33;32mOk\033[0m"
else
  echo -e ">> Skipping docker checks"
fi

docker_compose_version=$(docker_label $DOCKER_IMAGE_NAME "com.buildkite.docker_compose_version")

if [[ -n "$docker_compose_version" ]] ; then
  echo -e ">> Checking docker-compose client for ${DOCKER_IMAGE_NAME}"
  docker run --rm --entrypoint "docker-compose" "${DOCKER_IMAGE_NAME}" --version | grep --color ${docker_compose_version}
  echo -e "\033[33;32mOk\033[0m"
else
  echo -e ">>Skipping docker-compose checks"
fi

echo -e "\033[33;32mLooks good!\033[0m"
