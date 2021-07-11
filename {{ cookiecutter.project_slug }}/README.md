# Cyber Security Risk profiler Dashboard

System of Records for all the LCCE Applications built on salesforce platform

## Prerequisites

1. Add SSH key to your [GitHub Profile](https://www-github.cisco.com/settings/keys)

    - Follow the Steps as in [GitHub Docs: ](https://docs.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account)

1. Join [Shift Left Security](https://eurl.io/#L1zXw5q-Z) and request for

    - Git Guardian API Key
    - Cisco Dev Hub Org username and password

1. Install [Visual Studio Code](https://code.visualstudio.com/download)

1. [Remote-Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

    - In the terminal `code --install-extension ms-vscode-remote.remote-containers`

1. Complete two Tutorials

    - [Developing inside a Container](https://code.visualstudio.com/docs/remote/containers)
    - [Remote development in Containers](https://code.visualstudio.com/docs/remote/containers-tutorial)

1. [Docker](https://www.docker.com/)

## Getting Started

1. Clone repository

    ```
    git clone <repository_url> && cd <repository_name>
    code .
    ```

1. Run the Remote-Containers: Open Folder in Container... command and select the local folder.

![Click the Green Button](https://code.visualstudio.com/assets/docs/remote/containers-tutorial/remote-status-bar.png)

1. Open Terminal in Visual Studio Code

    ```
    $ source automator/ghelp.bash
    $ ghelp
    $ gsetup
    ```

1. All in One Step `automator/cci-deploy.sh`

1. Assign Permission set based on the role to be tested from any of the following roles [ToDo:Review]

    - Dev_Admin - Salesforce Administration Activities
    - Application_Admin - User Management Activities
    - DashBoard_Executive - Super Admininistrator of Security Risk Profiler Dashboard + Executive Dashboard
    - Dashboard_Admin - Super Admininistrator of Security Risk Profiler Dashboard
    - Security_Advocate - Approvals, View Previlages across Organization
    - Dashboard_User - View Previlage

    ```
    api_name = < DashBoard_Executive | Dashboard_Admin | Security_Advocate | Dashboard_User >
    cci task run assign_permission_sets --api_names $api_name
    ```

1. Test Automation `cci task run robot`

1. [Shift Left Security Tooling Guide](SLS.md)

**Development Rythm**

-   Customize & Configure in salesforce UI
-   Review Changes using `cci task run list_changes` and use `cci task run list_changes --exclude "<pattern>"` to ignore chnages
-   Pull Changes `cci task run retrieve_changes` and use `cci task run retrieve_changes --exclude "<pattern>"` to ignore chnages
-   Git Add `git add -A`
-   Git Commit `git commit -m "<provide meaningfull message"`

### SFDX Power Tools

-   Enable [sfdx Autocomplete setup]() #ToDo
