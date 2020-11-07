> * 原文地址：[Build a GraphQL Server With Spring Boot and MySQL](https://medium.com/better-programming/build-a-graphql-server-with-spring-boot-and-mysql-df427cbba26d)
> * 原文作者：[Yasas Sandeepa](https://medium.com/@yasassandeepa007)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/build-a-graphql-server-with-spring-boot-and-mysql.md](https://github.com/xitu/gold-miner/blob/master/article/2020/build-a-graphql-server-with-spring-boot-and-mysql.md)
> * 译者：
> * 校对者：

# Build a GraphQL Server With Spring Boot and MySQL

![Photo modified by me using resources of [John Peel](https://unsplash.com/@johnpeel?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/3840/1*zttc2YOayk-LuiTYy18c9A.png)

Have you ever wondered that a client can impact an API request? Can he request what he actually needs and get exactly that? If you’re surprised by the questions, I can confirm that you’ve never heard about GraphQL.

So the answer to the above questions will be a definite yes because it’s 100% possible with GraphQL. If you have not heard about it, don’t worry. I’ll walk you through this newest and amazing GraphQL world and you won’t be regret if you get the maximum benefit from this article.

I hope that you are familiar with the Java programming language, the Spring Boot framework, and REST APIs in general. No prior GraphQL experience is required to continue. I know already you are excited about this topic. So why are we waiting? But before moving to the coding, I’ll give a quick overview of GraphQL and the reasons that make it so special.

## The First Step to GraphQL

I know what your mind is struggling to find right now. What the heck is this GraphQL? Take a deep breath and let me explain. Simply it’s a data query and manipulation language for your API.

GraphQL exposes a single endpoint that receives a query from the front-end as part of the request, returning exactly the requested parts of data in a single response. Of course, I must say: Don’t underestimate the power of a common client.

You can get a clear idea by viewing this GIF. Also, this is a part of the app that we are about to implement today.

![How GraphQL works](https://cdn-images-1.medium.com/max/3472/1*aXd1Atpt9B8QI2s9r3r_Ew.gif)

GraphQL is used in production by hundreds of organizations of all sizes including Facebook (Actually GraphQL was internally developed by Facebook in 2012 and then it publicly open-sourced in 2015 ), Credit Karma, GitHub, Intuit, PayPal, the New York Times, and many more.

Hey, wait a minute! What’s about REST then. Isn’t it worthy enough anymore? Check this out!

## The Battle: GraphQL Vs REST

Mostly we are familiar with REST APIs in web developments as it is widely using all over the world. But recently, there is a tendency to move to GraphQL because of its flexibility and performance.

So what is the core difference between REST and GraphQL? REST is an architectural concept for network-based software. GraphQL, on the other hand, is a query language, a specification, and a set of tools that operates over a single endpoint. Let me clear this up with an example.

Imagine you would like to request information from a book entity. At the same time, you’d like to request information about the author (which is a different entity). Typically this is done by sending two requests to the REST API (two GET requests). Endpoints for books and authors might be:

```
localhost:8080/book/:id
localhost:8080/author/:id
```

But with GraphQL, we can fetch not only these two but any information
from one single API endpoint.

```
localhost:8080/graphql
```

Also as you saw in my previous GIF, if you wanted to gather some information from a specific endpoint, we can limit the fields that the GraphQL API returns. But in REST, you’ll always get a complete data set and impossible to limit.

Sometimes the response data are insufficient (like nested results) and you
have to make another request to get what you actually needed. On the other hand, incoming response data are too much (not necessary) and you are only using one or two data fields.

This phenomenon is referred to as under-fetching and over-fetching. GraphQL resolves these issues and optimizes your application. By comparing REST with GraphQL, it’s like a restaurant without a waiter.

However with GraphQL, there is a learning curve, which is not nearly as established as REST APIs, but that learning curve is worth it. When creating user-friendly large applications, the user will be more delighted if he received only the data he requested and nothing else.

As an added bonus, the performance of your application will tremendously increase because you’re not having to process a large amount of data. (The best example is the Facebook app) At scale, any performance improvements you can gain are big wins.

Many different programming languages support GraphQL like Java, JavaScript, Python, Scala, etc. You can find more info on the server and client-side languages by visiting [GraphQL official site](https://graphql.org/code/).

As I’m more familiar with Java and JavaScript, I thought of going Spring Boot application as there are a lesser number of supportive articles to that technology. There are reasonable articles/tutorials on Node.js and it’s not hard to implement with it.

However, if you want an article on implementing a GraphQL server with Node.js, please drop a message in the comments section and I’m extremely happy to write up a separate article on that as well.

Okay, enough talking. Let’s go to some practical stuff. Nothing better than getting a hands-on experience.

## The Foundation: Setting Up the Project

As a simple scenario, I’m creating an app for fetching users and their posts. I am naming this as **WriteUp** and hoping to further develop it in the future.

I’ll be implementing this from scratch. If you are familiar with spring boot, go through this quickly by skipping the basics. So as the first thing, create your new Spring Boot application either through [Spring Initializr](https://start.spring.io/) or with IntelliJ idea.

![](https://cdn-images-1.medium.com/max/3190/1*DEPldJV7a6gZfG_VGlr1HQ.png)

![Screenshots provided by the author.](https://cdn-images-1.medium.com/max/3384/1*ZueIgy3oLM7lND_Eo-4leQ.png)

Make sure to add these dependencies.

1. Spring Data JPA: Handles most of the complexity of JDBC-based database access and ORM (Object Relational Mapping)
reduces the boilerplate code required by JPA.
2. MySQL Driver: Java MySQL connector for connecting with SQL database.
3. Lombok: Reduce boilerplate code for model/data objects. It can automatically generate getters and setters (and many more) for those objects by using Lombok annotations.

![Screenshot provided by the author.](https://cdn-images-1.medium.com/max/2740/1*gj881gOHnanEEmyWoStkEw.png)

All okay. Take a quick break and let the IntelliJ to resolve the dependencies.

## The Essentials: Configuring the Basics

As for the initial setup, we can create the entity models and add some dummy data to our MySQL database.

For that, I created a new package in the root folder and named it as the model, and inside that package, I define my two models user and post. With Lombok, code is clean and no need of generating setters and getters as they can be inserted with annotations. But remember, you have to create a constructor without id fields as it will be required when instantiating.

![User and Post Entities](https://cdn-images-1.medium.com/max/3840/1*rSxPRxwWgyq1ZF5AiwF2OQ.png)

```Java
package com.example.writeup.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import javax.persistence.*;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "USER")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "USER_ID")
    private Integer userId;

    @Column(name = "FIRST_NAME")
    private String firstName;

    @Column(name = "LAST_NAME")
    private String lastName;

    @Column(name = "DOB")
    private Date dob;

    @Column(name = "ADDRESS")
    private String address;

    @Column(name = "POST_ID")
    private Integer postId;

    public User(String firstName, String lastName, Date dob, String address, Integer postId) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.dob = dob;
        this.address = address;
        this.postId = postId;
    }
}
```

Let’s create a repository layer to connect with the database. So, I created a new package named repository, and inside of that, I created two interfaces for the entities and extends with `JpaRepository` . Make sure to add the type of entity and ID specifically in the generic parameters on `JpaRepository`.

We can extend with `CrudRepository`, but I mostly prefer `JpaRepository` because it’s returning a list in find methods rather than an iterable list provided by the curd one. (Also if you want to find more info about these repositories, you can use [this](https://stackoverflow.com/questions/14014086/what-is-difference-between-crudrepository-and-jparepository-interfaces-in-spring) thread.)

```Java
package com.example.writeup.repository;

import com.example.writeup.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {

}

```

Then I implemented a component to add some dummy data to our database. For that, I created a service package, and inside of that, I define a data loader service. This will add the specified data when initializing the project.

```Java
package com.example.writeup.service;

import com.example.writeup.model.Post;
import com.example.writeup.model.User;
import com.example.writeup.repository.PostRepository;
import com.example.writeup.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import javax.annotation.PostConstruct;
import java.util.Calendar;
import java.util.Date;
import java.util.concurrent.ThreadLocalRandom;

@Service
public class DataLoader {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PostRepository postRepository;

    @PostConstruct
    public void loadData(){

        User user1 = new User("Yasas" ,"Sandeepa",DataLoader.getRandomDate(),"Mount Pleasant Estate Galle",1);
        User user2 = new User("Sahan" ,"Rambukkna",DataLoader.getRandomDate(),"Delkanda Nugegoda",2);
        User user3 = new User("Ranuk" ,"Silva",DataLoader.getRandomDate(),"Yalawatta gampaha",3);

        Post post1 = new Post("Graphql with SpringBoot",DataLoader.getRandomDate());
        Post post2 = new Post("Flutter with Firebase",DataLoader.getRandomDate());
        Post post3 = new Post("Nodejs Authentication with JWT",DataLoader.getRandomDate());

        postRepository.save(post1);
        postRepository.save(post2);
        postRepository.save(post3);

        userRepository.save(user1);
        userRepository.save(user2);
        userRepository.save(user3);

    }


    public static Date getRandomDate(){
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.YEAR, 1990);
        calendar.set(Calendar.MONTH, 1);
        calendar.set(Calendar.DATE, 2);
        Date date1 = calendar.getTime();
        calendar.set(Calendar.YEAR, 1996);
        Date date2 = calendar.getTime();
        long startMillis = date1.getTime();
        long endMillis = date2.getTime();
        long randomMillisSinceEpoch = ThreadLocalRandom
                .current()
                .nextLong(startMillis, endMillis);

        return new Date(randomMillisSinceEpoch);
    }

}

```

Okay great! Now you have to do the configuration in `application.properties` Make sure to create a new database named as writeup and provide correct credentials to connect with MySQL database.

```Java Properties
server.port=7000

#mysql properties
spring.jpa.generate-ddl=true
spring.datasource.url=jdbc:mysql://localhost/writeup
spring.datasource.username=user
spring.datasource.password=password
spring.datasource.driverClassName=com.mysql.cj.jdbc.Driver
spring.jpa.hibernate.ddl-auto=create
```

All the basic structure is done. Hey, what about the controller? If you are thinking I forgot it, you are absolutely wrong. In REST API’s, we use controllers to handle multiple endpoints. But as you already know in GraphQL, you only need one API endpoint. So you don’t need any controllers to handle that.

All right! Let’s do a quick demo run to check whether all are working fine.

![](https://cdn-images-1.medium.com/max/3630/1*ntnM4Gn6fdr7kIthZbGvWw.png)

![Screenshots provided by the author.](https://cdn-images-1.medium.com/max/2016/1*MSaXfP1WhsFaMrPT94A8FA.png)

Great. As you can see our basic structure has worked as expected. Let’s move on to the big step.

## Releasing The Beast: Setting Up GraphQL

First things first! You need to add GraphQL dependencies to the project.
So in the `pom.xml` add these two dependencies inside the `\<dependencies>` section and update the project (resolve dependencies) by clicking the **m** icon in the top right corner.

```
<!-- GraphQL dependencies -->
<dependency>
    <groupId>com.graphql-java</groupId>
    <artifactId>graphql-spring-boot-starter</artifactId>
    <version>5.0.2</version>
</dependency>
<dependency>
    <groupId>com.graphql-java</groupId>
    <artifactId>graphql-java-tools</artifactId>
    <version>5.2.4</version>
</dependency>
```

![Screenshot provided by the author.](https://cdn-images-1.medium.com/max/3406/1*I6ecTzyeFI8UQL4ica3lcg.png)

GraphQL has two main building blocks: schema and resolver. As the first step of implementing GraphQL to our app, we need to define a schema.

The most basic components of a GraphQL schema are object types, which represent an object (like student, animal, etc.) that you can fetch from your service, and what fields it has.

```
type Director {
  name: String!
  age: Int
  films: [Film]
}
```

As you know there are so many primitive and non-primitive data types in languages like java. But here we can see only a limited number of data types (known as scalar types).

* Int: A signed 32‐bit integer.
* Float: A signed double-precision floating-point value.
* String: A UTF‐8 character sequence.
* Boolean: true or false.
* ID: A unique identifier

However, you can define custom scalars according to your preference.
(like Date, Currency, etc..)

Most types in your schema will just be normal object types, but there are two types that are special within a schema.

1. Query: Entry point of data fetching (Read)
2. Mutation: Entry point of data modifying (Write)

You can learn more about these concepts by visiting the [official GraphQL web site](https://graphql.org).

Okay. Let’s define our schema. For that, I created a directory named `graphql` inside the resource folder and created a `schema.graphqls` file inside of it. (Make sure the extension should be `.graphqls` as it’s a schema file.)

If you already installed the GraphQL plugin to IntelliJ, you can see the GraphQL icon after creating the file. It can easily install by searching in the plug-in section. It would be so much useful when doing the
development of a GraphQL schema file.

![Screenshot provided by the author.](https://cdn-images-1.medium.com/max/3308/1*9m9djB1PukLtoQCU348zbQ.png)

Here is the schema that I defined for my writeup application. First I go with a query and it will be easy to understand the things from it and then I’ll explain the mutation.

```
schema {
    query: Query,   
}

type Query{
    # Fetch All Users
    getAllUsers:[User]
}

type User {
    userId : ID!,
    firstName :String,
    lastName :String,
    dob:String,
    address:String,
    postId : Int,
}
```

Make sure to add comments as here. For the reason that, we can view those descriptions when testing the server with third-party tools like Altair (Mostly we are using this client for testing GraphQL endpoints instead of postman.)

Now we have to define our resolvers. (If you are curious about what is this `getAllUsers` method [not a method but a field] and where it’s referencing, wait this is it)

Resolvers are per field functions that are given a parent object, arguments, and the execution context. They are responsible for returning the corresponding data result for that field.

We can implement this in multiple ways. Most larger projects (Industry standard) tend to create a separate `graphql` package inside the root layer and inside that, it will define resolver interfaces and implementations. Also, mapping types for requests and responses can be defined in separate packages.

![Industry Standard for defining resolvers](https://cdn-images-1.medium.com/max/3840/1*eqGqp_oqVxsE1at4tSwFVA.png)

As this is for understanding the concepts, I’ll implement this on the service layer.

```Java
package com.example.writeup.service;

import com.coxautodev.graphql.tools.GraphQLQueryResolver;
import com.example.writeup.model.User;
import com.example.writeup.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class UserService implements GraphQLQueryResolver {

    @Autowired
    private UserRepository userRepository;

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }
    
}
```

I created a new service called `UserService` and implement `GraphQLQueryResolver` interface that comes as a library interface in `graphql-java-tools`

Then I auto-wired the user repository to get a connection with the database. (However, this field injection is not recommended in the latest versions. What you can do is, click on the yellow color bulb icon in the left corner when appears by clicking on the Autowired annotation and reformat as idea suggest.)

Now hope you remember that `getAllUsers` field we defined in the GraphQL schema. That should exactly tally with the method of this class. So I defined that method here and returned the user list as expected.

![Folder structure and the service layer](https://cdn-images-1.medium.com/max/2672/1*dFmcMBaBBUTF8YAJkKweYg.png)

Finally, we have to define our GraphQL configurations in the `application.properties` file.

```
#graphql properties
graphql.servlet.corsEnabled=true
graphql.servlet.mapping=/graphql
graphql.servlet.enabled=true
```

As you can see from the configs, `/graphql` endpoint will be handling all the requests. So you don’t need to define a controller.

All set! Our server is ready now. Give a test run and voila: you will be seeing such a message like “**Started WriteupApplication...(JVM running…)”**

So now the testing. As I mentioned previously, you can use Altair client to test those endpoints. It comes as a desktop app and as well as a browser extension. You can add this to your machine as your preference by clicking [here](https://altair.sirmuel.design/docs/).

Now go to the server endpoint using Altair.

![[http://localhost:7000/graphql](http://localhost:7000/graphql)](https://cdn-images-1.medium.com/max/3316/1*nbDmknJv8-rYGJo2u9N2gA.png)

If you reload the docs section, you can see the fields with the comment message. You can click it and look for more details. Write a query inside the left corner. You can see the Altair giving the auto-completion. By clicking the run query or send request buttons, you can get the results.

![Screenshot provided by the author.](https://cdn-images-1.medium.com/max/3264/1*-BT7ol2I85_R2NtYeCRoBQ.png)

Look, how cool is that! We can get the details as we request. I hope now you all clear with the concept as well as the practical. I’ll explain about mutation as well as for the completion of my article.

As the first thing, you can add a mutation to the schema file. I have done the update user address as an example. For that, I added the mutation to the schema and defined the mutation as below. So the final schema will be as follows.

```GraphQL
schema {
    query: Query,
    mutation: Mutation,
}

type Query{
    # Fetch All Users
    getAllUsers:[User]

}

type Mutation {
    # Update the user address
    updateUserAddress(userId:Int,address:String): User
}

type User {
    userId : ID!,
    firstName :String,
    lastName :String,
    dob:String,
    address:String,
    postId : Int,
}
```

I added a SQL query to the user repository to update the user from incoming parameters.

```Java
package com.example.writeup.repository;

import com.example.writeup.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {

    @Transactional
    @Modifying
    @Query(value = "UPDATE user SET address = ?1 WHERE user_id = ?2 ", nativeQuery = true)
    int updateUserAddress(String address, Integer user_id);

}
```

In the user service, we have to implement another interface called `GraphQLMutationResolver` Then we can define our `updateUserAdress` method there. Make sure that all the methods can be publicly accessible. So the final `UserService` will be as follows.

```Java
package com.example.writeup.service;

import com.coxautodev.graphql.tools.GraphQLMutationResolver;
import com.coxautodev.graphql.tools.GraphQLQueryResolver;
import com.example.writeup.model.User;
import com.example.writeup.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService implements GraphQLQueryResolver, GraphQLMutationResolver {

    @Autowired
    private UserRepository userRepository;

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public User updateUserAddress(Integer userId, String address) throws Exception {
        try {
            userRepository.updateUserAddress(address, userId);
            User user = userRepository.findById(userId).get();
            return user;
        } catch (Exception e) {
            throw new Exception(e);
        }

    }

}
```

All right! We defined our mutation also. Now do the testing as usual. You can confirm the API is working perfectly by checking the database.

![Screenshot provided by the author.](https://cdn-images-1.medium.com/max/3456/1*voqYoBAxQ6UyQdvfiX2SDw.png)

Great! You have completed most concepts in GraphQL. But there are plenty of things we need to explore in this amazing world. Wait, I’ll reveal some more things.

In addition to queries and mutations, GraphQL supports a third operation type called **subscriptions**.

Like queries, subscriptions enable you to fetch data. Unlike queries, subscriptions maintain an active connection to your GraphQL server. (Most commonly via a Web Socket) This enables your server to push updates to the subscription’s result over time.

This is extremely useful when notifying your client in real-time about alterations to back-end data, such as user notifications, important updates, changes in files, etc.

Also, there are many more things to cover up in GraphQL like error handling, spring-security, validation, etc. So I’ll intend to have separate articles on these topics as well.

## Inner Peace: The Conclusion

Here is a [small demonstration](https://youtu.be/D_YDhxLtjpI) of what we built today and the complete source code of the project can be seen below.

Resources: [Source code of the WriteUp](https://github.com/Yasas4D/WriteUp) Application.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
