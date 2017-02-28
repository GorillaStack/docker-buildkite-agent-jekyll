#!/bin/bash

set -euo pipefail

echo "--- Pushing gorillastack/buildkite-agent-aws"
docker push "gorillastack/buildkite-agent-aws"
