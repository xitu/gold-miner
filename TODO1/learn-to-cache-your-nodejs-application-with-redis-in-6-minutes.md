> * 原文地址：[Learn to Cache your NodeJS Application with Redis in 6 Minutes!](https://itnext.io/learn-to-cache-your-nodejs-application-with-redis-in-6-minutes-745a574a9739)
> * 原文作者：[Abdullah Amin](https://medium.com/@abdamin)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/learn-to-cache-your-nodejs-application-with-redis-in-6-minutes.md](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-to-cache-your-nodejs-application-with-redis-in-6-minutes.md)
> * 译者：
> * 校对者：

# Learn to Cache your NodeJS Application with Redis in 6 Minutes!

![](https://cdn-images-1.medium.com/max/4800/1*4DX0Dj0zI2q4MnqeO_Bfbg.png)

Caching your web application is highly essential and can grant high performance gains as you scale. Be it a **search engine** and you want to respond to frequently requested queries with minimum latency, a **URL shortener** and you want to redirect to frequently accessed URLs faster, a **social network** and you want to load popular user profiles quicker, or perhaps a very simple web server that requests data from a third party web API and you have plans to scale, caching data can prove to be very fruitful!

## What is Redis? Why use Redis?

**Redis** is a high performance open source **NoSQL** database primarily used as a caching solution for various types of applications. What is surprising is that it stores all its data in the RAM and promises highly optimized data reads and writes. Redis also supports many different data types and clients based on different programming languages. You can find out more about **Redis**[ here](https://redis.io/topics/introduction).

## Overview

Today, we will implement a basic cache mechanism ****on a **NodeJS** web application ****which requests **Star Wars Starships** information from the **[Star Wars API](https://swapi.co)**. We will learn how to store frequently requested Starships data to our cache. Future requests from our web server will first search the cache and only send a request to the [**Star Wars API**](https://swapi.co) if the cache does not contain the requested data. This will allow us to send less requests to the third party API and overall speed up our application. To make sure that our cache is up to date, the cached value will be set with a time to live (TTL) and will expire after a definite period of time. Sounds exciting? Let’s get started!

## Redis Setup

If you already have Redis installed on your local machine or if you are using a Redis cloud hosting solution, feel free to skip this step.

#### Install on a Mac

Redis can be installed on your Mac using **Homebrew**. If you do not have Homebrew installed on your Mac, you can run the following command on your terminal to install it,

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Now you can install Redis by running the following command on your terminal,

```
brew install redis
```

#### Install on Ubuntu

You can use this [simple guide](https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-redis-on-ubuntu-18-04) to install Redis on your Ubuntu machine.

#### Install on Windows

You can use this [simple guide](https://redislabs.com/blog/redis-on-windows-8-1-and-previous-versions/) to install Redis on your Windows machine.

## Start Redis Server and Redis CLI

On your terminal you can run the following command to start your Redis server locally,

```
redis-server
```

![Start Redis Server](https://cdn-images-1.medium.com/max/4866/1*X8YnTE55NZbp-V7ER4iKLw.png)

To access the Redis CLI, you can run the following command on a separate terminal window/tab,

```
redis-cli
```

![Redis CLI](https://cdn-images-1.medium.com/max/2874/1*lPYgPudVRWd1HoJA5khQsQ.png)

Just like any other database solution installed locally on your machine, you can interact with Redis using its CLI. I recommend you to checkout this guide on the [Redis CLI](https://redis.io/topics/rediscli). However, we will only focus on setting up Redis as a caching solution for our NodeJS web application and interact with it through our web server only.

## NodeJS Project Setup

In a separate folder, run **npm init** to setup your NodeJS project.

![NodeJS App Setup with **npm init**](https://cdn-images-1.medium.com/max/3728/1*sVU5v2M6FEOMd9LtLaMoOQ.png)

#### Project Dependencies

We will use a set of dependencies with our NodeJS application. Run the following command in the terminal from your our directory,

```
npm i express redis axios
```

**Express** will help us set our server. We will use the **redis** package to connect our app to the Redis server running locally on our machine and we will use **axios** to make requests to the [**Star Wars API**](https://swapi.co) to fetch data.

#### Dev Dependencies

We will also use **nodemon** as our **dev-dependency** to be able to save and run our changes to our server without having to restart it. Run the following command in the terminal from our project directory,

```
npm i -D nodemon
```

#### Setup start script in package.json

Replace the existing scripts in **package.json** with the following script so that we can run our server with **nodemon**,

```
"start": "nodemon index"
```

```JSON
{
  "name": "redis-node-tutorial",
  "version": "1.0.0",
  "description": "A step by step guide to setup caching with Redis on a NodeJS Web Application",
  "main": "index.js",
  "scripts": {
    "start": "nodemon index"
  },
  "repository": {
    "type": "git",
    "url": "git+https://github.com/abdamin/redis-node-tutorial.git"
  },
  "author": "Abdullah Amin",
  "license": "ISC",
  "bugs": {
    "url": "https://github.com/abdamin/redis-node-tutorial/issues"
  },
  "homepage": "https://github.com/abdamin/redis-node-tutorial#readme",
  "dependencies": {
    "axios": "^0.19.0",
    "express": "^4.17.1",
    "redis": "^2.8.0"
  },
  "devDependencies": {
    "nodemon": "^1.19.4"
  }
}

```

#### Setup our Initial Server Entry Point : index.js

Run the following command in the terminal from our project directory to create the **index.js** file,

```
touch index.js
```

The following is what our **index.js** file will look like after adding some code,

```JavaScript
//set up dependencies
const express = require("express");
const redis = require("redis");
const axios = require("axios");
const bodyParser = require("body-parser");

//setup port constants
const port_redis = process.env.PORT || 6379;
const port = process.env.PORT || 5000;

//configure redis client on port 6379
const redis_client = redis.createClient(port_redis);

//configure express server
const app = express();

//Body Parser middleware
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

//listen on port 5000;
app.listen(port, () => console.log(`Server running on Port ${port}`));
```

If you have worked with **NodeJS** and **ExpressJS** before, this should look pretty straightforward. First, we set up the dependencies that we previously installed using npm. Secondly, we setup our port constants and create our Redis client. Also, we configure our Redis client on **port 6379** and our Express server on **port 5000**. We also setup **Body-Parser** on our server to be able to parse JSON data. You can run the following command in the terminal to run the web server using the start script from **package.json**,

```
npm start
```

**Note** that our Redis server should be running on another terminal, as mentioned earlier, in order to successfully connect our NodeJS app to Redis.

You should now be able to see the following output on your terminal indicating that your web server is running on **port 5000**,

![](https://cdn-images-1.medium.com/max/2876/1*1W6F-j0EtdYKDrgJj4hjHg.png)

## Setup Server Endpoint to send a request to the Star Wars API

Now that we have our project setup, let’s write some code to setup an endpoint to send a **GET** request to the **Star Wars API** to get Starships data.

Note that we will make a GET request to **[https://swapi.co/api/starships/](https://swapi.co/api/starships/${id}):id** to fetch the data of a Starship corresponding to the identifier **id** in our URL.

The following is how our endpoint will look like,

```
// Endpoint:  GET /starships/:id

// @desc Return Starships data for particular starship id

app.get("/starships/:id", async (req, res) => {

  try {

       const { id } = req.params;

       const starShipInfo = await axios.get(

       `https://swapi.co/api/starships/${id}`
       );

       
       //get data from response

       const starShipInfoData = starShipInfo.data;


       return res.json(starShipInfoData);

  } 
  catch (error) {
       
       console.log(error);

       return res.status(500).json(error);

   }

});
```

We will use a traditional **async** call back function with try and catch blocks to make GET requests to the **Star Wars API** using **axios**. On success, our endpoint will return the data of the Starship corresponding to the id in the URL. Otherwise our endpoint will respond with an error. Simple.

```JavaScript
//set up dependencies
const express = require("express");
const redis = require("redis");
const axios = require("axios");
const bodyParser = require("body-parser");

//setup port constants
const port_redis = process.env.PORT || 6379;
const port = process.env.PORT || 5000;

//configure redis client on port 6379
const redis_client = redis.createClient(port_redis);

//configure express server
const app = express();

//Body Parser middleware
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

//  Endpoint:  GET /starships/:id
//  @desc Return Starships data for particular starship id
app.get("/starships/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const starShipInfo = await axios.get(
      `https://swapi.co/api/starships/${id}`
    );

    //get data from response
    const starShipInfoData = starShipInfo.data;

    return res.json(starShipInfoData);
  } catch (error) {
    console.log(error);
    return res.status(500).json(error);
  }
});

app.listen(port, () => console.log(`Server running on Port ${port}`));

```

Let’s try running our endpoint by searching for a Starship with **id=9.**

![http://localhost:5000/starships/9](https://cdn-images-1.medium.com/max/5684/1*8omThnreKe-2gQHS29U9Rw.png)

Woah! That works. But did you notice the time it took to fulfill the request? In order to do this, you can check the network tab under chrome developer tools in your browser.

**769 ms.** That is slow! This is where **Redis** comes to rescue.

## Implement Redis Cache for our Endpoint

#### Add to Cache

Since Redis stores data in key value pairs, we need to make sure that whenever a request is made to the Star Wars API and we receive a successful response, we store the Starship id paired with its data in our cache.

In order to do that we will add the following line of code to our endpoint after we receive a response from the Star Wars API,

```
//add data to Redis

redis_client.setex(id, 3600, JSON.stringify(starShipInfoData));
```

The above command allows us to add **key=id** with **expiration=3600 seconds** and **value= JSON Stringified formatted data of our Starship** to the cache. This is what our **index.js** should now look like,

```JavaScript
//set up dependencies
const express = require("express");
const redis = require("redis");
const axios = require("axios");
const bodyParser = require("body-parser");

//setup port constants
const port_redis = process.env.PORT || 6379;
const port = process.env.PORT || 5000;

//configure redis client on port 6379
const redis_client = redis.createClient(port_redis);

//configure express server
const app = express();

//Body Parser middleware
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

//  Endpoint:  GET /starships/:id
//  @desc Return Starships data for particular starship id
app.get("/starships/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const starShipInfo = await axios.get(
      `https://swapi.co/api/starships/${id}`
    );

    //get data from response
    const starShipInfoData = starShipInfo.data;

    //add data to Redis
    redis_client.setex(id, 3600, JSON.stringify(starShipInfoData));

    return res.json(starShipInfoData);
  } catch (error) {
    console.log(error);
    return res.status(500).json(error);
  }
});

app.listen(port, () => console.log(`Server running on Port ${port}`));

```

Now if we go to the browser and make a GET request for a Starship, it’s data will also be added to our Redis cache.

![GET Request for Starship id 9](https://cdn-images-1.medium.com/max/5760/1*0uTJdzOcDvPlEX7r3QumHw.png)

As mentioned earlier, you can access the Redis CLI from the terminal using the following command,

```
redis-cli
```

![](https://cdn-images-1.medium.com/max/2884/1*fhmGALJ_lJ6WksnQ9fo1_A.png)

Running the command **get 9** shows us that our data for Starship with **id=9** was indeed added to the cache!

#### Check and Retrieve from Cache

Now we only need to send a GET request to the **Star Wars API** if the data we need does not exist in the cache. We will use **Express middleware** to implement a function that checks our cache before executing the code inside our endpoint. The function will be passed as the **second argument** to our endpoint function.

The middleware function will be as follows,

```
//Middleware Function to Check Cache

checkCache = (req, res, next) => {

       const { id } = req.params;
       
       //get data value for key =id

       redis_client.get(id, (err, data) => {

           if (err) {

               console.log(err);

               res.status(500).send(err);

           }
           //if no match found

           if (data != null) {

               res.send(data);

           } 
           else {
               //proceed to next middleware function

               next();

           }

        });

};
```

```JavaScript
//set up dependencies
const express = require("express");
const redis = require("redis");
const axios = require("axios");
const bodyParser = require("body-parser");

//setup port constants
const port_redis = process.env.PORT || 6379;
const port = process.env.PORT || 5000;

//configure redis client on port 6379
const redis_client = redis.createClient(port_redis);

//configure express server
const app = express();

//Body Parser middleware
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

//Middleware Function to Check Cache
checkCache = (req, res, next) => {
  const { id } = req.params;

  redis_client.get(id, (err, data) => {
    if (err) {
      console.log(err);
      res.status(500).send(err);
    }
    //if no match found
    if (data != null) {
      res.send(data);
    } else {
      //proceed to next middleware function
      next();
    }
  });
};

//  Endpoint:  GET /starships/:id
//  @desc Return Starships data for particular starship id
app.get("/starships/:id", checkCache, async (req, res) => {
  try {
    const { id } = req.params;
    const starShipInfo = await axios.get(
      `https://swapi.co/api/starships/${id}`
    );

    //get data from response
    const starShipInfoData = starShipInfo.data;

    //add data to Redis
    redis_client.setex(id, 3600, JSON.stringify(starShipInfoData));

    return res.json(starShipInfoData);
  } catch (error) {
    console.log(error);
    return res.status(500).json(error);
  }
});

app.listen(port, () => console.log(`Server running on Port ${port}`));

```

Let’s make a GET request again for Starship with **id=9**.

![](https://cdn-images-1.medium.com/max/5760/1*Jmu98b42pna6v4t626M7gg.png)

**115 ms.** That is almost a **7x** performance boost!

## Conclusion

It is important to note that we have only scratched the surface in this tutorial and there is a lot more that Redis has to offer! I highly recommend checking out its [official documentation](https://redis.io/documentation). This is the [**link**](https://github.com/abdamin/redis-node-tutorial) to the **Github** **repository** with the complete code of our application.

If you have any questions, feel free to leave a comment. Also, if this helped you, please like and share it with others. I publish articles related to web development regularly. Consider [**entering your email here**](https://abdullahsumsum.com/subscribe) to stay up to date with articles and tutorials related to web development. You can also find out more about what I do at [**abdullahsumsum.com**](http://abdullahsumsum.com/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
