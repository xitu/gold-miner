> * 原文地址：[Patterns — Generic Repository with Typescript and Node.js](https://hackernoon.com/generic-repository-with-typescript-and-node-js-731c10a1b98e)
> * 原文作者：[Erick Wendel](https://medium.com/@erickwendel)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/patterns-generic-repository-with-typescript-and-node-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/patterns-generic-repository-with-typescript-and-node-js.md)
> * 译者：
> * 校对者：

# Patterns — Generic Repository with Typescript and Node.js

![Become a master of Codes](https://cdn-images-1.medium.com/max/2000/1*dffdGxirQfDyHJjWM3p47Q.png)

If you work with **Node.js/Javascript** and you have many replicated codes for different data models or create **CRUDs (Create, Read, Update and Delete**) at all times, then this post is for you!

***

### Generic Repository Pattern

Working with Javascript applications, we have some problems to share similar code between the application, and in many times we create the same code for different applications. That pattern gives to you a power to write an abstraction of data, when we have one abstract class (or many classes) and reuse the implementations independent of your Data Model, passing only your types to someone classes.

Talking about the **Repository pattern**, it is a representation where you can keep all operations of your database (like a Create, Read, Update and Delete Operations) in one local per Business Entity, when you need to do operations with Database, don’t call directly database drivers and if you have more one database, or differently databases to one transaction, you application only calls the method of repository and is transparently for who calls.

Therefore, the **Generic Repository** is similar but now you have only one abstraction, one Base Class which have all common operations and your **EntityRepository** only extends the base class with all implementations of database operations. Following the **SOLID** principles, that pattern follows the [**Open / Closed** **principle**](https://en.wikipedia.org/wiki/Open/closed_principle), when your **baseClass** is open for extension, but closed for modification.

### When to use a Generic Repository ?

Depends on your Business Model, and critical level of your applications. My opinion about this pattern it’s about the extensibility and enabling you to create only one class to write all common operations, such **CRUDs**, when all **Entities** of your application should have a **CRUD** or similar operations.

### When don’t use Generic Repository ?

The same way that you have a power, you have dangerous implicit codes, an clean example for that is:

* You have two Entity Classes: **People** and **Account.**

* Users can remove **People.**

* Users can’t update information about **Account** (like add more money to account)

* If both classes extends from **BaseClass**, that haves **update()** and **remove()** methods**,** the programmer should remember of that rule and not expose **remove** or **update** methods to service, or your business case is wrong and dangerous.

### Generics with Typescript

> Components that are capable of working on the data of today as well as the data of tomorrow will give you the most flexible capabilities for building up large software systems — [typescriptlang.org/docs/handbook/generics.html](https://www.typescriptlang.org/docs/handbook/generics.html)

Following the Typescript's documentation, generics gives the power to build flexible and generic components (or types). From their docs, we have a better example about how it works:

```js
function identity(arg: number): number {
    return arg;
}
```

So, we have a **concrete method**, which receives one number and returns the same type. If you want pass one string to this method you need to create another method with the same implementation and repeat your code.

With the **Generics** Implementation, we have the aleatory word to says what is the generic implementation (for convention, uses **T** to say that is a generic type)

```js
function identity<T>(arg: T): T {
  return arg;
}

// call
const result = identity<string>('Erick Wendel');
console.log('string is', result);

const resultNumber = identity<number>(200);
console.log('number is ', resultNumber);

/**
 * string is Erick Wendel
   number is  200
 */
 ```

### Creating a real project with Generic Repository and Node.js

Lets go! If you don’t understated yet, with the next section you’ll be able be to get the idea.

**Requirements:**

* [Node.js 8+](https://nodejs.org/en/)

* [Typescript 2.6.2+](https://www.npmjs.com/package/typescript)

* [MongoDB 3.6](https://www.mongodb.com/download-center#community)+

* [VSCode](https://code.visualstudio.com/)

**Testing your environment**

After install all environment requirements, test in your terminal if it is all ok.

```
npm --v && node --version
```

![Output of commands to view Node.js version and npm versions](https://cdn-images-1.medium.com/max/2386/1*s02l_kV76Bcl9-4MBuEBbQ.png)

To verify if your MongoDB is fine, run on another terminal tab, `sudo mongod`

![MongoDB Instance Starting](https://cdn-images-1.medium.com/max/2734/1*2VJwmyHZSC9bdCeL2paShA.png)

Then, in another tab run `mongo` to enter em your database.

![Entering em MongoDB database](https://cdn-images-1.medium.com/max/2044/1*QmpUdPued8_J4B2rfSZH_Q.png)

Then, install the global package` typescript`, to compile your typescript projects. Run `npm install -g typescript`

![Output of typescript globally package installed](https://cdn-images-1.medium.com/max/2676/1*9uiIrlCysRJdbm9Q58PKbg.png)

Once you’re done with that, we are ready to move forward :D

***

Now, we need to create one folder and initializate a **Node.js** project.

```
mkdir warriors-project
cd warriors-pŕoject
npm init -y #to init nodejs app without wizard
tsc --init  #to init config file to typescript
```

After that, should open the **vscode** within your project folder. To create our project, you need create some folders for better organization of our application. We are going to use the folder structure bellow:

```
.
├── entities 
├── package.json
├── repositories
│ ├── base 
│ └── interfaces 
└── tsconfig.json
```

Entering in `tsconfig.json` file, in the section of property `"lib": []` modify the value to `"lib": [` “es2015”`]`, we alter that property of a **json file**, to work with **es2015** modules, like **Promises** in Typescript. Alter the `outDir` property to **“outDir”: “lib”** to generate **.js** files in a separated folder.

About our folders, when `entities` folder is about your data models, `repositories` folder is about our database operations and `interfaces` our operations' contracts. Now, we should create our entities, in **entities** folder, create a `Spartan.ts` file with the following code:

```js
export class Spartan {
  private name: string;
  private kills: number;

  constructor(name: string, kills: number) {
    this.name = name;
    this.kills = kills;
  }
}
```

Now, on **repositories/interfaces** folder, we'll create two files, following the **single responsability,** undefinedthese files will have our contracts that the abstract classes must be. Our contracts, should follow the generic pattern, that can be written without a fixed type, but, when anyone implements this interfaces, should pass the type for them.

```js
export interface IWrite<T> {
  create(item: T): Promise<boolean>;
  update(id: string, item: T): Promise<boolean>;
  delete(id: string): Promise<boolean>;
}
```

```js
export interface IRead<T> {
  find(item: T): Promise<T[]>;
  findOne(id: string): Promise<T>;
}
```

After creating our interface, we should create the **BaseClass**, an abstract class that implements all generic interfaces and has our common implementation for all entities. In **base** folder, create a `BaseRepository.ts` with following code

![Creating BaseRepository with Interfaces imported](https://cdn-images-1.medium.com/max/2098/1*J1IoDdwIQAVw9_kvkfdz2g.png)

After you importing the interfaces you need to implements the signature of your interfaces, for that, you can press `ctrl .` to show options of **vscode** to show options to fix problems and click in “**Implements Interface IWrite\<T> (Fix all in file)”** undefinedto add all implementations.

![After open options and select fix all in files](https://cdn-images-1.medium.com/max/2216/1*uIRLvbJEVIK9ZxPtMdUh3Q.png)

Now we have a class similar to code bellow

```js
// import all interfaces
import { IWrite } from '../interfaces/IWrite';
import { IRead } from '../interfaces/IRead';

// that class only can be extended
export abstract class BaseRepository<T> implements IWrite<T>, IRead<T> {
    create(item: T): Promise<boolean> {
        throw new Error("Method not implemented.");
    }
    update(id: string, item: T): Promise<boolean> {
        throw new Error("Method not implemented.");
    }
    delete(id: string): Promise<boolean> {
        throw new Error("Method not implemented.");
    }
    find(item: T): Promise<T[]> {
        throw new Error("Method not implemented.");
    }
    findOne(id: string): Promise<T> {
        throw new Error("Method not implemented.");
    }
}
```

We should now create the implementations for all methods. Our **BaseRepository** class, should know how is the database and collection that you can access. At this point, you need to install the **mongodb driver package,** for that, return to your terminal on project folder and runs npm i -S mongodb @types/mongodb to add **mongodb** undefineddriver and typescript definition of package.

In **constructor,** we add two arguments, **db** and **collectionName**. Your class implementation should like a following code

```js
// import all interfaces
import { IWrite } from '../interfaces/IWrite';
import { IRead } from '../interfaces/IRead';

// we imported all types from mongodb driver, to use in code
import { MongoClient, Db, Collection, InsertOneWriteOpResult } from 'mongodb';

// that class only can be extended
export abstract class BaseRepository<T> implements IWrite<T>, IRead<T> {
  //creating a property to use your code in all instances 
  // that extends your base repository and reuse on methods of class
  public readonly _collection: Collection;

  //we created constructor with arguments to manipulate mongodb operations
  constructor(db: Db, collectionName: string) {
    this._collection = db.collection(collectionName);
  }

  // we add to method, the async keyword to manipulate the insert result
  // of method.
  async create(item: T): Promise<boolean> {
    const result: InsertOneWriteOpResult = await this._collection.insert(item);
    // after the insert operations, we returns only ok property (that haves a 1 or 0 results)
    // and we convert to boolean result (0 false, 1 true)
    return !!result.result.ok;
  }


  update(id: string, item: T): Promise<boolean> {
    throw new Error('Method not implemented.');
  }
  delete(id: string): Promise<boolean> {
    throw new Error('Method not implemented.');
  }
  find(item: T): Promise<T[]> {
    throw new Error('Method not implemented.');
  }
  findOne(id: string): Promise<T> {
    throw new Error('Method not implemented.');
  }
}
```

Now, we created the **Repository** file to specific entity in **repositories** folder**.**

```js
import { BaseRepository } from "./base/BaseRepository";
import { Spartan } from "../entities/Spartan"

// now, we have all code implementation from BaseRepository
export class SpartanRepository extends BaseRepository<Spartan>{

    // here, we can create all especific stuffs of Spartan Repository
    countOfSpartans(): Promise<number> {
        return this._collection.count({})
    }
}
```

Now, to test our repository and all logic event. We need in root of project, create a `Index.ts` file, that call all repositories.

```js
// importing mongoClient to connect at mongodb
import { MongoClient } from 'mongodb';

import { SpartanRepository } from './repositories/SpartanRepository'
import { Spartan } from './entities/Spartan';


// creating a function that execute self runs
(async () => {
    // connecting at mongoClient
    const connection = await MongoClient.connect('mongodb://localhost');
    const db = connection.db('warriors');

    // our operations
    // creating a spartan
    const spartan = new Spartan('Leonidas', 1020);

    // initializing the repository
    const repository = new SpartanRepository(db, 'spartans');

    // call create method from generic repository
    const result = await repository.create(spartan);
    console.log(`spartan inserted with ${result ? 'success' : 'fail'}`)

    //call specific method from spartan class
    const count = await repository.countOfSpartans();
    console.log(`the count of spartans is ${count}`)

    /**
     * spartan inserted with success
      the count of spartans is 1
     */
})();
```

You need to transpile your **Typescript** to **Javascript** files, running the `tsc` command from terminal, you have now in `lib` folder all `javascript files `and now, you can run your application with `node lib/Index.js.`

To you see the power of **Generic Repositories**, we go to create more one repository for `Heroes` with name `HeroesRepository.ts` and one **entity class**, that represents a **Hero**.

```js
// entities/Hero.ts

export class Hero {
    private name: string;
    private savedLifes: number;

    constructor(name: string, savedLifes: number) {
        this.name = name;
        this.savedLifes = savedLifes;
    }
}
```

```js
// repositories/HeroRepository.ts

import { BaseRepository } from "./base/BaseRepository";
import { Hero } from "../entities/Hero"

export class HeroRepository extends BaseRepository<Hero>{

}
```

Now, we just call that repository in our **Index.ts,** undefinedfollowing the complete code below.

```js
// importing mongoClient to connect at mongodb
import { MongoClient } from 'mongodb';

import { SpartanRepository } from './repositories/SpartanRepository'
import { Spartan } from './entities/Spartan';

//importing Hero classes
import { HeroRepository } from './repositories/HeroRepository'
import { Hero } from './entities/Hero';

// creating a function that execute self runs
(async () => {
    // connecting at mongoClient
    const connection = await MongoClient.connect('mongodb://localhost');
    const db = connection.db('warriors');

    // our operations
    // creating a spartan
    const spartan = new Spartan('Leonidas', 1020);

    // initializing the repository
    const repository = new SpartanRepository(db, 'spartans');

    // call create method from generic repository
    const result = await repository.create(spartan);
    console.log(`spartan inserted with ${result ? 'success' : 'fail'}`)

    //call specific method from spartan class
    const count = await repository.countOfSpartans();
    console.log(`the count of spartans is ${count}`)

    /**
     * spartan inserted with success
      the count of spartans is 1
     */

    const hero = new Hero('Spider Man', 200);
    const repositoryHero = new HeroRepository(db, 'heroes');
    const resultHero = await repositoryHero.create(hero);
    console.log(`hero inserted with ${result ? 'success' : 'fail'}`)

})();
```

### Conclusion

With one class, we have many implementations to use and to work more easily, for me, the **Generics** feature in **TypeScript** is one of most powerful features to work. All the code that you see here is available in the GitHub repo that you can find in the links section below, don’t forget to check it out :D

If you got up to this point, don’t forget to comment, share with your friends and leave some feedback. Please be mindful that this is my first English post so feel free to correct me with some private notes if you happen to spot any error :D

Don’t forget too, to click and claps on post.

![](https://cdn-images-1.medium.com/max/4000/1*rzQNDQ7ixuA3qcyydCGs5g.png)

***

### Links

[https://github.com/ErickWendel/generic-repository-nodejs-typescript-article](https://github.com/ErickWendel/generic-repository-nodejs-typescript-article)
[https://erickwendel.com.br](http://erickwendel.com.br/)
[fb.com/page.erickwendel](https://www.facebook.com/page.erickwendel)

[http://deviq.com/repository-pattern/](http://deviq.com/repository-pattern/)
[http://hannesdorfmann.com/android/evolution-of-the-repository-pattern](http://hannesdorfmann.com/android/evolution-of-the-repository-pattern)
[https://www.pluralsight.com/courses/domain-driven-design-fundamentals](https://www.pluralsight.com/courses/domain-driven-design-fundamentals)
[https://en.wikipedia.org/wiki/Open/closed_principle](https://en.wikipedia.org/wiki/Open/closed_principle)
[https://en.wikipedia.org/wiki/SOLID_(object-oriented_design)](https://en.wikipedia.org/wiki/SOLID_(object-oriented_design))
[https://medium.com/@cramirez92/s-o-l-i-d-the-first-5-priciples-of-object-oriented-design-with-javascript-790f6ac9b9fa](https://medium.com/@cramirez92/s-o-l-i-d-the-first-5-priciples-of-object-oriented-design-with-javascript-790f6ac9b9fa)
[https://www.typescriptlang.org/docs/handbook/generics.html](https://www.typescriptlang.org/docs/handbook/generics.html)

See ya 🤘

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
