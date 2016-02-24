# Command Reference

## Cloud Functions CLI

Google Cloud Functions exposes a Command Line Interface (CLI) via the `gcloud` SDK. If you followed [Getting Started](https://cloud.google.com/functions/getting-started), you should already have the `gcloud` tool installed.

### Authentication

To authenticate the `gcloud` tool, execute:

> $ gcloud auth login

### CLI Methods

To see the full list of `gcloud` methods for Cloud Functions, execute:

> $ gcloud alpha functions -h

### Common commands available are:

```
call        Call function synchronously for testing.
delete      Deletes a given function.
deploy      Creates a new function or updates an existing one.
describe    Show description of a function.
get-logs    Show logs produced by functions.
list        Lists all the functions in a given region.
```
You can view detailed help on a single command by using the -h flag. For example:

> $ gcloud alpha functions call -h
>>>>>>> 192a68444477572bd7b56eabb351d05f0e1d7c93
