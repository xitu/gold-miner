> * 原文地址：[How To Mock Services Using Mountebank and Node.js](https://www.digitalocean.com/community/tutorials/how-to-mock-services-using-mountebank-and-node-js)
> * 原文作者：[Dustin Ewers](https://www.digitalocean.com/community/users/dustinjewers) 
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-mock-services-using-mountebank-and-node-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-mock-services-using-mountebank-and-node-js.md)
> * 译者：
> * 校对者

# How To Mock Services Using Mountebank and Node.js

## Introduction

In complex [service-oriented architectures (SOA)](https://en.wikipedia.org/wiki/Service-oriented_architecture), programs often need to call multiple services to run through a given workflow. This is fine once everything is in place, but if the code you are working on requires a service that is still in development, you can be stuck waiting for other teams to finish their work before beginning yours. Additionally, for testing purposes you may need to interact with external vendor services, like a weather API or a record-keeping system. Vendors usually don't give you as many environments as you need, and often don't make it easy to control test data on their systems. In these situations, unfinished services and services outside of your control can make code testing frustrating.

The solution to all of these problems is to create a *service mock*. A service mock is code that simulates the service that you would use in the final product, but is lighter weight, less complex, and easier to control than the actual service you would use in production. You can set a mock service to return a default response or specific test data, then run the software you're interested in testing as if the dependent service were really there. Because of this, having a flexible way to mock services can make your workflow faster and more efficient.

In an enterprise setting, making mock services is sometimes called *service virtualization*. Service virtualization is often associated with expensive enterprise tools, but you don't need an expensive tool to mock a service. [Mountebank](http://www.mbtest.org/) is a free and open source service-mocking tool that you can use to mock HTTP services, including [REST](https://en.wikipedia.org/wiki/Representational_state_transfer) and [SOAP](https://en.wikipedia.org/wiki/SOAP) services. You can also use it to mock [SMTP](https://en.wikipedia.org/wiki/Simple_Mail_Transfer_Protocol) or [TCP](https://en.wikipedia.org/wiki/Transmission_Control_Protocol) requests.

In this guide, you will build two flexible service-mocking applications using [Node.js](https://nodejs.org/en/about/) and Mountebank. Both of the mock services will listen to a specific port for REST requests in HTTP. In addition to this simple mocking behavior, the service will also retrieve mock data from a [*comma-separated values* (CSV) file](https://en.wikipedia.org/wiki/Comma-separated_values). After this tutorial, you'll be able to mock all kinds of service behavior so you can more easily develop and test your applications.

### Prerequisites

To follow this tutorial, you will need the following:

- Version 8.10.0 or higher of Node.js installed on your machine. This tutorial will use version 8.10.0. To install Node.js, check out [How To Install Node.js on Ubuntu 18.04](https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-18-04) or [How to Install Node.js and Create a Local Development Environment on macOS](https://www.digitalocean.com/community/tutorials/how-to-install-node-js-and-create-a-local-development-environment-on-macos).
- A tool to make HTTP requests, like [cURL](https://curl.haxx.se/) or [Postman](https://www.getpostman.com/). This tutorial will use cURL, since it's installed by default on most machines; if your machine does not have cURL, please see the[install documentation](https://curl.haxx.se/docs/install.html).

### Step 1 --- Starting a Node.js Application

In this step, you are going to create a basic Node.js application that will serve as the base of your Mountebank instance and the mock services you will create in later steps.

Note: Mountebank can be used as a standalone application by installing it globally using the command `npm install -g mountebank`. You can then run it with the `mb` command and add mocks using REST requests.

While this is the fastest way to get Mountebank up and running, building the Mountebank application yourself allows you to run a set of predefined mocks when the app starts up, which you can then store in source control and share with your team. This tutorial will build the Mountebank application manually to take advantage of this.

First, create a new directory to put your application in. You can name it whatever you want, but in this tutorial we'll name it `app`:

```bash
mkdir app
```

Move into your newly created directory with the following command:

```bash
cd app
```

To start a new Node.js application, run `npm init` and fill out the prompts:

```bash
npm init
```

The data from these prompts will be used to fill out your `package.json` file, which describes what your application is, what packages it relies on, and what different scripts it uses. In Node.js applications, scripts define commands that build, run, and test your application. You can go with the defaults for the prompts or fill in your package name, version number, etc.

After you finish this command, you'll have a basic Node.js application, including the `package.json` file.

Now install the Mountebank npm package using the following:

```bash
npm install -save mountebank
```

This command grabs the Mountebank package and installs it to your application. Make sure to use the `-save` flag in order to update your `package.json` file with Mountebank as a dependency.

Next, add a start script to your `package.json` that runs the command `node src/index.js`. This script defines the entry point of your app as `index.js`, which you'll create in a later step.

Open up `package.json` in a text editor. You can use whatever text editor you want, but this tutorial will use nano.

```bash
nano package.json
```

Navigate to the `"scripts"` section and add the line `"start": "node src/index.js"`. This will add a `start` command to run your application.

Your `package.json` file should look similar to this, depending on how you filled in the initial prompts:

```json
{
  "name": "diy-service-virtualization",
  "version": "1.0.0",
  "description": "An application to mock services.",
  "main": "index.js",
  "scripts": {
    "start": "node src/index.js"
  },
  "author": "Dustin Ewers",
  "license": "MIT",
  "dependencies": {
    "mountebank": "^2.0.0"
  }
}
```

You now have the base for your Mountebank application, which you built by creating your app, installing Mountebank, and adding a start script. Next, you'll add a settings file to store application-specific settings.

### Step 2 --- Creating a Settings File

In this step, you will create a settings file that determines which ports the Mountebank instance and the two mock services will listen to.

Each time you run an instance of Mountebank or a mock service, you will need to specify what network port that service will run on (e.g., `http://localhost:5000/`). By putting these in a settings file, the other parts of your application will be able to import these settings whenever they need to know the port number for the services and the Mountebank instance. While you could directly code these into your application as constants, changing the settings later will be easier if you store them in a file. This way, you will only have to change the values in one place.

Begin by making a directory called `src` from your `app` directory:

```bash
mkdir src
```

Navigate to the folder you just created:

```bash
cd src
```

Create a file called `settings.js` and open it in your text editor:

```bash
nano settings.js
```

Next, add settings for the ports for the main Mountebank instance and the two mock services you'll create later:

```js
module.exports = {
    port: 5000,
    hello_service_port: 5001,
    customer_service_port: 5002
}
```

This settings file has three entries: `port: 5000` assigns port `5000` to the main Mountebank instance, `hello_service_port: 5001` assigns port `5001` to the Hello World test service that you will create in a later step, and `customer_service_port: 5002` assigns port `5002` to the mock service app that will respond with CSV data. If the ports here are occupied, feel free to change them to whatever you want. `module.exports =` makes it possible for your other files to import these settings.

In this step, you used `settings.js` to define the ports that Mountebank and your mock services will listen to and made these settings available to other parts of your app. In the next step, you will build an initialization script with these settings to start Mountebank.

### Step 3 --- Building the Initialization Script

In this step, you're going to create a file that starts an instance of Mountebank. This file will be the entry point of the application, meaning that, when you run the app, this script will run first. You will add more lines to this file as you build new service mocks.

From the `src` directory, create a file called `index.js` and open it in your text editor:

```bash
nano index.js
```

To start an instance of Mountebank that will run on the port specified in the `settings.js` file you created in the last step, add the following code to the file:

```js
const mb = require('mountebank');
const settings = require('./settings');

const mbServerInstance = mb.create({
        port: settings.port,
        pidfile: '../mb.pid',
        logfile: '../mb.log',
        protofile: '../protofile.json',
        ipWhitelist: ['*']
    });
```

This code does three things. First, it imports the Mountebank npm package that you installed earlier (`const mb = require('mountebank');`). Then, it imports the settings module you created in the previous step (`const settings = require('./settings');`). Finally, it creates an instance of the Mountebank server with `mb.create()`.

The server will listen at the port specified in the settings file. The `pidfile`, `logfile`, and `protofile` parameters are for files that Mountebank uses internally to record its process ID, specify where it keeps its logs, and set a file to load custom protocol implementations. The `ipWhitelist` setting specifies what IP addresses are allowed to communicate with the Mountebank server. In this case, you're opening it up to any IP address.

Save and exit from the file.

After this file is in place, enter the following command to run your application:

```bash
npm start
```

The command prompt will disappear, and you will see the following:

```
info: [mb:5000] mountebank v2.0.0 now taking orders - point your browser to http://localhost:5000/ for help
```

This means your application is open and ready to take requests.

Next, check your progress. Open up a new terminal window and use `curl` to send the following `GET` request to the Mountebank server:

```bash
curl http://localhost:5000/
```

This will return the following JSON response:

```json
Output{
    "_links": {
        "imposters": {
            "href": "http://localhost:5000/imposters"
        },
        "config": {
            "href": "http://localhost:5000/config"
        },
        "logs": {
            "href": "http://localhost:5000/logs"
        }
    }
}
```

The JSON that Mountebank returns describes the three different endpoints you can use to add or remove objects in Mountebank. By using `curl` to send reqests to these endpoints, you can interact with your Mountebank instance.

When you're done, switch back to your first terminal window and exit the application using `CTRL` + `C`. This exits your Node.js app so you can continue adding to it.

Now you have an application that successfully runs an instance of Mountebank. In the next step, you will create a Mountebank client that uses REST requests to add mock services to your Mountebank application.

### Step 4 --- Building a Mountebank Client

Mountebank communicates using a REST API. You can manage the resources of your Mountebank instance by sending HTTP requests to the different endpoints mentioned in the last step. To add a mock service, you send a HTTP `POST` request to the imposters endpoint. An [*imposter*](http://www.mbtest.org/docs/mentalModel) is the name for a mock service in Mountebank. Imposters can be simple or complex, depending on the behaviors you want in your mock.

In this step, you will build a Mountebank client to automatically send `POST` requests to the Mountebank service. You could send a `POST` request to the imposters endpoint using `curl` or Postman, but you'd have to send that same request every time you restart your test server. If you're running a sample API with several mocks, it will be more efficient to write a client script to do this for you.

Begin by installing the `node-fetch` library:

```bash
npm install -save node-fetch
```

The [`node-fetch` library](https://www.npmjs.com/package/node-fetch) gives you an implementation of the JavaScript Fetch API, which you can use to write shorter HTTP requests. You could use the standard `http` library, but using `node-fetch` is a lighter weight solution.

Now, create a client module to send requests to Mountebank. You only need to post imposters, so this module will have one method.

Use `nano` to create a file called `mountebank-helper.js`:

```bash
nano mountebank-helper.js
```

To set up the client, put the following code in the file:

```js
const fetch = require('node-fetch');
const settings = require('./settings');

function postImposter(body) {
    const url = `http://127.0.0.1:${settings.port}/imposters`;

    return fetch(url, {
                    method:'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(body)
                });
}

module.exports = { postImposter };
```

This code starts off by pulling in the `node-fetch` library and your settings file. This module then exposes a function called `postImposter` that posts service mocks to Mountebank. Next, `body:`determines that the function takes `JSON.stringify(body)`, a JavaScript object. This object is what you're going to `POST` to the Mountebank service. Since this method is running locally, you run your request against `127.0.0.1` (`localhost`). The fetch method takes the object sent in the parameters and sends the `POST` request to the `url`.

In this step, you created a Mountebank client to post new mock services to the Mountebank server. In the next step, you'll use this client to create your first mock service.

### Step 5 --- Creating Your First Mock Service

In previous steps, you built an application that creates a Mountebank server and code to call that server. Now it's time to use that code to build an imposter, or a mock service.

In Mountebank, each imposter contains [*stubs*](http://www.mbtest.org/docs/mentalModel). Stubs are configuration sets that determine the response that an imposter will give. Stubs can be further divided into combinations of [*predicates*and *responses*](http://www.mbtest.org/docs/mentalModel). A predicate is the rule that triggers the imposter's response. Predicates can use lots of different types of information, including URLs, request content (using XML or JSON), and HTTP methods.

Looked at from the point of view of a [Model-View-Controller (MVC)](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller) app, an imposter acts like a controller and the stubs like actions within that controller. Predicates are routing rules that point toward a specific controller action.

To create your first mock service, create a file called `hello-service.js`. This file will contain the definition of your mock service.

Open `hello-service.js` in your text editor:

```bash
nano hello-service.js
```

Then add the following code:

```js
const mbHelper = require('./mountebank-helper');
const settings = require('./settings');

function addService() {
    const response = { message: "hello world" }

    const stubs = [
        {
            predicates: [ {
                equals: {
                    method: "GET",
                    "path": "/"
                }
            }],
            responses: [
                {
                    is: {
                        statusCode: 200,
                        headers: {
                            "Content-Type": "application/json"
                        },
                        body: JSON.stringify(response)
                    }
                }
            ]
        }
    ];

    const imposter = {
        port: settings.hello_service_port,
        protocol: 'http',
        stubs: stubs
    };

    return mbHelper.postImposter(imposter);
}

module.exports = { addService };
```

This code defines an imposter with a single stub that contains a predicate and a response. Then it sends that object to the Mountebank server. This code will add a new mock service that listens for `GET` requests to the root `url` and returns `{ message: "hello world" }` when it gets one.

Let's take a look at the `addService()` function that the preceding code creates. First, it defines a response message `hello world`:

```js
    const response = { message: "hello world" }
...
```

Then, it defines a stub:

```js
...
        const stubs = [
        {
            predicates: [ {
                equals: {
                    method: "GET",
                    "path": "/"
                }
            }],
            responses: [
                {
                    is: {
                        statusCode: 200,
                        headers: {
                            "Content-Type": "application/json"
                        },
                        body: JSON.stringify(response)
                    }
                }
            ]
        }
    ];
...
```

This stub has two parts. The predicate part is looking for a `GET` request to the root (`/`) URL. This means that `stubs` will return the response when someone sends a `GET` request to the root URL of the mock service. The second part of the stub is the `responses` array. In this case, there is one response, which returns a JSON result with an HTTP status code of `200`.

The final step defines an imposter that contains that stub:

```js
...
    const imposter = {
        port: settings.hello_service_port,
        protocol: 'http',
        stubs: stubs
    };
...
```

This is the object you're going to send to the `/imposters` endpoint to create an imposter that mocks a service with a single endpoint. The preceding code defines your imposter by setting the `port` to the port you determined in the settings file, setting the `protocol` to HTTP, and assigning `stubs` as the imposter's stubs.

Now that you have a mock service, the code sends it to the Mountebank server:

```js
...
    return mbHelper.postImposter(imposter);
...
```

As mentioned before, Mountebank uses a REST API to manage its objects. The preceding code uses the `postImposter()` function that you defined earlier to send a `POST` request to the server to activate the service.

Once you are finished with `hello-service.js`, save and exit from the file.

Next, call the newly created `addService()` function in `index.js`. Open the file in your text editor:

```bash
nano index.js
```

To make sure that the function is called when the Mountebank instance is created, add the following highlighted lines:

```js
const mb = require('mountebank');
const settings = require('./settings');
const helloService = require('./hello-service');

const mbServerInstance = mb.create({
        port: settings.port,
        pidfile: '../mb.pid',
        logfile: '../mb.log',
        protofile: '../protofile.json',
        ipWhitelist: ['*']
    });

mbServerInstance.then(function() {
    helloService.addService();
});
```

When a Mountebank instance is created, it returns a *promise*. A promise is an object that does not determine its value until later. This can be used to simplify asynchronous function calls. In the preceding code, the `.then(function(){...})` function executes when the Mountebank server is initialized, which happens when the promise resolves.

Save and exit `index.js`.

To test that the mock service is created when Mountebank initializes, start the application:

```bash
npm start
```

The Node.js process will occupy the terminal, so open up a new terminal window and send a `GET`request to `http://localhost:5001/`:

```bash
curl http://localhost:5001
```

You will receive the following response, signifying that the service is working:

```
Output{"message": "hello world"}
```

Now that you tested your application, switch back to the first terminal window and exit the Node.js application using `CTRL` + `C`.

In this step, you created your first mock service. This is a test service mock that returns `hello world` in response to a `GET` request. This mock is meant for demonstration purposes; it doesn't really give you anything you couldn't get by building a small Express application. In the next step, you'll create a more complex mock that takes advantage of some of Mountebank's features.

### Step 6 --- Building a Data-Backed Mock Service

While the type of service you created in the previous step is fine for some scenarios, most tests require a more complex set of responses. In this step, you're going to create a service that takes a parameter from the URL and uses it to look up a record in a CSV file.

First, move back to the main `app` directory:

```bash
cd ~/app
```

Create a folder called `data`:

```bash
mkdir data
```

Open a file for your customer data called `customers.csv`:

```bash
nano data/customers.csv
```

Add in the following test data so that your mock service has something to retrieve:

```csv
id,first_name,last_name,email,favorite_color
1,Erda,Birkin,ebirkinb@google.com.hk,Aquamarine
2,Cherey,Endacott,cendacottc@freewebs.com,Fuscia
3,Shalom,Westoff,swestoffd@about.me,Red
4,Jo,Goulborne,jgoulbornee@example.com,Red
```

This is fake customer data generated by the API mocking tool [Mockaroo](https://mockaroo.com/), similar to the fake data you'd load into a customers table in the service itself.

Save and exit the file.

Then, create a new module called `customer-service.js` in the `src` directory:

```bash
nano src/customer-service.js
```

To create an imposter that listens for `GET` requests on the `/customers/` endpoint, add the following code:

```js
const mbHelper = require('./mountebank-helper');
const settings = require('./settings');

function addService() {
    const stubs = [
        {
            predicates: [{
                and: [
                    { equals: { method: "GET" } },
                    { startsWith: { "path": "/customers/" } }
                ]
            }],
            responses: [
                {
                    is: {
                        statusCode: 200,
                        headers: {
                            "Content-Type": "application/json"
                        },
                        body: '{ "firstName": "${row}[first_name]", "lastName": "${row}[last_name]", "favColor": "${row}[favorite_color]" }'
                    },
                    _behaviors: {
                        lookup: [
                            {
                                "key": {
                                  "from": "path",
                                  "using": { "method": "regex", "selector": "/customers/(.*)$" },
                                  "index": 1
                                },
                                "fromDataSource": {
                                  "csv": {
                                    "path": "data/customers.csv",
                                    "keyColumn": "id"
                                  }
                                },
                                "into": "${row}"
                              }
                        ]
                    }
                }
            ]
        }
    ];

    const imposter = {
        port: settings.customer_service_port,
        protocol: 'http',
        stubs: stubs
    };

    return mbHelper.postImposter(imposter);
}

module.exports = { addService };
```

This code defines a service mock that looks for `GET` requests with a URL format of `customers/<id>`. When a request is received, it will query the URL for the `id` of the customer and then return the corresponding record from the CSV file.

This code uses a few more Mountebank features than the `hello` service you created in the last step. First, it uses a feature of Mountebank called [*behaviors*](http://www.mbtest.org/docs/mentalModel). Behaviors are a way to add functionality to a stub. In this case, you're using the `lookup` behavior to look up a record in a CSV file:

```js
...
  _behaviors: {
      lookup: [
          {
              "key": {
                "from": "path",
                "using": { "method": "regex", "selector": "/customers/(.*)$" },
                "index": 1
              },
              "fromDataSource": {
                "csv": {
                  "path": "data/customers.csv",
                  "keyColumn": "id"
                }
              },
              "into": "${row}"
            }
      ]
  }
...
```

The `key` property uses a regular expression to parse the incoming path. In this case, you're taking the `id` that comes after `customers/` in the URL.

The `fromDataSource` property points to the file you're using to store your test data.

The `into` property injects the result into a variable `${row}`. That variable is referenced in the following `body` section:

```js
...
  is: {
      statusCode: 200,
      headers: {
          "Content-Type": "application/json"
      },
      body: '{ "firstName": "${row}[first_name]", "lastName": "${row}[last_name]", "favColor": "${row}[favorite_color]" }'
  },
...
```

The row variable is used to populate the body of the response. In this case, it's a JSON string with the customer data.

Save and exit the file.

Next, open `index.js` to add the new service mock to your initialization function:

```bash
nano src/index.js
```

Add the highlighted line:

```js
const mb = require('mountebank');
const settings = require('./settings');
const helloService = require('./hello-service');
const customerService = require('./customer-service');

const mbServerInstance = mb.create({
        port: settings.port,
        pidfile: '../mb.pid',
        logfile: '../mb.log',
        protofile: '../protofile.json',
        ipWhitelist: ['*']
    });

mbServerInstance.then(function() {
    helloService.addService();
    customerService.addService();
});
```

Save and exit the file.

Now start Mountebank with `npm start`. This will hide the prompt, so open up another terminal window. Test your service by sending a `GET` request to `localhost:5002/customers/3`. This will look up the customer information under `id` `3`.

```bash
curl localhost:5002/customers/3
```

You will see the following response:

```json
Output{
    "firstName": "Shalom",
    "lastName": "Westoff",
    "favColor": "Red"
}
```

In this step, you created a mock service that read data from a CSV file and returned it as a JSON response. From here, you can continue to build more complex mocks that match the services you need to test.

## Conclusion

In this article you created your own service-mocking application using Mountebank and Node.js. Now you can build mock services and share them with your team. Whether it's a complex scenario involving a vendor service you need to test around or a simple mock while you wait for another team to finish their work, you can keep your team moving by creating mock services.

If you want to learn more about Mountebank, check out their [documentation](http://www.mbtest.org/). If you'd like to containerize this application, check out [Containerizing a Node.js Application for Development With Docker Compose](https://www.digitalocean.com/community/tutorials/containerizing-a-node-js-application-for-development-with-docker-compose). If you'd like to run this application in a production-like environment, check out [How To Set Up a Node.js Application for Production on Ubuntu 18.04](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-node-js-application-for-production-on-ubuntu-18-04).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
