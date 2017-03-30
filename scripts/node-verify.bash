#!/bin/bash

# External Environment Variables:
export DESIRED_NODE_VERSION
if test -z "$DESIRED_NODE_VERSION"; then
	DESIRED_NODE_VERSION="$(nvm version-remote --lts)" || exit -1
else
	DESIRED_NODE_VERSION="$(nvm version-remote "$DESIRED_NODE_VERSION")" || exit -1
fi

# Local Environment Variables:
export CURRENT_NODE_VERSION
CURRENT_NODE_VERSION="$(node --version)" || exit -1

# Run
if test "$CURRENT_NODE_VERSION" = "$DESIRED_NODE_VERSION"; then
	echo "running on node version $CURRENT_NODE_VERSION which IS the desired $DESIRED_NODE_VERSION"

	echo "compiling and verifying with $CURRENT_NODE_VERSION..."
	npm run our:compile && npm run our:verify || exit -1
	echo "...compiled and verified with $CURRENT_NODE_VERSION"
else
	echo "running on node version $CURRENT_NODE_VERSION which IS NOT the desired $DESIRED_NODE_VERSION"

	echo "swapping to $DESIRED_NODE_VERSION..."
	nvm install "$DESIRED_NODE_VERSION" || exit -1
	echo "...swapped to $DESIRED_NODE_VERSION"

	echo "compiling with $DESIRED_NODE_VERSION..."
	npm run our:compile || exit -1
	echo "...compiled with $DESIRED_NODE_VERSION"

	echo "swapping back to $CURRENT_NODE_VERSION"
	nvm use "$CURRENT_NODE_VERSION" || exit -1
	echo "...swapped back to $CURRENT_NODE_VERSION"
fi