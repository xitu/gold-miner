# Deploying Cloud Functions

## Building and Testing Locally

Cloud Functions execute in a managed Node.js runtime environment so you can build and test your functions locally just using a standard Node.js runtime along with your favorite development tools.

## Deployment

You can deploy Cloud Functions from your local file system (via a [Google Cloud Storage bucket](https://cloud.google.com/storage/docs/)) or from your Github or Bitbucket source repository (via [Cloud Source Repositories](https://cloud.google.com/tools/cloud-repositories/docs/)).

When deploying, Cloud Functions will look for a file named `index.js` or `function.js`. If you've provided a `package.json` file that contains a `"main"` entry, then Cloud Functions will look for the specified file instead.

**Note:** The first time you deploy a function it may take several minutes as we need to provision the underlying infrastructure to support your functions. Subsequent deployments will be much faster.

### Local file system

Local file system deployments work by uploading a ZIP file containing your function to a Cloud Storage Bucket, then including that bucket in the `deploy` CLI command line. When using the CLI, Cloud Functions zips up the contents of your functions directory for you. Alternatively you can use the Cloud Functions interface in the Cloud Platform Console to upload a ZIP file you make yourself.

#### Create a Cloud Storage Bucket

First you'll need a Cloud Storage Bucket to act as the temporary staging area for your function code.

If you don't already have a Cloud Storage Bucket, follow these steps to create one:

1.  Open the [Cloud Storage Console](https://console.cloud.google.com/project/_/storage/browser).
2.  Create a new bucket.
3.  Type the bucket name (we will use the name "cloud-functions" hereafter), then choose whichever storage class and location you prefer.
4.  Click **Create**.

#### Deploy using the gcloud CLI

Using the `gcloud` CLI, deploy your function from the path containing your function code with the `deploy` command. The command has the following format:

> $ gcloud alpha functions deploy <NAME> --bucket <BUCKET_NAME> <TRIGGER>

Let's look at the arguments in this command:


Argument|Description
----|----
deploy| The Cloud Functions command you are executing, in this case the deploy command.
<NAME>| The name of the Cloud Function you are deploying. This name may contain only lowercase letters, numbers, or hyphens. Unless you specify the --`entry-point` option, your module must export a function with the same name.
--bucket <BUCKET_NAME>| The name of the Cloud Storage bucket where your function source will be uploaded.
<TRIGGER>|The trigger type for this function (see [Calling Cloud Functions](https://cloud.google.com/functions/calling)).
Optional Arguments|
--entry-point <FUNCTION_NAME>|The name of a function that should be used as an entry point, instead of the `<NAME>` argument that is used by default. Use this optional argument when the function exported in your source file has a different name than the `<NAME>` argument you're using to deploy.

The following example deploys a function and assigns it an HTTP trigger:

> $ gcloud alpha functions deploy helloworld --bucket cloud-functions --trigger-http

Let's look at the arguments in this command:

Argument|Description
--------|-----------
deploy|The Cloud Functions command you are executing, in this case the deploy command.
helloworld|The name of the Cloud Function you are deploying, in this case helloworld. The deployed Cloud Function will be registered under the name helloworld, and the source file must export a function named helloworld.
--bucket cloud-functions|The name of the Cloud Storage bucket where your function source will be uploaded, in this case cloud-functions.
--trigger-http|The trigger type for this function, in this case an HTTP request (webhook).

The following example deploys the same function but under a different name:

> $ gcloud alpha functions deploy hello --entry-point helloworld --bucket cloud-functions --trigger-http

Let's look at the arguments in this command:

Argument|Description
--------|-----------
deploy|The Cloud Functions command you are executing, in this case the deploy command.
hello|The name of the Cloud Function you are deploying, in this case hello. The deployed Cloud Function will be registered under the name hello.
--entry-point helloworld|The deployed Cloud Function will use an exported function named helloworld.
--bucket cloud-functions|The name of the Cloud Storage bucket where your function source will be uploaded, in this case cloud-functions.
--trigger-http|The trigger type for this function, in this case an HTTP request (webhook).

The `--entry-point` option is useful when the names of your exported functions do not meet the naming requirements for Cloud Functions.

### Cloud Repositories

If you prefer to deploy your function source code from a source repository like Github or Bitbucket, you can use [Google Cloud Source Repositories](https://cloud.google.com/tools/cloud-repositories/docs) to deploy functions directly from branches or tags in your repository.

#### Set up Cloud Source Repositories

1.  Follow the Cloud Source Repositories [getting started steps](https://cloud.google.com/tools/cloud-repositories/docs/cloud-repositories-setup) to set up your repository.
2.  Connect your Github or Bitbucket repository by following the [hosted repository guide](https://cloud.google.com/tools/cloud-repositories/docs/cloud-repositories-hosted-repository).

Once the connection between Cloud Source Repositories and your external repository is established, these repositories are kept synchronized so that you can commit to your chosen repository as you would normally.

#### Deploy using the `gcloud` CLI

To deploy a function from your source repo, use the `--source-url` command line argument:

> $ gcloud alpha functions deploy helloworld \
>   --source-url https://source.developers.google.com/p/<PROJECT_ID> <TRIGGER>

Let's look at the arguments in this command:

Argument|Description
--------|-----------
deploy|The Cloud Functions command you are executing, in this case the deploy command.
helloworld|The name of the Cloud Function you are deploying, in this case helloworld. The deployed Cloud Function will be registered under the name helloworld, and the source file must export a function named helloworld.
--source-url https://source.developers.google.com/p/<PROJECT_ID>|The URL for the project's Cloud Source Repository. This should be in the form https://source.developers.google.com/p/<PROJECT_ID>, where is your Cloud Project ID.
<TRIGGER>|The trigger type for this function (see Calling Cloud Functions).
Optional Arguments| 
--source <SOURCE>|The path within your source tree that contains your function. For example, "/functions".
--source-branch <SOURCE_BRANCH>|The name of the branch containing your function source.
--source-tag <SOURCE_TAG>|The name of the tag containing your function source.
--source-revision <SOURCE_REVISION>|The name of the revision (commit) containing your function source.

#### Deploy using Cloud Console

If you prefer to use the Cloud Platform Console UI, you can also [create and deploy](https://console.cloud.google.com/project/_/functions/add) functions from the Cloud Functions page in the Cloud Platform Console.
