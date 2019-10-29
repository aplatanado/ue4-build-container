#!/bin/bash
#
# Build Unreal Engine on Linux
#
# https://docs.unrealengine.com/en-US/Platforms/Linux/BeginnerLinuxDeveloper/SettingUpAnUnrealWorkflow/index.html
# https://wiki.unrealengine.com/Building_On_Linux
#

set -e

CONTAINER_TAG=ue4
BUILD_ARGS=
WORKING_DIR="${1:-$PWD/build}"

if [ -n "$UNREAL_ENGINE_VERSION" ]; then
    CONTAINER_TAG="${CONTAINER_TAG}:$UNREAL_ENGINE_VERSION"
    BUILD_ARGS="$BUILD_ARGS --build-arg UNREAL_ENGINE_VERSION=$UNREAL_ENGINE_VERSION"
fi

if [ -n "$USE_SSH" ]; then
    if [ "$USE_SSH" == "agent" ]; then
        BUILD_ARGS="$BUILD_ARGS --volume $(readlink -f $SSH_AUTH_SOCK):/ssh-agent"
        BUILD_ARGS="$BUILD_ARGS --build-arg SSH_AUTH_SOCK=/ssh-agent"
    else
        BUILD_ARGS="$BUILD_ARGS --volume ~/.ssh:/root/.ssh:ro"
    fi

    BUILD_ARGS="$BUILD_ARGS --build-arg USE_SSH=1"
fi

mkdir -p "$WORKING_DIR"
podman build \
    --tag $CONTAINER_TAG \
    --volume "$WORKING_DIR":/build \
    $BUILD_ARGS .
