> When solving a problem that requires you to link a user's session data to their actual user object, Postgres comes in handy.

# **Sessions in Django**

Sessions are an important part of any HTTP-based web framework. They allow web servers to keep track of the identities of repeat HTTP clients without requiring them to re-authenticate for each request. There are several different ways to keep track of sessions. Some do not require the server to persist session data (like JSON Web Tokens), while others do.

Django, a popular Python-based web framework, ships with a default session backend that does store persistent session data. There are several storage and caching options; you can elect to simply store sessions in the SQL database and look them up each time, store them in a cache like Redis or Memcached, or use both, with the caching engine set up in front of the database store. If you use one of the options that ultimately stores sessions in SQL, the `django_session` table will contain your user's sessions.

Screenshots in this post come from Arctype.

# **Session Schema**

When perusing through your application's data, you may come across a problem that requires you to link a user's session data to their actual User entry (the `auth_user` table). This happened to me recently and when I took a look at the session table's schema definition, I was surprised that the `user_id` is not stored as a column. There are important design decisions as to why this is the case, but it is inconvenient to SQL'ers like myself.

![https://dzone.com/storage/temp/14542364-1616177751108.png](https://dzone.com/storage/temp/14542364-1616177751108.png)

`session_key` is the key that clients are provided. Generally, clients making a request will include the `session_key` as part of a cookie. When the webserver receives the request, it finds `session_key` if it exists, then queries to see if the key is known. If it is, it will then look at the correlated `session_data` and retrieve metadata about the user and their session.

This is how you are able to access something like `request.user` in a Django request. The `user_id` is fetched from the decoded `session_data`, the built-in User object is populated based on the stored `user_id`, and then the User object is available for use throughout the project's views.

Some quick Googling showed me that by default session data is stored as JSON. I was already aware of Postgres' excellent JSON abilities ([if you are not, check out this blog post](https://www.arctype.com/blog/json-in-postgresql/)), so I suspected this was something we could work with within the bounds of Postgres. This was great news for someone like myself who spends a lot of time in Postgres.

# **Building the Query**

# **First Look**

![https://dzone.com/storage/temp/14542365-1616177763796.png](https://dzone.com/storage/temp/14542365-1616177763796.png)

As you can see in the first image, session_data doesn't appear to be JSON. The metadata stored as JSON is hiding behind [base64 encoding](https://en.wikipedia.org/wiki/Base64). Fortunately, we can easily base64 decode in Postgres.

# **Decoding from Base64**

![https://dzone.com/storage/temp/14542366-1616177783620.png](https://dzone.com/storage/temp/14542366-1616177783620.png)

This is hardly more readable. We need to convert binary data into text.

# **Encoding to Text**

The "encode" function in Postgres allows you to "Encode binary data into a textual representation."

![https://dzone.com/storage/temp/14542367-1616177799061.png](https://dzone.com/storage/temp/14542367-1616177799061.png)

Now, we can finally see something human-readable. Here is one of the full decoded results in text format:

```
11fcbb0d460fd406e83b60ae082991818a1321a4:{"_auth_user_hash":"39308b9542b9305fc038d28a51088905e14246a1","_auth_user_backend":"x.alternate_auth.Backend","_auth_user_id":"52135"}
```

# **Extracting JSON**

What we have here is a JSON blob prefaced by a colon and a hash of sorts. We're only interested in the JSON blob. A quick way to extract just the text past the hash and colon is to find the position of the first colon and extract all characters after it.

To accomplish this, we can utilize both the `RIGHT` function, which returns n characters at the end of a `string` and the `POSITION` function, which returns the position of a character in a string. `POSITION` will only return the position of the first instance of the string for which you are searching.

The `RIGHT` function accepts a negative index. A negative index extracts characters from the right side of the string EXCEPT the characters indicated by the negative index.

To further construct this query, we are going to break it out into 2 parts using CTEs. CTEs are helpful when you have built and selected a nontrivial column and you need to use it more than once. If we continued with only one `SELECT`, we'd have to type the `encode(decode(session_data, 'base64'), 'escape')` part multiple times. This is messy and if you decide to change how you wanted to parse the encoded data, you'd have to change the function calls in 2 places.

Here is our updated query which extracts the JSON part.

![https://dzone.com/storage/temp/14542369-1616177940789.png](https://dzone.com/storage/temp/14542369-1616177940789.png)

Full result example:

```
{"_auth_user_hash":"396db3c0f4ba3d35b350a","_auth_user_backend":"x.alternate_auth.Backend","_auth_user_id":"52646"}
```

# **JSON Validation**

Now that the column is parsable as JSON we can continue. However, if you try to cast text to JSON in Postgres when the text is not valid JSON, Postgres will throw an error and stop your query. In my database, some of the sessions were not parseable JSON. Here's a way to quickly make sure the text looks like parseable JSON.

```sql
where
    substring(decoded, position(':' in decoded) + 1, 1) = '{'

    and right(decoded, 1) = '}'`
```

Any string that does not begin and end with curly braces will be filtered out.

This does not guarantee it will be able to parse, but for my database of several million sessions, it did the job. You could write a custom Postgres function to verify JSON parsability, but it would be slower.

# **JSON Casting**

With a `WHERE` clause to exclude invalid session metadata, it's time to cast our string to Postgres' JSON type and extract the `_auth_user_id` key from the JSON. Depending on your Django configuration, this key could be different. Once an object is cast to JSON type, you can query a JSON value by key using the `object->'key'` syntax.

![https://dzone.com/storage/temp/14544372-1616178066113.png](https://dzone.com/storage/temp/14544372-1616178066113.png)

# **String Cleanup**

We're getting close! When casting from JSON to `text`, Postgres adds double quotes around it. Ultimately we want the user_id field to be an `int`, but Postgres will not parse a string that includes double quotes into an `int`. Even JavaScript won't allow that!

The `TRIM` function with the `BOTH` will strip the specified character from both ends of a string, leaving us with a clean string that can easily be cast into an integer.

# **Final Query**

Here is our final query after trimming the excess double quotes and casting to `int`.

![https://dzone.com/storage/temp/14544375-1616178102560.png](https://dzone.com/storage/temp/14544375-1616178102560.png)

Now, as the sample result shows, we have linked `session_key` to Django `auth_user` id.

Here is the full query in the copyable form:

```jsx
with step1 as (
  select
    session_key,
    encode(decode(session_data, 'base64'), 'escape') :: text as decoded
  from
    django_session
)
select
  session_key,
  trim(
    both '"'
    from
      (
        right(
          decoded,
          0 - position(':' in decoded)
        ) :: json -> '_auth_user_id'
      ) :: text
  ) :: int as user_id
from
  step1
where
  substring(decoded, position(':' in decoded) + 1, 1) = '{'
  and right(decoded, 1) = '}'
```

# **Using a Materialized View for Quick Querying**

If your database has a lot of users you'll notice this query is very slow. Making a materialized view will allow you to repeatedly query the result from a persistent view without re-running the SQL.

When you create the materialized view (and anytime you refresh it), the source code for the view will be run and it will be populated with rows from the result. Be sure to refresh the view when you need up-to-date data!

```sql
create materialized view mv_django_session_user as
with step1 as (
…
// To refresh:
refresh materialized view mv_django_session_user;
```

# **Summary**

Encoding and string manipulation in Postgres are a little more tedious than it would be in common languages used for web applications like Python, Ruby, or PHP, but it is very satisfying to build a view entirely in Postgres that quickly extracts the exact data you want and allows you to directly join to other tables.

The next time you need to extract data encoded by a web framework or another 3rd-party, check Postgres for the answer!
