> * 原文地址：[Building an SQL Database Audit System Using Kafka, MongoDB and Maxwell's Daemon](https://www.infoq.com/articles/database-audit-system-kafka/)
> * 原文作者：[About the Author](https://www.infoq.com/articles/database-audit-system-kafka/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/Building-an-SQL-Database-Audit-System-Using-Kafka,-MongoDB-and-Maxwell's-Daemon.md](https://github.com/xitu/gold-miner/blob/master/article/2021/Building-an-SQL-Database-Audit-System-Using-Kafka,-MongoDB-and-Maxwell's-Daemon.md)
> * 译者：
> * 校对者：

# Building an SQL Database Audit System Using Kafka, MongoDB and Maxwell's Daemon

### Key Takeaways

*   Audit logging systems have a lot more use cases than just storing data for audit purposes. Apart from compliance and security purposes, it can be used by marketing teams to target users or it can also be used for generating critical alerts.
*   Database built-in audit logging capabilities may not be enough and definitely not an ideal way to handle all the use cases. 
*   There are many open source tools, e.g [Maxwell’s Daemons](https://maxwells-daemon.io/), [Debezium](https://debezium.io/), to support these needs and with minimum infrastructure and time requirements. 
*   Maxwell’s daemons can read SQL bin logs and send the events to various producers such as [Kafka](https://kafka.apache.org/), [Amazon Kinesis](https://aws.amazon.com/kinesis/), [SQS](https://aws.amazon.com/sqs/), [Rabbit MQ](https://www.rabbitmq.com/).
*   The bin log generated from SQL dbs must be in ROW based format for the whole setup to work

Ok! So, you use a relational database to maintain your transactional data and you need to store the audit trail of certain data present in a few tables. If you are like most of the developers you would end up doing one of the following:

### 1. Use the database audit logging capabilities

Most of the databases provide plugins to support audit logging. These plugins can be installed and easily configured to log data. However, it suffers from the below problems:

*   A full-fledged audit logging plugin is generally available only with the Enterprise edition. Community editions may lack these plugins. For example in the case of MySQL, an [audit logging plugin](https://dev.mysql.com/doc/refman/5.7/en/audit-log.html) is only available for the enterprise edition. It is worth mentioning that users of the community edition of MySQL can still install other audit logging plugins from MariaDB or Percona to get around this limitation.
*   Audit logging at the DB level causes 10-20% overhead on the database server as discussed [here](http://blog.symedia.pl/2016/10/performance-impact-general-slow-query-log.html) and [here](https://www.percona.com/blog/2009/02/10/impact-of-logging-on-mysql%E2%80%99s-performance). Generally, you may want to enable audit logging only for slow queries and not all the queries for a highly loaded system.
*   Audit logs are written in a log file and the data isn’t easily searchable. For data analysis and auditing purposes, you want your audit data to be in a searchable format.
*   Large audit archives consume critical database storage as it is stored on the same server as your DB.

### 2. Use your application to take care of audit logging

You may do one of the below to achieve it:

**a.** Before you update the existing data, copy the existing data to a different table, and then update the data in the current table.

**b.** Add a version number to the data and then every update will be an insert with an increased version number.

**c.** Write in two DB tables, one will contain the latest data and the other will contain the audit trail.

As a principle of designing scalable systems, you must always avoid multiple writes of the same data as it will not only decrease the application’s performance but also create all sorts of data out of sync issues.

Why do companies need audit data?
---------------------------------

Before we proceed with the architecture of the audit logging system, let’s look at a few points on the needs of the audit log system in various organizations.

*   Compliance and auditing: Auditors need the data in a meaningful and contextual manner from their perspective. DB audit logs are suitable for DBA teams but not for auditors.
*   The ability to generate critical alerts in case of a security breach are basic requirements of any large scale software. Audit logs can be used for this purpose.
*   You must be able to answer a variety of questions such as who accessed the data, what was the earlier state of the data, what was modified when it was updated, and are the internal users abusing their privileges, etc.
*   It’s important to note that since audit trails help identify infiltrators, they promote deterrence among "insiders." People who know their actions are scrutinized are less likely to access unauthorized databases or tamper with specific data.
*   All kinds of industries - from finance and energy to foodservice and public works - need to analyze data access and produce detailed reports regularly to various government agencies. Consider the Health Insurance Portability and Accountability Act (HIPAA) regulations. HIPAA requires that healthcare providers deliver audit trails about anyone and everyone who touches any data in their records. This is down to the row and record. The new European Union General Data Protection Regulation (GDPR) has similar requirements. The Sarbanes-Oxley Act (SOX), for example, places a wide range of accounting regulations on public corporations. These organizations need to analyze data access and produce detailed reports regularly.

In this article, I am going to present a scalable solution for managing audit trail data using technologies like Maxwell’s Daemon and Kafka.

Problem Statement
-----------------

Build an auditing system that is independent of the application and data model. The system must be scalable and cost-effective.

Architecture
------------

_Important Note: This system will work only when you are using a MySQL DB with [binlog logging format](https://dev.mysql.com/doc/refman/5.7/en/binary-log-formats.html) that is ROW based._

Before we discuss the solution architecture in detail, let’s take a quick look at each of the technologies discussed in this article.

### Maxwell’s Daemon

[Maxwell’s Daemon](https://maxwells-daemon.io/) (MD) is an open-source project from [Zendesk](https://www.zendesk.com/) that reads MySQL binlogs and writes ROW updates as JSON to Kafka, Kinesis, or other streaming platforms. Maxwell has low operational overhead, requiring nothing but MySQL and a place to write as explained [here](https://maxwells-daemon.io/). In short, MD is a tool for Change-Data-Capture (CDC).

There are quite a few variants of CDC available in the market such as Debezium from Redhat, Netflix’s DBLog, and LinkedIn’s Brooklyn. This setup can be achieved from any of these tools. However, Netflix’s DBLog and LinkedIn’s Brooklyn are developed for fulfilling different use cases as explained on the links above. Debezium however, is quite similar to MD and can be used to replace MD in our architecture. I have briefly highlighted the things to consider before choosing MD or Debezium.

*   Debezium can write data only in Kafka - at least that is the primary producer it supports. On the other hand, MD supports a variety of producers including Kafka. The list of producers MD supports is Kafka, [Kinesis](https://aws.amazon.com/kinesis/), [Google Cloud Pub/Sub](https://cloud.google.com/pubsub/docs/overview), [SQS](https://aws.amazon.com/sqs/), [Rabbit MQ](https://www.rabbitmq.com/), and Redis.
*   MD provides options to write your own producer and configure with it. Details can be found [here](https://maxwells-daemon.io/producers/).
*   The advantage of Debezium is that it can read Change Data from multiple sources such as [MySQL](https://www.mysql.com/), [MongoDB](https://www.mongodb.com/), [PostgreSQL](https://www.postgresql.org/), [SQL Server](https://www.microsoft.com/en-in/sql-server/), [Cassandra](http://cassandra.apache.org/), [DB2](https://www.ibm.com/in-en/products/db2-database), and [Oracle](https://www.oracle.com/index.html). They are quite active in adding new data sources. On the other hand, MD supports only the MySQL data source as of now.

### Kafka

[Apache Kafka](https://kafka.apache.org/) is an open-source distributed event streaming platform used for high-performance data pipelines, streaming analytics, data integration, and mission-critical applications.

### MongoDB

[MongoDB](https://www.mongodb.com/) is a general-purpose, document-based, distributed database built for modern application developers and the cloud era. We are using MongoDB for explanation purposes only. You can choose any other option such as [S3](https://aws.amazon.com/s3/) or any other time-series databases like [InfluxDB](https://www.influxdata.com/) or [Cassandra](http://cassandra.apache.org/).

The graphic below shows the data flow diagram for the audit trail solution.

![](https://res.infoq.com/articles/database-audit-system-kafka/en/resources/1Figure-1-Data-flow-diagram-1609154417022.jpg)

**Figure 1. Data flow diagram**

Here are the steps involved in the audit trail management system.

1.  Your application performs the DB writes, updates, or deletes.
2.  SQL DB will generate bin logs for that operation in ROW format. This is an SQL DB configuration.
3.  Maxwell’s Daemon polls the SQL bin log, reads the new entry, and writes it to Kafka Topics.
4.  The consumer apps will poll the Kafka Topic to read the data and process it.
5.  The consumers will write the processed data to a new data store.

Setup
-----

We’ll use Docker containers wherever possible for easy setup. If you don’t have docker installed on your machine, consider installing [Docker Desktop](https://www.docker.com/products/docker-desktop).

### MySQL DB

1.    Run a mysql server locally. The below command will start a mysql container on port 3307.

```
docker run -p 3307:3306 -p 33061:33060 --name=mysql83 -d mysql/mysql-server:latest

```

2.    If this is a fresh installation and you don’t know the root password, run the below command to print the password on the console.

```
docker logs mysql83 2>&1 | grep GENERATED

```

3.    Login to the container and change the password if required.

```
docker exec -it mysql83 mysql -uroot -p
alter user 'root'@'localhost' IDENTIFIED BY 'abcd1234'

```

4.    For security reasons, the mysql docker container isn’t allowed to connect from outside applications by default. We need to run the below commands to change it.

```
update mysql.user set host = '%' where user='root';

```

5.    Quit from the mysql prompt and restart the docker container.

```
docker container restart mysql83

```

6.    Log back into the mysql client and run the below commands to create a user for maxwell’s daemon. For details about this step, please refer to [Maxwell’s Daemon Quick Start](https://maxwells-daemon.io/quickstart/)

```
docker exec -it mysql83 mysql -uroot -p
set global binlog_format=ROW;
set global binlog_row_image=FULL;
CREATE USER 'maxwell'@'%' IDENTIFIED BY 'pmaxwell';
GRANT ALL ON maxwell.* TO 'maxwell'@'%';
GRANT SELECT, REPLICATION CLIENT, REPLICATION SLAVE ON *.* TO 'maxwell'@'%';
CREATE USER 'maxwell'@'localhost' IDENTIFIED BY 'pmaxwell';
GRANT ALL ON maxwell.* TO 'maxwell'@'localhost';
GRANT SELECT, REPLICATION CLIENT, REPLICATION SLAVE ON *.* TO 'maxwell'@'localhost';

```

### Kafka broker

Setting up Kafka is a straightforward task. Download Kafka from [this link](https://www.apache.org/dyn/closer.cgi?path=/kafka/2.6.0/kafka_2.13-2.6.0.tgz).

Run the following commands:

To extract Kafka

```
tar -xzf kafka_2.13-2.6.0.tgz
cd kafka_2.13-2.6.0

```

Start Zookeeper which is currently required to use Kafka

```
bin/zookeeper-server-start.sh config/zookeeper.properties

```

On a separate terminal Start Kafka

```
bin/kafka-server-start.sh config/server.properties

```

On a separate terminal create a topic

```
bin/kafka-topics.sh --create --topic maxwell-events --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1

```

The above commands should start the Kafka broker and create a topic "**maxwell-events**" in it.

To publish a message to the Kafka topic, run the below command in a new terminal

```
bin/kafka-console-producer.sh --topic maxwell-events --broker-list localhost:9092

```

The above command will give you a prompt where you can type your message and press enter to send the message to Kafka.

Consume the message from your Kafka topic

```
bin/kafka-console-producer.sh --topic quickstart-events --broker-list localhost:9092

```

### Maxwell’s Daemon

Download the maxwell’s daemon [from here](https://maxwells-daemon.io/quickstart/#download).  
Untar it and run the following command.

```
bin/maxwell --user=maxwell   --password=pmaxwell --host=localhost --port=3307  --producer=kafka     --kafka.bootstrap.servers=localhost:9092 --kafka_topic=maxwell-events

```

This will set up the Maxwell to monitor the bin log of the database setup discussed earlier. You can of course monitor only a few DB’s or few tables in a database. For more information, refer to [Maxwell’s Daemon Configuration](https://maxwells-daemon.io/bootstrapping/) documentation.

### Testing your setup

To test whether or not the setup works correctly, connect to MySQL, and insert some data in a table.

```
docker exec -it mysql83 mysql -uroot -p

CREATE DATABASE maxwelltest;

USE maxwelltest;

CREATE TABLE Persons (
    PersonId int NOT NULL AUTO_INCREMENT,
    LastName varchar(255),
    FirstName varchar(255),
    City varchar(255),
    primary key (PersonId)

);

INSERT INTO Persons (LastName, FirstName, City) VALUES ('Erichsen', 'Tom',  'Stavanger');

```

Now on a separate terminal, run the below command:

```
bin/kafka-console-consumer.sh --topic maxwell-events --from-beginning --bootstrap-server localhost:9092

```

You should see something like this on your terminal:

```
{"database":"maxwelltest","table":"Persons","type":"insert","ts":1602904030,"xid":17358,"commit":true,"data":{"PersonId":1,"LastName":"Erichsen","FirstName":"Tom","City":"Stavanger"}}

```

As you can see, Maxwell’s Daemon captured the DB insert event and wrote a JSON string to Kafka topic providing the details of the event.

### Setting up MongoDB

To run MongoDB locally, run the following command:

```
docker run --name mongolocal -p 27017:27017 mongo:latest

```

### Kafka Consumer

The Kafka-consumer code is available at the [github project](https://github.com/vishalsinha27/kmaxwell). Download the code and refer to the README section on how to run it.

### Final Testing

Finally, the setup is complete. Login to MySQL DB and run any insert, delete, or update commands. If your setup works correctly, you will see an entry in the mongodb auditlog database. Happy auditing!

Conclusions
-----------

The system described in this article works well in the live deployment and provides us an additional data source for user data but of course, there are some trade-offs that you must be aware of before adopting this architecture.

1.  Infrastructure costs - An additional infrastructure is required to run this setup. The data is transferred at multiple hops from your database to Kafka to another DB and then possibly to a backup. This will add up in your infrastructure cost.
2.  As the data travels multiple hops, the audit logs can’t be maintained in real-time. It will be delayed by a few seconds to some minutes. We can also argue "who needs the audit logs in real-time?" But you must consider it if you are planning to use this data for real-time monitoring.
3.  In this architecture, we are capturing the changes in the data but not who changed the data. If you are interested in also knowing which database user changed the data then this design won’t work out of the box.

Having highlighted some of the trade-offs of this architecture, I would like to end this article by reiterating the benefits of this setup. The main benefits are:

*   This setup reduces the database performance overhead of audit logging and also fulfills the need for additional data sources for marketing and alerting purposes.
*   It is easy to do the setup and robust - Any issue in any of the components in the setup won’t result in loss of data. For e.g., if the MD fails, the data will remain in the bin log file and the next time when the daemon comes up, it can read from where it left off. If the Kafka broker fails, the MD will detect it and stop reading from the binlog. If the Kafka consumer crashes, the data will remain in the Kafka broker. So, in the worst case, the audit logs will be delayed but there would be no data loss.
*   The setup is straightforward and doesn’t consume a lot of development bandwidth.

About the Author
----------------

**![][img-1]Vishal Sinha** is a passionate technologist with expertise and interest in distributed computing and large scalable systems. He works as Director of technology at a leading Indian unicorn. Over his career of 16+ years in the software industry, he has worked in multiple MNCs and startups, developed various large scale systems, and led a team of many software engineers. He enjoys solving complex problems and experimenting with new technologies.

[img-0]:data:text/html;base64,PCFET0NUWVBFIEhUTUwgUFVCTElDICItLy9JRVRGLy9EVEQgSFRNTCAyLjAvL0VOIj4KPGh0bWw+PGhlYWQ+Cjx0aXRsZT40MDQgTm90IEZvdW5kPC90aXRsZT4KPC9oZWFkPjxib2R5Pgo8aDE+Tm90IEZvdW5kPC9oMT4KPHA+VGhlIHJlcXVlc3RlZCBVUkwgL2FydGljbGVzL2RhdGFiYXNlLWF1ZGl0LXN5c3RlbS1rYWZrYS9hcnRpY2xlcy9kYXRhYmFzZS1hdWRpdC1zeXN0ZW0ta2Fma2EvZW4vcmVzb3VyY2VzLzFGaWd1cmUtMS1EYXRhLWZsb3ctZGlhZ3JhbS0xNjA5MTU0NDE3MDIyLmpwZyB3YXMgbm90IGZvdW5kIG9uIHRoaXMgc2VydmVyLjwvcD4KPGhyPgo8YWRkcmVzcz5BcGFjaGUvMi4yLjE1IChSZWQgSGF0KSBTZXJ2ZXIgYXQgd3d3LmluZm9xLmNvbSBQb3J0IDgwPC9hZGRyZXNzPgo8L2JvZHk+PC9odG1sPgo=

[img-1]:data:text/html;base64,PCFET0NUWVBFIEhUTUwgUFVCTElDICItLy9JRVRGLy9EVEQgSFRNTCAyLjAvL0VOIj4KPGh0bWw+PGhlYWQ+Cjx0aXRsZT40MDQgTm90IEZvdW5kPC90aXRsZT4KPC9oZWFkPjxib2R5Pgo8aDE+Tm90IEZvdW5kPC9oMT4KPHA+VGhlIHJlcXVlc3RlZCBVUkwgL2FydGljbGVzL2RhdGFiYXNlLWF1ZGl0LXN5c3RlbS1rYWZrYS9hcnRpY2xlcy9kYXRhYmFzZS1hdWRpdC1zeXN0ZW0ta2Fma2EvZW4vcmVzb3VyY2VzLzFWaXNoYWwtU2luaGEtMTYwOTE1NDQxNzczNi5qcGcgd2FzIG5vdCBmb3VuZCBvbiB0aGlzIHNlcnZlci48L3A+Cjxocj4KPGFkZHJlc3M+QXBhY2hlLzIuMi4xNSAoUmVkIEhhdCkgU2VydmVyIGF0IHd3dy5pbmZvcS5jb20gUG9ydCA4MDwvYWRkcmVzcz4KPC9ib2R5PjwvaHRtbD4K
