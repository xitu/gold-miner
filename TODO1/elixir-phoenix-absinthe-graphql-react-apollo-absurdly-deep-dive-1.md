> * 原文地址：[Elixir, Phoenix, Absinthe, GraphQL, React, and Apollo: an absurdly deep dive - Part 1](https://schneider.dev/blog/elixir-phoenix-absinthe-graphql-react-apollo-absurdly-deep-dive/)
> * 原文作者：[Zach Schneider](https://www.github.com/schneidmaster)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/elixir-phoenix-absinthe-graphql-react-apollo-absurdly-deep-dive-1.md](https://github.com/xitu/gold-miner/blob/master/TODO1/elixir-phoenix-absinthe-graphql-react-apollo-absurdly-deep-dive-1.md)
> * 译者：
> * 校对者：

# Elixir, Phoenix, Absinthe, GraphQL, React, and Apollo: an absurdly deep dive - Part 1

If you’re anything like me, at least 3 or 4 of the keywords in the title of this article fall under the category of “things I’ve been wanting to play with but haven’t gotten around to it yet.” React is the exception; I use it almost every day at work and know it front and back. I used Elixir for a project a couple of years ago, but it’s been a while and I’ve never used it in the context of GraphQL. Similarly, I’ve done a small amount of work on a project that used GraphQL with a Node.js backend and Relay on the frontend, but I barely scratched the surface of GraphQL and I’ve never used Apollo. I firmly believe that the best way to truly learn a technology is to build something with it, so I decided to take a deep dive and build a web application with all of these technologies together. If you want to skip to the end, the code is [on GitHub](https://github.com/schneidmaster/socializer) and there’s a live demo [here](https://socializer-demo.herokuapp.com). (The live demo is running on a free-tier Heroku dyno, so it might take 30 seconds or so to wake up when you visit it.)

### Defining our terms

First, let’s walk through the components I name-dropped above and how they will all fit together.

* [Elixir](https://elixir-lang.org) is a server-side programming language.
* [Phoenix](https://phoenixframework.org) is the most popular web server framework for Elixir. Ruby : Rails :: Elixir : Phoenix.
* [GraphQL](https://graphql.org) is a query language for APIs.
* [Absinthe](https://hexdocs.pm/absinthe/overview.html) is the most popular Elixir library for implementing a GraphQL server.
* [Apollo](https://www.apollographql.com/docs/react) is a popular JavaScript library for consuming a GraphQL API. (Apollo also has a server-side package, used for implementing a GraphQL server in Node.js, but I’m only using the client to consume my Elixir GraphQL server.)
* [React](https://reactjs.org) is a popular JavaScript framework for building frontend user interfaces. (You probably already knew this one.)

### What am I building?

I decided to build a toy social network. It seemed simple enough to feasibly accomplish in a reasonable amount of time, but complex enough that I would encounter the challenges of getting everything working in a real-world application. My social network is creatively called Socializer. Users can make posts and comment on other users’ posts. Socializer also has a chat feature; users can start private conversations with other users, and each conversation can have any number of users (i.e. group chat).

### Why Elixir?

Elixir has been steadily gaining in popularity over the last several years. It runs on the Erlang VM, and you can write Erlang syntax directly in an Elixir file, but it is designed to provide a much friendier syntax for developers while keeping the speed and fault tolerance of Erlang. Elixir is dynamically typed, and the syntax feels similar to ruby. However, it is much more functional than ruby, and has many different idioms and patterns.

At least for me, the major draw to Elixir is the performance of the Erlang VM. It’s frankly absurd. The team at WhatsApp was able to establish [two **million** connections to a single server](https://blog.whatsapp.com/196/1-million-is-so-2011) using Erlang. An Elixir/Phoenix server can often serve simple requests in less than 1 millisecond; it’s thrilling seeing the μ symbol in your terminal logs for request duration.

Elixir has other benefits as well. It’s designed to be fault tolerant; you can think of the Erlang VM as a cluster of nodes, where any one node can go down without disrupting the others. This also makes it possible to do “hot code swapping”, deploying new code without having to stop and restart the application. I also find a lot of joy in its [pattern matching](https://elixirschool.com/en/lessons/basics/pattern-matching) and its [pipe operator](https://elixirschool.com/en/lessons/basics/pipe-operator). It’s refreshing writing heavily functional code that still approaches the beauty of ruby, and I find that it drives me to think clearly about my code and write fewer bugs as a result.

### Why GraphQL?

With a traditional RESTful API, the server defines what resources and routes it offers (through API documentation, or perhaps through some automated contract like Swagger) and the consumer has to make the correct sequence of calls to get the data they want. If the server has a posts endpoint to get a blog post, a comments endpoint to get the comments on the post, and a users endpoint to get the authors’ names and pictures, a consumer might have to make three separate requests to get the information it needs for one view. (For such a trivial case, obviously the API would probably permit you to retrieve the associated record data, but it illustrates the shortcoming — the request structure is arbitrarily defined by the server, rather than matching the fluid needs of each individual consumer and page). GraphQL inverts this principle — the client sends a query document describing the data it needs (possibly spanning table relationships) and the server returns it all in one request. For our blog example, a post query might look something like this:

```graphql
query {
  post(id: 123) {
    id
    body
    createdAt
    user {
      id
      name
      avatarUrl
    }
    comments {
      id
      body
      createdAt
      user {
        id
        name
        avatarUrl
      }
    }
  }
}
```

This query describes all of the information that a consumer might need to render a page with a blog post: the ID, body, and timestamp of the post itself; the ID, name, and avatar URL of the user who published the post; the IDs, bodies, and timestamps of the comments on the post; and the IDs, names, and avatar URLs of the user who submitted each comment. The structure is intuitive and flexible; it’s great for building interfaces because you can just describe the data you want, rather than contorting around the structure offered by an API.

There are two other key concepts in GraphQL: mutations and subscriptions. A mutation is a query that makes a change to the data on the server; it’s the equivalent of a POST/PATCH/PUT in a RESTful API. The syntax is pretty similar to a query; here’s what a mutation to create a post might look like:

```graphql
mutation {
  createPost(body: $body) {
    id
    body
    createdAt
  }
}
```

The attributes of the record are provided as arguments, and the block describes the data you need to get back once the mutation is complete (in this case the ID, body, and timestamp of the new post).

A subscription is fairly unique to GraphQL; there isn’t really a direct analog in a RESTful API. It allows a client to say that it would like to receive live updates from the server every time a particular event happens. For example, if I want the homepage to live update every time a new post is created, I might write a post subscription like this:

```graphql
subscription {
  postCreated {
    id
    body
    createdAt
    user {
      id
      name
      avatarUrl
    }
  }
}
```

As you can probably intuit, this tells the server to send me a live update any time a new post is created, and include the post’s ID, body, and timestamp, and its author’s ID, name, and avatar URL. Subscriptions are generally backed by websockets; the client keeps a socket open to the server, and the server sends a message down to the client whenever the event happens.

One last thing — GraphQL has a pretty awesome development tool called GraphiQL. It’s a web interface with a live editor where you can write and execute queries and see the results. It includes autocompletion and other sugar that makes it easy to find available queries and fields; it’s particularly great when you’re iterating on the structure of a query. You can try out the GraphiQL interface for my web application [here](https://brisk-hospitable-indianelephant.gigalixirapp.com/graphiql). Try sending it the following query to fetch a list of posts with associated data (a slightly trimmed-down version of the hypothetical example above):

```graphql
query {
  posts {
    id
    body
    insertedAt
    user {
      id
      name
    }
    comments {
      id
      body
      user {
        id
        name
      }
    }
  }
}
```

### Why Apollo?

Apollo has become one of the most popular GraphQL libraries, both on the server and the client. My previous experience with GraphQL was in 2016 with [Relay](https://facebook.github.io/relay), which is another client-side JavaScript library. To be honest, I hated it. I was drawn to the simple expressiveness of GraphQL queries, but Relay felt complex and difficult to wrap my head around; the documentation had a lot of jargon and I found it difficult to establish a base of knowledge that would let me comprehend it. To be fair, this was in Relay’s 1.0 version; they’ve made significant changes to simplify the library (which they’ve termed Relay Modern) and the documentation is a lot better these days as well. But I wanted to try something new, and Apollo has gained popularity in part because it offers a simpler development experience for building a GraphQL client application.

### The server side

I started by building the server side of the application; the client isn’t all that interesting without data to consume. I was also curious how well GraphQL would deliver on the promise of being able to write client-side queries that fetched all the data I needed (vs. needing to return to make changes on the server once I started implementing my client).

Specifically, I started by defining out the basic model structure of the application. On a high level, it looks like this:

```text
User
- Name
- Email
- Password hash

Post
- User ID
- Body

Comment
- User ID
- Post ID
- Body

Conversation
- Title (just the names of the participants denormalized to a string)

ConversationUser (each conversation can have any number of users)
- Conversation ID
- User ID

Message
- Conversation ID
- User ID
- Body
```

Hopefully pretty straightforward. Phoenix allows you to write database migrations that are pretty similar to the ones in Rails. Here’s the migration to create the users table, for example:

```elixir
# socializer/priv/repo/migrations/20190414185306_create_users.exs
defmodule Socializer.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :password_hash, :string

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
```

You can see the migrations for all of the other tables [here](https://github.com/schneidmaster/socializer/tree/master/priv/repo/migrations).

Next, I implemented the model classes. Phoenix uses a library called Ecto for its models; you can think of Ecto as analogous to ActiveRecord but less tightly coupled to the framework. One major difference is that Ecto models do not have any instance methods. A model instance is just a struct (like a hash with predefined keys); methods that you define on a model are class methods that accept an “instance” (struct), change it in some fashion, and return the result. This approach is generally idiomatic in Elixir; it preferences functional programming and variables are immutable.

Here’s the breakdown of my Post model:

```elixir
# socializer/lib/socializer/post.ex
defmodule Socializer.Post do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Socializer.{Repo, Comment, User}

  # ...
end
```

First, we bring in some other modules. In Elixir, `import` brings in the functions of a module (similar to `include`ing a model in ruby); `use` calls the `__using__` macro on the specified module. Macros are Elixir’s mechanism for metaprogramming. `alias` simply makes namespaced modules available as their base name (so I can reference a `User` as just `User` rather than having to type `Socializer.User` everywhere).

```elixir
# socializer/lib/socializer/post.ex
defmodule Socializer.Post do
  # ...

  schema "posts" do
    field :body, :string

    belongs_to :user, User
    has_many :comments, Comment

    timestamps()
  end

  # ...
end
```

Next, we have the schema. Ecto models must explicitly describe each attribute in the schema (unlike ActiveRecord, for example, which introspects the underlying database table and creates attributes for each field). The `schema` macro is made available by the `use Ecto.Schema` in the previous section.

```elixir
# socializer/lib/socializer/post.ex
defmodule Socializer.Post do
  # ...

  def all do
    Repo.all(from p in __MODULE__, order_by: [desc: p.id])
  end

  def find(id) do
    Repo.get(__MODULE__, id)
  end

  # ...
end
```

After the schema, I’ve defined a few helper functions for fetching posts from the database. With Ecto, the `Repo` module is used for all database queries; for example, `Repo.get(Post, 123)` would look up the post with ID 123. The database query syntax in the `search` method is made available by the `import Ecto.Query` at the top of the class. Finally, `__MODULE__` is just a shorthand for the current module (i.e. `Socializer.Post`).

```elixir
# socializer/lib/socializer/post.ex
defmodule Socializer.Post do
  # ...

  def create(attrs) do
    attrs
    |> changeset()
    |> Repo.insert()
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
  end

  def changeset(post, attrs) do
    post
    |> cast(attrs, [:body, :user_id])
    |> validate_required([:body, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
```

The changeset methods are Ecto’s approach to creating and updating records: you begin with a `Post` struct (either from an existing post or an empty one), “cast” (apply) the changed attributes, run through any validations, and then insert it into the database.

And that’s it for our first model. You can find the rest of the models [here](https://github.com/schneidmaster/socializer/tree/master/lib/socializer).

### The GraphQL schema

Next, I wired up the GraphQL components of the server. These can generally be grouped into two categories: types and resolvers. In types files, you use a DSL-like syntax to declare the objects, fields, and relations that are available to be queried. Resolvers are the “glue” that tells the server how to respond to any given query.

Here’s what my post types look like:

```elixir
# socializer/lib/socializer_web/schema/post_types.ex
defmodule SocializerWeb.Schema.PostTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: Socializer.Repo

  alias SocializerWeb.Resolvers

  @desc "A post on the site"
  object :post do
    field :id, :id
    field :body, :string
    field :inserted_at, :naive_datetime

    field :user, :user, resolve: assoc(:user)

    field :comments, list_of(:comment) do
      resolve(
        assoc(:comments, fn comments_query, _args, _context ->
          comments_query |> order_by(desc: :id)
        end)
      )
    end
  end

  # ...
end
```

After our `use`s and `import`s, we start out by simply defining the `:post` object for GraphQL. The ID, body, and inserted_at will implictly use values directly from the `Post` struct. Next, we declare a couple of associations that can be queried on the post — the user who created the post and the comments on the post. I’m overriding the comments association just to make sure that we always return the comments in the order they were inserted. I’ll note here that Absinthe transparently handles translating the casing of query and field names — it’s idiomatic in Elixir to use snake_case for variables and method names, while names in a GraphQL query use camelCase.

```elixir
# socializer/lib/socializer_web/schema/post_types.ex
defmodule SocializerWeb.Schema.PostTypes do
  # ...

  object :post_queries do
    @desc "Get all posts"
    field :posts, list_of(:post) do
      resolve(&Resolvers.PostResolver.list/3)
    end

    @desc "Get a specific post"
    field :post, :post do
      arg(:id, non_null(:id))
      resolve(&Resolvers.PostResolver.show/3)
    end
  end

  # ...
end
```

Next, we’ll declare a couple of root-level queries that involve posts. `posts` allows querying all posts on the site while `post` fetches a single post by ID. The types file simply declares the queries along with arguments and return types; the actual implementation is delegated to the resolver.

```elixir
# socializer/lib/socializer_web/schema/post_types.ex
defmodule SocializerWeb.Schema.PostTypes do
  # ...

  object :post_mutations do
    @desc "Create post"
    field :create_post, :post do
      arg(:body, non_null(:string))

      resolve(&Resolvers.PostResolver.create/3)
    end
  end

  # ...
end
```

After the queries, we declare a mutation that allows creating a new post on the site. As with the queries, the types file simply declares the metadata about the mutations, while the resolver will actually handle the implementation.

```elixir
# socializer/lib/socializer_web/schema/post_types.ex
defmodule SocializerWeb.Schema.PostTypes do
  # ...

  object :post_subscriptions do
    field :post_created, :post do
      config(fn _, _ ->
        {:ok, topic: "posts"}
      end)

      trigger(:create_post,
        topic: fn _ ->
          "posts"
        end
      )
    end
  end
end
```

Finally, we declare a subscription related to posts, `:post_created`. This allows clients to subscribe and receive an update any time a new post is created. `config` is used to set up the subscription, while `trigger` tells Absinthe what mutation should invoke the subscription. The `topic` allows you to segment subscription responses — in this case, we want to update the client about any post no matter what, but in other cases we only want to notify about certain changes. For example, here’s the comment subscription — the client only wants to know about new comments on a specific post (not every post) so it provides a `post_id` argument as the topic.

```elixir
defmodule SocializerWeb.Schema.CommentTypes do
  # ...

  object :comment_subscriptions do
    field :comment_created, :comment do
      arg(:post_id, non_null(:id))

      config(fn args, _ ->
        {:ok, topic: args.post_id}
      end)

      trigger(:create_comment,
        topic: fn comment ->
          comment.post_id
        end
      )
    end
  end
end
```

While I’ve broken out my types to separate files for each model, it’s worth noting that Absinthe requires you to assemble all of the types in a single `Schema` module. It looks like this:

```elixir
defmodule SocializerWeb.Schema do
  use Absinthe.Schema
  import_types(Absinthe.Type.Custom)

  import_types(SocializerWeb.Schema.PostTypes)
  # ...other models' types

  query do
    import_fields(:post_queries)
    # ...other models' queries
  end

  mutation do
    import_fields(:post_mutations)
    # ...other models' mutations
  end

  subscription do
    import_fields(:post_subscriptions)
    # ...other models' subscriptions
  end
end
```

### Resolvers

As I mentioned above, resolvers are the “glue” of a GraphQL server — they contain the logic to provide data for a query or apply a mutation. Let’s walk through the `post` resolver:

```elixir
# lib/socializer_web/resolvers/post_resolver.ex
defmodule SocializerWeb.Resolvers.PostResolver do
  alias Socializer.Post

  def list(_parent, _args, _resolutions) do
    {:ok, Post.all()}
  end

  def show(_parent, args, _resolutions) do
    case Post.find(args[:id]) do
      nil -> {:error, "Not found"}
      post -> {:ok, post}
    end
  end

  # ...
end
```

The first two methods handle the two queries defined above — for loading all of the posts and loading a specific post. Absinthe expects every resolver method to return a tuple — either `{:ok, requested_data}` or `{:error, some_error}` (this is a common pattern for Elixir methods in general). The `case` statement in the `show` method is a nice example of pattern-matching in Elixir — if the `Post.find` returns `nil`, we return the error tuple; if anything else, we return the found post.

```elixir
# lib/socializer_web/resolvers/post_resolver.ex
defmodule SocializerWeb.Resolvers.PostResolver do
  # ...

  def create(_parent, args, %{
        context: %{current_user: current_user}
      }) do
    args
    |> Map.put(:user_id, current_user.id)
    |> Post.create()
    |> case do
      {:ok, post} ->
        {:ok, post}

      {:error, changeset} ->
        {:error, extract_error_msg(changeset)}
    end
  end

  def create(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  # ...
end
```

Next, we have the `create` resolver, which contains the logic for creating a new post. This is also a good example of pattern-matching via method parameters — Elixir allows you to overload a method name and will select the first implementation that matches the declared pattern. In this case, if the third parameter is a map with a `context` key, containing a map with a `current_user` key, then the first method is used; if the query did not come with an authentication token, it will fall through to the second method and return an error.

```elixir
# lib/socializer_web/resolvers/post_resolver.ex
defmodule SocializerWeb.Resolvers.PostResolver do
  # ...

  defp extract_error_msg(changeset) do
    changeset.errors
    |> Enum.map(fn {field, {error, _details}} ->
      [
        field: field,
        message: String.capitalize(error)
      ]
    end)
  end
end
```

Finally, we have a simple helper method for returning an error response if the post attributes are invalid (e.g. if the body is blank). Absinthe wants error messages to be a string, an array of strings, or an array of keyword lists with `field` and `message` keys — in our case, we extract the Ecto validation errors on each field into such a keyword list.

### Context/authentication

I alluded in the last section to the concept of a query being authenticated — in my case, denoted simply with a `Bearer: token` in the `authorization` header. How do we get from that token to the `current_user` context in the resolver? With a custom Plug that reads the header and looks up the current user. In Phoenix, a Plug is a piece of the pipeline for a request — you might have plugs that decode JSON, add CORS headers, or really any other composable part of handling a request. Our plug looks like this:

```elixir
# lib/socializer_web/context.ex
defmodule SocializerWeb.Context do
  @behaviour Plug

  import Plug.Conn

  alias Socializer.{Guardian, User}

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  def build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, claim} <- Guardian.decode_and_verify(token),
         user when not is_nil(user) <- User.find(claim["sub"]) do
      %{current_user: user}
    else
      _ -> %{}
    end
  end
end
```

The first two methods are just plumbing — nothing interesting to do on initialization (in other cases, we might use the initializer to do some work based on configuration options), and when the plug is called, we just want to set the current user in the request context. The `build_context` method is where the interesting work happens. The `with` statement is another variation on pattern-matching in Elixir; it allows you to execute a series of asymmetrical steps and act on the result. In this case, we get the authorization header; then we decode the authentication token (using the [Guardian](https://github.com/ueberauth/guardian) library); then we look up the user. If all of the steps succeed then we move forward into the `with` block, simply returning a map containing the current user. If any of the steps fail (the second step might return an `{:error, ...}` tuple that fails the pattern match; the third step might return `nil` if the user doesn’t exist) then the `else` is executed, and we don’t set a current user.

---

- [Elixir, Phoenix, Absinthe, GraphQL, React, and Apollo: an absurdly deep dive - Part 1](https://github.com/xitu/gold-miner/blob/master/TODO1/elixir-phoenix-absinthe-graphql-react-apollo-absurdly-deep-dive-1.md)
- [Elixir, Phoenix, Absinthe, GraphQL, React, and Apollo: an absurdly deep dive - Part 2](https://github.com/xitu/gold-miner/blob/master/TODO1/elixir-phoenix-absinthe-graphql-react-apollo-absurdly-deep-dive-2.md)

---

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
