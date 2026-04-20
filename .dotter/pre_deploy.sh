#!/bin/bash
# pre_deploy.sh is rendered as a Handlebars template by dotter.

# Check for mise (required by post_deploy.sh for tool installation)
if ! command -v mise &>/dev/null; then
  echo "==> WARNING: mise not found. Many post-deploy steps will be skipped."
fi

find . -name ".DS_Store" -delete
