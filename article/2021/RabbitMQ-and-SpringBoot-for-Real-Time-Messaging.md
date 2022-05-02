> * 原文地址：[RabbitMQ and SpringBoot for Real-Time Messaging](https://medium.com/codex/rabbitmq-springboot-for-real-time-messaging-e450bde4e8cc)
> * 原文作者：[Tanbir Ahmed](https://tanbir-sagar.medium.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/RabbitMQ-and-SpringBoot-for-Real-Time-Messaging.md](https://github.com/xitu/gold-miner/blob/master/article/2021/RabbitMQ-and-SpringBoot-for-Real-Time-Messaging.md)
> * 译者：[samyu2000](https://github.com/samyu2000)、[jaredliw](https://github.com/jaredliw)
> * 校对者：[Usualminds](https://github.com/Usualminds)、[zhangchunxing](https://github.com/zhangchunxing)

# 使用 RabbitMQ 和 SpringBoot 实现实时消息

![](https://cdn-images-1.medium.com/max/2000/1*EYd1qBpQDCnVlyd_NxAFTQ.png)

在过去的几个月里，我一直在看《苍穹浩瀚》。这部剧中包含太空战、战舰、外星人和许多其他很酷的科幻部队。剧中展示了一些先进的软件，可以让空间站对所有的宇宙飞船和火箭进行监控与通信。这让我开始思考 —— 现今我们有没有像这样的后端开发工具？我首先想到的是 RabbitMQ 和 SpringBoot。

## 问题场景

我们想为 **Tycho** 空间站建立一个消息系统，这样空间站就能监控宇宙飞船的各项参数，并向宇宙飞船发送各种信息和命令。飞船会定时向空间站发送更新消息。飞船也可以跟空间站进行一对一的通信。

## 用例

基于上述场景，我们需要实现三个主要的用例。我们应当关注通信功能，而不是由消息触发的事件（希望我会在其他项目中讲述这个问题）。

1. 飞船定时向空间站发送更新消息。
2. 每艘飞船和对接站之间都将实时、一对一地进行通信（即社交网络中的“即时消息”）。
3. 对接站将向所有飞船**广播一条公共消息**。

我们可以通过在 RabbitMQ 中设置不同的**交换机**来实现上面的用例。由于需要双向通信，所以每艘飞船和对接站都是**消费者**和**生产者**的关系。想要了解关于交换机、队列、路由键的更多详情，可以访问[这个链接](https://www.rabbitmq.com/tutorials/amqp-concepts.html)。概括起来就是：
> 通过消息上的路由键，交换机就可以将消息发送到对应的队列上。这些交换机的功能是有差异的，区别就在于怎么使用路由键来向队列传递消息。

在我的 [GitHub 仓库](https://github.com/iamtanbirahmed/real-time-comm)有相应的代码。在这里我只展示与底层概念相关的代码。以下是空间站和飞船的属性配置文件：


```yml
## 飞船程序的 application.yml 文件
## 每艘飞船的属性值都需要更改

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

## 空间站程序的 application.yml 文件

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

>  直接交换机通过对关联的路由键的精确匹配来将消息发送到队列上。

每艘飞船都可以使用公共的路由键发送更新消息。`@EnableScheduling` 和 `@Scheduled` 注解用于设置定时任务。简单来说，我们只需要发送用冒号分隔的参数和飞船名称。`ParameterFactory` 用来创建随机的双精度值的虚拟参数。举例如下：

```
Parameters{x=0.9688891, y=0.82120174, z=0.6792371, fuelPercentage=0.2711178}
```

![使用单个路由键向空间站发送定期更新](https://cdn-images-1.medium.com/max/2252/1*Zv11CGnppABtBbU2RGOoXQ.png)

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

使用 RabbitMQ API 实现发送消息的功能非常简单。然而，为了接收消息，空间站需要配置直接交换机并通过路由键与队列绑定。为了在消息到达时进行处理，它也需要定义一个回调方法。下面是相关代码：

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

// 消息监听配置
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

        SimpleMessageListenerContainer container = new SimpleMessageListenerContainer();
        container.setConnectionFactory(connectionFactory);
        container.setQueueNames(brokerConfiguration.directExchangeQueue);
        container.setMessageListener(listenerAdapter);
        return container;
    }
}

@Component
public class MessageHandler {
    // 处理接收消息的回调方法
    public void receiveMessage(String message) {
        System.out.println("> " + message);
    }
}
```

空间站的控制台输出接收到的消息，如下所示：

```
> rocinante: Update at Sat Jul 31 17:35:15 CDT 2021 Parameters{x=0.9688891, y=0.82120174, z=0.6792371, fuelPercentage=0.2711178}
```

## 飞船和空间站之间的一对一通信

**空间站 → 飞船**：我们依然使用直接交换机，通过不同的路由键向飞船发送单独的消息。每艘飞船都有自己的队列和路由键。我们可以使用任意消息模式来确定消息是发送至哪艘飞船的，并在消息中附加一个路由键。我使用如下的消息模式：

```
@rocinante: Go to Mars
@razorback: Go to Ceres
@nauvoo: Go to Earth
```

![使用不同的路由键向飞船发送单独的消息](https://cdn-images-1.medium.com/max/2192/1*_7GMSs4GSDanzxCxoE59Og.png)

这是空间站程序的代码，它实现了向飞船发送单独消息的功能。我们可以使用 CLI 以正确的格式输入消息，并使用 `MessageHandler` 类向目标飞船发送消息。它的代码非常清晰明了：

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
    public void run(String...args) {
        System.out.println("Send message...");
        while (true) {
            String msg = scanner.nextLine();
            if (msg.contains(":")) {
                messageHandler.sendMessage(msg);
            } else {
                System.out.println("Message format not correct!!");
            }

        }
    }
}

// 处理向特定主题发送消息的类
@Component
public class MessageHandler {
    @Autowired
    private final RabbitTemplate rabbitTemplate;

    public void sendMessage(String cmd) {
        String to = cmd.split(":")[0];
        String msg = cmd.split(":")[1];
        switch (to) {
        case "@rocinante":
            rabbitTemplate.convertAndSend("rocinante-direct-exchange", "__rocinante", "Station-021: " + msg);
            break;
        case "@razorback":
            rabbitTemplate.convertAndSend("razorback-direct-exchange", "__razorback", "Station-O21: " + msg);
            break;
        case "@nauvoo":
            rabbitTemplate.convertAndSend("nauvoo-direct-exchange", "__nauvoo", "Station-O21: " + msg);
            break;
        default:
            System.out.println("Message format not correct!!");
        }
    }
}
```

为了接收消息，飞船需要定义自身的交换机、队列，并将队列跟一个唯一的路由键绑定。飞船将从直接交换机接收消息，其代码和空间站的类似。因此，这里只展示基本框架。

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
    // 类似于 Ships 的代理配置
}

@Configuration
public class MessageListenerConfiguration {
    // 类似于 Ships 的消息监听器配置
}

@Component
public class MessageHandler {
    // 处理接收到的消息的回调方法
    public void receiveMessage(String message) {
        System.out.println("> " + message);
    }

}
```

**飞船 → 空间站**：每艘飞船已经有一条跟空间站通信的通道了。我们可以复用这个通道，使用相同的路由键来向空间站发送单独的消息。

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

我们希望空间站能同一时间向所有飞船发送一条公共消息。因此，我们可以通过使用扇形交换机来实现这一用例。扇形交换机会忽略路由键并将消息传递给与它绑定的所有队列。飞船可以将之前用于一对一通信的队列绑定到一个特定的扇形交换机上，而不用设置任何路由键。这样一来，空间站可以直接向该交换机抛出消息，不用考虑路由键。在我的应用程序中，使用了下面的消息格式向空间站发送信号，完成广播消息。

```
@all: Come back to station
```

>  扇形交换机将忽略路由键并向所有绑定的队列发送消息。

为了实现广播，我们只需要在空间站应用中的 `MessageHandler` 类中新增一段逻辑，如下所示：

```java
@Component
public class MessageHandler {
    @Autowired
    private final RabbitTemplate rabbitTemplate;

    public void sendMessage(String cmd) {
        String to = cmd.split(":")[0];
        String msg = cmd.split(":")[1];
        switch (to) {
            ....

            // 添加一个新的 case
            case "@all":
                rabbitTemplate.convertAndSend("tyco-fanout-exchange", "", "Station: " + msg);
            break;
        default:
            System.out.println("Message format not correct!!");
        }
    }
}
```

![](https://cdn-images-1.medium.com/max/2000/1*WV0lW7LyExBHNLoY-gDBzA.png)

飞船接收广播消息的代码需要添加如下的配置：

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

    // 将公共队列绑定到扇形交换机
    @Bean
    Binding bindingToFanoutExchange(Queue commonQueue, FanoutExchange fanoutExchange) {
        return BindingBuilder.bind(commonQueue).to(fanoutExchange);
    }
}
```

## 总结

在本应用程序中，每艘飞船和空间站都同时扮演着生产者和消费者。因此，它们都需要自己的队列来保存消息。空间站只需要一个直接交换机和一个队列，用于接收实时消息和周期消息。但是，飞船因为要接收两种类型的消息 —— 单独的和公共的，所以需要两个交换机。然而它们只使用一个队列，这个队列同时跟直接交换机和扇形交换机进行绑定。本项目的实现代码：[**GitHub - iamtanbirahmed/real-time-comm**](https://github.com/iamtanbirahmed/real-time-comm)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
