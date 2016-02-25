# What are Google Cloud Functions?

> **Alpha**
> 
> This is an Alpha release of Google Cloud Functions. This feature might be changed in backward-incompatible ways and is not recommended for production use. It is not subject to any SLA or deprecation policy. [Request to be whitelisted to use this feature](https://docs.google.com/forms/d/1WQNWPK3xdLnw4oXPT_AIVR9-gd6DLo5ZIucyxzSQ5fQ/viewform).

Google Cloud Functions is a lightweight, event-based, asynchronous compute solution that allows you to create small, single-purpose functions that respond to cloud events without the need to manage a server or a runtime environment.

Cloud Functions are written in Javascript and execute in a managed Node.js environment on Google Cloud Platform. Events from Google Cloud Storage and Google Cloud Pub/Sub can trigger Cloud Functions asynchronously, or you can use HTTP invocation for synchronous execution.

## Cloud Events and Triggers

Cloud Events are _things that happen_ in your cloud environment. These might be things like changes to data in a database, files added to a storage system, or a new virtual machine instance being created.

Events occur whether or not you choose to respond to them. Creating a response to an event is done with a _Trigger_. A trigger is a declaration that you are interested in a certain event or set of events. You create triggers to capture _events_ and act on them.

## Cloud Functions

Cloud Functions are the mechanism you use to respond to events. Your Cloud Functions contain the code that executes in response to a _Trigger_ in order to process an _Event_.
