# Getting Started

For institutionalizing Shift Left Security adoption for

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

[Docker](https://www.docker.com/)

```sh
docker run --rm --name cruft python:3.9.3-alpine3.13  \
  pip3  install cruft \
  && cruft create https://github.com/rajasoun/cookiecutter-shift-left-security-sfdx
```

Once finished, navigate to your new project folder :

```sh
cd <project_name>
```

Refer [SLS - Shift Left Security](SLS.md)

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
