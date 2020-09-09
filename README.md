# fb-deploy

Build and Deployment scripts for From Builder platform and services.

## Getting environment variables

In order to interact with the MoJ Cloud Platform there are certain environment variables that need to be set in the pipelines:

- AWS_BUILD_IMAGE_ECR_ACCOUNT_URL
- AWS_BUILD_IMAGE_ACCESS_KEY_ID
- AWS_BUILD_IMAGE_SECRET_ACCESS_KEY
- ECR_CREDENTIALS_SECRET
- ENCODED_GIT_CRYPT_KEY
- K8S_CLUSTER_CERT
- K8S_CLUSTER_NAME
- K8S_TOKEN
- K8S_TOKEN_TEST_DEV
- K8S_TOKEN_TEST_PRODUCTION
- K8S_TOKEN_LIVE_DEV
- K8S_TOKEN_LIVE_PRODUCTION
- SSH_FILE_FOR_SECRETS

These can be obtained by having the necessary permissions to [interact with Cloud Platform](https://user-guide.cloud-platform.service.justice.gov.uk/documentation/getting-started/kubectl-config.html#how-to-use-kubectl-to-connect-to-the-cluster).

`SSH_FILE_FOR_SECRETS` is required by repos that make use of git-crypt in order to hold their secrets. Currently that is all of them except `fb-av`.

Once you have the required kube config on your machine you can run:

`./bin/get_environment_variables <app_name>`

`app_name` can be one of:

- fb-av
- fb-base-adapter
- fb-pdf-generator
- fb-publisher
- fb-runner-node
- fb-service-token-cache
- fb-submitter
- fb-user-filestore
- fb-user-datastore

Set the outputted environment variables in your pipeline of choice.

## Deployment pipeline configuration

In addition to the above, you will also need to set the following configuration in each environment step of your deployment pipeline:

- APPLICATION_NAME
- PLATFORM_ENV
- DEPLOYMENT_ENV
- K8S_NAMESPACE

`APPLICATION_NAME` is from the same list as `app_name` above.

`PLATFORM_ENV` is either `test` or `live`.

`DEPLOYMENT_ENV` is either `dev` or `production`.

You can run the following command to find the correct `K8S_NAMESPACE` that you require for the app you are deploying:

`kubectl get namespaces | grep formbuilder`
