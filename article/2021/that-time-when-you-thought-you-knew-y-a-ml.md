> * 原文地址：[That time when you thought you knew Y(A)ML ❗ 😵](https://dev.to/alxizr/that-time-when-you-thought-you-knew-y-a-ml-5302)
> * 原文作者：[alxizr](https://dev.to/alxizr)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/that-time-when-you-thought-you-knew-y-a-ml.md](https://github.com/xitu/gold-miner/blob/master/article/2021/that-time-when-you-thought-you-knew-y-a-ml.md)
> * 译者：
> * 校对者：

# That time when you thought you knew Y(A)ML ❗ 😵

Thank you for joining in for this article about YAML files. We will make it today a little lightweight tutorial about YAML configurations file. We will see what it is, how we can get started with it and where we use YAML files all around but maybe missed those little nuances.

Y(A)ML is a data serialization language and it is a strict superset of JSON (javascript object notation). It is data oriented structured language used as an input format for different software applications. We can deduct that the language in the end of the day consist of **key:value** pairs. YML's goal is to be more human readable in a clean and consise manner.

We often use tools available for us by interacting with a GUI interface, but we don't realize that under the hood there is nothing more than a YAML file that is storing our personal configurations for the given task. We will take a look in a couple of examples here today along side learning the language.

With YAML we have 2 main types: **Scalar** and **Collection**. When we were young and went to high school we had our physics class and we learned that a scalar consist only of value that describes a size, this is not very far fetch with YAML as well. It means that we can have only one unique key that can hold a value and if we use that same key again in our file, we will override the original value we set earlier. For example if we want to declare a variable (key) 'NAME' to the value 'Joey' then this variable, the key itself, is unique and we can use it globally in the file.

```yaml
# key : value
NAME: Joey
```

If we are not careful and declare that variable again to a different value, for example 'Chandler' then the last instance will override the original value.

```yaml
NAME: Joey

# ...
# other
# yaml
# configurations

NAME: Chandler
# this line will be the only source of truth when the file is evaluated, thus overriding every instance of the key NAME beforehand
```

A collection is basically the same, it also consist of **key:value** pairs, but one key can hold multiple values. For example a list of names.

```yaml
# list
NAMES: ["Joey", "Chandler", "Ross", "Phoebe", "Rachel", "Monica"]
```

Another way to describe the same NAMES list or sequence is as such

```yaml
# list or sequence
NAMES:
  - "Joey"
  - "Chandler"
  - "Ross"
  - "Phoebe"
  - "Rachel"
  - "Monica"
```

A collection in YAML is described not only in the form of an array but also can be described with maps. For example if we want to describe a mailing address of a person. Let's keep it simple for now. The address consist of street name, street number, city, state, zip code. Let's see how we can convert this address to YAML, we will choose the address of a Pizza Hut somewhere in the USA.

```yaml
# yaml object
address:
  street_name: North Mathilda Avenue
  street_number: 464
  city: Sunnyvale
  state: CA
  zipcode: 94085
```

As we can see here, we have a key named 'address' which holds multiple **key:value** pairs inside of it. You need to pay attention to the indentations. When we want to group multiple **key:value** pairs under one logical container that is the parent, we must indent them with preferred 2 space characters and each new line must be aligned vertically otherwise the YAML file will throw an error when it is ready to execute.

This particular description is called a 'Map'. The map name is 'address' and it holds several pieces of data that are in the usual form of **key:value** pairs. You also can pay attention and see that the values are not only of type 'String' but can also be 'Number', either integer or float and also can be boolean. By the way, for strings the quotes are optional. We can also define a Date variable but need to pay attention that the date format must comply to the ISO 8601 standard which looks like this: 'yyyy-mm-dd hh:mm:ss:sss'.

```yaml
# dates ISO 8601
some_date: 2018-30-09
some_datetime: 2020-10-01 09:10:30
```

Since we know that YAML consists of **key:value** pairs and is a superset of JSON, we are able to describe map objects json style.

```yaml
# json style map object in YAML
person: { name: "Johnny", age: 35, single: true }
```

I would prefer not to mix these 2 styles because to be honest, Sometimes we write very large YML files that are mile long and talking from experience here, if i get something wrong it is very unpleasant to debug. The fact that you can do it doesn't mean that you need to do it.

---

So far what we talked about was the types and saw particular samples that are a bit plain. Let's see an example where we can start complexing things. In this first example we will see how we can combine maps and collections. Let's say that i want to represent a list of people and represent this list as a collection of map objects.

```yaml
people:
  # method 1 - JSON style map object
  - { name: Alex, age: 18, single: false }

    # method 2 - YAML map object
  - name: Eric
    age: 19
    single: true

    # method 3 - another YAML map object, pay attention to the line break
  - 
    name: "Sam"
    age: 22
    single: true
```

As we can see here in this example, we have declared a variable (key) named 'people' and it holds multiple objects that are of the same format. We also can see that the way we declared each map object is different and we use 3 different methods to describe the same format for a map object but they all look the same for the YAML. One point we need to mention is that we can nest as much as we need to. If the person object has a property that describes 'hobbies' for example, we can add it thus creating a list object containing a list. Let's see it in an example. I will use the previous collection as a reference.

```yaml
people:
  - name: Tamara
    age: 20
    single: true
    hobbies: [movies, sports, food]

  - name: Julia
    age: 25
    single: false
    hobbies:
      - movies
      - sports
      - food

    # pay attention to the nesting
  - 
    name: Elaine
    age: 29
    single: false
    hobbies:
      - movies
      - sports:
          - swimming
          - hiking
          - dancing
      - food
```

Thus far we covered the types and how to use them. Now we will take a look at some features YAML supports. We now will take a look at formatting. In case we have a key that should hold large amount of data such as description of the particular object there are 2 ways to format it. We will use either the chevron right '>' or the pipe '|' signs. The main difference between them is that the formatting is either preserved or not. The chevron-right '>' sign will not preserve formatting and the pipe '|' sign will preserve the formatting. The reason we use formatting is make it more readale for us as humans, YAML will render everything in one line under the hood. Let's see it in action

```yaml
# no formatting. the text is written in one line

car:
  model: Toyota
  make: 2021
  description: "Awarded Green Car Journal's 2020 Green Car of the Year®, Corolla Hybrid even comes with an enhanced Hybrid Battery Warranty that lasts for 10 years from date of first use, or 150,000 miles, whichever comes first"
```

```yaml
# chevron right '>' sign will not preserve the formatting; no need for quotes

car:
  description: ">"
    Awarded Green Car Journal's 2020 Green Car of the Year®, 
    Corolla Hybrid even comes with an enhanced Hybrid Battery Warranty that lasts for 10 years from date of first use, 
    or 150,000 miles, whichever comes first
  model: Toyota
  make: 2021
```

```yaml
# pipe '|' sign will preserve the formatting; no need for quotes

car:
  description: "|"
    Awarded Green Car Journal's 2020 Green Car of the Year®, 
    Corolla Hybrid even comes with an enhanced Hybrid Battery Warranty that lasts for 10 years from date of first use, 
    or 150,000 miles, whichever comes first
  model: Toyota
  year: 2021
```

Congratulations! You now covered all the basics to start using YML like a pro for your everyday work. We have one other topic that we need to cover and will take a look at it in just a moment. I would like to point out a small nuances beforehand.

YAML also supports other features which we did not discuss here in this article and the reason i chose not to discuss about them is because the use cases that apply for these features are very marginal when you should justify the use for them. Features like tags that are used for explicit types, tuples, setting keys not as strings, paragraphs and more. You can read more about in the official [YAML docs](https://yaml.org/).

> If you do want that i will demonstrate some examples then just let me know and i will make another short part focusing on these features.

The one big feature that YAML also has called anchors and i often see that people do not really use it because of different reasons. To be honest i don't really know what is so scary with anchors and think that the value we gain by using them is huge. Anchors enable us to duplicate configurations or content and even inherit properties across the entire file. Not only that we can replicate a piece of configuration but we can inject an override to a specific key that is already defined in the anchor, thus making it very flexible. I agree that if you have some small or basic configuration file then there is no reason to use it, but if we assume that the file will grow in its content then it does worth the extra work in setting up anchors.

The way we work with anchors is by using the '&' sign and the '\*' sign.  
The format to define an anchor is by declaring a key followed by the anchor name preceded with the '&' sign and then the value.

```yaml
mykey: &myanchor myvalue
```

You can pay attention to the fact that the key and the anchor name don't have to match. When we want to use the anchor we need to assign the anchor name preceded with the '\*' sign as a value to another key.

```yaml
anotherkey: *myanchor
```

## Example - YAML Anchors 1

```yaml
name: &actor Neo
movie_charachter: *actor # movie_charachter will hold the value Neo
```

As we can see in this simple example this is not really why or when we should use anchors. We are not looking for the simple implementations of anchors. I usually use them when i want to configure an object that has multiple properties, or **key:value** pairs that should not change across the file everywhere we need to duplicate the instance. The way that we ue anchors with complex **key:value** pairs is by using the double chevron-left '<<' signs follow by the anchor.

## Example - YAML Anchors 2

```yaml
# global car object that we want to use across
car: &base_car
  year: 2021
  make: Toyota
  model: Corolla
  color: Grey

# reuse the car object without changing anything
corolla:
  <<: *base_car

# reuse the car object and override one of the properties
runx:
  <<: *base_car
  model: runx

# reuse the car object and override several of the properties
prius:
  <<: *base_car
  model: prius
  color: Red

# reuse the car object, override property and add additional that doesn't exist in the original anchor
camry:
  <<: *base_car
  model: camry
  seats: 5
```

As we can see in this example, we declared an anchor, used it in the YAML file in different places and also customized it. Pay attention that the customization can apply to nested properties as well. Just read the part where we talked about nesting and implement it. No need to rewrite it again. Each one of the map objects will look the same as the anchor with the adjustments that we added.

---

Let's talk about where you will encounter most likely YAML file configurations in your everyday work. As developers and/or devops engineers we encounter YAML configurations all the time when we need to use Docker, specifically Docker Compose and also in our CI/CD pipelines. These 2 examples are the most common ones.

## Example - YAML Docker Compose

in this example we will take a look at a simple docker compose config file for a local development environment

```yaml
# docker compose example

# simple key:value pair
version: "3"

# complex Map object with nested map objects, each nested object represents a service in docker compose
services:
  # service Map object
  redis_sentinel:
    image: redis:alpine
    volumes:
      - sentinel_data:/data

  # service Map object
  redis_worker:
    image: redis:alpine
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - worker_data:/data

# another complex Map object with nested map objects. volumes used for persistent storage in docker. docker containers are ephemeral which means that they are not designed to run forever, especially in local dev environment and that is why we need to create a volume and bind the local host's file system into the docker container's file system
volumes:
  # service Map object
  sentinel_data:
    driver: local
  # service Map object
  worker_data:
    driver: local
```

As we can see here in the example, we have a common use case for YAML configurations file that is written in a repetitive fashion. I am sure you are confident enough to try and rewrite this YAML configurations file all by yourselves. Let's give it a try

```yaml
# docker compose example
redis_service: &base_redis
  image: redis
  volume: null

volumes:
  sentinel_data:
    driver: local
  worker_data:
    driver: local

version: "3"

services:
  sentinal:
    <<: *base_redis
    volume:
      - sentinal_data:/data

  worker:
    <<: *base_redis
    volume:
      - worker_data:/data
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
```

You can see that i didn't touch the global configurations for volumes because it is very specific to docker and usually you do not want to make it dynamic. However, we can see that the rewrite didn't make too much of a difference, but we need to remember first that this is a very basic docker compose configurations file and if you add another 'service' under 'services' you will see the impact. Also the base\_redis anchor is very light. Imagine that we had 20 properties with nested properties of their own and how would our file would look like.

## Example - YAML - CI

```yaml
# Travis ci example

language: node_js
node_js:
  - node
env:
  global:
    - PATH=$HOME/.local/bin:$PATH
before_install:
  - pyenv global 3.7.1
  - pip install -U pip
  - pip install awscli
script:
  - yarn build
  - echo "Commit sha - $TRAVIS_COMMIT"
  - mkdir -p dist/@myapp/$TRAVIS_COMMIT
  - mv dist/*.* dist/@myapp/$TRAVIS_COMMIT/
deploy:
  provider: s3
  access_key_id: "$AWS_ACCESS_KEY_ID"
  secret_access_key: "$AWS_SECRET_ACCESS_KEY"
  bucket: "my_project_bucket"
  region: "us-west-2"
  cache-control: "max-age=31536000"
  acl: "public_read"
  local_dir: dist
  skip_cleanup: true
  on:
    branch: master
after_deploy:
  - chmod +x after_deploy_script.sh
  - "./after_deploy_script.sh"
```

As you can see the configurations in this file are self explanatory and you can see that the pattern is consistent. We use **key:value** pairs and most of the configurations are complex map objects

---

And that's all folks! This is all you need to know about YAML. From now on you can and should be more confident when dealing with YAML file configurations and maybe you will have the chance to improve existing files.

> A cool tool that i sometime use to validate the YAML files i work on is [this](http://www.yamllint.com/), it check spelling and configurations so you can make sure that you didn't miss anything and in the case you did then an error will be thrown 😄

By the way, if you asked yourself what YAML stands for, it is Yet Another Markup Language. 😄😄😄

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
