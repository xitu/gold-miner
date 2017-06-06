> * 原文地址：[REST 2.0 Is Here and Its Name Is GraphQL](https://www.sitepoint.com/rest-2-0-graphql/)
> * 原文作者：[Michael Paris](https://www.sitepoint.com/author/mparis/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# REST 2.0 Is Here and Its Name Is GraphQL #

![Abstract network design representing GraphQL querying data](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2017/05/1495045443Fotolia_71313802_Subscription_Monthly_M-1024x724.jpg) 

GraphQL is a query language for APIs. Although it’s fundamentally different than REST, GraphQL can serve as an alternative to REST that offers performance, a great developer experience, and very powerful tools.

Throughout this article, we’re going to look at how you might tackle a few common use-cases with REST and GraphQL. This article comes complete with three projects. You will find the code for REST and GraphQL APIs that serve information about popular movies and actors as well as a simple frontend app built with HTML and jQuery. 

We’re going to use these APIs to look into how these technologies are different so that we can identify their strengths and weaknesses. To start, however, let’s set the stage by taking a quick look at how these technologies came to be.

![](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2017/04/14918074751489563681243c760b-dcef-4ab0-b6ac-9a1e1e654483.png)

## Ending Soon: Get Every SitePoint Ebook and Course for FREE! ##

87 Ebooks, 70 Courses and 300+ Tutorials all yours for FREE with ANY web hosting plan from SiteGround!
[Claim This Deal!](https://www.sitepoint.com/premium/l/sitepoint-premium-siteground-ma) 

## The Early Days of the Web ##

The early days of the web were simple. Web applications began as static HTML documents served over the early internet. Websites advanced to include dynamic content stored in databases (e.g. SQL) and used JavaScript to add interactivity. The vast majority of web content was viewed through web browsers on desktop computers and all was good with the world.

![Normal Image](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2017/05/1494257477001-TraditionalWebserver.png)

## REST: The Rise of the API ##

Fast forward to 2007 when Steve Jobs introduced the iPhone. In addition to the far-reaching impacts that the smartphone would have on the world, culture, and communications, it also made developers’ lives a lot more complicated. The smartphone disrupted the development status quo. In a few short years, we suddenly had desktops, iPhones, Androids, and tablets. 

In response, developers started using [RESTful APIs](https://en.wikipedia.org/wiki/Representational_state_transfer) to serve data to applications of all shapes and sizes. The new development model looked something like this:

![REST Server](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2017/05/1494257479002-RestfulServer.png)

## GraphQL: The Evolution of the API ##

GraphQL is a **query language for APIs** that was designed and open-sourced by Facebook. You can think of GraphQL as an alternative to REST for building APIs. Whereas REST is a conceptual model that you can use to design and implement your API, GraphQL is a standardized language, type system, and specification that creates a strong contract between client and server. Having a standard language through which all of our devices communicate simplifies the process of creating large, cross-platform applications. 

With GraphQL our diagram simplifies:

![GraphQL Server](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2017/05/1494257483003-GraphQLServer.png)

## GraphQL vs REST ##

Throughout the rest of this tutorial (no pun intended), I encourage you to follow along with code! You can find the code for this article in [the accompanying GitHub repo](https://github.com/sitepoint-editors/sitepoint-graphql-article). 

The code includes three projects: 

1. A RESTful API 
2. a GraphQL API and 
3. a simple client web page built with jQuery and HTML. 

The projects are purposefully simple and were designed to provide as simple a comparison between these technologies as possible.

If you would like to follow along open up three terminal windows and `cd` to the `RESTful`, `GraphQL`, and `Client` directories in the project repository. From each of these directories, run the development server via `npm run dev`. Once you have the servers ready, keep reading :)

## Querying with REST ##

Our RESTful API contains a few endpoints:

![Markdown](http://i4.buimg.com/1949/6c5d1503224ef6b2.png)

> **Note**: Our simple data model already has 6 endpoints that we need to maintain and document.

Let’s imagine that we are client developers that need to use our movies API to build a simple web page with HTML and jQuery. To build this page, we need information about our movies as well as the actors that appear in them. Our API has all the functionality we might need so let’s go ahead and fetch the data.

If you open a new terminal and run

```
curl localhost:3000/movies

```

You should get a response that looks like this:

```
[
  {
    "href": "http://localhost:3000/movie/1"
  },
  {
    "href": "http://localhost:3000/movie/2"
  },
  {
    "href": "http://localhost:3000/movie/3"
  },
  {
    "href": "http://localhost:3000/movie/4"
  },
  {
    "href": "http://localhost:3000/movie/5"
  }
]
```

In RESTful fashion, the API returned an array of links to the actual movie objects. We can then go grab the first movie by running `curl http://localhost:3000/movie/1` and the second with `curl http://localhost:3000/movie/2` and so on and so forth.

If you look at `app.js` you can see our function for fetching all the data we need to populate our page:

```
const API_URL = 'http://localhost:3000/movies';
function fetchDataV1() {

  // 1 call to get the movie links
  $.get(API_URL, movieLinks => {
    movieLinks.forEach(movieLink => {

      // For each movie link, grab the movie object
      $.get(movieLink.href, movie => {
        $('#movies').append(buildMovieElement(movie))

        // One call (for each movie) to get the links to actors in this movie
        $.get(movie.actors, actorLinks => {
          actorLinks.forEach(actorLink => {

            // For each actor for each movie, grab the actor object
            $.get(actorLink.href, actor => {
              const selector = '#' + getMovieId(movie) + ' .actors';
              const actorElement = buildActorElement(actor);
              $(selector).append(actorElement);
            })
          })
        })
      })
    })
  })
}
```

As you might notice, this is less than ideal. When all is said and done we have made `1 + M + M + sum(Am)` round trip calls to our API where **M** is the number of movies and **sum(Am)** is the sum of the number of acting credits in each of the M movies. For applications with small data requirements, this might be okay but it would never fly in a large, production system.

Conclusion? Our simple RESTful approach is not adequate. To improve our API, we might go ask someone on the backend team to build us a special `/moviesAndActors` endpoint to power this page. Once that endpoint is ready, we can replace our `1 + M + M + sum(Am)` network calls with a single request.

```
curl http://localhost:3000/moviesAndActors

```

This now returns a payload that should look something like this:

```
[
  {
    "id": 1,
    "title": "The Shawshank Redemption",
    "release_year": 1993,
    "tags": [
      "Crime",
      "Drama"
    ],
    "rating": 9.3,
    "actors": [
      {
        "id": 1,
        "name": "Tim Robbins",
        "dob": "10/16/1958",
        "num_credits": 73,
        "image": "https://images-na.ssl-images-amazon.com/images/M/MV5BMTI1OTYxNzAxOF5BMl5BanBnXkFtZTYwNTE5ODI4._V1_.jpg",
        "href": "http://localhost:3000/actor/1",
        "movies": "http://localhost:3000/actor/1/movies"
      },
      {
        "id": 2,
        "name": "Morgan Freeman",
        "dob": "06/01/1937",
        "num_credits": 120,
        "image": "https://images-na.ssl-images-amazon.com/images/M/MV5BMTc0MDMyMzI2OF5BMl5BanBnXkFtZTcwMzM2OTk1MQ@@._V1_UX214_CR0,0,214,317_AL_.jpg",
        "href": "http://localhost:3000/actor/2",
        "movies": "http://localhost:3000/actor/2/movies"
      }
    ],
    "image": "https://images-na.ssl-images-amazon.com/images/M/MV5BODU4MjU4NjIwNl5BMl5BanBnXkFtZTgwMDU2MjEyMDE@._V1_UX182_CR0,0,182,268_AL_.jpg",
    "href": "http://localhost:3000/movie/1"
  },
  ...
]
```

Great! In a single request, we were able to fetch all the data we needed to populate the page. Looking back at `app.js` in our `Client` directory we can see the improvement in action:

```
const MOVIES_AND_ACTORS_URL = 'http://localhost:3000/moviesAndActors';
function fetchDataV2() {
  $.get(MOVIES_AND_ACTORS_URL, movies => renderRoot(movies));
}
function renderRoot(movies) {
  movies.forEach(movie => {
    $('#movies').append(buildMovieElement(movie));
    movie.actors && movie.actors.forEach(actor => {
      const selector = '#' + getMovieId(movie) + ' .actors';
      const actorElement = buildActorElement(actor);
      $(selector).append(actorElement);
    })
  });
}

```

Our new application will be much speedier than the last iteration, but it is still not perfect. If you open up `http://localhost:4000` and look at our simple web page you should see something like this:

![Demo App](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2017/05/1494257488004-DemoApp.png)

If you look closely, you’ll notice that our page is using a movie’s title and image, and an actor’s name and image (i.e. we are only using 2 of 8 fields in a movie object and 2 of 7 fields in an actor object). That means we are wasting roughly three-quarters of the information that we are requesting over the network! This excess bandwidth usage can have very real impacts on performance as well as your infrastructure costs!

A savvy backend developer might scoff at this and quickly implement a special query parameter named fields that takes an array of field names that will dynamically determine which fields should be returned in a specific request. 

For example, instead of `curl http://localhost:3000/moviesAndActors` we might have `curl http://localhost:3000/moviesAndActors?fields=title,image`. We might even have another special query parameter `actor_fields` that specifies which fields in the actor models should be included. E.G. `curl http://localhost:3000/moviesAndActors?fields=title,image&actor_fields=name,image`. 

Now, this would be a near optimal implementation for our simple application but it introduces a bad habit where we create custom endpoints for specific pages in our client applications. The problem becomes more apparent when you start building an iOS app that shows different information than your web page and an Android app that shows different information than the iOS app.

Wouldn’t it be nice if we could build a generic API that explicitly represents the entities in our data model as well as the relationships between those entities but that does not suffer from the `1 + M + M + sum(Am)` performance problem? Good news! We can!

## Querying with GraphQL ##

With GraphQL, we can skip directly to the optimal query and fetch all the info we need and nothing more with a simple, intuitive query:

```
query MoviesAndActors {
  movies {
    title
    image
    actors {
      image
      name
    }
  }
}

```

Seriously! To try it yourself, open GraphiQL (the awesome browser based GraphQL IDE) at [http://localhost:5000](http://localhost:5000) and run the query above. 

Now, let’s dive a little deeper.

## Thinking in GraphQL ##

GraphQL takes a fundamentally different approach to APIs than REST. Instead of relying on HTTP constructs like verbs and URIs, it layers an intuitive query language and powerful type system on top of our data. The type system provides a strongly-typed contract between the client and server, and the query language provides a mechanism that the client developer can use to performantly fetch any data he or she might need for any given page.

GraphQL encourages you to think about your data as a virtual graph of information. Entities that contain information are called types and these types can relate to one another via fields. Queries start at the root and traverse this virtual graph while grabbing the information they need along the way. 

This “virtual graph” is more explicitly expressed as a **schema**. A **schema** is a collection of types, interfaces, enums, and unions that make up your API’s data model. GraphQL even includes a convenient schema language that we can use to define our API. For example, this is the schema for our movie API:

```
schema {
    query: Query
}

type Query {
    movies: [Movie]
    actors: [Actor]
    movie(id: Int!): Movie
    actor(id: Int!): Actor
    searchMovies(term: String): [Movie]
    searchActors(term: String): [Actor]
}

type Movie {
    id: Int
    title: String
    image: String
    release_year: Int
    tags: [String]
    rating: Float
    actors: [Actor]
}

type Actor {
    id: Int
    name: String
    image: String
    dob: String
    num_credits: Int
    movies: [Movie]
}

```

The type system opens the door for a lot of awesome stuff including better tools, better documentation, and more efficient applications. There is so much we could talk about, but for now, let’s skip ahead and highlight a few more scenarios that showcase the differences between REST and GraphQL.

## GraphQL vs Rest: Versioning ##

A [simple google search](https://www.google.com/search?q=REST+versioning&amp;oq=REST+versioning) will result in many opinions on the best way to version (or evolve) a REST API. We’re not going to go down that rabbit hole, but I do want to stress that this is a non-trivial problem. One of the reasons that versioning is so difficult is that it is often very difficult to know what information is being used and by which applications or devices.

Adding information is generally easy with both REST and GraphQL. Add the field and it will flow down to your REST clients and will be safely ignored in GraphQL until you change your queries. However, removing and editing information is a different story.

In REST, it is hard to know at the field level what information is being used. We might know that an endpoint `/movies` is being used but we don’t know if the client is using the title, the image, or both. A possible solution is to add a query parameter `fields` that specifies which fields to return, but these parameters are almost always optional. For this reason, you will often see evolution occur at the endpoint level where we introduce a new endpoint `/v2/movies`. This works but also increases the surface area of our API as well as adds a burden on the developer to keep up to date and comprehensive documentation.

Versioning in GraphQL is very different. Every GraphQL query is required to state exactly what fields are being requested in any given query. The fact that this is mandatory means that we know exactly what information is being requested and allows us to ask the question of how often and by who. GraphQL also includes primitives that allow us to decorate a schema with deprecated fields and messages for why they are being deprecated.

This is what versioning looks like in GraphQL:

![Versioning in GraphQL](https://philsturgeon.uk/images/article_images/2017-01-24-graphql-vs-rest-overview/graphql-versioning-marketing-site.gif)

## GraphQL vs REST: Caching ##

Caching in REST is straightforward and effective. In fact, caching is [one of the six guiding constraints of REST](https://en.wikipedia.org/wiki/Representational_state_transfer) and is baked into RESTful designs. If a response from an endpoint `/movies/1` indicates that the response can be cached, any future requests to `/movies/1` can simply be replaced by the item in the cache. Simple.

Caching in GraphQL is tackled slightly differently. Caching a GraphQL API will often require introducing some sort of unique identifier for each object in the API. When each object has a unique identifier, clients can build normalized caches that use this identifier to reliably cache, update, and expire objects. When the client issues downstream queries that reference that object, the cached version of the object can be used instead. If you are interested in learning more about how caching in GraphQL works here is a [good article that covers the subject more in depth](http://graphql.org/learn/caching/).

## GraphQL vs REST: Developer Experience ##

Developer experience is an extremely important aspect of application development and is the reason we as engineers invest so much time into building good tooling. The comparison here is somewhat subjective but I think still important to mention.

REST is tried and true and has a rich ecosystem of tools to help developers document, test, and inspect RESTful APIs. With that being said there is a huge price developers pay as REST APIs scale. The number of endpoints quickly becomes overwhelming, inconsistencies become more apparent, and versioning remains difficult.

GraphQL really excels in the developer experience department. The type system has opened the door for awesome tools such as the GraphiQL IDE, and documentation is built into the schema itself. In GraphQL there is also only ever one endpoint, and, instead of relying on documentation to discover what data is available, you have a type safe language and auto-complete which you can use to quickly get up to speed with an API. GraphQL was also designed to work brilliantly with modern front-end frameworks and tools like React and Redux. If you are thinking of building an application with React, I highly recommend you check out either [Relay](https://facebook.github.io/relay/) or [Apollo client](https://github.com/apollographql/apollo-client).

## Conclusion ##

GraphQL offers a somewhat more opinionated yet extremely powerful set of tools for building efficient data-driven applications. REST is not going to disappear anytime soon but there is a lot to be desired especially when it comes to building client applications. 

If you are interested in learning more, check out [Scaphold.io’s GraphQL Backend as a Service](https://scaphold.io). In a [few minutes you will have a production ready GraphQL API deployed on AWS](https://www.youtube.com/watch?v=yaacnYUqY1Q) and ready to be customized and extended with your own business logic. 

I hope you enjoyed this post and if you have any thoughts or comments, I would love to hear from you. Thanks for reading!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
