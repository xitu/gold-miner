> * 原文地址：[Elixir, Phoenix, Absinthe, GraphQL, React, and Apollo: an absurdly deep dive - Part 2](https://schneider.dev/blog/elixir-phoenix-absinthe-graphql-react-apollo-absurdly-deep-dive/)
> * 原文作者：[Zach Schneider](https://www.github.com/schneidmaster)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/elixir-phoenix-absinthe-graphql-react-apollo-absurdly-deep-dive-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/elixir-phoenix-absinthe-graphql-react-apollo-absurdly-deep-dive-2.md)
> * 译者：[Fengziyin1234](https://github.com/Fengziyin1234)
> * 校对者：[Xuyuey](https://github.com/Xuyuey), [portandbridge](https://github.com/portandbridge)

# Elixir、Phoenix、Absinthe、GraphQL、React 和 Apollo：一次近乎疯狂的深度实践 —— 第二部分（测试相关部分）

如果你没有看过本系列文章的第一部分，建议你先去看第一部分：

- [Elixir, Phoenix, Absinthe, GraphQL, React, and Apollo: an absurdly deep dive - Part 1](https://github.com/xitu/gold-miner/blob/master/TODO1/elixir-phoenix-absinthe-graphql-react-apollo-absurdly-deep-dive-1.md)
- [Elixir, Phoenix, Absinthe, GraphQL, React, and Apollo: an absurdly deep dive - Part 2](https://github.com/xitu/gold-miner/blob/master/TODO1/elixir-phoenix-absinthe-graphql-react-apollo-absurdly-deep-dive-2.md)

## 测试 —— 服务器端

现在我们已经完成了所有的代码部分，那我们如何确保我的代码总能正常的工作呢？我们需要对下面几种不同的层次进行测试。首先，我们需要对 model 层进行单元测试 —— 这些 model 是否能正确的验证（数据）？这些 model 的 helper 函数是否能返回预期的结果？第二，我们需要对 resolver 层进行单元测试 —— resolver 是否能处理不同的（成功和失败）的情况？是否能返回正确的结果或者根据结果作出正确的数据库更新？第三，我们应该编写一些完整的 integration test（集成测试），例如发送向服务器一个查询请求并期待返回正确的结果。这可以让我们更好地从全局上把控我们的应用，并且确保这些测试涵盖认证逻辑等案例。第四，我们希望对我们的 subscription 层进行测试 —— 当相关的变化发生时，它们可否可以正确地通知套接字。

Elixir 有一个非常基本的内置测试库，叫做 ExUnit。ExUnit 包括简单的 `assert`/`refute` 函数，也可以帮助你运行你的测试。在 Phoenix 中建立一系列 “case” support 文件的方法也很常见。这些文件在测试中被引用，用于运行常见的初始化任务，例如连接数据库。此外，在我的测试中，我发现 [ex_spec](https://hexdocs.pm/ex_spec/readme.html) 和 [ex_machina](https://hexdocs.pm/ex_machina/readme.html) 这两个库非常有帮助。ex_spec 加入了简单的 `describe` 和 `it`，对于有 ruby 相关背景的我来说，ex_spec 可以让编写测试所用的语法更加的友好。ex_machina 提供了函数工厂（factory），这些函数工厂可以让动态插入测试数据变得更简单。

我创建的函数工厂长这样：

```elixir
# test/support/factories.ex
defmodule Socializer.Factory do
  use ExMachina.Ecto, repo: Socializer.Repo

  def user_factory do
    %Socializer.User{
      name: Faker.Name.name(),
      email: Faker.Internet.email(),
      password: "password",
      password_hash: Bcrypt.hash_pwd_salt("password")
    }
  end

  def post_factory do
    %Socializer.Post{
      body: Faker.Lorem.paragraph(),
      user: build(:user)
    }
  end

  # ...factories for other models
end
```

在环境的搭建中导入函数工厂后，你就可以在测试案例中使用一些非常直观的语法了：

```elixir
# Insert a user
user = insert(:user)

# Insert a user with a specific name
user_named = insert(:user, name: "John Smith")

# Insert a post for the user
post = insert(:post, user: user)
```

在搭建完成后，你的 `Post` model 长这样：

```elixir
# test/socializer/post_test.exs
defmodule Socializer.PostTest do
  use SocializerWeb.ConnCase

  alias Socializer.Post

  describe "#all" do
    it "finds all posts" do
      post_a = insert(:post)
      post_b = insert(:post)
      results = Post.all()
      assert length(results) == 2
      assert List.first(results).id == post_b.id
      assert List.last(results).id == post_a.id
    end
  end

  describe "#find" do
    it "finds post" do
      post = insert(:post)
      found = Post.find(post.id)
      assert found.id == post.id
    end
  end

  describe "#create" do
    it "creates post" do
      user = insert(:user)
      valid_attrs = %{user_id: user.id, body: "New discussion"}
      {:ok, post} = Post.create(valid_attrs)
      assert post.body == "New discussion"
    end
  end

  describe "#changeset" do
    it "validates with correct attributes" do
      user = insert(:user)
      valid_attrs = %{user_id: user.id, body: "New discussion"}
      changeset = Post.changeset(%Post{}, valid_attrs)
      assert changeset.valid?
    end

    it "does not validate with missing attrs" do
      changeset =
        Post.changeset(
          %Post{},
          %{}
        )

      refute changeset.valid?
    end
  end
end
```

这个测试案例很直观。对于每个案例，我们插入所需要的测试数据，调用需要测试的函数并对结果作出断言（assertion）。

接下来，让我们一起看一下下面这个 resolver 的测试案例：

```elixir
# test/socializer_web/resolvers/post_resolver_test.exs
defmodule SocializerWeb.PostResolverTest do
  use SocializerWeb.ConnCase

  alias SocializerWeb.Resolvers.PostResolver

  describe "#list" do
    it "returns posts" do
      post_a = insert(:post)
      post_b = insert(:post)
      {:ok, results} = PostResolver.list(nil, nil, nil)
      assert length(results) == 2
      assert List.first(results).id == post_b.id
      assert List.last(results).id == post_a.id
    end
  end

  describe "#show" do
    it "returns specific post" do
      post = insert(:post)
      {:ok, found} = PostResolver.show(nil, %{id: post.id}, nil)
      assert found.id == post.id
    end

    it "returns not found when post does not exist" do
      {:error, error} = PostResolver.show(nil, %{id: 1}, nil)
      assert error == "Not found"
    end
  end

  describe "#create" do
    it "creates valid post with authenticated user" do
      user = insert(:user)

      {:ok, post} =
        PostResolver.create(nil, %{body: "Hello"}, %{
          context: %{current_user: user}
        })

      assert post.body == "Hello"
      assert post.user_id == user.id
    end

    it "returns error for missing params" do
      user = insert(:user)

      {:error, error} =
        PostResolver.create(nil, %{}, %{
          context: %{current_user: user}
        })

      assert error == [[field: :body, message: "Can't be blank"]]
    end

    it "returns error for unauthenticated user" do
      {:error, error} = PostResolver.create(nil, %{body: "Hello"}, nil)

      assert error == "Unauthenticated"
    end
  end
end
```

对于 resolver 的测试也相当的简单 —— 它们也是单元测试，运行于 model 之上的一层。这里我们插入任意的测试数据，调用所测试的 resolver，然后期待正确的结果被返回。

集成测试有一点点小复杂。我们首先需要建立和服务器端的连接（可能需要认证），接着发送一个查询语句并且确保我们得到正确的结果。我找到了[这篇帖子](https://tosbourn.com/testing-absinthe-exunit)，它对学习如何为 Absinthe 构建集成测试非常有帮助。

首先，我们建立一个 helper 文件，这个文件将包含一些进行集成测试所需要的常见功能：

```elixir
# test/support/absinthe_helpers.ex
defmodule Socializer.AbsintheHelpers do
  alias Socializer.Guardian

  def authenticate_conn(conn, user) do
    {:ok, token, _claims} = Guardian.encode_and_sign(user)
    Plug.Conn.put_req_header(conn, "authorization", "Bearer #{token}")
  end

  def query_skeleton(query, query_name) do
    %{
      "operationName" => "#{query_name}",
      "query" => "query #{query_name} #{query}",
      "variables" => "{}"
    }
  end

  def mutation_skeleton(query) do
    %{
      "operationName" => "",
      "query" => "mutation #{query}",
      "variables" => ""
    }
  end
end
```

这个文件里包括了三个 helper 函数。第一个函数接受一个连接对象和一个用户对象作为参数，通过在 HTTP 的 header 中加入已认证的用户 token 来认证连接。第二个和第三个函数都接受一个查询语句作为参数，当你通过网络连接发送查询语句给服务器时，这两个函数会返回一个包含该查询语句结果在内的 JSON 结构对象。

然后回到测试本身：

```elixir
# test/socializer_web/integration/post_resolver_test.exs
defmodule SocializerWeb.Integration.PostResolverTest do
  use SocializerWeb.ConnCase
  alias Socializer.AbsintheHelpers

  describe "#list" do
    it "returns posts" do
      post_a = insert(:post)
      post_b = insert(:post)

      query = """
      {
        posts {
          id
          body
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "posts"))

      posts = json_response(res, 200)["data"]["posts"]
      assert List.first(posts)["id"] == to_string(post_b.id)
      assert List.last(posts)["id"] == to_string(post_a.id)
    end
  end

  # ...
end
```

这个测试案例，通过查询来得到一组帖子信息的方式来测试我们的终端。我们首先在数据库中插入一些帖子的记录，然后写一个查询语句，接着通过 POST 方法将语句发送给服务器，最后检查服务器的回复，确保返回的结果符合预期。

这里还有一个非常相似的案例，测试是否能查询得到单个帖子信息。这里我们就不再赘述（如果你想了解所有的集成测试，你可以查看[这里](https://github.com/schneidmaster/socializer/tree/master/test/socializer_web/integration)）。下面让我们看一下为创建帖子的 Mutation 所做的集成测试。

```elixir
# test/socializer_web/integration/post_resolver_test.exs
defmodule SocializerWeb.Integration.PostResolverTest do
  # ...

  describe "#create" do
    it "creates post" do
      user = insert(:user)

      mutation = """
      {
        createPost(body: "A few thoughts") {
          body
          user {
            id
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      post = json_response(res, 200)["data"]["createPost"]
      assert post["body"] == "A few thoughts"
      assert post["user"]["id"] == to_string(user.id)
    end
  end
end
```

非常相似，只有两点不同 —— 这次我们是通过 `AbsintheHelpers.authenticate_conn(user)` 将用户的 token 加入头字段的方式来建立连接，并且我们调用的是 `mutation_skeleton`，而非之前的 `query_skeleton`。

那对于 subscription 的测试呢？对于 subscription 的测试也需要通过一些基本的搭建，来建立一个套接字连接，然后就可以建立并测试我们的 subscription。我找到了[这篇文章](https://www.smoothterminal.com/articles/building-a-forum-elixir-graphql-backend-with-absinthe)，它对我们理解如何为 subscription 构建测试非常有帮助。

首先，我们建立一个新的 case 文件来为 subscription 的测试做基本的搭建。代码长这样：

```elixir
# test/support/subscription_case.ex
defmodule SocializerWeb.SubscriptionCase do
  use ExUnit.CaseTemplate

  alias Socializer.Guardian

  using do
    quote do
      use SocializerWeb.ChannelCase
      use Absinthe.Phoenix.SubscriptionTest, schema: SocializerWeb.Schema
      use ExSpec
      import Socializer.Factory

      setup do
        user = insert(:user)

        # When connecting to a socket, if you pass a token we will set the context's `current_user`
        params = %{
          "token" => sign_auth_token(user)
        }

        {:ok, socket} = Phoenix.ChannelTest.connect(SocializerWeb.AbsintheSocket, params)
        {:ok, socket} = Absinthe.Phoenix.SubscriptionTest.join_absinthe(socket)

        {:ok, socket: socket, user: user}
      end

      defp sign_auth_token(user) do
        {:ok, token, _claims} = Guardian.encode_and_sign(user)
        token
      end
    end
  end
end
```

在一些常见的导入后，我们定义一个 `setup` 的步骤。这一步会插入一个新的用户，并通过这个用户的 token 来建立一个 websocket 连接。我们将这个套接字和用户返回以供我们其他的测试使用。

下一步，让我们一起来看一看测试本身：

```elixir
defmodule SocializerWeb.PostSubscriptionsTest do
  use SocializerWeb.SubscriptionCase

  describe "Post subscription" do
    it "updates on new post", %{socket: socket} do
      # Query to establish the subscription.
      subscription_query = """
        subscription {
          postCreated {
            id
            body
          }
        }
      """

      # Push the query onto the socket.
      ref = push_doc(socket, subscription_query)

      # Assert that the subscription was successfully created.
      assert_reply(ref, :ok, %{subscriptionId: _subscription_id})

      # Query to create a new post to invoke the subscription.
      create_post_mutation = """
        mutation CreatePost {
          createPost(body: "Big discussion") {
            id
            body
          }
        }
      """

      # Push the mutation onto the socket.
      ref =
        push_doc(
          socket,
          create_post_mutation
        )

      # Assert that the mutation successfully created the post.
      assert_reply(ref, :ok, reply)
      data = reply.data["createPost"]
      assert data["body"] == "Big discussion"

      # Assert that the subscription notified us of the new post.
      assert_push("subscription:data", push)
      data = push.result.data["postCreated"]
      assert data["body"] == "Big discussion"
    end
  end
end
```

首先，我们先写一个 subscription 的查询语句，并且推送到我们在上一步已经建立好的套接字上。接着，我们写一个会触发 subscription 的 mutation 语句（例如，创建一个新帖子）并推送到套接字上。最后，我们检查 `push` 的回复，并断言一个帖子的被新建的更新信息将被推送给我们。这其中设计了更多的前期搭建，但这也让我们对 subscription 的生命周期的建立的更好的集成测试。

## 客户端

以上就是对服务端所发生的一切的大致的描述 —— 服务器通过在 types 中定义，在 resolvers 中实现，在 model 查询和固化（persist）数据的方法来处理 GraphQL 查询语句。接下来，让我们一起来看一看客户端是如何建立的。

我们首先使用 [create-react-app](https://facebook.github.io/create-react-app)，这是从 0 到 1 搭建 React 项目的好方法 —— 它会搭建一个 “hello world” React 应用，包含默认的设定和结构，并且简化了大量配置。

这里我使用了 [React Router](https://reacttraining.com/react-router) 来实现应用的路由；它将允许用户在帖子列表页面、单一帖子页面和聊天页面等进行浏览。我们的应用的根组件应该长这样：

```javascript
// client/src/App.js
import React, { useRef } from "react";
import { ApolloProvider } from "react-apollo";
import { BrowserRouter, Switch, Route } from "react-router-dom";
import { createClient } from "util/apollo";
import { Meta, Nav } from "components";
import { Chat, Home, Login, Post, Signup } from "pages";

const App = () => {
  const client = useRef(createClient());

  return (
    <ApolloProvider client={client.current}>
      <BrowserRouter>
        <Meta />
        <Nav />

        <Switch>
          <Route path="/login" component={Login} />
          <Route path="/signup" component={Signup} />
          <Route path="/posts/:id" component={Post} />
          <Route path="/chat/:id?" component={Chat} />
          <Route component={Home} />
        </Switch>
      </BrowserRouter>
    </ApolloProvider>
  );
};
```

几个值得注意的点 —— `util/apollo` 这里对外输出了一个 `createClient` 函数。这个函数会创建并返回一个 Apollo 客户端的实例（我们将在下文中进行着重地介绍）。将 `createClient` 包装在 `useRef` 中，就能让该实例在应用的生命周期内（即，所有的 rerenders）中均可使用。`ApolloProvider` 这个高阶组件会使 client 可以在所有子组件/查询的 context 中使用。在我们浏览该应用的过程中，`BrowserRouter` 使用 HTML5 的 history API 来保持 URL 的状态同步。

这里的 `Switch` 和 `Route` 需要单独进行讨论。React Router 是围绕**动态**路由的概念建立的。大部分的网站使用**静态**路由，也就是说你的 URL 将匹配唯一的路由，并且根据所匹配的路由来渲染一整个页面。使用**动态**路由，路由将被分布到整个应用中，一个 URL 可以匹配多个路由。这听起来可能有些令人困惑，但事实上，当你掌握了它以后，你会觉得它**非常**棒。它可以轻松地构建一个包含不同组件页面，这些组件可以对路由的不同部分做出反应。例如，想象一个类似脸书的 messenger 的页面（Socializer 的聊天界面也非常相似）—— 左边是对话的列表，右边是所选择的对话。动态路由允许我这样表达：

```javascript
const App = () => {
  return (
    // ...
    <Route path="/chat/:id?" component={Chat} />
    // ...
  );
};

const Chat = () => {
  return (
    <div>
      <ChatSidebar />

      <Switch>
        <Route path="/chat/:id" component={Conversation} />
        <Route component={EmptyState} />
      </Switch>
    </div>
  );
};
```

如果路径以 `/chat` 开头（可能以 ID 结尾，例如，`/chat/123`），根层次的 `App` 会渲染 `Chat` 组件。`Chat` 会渲染对话列表栏（对话列表栏总是可见的），然后会渲染它的路由，如果路径有 ID，则显示一个 `Conversation` 组件，否则就会显示 `EmptyState`（请注意，如果缺少了 `?`，那么 `:id` 参数就不再是可选参数）。这就是动态路由的力量 —— 它让你可以基于当前的 URL 渐进地渲染界面的不同组件，将基于路径的问题本地化到相关的组件中。

即使使用了动态路由，有时你也只想要渲染一条路径（类似于传统的静态路由）。这时 `Switch` 组件就登上了舞台。如果没有 `Switch`，React Router 会渲染**每一个**匹配当前 URL 的组件，那么在上面的 `Chat` 组件中，我们就会既有 `Conversation` 组件，又有 `EmptyState` 组件。`Switch` 会告诉 React Router，让它只渲染第一个匹配当前 URL 的路由并忽视掉其它的。

## Apollo 客户端

现在，让我们更进一步，深入了解一下 Apollo 的客户端 —— 特别是上文已经提及的 `createClient` 函数。`util/apollo.js` 文件长这样：

```javascript
// client/src/util.apollo.js
import ApolloClient from "apollo-client";
import { InMemoryCache } from "apollo-cache-inmemory";
import * as AbsintheSocket from "@absinthe/socket";
import { createAbsintheSocketLink } from "@absinthe/socket-apollo-link";
import { Socket as PhoenixSocket } from "phoenix";
import { createHttpLink } from "apollo-link-http";
import { hasSubscription } from "@jumpn/utils-graphql";
import { split } from "apollo-link";
import { setContext } from "apollo-link-context";
import Cookies from "js-cookie";

const HTTP_URI =
  process.env.NODE_ENV === "production"
    ? "https://brisk-hospitable-indianelephant.gigalixirapp.com"
    : "http://localhost:4000";

const WS_URI =
  process.env.NODE_ENV === "production"
    ? "wss://brisk-hospitable-indianelephant.gigalixirapp.com/socket"
    : "ws://localhost:4000/socket";

// ...
```

开始很简单，导入一堆我们接下来需要用到的依赖，并且根据当前的环境，将 HTTP URL 和 websocket URL 设置为常量 —— 在 production 环境中指向我的 Gigalixir 实例，在 development 环境中指向 localhost。

```javascript
// client/src/util.apollo.js
// ...

export const createClient = () => {
  // Create the basic HTTP link.
  const httpLink = createHttpLink({ uri: HTTP_URI });

  // Create an Absinthe socket wrapped around a standard
  // Phoenix websocket connection.
  const absintheSocket = AbsintheSocket.create(
    new PhoenixSocket(WS_URI, {
      params: () => {
        if (Cookies.get("token")) {
          return { token: Cookies.get("token") };
        } else {
          return {};
        }
      },
    }),
  );

  // Use the Absinthe helper to create a websocket link around
  // the socket.
  const socketLink = createAbsintheSocketLink(absintheSocket);

  // ...
});
```

Apollo 的客户端要求你提供一个链接 —— 本质上说，就是你的 Apollo 客户端所请求的 GraphQL 服务器的连接。通常有两种类型的链接 —— HTTP 链接，通过标准的 HTTP 来向 GraphQL 服务器发送请求，和 websocket 链接，开放一个 websocket 连接并通过套接字来发送请求。在我们的例子中，我们两种都使用了。对于通常的 query 和 mutation，我们将使用 HTTP 链接，对于 subscription，我们将使用 websocket 链接。

```javascript
// client/src/util.apollo.js
export const createClient = () => {
  //...

  // Split traffic based on type -- queries and mutations go
  // through the HTTP link, subscriptions go through the
  // websocket link.
  const splitLink = split(
    (operation) => hasSubscription(operation.query),
    socketLink,
    httpLink,
  );

  // Add a wrapper to set the auth token (if any) to the
  // authorization header on HTTP requests.
  const authLink = setContext((_, { headers }) => {
    // Get the authentication token from the cookie if it exists.
    const token = Cookies.get("token");

    // Return the headers to the context so httpLink can read them.
    return {
      headers: {
        ...headers,
        authorization: token ? `Bearer ${token}` : "",
      },
    };
  });

  const link = authLink.concat(splitLink);

  // ...
};
```

Apollo 提供了 `split` 函数，它可以让你根据你选择的标准，将不同的查询请求路由到不同的链接上 —— 你可以把它想成一个三项式：如果请求有 subscription，就通过套接字链接来发送，其他情况（Query 或者 Mutation）则使用 HTTP 链接传送。

如果用户已经登陆，我们可能还需要给两个链接都提供认证。当用户登陆以后，我们将其认证令牌设置到 `token` 的 cookie 中（下文会详细介绍）。与 Phoenix 建立 websocket 连接时，我们使用`token` 作为参数，在 HTTP 链接中，这里我们使用 `setContext` 包装器，将`token` 设置在请求的头字段中。

```javascript
// client/src/util.apollo.js
export const createClient = () => {
  // ...

  return new ApolloClient({
    cache: new InMemoryCache(),
    link,
  });
});
```

如上所示，除了链接以外，一个 Apollo 的客户端还需要一个缓存的实例。GraphQL 会自动缓存请求的结果来避免对相同的数据进行重复请求。基本的 `InMemoryCache` 已经可以适用大部分的用户案例了 —— 它就是将查询的数据存在浏览器的本地状态中。

## 客户端的使用 —— 我们的第一个请求

好哒，我们已经搭建好了 Apollo 的客户端实例，并且通过 `ApolloProvider` 的高阶函数让这个实例在整个应用中都可用。现在让我们来看一看如何运行 query 和 mutation。我们从 `Posts` 组件开始，`Posts` 组件将在我们的首页渲染一个帖子的列表。

```javascript
// client/src/components/Posts.js
import React, { Fragment } from "react";
import { Query } from "react-apollo";
import gql from "graphql-tag";
import produce from "immer";
import { ErrorMessage, Feed, Loading } from "components";

export const GET_POSTS = gql`
  {
    posts {
      id
      body
      insertedAt
      user {
        id
        name
        gravatarMd5
      }
    }
  }
`;

export const POSTS_SUBSCRIPTION = gql`
  subscription onPostCreated {
    postCreated {
      id
      body
      insertedAt
      user {
        id
        name
        gravatarMd5
      }
    }
  }
`;

// ...
```

首先是各种库的引入，接着我们需要为我们想要渲染的帖子写一些查询。这里有两个 —— 首先是一个基础的获取帖子列表的 query（也包括帖子作者的信息），然后是一个 subscription，用来告知我们新帖子的出现，让我们可以实时地更新屏幕，保证我们的列表处于最新。

```javascript
// client/src/components/Posts.js
// ...

const Posts = () => {
  return (
    <Fragment>
      <h4>Feed</h4>
      <Query query={GET_POSTS}>
        {({ loading, error, data, subscribeToMore }) => {
          if (loading) return <Loading />;
          if (error) return <ErrorMessage message={error.message} />;
          return (
            <Feed
              feedType="post"
              items={data.posts}
              subscribeToNew={() =>
                subscribeToMore({
                  document: POSTS_SUBSCRIPTION,
                  updateQuery: (prev, { subscriptionData }) => {
                    if (!subscriptionData.data) return prev;
                    const newPost = subscriptionData.data.postCreated;

                    return produce(prev, (next) => {
                      next.posts.unshift(newPost);
                    });
                  },
                })
              }
            />
          );
        }}
      </Query>
    </Fragment>
  );
};
```

现在我们将实现真正的组件部分。首先，执行基本的查询，我们先渲染 Apollo 的 `<Query query={GET_POSTS}>`。它给它的子组件提供了一些渲染的 props —— `loading`，`error`，`data` 和 `subscribeToMore`。如果查询正在加载，我们就渲染一个简单的加载图片。如果有错误存在，我们渲染一个通用的 `ErrorMessage` 组件给用户。否则，就说明查询成果，我们就渲染一个 `Feed` 组件（`data.posts` 中包含着需要渲染的帖子，结构和 query 中的结构一致）。

`subscribeToMore` 是一个 Apollo 帮助函数，用于实现一个只需要从用户正在浏览的集合中获取新数据的 subscription。它应该在子组件的 `componentDidMount` 阶段被渲染，这也是它被作为 props 传递给 `Feed` 的原因 —— 一旦 `Feed` 被渲染，`Feed` 负责调用 `subscribeToNew`。我们给 `subscribeToMore` 提供了我们的 subscription 查询和一个 `updateQuery` 的回调函数，该函数会在 Apollo 接收到新帖子被建立的通知时被调用。当那发生时，我们只需要简单将新帖子推入我们当前的帖子数组，使用 [immer](https://github.com/immerjs/immer) 可以返回一个新数组来确保组件可以正确地渲染。

## 认证（和 mutation）

现在我们已经有了一个带帖子列表的首页啦，这个首页还可以实时的对新建的帖子进行响应 —— 那我们应该如何新建帖子呢？首先，我们需要允许用户用他们的账户登陆，那么我们就可以把他的账户和帖子联系起来。我们需要为此写一个 mutation —— 我们需要将电子邮件和密码发送到服务器，服务器会发送一个新的认证该用户的令牌。我们从登陆页面开始：

```javascript
// client/src/pages/Login.js
import React, { Fragment, useContext, useState } from "react";
import { Mutation } from "react-apollo";
import { Button, Col, Container, Form, Row } from "react-bootstrap";
import Helmet from "react-helmet";
import gql from "graphql-tag";
import { Redirect } from "react-router-dom";
import renderIf from "render-if";
import { AuthContext } from "util/context";

export const LOGIN = gql`
  mutation Login($email: String!, $password: String!) {
    authenticate(email: $email, password: $password) {
      id
      token
    }
  }
`;
```

第一部分和 query 组件十分相似 —— 我们导入需要的依赖文件，然后完成登陆的 mutation。这个 mutation 接受电子邮件和密码作为参数，然后我们希望得到认证用户的 ID 和他们的认证令牌。

```javascript
// client/src/pages/Login.js
// ...

const Login = () => {
  const { token, setAuth } = useContext(AuthContext);
  const [isInvalid, setIsInvalid] = useState(false);
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  if (token) {
    return <Redirect to="/" />;
  }

  // ...
};
```

在组件中，我们首先去从 context 中获取当前的 `token` 和一个叫 `setAuth` 的函数（我们会在下文中介绍 `setAuth`）。我们也需要使用 `useState` 来设置一些本地的状态，那样我们就可以为用户的电子邮件，密码以及他们的证书是否有效来存储临时值（这样我们就可以在表单中显示错误状态）。最后，如果用户已经有了认证令牌，说明他们已经登陆，那么我们就直接让他们跳转去首页。

```javascript
// client/src/pages/Login.js
// ...

const Login = () => {
  // ...

  return (
    <Fragment>
      <Helmet>
        <title>Socializer | Log in</title>
        <meta property="og:title" content="Socializer | Log in" />
      </Helmet>
      <Mutation mutation={LOGIN} onError={() => setIsInvalid(true)}>
        {(login, { data, loading, error }) => {
          if (data) {
            const {
              authenticate: { id, token },
            } = data;
            setAuth({ id, token });
          }

          return (
            <Container>
              <Row>
                <Col md={6} xs={12}>
                  <Form
                    data-testid="login-form"
                    onSubmit={(e) => {
                      e.preventDefault();
                      login({ variables: { email, password } });
                    }}
                  >
                    <Form.Group controlId="formEmail">
                      <Form.Label>Email address</Form.Label>
                      <Form.Control
                        type="email"
                        placeholder="you@gmail.com"
                        value={email}
                        onChange={(e) => {
                          setEmail(e.target.value);
                          setIsInvalid(false);
                        }}
                        isInvalid={isInvalid}
                      />
                      {renderIf(error)(
                        <Form.Control.Feedback type="invalid">
                          Email or password is invalid
                        </Form.Control.Feedback>,
                      )}
                    </Form.Group>

                    <Form.Group controlId="formPassword">
                      <Form.Label>Password</Form.Label>
                      <Form.Control
                        type="password"
                        placeholder="Password"
                        value={password}
                        onChange={(e) => {
                          setPassword(e.target.value);
                          setIsInvalid(false);
                        }}
                        isInvalid={isInvalid}
                      />
                    </Form.Group>

                    <Button variant="primary" type="submit" disabled={loading}>
                      {loading ? "Logging in..." : "Log in"}
                    </Button>
                  </Form>
                </Col>
              </Row>
            </Container>
          );
        }}
      </Mutation>
    </Fragment>
  );
};

export default Login;
```

这里的代码看起来很洋气，但是不要懵 —— 这里大部分的代码只是为表单做一个 Bootstrap 组件。我们从一个叫做 `Helmet`（[react-helmet](https://github.com/nfl/react-helmet)） 组件开始 —— 这是一个顶层的表单组件（相较而言，`Posts` 组件只是 `Home` 页面渲染的一个子组件），所以我们希望给他一个浏览器标题和一些 metadata。下一步我们来渲染 `Mutation` 组件，将我们的 mutation 语句传递给他。如果 mutation 返回一个错误，我们使用 `onError` 回调函数来将状态设为无效，来将错误显示在表单中。Mutation 将一个函数传将会递给调用他的子组件（这里是 `login`），第二个参数是和我们从 `Query` 组件中得到的一样的数组。如果 `data` 存在，那就意味着 mutation 被成功执行，那么我们就可以将我们的认证令牌和用户 ID 通过 `setAuth` 函数来储存起来。剩余的部分就是很标准的 React 组件啦 —— 我们渲染 input 并在变化时更新 state 值，在用户试图登陆，而邮件密码却无效时显示错误信息。

那 `AuthContext` 是干嘛的呢？当用户被成功认证后，我们需要将他们的认证令牌以某种方式存储在客户端。这里 GraphQL 并不能帮上忙，因为这就像是个鸡生蛋问题 —— 发出请求才能获取认证令牌，而认证这个请求本身就要用到认证令牌。我们可以用 Redux 在本地状态中来存储令牌，但如果我只需要储存这一个值时，感觉这样做就太过于复杂了。我们可以使用 React 的 context API 来将 token 储存在我们应用的根目录，在需要时调用即可。

首先，让我们建立一个帮助函数来帮我们建立和导出 context：

```javascript
// client/src/util/context.js
import { createContext } from "react";

export const AuthContext = createContext(null);
```

接下来我们来新建一个 `StateProvider` 高阶函数，这个函数会在应用的根组件被渲染 —— 它将帮助我们保存和更新认证状态。

```javascript
// client/src/containers/StateProvider.js
import React, { useEffect, useState } from "react";
import { withApollo } from "react-apollo";
import Cookies from "js-cookie";
import { refreshSocket } from "util/apollo";
import { AuthContext } from "util/context";

const StateProvider = ({ client, socket, children }) => {
  const [token, setToken] = useState(Cookies.get("token"));
  const [userId, setUserId] = useState(Cookies.get("userId"));

  // If the token changed (i.e. the user logged in
  // or out), clear the Apollo store and refresh the
  // websocket connection.
  useEffect(() => {
    if (!token) client.clearStore();
    if (socket) refreshSocket(socket);
  }, [token]);

  const setAuth = (data) => {
    if (data) {
      const { id, token } = data;
      Cookies.set("token", token);
      Cookies.set("userId", id);
      setToken(token);
      setUserId(id);
    } else {
      Cookies.remove("token");
      Cookies.remove("userId");
      setToken(null);
      setUserId(null);
    }
  };

  return (
    <AuthContext.Provider value={{ token, userId, setAuth }}>
      {children}
    </AuthContext.Provider>
  );
};

export default withApollo(StateProvider);
```

这里有很多东西。首先，我们为认证用户的 `token` 和 `userId` 建立 state。我们通过读 cookie 来初始化 state，那样我们就可以在页面刷新后保证用户的登陆状态。接下来我们实现了我们的 `setAuth` 函数。用 `null` 来调用该函数会将用户登出；否则就使用提供的 `token` 和 `userId`来让用户登陆。不管哪种方法，这个函数都会更新本地的 state 和 cookie。

在同时使用认证和 Apollo websocket link 时存在一个很大的难题。我们在初始化 websocket 时，如果用户被认证，我们就使用令牌，反之，如果用户登出，则不是用令牌。但是当认证状态发生变化时，我们需要根据状态重置 websocket 连接来。如果用户是先登出再登入，我们需要用户新的令牌来重置 websocket，这样他们就可以实时地接受到需要登陆的活动的更新，比如说一个聊天对话。如果用户是先登入再登出，我们则需要将 websocket 重置成未经验证状态，那么他们就不再会实时地接受到他们已经登出的账户的更新。事实证明这真的很难 —— 因为没有一个详细记录的下的解决方案，这花了我好几个小时才解决。我最终手动地为套接字实现了一个重置函数：

```javascript
// client/src/util.apollo.js
export const refreshSocket = (socket) => {
  socket.phoenixSocket.disconnect();
  socket.phoenixSocket.channels[0].leave();
  socket.channel = socket.phoenixSocket.channel("__absinthe__:control");
  socket.channelJoinCreated = false;
  socket.phoenixSocket.connect();
};
```

这个会断开 Phoenix 套接字，将当前存在的 Phoenix 频道留给 GraphQL 更新，创建一个新的 Phoenix 频道（和 Abisnthe 创建的默认频道一个名字），并将这个频道标记为连接（那样 Absinthe 会在连接时将它重新加入），接着重新连接套接字。在文件中，Phoenix 套接字被配置为在每次连接前动态的在 cookie 中查找令牌，那样每当它重联时，它将会使用新的认证状态。让我崩溃的是，对这样一个看着很普通的问题，却并没有一个好的解决方法，当然，通过一些手动的努力，它工作得还不错。

最后，在我们的 `StateProvider` 中使用的 `useEffect` 是调用 `refreshSocket` 的地方。第二个参数 `[token]`告诉了 React 在每次 `token` 值变化时，去重新评估该函数。如果用户只是登出，我们也要执行 `client.clearStore()` 函数来确保 Apollo 客户端不会继续缓存包含着需要权限才能得到的数据的查询结果，比如说用户的对话或者消息。

这就大概是客户端的全部了。你可以查看余下的[组件](https://github.com/schneidmaster/socializer/tree/master/client/src)来得到更多的关于 query，mutation 和 subscription 的例子，当然，它们的模式都和我们所提到的大体一致。

## 测试 —— 客户端

让我们来写一些测试，来覆盖我们的 React 代码。我们的应用内置了 [jest](https://jestjs.io)（create-react-app 默认包括它）；jest 是针对 JavaScript 的一个非常简单和直观的测试运行器。它也包括了一些高级功能，比如快照测试。我们将在我们的第一个测试案例里使用它。

我非常喜欢使用 [react-testing-library](https://testing-library.com/react) 来写 React 的测试案例 —— 它提供了一个非常简单的 API，可以帮助你从一个用户的角度来渲染和测试表单（而无需在意组件的具体实现）。此外，它的帮助函数可以在一定程度上的帮助你确保组件的可读性，因为如果你的 DOM 节点很难访问，那么你也很难通过直接操控 DOM 节点来与之交互（例如给文本提供正确的标签等等）。

我们首先开始为 `Loading` 组件写一个简单的测试。该组件只是渲染一些静态的 HTML，所以并没有什么逻辑需要测试；我们只是想确保 HTML 按照我们的预期来渲染。

```javascript
// client/src/components/Loading.test.js
import React from "react";
import { render } from "react-testing-library";
import Loading from "./Loading";

describe("Loading", () => {
  it("renders correctly", () => {
    const { container } = render(<Loading />);
    expect(container.firstChild).toMatchSnapshot();
  });
});
```

当你调用 `.toMatchSnapshot()` 时，jest 将会在 `__snapshots__/Loading.test.js.snap` 的相对路径下建立一个文件，来记录当前的状态。随后的测试会比较输出和我们所记录的快照（snapshot），如果与快照不匹配则测试失败。快照文件长这样：

```javascript
// client/src/components/__snapshots__/Loading.test.js.snap
// Jest Snapshot v1, https://goo.gl/fbAQLP

exports[`Loading renders correctly 1`] = `
<div
  class="d-flex justify-content-center"
>
  <div
    class="spinner-border"
    role="status"
  >
    <span
      class="sr-only"
    >
      Loading...
    </span>
  </div>
</div>
`;
```

在这个例子中，因为 HTML 永远不会改变，所以这个快照测试并不是那么有效 —— 当然它达到了确认该组件是否渲染成功没有任何错误的目的。在更高级的测试案例中，快照测试在确保组件只会在你想改变它的时候才会改变时非常的有效 —— 比如说，如果你在优化组件内的逻辑，但并不希望组件的输出改变时，一个快照测将会告诉你，你是否犯了错误。

下一步，让我们一起来看一个对与 Apollo 连接的组件的测试。从这里开始，会变得有些复杂；组件会期待在它的上下文中有 Apollo 的客户端，我们需要模拟一个 query 查询语句来确保组件正确地处理响应。

```javascript
// client/src/components/Posts.test.js
import React from "react";
import { render, wait } from "react-testing-library";
import { MockedProvider } from "react-apollo/test-utils";
import { MemoryRouter } from "react-router-dom";
import tk from "timekeeper";
import { Subscriber } from "containers";
import { AuthContext } from "util/context";
import Posts, { GET_POSTS, POSTS_SUBSCRIPTION } from "./Posts";

jest.mock("containers/Subscriber", () =>
  jest.fn().mockImplementation(({ children }) => children),
);

describe("Posts", () => {
  beforeEach(() => {
    tk.freeze("2019-04-20");
  });

  afterEach(() => {
    tk.reset();
  });

  // ...
});
```

首先是一些导入和模拟。这里的模拟是避免 `Posts` 组件地 subscription 在我们所不希望地情况下被注册。在这里我很崩溃 —— Apollo 有关于有模拟 query 和 mutation 的文档，但是并没有很多关于模拟 subscription 文档，并且我还会经常遇到各种神秘的，内部的，十分难解决的问题。当我只是想要组件执行它初始的 query 查询时（而不是模拟收到来自它的 subscription 的更新），我完全没能想到一种可靠的方法来模拟 query 查询。

但这确实也给了一个来讨论 jest 的好机会 —— 这样的案例非常有效。我有一个 `Subscriber` 组件，通常在装载（mount）时会调用 `subscribeToNew`，然后返回它的子组件：

```javascript
// client/src/containers/Subscriber.js
import { useEffect } from "react";

const Subscriber = ({ subscribeToNew, children }) => {
  useEffect(() => {
    subscribeToNew();
  }, []);

  return children;
};

export default Subscriber;
```

所以，在我的测试中，我只需要模拟这个组件的实现来返回子组件，而无需真正地调用 `subscribeToNew`。

最后，我是用了 `timekeeper` 来固定每一个测试案例的时间 —— `Posts` 根据帖子发布时间和当前时间（例如，两天以前）渲染了一些文本，那么我需要确保这个测试总是在“相同”的时间运行，否则快照测试就会因为时间推移而失败。

```javascript
// client/src/components/Posts.test.js
// ...

describe("Posts", () => {
  // ...

  it("renders correctly when loading", () => {
    const { container } = render(
      <MemoryRouter>
        <AuthContext.Provider value={{}}>
          <MockedProvider mocks={[]} addTypename={false}>
            <Posts />
          </MockedProvider>
        </AuthContext.Provider>
      </MemoryRouter>,
    );
    expect(container).toMatchSnapshot();
  });

  // ...
});
```

我们的第一个测试检查了加载的状态。我们必须把它包裹在几个高阶函数里 —— `MemoryRouter`，给 React Router 的 `Link` 和 `Route` 提供了一个模拟的路由；`AuthContext.Provider`，提供了认证的状态，和 Apollo 的 `MockedProvider`。因为我们已拍了一个即时的快照并返回，我们事实上不需要模拟任何事情；一个即时的快照会在 Apollo 有机会执行 query 查询之前捕捉到加载的状态。

```javascript
// client/src/components/Posts.test.js
// ...

describe("Posts", () => {
  // ...

  it("renders correctly when loaded", async () => {
    const mocks = [
      {
        request: {
          query: GET_POSTS,
        },
        result: {
          data: {
            posts: [
              {
                id: 1,
                body: "Thoughts",
                insertedAt: "2019-04-18T00:00:00",
                user: {
                  id: 1,
                  name: "John Smith",
                  gravatarMd5: "abc",
                },
              },
            ],
          },
        },
      },
    ];
    const { container, getByText } = render(
      <MemoryRouter>
        <AuthContext.Provider value={{}}>
          <MockedProvider mocks={mocks} addTypename={false}>
            <Posts />
          </MockedProvider>
        </AuthContext.Provider>
      </MemoryRouter>,
    );
    await wait(() => getByText("Thoughts"));
    expect(container).toMatchSnapshot();
  });

  // ...
});
```

对于这个测试，我们希望一旦加载结束帖子被显示出来，就立刻快照。为了达到这个，我们必须让测试 `async`，然后使用 react-testing-library 的 `wait` 来 await 加载状态的结束。`wait(() => ...)` 将会简单的重试这个函数直到结果不再错误 —— 通常情况下不会超过 0.1 秒。一旦文本显现出来，我们就立刻对整个组件快照以确保那是我们所期待的结果。

```javascript
// client/src/components/Posts.test.js
// ...

describe("Posts", () => {
  // ...

  it("renders correctly after created post", async () => {
    Subscriber.mockImplementation((props) => {
      const { default: ActualSubscriber } = jest.requireActual(
        "containers/Subscriber",
      );
      return <ActualSubscriber {...props} />;
    });

    const mocks = [
      {
        request: {
          query: GET_POSTS,
        },
        result: {
          data: {
            posts: [
              {
                id: 1,
                body: "Thoughts",
                insertedAt: "2019-04-18T00:00:00",
                user: {
                  id: 1,
                  name: "John Smith",
                  gravatarMd5: "abc",
                },
              },
            ],
          },
        },
      },
      {
        request: {
          query: POSTS_SUBSCRIPTION,
        },
        result: {
          data: {
            postCreated: {
              id: 2,
              body: "Opinions",
              insertedAt: "2019-04-19T00:00:00",
              user: {
                id: 2,
                name: "Jane Thompson",
                gravatarMd5: "def",
              },
            },
          },
        },
      },
    ];
    const { container, getByText } = render(
      <MemoryRouter>
        <AuthContext.Provider value={{}}>
          <MockedProvider mocks={mocks} addTypename={false}>
            <Posts />
          </MockedProvider>
        </AuthContext.Provider>
      </MemoryRouter>,
    );
    await wait(() => getByText("Opinions"));
    expect(container).toMatchSnapshot();
  });
});
```

最后，我们将会来测试 subscription，来确保当组件收到一个新的帖子时，它能够按照所期待地结果进行正确地渲染。在这个测试案例中，我们需要更新 `Subscription` 的模拟，以便它实际地返回原始的实现，并为组件订阅所发生的变化（新建帖子）。我们同时模拟了一个叫 `POSTS_SUBSCRIPTION` 地查询来模拟 subscription 接收到一个新的帖子。最后，同上面的测试一样，我们等待查询语句的结束（并且新帖子的文本出现）并对 HTML 进行快照。

以上就差不多是全部的内容了。jest 和 react-testing-library 都非常的强大，它们使我们对组件的测试变得简单。测试 Apollo 有一点点困难，但是通过明智地使用模拟数据，我们也能够写出一些非常完整的测试来测试所有主要组件的状态。

## 服务器端渲染

现在我们的客户端只有一个问题了 —— 所有的 HTML 都是在客户端被渲染的。从服务器返回的 HTML 只是一个空的 `index.html` 文件和一个 `<script>` 标签，所载入的 JavaScript 渲染了全部的内容。在开发模式下，这样可以，但这样对生产环境并不好 —— 例如说，很多的搜索引擎并不擅长运行 JavaScript 来根据客户端渲染的内容构建索引（index）。我们真正希望的是服务器能返回该页面的完全渲染的 HTML，然后 React 可以接管客户端，处理用户的加护的路由。

这里，服务器端渲染（SSR）的概念被引入进来。本质上来说，相比于提供静态的 HTML 索引文件，我们将请求路由到 Node.js 服务器端。服务器渲染组件（解析对 GraphQL 端点的任何查询）并且返回输出的 HTML，和 `<script>` 标签来加载 JavaScript。当 JavaScript 在客户端加载，它会使用 `hydrate` 函数而不是从头开始渲染 —— 意味着它会保存已存在的，服务器端提供的 HTML 并将它和相匹配的 React 树联系起来。这种方法将允许搜索引擎简单的索引服务器渲染的 HTML，并且因为用户不再需要在页面可视之前等待 JavaScript 文件的下载，执行和进行查询，这也会为用户提供了一个更快的体验。

不幸的是，我发现配置 SSR 真正的并没有一个通用的方法 —— 他们的基础是相同的（都是运行一个可以渲染组件的 Node.js 服务器）但是存在一些不同的实现，并且没有任何实现被标准化。我的应用的大部分的配置都来自于 [cra-ssr](https://github.com/cereallarceny/cra-ssr)，它为 create-react-app 搭建的应用用提供了非常易于理解的 SSR 的实现。因为 cra-ssr 的教程提供相当完善的介绍，我不会在这里做更加深入的剖析。我是想说，SSR 很棒并且使得应用加载的非常快，尽管实现它确实有点点困难。

## 结论和收获

感谢大家看到这里！这里内容超多，因为我想要真正地深入一个复杂的应用，来从头到尾地练习所有的技术，并且来解决一些在现实世界中真正遇到的问题。如果你已经读到这里了，希望你能对如何将这所有的技术用在一起有了一些不错的理解。你可以在 Github 上看到完整版的[代码](https://github.com/schneidmaster/socializer)。或者试用这个[在线演示](https://socializer-demo.herokuapp.com)。这个演示是部署在免费版的 Heroku dyno 上的，所以在你访问的时候，可能会需要 30 秒来唤醒服务器。如果你有任何问题，可以在演示下面的评论里留言，我会尽我的可能来回答。

我部署的体验也充满了挫折和问题。有些是意料之中，包括一些新的框架和库的学习曲线 —— 但也有一些地方，如果有更好的文档和工具，可以节省我很多的时间，让我不那么头疼。特别是 Apollo，我在理解如果让 websocket 在认证变化后重新初始化它的连接上遇到了一大堆问题；通常情况下这些都应该在文档里写下来，但是显然我啥也找不到。相似的，我在测试 subscriptions 时也遇到很多问题，并且最终不得不放弃转而使用 mock 测试。测试的文档对于基本的测试来说是非常够的，但是我发现当我想要写更高级的测试案例时，文档太过于浅显。我怕也经常因为缺少 API 的文档而感到困惑，主要是 Apollo 和 Absinthe 客户端库的一部分文档。例如说，当我研究如果重置 websocket 连接时，我找不到任何 Absinthe socket 实例和 Apollo link 实例的文档。我唯一能做的就是把 GitHub 上面的源代码从头到尾读一遍。我使用 Apollo 的体验比起几年前使用 Relay 的体验要好很多 —— 但是下一次我使用它时，我不得不接受，如果我想要另辟蹊径的话，就需要花更多的时间来破解改造代码的事实。

总而言之，我给这套技术栈很高的评分，而且我非常的喜欢这个项目。Elixir 和 Phoenix 用起来让人耳目一新；如果你来自 Rails，会有一些学习的曲线，但是我真的非常喜欢 Elixir 的一些语言特点，例如模式匹配和通道运算符（pipe operator）。Elixir 有很多新颖的想法（以及来许多来自函数式编程，经过实战考验的概念），让编写有意义的，好看的代码这件事变得十分简单。Absinthe 的使用就像是一阵春风拂面；它实现的很好，文档极佳，几乎涵盖了所有实现 GraphQL 服务器的合理用例，并且从总体上来说，我发现 GraphQL 的核心概念也被很好地传递。查询每一个页面我需要的数据十分简单，通过 subscription 实现实时地更新也非常容易。我一直都非常喜欢使用 React 和 React Router，这一次也不例外 —— 它们使得构建复杂，交互的前端用户界面变得简单。最后，我十分满意整体的结果 —— 作为一名用户，应用的加载和浏览非常快，所有的东西都是实时的所以可以一直保持同步。如果说对技术栈的终极衡量标准是用户的体验，那这个组合一定是一个巨大的成功。

---

- [Elixir, Phoenix, Absinthe, GraphQL, React, and Apollo: an absurdly deep dive - Part 1](https://github.com/xitu/gold-miner/blob/master/TODO1/elixir-phoenix-absinthe-graphql-react-apollo-absurdly-deep-dive-1.md)
- [Elixir, Phoenix, Absinthe, GraphQL, React, and Apollo: an absurdly deep dive - Part 2](https://github.com/xitu/gold-miner/blob/master/TODO1/elixir-phoenix-absinthe-graphql-react-apollo-absurdly-deep-dive-2.md)

---

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
