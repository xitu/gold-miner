> * 原文地址：[RabbitMQ and SpringBoot for Real-Time Messaging](https://medium.com/codex/rabbitmq-springboot-for-real-time-messaging-e450bde4e8cc)
> * 原文作者：[Tanbir Ahmed](https://tanbir-sagar.medium.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/RabbitMQ-and-SpringBoot-for-Real-Time-Messaging.md](https://github.com/xitu/gold-miner/blob/master/article/2021/RabbitMQ-and-SpringBoot-for-Real-Time-Messaging.md)
> * 译者：
> * 校对者：

# RabbitMQ and SpringBoot for Real-Time Messaging

![](https://cdn-images-1.medium.com/max/2000/1*EYd1qBpQDCnVlyd_NxAFTQ.png)

I’ve been watching **The Expanse** for the last few months. It has space battles, warships, aliens, and lots of other cool sci-fi troops. It also shows some advanced software that allows the space stations to monitor and communicate with all of their space ships and rockets. Got me thinking — do we have the tools to build a backend for something like that today. The first thing that came to my mind — with RabbitMQ and SpringBoot.

## The Problem Scenario

We want to build a messaging system for the space station **Tyco** which monitors different parameters of its space ships and sends personal and common messages(and/or commands) to the spaceships. The ships will send a periodic update to the station. They (the ships) can also have one-to-one communication with the station.

## Use Cases

Based on the problem scenario we have three major use cases we need to implement. We are focusing on messaging, not the events triggered by the messages (Hopefully I’ll talk about that in another project)

1. The spaceships will send periodic updates to the station.
2. Each ship and the docking station will have real-time one-to-one messaging (“Instant Messaging” in terms of social networks).
3. The docking station will **broadcast a common message** to all the ships.

These use cases could be developed utilizing different **exchanges** available in RabbitMQ. Each ship and the docking station will act both as **consumer** and **producer** because of the two-way communication requirement. Follow up [here](https://www.rabbitmq.com/tutorials/amqp-concepts.html) for more details on the exchanges, queues, and routing key if you want details on these concepts. In short,
>  Exchanges send messages to a specific Queue based on the Routing-key attached to the messages. These exchanges differ in their functionality on how they use the routing key to deliver messages to the queues.

The codes are available on my [GitHub](https://github.com/iamtanbirahmed/real-time-comm). Here I’m showing codes only necessary for explaining the underlying concepts. Before starting here are the properties files for the Station and the Ships.


```yml
## application.yml for the ship's application
## have to change property values for each ship

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

## applciation.yml for the station's applciation

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

## Send periodic updates to the docking station

We will use the Direct Exchange for sending periodic updates from the spaceships to the station.

>  Direct Exchange delivers messages to the queues based on the exact match of the attached routing-key.

Each ship can use a common routing key to send updates. @EnableScheduling & @Scheduled annotation could be used to schedule a periodic task. For simplicity, we just send the parameters along with the ship’s name punctuated by a colon (:). The class ParameterFactory creates dummy parameters with random double values. Here is an example:

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

The implementation for sending messages using RabbitMQ API is fairly simple. However, to receive a message the Station needs to configure the direct exchange and bind the queue to the direct exchange with a routing key. It also needs a callback method to handle the message when it arrives at the queue. Here are the codes:

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

The received message will look like the following in the station's console.

```
> rocinante: Update at Sat Jul 31 17:35:15 CDT 2021 Parameters{x=0.9688891, y=0.82120174, z=0.6792371, fuelPercentage=0.2711178}
```

## One-to-one communication between ships and the station

**Station → Ship**: We can again use direct exchange for sending individual messages to the ships using different routing keys. Each of the ships will have its own queue and routing key. We can have any messaging pattern to determine for which ship any message is meant and attach a routing key with the message. I used a messaging pattern like the following.

```
@rocinante: Go to Mars
@razorback: Go to Ceres
@nauvoo: Go to Earth
```

![Using different routing keys to send individual messages to the ships](https://cdn-images-1.medium.com/max/2192/1*_7GMSs4GSDanzxCxoE59Og.png)

Here is the code of the Station’s application for sending individual messages to the ships. Using a CLI we can take the input in the correct format and using the **MessageHandler** class send the message to the intended ship. The code is very straightforward.

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

To receive the messages the ships need to define it’s own direct exchange, queue, and bind it with a unique routing key. The codes for the ships are almost similar to the station for receiving messages from direct exchange. Hence, only the skeleton is shown here.

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

**Ship → Station**: Each ship already has a channel of communication with the station for their regular update. We can take a shortcut here and use the same routing key for sending individual messages to the station.

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

## Broadcast a message to the spaceships

For sending a common message to all the ships at a time from the station, we can use a Fanout Exchange. Fanout exchange delivers messages to all the queues that are bound to it ignoring the routing key. The ships can bind the already existing queue they used for One-to-One messaging to a specific fanout exchange whit out any routing key and the station can just throw a message to the exchange without worrying about the routing key. In my application, I used the following messaging pattern to signal the station to broadcast the message.

```
@all: Come back to station
```

>  Fanout Exchange delivers messages to all the queues that are bound to it ignoring the routing key.

For broadcasting just needed to add a new case like the following in the **MessageHandler** class of the ship’s application:

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

The code for receiving the broadcasted message for each ship needs to add the following configurations.

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

## Summary

In this application, each of the ships and the station works both as a consumer and producer. Hence, all of them needed their own queue for keeping the messages. The station needed only one direct exchange and one queue for receiving real-time and scheduled messages. On the other hand, the ships needed two exchanges as there were two types of messages they could receive — individual and common. However, they could use only one queue to bind it to the direct and fanout exchange. The implementation is available here: [**GitHub - iamtanbirahmed/real-time-comm**](https://github.com/iamtanbirahmed/real-time-comm)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
