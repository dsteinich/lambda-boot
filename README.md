# lambda-boot

## Testing
### Prerequisites
* nvm: https://github.com/nvm-sh/nvm
	** Node.js: https://nodejs.org/en/
	** npm: https://www.npmjs.com/
* Docker: https://docs.docker.com/get-docker/
* Docker-Compose: https://docs.docker.com/compose/install/
* Terraform: https://www.terraform.io/downloads.html
* AWS Command Line Interface (CLI): https://aws.amazon.com/cli/
* LocalStack AWS CLI: https://github.com/localstack/awscli-local
* Serverless: https://serverless.com/framework/docs/getting-started/
	** serverless-offline plugin: https://github.com/dherault/serverless-offline
	** serverless-localstack plugin: https://github.com/localstack/serverless-localstack
* Maven: https://maven.apache.org/ (Make sure JAVA_HOME is set)
* This repo

### Create the Stack
* terraform init
* terraform apply

### Build the project
* mvn package

### Deploy the Jar
* sls deploy --stage local --region us-east-1

### Run the Function
* sls invoke -f echoObject --stage local --log --data '{"name": "steve"}'