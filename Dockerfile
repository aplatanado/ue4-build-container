FROM ubuntu:latest

ARG USE_SSH
ARG UNREAL_ENGINE_VERSION=release
ARG SSH_AUTH_SOCK

ENV REPOSITORY_URL=${USE_SSH:+git@github.com:EpicGames/UnrealEngine.git}
ENV REPOSITORY_URL=${REPOSITORY_URL:-https://github.com/EpicGames/UnrealEngine.git}
ENV SSH_AUTH_SOCK=$SSH_AUTH_SOCK
ENV GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        ssh-client \
        sudo \
        xdg-user-dirs \
        xdg-utils \
    && useradd --no-log-init -m -Gsudo user \
    && echo "user ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user \
    && chmod 0440 /etc/sudoers.d/user

RUN mkdir -p /build \
    && git clone --depth=1 -b $UNREAL_ENGINE_VERSION $REPOSITORY_URL /build/UnrealEngine \
    && rm -rf /build/UnrealEngine/.git \
    && chown -R user:user /build

USER user
WORKDIR /build/UnrealEngine

RUN ./Setup.sh \
    && ./GenerateProjectFiles.sh \
    && make ARGS=-clean \
    && make \
    && rm -rf Engine/Build Engine/Intermediate

USER root

RUN chown -R root:root /build

ENTRYPOINT []
