> * 原文地址：[Elixir, Phoenix, Absinthe, GraphQL, React, and Apollo: an absurdly deep dive - Part 2](https://schneider.dev/blog/elixir-phoenix-absinthe-graphql-react-apollo-absurdly-deep-dive/)
> * 原文作者：[Zach Schneider](https://www.github.com/schneidmaster)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/elixir-phoenix-absinthe-graphql-react-apollo-absurdly-deep-dive-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/elixir-phoenix-absinthe-graphql-react-apollo-absurdly-deep-dive-2.md)
> * 译者：
> * 校对者：

# Elixir, Phoenix, Absinthe, GraphQL, React, and Apollo: an absurdly deep dive - Part -2

如果你没有看过本系列文章的第一部分，建议你先去看第一部分：

- [Elixir, Phoenix, Absinthe, GraphQL, React, and Apollo: an absurdly deep dive - Part 1](https://github.com/xitu/gold-miner/blob/master/TODO1/elixir-phoenix-absinthe-graphql-react-apollo-absurdly-deep-dive-1.md)
- [Elixir, Phoenix, Absinthe, GraphQL, React, and Apollo: an absurdly deep dive - Part 2](https://github.com/xitu/gold-miner/blob/master/TODO1/elixir-phoenix-absinthe-graphql-react-apollo-absurdly-deep-dive-2.md)

### Testing — server side

Now that we’ve gotten all that code written, how do we make sure it keeps working? There’s a few different layers to think about testing here. First, we should unit test the models — do they validate correctly and do their helper methods return what’s expected? Second, we should also unit test the resolvers — do they handle different cases (success and error) and return the correct data or apply the correct change? Third, we should write some complete integration tests, sending a query to the server and expecting the response to be correct. This helps us keep a handle on the big picture, and also ensures we cover cases like the authentication logic. Fourth, we will want tests on our subscriptions — do they correctly notify the socket when relevant changes are made?

Elixir has a basic built-in testing library called ExUnit. It contains simple `assert`/`refute` helpers and handles running your tests. It’s also common in Phoenix to set up “case” support files; these are included in tests to run common setup tasks like connecting to the database. Beyond the defaults, there are two helper libraries that I found helpful in my tests — [ex_spec](https://hexdocs.pm/ex_spec/readme.html) and [ex_machina](https://hexdocs.pm/ex_machina/readme.html). ex_spec adds simple `describe` and `it` macros that make the testing syntax feel a little friendlier, at least from my ruby background. ex_machina provides factories which make it easy to dynamically insert test data.

My factories look like this:

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

And after importing the factory into the case setup, it can be used in tests with a very intuitive syntax:

```elixir
# Insert a user
user = insert(:user)

# Insert a user with a specific name
user_named = insert(:user, name: "John Smith")

# Insert a post for the user
post = insert(:post, user: user)
```

With the setup out of the way, here’s what the `Post` model test looks like:

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

Hopefully this test is fairly intuitive. For each case, we insert any needed test data, invoke the method being tested, and make assertions about the results.

Next, let’s look at a resolver test:

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

The resolver tests are also fairly simple — they’re also unit tests, just operating at one layer up from the models. We insert any setup data, invoke the resolver, and expect the correct result to be returned.

The integration tests get a little more complicated. We need to set up a connection (possibly with authentication) and send it a query to ensure we get the correct result. I found [this post](https://tosbourn.com/testing-absinthe-exunit) extremely helpful in learning how to set up integration tests for Absinthe.

First, we create a helper file with some of the common functionality that the integration tests will need:

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

There are three helper methods. The first takes a connection object and a user, and authenticates the connection by adding a header with an authentication token for the user. The second and third accept a query and return the JSON structure used to wrap a GraphQL query when sending it over the network.

Onward to the test itself:

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

This test exercises the endpoint to query for a list of posts. We start by inserting some posts into the database; write the query; post it to the connection; and check the response to make sure our test data was returned as expected.

There’s a very similar test for the endpoint to show a single post, but we’ll skip it for brevity (you can look through all of the integration tests [here](https://github.com/schneidmaster/socializer/tree/master/test/socializer_web/integration) if you want). Let’s look at the integration test for the post creation mutation:

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

Pretty similar, but two differences around the request — we pipe the connection through `AbsintheHelpers.authenticate_conn(user)` to add the user’s authentication token, and we invoke the `mutation_skeleton` helper instead of `query_skeleton`.

How about subscription tests? These also involve a bit of setup to create a socket connection where we can establish and exercise the subscription. I found [this article](https://www.smoothterminal.com/articles/building-a-forum-elixir-graphql-backend-with-absinthe) extremely helpful for understanding the setup process for a subscription test.

First, we create a new “case” to do the setup for subscription tests. It looks like this:

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

After the common imports, we define a `setup` step which inserts a new user and sets up a websocket authenticated with the user’s token. We return the socket and the user for our tests to use.

Next, let’s have a look at the test itself:

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

First, we write a subscription query, and push it onto the socket that we constructed during the test setup. Next, we write a mutation that’s expected to trigger the subscription (i.e. creating a new post) and push that onto the socket. Finally, we check the `push` response to assert that we were pushed an update about the newly created post. A bit more setup involved, but this gives us a nice end-to-end test on the lifecycle of a subscription.

### The client

Whew! That’s a pretty decent outline of what’s happening on the server side — it handles queries as defined in the types, implemented in the resolvers, using the models to query and persist data. Next, let’s take a look at how the client is built.

I started out with [create-react-app](https://facebook.github.io/create-react-app), which is great for bootstrapping React projects — it sets up a “hello world” React app with sound defaults and structure, and abstracts away a lot of the configuration.

I’m using [React Router](https://reacttraining.com/react-router) for the routing in my application; this will allow users to navigate between a list of posts, a single post, a chat conversation, etc. The root component of my application looks something like this:

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

A few pieces here — `util/apollo` exposes a `createClient` function that creates and returns an Apollo client instance (more on that next). Wrapping it in a `useRef` makes the same client instance available for the lifetime of the application (i.e. across rerenders). The `ApolloProvider` HOC makes the client available in context for child components/queries. The `BrowserRouter` uses the HTML5 history API to keep the URL state in sync as we navigate around the application.

The `Switch` and `Route` components merit their own discussion. React Router is built around the concept of “dynamic” routing. Most web server frameworks use “static” routing, which is to say that your URL matches exactly one route and renders an entire page based on that route. With “dynamic” routing, routes are sprinkled throughout the application, and more than one route can match the URL. This sounds confusing, but it’s actually **really** nice once you get the hang of it. It makes it easy to build screens that have different components which react to different parts of the route. For example, imagine a messenger screen similar to Facebook messenger (Socializer’s chat interface is similar) — the left side always shows a list of conversations, and the right side shows a conversation only if one is selected. Dynamic routing lets me express that like so:

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

The root-level `App` renders the `Chat` component if the route starts with `/chat` (possibly with an ID on the end, i.e. `/chat/123`). The `Chat` component renders the sidebar (which should always be visible) and then renders its own routes, which show a `Conversation` if the route has an ID (note the lack of a `?` so the `:id` parameter is not optional) and otherwise falls through to an empty state. This is the power of dynamic routing — it lets you progressively render different pieces of the interface based on the current URL, while localizing route-based concerns to the relevant component.

Even with dynamic routing, sometimes you want to render exactly one route (similar to a traditional static router). That’s where the `Switch` component comes in. Without the `Switch`, React Router will render **every** component that matches the current URL, so in our `Chat` component above we would get both the conversation and the empty state message. `Switch` tells React Router to only render the first route matching the current URL, and ignore the rest.

### The Apollo client

Now that we’ve got that down, let’s dive a bit deeper into the Apollo client — specifically the `createClient` function referenced above. The `util/apollo.js` file looks like this:

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

Starting out pretty simple. Import a bunch of dependencies that we’ll need shortly, and set constants for the HTTP URL and the websocket URL based on the current environment — pointed at my Gigalixir instance in production, or at localhost in development.

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

An Apollo client instance requires you to provide it with a link — essentially, a connection to your GraphQL server which the Apollo client can use to make requests. There are two common kinds of links — the HTTP link, which makes requests to the GraphQL server over standard HTTP, and the websocket link, which opens a websocket connection to the server and sends queries over the socket. In our case, we actually want **both**. For regular queries and mutations, we’ll use the HTTP link and for subscriptions we’ll use the websocket link.

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

Apollo provides the `split` method which lets you route queries to different links based on the criteria of your choice — you can think of it like a ternary: if the query has a subscription, then send it through the socket link, else send it through the HTTP link.

We also might need to provide authentication for both of our links, if the user is currently logged in. When they log in, we’re going to set their authentication token to a `token` cookie (more on that in a bit). We used the `token` as a parameter when establishing the Phoenix websocket connection in the previous section, and here we use the `setContext` wrapper to set the `token` on the authorization header of requests over the HTTP link.

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

And that’s just about it. In addition to the link, an Apollo client also needs a cache instance; GraphQL automatically caches the results of queries to prevent duplicate requests for the same data. The basic `InMemoryCache` is ideal for most use cases — it just keeps the cached query data in local browser state.

### Using the client — our first query

Great, so we’ve set up the Apollo client instance, and made it available throughout the application via the `ApolloProvider` HOC. Now let’s take a look at how it’s used to run queries and mutations. We’ll start with the `Posts` component, which is used to render the feed of posts on the homepage of the application.

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

We start with our imports, and then write the queries we need to render the posts. There are two — the first is a basic query to fetch the list of posts (along with information about the user who wrote each post), and the second is a subscription query to notify us of any new posts, so we can live-update the screen and keep the feed up to date.

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

Now we’ll implement the actual component. First, to run the base query, we render Apollo’s `<Query query={GET_POSTS}>`. It provides several render props to its child — `loading`, `error`, `data`, and `subscribeToMore`. If the query is loading, we just render a simple loading spinner. If there was an error, we render a generic `ErrorMessage` for the user. Otherwise, the query was successful, so we can render a `Feed` component (passing through the `data.posts` which contains the posts to be rendered, matching the structure of the query).

`subscribeToMore` is an Apollo helper for implementing a subscription that is only responsible for fetching new items in the collection that the user is currently viewing. It’s supposed to be invoked at the `componentDidMount` phase of the child component, which is why it’s passed through as a prop to `Feed` — `Feed` is responsible for calling `subscribeToNew` once the `Feed` has rendered. We provide `subscribeToMore` our subscription query and an `updateQuery` callback, which Apollo will invoke when it receives notice that a new post has been created. When that happens, we simply push the new post onto the existing array of posts, using [immer](https://github.com/immerjs/immer) to return a new object so the component correctly rerenders.

### Authentication (and mutations)

So now we’ve got a homepage that can render a list of posts, and can respond in realtime to new posts being created — how do new posts get created? For starters, we’ll want to allow users to sign in to an account, so we can associate them with their posts. This will require us to write a mutation — we need to send an email and password to the server, and get back a new authentication token for the user. Let’s get started with the login screen:

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

The first section is similar to the query component — we import our dependencies and then write the login mutation. It accepts an email and a password, and we want to get back the ID of the authenticated user and their authentication token.

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

In the component body, we first fetch the current `token` and a `setAuth` function from context (more on this `AuthContext` in a second). We also set some local state using `useState`, so we can store temporary values for the user’s email, password, and whether their credentials are invalid (so we can show an error state on the form). Finally, if the user already has an auth token, they’re already logged in so we can just redirect them to the homepage.

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

There’s a decent bit here, but don’t get overwhelmed — most of it is just rendering the Bootstrap components for the form. We start with a `Helmet` from [react-helmet](https://github.com/nfl/react-helmet) — this component is a top-level page (compared to `Posts` which is rendered as a child of the `Home` page) so we want to give it a browser title and some metadata. Next we render the `Mutation`, passing it our mutation query from above. If the mutation returns an error, we use the `onError` callback to set the state to invalid, so we can show an error in the form. The mutation passes a function to its child (named `login` here) which will invoke the mutation, and the second argument is the same array of values that we’d get from a `Query`. If `data` is populated, that means the mutation has successfully executed, so we can store our auth token and user ID with the `setAuth` function. The rest of the form is pretty standard React Bootstrap — we render inputs and update the state values on change, showing an error message if the user attempted a login but their credentials were invalid.

What about that `AuthContext`? Once the user has authenticated, we need to somehow store their auth token on the client side. GraphQL wouldn’t really help here because it’s a chicken-and-the-egg problem — I need to have the auth token in order to authenticate the request in order to get the auth token. We could wire up Redux to store the token in local state, but that feels like overkill when we only need to store one value. Instead, we can just use the React context API to store the token in state at the root of our application, and make it available as needed.

First, let’s create a helper file which creates and exports the context:

```javascript
// client/src/util/context.js
import { createContext } from "react";

export const AuthContext = createContext(null);
```

And then we’ll create a `StateProvider` HOC which we’ll render at the root of the application — it will be responsible for keeping and updating the authentication state.

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

There’s a lot of stuff going on here. First, we create state for both the `token` and the `userId` of the authenticated user. We initialize that state by reading cookies, so we can keep the user logged in across page refreshes. Then we implement our `setAuth` function. If it’s invoked with `null` then it logs the user out; otherwise it logs the user in with the provided `token` and `userId`. Either way, it updates both the local state and the cookies.

There’s a major challenge with authentication and the Apollo websocket link. We initialize the websocket using either a token parameter if authenticated, or no token if the user is signed out. But when the authentication state changes, we need to reset the websocket connection to match. If the user starts out logged out and then logs in, we need to reset the websocket to be authenticated with their new token, so they can receive live updates for logged-in activities like chat conversations. If they start out logged in and then log out, we need to reset the websocket to be unauthenticated, so they don’t continue to receive websocket updates for an account that they’re no logger logged into. This actually turned out to be really hard — there is no well-documented solution and it took me a couple of hours to find something that worked. I ended up manually implementing a reset helper for the socket:

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

It disconnects the Phoenix socket, leaves the existing Phoenix channel for GraphQL updates, creates a new Phoenix channel (with the same name as the default channel that Abisnthe creates on setup), marks that the channel has not been joined yet (so Absinthe rejoins the channel on connect), and then reconnects the socket. Farther up in the file, the Phoenix socket is configured to dynamically look up the token in the cookies before each connection, so when it reconnects it will use the new authentication state. I found it frustrating that there was no good solution for what seems like a common problem, but with some manual effort I got it working well.

Finally, the `useEffect` in our `StateProvider` is what invokes the `refreshSocket` helper. The second argument, `[token]`, tells React to reevaluate the function every time the `token` value changes. If the user has just logged out, we also call `client.clearStore()` to make sure that the Apollo client does not continue caching queries that contain privileged data, like the user’s conversations or messages.

And that’s pretty much all there is for the client. You can look through the rest of the [components](https://github.com/schneidmaster/socializer/tree/master/client/src) for more examples of queries, mutations, and subscriptions, but the patterns are largely the same as what we’ve walked through so far.

### Testing — client side

Let’s write some tests to cover our React code. Our app comes with [jest](https://jestjs.io) built in (create-react-app includes it by default); jest is a fairly simple and intuitive test runner for JavaScript. It also includes some advanced features like snapshot testing, which we’ll put to use in our first test.

I’ve come to really enjoy writing React tests with [react-testing-library](https://testing-library.com/react) — it provides a simple API which encourages you to render and exercise components from the perspective of a user (without delving into the implementation details of components). Also, its helpers subtly push you to ensure your components are accessible, as it’s hard to get a handle on a DOM node to interact with it if the node is not generally accessible in some fashion (correctly labeled with text, etc.).

We’ll start with a simple test of our `Loading` component. The component just renders some static loading HTML so there’s not really any logic to test; we just want to make sure the HTML renders as expected.

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

When you invoke `.toMatchSnapshot()`, jest will create a relative file under `__snapshots__/Loading.test.js.snap` to record the current state. Subsequent test runs will compare the output against the recorded snapshot, and fail the test if the snapshot doesn’t match. The snapshot file looks like this:

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

In this case, the snapshot test is not really all that useful, since the HTML never changes — though it does serve to confirm that the component renders without error. In more advanced cases, snapshot tests can be very useful to ensure that you only change component output when you intend to do so — for example, if you’re refactoring the logic inside your component but expecting the output not to change, a snapshot test will let you know if you’ve made a mistake.

Next, let’s have a look at a test for an Apollo-connected component. This is where things get a bit more complicated; the component expects to have an Apollo client in its context, and we need to mock out the queries to ensure the component correctly handles responses.

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

We start out with some imports and mocks. The mock is to prevent the `Posts` component’s subscription from being registered unless we want it to. This was an area where I had a lot of frustration — Apollo has documentation for mocking queries and mutations, but not much by way of mocking subscriptions, and I frequently encountered cryptic, internal errors that were hard to track down. I never was able to figure out how to reliably mock the queries when I just wanted the component to execute its initial query (and **not** mock it out to receive an update from its subscription).

This does give a good opportunity to discuss mocks in jest though — they’re extremely useful for cases like this. I have a `Subscriber` component which normally invokes the `subscribeToNew` prop once it mounts and then returns its children:

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

So in my test, I’m just mocking out the implementation of this component to return the children without invoking `subscribeToNew`.

Finally, I’m using `timekeeper` to freeze the time around each test — the `Posts` component renders some text based on the relation of the post time to the current time (e.g. “two days ago”), so I need to ensure the test always runs at the “same” time, or else the snapshots will regularly fail as time progresses.

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

Our first test checks the loading state. We have to wrap it in a few HOCs — `MemoryRouter` which provides a simulated router for any React Router `Link`s and `Route`s; `AuthContext.Provider` which provides the authentication state; and `MockedProvider` from Apollo. Since we’re taking an immediate snapshot and returning, we don’t actually need to mock anything; the immediate snapshot will just capture the loading state before Apollo has had a chance to execute the query.

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

For this test, we want to snapshot the screen once loading has finished and the posts are being displayed. For this, we have to make our test `async`, and then use react-testing-library’s `wait` to await the load to finish. `wait(() => ...)` will simply retry the function until it doesn’t error — which hopefully shouldn’t be more than a fraction of a second. Once the text has appeared, we snapshot the whole component to make sure it’s what we expect.

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

Finally, we’ll test out the subscription, to make sure the component rerenders as expected when it receives a new post. For this case, we need to update the `Subscription` mock so that it actually returns the original implementation and subscribes the component to updates. We also mock a `POSTS_SUBSCRIPTION` query to simulate the subscription receiving a new post. Finally, similar to the last test, we wait for the queries to resolve (and the text from the new post to appear) and then snapshot the HTML.

And that’s pretty much it. jest and react-testing-library are very powerful and make it easy to exercise our components. Testing Apollo is a bit of trouble, but with some judicious use of mocking I was able to write a pretty solid test that exercises all of the major component state cases.

### Server-side rendering

There’s one more problem with our client application — all of the HTML is rendered on the client side. The HTML returned from the server is just an empty `index.html` file with a `<script>` tag to load the JavaScript that actually renders everything. This is fine in development, but not great for production — for example, many search engines are not great at running JavaScript and indexing client-rendered content. What we really want is for the server to return the fully rendered HTML for the page, and then React can take over on the client side to handle subsequent user interactions and routing.

This is where the concept of server-side rendering (or SSR) comes in. Essentially, instead of serving a static HTML index file, we route requests to a Node.js server. The server renders the components (resolving any queries to the GraphQL endpoint) and returns the output HTML, along with the `<script>` tag to load the JavaScript. When the JavaScript loads on the client, it “hydrates” instead of fully rendering from scratch — meaning that it keeps the existing HTML provided by the server and connects it to the matching React tree. This approach allows search engines to easily index the server-rendered HTML, and also provides a faster experience for users since they don’t have to wait for the JavaScript to download, execute, and run queries before the page content is visible.

Unfortunately, I found configuring SSR to be something of a wild west — the fundamentals are the same (run a Node.js server that renders components) but there are a number of different implementations and nothing that’s very well standardized. I lifted most of my application’s configuration from [cra-ssr](https://github.com/cereallarceny/cra-ssr), which provides a pretty comprehensive implementation of SSR for apps bootstrapped with create-react-app. I won’t delve too deep here, as cra-ssr’s tutorial provides a solid introduction. Suffice it to say that SSR is awesome and makes the app feel extremely fast to load, but getting it working is still a bit of a struggle.

### Conclusion and takeaways

Thanks for staying with me! There’s a lot of content here, but I wanted to really dive deep on a reasonably complex application, to thoroughly exercise the technology stack and work out the kinks that arise with real-world use cases. If you’ve read this far, hopefully you have a pretty good understanding of how all the pieces fit together. You can look through the full [codebase](https://github.com/schneidmaster/socializer) on GitHub, or try out the [live demo](https://socializer-demo.herokuapp.com). (The live demo is running on a free-tier Heroku dyno, so it might take 30 seconds or so to wake up when you visit it.) If you have questions, feel free to leave them in the comments and I’ll do my best to answer.

My development experience was not free from frustration and trouble. Some of it is to be expected as the learning curve for a new framework or library — but I think there are some areas where better documentation or tooling would have saved me a lot of time and heartache. With Apollo in particular, I had a ton of trouble figuring out how to get the websocket to reinitialize its connection when the authentication state changes; this feels like a fairly common case that should be documented somewhere, but I just could not find anything. Similarly, I had a lot of trouble around testing subscriptions, and ultimately gave up and used a mock. The documentation around testing was great for the “happy path” of basic tests, but I found it to be shallow once I started working through more advanced use cases. I was also confounded at times by the lack of basic API documentation, which falls partially on Apollo and partially on Absinthe’s client-side library. When researching how to reset the websocket connection, I couldn’t find any API documentation for Absinthe socket instances or Apollo link instances, for example; I basically just had to read through all the source code on GitHub. My experience with Apollo was much better than my experience with Relay a few years back — but next time I use it, I’ll still be bracing myself a bit for the fact that I’ll need to spend some time hacking through jungle if I have to depart from the beaten path.

With all that said, on the whole I give this stack very high marks, and I really enjoyed working on this project. Elixir and Phoenix are refreshing to use; there’s a learning curve coming from Rails, but I really like some of Elixir’s language features such as pattern matching and the pipe operator. Elixir has a lot of fresh ideas (and many battle-tested concepts from functional programming) that make it easy to write expressive, beautiful code. Absinthe was a breeze to use; it’s very well implemented with sound documentation and it covers all of the reasonable use cases around implementing a GraphQL server. And on the whole, I found that GraphQL delivered on its fundamental promises. It was easy to query the data I needed for each page, and also easy to wire up live updates via subscriptions. I’ve always enjoyed working with React and React Router, and this time was no different — they make it easy to build complex, reactive user interfaces for the frontend. Finally, I am very satisfied with the overall result — as a user, my application is blazing fast to load and navigate, and everything live updates so I’m never out of sync. If the ultimate measure of a technology stack is the user experience that results, I’d say this combination is a smashing success.

---

- [Elixir, Phoenix, Absinthe, GraphQL, React, and Apollo: an absurdly deep dive - Part 1](https://github.com/xitu/gold-miner/blob/master/TODO1/elixir-phoenix-absinthe-graphql-react-apollo-absurdly-deep-dive-1.md)
- [Elixir, Phoenix, Absinthe, GraphQL, React, and Apollo: an absurdly deep dive - Part 2](https://github.com/xitu/gold-miner/blob/master/TODO1/elixir-phoenix-absinthe-graphql-react-apollo-absurdly-deep-dive-2.md)

---

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
