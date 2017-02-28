#!/bin/bash

set -euo pipefail

echo "--- Pushing gorillastack/buildkite-agent-jekyll"
docker push "gorillastack/buildkite-agent-jekyll"
