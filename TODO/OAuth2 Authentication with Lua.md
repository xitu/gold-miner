* 原文链接 : [OAuth2 Authentication with Lua](http://lua.space/webdev/oauth2-authentication-with-lua)
* 原文作者 : [Israel Sotomayor](https://github.com/zot24)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [认领地址](https://github.com/xitu/gold-miner/issues/117)
* 校对者: [CoderBOBO]
* 状态 : 认领中

Just to clarify, this won't be a detailed technical guide about how you can build your own authentication layer using [OpenResty](https://openresty.org) + [Lua](http://www.lua.org), rather it is a document explaining the process behind the solution.
在此说明该教程将不提供详细的技术指导，教您如何使用 [OpenResty](https://openresty.org) + [Lua](http://www.lua.org) 构建自己的认证层，而是讲解一下解决方案背后的处理过程。

This is a real example of how [moltin](https://moltin.com)'s API has come to rely on [OpenResty](https://openresty.org) + [Lua](http://www.lua.org) to handle our oauth2 authentication for all users.
这是一个真实的案例：[moltin](https://moltin.com)'s API 如何依赖 [OpenResty](https://openresty.org) + [Lua](http://www.lua.org) 来为所有的用户处理 oauth2 身份认证

The logic used to authenticate a user was originally embedded into [moltin](https://moltin.com)'s API, built using the PHP Framework [Laravel](https://laravel.com/). This means a lot of code had to be booted before we could authenticate, reject or validate a user request resulting in a high latency.
用于验证用户的方法最初是被在运用在PHP框架Laravel所搭建的moltin 相关的API当中。这就意味着在认证身份、驳回请求或验证消息从而导致高度延时的用户请求之前需启动大量的代码。

I'm not going to give details about how much time a PHP Framework could take to give a basic response, but if we compare it to other languages/frameworks, you can probably understand.
我不会详细地去介绍一个PHP框架需要花多长时间才能给出一个基本响应，但如果我们将它和其他语言/框架进行比较，也许你就可以理解相关的差异。

This is roughly how it looked at that time:
以下是它所呈现的大致情景：

    ...
    public function filter($route, $request) {
        try {
            // Initiate the Request handler
            $this->request = new OAuthRequest;
            // Initiate the auth server with the models
            $this->server  = new OAuthResource(new OAuthSession);
            // Is it a valid token?   
            if ($this->accessTokenValid() == false) {
                throw new InvalidAccessTokenException('Unable to validate access token');
            }
    ...

So we decided to move all logic one layer up to [OpenResty](https://openresty.org) + [Lua](http://www.lua.org) which achieved the following:
那么，我们决定将所有逻辑提升一层至OpenResty+Lua，便能实现如下几点：

*   Decoupled responsibilities from our Monolitic API.
*   解除与Monolitic API之间的耦合关系。
*   Improved authentication times and generated access/refresh tokens.
*   改进认证次数和生成的访问/刷新令牌。
*   Improved times for rejecting invalid access tokens or authentication credentials.
*   改进拒绝非法访问令牌和身份验证证书的次数。
*   Improved times when validating an access token and redirecting the request to the API.
*   改进身份验证访问令牌时的次数和重定向后再次向API发送请求的次数。

We wanted, and needed, to have more control on each request before hitting the actual API and so we decided to use something fast enough to allow us to pre-process each request and flexible enough to be integrated into our actual system. Doing this led us to use `OpenResty`, a modified version of [Nginx](https://www.nginx.com/), that allowed us to use [Lua](http://www.lua.org), the language used to pre-process those requests. Why? Because it's robust and fast enough to use for these purposes and it's a highly recognised scripting language used daily by many large companies.
我们希望并需要在请求API之前，让每个请求拥有更多的控制权限，因此我们决定采用速度足够快的工具，使我们能对每个请求进行预处理，并可以十分灵活地将它们集成到我们的实际系统中。这样做的结果就是，我们就可以使用OpenResty（即Nginx修改后的版本），并且也能使用Lua脚本（即用于预先处理这些请求的语言）。原因是什么呢？因为它强大而且速度足够快，并能够解决这些问题，lua是许多大公司每天都在使用的一种受到高度认可的脚本语言。

We followed the concept behind [Kong](https://github.com/Mashape/kong), who use [OpenResty](https://openresty.org) + [Lua](http://www.lua.org), to offer several micro-services that could be plugged into your API project. However we found that Kong is in a very early stage and is actually trying to offer more than what we needed therefore we decided to implement our own Auth layer to allow us to have more control over it.
我们跟随Kong背后的思想使用OpenResty+ Lua脚本，kong提供了一些可插入到你的API项目中的微服务。然而，我们发现Kong仍处于一个非常初期的阶段，实际上kong正在试图提供更多我们需要的东西。因此，我们决定实现自己的验证层，使我们对它有更多的控制权。
### Infrastructure
### 基础架构

Below is how [moltin](https://moltin.com)'s infrastructure currently looks:
moltin的基础架构

![](https://moltin.com/files/large/67b084c60b6d0ff)

*   OpenResty (Nginx)
*   Lua scripts
*   Caching Layer (Redis)

#### OpenResty

This is the bit that rules them all.
这是一些配置的规则

![](https://moltin.com/files/large/8b359a7b2bad55a)

We have routing in place to process each of the different user's requests as you can see below:
我们在合适的地方设置路径，用于处理不同用户的请求，你可以看到如下情况：
**nginx.conf**

    location ~/oauth/access_token {
        ...
    }
    location /v1 {
        ...
    }

So for each of those endpoints we have to:

*   check the authentication access token
*   get the authentication access token

    ...
    location ~/oauth/access_token {
        content_by_lua_file "/opt/openresty/nginx/conf/oauth/get_oauth_access.lua";
        ...
    }

    location /v1 {
        access_by_lua_file "/opt/openresty/nginx/conf/oauth/check_oauth_access.lua";
       ...
    }
    ...

We make use of the OpenResty directives [content_by_lua_file](https://github.com/openresty/lua-nginx-module#content_by_lua_file) and [access_by_lua_file](https://github.com/openresty/lua-nginx-module#access_by_lua_file).
我们利用OpenResty的这两条指令content_by_lua_file和access_by_lua_file

#### Lua Scripts
#### Lua 脚本

This is where all the magic happens. We have two scripts to do this:
这是个不可思议的环节。我们需要编写2个lua脚本来做到这一点：
**get_oauth_access.lua**

    ...
    ngx.req.read_body()
    args, err = ngx.req.get_post_args()

    -- If we don't get any post data fail with a bad request
    if not args then
        return api:respondBadRequest()
    end

    -- Check the grant type and pass off to the correct function
    -- Or fail with a bad request
    for key, val in pairs(args) do
        if key == "grant_type" then
            if val == "client_credentials" then
                ClientCredentials.new(args)
            elseif val == "password" then
                Password.new(args)
            elseif val == "implicit" then
                Implicit.new(args)
            elseif val == "refresh_token" then
                RefreshToken.new(args)
            else
                return api:respondForbidden()
            end
        end
    end

    return api:respondOk()
    ...

**check_oauth_access.lua**

    ...
    local authorization, err = ngx.req.get_headers()["authorization"]

    -- If we have no access token forbid the beasts
    if not authorization then
        return api:respondUnauthorized()
    end

    -- Check for the access token
    local result = oauth2.getStoredAccessToken(token)

    if result == false then
        return api:respondUnauthorized()
    end
    ...

#### Caching Layer
#### 缓存层

This is where the created access tokens are stored. We can remove, expire or refresh them as we please. We use Redis as a storage layer and we use [openresty/lua-resty-redis](https://github.com/openresty/lua-resty-redis) to connect Lua to [Redis](http://redis.io/).
在这创建并且存储访问的令牌。我们可以按照自己的意愿对其进行删除、终止或刷新。我们将Redis作为存储层，使用openresty/lua - resty-redis把Lua连接到Redis上。

### Resources
### 资源

Here are some interesting resources on Lua that we used when creating our authentication layer.
以下是我们在创建验证层时所用到的一些与Lua相关的有趣资源。
#### Lua

*   [Lua formdata type](http://blog.zot24.com/lua-formdata-type/)
*   [Lua sugar syntax double dots](http://blog.zot24.com/lua-sugar-syntax-double-dots/)
*   [How to use a classs constructor on Lua](http://blog.zot24.com/how-to-use-a-classs-constructor-on-lua/)
*   [Returning status code with OpenResty Lua](http://blog.zot24.com/returning-status-code-with-openresty-lua/)
*   [Return JSON responses when using OpenResty + Lua](http://blog.zot24.com/return-json-responses-when-using-openresty-lua/)
*   [When ngx exit using OpenResty precede it with return](http://blog.zot24.com/when-ngx-exit-using-openresty-precede-it-with-return/)
