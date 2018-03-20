> * 原文地址：[Powering PHP With JanusGraph](https://compose.com/articles/powering-php-with-janusgraph/)
> * 原文作者：[Don Omondi](https://compose.com/articles/powering-php-with-janusgraph/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/powering-php-with-janusgraph.md](https://github.com/xitu/gold-miner/blob/master/TODO/powering-php-with-janusgraph.md)
> * 译者：
> * 校对者：

# Powering PHP With JanusGraph

_With JanusGraph's increasing popularity, it's no surprise that developers have been building tools around it. In this Compose [Write Stuff](https://compose.com/write-stuff) article, Don Omondi, Founder and CTO of Campus Discounts, talks about his new PHP library for JanusGraph and how to get started using it._

PHP, in the world of programming languages, needs no introduction. First appearing in 1995, PHP has gone on to be the backbone of many unicorns most notably Facebook but even recent ones like Slack. As of September 2017 [W3Techs](https://w3techs.com/technologies/overview/programming_language/all) reports that PHP is used by 82.8% of all the websites whose server-side programming language is known - enough said!

JanusGraph, in the world of databases, is a new player but with a deep heritage since it builds on a fork of the Titan graph database, a previous leader in open source graph databases. To give you some background about graph databases take a look at [Introduction to Graph Databases](https://www.compose.com/articles/introduction-to-graph-databases/). Despite its young age, JanusGraph is already being used in production by one well-known unicorn – Uber.

So the big question is, how can one build a unicorn from PHP and JanusGraph? Believe me when I say, I really wish I knew the answer to that! However, if the question is how can one power PHP using JanusGraph? I do know at least one way.

### Introducing the Gremlin-OGM PHP Library

The [Gremlin-OGM](https://github.com/the-don-himself/gremlin-ogm) PHP Library is an Object Graph Mapper for Tinkerpop 3+ compatible Graph Databases (JanusGraph, Neo4j, etc.) that allows you to persist data and run gremlin queries.

The [library is available on Packagist](https://packagist.org/packages/the-don-himself/gremlin-ogm) and is a breeze to install using Composer.

```
composer require the-don-himself/gremlin-ogm  
```

Using the library is also a breeze because of its heavy use of PHP annotations. But before we get into how to use it, let’s dive into some of the problems we might encounter when working with a Graph Database like JanusGraph and how the library helps you avoid them.

### Some Things to Watch Out For

First off, all properties with the same name must be of the same data type. If you already have data in a different database like MySQL or MongoDB that you want to put in JanusGraph, then you’ll probably encounter this.

A good example is a field called `id` in each entity or document. Some IDs may be of an integer data type (1, 2, 3, etc.), others of a string (e.g. a FAQs collection with ids `en_1`, `es_1`, `fr_1`), and others with a MongoDB UUID (e.g `59be8696540bbb198c0065c4`). Using the same property name with different data types will throw exceptions. The Gremlin-OGM library will find such conflicts and reject the schema. As a workaround, I recommend combining the label with the word `id`; for example, a user’s identifier becomes `users_id`. The library comes with a serializer that allows you to map fields to virtual properties to avoid this conflict.

Secondly, property names, edge labels and vertex labels must all be unique within the graph. For example, it might be tempting to have a Vertex labeled `tweets` referring to the object and then create an Edge labeled `tweets` referring to the user action, or perhaps create a property `tweets` in the `users` Vertex referring to the number of tweets made by a user. The library will similarly find such conflicts and reject the schema.

Third, for both performance and schema validity, I’d recommend ensuring each element, or at the very least each Vertex contains a single unique property on which a unique Composite Index (also known as a Key index) will be created. This ensures all elements will be unique and will boost performance because adding an edge between vertexes would first require querying if they exist first. The library allows you to tag a property with the `@Id` annotation for this purpose.

Lastly, indexes. They deserve a whole book… or two. In JanusGraph, basically what you index are properties (it is a property graph after all), but the same property name can be used across different vertexes and edges. Be very careful when doing this. Please remember the first thing to watch out for above. So, for example, an index on the property `total_comments` will, by default, span across all vertexes and edges. Querying for vertexes where `total_comments` is greater than say `5` would bring back a mix of `users` who have `total_comments > 5`, blog posts with `total_comments > 5`, and any other vertex that satisfies that query. Things can get messier when, months later, you add a `recipes` vertex with a `total_comments` property and now your existing queries might start to return unexpected data.

To prevent the potential downfall above, JanusGraph allows you to set a label parameter when creating an index to restrict its scope. I’d recommend this so as to keep the indexes smaller and more performant, but this means you have to give a unique name for each index. The Gremlin-OGM library finds any conflicting index names and will subsequently reject the schema if it finds any.

### How to Use Gremlin-OGM

To get started with Gremlin-OGM we’ll first need to create a directory called Graph within our source folder e.g `src/Graph`. Within this directory, we’ll need to create two different directories: one called Vertices and the other called Edges. These two directories will now hold the PHP classes that define our graph elements.

Each class within the vertices folder describes, mostly using annotations, the vertex label, associated indices, and properties. For more advanced use cases, you can also define embedded edges best suited if you use MongoDB and have a class that
holds Embedded Documents (e.g a comments collection).

Each class within the edges folder describes, also via annotations, the edge label, associated indices, and properties. Two properties in every edge class can also be tagged with annotations, one to describe the vertex to be linked from while the other describes the vertex to be linked to. It really is simple to use, but I guess nothing ever beats a good old example. So without further ado ...

### A Practical Example: Twitter

Twitter is probably one of the best natural fits for a graph database. Objects like users and tweets can form vertexes while actions such as follows, likes, tweeted and retweets can form edges. Note the edge `tweeted` is named that way so as to avoid a conflict with the vertex `tweets`. A pictorial representation of this simple schema can be visualized as shown below.

![](https://res.cloudinary.com/dyyck73ly/image/upload/v1517108900/lvd2gsstbh57ebsjikto.png)

Let’s create the respective classes in the Graph/Vertexes folder and Graph/Edges folder. The tweets class could look like this:

```
<?php  
namespace TheDonHimself\GremlinOGM\TwitterGraph\Graph\Vertices;  
use JMS\Serializer\Annotation as Serializer;  
use TheDonHimself\GremlinOGM\Annotation as Graph;  
/**
* @Serializer\ExclusionPolicy("all")
* @Graph\Vertex(
* label="tweets",
* indexes={
* @Graph\Index(
* name="byTweetsIdComposite",
* type="Composite",
* unique=true,
* label_constraint=true,
* keys={
* "tweets_id"
* }
* ),
* @Graph\Index(
* name="tweetsMixed",
* type="Mixed",
* label_constraint=true,
* keys={
* "tweets_id" : "DEFAULT",
* "text" : "TEXT",
* "retweet_count" : "DEFAULT",
* "created_at" : "DEFAULT",
* "favorited" : "DEFAULT",
* "retweeted" : "DEFAULT",
* "source" : "STRING"
* }
* )
* }
* )
*/
class Tweets  
{
 /**
 * @Serializer\Type("integer")
 * @Serializer\Expose
 * @Serializer\Groups({"Default"})
 */
 public $id;
 /**
 * @Serializer\VirtualProperty
 * @Serializer\Expose
 * @Serializer\Type("integer")
 * @Serializer\Groups({"Graph"})
 * @Serializer\SerializedName("tweets_id")
 * @Graph\Id
 * @Graph\PropertyName("tweets_id")
 * @Graph\PropertyType("Long")
 * @Graph\PropertyCardinality("SINGLE")
 */
 public function getVirtualId()
 {
 return self::getId();
 }
 /**
 * @Serializer\Type("string")
 * @Serializer\Expose
 * @Serializer\Groups({"Default", "Graph"})
 * @Graph\PropertyName("text")
 * @Graph\PropertyType("String")
 * @Graph\PropertyCardinality("SINGLE")
 */
 public $text;
 /**
 * @Serializer\Type("integer")
 * @Serializer\Expose
 * @Serializer\Groups({"Default", "Graph"})
 * @Graph\PropertyName("retweet_count")
 * @Graph\PropertyType("Integer")
 * @Graph\PropertyCardinality("SINGLE")
 */
 public $retweet_count;
 /**
 * @Serializer\Type("boolean")
 * @Serializer\Expose
 * @Serializer\Groups({"Default", "Graph"})
 * @Graph\PropertyName("favorited")
 * @Graph\PropertyType("Boolean")
 * @Graph\PropertyCardinality("SINGLE")
 */
 public $favorited;
 /**
 * @Serializer\Type("boolean")
 * @Serializer\Expose
 * @Serializer\Groups({"Default", "Graph"})
 * @Graph\PropertyName("retweeted")
 * @Graph\PropertyType("Boolean")
 * @Graph\PropertyCardinality("SINGLE")
 */
 public $retweeted;
 /**
 * @Serializer\Type("DateTime<'', '', 'D M d H:i:s P Y'>")
 * @Serializer\Expose
 * @Serializer\Groups({"Default", "Graph"})
 * @Graph\PropertyName("created_at")
 * @Graph\PropertyType("Date")
 * @Graph\PropertyCardinality("SINGLE")
 */
 public $created_at;
 /**
 * @Serializer\Type("string")
 * @Serializer\Expose
 * @Serializer\Groups({"Default", "Graph"})
 * @Graph\PropertyName("source")
 * @Graph\PropertyType("String")
 * @Graph\PropertyCardinality("SINGLE")
 */
 public $source;
 /**
 * @Serializer\Type("TheDonHimself\GremlinOGM\TwitterGraph\Graph\Vertices\Users")
 * @Serializer\Expose
 * @Serializer\Groups({"Default"})
 */
 public $user;
 /**
 * @Serializer\Type("TheDonHimself\GremlinOGM\TwitterGraph\Graph\Vertices\Tweets")
 * @Serializer\Expose
 * @Serializer\Groups({"Default"})
 */
 public $retweeted_status;
 /**
 * Get id.
 *
 * @return int
 */
 public function getId()
 {
 return $this->id;
 }
}
```

The Twitter API is very expressive, such that we can actually save much more data than what the vertex class allows. However, for this sample, we’re just interested in a few properties. The above annotations will tell the serializer to only populate those fields when deserializing the Twitter API data into the vertex class object.

A similar class is created for the `users` vertex. The complete sample code is found in the TwitterGraph folder within the library.

An example `Follows` Edge class can be created in the Graph/Edges folder that looks like this:

```
<?php  
namespace TheDonHimself\GremlinOGM\TwitterGraph\Graph\Edges;  
use JMS\Serializer\Annotation as Serializer;  
use TheDonHimself\GremlinOGM\Annotation as Graph;  
/**
* @Serializer\ExclusionPolicy("all")
* @Graph\Edge(
* label="follows",
* multiplicity="MULTI"
* )
*/
class Follows  
{
 /**
 * @Graph\AddEdgeFromVertex(
 * targetVertex="users",
 * uniquePropertyKey="users_id",
 * methodsForKeyValue={"getUserVertex1Id"}
 * )
 */
 protected $userVertex1Id;
 /**
 * @Graph\AddEdgeToVertex(
 * targetVertex="users",
 * uniquePropertyKey="users_id",
 * methodsForKeyValue={"getUserVertex2Id"}
 * )
 */
 protected $userVertex2Id;
 public function __construct($user1_vertex_id, $user2_vertex_id)
 {
 $this->userVertex1Id = $user1_vertex_id;
 $this->userVertex2Id = $user2_vertex_id;
 }
 /**
 * Get User 1 Vertex ID.
 *
 *
 * @return int
 */
 public function getUserVertex1Id()
 {
 return $this->userVertex1Id;
 }
 /**
 * Get User 2 Vertex ID.
 *
 *
 * @return int
 */
 public function getUserVertex2Id()
 {
 return $this->userVertex2Id;
 }
}
```

Similar classes are created for the `likes`, `tweeted` and `retweets` edges. Once done, we can check for the validity of our schema by running this command:

```
php bin/graph twittergraph:schema:check  
```

If exceptions are thrown, then we need to fix them first, if not, our schema is set and ready, all we need to do now is tell JanusGraph about it.

### The JanusGraph Connection

The class `TheDonHimself\GremlinOGM\GraphConnection` is responsible for initializing a graph connection. You can do so by creating a new instance and passing some connection options in an array.

```
$options = [
 'host' => 127.0.0.1,
 'port' => 8182,
 'username' => null,
 'password' => null,
 'ssl' = [
 'ssl_verify_peer' => false,
 'ssl_verify_peer_name' => false
 ],
 'graph' => 'graph',
 'timeout' => 10,
 'emptySet' => true,
 'retryAttempts' => 3,
 'vendor' = [
 'name' => _self',
 'database' => 'janusgraph',
 'version' => '0.2'
 ],
 'twitter' => [
 'consumer_key' => 'LnUQzlkWlNT4oNUh7a2rwFtwe',
 'consumer_secret' => 'WCIu0YhaOUBPq11lj8psxZYobCjXpYXHxXA6rVcqbuNDYXEoP0',
 'access_token' => '622225192-upvfXMpeb9a3FMhuid6oBiCRsiAokpNFgbVeeRxl',
 'access_token_secret' => '9M5MnJOns2AFeZbdTeSk3R81ZVjltJCXKtxUav1MgsN7Z'
 ]
];
```

The vendor array specifies vendor-specific information such as the gremlin compatible database, its version, the name of the service host (or `_self` for self-hosted) and name of the graph. This enables the library to cater for different environments and settings without the user having to worry about it. A few examples will follow.

Finally to actually create the schema, we’ll run this command.

```
php bin/graph twittergraph:schema:create  
```

This command will ask for an optional `configPath` parameter, which is the location of a yaml configuration file containing the `options` array to make the connection. The library comes with three sample configs, `janusgraph.yaml`, `janusgraphcompose.yaml` and `azure-cosmosdb.yaml` in the root folder.

The above command will recursively walk through our `TwitterGraph/Graph` directory and find all `@Graph` annotations to build a schema definition. Exceptions will be thrown if found; otherwise, it will start a Graph transaction to commit all properties, edges, and vertexes in one go or rollback on failure.

The same command will also ask whether you want to perform a `dry run`. If specified, instead of sending the commands over to a gremlin server, they’ll be dumped in a `command.groovy` file that you can inspect. For the Twitter example, these 26 lines are the commands that will be sent or dumped depending on your configuration (shown in janusgraph _self hosted).

```
mgmt = graph.openManagement()  
text = mgmt.makePropertyKey('text').dataType(String.class).cardinality(Cardinality.SINGLE).make()  
retweet_count = mgmt.makePropertyKey('retweet_count').dataType(Integer.class).cardinality(Cardinality.SINGLE).make()  
retweeted = mgmt.makePropertyKey('retweeted').dataType(Boolean.class).cardinality(Cardinality.SINGLE).make()  
created_at = mgmt.makePropertyKey('created_at').dataType(Date.class).cardinality(Cardinality.SINGLE).make()  
source = mgmt.makePropertyKey('source').dataType(String.class).cardinality(Cardinality.SINGLE).make()  
tweets_id = mgmt.makePropertyKey('tweets_id').dataType(Long.class).cardinality(Cardinality.SINGLE).make()  
name = mgmt.makePropertyKey('name').dataType(String.class).cardinality(Cardinality.SINGLE).make()  
screen_name = mgmt.makePropertyKey('screen_name').dataType(String.class).cardinality(Cardinality.SINGLE).make()  
description = mgmt.makePropertyKey('description').dataType(String.class).cardinality(Cardinality.SINGLE).make()  
followers_count = mgmt.makePropertyKey('followers_count').dataType(Integer.class).cardinality(Cardinality.SINGLE).make()  
verified = mgmt.makePropertyKey('verified').dataType(Boolean.class).cardinality(Cardinality.SINGLE).make()  
lang = mgmt.makePropertyKey('lang').dataType(String.class).cardinality(Cardinality.SINGLE).make()  
users_id = mgmt.makePropertyKey('users_id').dataType(Long.class).cardinality(Cardinality.SINGLE).make()  
tweets = mgmt.makeVertexLabel('tweets').make()  
users = mgmt.makeVertexLabel('users').make()  
follows = mgmt.makeEdgeLabel('follows').multiplicity(MULTI).make()  
likes = mgmt.makeEdgeLabel('likes').multiplicity(MULTI).make()  
retweets = mgmt.makeEdgeLabel('retweets').multiplicity(MULTI).make()  
tweeted = mgmt.makeEdgeLabel('tweeted').multiplicity(ONE2MANY).make()  
mgmt.buildIndex('byTweetsIdComposite', Vertex.class).addKey(tweets_id).unique().indexOnly(tweets).buildCompositeIndex()  
mgmt.buildIndex('tweetsMixed',Vertex.class).addKey(tweets_id).addKey(text,Mapping.TEXT.asParameter()).addKey(retweet_count).addKey(created_at).addKey(retweeted).addKey(source,Mapping.STRING.asParameter()).indexOnly(tweets).buildMixedIndex("search")  
mgmt.buildIndex('byUsersIdComposite',Vertex.class).addKey(users_id).unique().indexOnly(users).buildCompositeIndex()  
mgmt.buildIndex('byScreenNameComposite',Vertex.class).addKey(screen_name).unique().indexOnly(users).buildCompositeIndex()  
mgmt.buildIndex('usersMixed',Vertex.class).addKey(users_id).addKey(name,Mapping.TEXTSTRING.asParameter()).addKey(screen_name,Mapping.STRING.asParameter()).addKey(description,Mapping.TEXT.asParameter()).addKey(followers_count).addKey(created_at).addKey(verified).addKey(lang,Mapping.STRING.asParameter()).indexOnly(users).buildMixedIndex("search")  
mgmt.commit()  
```

So, now that we have a valid schema setup, all we need is data. The Twitter API has great documentation on how to request such data. The Gremlin-OGM library comes bundled with a _twitteroauth_ package ([abraham/twitteroauth](https://packagist.org/packages/abraham/twitteroauth_)) as well as a prepared read-only Twitter app meant for testing the library and to help you get started.

After fetching data from the API, persisting vertexes is pretty much straightforward. First, deserialize the JSON into respective Vertex class objects. So, for example, the `@TwitterDev` Twitter data retrieved via `/api/users/show` will be deserialized as shown in this `var_dump()`.

```
object(TheDonHimself\GremlinOGM\TwitterGraph\Graph\Vertices\Users)#432 (8) {  
 ["id"]=>
 int(2244994945)
 ["name"]=>
 string(10) "TwitterDev"
 ["screen_name"]=>
 string(10) "TwitterDev"
 ["description"]=>
 string(136) "Developer and Platform Relations @Twitter. We are developer advocates. We can't answer
all your questions, but we listen to all of them!"  
 ["followers_count"]=>
 int(429831)
 ["created_at"]=>
 object(DateTime)#445 (3) {
 ["date"]=>
 string(26) "2013-12-14 04:35:55.000000"
 ["timezone_type"]=>
 int(1)
 ["timezone"]=>
 string(6) "+00:00"
 }
 ["verified"]=>
 bool(true)
 ["lang"]=>
 string(2) "en"
}
```

The deserialized PHP objects have now begun to take shape in the respective Vertexes and Edges. However, we can only send gremlin commands as strings, so we’ll still have to serialize the objects into command strings. We’ll use a conveniently named class, `GraphSerializer` to do this. Pass the deserialized object to an instance of `GraphSerializer`, which will handle complex serialization like stripping new lines, adding slashes, converting PHP `DateTime` as well as flattening arrays like tags into a format JanusGraph expects. The `GraphSerializer` also graciously handles Geopoint and Geoshape serialization.

```
// Get Default Serializer
$serializer = SerializerBuilder::create()->build();
// Get Twitter User
$decoded_user = $connection->get(
 'users/show',
 array(
 'screen_name' => $twitter_handle,
 'include_entities' => false,
 )
);
if (404 == $connection->getLastHttpCode()) {  
 $output->writeln('Twitter User @'.$twitter_handle.' Does Not Exist');
 return;
}
// Use default serializer to convert array from Twitter API to Users Class Object handling complex
deserialization like Date Time  
$user = $serializer->fromArray($decoded_user, Users::class);
// Initiate Special Graph Serializer
$graph_serializer = new GraphSerializer();
// Use graph serializer to convert Users Class Object to array handling complex deserialization like
Geoshape  
$user_array = $graph_serializer->toArray($user);
// Use graph serializer to convert array to a gremlin command string ready to be sent over
$command = $graph_serializer->toVertex($user_array);
```

The GraphSerializer then stringifies the output into a Gremlin command. This string is then ready to be sent to the JanusGraph server. So in the example above, that becomes:

```
"g.addV(label, 'users', 'users_id', 2244994945, 'name', 'TwitterDev', 'screen_name', 'TwitterDev', 'description', 'Developer and Platform Relations @Twitter. We are developer advocates. We can\'t answer all your questions, but we listen to all of them!', 'followers_count', 429831, 'created_at', 1386995755000, 'verified', true, 'lang', 'en')"
```

Persisting edges is just a tiny bit less straightforward because it requires the vertexes to exist beforehand. Therefore, the library needs to know the property key-value pair to look them up on. Furthermore, edges have direction and multiplicity within a graph database. Therefore, the vertexes that the edge is to be added to and from is very important.

This is the purpose of the `@Graph\AddEdgeFromVertex` and `@Graph\AddEdgeToVertex` property annotations within an Edge Class. They both extend a `@Graph\AddEdge` annotation to indicate the target vertex class as well as the property key and an array of methods needed to get the value.

Assuming we already queried the Twitter API for tweets, which gratefully includes an embedded field called `user` that holds the data of the tweeter. If `users_id: 5` created `tweets_id: 7` the serialized gremlin command would look like this:

```
if (g.V().hasLabel('users').has('users_id',5).hasNext() == true  
   && g.V().hasLabel('tweets').has('tweets_id',7).hasNext() == true) 
     { 
       g.V().hasLabel('users').has('users_id',5).next().addEdge('tweeted', 
         g.V().hasLabel('tweets').has('tweets_id',7).next()) 
     }
```

So, two vertex queries then a transaction to create an edge between the two from `users` to `tweets`. Note the multiplicity is `ONE2MANY` since one user can tweet many times, but each tweet can only have exactly one owner.

If the edge class had properties like `tweeted_on` or `tweeted_from`, the library would serialize them appropriately just as in the case of vertexes.

### Querying JanusGraph

So we’ve handled fetching and persisting data. Data querying is also something the library helps accomplish. The class `TheDonHimself\Traversal\TraversalBuilder` offers a near perfect match to gremlin’s native API. For example, fetching a user in TwitterGraph can be achieved as follows.

```
$user_id = 12345;
$traversalBuilder = new TraversalBuilder();
$command = $traversalBuilder
 ->g()
 ->V()
 ->hasLabel("'users'")
 ->has("'users_id'", "$user_id")
 ->getTraversal();
```

A slightly more complex example of fetching a user’s timeline can be achieved as follows.

```
$command = $traversalBuilder
 ->g()
 ->V()
 ->hasLabel("'users'")
 ->has("'screen_name'", "'$screen_name'")
 ->union(
 (new TraversalBuilder())->out("'tweeted'")->getTraversal(),
 (new TraversalBuilder())->out("'follows'")->out("'tweeted'")->getTraversal()
 )
 ->order()
 ->by("'created_at'", 'decr')
 ->limit(10)
 ->getTraversal();
```

The full list of supported steps can be found in the class `\TheDonHimself\Traversal\Step`.

### GraphQL to Gremlin

There is a [separate attempt](https://github.com/The-Don-Himself/graphql2gremlin) to create a sort of standard to support GraphQL to Gremlin commands. It’s in its very early stages and only supports queries and not mutations. Since it’s written by me as well, the Gremlin-OGM library comes with support for this standard which will hopefully improve with time.

### Visualizing JanusGraph

Sadly, there are not as many Graph Database GUIs as their counterparts for Relational, Document and Key-Value Databases. There is [Gephi](https://gephi.org/), which can be used to visualize JanusGraph data and queries via a streaming plugin. Compose, meanwhile, has a data browser for JanusGraph, which I was able to use to visualize some queries from the TwitterGraph.

**_Visualize 5 users I follow_**

```
def graph = ConfiguredGraphFactory.open("twitter");  
def g = graph.traversal();  
g.V().hasLabel('users').has('screen_name',  
   textRegex('(i)the_don_himself')).outE('follows').limit(5).inV().path()
```

![](https://res.cloudinary.com/dyyck73ly/image/upload/v1518101970/ayytldgnf3dkgsfdee1p.png)

**_Visualize 5 Users Who Follow Me_**

```
def graph = ConfiguredGraphFactory.open("twitter");  
def g = graph.traversal();  
g.V().hasLabel('users').has('screen_name',  
    textRegex('(i)the_don_himself')).inE('follows').limit(5).outV().path()
```

![](https://res.cloudinary.com/dyyck73ly/image/upload/v1518101893/n0j7ww7h8qxs1hcif8xc.png)

**_Visualize 5 Tweets I’ve Liked_**

```
def graph = ConfiguredGraphFactory.open("twitter");  
def g = graph.traversal();  
g.V().hasLabel('users').has('screen_name',  
    textRegex('(?i)the_don_himself')).outE('likes').limit(5).inV().path()
```

![](https://res.cloudinary.com/dyyck73ly/image/upload/v1518101950/lfnrx0ybr5d8bzkji1wb.png)

**_Visualize Any 5 retweets and their original tweet_**

```
def graph = ConfiguredGraphFactory.open("twitter");  
def g = graph.traversal();  
g.V().hasLabel('tweets').outE('retweets').inV().limit(5).path()  
```

![](https://res.cloudinary.com/dyyck73ly/image/upload/v1518101928/upna6igufcbyf4o0y3dr.png)

So there you have it. A powerful and thoughtful yet simple library to help you get started with JanusGraph and PHP in a matter of minutes. If you use the awesome Symfony framework you’re in even better luck. An upcoming bundle, the [Gremlin-OGM-Bundle](https://github.com/the-don-himself/gremlin-ogm-bundle) will help you replicate your data from an RDBMS or MongoDB into a Tinkerpop 3+ compatible graph database. Enjoy!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
