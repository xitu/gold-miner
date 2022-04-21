> * 原文地址：[RabbitMQ and SpringBoot for Real-Time Messaging](https://medium.com/codex/rabbitmq-springboot-for-real-time-messaging-e450bde4e8cc)
> * 原文作者：[Tanbir Ahmed](https://tanbir-sagar.medium.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/RabbitMQ-and-SpringBoot-for-Real-Time-Messaging.md](https://github.com/xitu/gold-miner/blob/master/article/2021/RabbitMQ-and-SpringBoot-for-Real-Time-Messaging.md)
> * 译者：[samyu2000](https://github.com/samyu2000)
> * 校对者：[jaredliw](https://github.com/jaredliw)、[Usualminds](https://github.com/Usualminds)

# 使用 RabbitMQ 和 SpringBoot 实现实时消息

![](https://cdn-images-1.medium.com/max/2000/1*EYd1qBpQDCnVlyd_NxAFTQ.png)

在过去的几个月里，我一直在看《苍穹浩瀚》。这部剧中有太空战、战舰、外星人和许多其他很酷的科幻部队。其中有一些先进的软件，可以让空间站对所有的宇宙飞船和火箭进行监视与通信。这让我想到：有没有类似的后端开发工具可以像它这样。我首先想到的是 RabbitMQ 和 SpringBoot。

## 场景

我们需要为空间站建立一个消息系统，它能控制宇宙飞船的各项参数，并向宇宙飞船发送各种信息和命令。飞船也会定时向空间站发送更新消息。飞船也可以跟空间站进行一对一的通信。

## 用例

基于上述场景，我们需要实现三个主要的用例。我们应当关注通信功能，而不是由消息触发的事件（希望我会在其他项目中讲述这个问题）。

1. 飞船定时向空间站发送更新消息。
2. 每艘飞船和对接站之间都将实时、一对一地进行通信。（即社交网络中的“即时消息”）
3. 对接站将向所有飞船**广播一条公共消息**。

在 RabbitMQ 中，这些用例被视为不同的**交换机**。由于需要双向通信，每艘飞船和对接站就是**消费者**和**生产者**的关系。想要了解关于交换机、队列、路由器的更多详情，可以访问[这个链接](https://www.rabbitmq.com/tutorials/amqp-concepts.html)。概括起来就是：
> 交换机向一个由路由绑定的队列发送消息。这些交换机功能各有不同，它们根据不同的路由键向队列发送消息。

在我的 [GitHub 仓库](https://github.com/iamtanbirahmed/real-time-comm)有相应的代码。在这里我只展示与讲解相关概念所必要的代码。在开始讲解前，我先展示空间站和飞船的属性的配置文件。


```yml
## 飞船程序的 applciation.yml 文件
## 必须更改每艘船的属性值

ship:
  name: rocinante
  update-freq: 1000

broker:
  exchange:
    direct:
      ship:
        name: rocinante-direct-exchange
        routing-key: __rocinante 
      station:
        name: tyco-direct-exchange 
        routing-key: __scheduled-update
    fanout:
      name: tyco-fanout-exchange
    queue:
      name: rocinante

 #.                         ---X----

## 空间站程序的 applciation.yml 文件

station:
  name: Tyco

broker:
  exchange:
    direct:
      name: tyco-direct-exchange
      routing-key: __scheduled-update
      queue:
        auto-queue: auto-queue
    fanout:
      name: tyco-fanout-exchange
```

## 定期向对接站发送最新消息

我们使用直接交换模式，定期从飞船向空间站发送消息。

>  直接交换机基于绑定的路由键，精确匹配，向相应的队列发消息。

每艘飞船都可以使用公共的路由键发送更新消息。@EnableScheduling 和 @Scheduled 注解用于设置定时任务。简单的来说，我们需要发送用冒号分割隔的参数和飞船名称。在 ParameterFactory 类中，需要创建具有随机双精度值的虚拟参数。举例如下：

```
Parameters{x=0.9688891, y=0.82120174, z=0.6792371, fuelPercentage=0.2711178}
```

![Using a single routing key to send periodic updates the station](https://cdn-images-1.medium.com/max/2252/1*Zv11CGnppABtBbU2RGOoXQ.png)

```java
@Component
@EnableScheduling
public class UpdateScheduler {

    @Value("${ship.name}")
    private String shipName;

    @Value("${broker.exchange.direct.station.name}")
    private String directExchange;

    @Value("${broker.exchange.direct.station.routing-key}")
    private String directExchangeRoutingKey;

    private Long shipUpdateFrequency;

    @Value("${ship.update-freq}")
    private void setShipUpdateFrequency(String frequency) {
        this.shipUpdateFrequency = Long.parseLong(frequency);
    }

    @Autowired
    private final RabbitTemplate rabbitTemplate;


    @SneakyThrows
    @Scheduled(fixedDelay = 1)
    public void sendUpdates() {
        String updateMessage = shipName + ": Update at " + new Date() + " " + ParameterFactory.getParameter();

        rabbitTemplate.convertAndSend(directExchange, directExchangeRoutingKey, updateMessage);
        Thread.sleep(shipUpdateFrequency);
    }

}
```

使用 RabbitMQ API 实现发送消息的功能非常简单。然而，为了接收消息，空间站需要配置直接交换机并通过路由键跟队列绑定。为了在消息到达时进行处理，它也需要定义一个回调方法。下面是相关代码：

```java
@Configuration
public class BrokerConfiguration {
    static String directExchangeQueue;
    static String directExchange;
    static String directRoutingKey;

    @Value("${broker.exchange.direct.routing-key}")
    private void setDirectRoutingKey(String routingKey) {
        BrokerConfiguration.directRoutingKey = routingKey;
    }

    @Value("${broker.exchange.direct.name}")
    private void setDirectExchange(String exchangeName) {
        BrokerConfiguration.directExchange = exchangeName;
    }

    @Value("${broker.exchange.direct.queue.auto-queue}")
    private void setQueueName(String queueName) {
        BrokerConfiguration.directExchangeQueue = queueName;
    }

    @Bean
    DirectExchange directExchange() {
        return new DirectExchange(BrokerConfiguration.directExchange);
    }

    @Bean
    Queue directExchangeQueue() {
        return new Queue(BrokerConfiguration.directExchangeQueue);
    }

    @Bean
    Binding updateQueueBinding(Queue directExchangeQueue, DirectExchange directExchange) {
        return BindingBuilder
                    .bind(directExchangeQueue)
                    .to(directExchange)
                    .with(BrokerConfiguration.directRoutingKey);
    }

}

// message listener configuration

@Configuration
public class MessageListenerConfiguration {

    @Autowired
    private final BrokerConfiguration brokerConfiguration;

    @Bean
    MessageListenerAdapter listenerAdapter(MessageHandler messageHandler) {
        return new MessageListenerAdapter(messageHandler, "receiveMessage");
    }

    @Bean
    SimpleMessageListenerContainer container(
       ConnectionFactory connectionFactory,
       MessageListenerAdapter listenerAdapter) {

       SimpleMessageListenerContainer container = new  SimpleMessageListenerContainer();
 container.setConnectionFactory(connectionFactory);
 container.setQueueNames(brokerConfiguration.directExchangeQueue);
 container.setMessageListener(listenerAdapter);
        return container;
    }
}

@Component
public class MessageHandler {

    // Callback method to handle the recived messages

    public void receiveMessage(String message) {
        System.out.println("> " + message);
    }

}
```

空间站的控制台输出接收到的消息，如下所示.

```
> rocinante: Update at Sat Jul 31 17:35:15 CDT 2021 Parameters{x=0.9688891, y=0.82120174, z=0.6792371, fuelPercentage=0.2711178}
```

## 飞船和空间站之间的一对一通信

**空间站 → 飞船**: 我们可以再次使用直接交换机，以不同的路由键向飞船发消息。每艘飞船有它自己的队列和路由键。我们可以使用任一消息模式，使任意消息都能发送至某一艘船，并在消息中附加一个路由键。我使用如下的消息模式：

```
@rocinante: Go to Mars
@razorback: Go to Ceres
@nauvoo: Go to Earth
```

![Using different routing keys to send individual messages to the ships](https://cdn-images-1.medium.com/max/2192/1*_7GMSs4GSDanzxCxoE59Og.png)

这是空间站程序的代码，它实现了向飞船发送独立消息的功能。我们可以使用 CLI 以正确的格式输入消息，并使用 **MessageHandler** 类向特定飞船发送消息。它的代码非常明了。

```java
@Configuration
public class ChatInterface implements CommandLineRunner {
    private Scanner scanner;
    private final MessageHandler messageHandler;

    public ChatInterface(MessageHandler messageHandler) {
        this.messageHandler = messageHandler;
        this.scanner = new Scanner(System.in);
    }

    @Override
    public void run(String... args) {
        System.out.println("Send message...");
        while (true) {
            String msg = scanner.nextLine();
            if(msg.contains(":")){
                messageHandler.sendMessage(msg);
            }else{
                System.out.println("Message format not correct!!");
            }

        }
    }
}

// Class to handle sending messaging to specific topic
@Component
public class MessageHandler {

    @Autowired
    private final RabbitTemplate rabbitTemplate;

    public void sendMessage(String cmd) {
      String to = cmd.split(":")[0];
      String msg = cmd.split(":")[1];
      switch(to){
        case "@rocinante":
            rabbitTemplate.convertAndSend("rocinante-direct-exchange", "__rocinante", "Station-021: "+msg);
            break;
        case "@razorback":
            rabbitTemplate.convertAndSend("razorback-direct-exchange", "__razorback", "Station-O21: "+msg);
            break;
        case "@nauvoo":
            rabbitTemplate.convertAndSend("nauvoo-direct-exchange", "__nauvoo", "Station-O21: "+msg);
            break;
        default:
            System.out.println("Message format not correct!!");
    }
  }
}
```

为了接收消息，飞船需要定义自身的交换机、队列，并将队列跟一个唯一的路由键绑定。飞船的代码几乎跟空间站从直接交换机接收消息的代码相同。所以，这里只展示基本架构。

```java
@Configuration
public class DirectExchangeConfiguration {

    private static String directExchange;

    @Value("${broker.exchange.direct.ship.name}")
    private void setDirectExchangeName(String topicExchange) {
        DirectExchangeConfiguration.directExchange = topicExchange;
    }

    @Bean
    DirectExchange directExchange() {
        return new DirectExchange(DirectExchangeConfiguration.directExchange);
    }
}

@Configuration
public class BrokerConfiguration {

    // Similar to the Ships broker configuration
}
@Configuration
public class MessageListenerConfiguration {

    // Similar to the Ships message listener configuration
}

@Component
public class MessageHandler {

    // Callback method to handle the recived messages

    public void receiveMessage(String message) {
        System.out.println("> " + message);
    }

}
```

**飞船 → 空间站**: 每艘飞船已经有一条跟空间站通信的通道。在此，我们可以走捷径，使用相同的路由键来向空间站发送单独的消息。

```java
@Configuration
public class ChatInterface implements CommandLineRunner {

    private final RabbitTemplate rabbitTemplate;
    private final Scanner scanner;

    @Value("${ship.name}")
    private String shipName;
    @Value("${broker.exchange.direct.station.name}")
    private String directExchange;
    @Value("${broker.exchange.direct.station.routing-key}")
    private String directExchangeRoutingKey;

    public ChatInterface(RabbitTemplate rabbitTemplate) {
        this.rabbitTemplate = rabbitTemplate;
        this.scanner = new Scanner(System.in);
    }

    @Override
    public void run(String... args) {
        System.out.println("Booting up: " + shipName.toUpperCase());
        System.out.println("Please enter the message..");
        while (true) {
            String msg = scanner.nextLine();
            rabbitTemplate.convertAndSend(directExchange, directExchangeRoutingKey, shipName + ": " + msg);
        }
    }
}
```

## 向所有飞船广播消息

为了在同一时间从空间站向所有船只发送一条公共的信息，我们可以使用 Fanout 交换器。Fanout 交换器将消息传递给与它绑定的所有队列，忽略路由键。飞船可以将已经存在的用于一对一消息传递的队列绑定到一个特定的 Fanout 交换器上，省去任何路由键，空间站可以直接向交换器抛出消息，而不用担心路由键。在我的应用程序中，使用了下面的消息模式，令空间站广播消息。

```
@all: Come back to station
```

>  Fanout 交换机忽略路由键，向所有绑定的队列发送消息。

在飞船程序中，如下所示，在 **MessageHandler** 添加一个实例用于实现广播：

```java
@Component
public class MessageHandler {
    
    @Autowired
    private final RabbitTemplate rabbitTemplate;

    public void sendMessage(String cmd) {
        String to = cmd.split(":")[0];
        String msg = cmd.split(":")[1];
        switch(to){
            ....

            // add a new case
            case "@all":
                rabbitTemplate.convertAndSend("tyco-fanout-exchange", "","Station: "+msg);
                break;
            default:
                System.out.println("Message format not correct!!");
        }
    }
}
```

![](https://cdn-images-1.medium.com/max/2000/1*WV0lW7LyExBHNLoY-gDBzA.png)

飞船接收广播消息的代码需要添加下面的配置。

```java
@Configuration
public class FanoutExchangeConfiguration {

    private static String fanoutExchange;

    @Value("${broker.exchange.fanout.name}")
    private void setFanoutExchange(String fanoutExchange) {
        FanoutExchangeConfiguration.fanoutExchange = fanoutExchange;
    }

    @Bean
    FanoutExchange fanoutExchange() {
        return new FanoutExchange(FanoutExchangeConfiguration.fanoutExchange);
    }
}

@Configuration
public class BrokerConfiguration {

    ...

    // add at the end of the class for binding the common queue to           the fanout exhange

    @Bean
    Binding bindingToFanoutExchange(Queue commonQueue, FanoutExchange fanoutExchange) {
        return BindingBuilder.bind(commonQueue).to(fanoutExchange);
    }
}
```

## 总结

在本应用程序中，每艘飞船和空间站都同时扮演生产者和消费者。所以，它们都需要自己的队列来保存消息。空间站只需要一个直接交换机和一个队列，用于接收实时消息和定时发送消息。另一方面，由于飞船接收的消息存在两种类型———单一的和公共的，就需要两个交换机。然而它们只能跟一个队列绑定，队列再跟直接交换机和 Fanout 交换机进行绑定。本项目的实现代码：[**GitHub - iamtanbirahmed/real-time-comm**](https://github.com/iamtanbirahmed/real-time-comm)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
