
## Createing CD + CD with Github Actions

<https://learn.microsoft.com/en-us/azure/machine-learning/how-to-github-actions-machine-learning?tabs=userlevel>

for bootstrapping your own MLOps projects.

## Steps to Deploy

Clone this repository to your own GitHub organization and follow the steps below to deploy the demo.

1. [Create an Azure Service Principal and configure GitHub actions secrets.](#configure-github-actions-secrets)
2. [Configure dev and/or prod environments and create a dev branch.](#configure-azure-ml-environment-parameters)
3. [Use a GitHub workflow to create Azure ML infrastructure for dev and/or prod environments.](#deploy-azure-machine-learning-infrastructure)
4. [Use a GitHub workflow to create and run a pytorch vision model training pipeline in Azure ML.](#train-a-pytorch-classifier-in-azure-machine-learning)
5. [Use a GitHub workflow to deploy the vision model as a real-time endpoint in Azure ML.](#deploy-the-registered-model-to-an-online-endpoint)

---

## Configure GitHub Actions Secrets and Environments

   This step creates a service principal and GitHub secrets to allow the GitHub action workflows to create and interact with Azure Machine Learning Workspace resources.
   
   From the command line, execute the following Azure CLI command with your choice of a service principal name:
   
   > `# az ad sp create-for-rbac --name <service_principal_name> --role contributor --scopes /subscriptions/<subscription_id> --sdk-auth`
   
   You will get output similar to below:

   >`{`  
   > `"clientId": "<service principal client id>",`  
   > `"clientSecret": "<service principal client secret>",`  
   > `"subscriptionId": "<Azure subscription id>",`  
   > `"tenantId": "<Azure tenant id>",`  
   > `"activeDirectoryEndpointUrl": "https://login.microsoftonline.com",`  
   > `"resourceManagerEndpointUrl": "https://management.azure.com/",`  
   > `"activeDirectoryGraphResourceId": "https://graph.windows.net/",`  
   > `"sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",`  
   > `"galleryEndpointUrl": "https://gallery.azure.com/",`  
   > `"managementEndpointUrl": "https://management.core.windows.net/"`  
   > `}`
   
   Copy all of this output, braces included. From your GitHub project, select **Settings**
   Select **New repository secret**. Name this secret **AZURE_CREDENTIALS** and paste the service principal output as the content of the secret.  Select **Add secret**.

 ## Create Environment
From your GitHub project, select **Settings**

<p align="left">
    <img src="./images/gh-env.png" alt="GitHub Settings" width="50%" height="50%"/>
</p>

Select **Add Environment variable**. Name this variable **RESOURCE_GROUP** and **WORKSPACE_NAME**
  
<p align="left">
    <img src="./images/gh-envvars.png" alt="GitHub Settings" width="50%" height="50%"/>
</p> 



---


 ## Deploy Azure Machine Learning Infrastructure

   In your GitHub project repository, select **Actions**

   This will display the pre-defined GitHub workflows associated with your project. For a classical machine learning project, the available workflows will look similar to this:

 - `train-pipeline-model` - creates dataset. environment and submits pipeline to train and register model
 - `deploy-pipeline-model` - deployes model to online endpoint
 - `run-pipeline-nowait` - simple pipeline creation

---

## Train a Taxi Prices Prediction Model in Azure Machine Learning

The https://github.com/sdonohoo/mlops-cv-demo/blob/main/.github/workflows/run-model-training.yml GitHub workflow creates the training dataset and environment in Azure ML. Then it creates an Azure ML pipeline with a few  components that trains and registers  model.

To create the model training pipeline in the previously created Azure ML workspace, select **Actions** in your GitHub project repository. 
Then select the `train-pipeline-model`.

<p align="left">
    <img src="./images/gh-training.png" alt="centered image" width="50%" height="50%"/>
</p>

As before, select  **Run workflow** on the right and select the branch to run from. This will run the workflow, register the dataset, and deploy the training pipeline in Azure ML.

Once the run-model-training-pipeline job begins running, you can follow the execution of this job in the Azure ML workspace. 

![GH-actions](./images/gh-trainingflow.png)

When the Azure ML pipeline completes, the trained model should be registered in the workspace.

Next, the registered model will be deployed to a real-time endpoint for predictions.

---

## Deploy the Registered Model to an Online Endpoint

This step uses a GitHub workflow to deploy the registered model to an Azure ML Managed Online Endpoint for predicting the class of new images.

This workflow will register the interference environment with prerequisite python packages, create an Azure ML endpoint, create a deployment of the registered model to that endpoint, then allocate traffic to the endpoint.

To run the workflow to deploy the registered model as a managed online endpoint, select **Actions** in your GitHub project repository.
Then select the `deploy-pipeline-model`.

<p align="left">
    <img src="./images/gh-deploy.png" alt="centered image" width="50%" height="50%"/>
</p>

Run the workflow.

![GH-actions](./images/gh-deployflow.png)

As the create-endpoint job begins, you can monitor the ednpoint creation, deployment creation, and traffic allocation in the Azure ML workspace.


---

## Next Steps

* Add step to test deployed model
* Configure the GitHub repository and workflows to fit your MLOps workflows and policies utilizing prod/dev branches, branch protection, and pull requests.

