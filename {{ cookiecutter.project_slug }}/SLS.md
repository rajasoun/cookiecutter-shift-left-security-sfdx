# Purpose

Institutionalizing Shift Left Security adoption for

1.  Secrets Detection
1.  Static Application Security Testing (SAST) Scan
1.  Development Environment Setup
1.  Git Commit
1.  Git Branching
1.  Code formatter
1.  Linters for staged git files
1.  CLI that simplifies build automation for Salesforce org
1.  Automate salesforce org setup, testing, and deployment


## Prerequisites

1.  [Visual Studio Code](https://code.visualstudio.com/)
1.  [Remote-Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) ext install ms-vscode-remote.remote-containers
1.  [Docker](https://www.docker.com/)

## Getting Started

1.  Enable help and alias

```
$ source dotfiles/.alias.sh
$ ghelp
```

1.  Setup commitzen, commitlint and ggshield toolset as git hooks

```
$ gsetup
```

1.  Populate .env file with GITHUB_TOKEN, GITGUARDIAN_API_KEY and GITGUARDIAN_API_URL

```
cp .env.sample .env
```

1. `npm install --prefix ./shift-left-security` to install the toolset


## Prerequisites - Remote development in Containers

Running Visual Studio Code in a Docker container using the Remote - Containers extension.
Goto: https://code.visualstudio.com/docs/remote/containers-tutorial

[Developing inside a Container](https://code.visualstudio.com/docs/remote/containers)

## Toolz Radar

🚀 Tool Collection

### Adopt

1.  [Docker](https://www.docker.com/): Docker takes away repetitive, mundane configuration tasks and is used throughout the development lifecycle for fast, easy and portable application development - desktop and cloud.
1.  [cookiecutter](https://github.com/cookiecutter/cookiecutter): A command-line utility that creates projects from cookiecutters (project templates)
1.  [cruft](https://github.com/cruft/cruft): cruft allows you to maintain all the necessary boilerplate for packaging and building projects separate from the code you intentionally write. Fully compatible with existing Cookiecutter templates
1.  [Visual Studio Code Remote - Containers Extension](https://code.visualstudio.com/docs/remote/containers): Leverage Docker container as a full-featured development environment. It allows you to open any folder inside (or mounted into) a container and take advantage of Visual Studio Code's full feature set.
1.  [commitizen](https://github.com/commitizen/cz-cli): Tool that guides the developer through the writing of the commit message
1.  [commitlint](https://github.com/conventional-changelog/commitlint): Tool that validates the commit message following a set of rules and good practices
1.  [pre-commit](https://pre-commit.com/): A framework for managing and maintaining multi-language pre-commit hooks
1.  [gg-shield](https://github.com/GitGuardian/gg-shield): CLI application that runs in your local environment or in a CI environment to help you detect more than 200 types of secrets, as well as other potential security vulnerabilities or policy breaks.
1.  [git flow](https://github.com/nvie/gitflow): Git extensions to provide high-level repository operations
1.  [lint-staged](https://github.com/okonet/lint-staged): Run linters against staged git files and don't let :poop: slip into your code base!
1.  [prettier](https://prettier.io/): An opinionated code formatter
1.  [husky](https://github.com/typicode/husky): Tool that adds scripts (hooks) trigged before (pre-commit) and after (post-commit) your commit.
1.  [sfdx-cli](https://developer.salesforce.com/docs/atlas.en-us.230.0.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
1.  [cumulusci](https://cumulusci.readthedocs.io/en/stable/intro.html)
1.  [release-it](https://github.com/release-it/release-it): CLI tool to automate versioning and package publishing related tasks

## Quick Background about Remote Containers

Visual Studo Code [Remote Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension allow us to use docker as a full-featured development environment.

Remote Containters allows us to isolate each project’s development environment with following advantages

1.  Reproducibility: Each developer has exactly the same workspace
1.  Isolation: Workspaces and their dependencies are isolated from each other
1.  Security: Prevents malicious dependencies from installing malware or reading your files.

Each project has a .devcontainer folder.
The .devcontainer folder contains the Dockerfile and devcontainer.json configuration for the development environment.

![Remote Container](https://code.visualstudio.com/assets/docs/remote/containers/architecture-containers.png)
