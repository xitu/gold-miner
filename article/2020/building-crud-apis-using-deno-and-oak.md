> * 原文地址：[Building CRUD APIs using Deno and oak](https://medium.com/javascript-in-plain-english/building-crud-apis-using-deno-and-oak-9f71ec106b0e)
> * 原文作者：[Kailas Walldoddi](https://medium.com/@kailashwall)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/building-crud-apis-using-deno-and-oak.md](https://github.com/xitu/gold-miner/blob/master/article/2020/building-crud-apis-using-deno-and-oak.md)
> * 译者：
> * 校对者：

# Building CRUD APIs using Deno and oak

![Building CRUD api’s using Deno and oak](https://cdn-images-1.medium.com/max/2420/1*7H0kXkVQGqg-pto23TY_eQ.png)

Deno is fairly new environment compared to Node. One of the first thing that a developer would want to do while learning Deno is to build CRUD api’s. Deno has several several projects which help us achieve this namely, [deno-express](https://github.com/NMathar/deno-express), [oak](https://github.com/oakserver/oak), [servest](https://github.com/keroxp/servest), [deno-drash](https://github.com/drashland/deno-drash),and [pogo](https://github.com/sholladay/pogo). In this article we will learn about building a todo list using Deno and Oak.

#### What are we building?

Oak is project that has been inspired by [Koa](https://github.com/koajs/koa), a popular Node.js HTTP middle-ware framework. We will use oak and Deno to build a small application which will deal with todos list. The api we are going to build will have following end points.

![List of API end points](https://cdn-images-1.medium.com/max/2000/1*gIltBeBAq5xdY7vpW-sFag.png)

#### How are we building it?

we need to create two files **app.ts** and **routes.ts** in our project repository. one for app and other one for serving routes.

The content of **app.ts** file is as shown in following gist file. Look at how we are importing Application module from oak in **app.ts** file. We create a new oak application at line #8. we make this app use the routes we will later define in **routes.ts** file. Now this app will run on the specified host and port given on line#5 and line #6.

```TypeScript
import { Application } from 'https://deno.land/x/oak/mod.ts';
import { router } from "./routes.ts";

const env = Deno.env.toObject()
const PORT = env.PORT || 4000
const HOST = env.HOST || '127.0.0.1'

const app = new Application()

app.use(router.routes())
app.use(router.allowedMethods())

console.log(`Listening on port ${PORT}...`)

await app.listen(`${HOST}:${PORT}`)
```

We will create an interface for Todo in **routes.ts** which will have two fields **id** and **description**. we will store todo id and todo description in these fields respectively. We also have a **todos** list with initial values to be returned for the first time.

```TypeScript
interface Todo {
    description: string
    id: number
}

let todos: Array<Todo> = [
    {
        description: 'Todo 1',
        id: 1,
    },
    {
        description: 'Todo 2',
        id: 2,
    },
]
```

We will now define functions to support the listing operation of todos, fetching specific todo by id, creation of new todo, update/delete of specific todo description by id. The code for the same can be seen in following gist file.

```TypeScript
export const getTodos = ({ response }: { response: any }) => {
    response.body = todos
}

export const getTodo = ({
    params,
    response,
}: {
    params: {
        id: string
    }
    response: any
}) => {
    const todo = todos.filter((todo) => todo.id === parseInt(params.id))
    if (todo.length) {
        response.status = 200
        response.body = todo[0]
        return
    }

    response.status = 400
    response.body = { msg: `Cannot find todo ${params.id}` }
}

export const addTodo = async ({
    request,
    response,
}: {
    request: any
    response: any
}) => {
    const body = await request.body()
    const { description, id }: { description: string; id: number } = body.value
    todos.push({
        description: description,
        id: id,
    })

    response.body = { msg: 'OK' }
    response.status = 200
}

export const updateTodo = async ({
    params,
    request,
    response,
}: {
    params: {
        id: string
    }
    request: any
    response: any
}) => {
    const temp = todos.filter((existingTodo) => existingTodo.id === parseInt(params.id))
    const body = await request.body()
    const { description }: { description: string } = body.value.description

    if (temp.length) {
        temp[0].description = description
        response.status = 200
        response.body = { msg: 'OK' }
        return
    }

    response.status = 400
    response.body = { msg: `Cannot find todo ${params.id}` }
}

export const removeTodo = ({
    params,
    response,
}: {
    params: {
        id: string
    }
    response: any
}) => {
    const lengthBefore = todos.length
    todos = todos.filter((todo) => todo.id !== parseInt(params.id))

    if (todos.length === lengthBefore) {
        response.status = 400
        response.body = { msg: `Cannot find todo ${params.id}` }
        return
    }

    response.body = { msg: 'OK' }
    response.status = 200
}

export const getHome = ({ response }: { response: any }) => {
    response.body = 'Deno API server is running...'
    response.status = 200
}
```

We have created and exported routes to consume these functions as following.

```TypeScript
import { Router } from 'https://deno.land/x/oak/mod.ts'

export const router = new Router()
router
    .get('/', getHome)
    .get('/todos', getTodos)
    .get('/todos/:id', getTodo)
    .post('/todos', addTodo)
    .put('/todos/:id', updateTodo)
    .delete('/todos/:id', removeTodo)
```

Run the following command to get the app running on [http://localhost:4000,](http://localhost:4000,)

> **deno run — allow-env — allow-net app.ts**

Now that the app is running on localhost:4000, use postman or similar apps for testing the api endpoints. Following are screenshot of the results in postman.

![Health Check API respone](https://cdn-images-1.medium.com/max/2814/1*t3M9YRG9BL6SLkZ8c8rk9w.png)

![listing todos API response.](https://cdn-images-1.medium.com/max/2804/1*BwcwEPsx0T6vAy6gszbrMg.png)

![Get todo by Id API response.](https://cdn-images-1.medium.com/max/2802/1*0UiAn2iZGa7n0qIo2EVOxQ.png)

![POST operation to create a new todo.](https://cdn-images-1.medium.com/max/2804/1*B9YVhBQl56uuUx7y7Y4UHw.png)

![DELETE operation to delete todo by Id.](https://cdn-images-1.medium.com/max/2820/1*9gQDicmapSbarTQsNgCcnA.png)

**If you simple want to clone the code, I used in this article and see how it is working. you can checkout the code from GitHub using following link.**

**Source-Code link :**[ https://github.com/Kailashw/deno-api-oak](https://github.com/Kailashw/deno-api-oak)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
