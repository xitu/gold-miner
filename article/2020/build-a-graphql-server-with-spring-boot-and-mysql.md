> * 原文地址：[Build a GraphQL Server With Spring Boot and MySQL](https://medium.com/better-programming/build-a-graphql-server-with-spring-boot-and-mysql-df427cbba26d)
> * 原文作者：[Yasas Sandeepa](https://medium.com/@yasassandeepa007)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/build-a-graphql-server-with-spring-boot-and-mysql.md](https://github.com/xitu/gold-miner/blob/master/article/2020/build-a-graphql-server-with-spring-boot-and-mysql.md)
> * 译者：[samyu2000](https://github.com/samyu2000)
> * 校对者：[zenblo](https://github.com/zenblo), [regon-cao](https://github.com/regon-cao)

# 使用 SpringBoot 和 MySQL 构建 GraphQL 服务端应用程序

![Photo modified by me using resources of [John Peel](https://unsplash.com/@johnpeel?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/3840/1*zttc2YOayk-LuiTYy18c9A.png)

你是否考虑过客户端直接控制 API 请求？客户端能否请求其实际需要的数据并精确获取？如果你对这些问题感到惊讶，我敢肯定你从来没听说过 GraphQL。

上述问题的答案是肯定的，因为使用 GraphQL 就可以实现。如果你没听说过，不必担心。我将带领你走进最新的、令人惊叹的 GraphQL 世界，并且如果本文给你带来巨大的收益，你就不会感到遗憾。

一般来说，你需要熟悉 Java 语言、Spring Boot 框架和 REST APIs 相关知识。不需要你有过使用 GraphQL 的经历。你可能对这个话题非常有兴趣。那还等什么呢？但在上手实践之前，我会大致介绍 GraphQL，以及它独具特色的原因。

## 入手 GraphQL 的第一步

我想，你可能在努力寻找关于 GraphQL 的相关信息吧。GraphQL 到底是什么呢？深呼吸一下，听我道来。简单的来说，它是一种数据查询和操作语言，可以在 API 中使用。

GraphQL 提供了一个简易的终端，可以用于从前端接收查询请求，并返回相应的查询结果，而且可以根据需要，精准获取部分数据。所以我不得不说：不要低估这个通用客户端的功能。

看了这幅 GIF 图片，就清晰明了了。这也是我们将要实现的应用程序的一部分功能。

![GraphQL 如何运行](https://cdn-images-1.medium.com/max/3472/1*aXd1Atpt9B8QI2s9r3r_Ew.gif)

GraphQL 如今在数以百计、大大小小的公司广泛使用，包括 Facebook（GraphQL 本来就是由 Facebook 于2012年发明的，并于2015年开源）、Credit Karma、GitHub、Intuit、PayPal、the New York Times 等等。

嘿，等等。需要介绍一下 REST。难道它还不够有用吗？我们来了解一下这个。

## GraphQL 与 REST 的对比

由于 REST API 的广泛使用，我们都对它很熟悉。但如今，使用 GraphQL 是大势所趋，因为它更灵活、性能更好。

那么，REST 和 GraphQL 本质上有什么不同呢？REST 是一种开发网络应用程序的架构思想。而 GraphQL 是一种查询语言、一种技术规范和一系列单点操作工具的集合。我来举个例子，让大家更好地了解这些内容。

假定你需要查询书本信息。同时，你还要查询作者信息（书本和作者是两个不同的实体）。典型的方法是发送两个 GET 类型的请求。

```
localhost:8080/book/:id
localhost:8080/author/:id
```


但使用 GraphQL 就可以通过一个单一的 API 端点获取到所有信息。

```
localhost:8080/graphql
```

正如前面的那幅 GIF 图片中那样，如果你要在一个终端把一些信息归集起来，可以过滤某些不需要的字段。但如果使用 REST，只能得到全部的数据集，无法过滤某些数据。


有时候，响应的数据不能直接使用（比如嵌套的数据），你为了获取实际需要的数据只得另行请求。但另一方面，响应的数据有很多是你并不需要的，你只需要一两个字段。

这种现象称为读取不足和过度读取。GraphQL 可以解决这些问题，优化你的程序。REST 跟 GraphQL 相比，REST 就像是一家没有服务员的餐厅。

无论如何，使用 GraphQL 必然存在学习曲线，它与 REST API 固然存在一些差别，但是它确实值得学习。如果你能开发用户友好的大型应用程序，用户只获取到他需要的数据，没有其他多余的东西，也是令人满意的。

使用 GraphQL 的一个额外好处是，由于不需要处理大量数据，应用程序的性能将会大幅度提升。任何性能上的提升都是巨大的胜利。

许多编程语言，比如 Java、JavaScript、Python、Scala 等等，都支持 GraphQL。你可以访问[GraphQL 官网](https://graphql.org/code/)了解各种服务端和客户端语言的相关信息。

由于我比较熟悉 Java 和 JavaScript，关于这些技术的文章较少，我考虑写一个 Spring Boot 应用程序。也有一些关于 Node.js 的文章和手册，实现它并不难。

如果你需要了解如何使用 Node.js 实现 GraphQL 服务端，请在评论区留言，我也很愿意就此话题写一篇文章。

好，讨论够了。我们进入实践环节。没有什么比亲自动手实践更好的方法了。

## 基础：创建项目

我正着手开发一个 APP，实现获取用户和他们发的帖子的功能。我把这个项目命名为 **WriteUp**，以后还要进行二次开发。

我从头开始开发这个 APP。如果你熟悉 Spring Boot，可以快速浏览这部分基础的内容。第一步，我们需要使用 [Spring Initializr](https://start.spring.io/) 或IntelliJ idea 新建 Spring Boot 工程。
 
![](https://cdn-images-1.medium.com/max/3190/1*DEPldJV7a6gZfG_VGlr1HQ.png)

![Screenshots provided by the author.](https://cdn-images-1.medium.com/max/3384/1*ZueIgy3oLM7lND_Eo-4leQ.png)

确保项目中添加了这些依赖。


1. Spring Data JPA: 用于处理大多数基于 JDBC 的数据库访问操作，减少 JPA 中的模板文件代码
2. MySQL Driver: 用于管理 Java 程序与 MySQL 数据库的连接
3. Lombok: 减少模型对象类中的代码，使用 Lombok 注解可以自动创建 get/set 方法。

![Screenshot provided by the author.](https://cdn-images-1.medium.com/max/2740/1*gj881gOHnanEEmyWoStkEw.png)

一切就绪。我们休息一会儿，等待 IntelliJ 为项目配置依赖。

## 要点：配置基础

至于初始化设置，我们可以创建实体模型并向 MySQL 数据库添加一些虚拟数据。

我创建了一个包，命名为 model，在这个包中定义了 User 和 Post 两个类，代码较为简洁，由于有注解，get/set 方法会自动生成，就不需要定义了。但切记，你必须创建一个不包含 ID 字段的构造方法，这个构造方法在实例化时会被调用。

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

我们来创建 repository 层，它是用于与数据库建立连接的。我新建一个名为 repository 的包，在此包中创建两个 JpaRepository 的子接口，分别对应于 User 和 Post。

可以继承 CrudRepository，但我更倾向于继承 JpaRepository，因为它的 find 方法返回一个普通列表对象，不像 CrudRepository 那样返回可迭代列表对象。(欲详细了解这些 Repository 接口，可以点击查看[这里](https://stackoverflow.com/questions/14014086/what-is-difference-between-crudrepository-and-jparepository-interfaces-in-spring))。

```Java
package com.example.writeup.repository;

import com.example.writeup.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {

}

```

接着，我写一个组件类，向数据库添加虚拟数据。还需要创建 service 包，在这个包里定义一个 DataLoader 类。这个类负责在应用程序初始化时添加某些虚拟数据。

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

好了。现在你需要在 application.properties 文件中进行配置。同时也要确保已经创建了数据库，并且在应用程序中设置了可与 MySQL 数据库建立连接的凭证。

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

已经完成了基础的架构。嘿，控制器呢？如果你认为需要有控制器而我忘了，你就完全错了。在 REST API 中，我们使用控制器是为了处理多个端点。但在 GraphQL 中，你也了解的，只需要一个 API 端点，所以控制器是不需要的。

好，我们来做一个例子，检验是否一切正常。

![](https://cdn-images-1.medium.com/max/3630/1*ntnM4Gn6fdr7kIthZbGvWw.png)

![Screenshots provided by the author.](https://cdn-images-1.medium.com/max/2016/1*MSaXfP1WhsFaMrPT94A8FA.png)

好，你可以看到，项目的基础架构正常运行。我们继续后面的步骤。

## 重点环节：为项目装配 GraphQL 相关功能

先做重要的事！你需要为项目添加 GraphQL 依赖。
在 pom.xml 文件的 dependencies 节点中加入这两个依赖包，并点击右上角的 **m** 图标，更新项目。

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

GraphQL 有两个主要的构建模块：模式和解析程序。在应用程序中实现 GraphQL 的第一步是定义一个模式。

GraphQL 模式中最基础的组件是 type, 它代表一个对象(类似于学生、动物等)和对象的属性，你可以从你开发的程序中获取这些对象。

```
type Director {
  name: String!
  age: Int
  films: [Film]
}
```

在 Java 等语言中，有很多原始的和非原始的数据类型。但在这里我们只需要了解这几个数据类型(也可称为 Scalar 类型)。

* Int: 有符号的 32 位整型
* Float: 有符号的双精度浮点值
* String: 使用 UTF-8 编码的字符串
* Boolean: 取值范围为 true/false
* ID: 唯一性的标识符

当然，你也可以根据你的需要定义 Scalar 类型。
(例如 Date, Currency 等等)

在模式中大多数数据类型不过是普通的类型，但有两种类型较为特殊。

1. Query: 获取数据的入口
2. Mutation: 更新数据的入口

关于这些概念，你可以访问 [GraphQL 官网](https://graphql.org)了解更多。

OK，我们来定义模式。需要在资源目录下创建 graphql 目录，并在 graphql 目录中创建一个 schema.graphqls 文件。（需要确保文件的扩展名为 .graphqls，它是一个模式文件）


如果你在 IntelliJ 中已经安装了 GraphQL 插件，你创建文件后就能看到 GraphQL 的图标。通过在插件面板中搜索，就可以安装这个插件。它对 GraphQL 模式文件的开发很有用。

![Screenshot provided by the author.](https://cdn-images-1.medium.com/max/3308/1*9m9djB1PukLtoQCU348zbQ.png)

以下是我定义的模式文件。首先我定义了 query 属性，这些代码很容易理解。后面我还会讲解 Mutation 类型。

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

请确保在代码种添加这些注释。这样做的目的是为了使用第三方工具测试服务端时可以查看相关的描述信息。(我们在大多数情况下会使用 Altair 客户端来测试，不会使用 Postman)

现在我们需要定义解析器。(如果你不理解这里的 `getAllUsers` 是什么(它不是方法，而是一个字段)以及它代表什么，等会儿会解释)

解析器是给定了父对象、参数和执行上下文的函数字段。他们负责返回对应函数的结果给这个字段。

实现解析器的方法有若干种。很多行业级的大型项目的做法是在根目录创建一个名为 `graphql` 的包，在这个包中定义解析器接口和相应的实现。请求和响应的映射类型也可以在这些包中定义。

![Industry Standard for defining resolvers](https://cdn-images-1.medium.com/max/3840/1*eqGqp_oqVxsE1at4tSwFVA.png)

因为这是为了帮助大家理解概念，我就在项目的 service 包内实现它。

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

我新建一个名为 `UserService` 的类，在这个类中提供 `GraphQLQueryResolver` 的具体实现，GraphQLQueryResolver 是 `graphql-java-tools` 库中的接口。

然后，为了获取数据库连接，我把 UserRepository 类的对象自动注入到 UserService 中。(当然这种注入方式不建议在最终版本中使用。你应该点击 Autowired 注解，接着代码区域左侧会出现黄色图标，再点击这个黄色图标，会弹出推荐的做法，然后根据系统推荐的做法修改代码)

现在你应该想到 GraphQL 模式文件中的 `getALlUsers` 字段。它跟 UserService 类中的方法名一样。所以我在这个类中定义此方法，并像模式文件中声明的那样返回 User 对象的列表。
 
![Folder structure and the service layer](https://cdn-images-1.medium.com/max/2672/1*dFmcMBaBBUTF8YAJkKweYg.png)

最后，我们需要在 `application.properties` 中配置 GraphQL 相关属性。

```
#graphql properties
graphql.servlet.corsEnabled=true
graphql.servlet.mapping=/graphql
graphql.servlet.enabled=true
```

从配置中可以看出， `/graphql` 端点可以接收请求。所以不需要定义控制器。

一切都准备就绪了。我们的服务器在等待访问。测试一下，你应该看到类似于这样的信息：**Started WriteupApplication...(JVM running…)**。

现在继续进行测试。我前面提到过，可以使用 Altair 客户端对那些端点进行测试。Altair 既有桌面版，也有相应的浏览器插件，都可以用来进行测试。你可以点击[这里](https://altair.sirmuel.design/docs/)下载安装 Altair 客户端。 

我们现在使用 Altair 访问服务器上的端点。

![[http://localhost:7000/graphql](http://localhost:7000/graphql)](https://cdn-images-1.medium.com/max/3316/1*nbDmknJv8-rYGJo2u9N2gA.png)

如果你重新加载文档部分，可以看到带注释的字段。点击它可以了解更多详细信息。在左侧输入查询语句，可以发现 Altair 提供了输入内容自动完成。点击运行查询或发送请求按钮，就可以得到查询结果。

![Screenshot provided by the author.](https://cdn-images-1.medium.com/max/3264/1*-BT7ol2I85_R2NtYeCRoBQ.png)

看，多么酷炫。使用 GraphQL，我们能得到所需要的信息。我估计现在你应该理解相关概念，并能够使用它们了。下面我要介绍 Mutation 类型了。

第一步，你可以在模式文件中添加一个 Mutation 类型字段。我已经开发了更新地址的功能，作为示例。如下所示，我已经在模式文件中添加了 mutation。下面是完整的模式文件代码。

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

我在 UserRepository 中加入了更新用户的查询操作，相应的 SQL 语句带有输入参数，由方法的参数代入。 

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

在 UserService 中，需要实现 GraphQLMutationResolver 接口声明的方法。我们在这个类中还定义了 updateUserAdress 方法。所有的方法的访问权限都是 public，无访问限制。UserService 类的代码如下。 

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

好了。我们也定义了 mutation。现在进行测试。可以通过查看数据库确认相关功能是否实现。

![Screenshot provided by the author.](https://cdn-images-1.medium.com/max/3456/1*voqYoBAxQ6UyQdvfiX2SDw.png)

太好了。你已经掌握了 GraphQL 中的大多数概念。但值得我们探索的还有很多。等等，我还有些东西要补充。

除了 Query 和 Mutation，GraphQL 还支持一种操作类型，叫做 **subscriptions**。

与 Query 类似，subscription 提供数据查询功能。但它跟 Query 又有所不同，它跟 GraphQL 服务端保持着连接（通俗的来说是使用 Web Socket 维持连接）。它能提供服务端主动推送更新消息的功能。

如果需要把后台更新的数据实时通知到客户端，比如用户通知、重要更新、文件修改等，subscription 很有用。

关于 GraphQL 的使用，还有很多话题可以讨论，比如错误处理、跟 spring-security 的整合、文本验证等等。关于这些话题，我也会发一些文章，供大家学习参考。

## 总结

这是关于本文内容的一个[小型示范项目](https://youtu.be/D_YDhxLtjpI)，项目完整的源代码见下面的 Github 仓库。

资源：[WriteUp 项目源代码](https://github.com/Yasas4D/WriteUp)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
