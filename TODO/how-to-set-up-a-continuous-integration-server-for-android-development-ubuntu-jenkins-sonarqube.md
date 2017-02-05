> * 原文地址：[How to set up a Continuous Integration server for Android development (Ubuntu + Jenkins + SonarQube)](https://pamartinezandres.com/how-to-set-up-a-continuous-integration-server-for-android-development-ubuntu-jenkins-sonarqube-43c1ed6b08d3#.sylq0wmfq)
* 原文作者：[Pablo A. Martínez](https://pamartinezandres.com/@pamartineza?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# How to set up a Continuous Integration server for Android development (Ubuntu + Jenkins + SonarQube) #

I have recently acquired a new MacBook Pro as my main Android development machine and instead of selling or giving away my old Mac BookPro (13", late 2011, 16GB RAM, 500G SSD, Core i5 2,4GHz, 64Bit) I have wiped it out and turned it into a Continuous Integration Server with dual boot MacOS-Ubuntu.

The goal of this article is to summarize the installation steps for me as future reference and for any developer that may be interested in setting up its own CI server, I will explain how to:

- Configure a fresh Ubuntu installation to be able to run the Android SDK.

- Install Jenkins CI as a service to pull, compile, and run tests of an Android multi-module project hosted in GitHub.

- Install Docker to run a MySQL server and SonarQube in their own containers, to perform static code analysis triggered by Jenkins

- Android App configuration requirements.

### Step 1 — Ubuntu Installation: ###

I’m going to use Ubuntu as the SO of the CI because it has a strong community that will provide you support for any issue you may encounter and my personal recommendation is always to use the last LTS version, currently 16.04 LTS. There are plenty of tutorials about how to install it on virtually any hardware so I’m just providing the link to download it.

[Install Ubuntu Desktop 16.04 LTS](https://www.ubuntu.com/download/desktop)

You may wonder why I’m using the Desktop version instead of the pure server version, this is just a matter of personal preference, I’m not worried of losing a bit of performance and available RAM due to be running the desktop interface because I think that the usability that provides de GUI pays off enough in increased productivity.

### Step 2 — Remote access management: ###

#### **SSH-Server:** ####

Ubuntu desktop is not shipped with the ssh server installed by default, so to be able to manage your server remotely through the command line just install it:

```
$ sudo apt-get install openssh-server
```

#### **NoMachine Remote Desktop:** ####

Probably your CI is not going to be next to you but closer to your router, other room or even miles away from your current location. I have been dealing with different remote desktop solutions and I have to say that IMHO NoMachine performs the best, it is platform agnostic and works just out of the box just using your ssh credentials. (Obviously you have to install it both in your CI and your machine)

[**NoMachine - Free Remote Access For Everybody**](https://www.nomachine.com/download)


### Step 3 — Environment configuration ###

Here I’m going to install JAVA8, Git and the Android SDK that are required by Jenkins to pull, compile and run android projects.

#### **SDKMAN!:** ####

This marvelous command line tool allows you install many popular SDK (eg. Gradle, Groovy, Grails, Kotlin, Scala…), list candidates and switch among different versions in parallel in a really easy and handy way.

[**SDKMAN! the Software Development Kit Manager**](http://sdkman.io/) 

They have added recently support for JAVA8 so I preferred to install Java using it instead of using the popular webupd8 repository, so it is up to you to choose whether to install SDKMAN! or not but I’m pretty sure it is a tool that you will use in the near future.

Installation of SDKMAN! is as easy as executing the following line:

```
$ curl -s "https://get.sdkman.io" | bash
```


#### Oracle JAVA8: ####

As we have previously installed SDKMAN! now installing JAVA8 is as easy as:

```
$ sdk install java
```

Or using the webupd8 repository:

[**Install Oracle Java 8 In Ubuntu Or Linux Mint Via PPA Repository [JDK8]**](http://www.webupd8.org/2012/09/install-oracle-java-8-in-ubuntu-via-ppa.html)


#### **Git:** ####

Installing git is straight forward, no more comments needed:

```
$ sudo apt install git
```


#### **Android SDK:** ####

At the bottom of this page:

[**Download Android Studio and SDK Tools | Android Studio**](https://developer.android.com/studio/index.html)


you can find “***Get just the command line tools***”, copy the link e.g:


[https://dl.google.com/android/repository/tools_r25.2.3-linux.zip](https://dl.google.com/android/repository/tools_r25.2.3-linux.zip) 


Then download and unzip it at /opt/android-sdk-linux

```
$ cd /opt
```


$ sudo wget [https://dl.google.com/android/repository/tools_r25.2.3-linux.zip](https://dl.google.com/android/repository/tools_r25.2.3-linux.zip)


```
$ sudo unzip tools_r25.2.3-linux.zip -d android-sdk-linux
```

As we have used root user to create de directory we need to fix folder permissions to make it readable and writable by our main user:

```
$ sudo chown -R YOUR_USERNAME:YOUR_USERNAME android-sdk-linux/
```

Let’s set the SDK environmental variables editing the /.bashrc file:

```
$ cd
$ nano .bashrc
```

Then add at the bottom (but before SDKMAN! config line) these lines:

```
export ANDROID_HOME="/opt/android-sdk-linux"
export PATH="$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH"
```

Close the terminal and open a new one to verify that variables have been properly exported:

```
$ echo $ANDROID_HOME
/opt/android-sdk-linux
```

Then you can launch the Android SDK Manager GUI and install your desired platforms and dependencies

```
$ android
```

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*Q4o_LpfC5A3evFUwd62MOQ.png">

Running Android SDK Manager GUI


### Step 4 — Jenkins server: ###

Here I’m going to describe how to install the server, configure it, create a Jenkins Job to pull, build and test an Android project and how to get to the console output.

#### Jenkins installation: ####

Jenkins server is available at:

[**Jenkins**](https://jenkins.io/)

There are many ways to run **Jenkins**, executing a **.war** file, as a linux **service**, as a Docker **container**, etc….

My first thought was to run it using a Docker container but then I realized that it was a nightmare to properly configure code folders, android-sdk folder visibility and USB visibility of physical devices plug to run Android Tests.

For ease of use I finally decided to use it as service adding the Stable repository key to install and get updates with **apt**


$ wget -q -O - [https://pkg.jenkins.io/debian-stable/jenkins.io.key](https://pkg.jenkins.io/debian-stable/jenkins.io.key)| sudo apt-key add -


Edit the sources.list file and add:

```
$ sudo nano /etc/apt/sources.list
```

```
#Jenkin Stable
deb https://pkg.jenkins.io/debian-stable binary/
```

Then install it:

```
sudo apt-get update
sudo apt-get install jenkins
```

Add user *jenkins* to your username group to allow it to read and write the Android SDK folder

```
$ sudo usermod -a -G YOUR_USERNAME jenkins
```

Jenkins service will always start at boot time and will be available at [http://localhost:8080](http://localhost:8080) 

Just after installation due to security reasons this screen is shown, just follow the instructions to finally get your Jenkins instance up and running.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*gN6-ncU7mRdQWL3wmlS_5g.png">

Unlocking a successfully installed Jenkins server

#### Jenkins Configuration: ####

After unlocking Jenkins installation you are prompted to install plugins, click “**Select plugins to Install**” browse and select the following ones to be installed in addition to suggested plugins:

- JUnit

[**JUnit Plugin - Jenkins - Jenkins Wiki**](https://wiki.jenkins-ci.org/display/JENKINS/JUnit+Plugin)

- JaCoCo

[**JaCoCo Plugin - Jenkins - Jenkins Wiki**](https://wiki.jenkins-ci.org/display/JENKINS/JaCoCo+Plugin)


- EnvInject

[**EnvInject Plugin - Jenkins - Jenkins Wiki**](https://wiki.jenkins-ci.org/display/JENKINS/EnvInject+Plugin) 

- GitHub plugins

[**GitHub Plugin - Jenkins - Jenkins Wiki**](https://wiki.jenkins-ci.org/display/JENKINS/GitHub+Plugin)

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*xvG06qRSCvfw5OQgQleG0A.png">

Installing Jenkins plugins

Create the admin user and complete installation.

To finish configuration we have to configure ANDROID_HOME and JAVA_HOME environmental variables:

Go to Manage Jenkins > Configure System

Scroll down and at **Global properties** section check the **Environment variables** box and add *ANDROID_HOME* and *JAVA_HOME*

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*rpgkUsqWhkHk4xOKCGPcvw.png">

Adding global environmental variables common to all Jenkins jobs

#### **Creating a “Jenkins Job”** ####

A Jenkins Job describes a series of steps that are executed consecutively. I have prepared a “Hello Jenkins” Android project in GitHub that you can use to test your Jenkins configuration as you follow this tutorial. It is just a hello world multi-module app with Unit tests, Android tests and includes JaCoCo and SonarQube plugins.

[**pamartineza/helloJenkins**](https://github.com/pamartineza/helloJenkins)

First create a new ***Freestyle project Job ***and give it a name eg. “***Hello_Android***” (Don’t use spaces in Jenkins Job names to avoid future compatibility problems with SonarQube)

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*ITE7xIrbsrChWv45PSlPPw.png">

Creating a Freestyle Jenkins Job

Then let’s configure it, I’m going to add screenshots of every section:

**General:**

This section is not very interesting for our goals, here you can change the name of the Job, add a description and if using a GitHub project add the project URL, (without *.git, the url of the web not the repo)

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*7QF2pfgM73FVIWTfQhcbEA.png">

Project Url Configuration


**Source Code Management:**

Here is where we have to chose our CVS as Git and add the repository url (this time include *.git) and select the branch to pull. As this is a public GitHub repository you don’t need to add credentials but otherwise you will have to add your user and password.

I recommend you that instead of using your actual GitHub user with full permissions create a new GitHub user with read-only privileges of your private repos to be used exclusively by your Jenkins Jobs.

In addition if you have enabled Two-Factor authentication Jenkins won’t be able to pull code and again having this exclusively created for Jenkins user will be the solution to pull code from private repos.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*wkzdL70XrCzIpXDsHPA2Pg.png">

Repository configuration


**Build Triggers:**

Builds can be triggered manually, remotely, periodically, after another Job build, when changes are detected, etc…

Ideally the optimal situation is to just trigger a build when a change has been pushed to the repository, GitHub provides a system called Webhooks

[**Webhooks | GitHub Developer Guide**](https://developer.github.com/webhooks/)

that we can configure to send events to the CI server and then trigger the build, but this obviously requires our CI sever to be online and reachable by GitHub servers.

Your CI is going to be probably isolated in a private network for security reasons then the only solution is to poll GitHub periodically. In my personal case I just turn on the CI when I’m working, in the following screenshot I have configured it to poll Github every 15 minutes. Polling times are defined with **CRON** syntax, if you are not familiar with it, press the help button on the right to get an extensive documentation with examples.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*eONz8DAwJ9PW7uc8VQw7wQ.png">

Repository polling configuration


**Build Environment:**

Here I recommend to configure the build ***stuck*** timeout to avoid Jenkins blocking memory and CPU if any unexpected error happens. Here also you can Inject environmental variables, passwords, etc…

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*Y6FgbIQq8pMk6D72Sr9KdQ.png">

Build stuck time out


**Build:**

Here is where the magic happens! Add a ***Build Step ***that ***Invokes Gradle Script ***select the Gradle Wrapper (Android projects are shipped with a Gradle Wrapper by default, don’t forget to check it into Git) and let’s define which tasks are going to be executed:

1. **clean:** Deletes all build outputs of previous builds, this ensures nothing is cached and the freshness of this build.

2. **assembleDebug:** Generates the debug .apk

3. **test:** executes JUnit tests in all modules

4. **connectedDebugAndroidTest:** executes Android Tests on actual android devices connected to the CI. (It is also possible to run Android Test against an Android Emulator installing the Android Emulator Jenkins plugin, but it doesn’t support all emulator versions and its configuration is not trivial at all)

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*D0HDPOUYCWzsWKiLv4LrBA.png">

Gradle tasks definition


**Post-build Actions:**

Here we are going to add ***Publish JUnit test result report ***this step is provided by the JUnit plugin and collects the .XML reports generated with the outcome of the JUnit tests that will generate a fancy chart with the evolution of tests results in time.

The path for debug flavor tests results in our app module is:

**app/build/test-results/debug/*.xml**

In multi-module projects the path for test results in other “pure” java modules is:

***/build/test-results/*.xml**

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*ZQtamiQ_8PzAFBd-pMfvdg.png">


Also add ***Record JaCoCo coverage report*** that will create a chart to show the evolution of the code coverage

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*wKaFykDl0qg-c79QwRTR2w.png">


#### Executing a Jenkins Job ####

Our Job will execute every 15 minutes if new changes have been pushed to the repository but it can also be triggered manually if you don’t want to wait until next polling or you just want to verify any change in the configuration straight forward. Click ***Build Now*** and then current build will be shown in the ***Build History ***, click on it to see the details.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*vKi-BGQ2blimaoTl7PTXtQ.png">

Manual Job execution

The most interesting part here is the console output, you can see how Jenkins pulls the code and starts executing the Gradle tasks we have previously defined e.g ***clean.***

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*dbtmlSr2owrj_CQfGXjdsw.png">

Beginning of console output

If everything is OK console output will finish as follows (any repository connectivity problem, failing JUnit or Android test failure would make the build to fail)

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*WpOH-aHuuNRDYmY710ecLQ.png">

Yeehaa! build Sucsessful and test results with coverage collected


### Step 5 — SonarQube ###

In this section I will describe how to install and configure SonarQube and its companion MySQL database using Docker containers.

[**Continuous Code Quality | SonarQube**](https://www.sonarqube.org/)

SonarQube is a code static analysis tool that helps developers to write cleaner code, detect bugs, learn good practices and it also keeps track of code coverage, tests results, technical debt, etc… all SonarQube detected issues can be imported easily to be fixed into Android Studio/IntelliJ with a plugin:

[**JetBrains Plugin Repository :: SonarQube Community Plugin**](https://plugins.jetbrains.com/idea/plugin/7238-sonarqube-community-plugin)

#### Installing Docker: ####

Installation of Docker is pretty straightforward following official Docker documentation:

[**Install Docker on Ubuntu**](https://docs.docker.com/engine/installation/linux/ubuntulinux/)


#### Creating Containers: ####

**MySQL:**

Let’s create a MySQL 5.7.17 server container called ***mysqlserver,*** that will allways start at boot time, with a local volume in your user folder, a password and exposed at localhost:3306 *(replace YOUR_USER and YOUR_MYSQL_PASSWORD with your values)*

```
$ docker run --name mysqlserver --restart=always -v /home/YOUR_USER/mysqlVolume:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=YOUR_MYSQL_PASSWORD -p 3306:3306 -d mysql:5.7.17
```


**phpMyAdmin:** 

To manage the MySQL server I’m used to phpMyAdmin then nothing more easy than creating another container called ***phpmyadmin*** linked to our ***mysqlserver*** container, that also starts at boot time, exposed at localhost:9090 and using the last version available.

```
$ docker run --name phpmyadmin --restart=always --link mysqlserver:db -p 9090:80 -d phpmyadmin/phpmyadmin
```

Using the phpMyAdmin interface at localhost:**9090** login as ***root and YOUR_MYSQL_PASSWORD*** andcreate a database called ***sonar*** with ***utf8_general_ci*** collation. Also create a new user ***sonar*** with password ***YOUR_SONAR_PASSWORD*** and give it all privileges on the ***sonar*** database.


**SonarQube:**

Now we are ready to create our SonarQube container called ***sonarqube*** that starts at boot time, linked to our db, exposed at localhost:**9000** and using the 5.6.4 (LTS) version.

```
$ docker run --name sonarqube --restart=always --link mysqlserver:db -p 9000:9000 -p 9092:9092 -e "SONARQUBE_JDBC_URL=jdbc:mysql://db:3306/sonar?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true&useConfigs=maxPerformance" -e "SONARQUBE_JDBC_USER=sonar" -e "SONARQUBE_JDBC_PASSWORD=YOUR_SONAR_PASSWORD" -d sonarqube:5.6.4
```

#### SonarQube Configuration: ####

If everything is OK browsing to localhost:9000 will lead you to this page:

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*tcgww8PENXdyrLS3K95ZEw.png">

Now let’s configure necessary plugins and Quality Profiles:

1. Login at the top right corner (Default administrator login is admin/admin)

2. Go to Administration > System > Update Center > **Updates Only**

- Update **Java** plugin if necessary

3. Now switch to **Available** and install the following plugins:

- **Android** (provides Android lint rules)

- **Checkstyle**

- **Findbugs**

- **XML**

4. Scroll back to the top and press restart button to complete the installation


#### SonarQube Profiles: ####

The plugins that we have installed define profiles that are sets of rules used to evaluate the code quality of a project.

Only 1 profile can be applied to a project at a time but we can make profiles have a parent and therefore inherit rules, so to be able to have all rules evaluated against our project we can create a new custom profile and chain all profiles.

Let’s do it, go to Quality Profiles > Create and give it a name e.g. **CustomAndroidProfile**

Add Android Lint as parent, then switch to the **Android Lint** profile and add **FindBugs Security Minimal** as parent, continue this chain until you get this inheritance schema and set the **CustomAndroidProfile** as the default one:

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*w2CvH8uAOUcvajzjsOoCgQ.png">

Inheritance chain


#### Executing the SonarQube Analysis: ####

Now that our SonarQube is properly configured we just have to add a new Gradle task, ***sonarqube***, to our Jenkins job, that will be executed in last place:

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*EDAjalNzmdU-ptjhWzuCcQ.png">

Adding the sonarqube gradle task

Execute again the Jenkins job and once it has finished let’s see our sonarQube dashboard at localhost:9000 :

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*n7dKdPXyUPj1AZe6ujL3vw.png">

Dashboard with Analysis result

If we press the project name we can navigate different dashboards, with tons of info, the most important one is probably Issues. 

In the next screenshot I’m showing the detail of a ***major*** issue that flags an empty constructor method. Here personally what gives me the most important value of using Sonarqube is the explanation shown at the screen bottom when you click on the period … , this is an invaluable way of learning tips and tricks of programming.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*KKM9T2qHzanraAetghYCqg.png">

Getting the explanation of the issue


### Step 6 — Extra: configuring other Android apps ###

Configuring an Android app to get coverage and sonarqube results is just having the JaCoCo and SonarQube plugins applied. Again you can find more details at my demo app **HelloJenkins:**

[**pamartineza/helloJenkins**](https://github.com/pamartineza/helloJenkins)

### The end! ###

Yes, you have finally reached the end of this long article! I hope you found it useful. If you find any error or you have any doubt please don’t hesitate to make any comment, I’ll do my best to try to help and if you liked it please share it!

![Markdown](http://i1.piimg.com/1949/7d2d44d03dd76bdc.png)
