# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.163.1/containers/python-3/.devcontainer/base.Dockerfile

# [Choice] Python version: 3, 3.9, 3.8, 3.7, 3.6
ARG VARIANT="3"
FROM mcr.microsoft.com/vscode/devcontainers/python:0-${VARIANT} AS builder

# secerts management using chamber
FROM segment/chamber:2.9.1 as chamber-builder

FROM builder
# COPY files

COPY dotfiles /root/dotfiles
COPY --from=chamber-builder /chamber /usr/bin/chamber

# pip3 packages
RUN set -ex \
    && pip3 --disable-pip-version-check --no-cache-dir install \
            pipenv==2020.11.15      \
            ggshield==1.4.0         \
            pre-commit==2.12.1      \
            commitizen==2.17.3      \
            cruft==2.8.0            \
            cumulusci==3.33.1

# OS packages.
RUN set -ex \
    && apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends git-flow bash-completion

# Install global node packages.
ARG SALESFORCE_CLI_VERSION=latest
RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g sfdx-cli@${SALESFORCE_CLI_VERSION}" 2>&1

RUN set -x \
    && apt-get autoremove --assume-yes \
    && apt-get clean --assume-yes \
    && rm -rf /var/lib/apt/lists/*
