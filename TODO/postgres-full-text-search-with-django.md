> * 原文地址：[Postgres Full-Text Search With Django](http://blog.lotech.org/postgres-full-text-search-with-django.html)
> * 原文作者：[Nathan Shafer](http://blog.lotech.org/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[stein](https://github.com/steinliber)
> * 校对者：[Zheaoli](https://github.com/Zheaoli) [lovexiaov](https://github.com/lovexiaov)

# Django 基于 Postgres 的全文搜索 #

Django 在 1.10 版本已经增加了对 Postgres 内建全文检索的支持。当我们想要增加 django 的检索能力又不想去建立和维护其它服务时，相较于其它更重型的像 [elasticsearch](https://www.elastic.co/products/elasticsearch)  或者  [SOLR](http://lucene.apache.org/solr/) 搜索系统， Posgres 会是一个很好的选择。对于多数使用场景而言，Postgres 的全文搜索能力已经 [足够了](http://rachbelaid.com/postgres-full-text-search-is-good-enough/) 。

在这个简明攻略中，我将会展示如何为 Django 应用添加全文检索功能。在 Django [文档](https://docs.djangoproject.com/en/1.11/ref/contrib/postgres/search/) 中已经包含了很全面的简单的使用案例，所以我会直接关注于更加进阶的例子，这些例子将允许在不同的字段间查询，包括字段间对应关系的数据，为不同字段设置权重，添加索引来加快查询速度，以及确保查询结果是实时的方法。

不言自明，这次主要说的是 Django 和 Postgres 后端技术栈。在 SQLite 或者 MYSQL 中是不会有效的。我也认为你已经熟悉 Django 并且对 Postgres 有基本的了解。

在 [Github](https://github.com/nshafer/pgfulltext) 上有这个攻略的项目示例。

## 模型 ##

我们将使用这些模型作为例子。这是一个类似博客的应用程序的简单数据，其中包括直接包含和通过关系引用数据的 Posts 。但是最重要的是，我们有了想要通过多对一关系( author ) 和 多对多关系( tag ) 查询的数据。

```
class Author(models.Model):
    name = models.CharField(max_length=50)


class Tag(models.Model):
    name = models.CharField(max_length=20)


class Post(models.Model):
    title = models.CharField(max_length=50)
    content = models.TextField()
    author = models.ForeignKey(Author)
    tags = models.ManyToManyField(Tag)
```

我们将会使用以下数据：

```
jim = Author.objects.create(name="Jim Blogwriter")
nancy = Author.objects.create(name="Nancy Blogaday")

databases = Tag.objects.create(name="Databases")
programming = Tag.objects.create(name="Programming")
python = Tag.objects.create(name="Python")
postgres = Tag.objects.create(name="Postgres")
django = Tag.objects.create(name="Django")

django_post = Post.objects.create(
    title="Django, the western character",
    content="Django is a character who appears in a number of spaghetti "
            "western films.",
    author=jim
)
django_post.tags.add(django)

python_post = Post.objects.create(
    title="Python is a programming language",
    content="Python is a programming language created by Guido van Rossum "
            "and first released in 1991. Django is written in Python. Python "
            "can connect to databases.",
    author=nancy
)
python_post.tags.add(django, programming, python)

postgres_post = Post.objects.create(
    title="What is Postgres",
    content="PostgreSQL, commonly Postgres, is an open-source, "
            "object-relational database (ORDBMS).",
    author=nancy
)
postgres_post.tags.add(databases, postgres)
```

## 创建文档 ##

首先是为我们的 posts 创建**文档**。每一份文档在逻辑上都将代表一个 post ，包括

- title
- content
- Author's name
- All tag names

这里是 Django 查询的一个例子：

```
from django.db.models.functions import Concat
from django.db.models import TextField, Value as V
from django.contrib.postgres.aggregates import StringAgg

document=Concat(
    'title', V(' '),
    'content', V(' '),
    'author__name', V(' '),
    StringAgg('tags__name', delimiter=' '),
    output_field=TextField()
)
Post.objects.annotate(document=document).values_list('document', flat=True)
```

```
<QuerySet [
  "Django, the western character Django is a character who appears in a
    number of spaghetti western films. Jim Blogwriter Django",
  "Python is a programming language Python is a programming language
    created by Guido van Rossum and first released in 1991. Django is
    written in Python. Python can connect to databases. Nancy Blogaday
    Python Django Programming",
  "What is Postgres PostgreSQL, commonly Postgres, is an open-source,
    object-relational database (ORDBMS). Nancy Blogaday Postgres Databases"
]>
```

这包括了我们每篇文章实例的所有数据，字段数据间通过空格来分割。

## 查询向量 ##

我们已经有了我们的文档，我们需要把他们转换成 Postgres 可以索引和查询的格式。 Postgres 把这种形式叫做 [向量](https://www.postgresql.org/docs/9.6/static/textsearch-controls.html#TEXTSEARCH-PARSING-DOCUMENTS)。Django 提供了一个该功能的封装类叫做  [SearchVector](https://docs.djangoproject.com/en/1.11/ref/contrib/postgres/search/#searchvector)。一个 `SearchVector` 类也可以接受权重参数，接下来我们会重写查询语句来创建向量。

```
from django.contrib.postgres.search import SearchVector
from django.contrib.postgres.aggregates import StringAgg

vector=SearchVector('title', weight='A') + \
       SearchVector('content', weight='C') + \
       SearchVector('author__name', weight='B') + \
       SearchVector(StringAgg('tags__name', delimiter=' '), weight='B')
Post.objects.annotate(document=vector).values_list('document', flat=True)
```

```
<QuerySet [
  "'appear':10C 'blogwrit':19B 'charact':4A,8C 'django':1A,5C,20B 'film':17C
    'jim':18B 'number':13C 'spaghetti':15C 'western':3A,16C",
  "'1991':20C 'blogaday':32B 'connect':28C 'creat':11C 'databas':30C
    'django':21C,34B 'first':17C 'guido':13C 'languag':5A,10C 'nanci':31B
    'program':4A,9C,35B 'python':1A,6C,25C,26C,33B 'releas':18C
    'rossum':15C 'van':14C 'written':23C",
  "'blogaday':18B 'common':5C 'databas':15C,20B 'nanci':17B 'object':13C
    'object-rel':12C 'open':10C 'open-sourc':9C 'ordbm':16C
    'postgr':3A,6C,19B 'postgresql':4C 'relat':14C 'sourc':11C"
]>
```

每个文档都被统一到一组常用的词根。其中包括所有字母都切换到小写，去除通用的前缀和后缀（比如像英语中的 's' 和 'es'），并且移除掉像 'a'，'an' 和 'the' 这样的通用词汇。这个数据前面的数字表示词根在文档中的位置，后面的字母表示这个词根的比重。如果我们想要覆盖 Postgres 处理这些词汇的配置，比如说使用不同的语言，我们需要向查询向量传递一个额外的参数 config。如果没有声明这个配置， Postgres 将会使用数据库默认的配置，这样很可能基于其配置的 locale。

## 执行一次查询 ##

我们现在已经有了我们的文档，就可以执行一次查询啦。实现查询最简单的方式就是在我们的文档中筛选。

```
vector=SearchVector('title',weight='A')+ \
       SearchVector('content',weight='C')+ \
       SearchVector('author__name',weight='B')+ \
       SearchVector(StringAgg('tags__name',delimiter=' '),weight='B')
       Post.objects.annotate(document=vector).filter(document='django')
```

```
<QuerySet [<Post: Django, the western character>,
           <Post: Python is a programming language>]>
```

在默认情况下，django 将会使用 Postgres 的 `plainto_tsquery()`[函数](https://www.postgresql.org/docs/9.6/static/textsearch-controls.html#TEXTSEARCH-PARSING-QUERIES) 来解析这个查询。这种方式的缺点在于它将会搜索与所有单词都匹配的文档。所以，我们可以传递一个 [SearchQuery()](https://docs.djangoproject.com/en/1.11/ref/contrib/postgres/search/#searchquery) 的实例而不是字符串，这样查询条件就可以使用布尔操作符组合起来了。

```
from django.contrib.postgres.search import SearchQuery

query = SearchQuery('django') & SearchQuery('program')
Post.objects.annotate(document=vector).filter(document=query)
```

如果我们在 SearchVector() 中使用了自定义的 `config`，那么我们就应该在 SearchQuery() 中使用同样的 `config`。

## 排序 ##

考虑到我们为文档的每个部分分配了不同的权重，如果可以对返回的结果进行排序将会更有意义。Django 为此提供了 SearchRank 类。

```
from django.contrib.postgres.search import SearchVector, SearchQuery, SearchRank
from django.contrib.postgres.aggregates import StringAgg

vector=SearchVector('title', weight='A') + \
       SearchVector('content', weight='C') + \
       SearchVector('author__name', weight='B') + \
       SearchVector(StringAgg('tags__name', delimiter=' '), weight='B')
query = SearchQuery('django')
Post.objects\
    .annotate(document=vector, rank=SearchRank(vector, query))\
    .filter(document=query)\
    .order_by('-rank')\
    .values_list('title', 'rank')

```

```
<QuerySet [
  ('Django, the western character', 0.665342),
  ('Python is a programming language', 0.364756)
]>

```

这提供了我们想要的功能，但如果我们关注性能那这也许就不是最好的方式。我们每执行一次查询，数据库就要为表中的每一行构建文档，然后才能对其搜索并排序。如果查询的数据只有几行当然没什么，但在数据超过几百行之后，查询的速度将会逐渐慢到不可接受的地步。如果我们的文档只包含一个表的数据，我们可以[建立一个 GIN 索引](https://www.postgresql.org/docs/current/static/textsearch-tables.html#TEXTSEARCH-TABLES-INDEX)来解决这个问题，但如果我们需要从其它的表里获取额外的数据这样做就不行了。所以我们真正想要做的是预先计算所有的文档并将它们存储在数据库中。

# 用 SearchVectorField 来储存向量 #

Django 为我们提供了一个叫做 `SearchVectorField` 的字段来储存预先计算好的向量。我们将会把这个字段加入到我们的 Post 模型。

```
from django.contrib.postgres.search import SearchVectorField

class Post(models.Model):
    ...
    search_vector = SearchVectorField(null=True)
```

之后我们会执行 migrate 操作来添加这个字段。

```
./manage.py makemigrations
./manage.py migrate

```

让我们现在手工更新这个字段。

```
from django.contrib.postgres.search import SearchVector, SearchQuery, SearchRank
from django.contrib.postgres.aggregates import StringAgg

vector=SearchVector('title', weight='A') + \
       SearchVector('content', weight='C') + \
       SearchVector('author__name', weight='B') + \
       SearchVector(StringAgg('tags__name', delimiter=' '), weight='B')
for post in Post.objects.annotate(document=vector):
    post.search_vector = post.document
    post.save(update_fields=['search_vector'])
```

**注意：** 这将为表中的每一行触发一次UPDATE，如果我们的表有很多行，这过程将会持续很久很久。如果我们仅需要在文档中包含来自单个模型的字段，那么这么做会更有效率：

```
vector=SearchVector('title', weight='A') + \
       SearchVector('content', weight='C')
Post.objects.update(search_vector=vector)
```

Django 并不允许我们使用带有 update 子句的集合函数，但是 Postgres 允许，所以如果我们真的想那么做的话，我们可以执行一次像这样的查询来一次性更新所有文档。

```
UPDATE blog_post
SET search_vector = document.vector
FROM (
     SELECT post.id,
            setweight(to_tsvector(post.title), 'A') ||
            setweight(to_tsvector(post.content), 'C') ||
            setweight(to_tsvector(author.name), 'B') ||
            setweight(to_tsvector(COALESCE(string_agg(tag.name, ', '), '')), 'B')
              AS vector
     FROM blog_post AS post
     JOIN blog_author AS author ON author.id = post.author_id
     JOIN blog_post_tags AS post_tags ON post_tags.post_id = post.id
     JOIN blog_tag AS tag ON tag.id = post_tags.tag_id
     GROUP BY post.id, author.id
   ) AS document
WHERE blog_post.id = document.id;

```

## 通过 search_vector 查询 ##

现在我们已经储存了我们的文档，我们就可以很简单的对它们进行查询

```
from django.db.models import F
from django.contrib.postgres.search import SearchVector, SearchQuery, SearchRank

query = SearchQuery('django')
Post.objects.annotate(rank=SearchRank(F('search_vector'), query))\
    .filter(search_vector=query).order_by('-rank').values_list('title', 'rank')
```

```
<QuerySet [
  ('Django, the western character', 0.665342),
  ('Python is a programming language', 0.364756)
]>

```

## 索引 ##

现在我们的文档是储存在一个字段中的，我们可以创建一个 GIN 索引来加快查询速度。在 Django 1.11 中，这简单到只需要为我们的模型添加一个 `indexes` Meta 选项，然后创建并执行 migrate 操作。

```
from django.contrib.postgres.indexes import GinIndex

class Post(models.Model):
    title = models.CharField(max_length=50)
    content = models.TextField()
    author = models.ForeignKey(Author)
    tags = models.ManyToManyField(Tag)
    search_vector = SearchVectorField(null=True)

    class Meta:
        indexes = [
            GinIndex(fields=['search_vector'])
        ]
```

在 Django 1.10 中我们需要创建一个空的迁移并且添加上 `RunSQL` 操作。

```
migrations.RunSQL(
    "CREATE INDEX blog_post_search_vector_idx ON blog_post USING gin(search_vector)",
    "DROP INDEX blog_post_search_vector_idx"
)
```

# 更新文档 #

目前为止是非常好的，但是一旦其中的任何数据发生改变，这个文档也就过期了，搜寻结果也将变得不正确。我们能够解决这个问题的第一个方法是使用一个 cron 或计划任务来定期更新整张表（如上所述）。这对于需要处理大量更新或者大批量更新的应用是个很好的选择。这样，我们就不需要为每一次更新增加额外的开销，而且可以更有效的一次性更新全部行。

对于其它有着缓慢更新流程的应用，每次数据改变就更新数据表是更加合适的。这样做的优点是查询的数据将是实时的。这样做的缺点是每次更新都会计算 search_vector 从而增加了额外的开销。

一种妥协的方式是把 search_vector 作为异步的进程放到队列里，这样它的更新可以非常快，而且更新仍然可以批量处理。这不在本文的范围之内，但根据应用的架构，这样做应该不会很难。

最好的方式将取决于具体的应用。这里有一些简单的方法可以在每次数据更新时保存文档。

## 重写 save() ##

更新文档的其中一个方式是重写 Post 的 save() 方法。在这个方法中，每次查询依赖的数据更新了，search_vector 也会随之更新。所以查询的结果可以立即反映数据的改变。然而这会对数据库的每次更新操作增加额外的开销。

首先我们将会创建一个自定义管理器，当我们调用它时将会向查询集添加文档，这样我们可以保持代码 DRY (译者注：Don't repeat yourself)，而且把我们的搜索向量只定义在了一个地方。

```
class PostManager(models.Manager):
    def with_documents(self):
        vector = SearchVector('title', weight='A') + \
                 SearchVector('content', weight='C') + \
                 SearchVector('author__name', weight='B') + \
                 SearchVector(StringAgg('tags__name', delimiter=' '), weight='B')
        return self.get_queryset().annotate(document=vector)
```

现在更新我们的 Post 模型，添加自定义管理器和自定义 save 方法。这里的想法时将数据保存到数据库，然后执行一个 SELECT 查询来将所有的数据连接到一起，之后再创建新的 search_vector。这样每次保存都会导致一次 UPATE，SELECT 以及另一个 UPDATE 的操作。

```
from django.contrib.postgres.search import SearchVectorField, SearchVector

class Post(models.Model):
    title = models.CharField(max_length=50)
    content = models.TextField()
    author = models.ForeignKey(Author)
    tags = models.ManyToManyField(Tag)
    search_vector = SearchVectorField(null=True)

    objects = PostManager()

    def save(self, *args, **kwargs):
        super().save(*args, **kwargs)
        if 'update_fields' not in kwargs or 'search_vector' not in kwargs['update_fields']:
            instance = self._meta.default_manager.with_documents().get(pk=self.pk)
            instance.search_vector = instance.document
            instance.save(update_fields=['search_vector'])
```

另外，更新 authors 和 tags 并不会触发这个 `save()`，所以我们也为它们添加信号来强制执行 Post 模型的 `save()` 来更新 search_vector。

```
from django.db.models.signals import post_save, m2m_changed
from django.dispatch import receiver

@receiver(post_save, sender=Author)
def author_changed(sender, instance, **kwargs):
    for post in instance.post_set.with_documents():
        post.search_vector = post.document
        post.save(update_fields=['search_vector'])


@receiver(m2m_changed, sender=Post.tags.through)
def post_tags_changed(sender, instance, action, **kwargs):
    if action in ('post_add', 'post_remove', 'post_clear'):
        instance.save()
```

现在所有对 Post，Author 或添加、删除、移除 tags 的操作都会触发查询数据的更新。如果一个 tag 被重命名了，那么我们不会在没有创建另一个信号处理程序的情况下接收它。

## 使用触发器 ##

也可以为数据库安装一些当数据改变时会自动更新 search_vector 的触发器。我不会描述太多的细节，但它们看起来会像下面这样。我们可以将它们添加到一次迁移中，使用 RunSQL 命令将它们安装到数据库。这个想法与上述完全一样，但是由于数据库可以在本地执行所有操作，并且不必将数据来回发送到Django，它将执行得更好。

```
-- Trigger on insert or update of blog.Post
CREATE OR REPLACE FUNCTION post_search_vector_trigger() RETURNS trigger AS $$
BEGIN
  SELECT setweight(to_tsvector(NEW.title), 'A') ||
         setweight(to_tsvector(NEW.content), 'C') ||
         setweight(to_tsvector(author.name), 'B') ||
         setweight(to_tsvector(COALESCE(string_agg(tag.name, ', '), '')), 'B')
  INTO NEW.search_vector
  FROM blog_post AS post
  JOIN blog_author AS author ON author.id = post.author_id
  JOIN blog_post_tags AS post_tags ON post_tags.post_id = post.id
  JOIN blog_tag AS tag ON tag.id = post_tags.tag_id
  WHERE post.id = NEW.id
  GROUP BY post.id, author.id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER search_vector_update BEFORE INSERT OR UPDATE ON blog_post
  FOR EACH ROW EXECUTE PROCEDURE post_search_vector_trigger();

-- Trigger after blog.Author is update
CREATE OR REPLACE FUNCTION author_search_vector_trigger() RETURNS trigger AS $$
BEGIN
  UPDATE blog_post SET id = id WHERE author_id = NEW.id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER search_vector_update AFTER INSERT OR UPDATE ON blog_author
  FOR EACH ROW EXECUTE PROCEDURE author_search_vector_trigger();

-- Trigger after blog.Post.tags are added, update or deleted
CREATE OR REPLACE FUNCTION tags_search_vector_trigger() RETURNS trigger AS $$
BEGIN
  IF (TG_OP = 'DELETE') THEN
    UPDATE blog_post SET id = id WHERE id = OLD.post_id;
    RETURN OLD;
  ELSE
    UPDATE blog_post SET id = id WHERE id = NEW.post_id;
    RETURN NEW;
  END IF;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER search_vector_update AFTER INSERT OR UPDATE OR DELETE ON blog_post_tags
  FOR EACH ROW EXECUTE PROCEDURE tags_search_vector_trigger();。
```

# 结论 #

现在我们已经有了一个运行中的应用了，该应用使用了 Postgres 的全文搜索，一旦它运行起来，大部分就不需要你管了。相较于搭一个  [elasticsearch](https://www.elastic.co/products/elasticsearch) 或者 [SOLR](http://lucene.apache.org/solr/) (even with [Haystack](http://haystacksearch.org/))，这简直是一股清流，而且这结果对于大多数应用来说已经足够了。

想要查询更多的信息和功能，比如语言支持、自定义词根、三连词、口音等，请参见以下资源：

- [Official PostgreSQL Full-Text Search Documentation](https://www.postgresql.org/docs/9.6/static/textsearch.html)
- [Official Django Postgres Search Documentation](https://docs.djangoproject.com/en/1.11/ref/contrib/postgres/search/)
- [Postgres full-text search is Good Enough](http://rachbelaid.com/postgres-full-text-search-is-good-enough/): 关于Postgres 全文搜索基础很棒的文章。
- [An example project](https://github.com/nshafer/pgfulltext) 这个帖子所描述的例子。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
