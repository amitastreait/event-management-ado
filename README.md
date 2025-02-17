# Setup Self-Hoster Runner in Azure Pipeline

## Azure DevOps Pipeline Document Link
You can get the complete document using [Link](https://learn.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/pipeline?view=azure-pipelines)

## How to read the PR body in ADO Pipelines

There are two scenarios when you are using the ADO Pipelines

- Using the GitHub Repo and ADO Pipeline - GITHUB_PAT ( Personal Access Token )
- Using the Azure Repo and Azure Pipeline - Access Token ( $(System.AccessToken) )

Note:- There are no pipeline, build or system variables which can be used to read the PR Body. To read the PR body we need to Use the API

### How to read the PR Body in Azure Pipeline
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

      # Write PR body to file (handle newlines properly)
      Set-Content -Path pr_body.txt -Value $description -Encoding UTF8

      # echo "##vso[task.setvariable variable=PR_BODY;isOutput=true]$description"
      Write-Host "##vso[task.setvariable variable=PR_BODY;isOutput=true]$description"

- script: |
    echo "$(prbody.PR_BODY)"
  displayName: "PR Body"
```

### How to Read the PR Body of GitHub PR from ADO Pipeline

```yml
# Starter pipeline
# Start with a minimal pipeline that you can customize to build and deploy your code.
# Add steps that build, run tests, deploy, and more:
# https://aka.ms/yaml

trigger: none
pr:
  branches:
      include:
        - azure-pipelines
  paths:
    include:
      - force-app/*
      - ado_build/practicePipeline.yml

pool:
  vmImage: ubuntu-latest

variables:
  - group: uat
  - name: repoOwner
    value: "amitastreait"
  - name: repoName
    value: "event-management-ado"

stages:
  - stage: SFDeployANDValidate
    jobs:
      - job: SFValidate
        steps:
          - checkout: self
            fetchDepth: 0
            displayName: Checkout to correct commit

          # 🟢 Fetch PR Description from GitHub API
          - task: PowerShell@2
            name: fetchPRBody
            displayName: "Fetch GitHub PR Description"
            inputs:
              targetType: 'inline'
              script: |
                  # Get the source branch name
                  $sourceBranch = "$(Build.SourceBranch)"  # Example: "refs/pull/13/merge"

                  # Extract PR number using regex
                  if ($sourceBranch -match "refs/pull/(\d+)/merge") {
                      $githubPrNumber = $matches[1]
                  } else {
                      Write-Host "##vso[task.logissue type=error]Could not extract GitHub PR number"
                      exit 1
                  }
                  echo $githubPrNumber
                  $url = "https://api.github.com/repos/$(repoOwner)/$(repoName)/pulls/$githubPrNumber"
                  echo $url
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

                  echo $description

                  # Write PR body to file (handle newlines properly)
                  Set-Content -Path pr_body.txt -Value $description -Encoding UTF8

                  # Store PR description as a pipeline variable
                  Write-Host "##vso[task.setvariable variable=PR_BODY;isOutput=true]$description"
          
          # 🟢 Display PR Body (for debugging)
          - script: |
              echo "$(fetchPRBody.PR_BODY)"
            displayName: GitHub Actions PR BODY

          # 🟢 Extract Apex Test Classes using Python
          - task: PythonScript@0
            name: extractApex
            displayName: "Extract Apex Test Classes"
            inputs:
              scriptSource: 'filePath'
              scriptPath: 'PRBODY_TESTCLASS.py'
              arguments: 'pr_body.txt'   # ✅ Pass file instead of direct text

          # 🟢 Use Extracted Apex Test Classes
          - script: |
              echo "Extracted Apex Classes: $(extractApex.APEX_CLASSES)"
            displayName: "Use Extracted Apex Classes"
```

### Use the python code for fetching the Apex class
```python
import re
import argparse

def extract_apex_classes(pr_body):
    """
    Extract Apex test class names from the PR body.

    Args:
        pr_body (str): The PR description/body as a string.

    Returns:
        str: A space-separated string of Apex class names or an error message.
    """
    print(pr_body)
    # Using regex to extract the test class names from the last line
    match = re.search(r"APEX TEST CLASS TO RUN \[RUN:([^\]]+)\]", pr_body)
    if match:
        apex_classes = match.group(1).split(',')
        apex_classes_string = ' '.join(cls.strip() for cls in apex_classes)
        return apex_classes_string
    else:
        return "No Apex classes found"

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Extract Apex test classes from PR body file.")
    parser.add_argument("file_path", type=str, help="Path to the PR body file")

    args = parser.parse_args()

    # Read PR body from file
    with open(args.file_path, "r", encoding="utf-8") as file:
        pr_body = file.read().strip()

    result = extract_apex_classes(pr_body)

    # Print result normally
    print(result)

    # Set Azure DevOps variable
    print(f"##vso[task.setvariable variable=APEX_CLASSES;isOutput=true]{result}")
```

#### Complete Code for the ADO Pipeline

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
      # Write PR body to file (handle newlines properly)
      Set-Content -Path pr_body.txt -Value $description -Encoding UTF8

- script: |
    echo "$(prbody.PR_BODY)"
  displayName: Azure DevOps PR BODY

- task: PythonScript@0
  name: extractedApexClass
  displayName: Extract the Apex Test Class from PR Body
  inputs:
    scriptSource: 'filePath'
    scriptPath: 'PRBODY_TESTCLASS.py'
    arguments: 'pr_body.txt'
  
- script: |
    echo "$(extractedApexClass.APEX_CLASSES)"
  displayName: GitHub PR BODY

```

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