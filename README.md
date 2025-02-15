# Setup Self-Hoster Runner in Azure Pipeline

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

Make the necessary changes into the YML pipeline so that your new runners will work
```yml
pool:
  name: default # Provide the name of your self hosted runner. The name of the Pool Can be different if you using a Custom Pool
  # vmImage: ubuntu-latest # use this only when you are using Microsoft Hosted Runners
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
