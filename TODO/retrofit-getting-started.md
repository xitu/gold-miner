> * 原文链接 : [Retrofit — Getting Started and Create an Android Client](https://futurestud.io/blog/retrofit-getting-started-and-android-client)
* 原文作者 : [Marcus Pöhls](https://futurestud.io/blog/author/marcus)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Kevin Xiu](https://github.com/xiuweikang)
* 校对者: [kassadin](https://github.com/kassadin)、[foolishgao](https://github.com/foolishgao)
* 状态 :  完成

这是Retrofit系列文章中的第一篇，这个系列前前后后有几个用例，并且还分析了Retrofit的功能性和可扩展性。

**— 2015.10.21日更新**

除了之前已经有的关于Retrofit 1.9的代码样例，我们也已经添加了新的关于Retrofit 2（基于 2.0.0-beta2）的代码样例。 并且也已经发布了一个扩展的Retrofit更新指南：在下述内容的 #15。


## 文章概述

通过这篇博客，我们会学到Retrofit的基本用法和实现一个针对API或者HTTP请求的Android客户端。

**然而，这篇博客不会讲太多入门的知识，也不会讲Retrofit是关于什么的，如果你想要了解这些，可以看[Retrofit项目主页](http://square.github.io/retrofit/)**.

## Retrofit是什么

官方的Retrofit主页是这样描述它的

> 用于Android和Java的一个类型安全(type-safe)的REST客户端

你将会用注解去描述HTTP请求，同时Retrofit默认集成URL参数替换和查询参数.除此之外它还支持 Multipart请求和文件上传。


## 如何去声明请求（API）

请去[Retrofit 主页](http://square.github.io/retrofit/#api-declaration) 浏览并阅读相应的API声明章节来理解如何发送一个请求。你可以在上面找到所有重要的信息，和非常清楚的代码样例。

## 准备你的Android项目
现在，让我们把手放回到键盘上来。如果你已经建了一个Android项目的话，你可以直接看下一条，否则，在你最熟悉的IDE上建立一个Android项目。我们更倾向于用Gradle构建项目，但是如果你用Maven也是可以的。

### 定义依赖关系：Gradle 或者 Maven

现在，在你的项目中设置 Retrofit依赖。 根据你自己的构建工具，在`pom.xml`或者`build.gradle`中定义Retrofit和它的依赖关系。当运行命令去构建你的项目时，构建系统会在你的项目里下载相应的库。 我们建议用OkHttpP搭配Retrofit，OKHttp同样需要定义[Okio](https://github.com/square/okio#download)依赖。

#### **Retrofit 1.9**

**pom.xml**

        com.squareup.retrofit
        retrofit
        1.9.0

        com.squareup.okhttp
        okhttp
        2.2.0

**build.gradle**

    dependencies {  
        // Retrofit & OkHttp
        compile 'com.squareup.retrofit:retrofit:1.9.0'
        compile 'com.squareup.okhttp:okhttp:2.2.0'
    }

#### Retrofit 2

如果你正在用Retrofit2.0版，请用下面的依赖

**pom.xml**

        com.squareup.retrofit
        retrofit
        2.2.0-beta2

**build.gradle**

    dependencies {  
        // Retrofit & OkHttp
        compile 'com.squareup.retrofit:retrofit:2.0.0-beta2'
    }


Retrofit 2默认使用OKHttp作为网络层,并且在它上面进行构建。 你不需要在你的项目中显式的定义OkHttp依赖，除非你有一个特殊的版本需求。

现在你的项目已经集成了Retrofit,让我们一起创建一个具有持久性的 Android API/HTTP客户端吧。


##可持续的Android客户端
在对已经有的Retrofit的客户端的研究期间，我们发现了[example repository of Bart Kiers](https://github.com/bkiers/retrofit-oauth/tree/master/src/main/java/nl/bigo/retrofitoauth)。实际上，它是一个用Retrofit进行OAuth认证的例子。然而，它提供了做一个可持续的Android客户端需要的全部基本原理。这就是我们在未来的博客文章中要把它作为一个基础进行扩展，将认证功能更进一步的原因。


接下来的这个类是我们的Android客户端的主要成分：**ServiceGenerator**。
### Service Generator


**ServiceGenerator** 是我们 API/HTTP客户端的核心， 在目前的阶段，它只定义了一个对给定的类或者接口创建一个基本的REST适配器(adapter)的方法。

**Retrofit 1.9**

    public class ServiceGenerator {

        public static final String API_BASE_URL = "http://your.api-base.url";

        private static RestAdapter.Builder builder = new RestAdapter.Builder()
                    .setEndpoint(API_BASE_URL)
                    .setClient(new OkClient(new OkHttpClient()));

        public static  S createService(Class serviceClass) {
            RestAdapter adapter = builder.build();
            return adapter.create(serviceClass);
        }
    }

**Retrofit 2**

    public class ServiceGenerator {

        public static final String API_BASE_URL = "http://your.api-base.url";

        private static OkHttpClient httpClient = new OkHttpClient();
        private static Retrofit.Builder builder =
                new Retrofit.Builder()
                        .baseUrl(API_BASE_URL)
                        .addConverterFactory(GsonConverterFactory.create());

        public static  S createService(Class serviceClass) {
            Retrofit retrofit = builder.client(httpClient).build();
            return retrofit.create(serviceClass);
        }
    }


`ServiceGenerator`类 用Retrofit的 `RestAdapter`-Builder与给定的API基础url来创建一个新的REST客户端。例如，Github的API基础url是`https://developer.github.com/v3/`。

`serviceClass`类定义了用于API请求的注解了的类或接口。接下来的章节会向我们展示Retrofit的实用的用法，还有如何写出一个值得仿效的客户端。
## JSON 映射

Retrofit 1.9 默认提供Google的GSON。你需要做的只是定义好你的response对象，之后这个response将会被自动地映射。

当用Retrofit 2时，你需要对`Retrofit`对象显式地添加一个转换器(converter).这就是我们要在Retrofit的 builder上调用`.addConverterFactory(GsonConverterFactory.create())`去集成GSON作为默认的JSON转换器的原因。

## Retrofit实战


好的，让我们写一个 REST的 客户端向Github请求数据。

首先，我们必须创建一个接口和定义需要的方法。
### GitHub 客户端


接下来的代码定义了一个`GithubClient`和一个请求仓库的贡献者列表的方法。它也说明了Retrofit的参数替换功能（当调用对象的方法时，在定义的路径中的{owner} 和 {repo}将会被所给的变量所替换）。

**Retrofit 1.9**

    public interface GitHubClient {  
        @GET("/repos/{owner}/{repo}/contributors")
        List contributors(
            @Path("owner") String owner,
            @Path("repo") String repo
        );
    }

**Retrofit 2**

    public interface GitHubClient {  
        @GET("/repos/{owner}/{repo}/contributors")
        Call> contributors(
            @Path("owner") String owner,
            @Path("repo") String repo
        );
    }

这里定义了一个`Contributor`类，这个类包含了要映射到response数据的所有需要的属性。

    static class Contributor {  
        String login;
        int contributions;
    }


关于之前提到的JSON映射：`GithubClient` 定义了一个返回类型是`List`的命名为`contributors`的方法。Retrofit确保服务端返回的response 能够得到正确的映射(在这里 服务端返回的response 匹配所给的Contributor类)。
### API 请求样例

下面的片段说明了如何用`ServiceGenerator`去实例化你的客户端，具体点，这个Github客户端就是得到contributors的方法 用到的客户端。[Retrofit github-client example](https://github.com/square/retrofit/tree/master/sa
mples/src/main/java/com/example/retrofit)是一个修改后的版本。


当执行Github的这个例子的时候，你需要手动地在`ServiceGenerator`中用`"https://developer.github.com/v3/"`作为基础的url。另一个选择是用额外的`createService()`方法接受两个参数: 客户端类名，和基础的url。

**Retrofit 1.9**

    public static void main(String... args) {  
    
        // 创建一个非常简单的 指向Github API端点的 RSET 适配器
        GitHubClient client = ServiceGenerator.createService(GitHubClient.class);

        // 得到并打印这个仓库的贡献者列表
        List contributors =
            client.contributors("fs_opensource", "android-boilerplate");

        for (Contributor contributor : contributors) {
            System.out.println(
                    contributor.login + " (" + contributor.contributions + ")");
        }
    }

**Retrofit 2**

    public static void main(String... args) {  
        // 创建一个非常简单的 指向Github API端点的 RSET 适配器 
        GitHubClient client = ServiceGenerator.createService(GitHubClient.class);

        // 得到并打印这个仓库的贡献者列表
        Call> call =
            client.contributors("fs_opensource", "android-boilerplate");

        List contributors = call.execute().body();

        for (Contributor contributor : contributors) {
            System.out.println(
                    contributor.login + " (" + contributor.contributions + ")");
        }
    }



## 下面会讲什么

下一篇文章主要解释了如何用Retrofit去实现基本的认证。我们将会展示一些用 用户名/邮箱 和密码验证webservices或者APIs的代码样例。进一步讲，之后的文章主要会涉及到用tokens（包括OAuth）的API认证

我们希望你能对这个概览感到满意，也希望你能用Retrofit来发出你的第一个请求。

## 对Retrofit的讲解还不够？ 买我们的书吧！

[![](https://futurestud.io/blog/content/images/2015/07/futurestudio-retrofitbook.png)](https://leanpub.com/retrofit-love-working-with-apis-on-android "Retrofit: Love working with APIs on Android")

学会如何在Android上用Retrofit创建一个高效率的RSET客户端，通过复杂的APIs提升你的效率，享受工作的乐趣。


**Retrofit：Love working with APIs on Android**  在[Leanpub.com](https://leanpub.com/retrofit-love-working-with-apis-on-android "Retrofit: Love working with APIs on Android")上可购




## 直接在你的收信箱里浏览文章

**订阅就可以收到我们每周总结的最新的关于Android、Node.js、开源代码和其他方面的文章。**



