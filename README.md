# Setup Self-Hoster Runner in Azure Pipeline

## Azure DevOps Pipeline Document Link
You can get the complete document using [Link](https://learn.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/pipeline?view=azure-pipelines)

## Required steps to setup Self-Hoted Runner

1. Download the Runner using [ADO Official Link](https://vstsagentpackage.azureedge.net/agent/4.251.0/vsts-agent-linux-x64-4.251.0.tar.gz)
2. Extract the file using ```tar zxvf vsts-agent-linux-x64-4.251.0.tar.gz```
3. Run ```./config.sh``` to configure the agent

## Steps after the Hosted Runner is Configured

1. Install Node.js
2. Install npm
3. Install Salesforce CLI
4. Install required plugins
    code analyzer
    sfdx git delta
5. Install Java or later
    5.1 - sudo apt install default-jre
    5.2 sudo apt install default-jdk

### Run the Self-Hosted Runner
1. Finally run ```./run.sh``` to run the agent

### Configure the Pipeline to take this agent

Make the necessary changes into the YML pipeline so that your new runners will work.
You can read more about the same using [link](https://learn.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/pool?view=azure-pipelines)
```yml
pool:
  name: default # Provide the name of your self hosted runner. The name of the Pool Can be different if you using a Custom Pool
  # vmImage: ubuntu-latest # use this only when you are using Microsoft Hosted Runners
```

## How to read the PR Body in Azure Pipeline
```yml
# Starter pipeline
# Start with a minimal pipeline that you can customize to build and deploy your code.
# Add steps that build, run tests, deploy, and more:
# https://aka.ms/yaml

trigger: none

pr:
 branches:
   include:
     - main
     - master

pool:
  vmImage: ubuntu-latest

steps:
- script: echo Hello, world!
  displayName: 'Run a one-line script'

- script: |
    echo Add other tasks to build, test, and deploy your project.
    echo See https://aka.ms/yaml
  displayName: 'Run a multi-line script'
  
- task: PowerShell@2
  name: prbody
  displayName: "Read PR description"
  inputs:
    targetType: 'inline'
    script: |

      # Call the Azure DevOps Services Rest API.
      $url = "$($env:SYSTEM_TEAMFOUNDATIONCOLLECTIONURI)$env:SYSTEM_TEAMPROJECTID/_apis/git/repositories/$(Build.Repository.ID)/pullRequests/$(System.PullRequest.PullRequestId)?api-version=7.0"
      $headers = @{
        Authorization = "Bearer $(System.AccessToken)"
      }
      $pullRequestInfo = Invoke-RestMethod -Uri $url -Method 'GET' -ContentType 'application/json' -Headers $headers

      # Get PR description from the json response.
      $json = $($pullRequestInfo | ConvertTo-Json -Depth 100 | ConvertFrom-Json)
      $description = $json.description

      # Replace newlines with a placeholder (e.g., `__NEWLINE__`)
      $description = $description -replace "`r`n", " "  # Windows newlines
      $description = $description -replace "`n", " "    # Unix newlines

      # echo "##vso[task.setvariable variable=PR_BODY;isOutput=true]$description"
      Write-Host "##vso[task.setvariable variable=PR_BODY;isOutput=true]$description"

- script: |
    echo "$(prbody.PR_BODY)"
  displayName: "PR Body"
```

## How to Read the PR Body of GitHub Actions from ADO Pipeline

```yml
- task: PowerShell@2
  name: fetchPRBody
  displayName: "Fetch GitHub PR Description"
  inputs:
    targetType: 'inline'
    script: |
        # Define GitHub API URL
        $repoOwner = "amitastreait"  # Replace with your GitHub org/user
        $repoName = "event-management-ado"  # Replace with your repo name
        $prNumber = "$(System.PullRequest.PullRequestId)"  #Fetch PR ID from ADO pipeline variable
        $url = "https://api.github.com/repos/$repoOwner/$repoName/pulls/$prNumber"

        # GitHub API authentication (Use GitHub PAT stored as a secret variable in ADO)
        $headers = @{
            Authorization = "Bearer $(GITHUB_PAT)"  # GITHUB_PAT should be stored securely in ADO
            Accept = "application/vnd.github.v3+json"
        }

        # Fetch PR details
        $response = Invoke-RestMethod -Uri $url -Method 'GET' -Headers $headers -ContentType "application/json"
        
        # Extract PR description
        $description = $response.body  # PR description
        
        # Replace newlines to avoid truncation
        $description = $description -replace "`r`n", " "  # Windows newlines
        $description = $description -replace "`n", " "    # Unix newlines

        # Store PR description as a pipeline variable
        Write-Host "##vso[task.setvariable variable=PR_BODY;isOutput=true]$description"

- script: |
    echo "$(prbody.PR_BODY)"
  displayName: Azure DevOps PR BODY
```

## Salesforce DX Project: Next Steps

Now that you’ve created a Salesforce DX project, what’s next? Here are some documentation resources to get you started.

## How Do You Plan to Deploy Your Changes?

Do you want to deploy a set of changes, or create a self-contained application? Choose a [development model](https://developer.salesforce.com/tools/vscode/en/user-guide/development-models).

## Configure Your Salesforce DX Project

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
