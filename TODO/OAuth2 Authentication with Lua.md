* 原文链接 : [OAuth2 Authentication with Lua](http://lua.space/webdev/oauth2-authentication-with-lua)
* 原文作者 : [Israel Sotomayor](https://github.com/zot24)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [BOBO](https://github.com/CoderBOBO)
* 校对者: [Adam Shen](https://github.com/shenxn) [iThreeKing](https://github.com/iThreeKing)

# 使用 Lua 完成 OAuth2 的身份验证

在此说明该教程将不提供详细的技术指导，教您如何使用 [OpenResty](https://openresty.org) + [Lua](http://www.lua.org) 构建自己的认证层，而是讲解一下解决方案背后的处理过程。

这是一个真实的案例：[moltin](https://moltin.com)'s API 如何依赖 [OpenResty](https://openresty.org) + [Lua](http://www.lua.org) 来为所有的用户处理 oauth2 身份认证

用于验证用户的方法最初是被在运用在 PHP 框架 [Laravel](https://laravel.com/) 所搭建的 [moltin](https://moltin.com)  相关的 API 当中。这就意味着在认证身份、驳回请求或验证消息从而导致高度延时的用户请求之前需启动大量的代码。

我不会详细地去介绍一个PHP框架需要花多长时间才能给出一个基本响应，但如果我们将它和其他语言/框架进行比较，也许你就可以理解相关的差异。

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

那么，我们决定将所有逻辑提升一层至 [OpenResty](https://openresty.org) + [Lua](http://www.lua.org) ，便能实现如下几点：

*   解除与Monolitic API之间的耦合关系。
*   改进认证次数和生成的访问/刷新令牌。
*   改进拒绝非法访问令牌和身份验证证书的次数。
*   改进身份验证访问令牌时的次数和重定向后再次向API发送请求的次数。

我们希望并需要在请求 API 之前更好地控制每个请求，因此我们决定采用速度足够快的工具，使我们能对每个请求进行预处理，并可以十分灵活地将它们集成到我们的实际系统中。最终，我们选择了 OpenResty（一个 [Nginx](https://www.nginx.com/) 的修改版本），这使得我们可以使用 [Lua](http://www.lua.org) 来预先处理这些请求。因为 [Lua](http://www.lua.org) 强大并且速度快，足以解决这些问题，并且 [Lua](http://www.lua.org) 是许多大公司每天都在使用的一种受到高度认可的脚本语言。

我们跟随Kong背后的思想使用 [OpenResty](https://openresty.org) + [Lua](http://www.lua.org) 脚本，[Kong](https://github.com/Mashape/kong) 提供了一些可插入到你的API项目中的微服务。然而，我们发现Kong仍处于一个非常初期的阶段，实际上kong正在试图提供更多我们需要的东西。因此，我们决定实现自己的验证层，使我们对它有更多的控制权。


### 基础架构

[moltin](https://moltin.com) 当前的基础架构

![](https://moltin.com/files/large/67b084c60b6d0ff)

*   OpenResty (Nginx)
*   Lua scripts
*   Caching Layer (Redis)

#### OpenResty

这是一些配置的规则

![](https://moltin.com/files/large/8b359a7b2bad55a)

我们设置了一些路由来处理不同用户的请求，你可以看到如下情况：

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

我们利用OpenResty的这两条指令 [content_by_lua_file](https://github.com/openresty/lua-nginx-module#content_by_lua_file) 和[access_by_lua_file](https://github.com/openresty/lua-nginx-module#access_by_lua_file)。

#### Lua 脚本

这是个不可思议的环节。我们需要编写两个lua脚本来做到这一点：

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

#### 缓存层

在这创建并且存储访问的令牌。我们可以按照自己的意愿对其进行删除、终止或刷新。我们将Redis作为存储层，使用 [openresty/lua-resty-redis](https://github.com/openresty/lua-resty-redis) 把Lua连接到Redis上。

### 资源


以下是我们在创建验证层时所用到的一些与Lua相关的有趣资源。

#### Lua

*   [Lua formdata type](http://blog.zot24.com/lua-formdata-type/)
*   [Lua sugar syntax double dots](http://blog.zot24.com/lua-sugar-syntax-double-dots/)
*   [How to use a classs constructor on Lua](http://blog.zot24.com/how-to-use-a-classs-constructor-on-lua/)
*   [Returning status code with OpenResty Lua](http://blog.zot24.com/returning-status-code-with-openresty-lua/)
*   [Return JSON responses when using OpenResty + Lua](http://blog.zot24.com/return-json-responses-when-using-openresty-lua/)
*   [When ngx exit using OpenResty precede it with return](http://blog.zot24.com/when-ngx-exit-using-openresty-precede-it-with-return/)
