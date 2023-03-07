# dipfins

## About The Project

Anagram for `Find IPs`. Scans JSON files to extract all IPv4 addresses stored as a property values. The scanner is
written in Clojure and deployed as an AWS Lambda. The Lambda is triggered by object creation in an AWS S3 bucket. Any
JSON objects that are created in S3 are processed by the Lambda. The result of the scan is then written back to the same
S3 bucket.

### Built With

* [Java 11](https://github.com/adoptium/temurin11-binaries/releases/tag/jdk-11.0.18%2B10) 
* [Leiningen](https://leiningen.org)
* [Clojure](https://clojure.org)
* [Terraform](https://www.terraform.io)
* [AWS CLI](https://aws.amazon.com/cli/)

## Getting Started

### Prerequisites

The following is required to build and deploy the application:

* **Install Java 11 JDK** - Temurin version 11.0.13 was used 
* **Install Clojure** - version 1.11.1.1237 was used
* **Install Leiningen 2** - version 2.10.0 was used
* **Install Terraform 1** - version 1.3.9 was used
* **Install AWS CLI 2** - version 2.11.0 was used

### Installation
The deployment to AWS assumes you have an AWS profile configured and containing a credentials for a user with access to
provision the following resources in `us-east-1`:

* Lambda
* S3
* IAM Role
* IAM Policy

Extract the project archive into a directory of your choice and change to that directory. From the project directory do
the following:

Verify Java version is 11.x:

    $ java -version

Build the project:

    $ lein uberjar

Switch to the Terraform directory:

    $ cd terraform

Initialize Terraform:

    $ terraform init

If desired check the plan prior to applying changes to understand resources that will be provisioned: 

    $ terraform plan

Deploy the application, review the plan and enter yes at the prompt to accept the changes to AWS:

    $ terraform apply

## Usage
The following usage assumes you are at a terminal prompt in the project root directory.

### List Data Files
Display a list of files in the bucket:

    $ aws s3 ls s3://dipfins-scanner/

### Upload Data File
Upload a JSON data file to trigger a scan. Only files with the suffix `.in.json` will be processed. Output files
will have the same prefix as the input file but the suffix replaced with `.out.json`.

    $ aws s3 cp ./resources/1.in.json  s3://dipfins-scanner/

Bulk upload a directory of files:

    $ aws s3 cp ./resources/ s3://dipfins-scanner --recursive --exclude "*" --include "*.in.json"

### Download Output File
Download the output file and view the result. It may take up to 10 seconds for the output file to be available
in the bucket. Use the list files command above to check if the file is available.

    $ aws s3 cp s3://dipfins-scanner/1.out.json ./resources/
    $ cat resources/1.out.json

Bulk download output files:

    $ aws s3 cp s3://dipfins-scanner resources/ --recursive --exclude "*" --include "*.out.json"

### Updating Lambda

Build the project:

    $ lein uberjar

Switch to the Terraform directory:

    $ cd terraform

Apply changes:

    $ terraform apply

### Updating Terraform Config

Switch to the Terraform directory:

    $ cd terraform

Apply changes:

    $ terraform apply

### Remove All Provisioned Resources

Switch to the Terraform directory:

    $ cd terraform

Apply changes:

    $ terraform destroy

