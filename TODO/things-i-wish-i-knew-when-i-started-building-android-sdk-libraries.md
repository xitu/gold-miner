> * 原文地址：[Things I wish I knew when I started building Android SDK/Libraries](https://android.jlelse.eu/things-i-wish-i-knew-when-i-started-building-android-sdk-libraries-dba1a524d619#.bw591tw8c)
* 原文作者：[Nishant Srivastava](https://android.jlelse.eu/@nisrulz?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[jifaxu](https://github.com/jifaxu)
* 校对者：

# Things I wish I knew when I started building Android SDK/Libraries #
# 当发布安卓开源库时我希望知道的东西 #

![](https://cdn-images-1.medium.com/max/1000/1*BfqwDsS3mt2pOslSQnFKCw.png)

一切要从安卓开发者开发自己的“超酷炫应用”开始说起，他们可能会在这个过程中遇到一系列的问题，然后经过一番努力解决了这些问题。

现在有件事，如果你和我一样认为这个问题足够严重，并且没有现成的处理方案，那么我将以模块化的方法抽象整个解决方案，这就是一个安卓库了。这样以后当我再次遇到这个问题时，我就可以很轻松的重用它了

到目前为止一切都好。现在你有一个库了，也许只是拿来自用，或者你认为别人也会遇到这个问题，然后你对外发布了这个库(比如开源代码)。我相信(或者它就是这样)很多人认为这就算大功告成了。

**错了！**这一点是大多数人通常弄错的地方。你的安卓库将被一些不在你身边的开发者使用，他们只是想用你的库来解决同样的问题。你的库的 API 设计的越好，它被使用概率就越大，因为它不会让使用者感到困惑。从一开始就应该让使用者知道该怎样使用你的库。

**为什么会发生这种事？**

开发者在第一次发布安卓库的时候通常不会注意 API 的设计，至少他们中的大多数都不会。倒不是因为漠不关心，而是因为他们都只是新手，又没有一个可以参考的 API 设计规范。之前我也陷入了同样的僵局，所以我可以理解找不到相关资料的沮丧。

我刚好做了一个开源库（你可以在[这个地址](https://github.com/nisrulz/android-tips-tricks#extra--android-libraries-built-by-me)查看）所以有一些经验。我总结了一些开发者在设计安卓库的 API 时应该记在脑海中的规范（其中一些也适合安卓之外的技术）。

> 需要注意的是，我的列表并不完善。它包含了我遇到的一些问题，我希望我在一开始就能知道这些，当我有了新的经验后我也会来更新这篇博客。

在我们正式开始之前，先来回答一个每个人在开发安卓库时都会遇到的问题，那就是：

### **你为什么要创建一个安卓库？**###

![](https://cdn-images-1.medium.com/max/800/1*YKokr5q6sL-Cge6AVPBsyQ.gif)

额……

好吧，无论何时都不是非要创建一个库。在开始之前好好想想它能给你带来什么价值。问问自己下面几个问题：

**有没有现成的解决方案？**

如果你回答是，那么考虑下使用已有的解决方案吧。

如果现有方案无法完美解决你的问题，即使在这种情况下，最好也是从 fork 代码开始，修改它以解决你的问题。

> 如果你向现有的库提交你的修改那么社区将会从中受益。

如果你的回答是没有，那么就可以开始编写安卓库了。之后与世界分享你的成果以便别人也可以使用它。

###你的 artifact 有哪些打包方式###
在开始之前，你需要决定以什么样的方式向开发者发布你的 artifact。

让我在这里解释一下这篇博客中的一些概念。先解释下 **artifact**。

> 在通用软件术语中，**artifact** 是在软件开发过程中产出的一些东西，可以是相关文档或者一个可执行文件。
> 在 Maven 术语中，artifact 是编译的输出，`jar`, `war`, `arr` 或者别的可执行文件。

让我们看下可选项

- **Library 工程**：你必须获取代码并链接到你的工程里。这是最灵活的方式，你可以修改它的代码，但也引入了与上游更改同步的问题。
- **JAR**：Java Archive 是一个专门将很多 Java 类以及元数据放到一起的包文件。
- **AAR**：Android Archive 类似于 JAR，但有些额外的功能。和 JAR 不同，**AAR** 可以存储安卓资源和 manifest 文件，这允许你分享诸如布局和 drawable 等资源文件。

### 我们有了 artifact 了，现在该做什么？别人如何获得它们###

![](https://cdn-images-1.medium.com/max/600/1*09w_B5kEUXMrLH6Z786d5g.gif)

开玩笑……

你有好几种选择，每种都有优缺点。让我们一个一个看。

#### 本地 ARR ####

如果你不想将你的库提交到任何仓库里，你可以产生一个 `arr` 文件并直接使用它。阅读 [StackOverflow 上的一个回答](http://stackoverflow.com/a/28816265/2745762)学习如何实现。

你必须将 `arr` 文件放到 `libs` 文件夹里(没有就创建)，然后在 build.gradle 中添加如下代码：

```
dependencies {
   compile(name:'nameOfYourAARFileWithoutExtension', ext:'aar')
 }
repositories{
      flatDir{
              dirs 'libs'
       }
 }
```

这带来的结果就是无论何时你想要分享你的安卓库时你都绕不过你的 `arr` 文件了（这可不是分享你的安卓库的好方式）。

> **尽可能的避免这么做**，因为它容易引发很多问题，尤其是代码库的可管理性和可维护性。
> 另一个问题是这种方式没办法保证你的用户使用的代码是最新的。
> 更不用说整个过程漫长而容易出现人为错误，我们的目标也只是将一个库集成到安卓工程中。

### 本地/远程 Maven 存储库 ###

**如果你只想给自己用这个安卓库该怎么做？**解决办法是部署一个自己的 artifactory（在[这里](http://jeroenmols.com/blog/2015/08/06/artifactory/)了解如何去做）或者使用 GitHub 或者 Bitbucket 作为你自己的 maven 库（在[这里](http://crushingcode.nisrulz.com/own-a-maven-repository-like-a-bosspart-1/）。

> 再次强调，**这只是用来发布自用包的方法。如果你想要与他人分享，那这不是你需要的方式**。

这种方式的第一个问题是你的 artifact 是存在私有仓库里的，别人要想用你的库就得授予访问权限，这可能会导致安全问题。

第二个问题是别人要想用你的库就得在他的 `build.gradle` 文件里加上额外的语句。

```
allprojects {
	repositories {
		...
		maven { url '
		http://url.to_your_hosted_artifactory_instance.maven_repository' }
	}
}
```

说实话这样比较麻烦，而我们都希望事情简单一点。它在发布安卓库的时候比较迅速但是为别人的使用增加了额外步骤。

### Maven Central, Jcenter 或 JitPack ###

现在最简单的发布方式是通过 **JitPack**。所以你可能想去使用它。JitPack 从你的公开 git 仓库中拉取代码，check out 最新的 release 代码，编译并生成 artifact，最后将它发布到它自己的 maven 库中。

但是它和 local/remote 仓库存在同样的问题，要使用的话必须在根 `build.gradle` 中添加额外内容。

```
allprojects {
	repositories {
		...
		maven { url 'https://www.jitpack.io' }
	}
}
```

你可以从[这儿](http://crushingcode.co/publish-your-android-library-via-jitpack/)了解该如何发布你的安卓库至 JitPack。

另一个选择就是 **Maven Central** 或者 **Jcenter**。 

**我个人建议你使用 Jcenter**，因为它有着完善的文档并被管理的很好。同时它也是安卓工程的默认仓库（除非有谁修改了）。

如果你发布到 Jcenter，binatray 公司提供将库同步到 Maven Central 的选项。一旦成功发布到 Jcenter 上，在 `build.gradle` 中加上如下代码就可以很方便的使用了。

```
dependencies {
      compile 'com.github.nisrulz:awesomelib:1.0'
  }
```

你可以在[这儿](http://crushingcode.co/publish-your-android-library-via-jcenter/)了解如何发布你的安卓库至 Jcenter。

基础的东西说完了，现在让我们来讨论一下在编写安卓库的时候需要注意的问题。

### 避免多参数 ###

每个安卓库通常都需要用一些参数初始化，为了达到这个目的，你可能会在构造函数或者新建一个 init 方法来接受这些参数。这么做的时候请考虑以下问题

**向 init() 方法传递 2-3 个参数会让使用者感到头大。**因为很难记住每个参数的用处和顺序，使用者也容易将 int 型数据传给了 `String` 类型的参数。

```
// 不要这么做
void init(String apikey, int refresh, long interval, String type);

// 这样做
void init(ApiSecret apisecret);
```

`ApiSecret` 是一个实体类，定义如下

```
public class ApiSecret {
    String apikey;
    int refresh;
    long interval;
    String type;

    // constructor

    /* you can define proper checks(such as type safety) and
     * conditions to validate data before it gets set
     */

    // setter and getters
}
```

**或者**你可以使用 `建造者模式`。

你可以阅读这篇[文章]()以了解更多建造者模式的知识。深入讨论了该如何在你的代码中实现它，看[这个](https://jlordiales.me/2012/12/13/the-builder-pattern-in-practice/)。

### 易用性 ###

当构建你的安卓库时，请关注库的易用性和暴露出的方法，它们应该具有一下特点：

- **符合直觉**

安卓库中的代码引起的每个变化都应该以某种形式反馈使用者，可以是日志输出，也可以是视图的变化，这根据库的类型来决定。如果它做了一些难以理解的事，那么开发者就可能认为这个库没有起作用。它应该按照使用者想的那样来工作而不需要强迫他们去看文档。

- **一致性**

代码应该易于理解，同时避免在版本迭代的过程中发生剧烈的变化。遵循 [**sematic versioning**](http://semver.org/)。

- **易于使用，难以误用**

就实现与首次使用而言，它应该是易于理解的。（？）公开的方法应该经过充分的检查以保证用户不会。

简而言之

![](https://cdn-images-1.medium.com/max/800/1*iBMPbaVozZmJkkp-kisr7g.gif)

简单。

### 最小化权限 ###

在每个开发者都在向用户申请很多的权限时，你得停下来想一想你是不是真的需要这些权限。这一点尤其需要注意。

- 尽可能的请求更少的权限。
- 使用 **Intent** 让专用程序为你工作并返回结果。
- 基于你获得的权限启用你的功能。避免因为权限不足导致的崩溃。可以的话，在请求权限之前先让用户知道你为什么需要这些权限。尽量在没有获得权限的时候进行功能回退。

通过如下方式检查是否具有某个权限。

```
public boolean hasPermission(Context context, String permission) {
  int result = context.checkCallingOrSelfPermission(permission);
  return result == PackageManager.PERMISSION_GRANTED;
}
```

有限开发者可能回说他是真的需要某个特定权限，在这种情况下该怎么办呢？库代码应该对所有需要这个功能的应用时通用的。如果你需要某个危险权限来获取某些数据，而开发者可以提供这些数据，那么你就应该提供一个方法来接收这些数据。这种时候你就不应该强迫开发者去申请他不想申请的权限了。当没有权限时，提供回退实现。


```
/* Requiring GET_ACCOUNTS permission (as a requisite to use the
 * library) is avoided here by providing a function which lets the
 * devs to get it on their own and feed it to a function in the
 * library.
 */

MyAwesomeLibrary.getEmail("username@emailprovider.com");
```

### 最小化条件 ###

现在，我们有一个功能需要设备具有某种功能。通常我们会在 manifest 文件中进行如下定义

```
<uses-feature android:name="android.hardware.bluetooth" />
```

当你在安卓库代码中这么写的时候问题就来了，它会在构建的过程中与应用的 manifest 文件合并，并导致那些没有蓝牙功用的设备无法从 Play 商店中下载它。这样会导致一个应用的用户变少，就只是因为引用了你的库。

这可不是我们想要的。所以我们得解决它。不要在 manifest 文件中写 **uses-feature**，在运行时检查是否有这个功能

```
String feature = PackageManager.FEATURE_BLUETOOTH;
public boolean isFeatureAvailable(Context context, String feature) {
 return context.getPackageManager().hasSystemFeature(feature);
}
```

这种方式就不会引起 Play 商店的过滤。

**一个额外的功能**是当这个功能不可用时在库代码中不去调用相关方法。这对于库的开发者和使用者来说是一种双赢的局面。

### 多版本支持 ###

![](https://cdn-images-1.medium.com/max/1600/1*7Lh4ChOmBQ5A9fJ0vP2e1Q.gif)

现在到底有多少种版本？

如果你的库中存在只能在特定版本中运行的代码，你应该在低版本的设备中禁用这些代码。

一般的做法是通过定义 `minSdkVersion` 和 `targetSdkVersion` 来指定支持版本。你应在在代码中检查版本，来决定是否启动某个功能，或者提供回退。

```
// Method to check if the Android Version on device is greater than or equal to Marshmallow.
public boolean isMarshmallow(){
    return Build.VERSION.SDK_INT>= Build.VERSION_CODES.M;
}
```

### 不要在正式版中输出日志 ###

![](https://cdn-images-1.medium.com/max/1200/1*78Ghqzo3iMUnaYjNcuu1xw.gif)

就是不要这么做。

几乎每次被要求去测试一个应用或者安卓库工程时我都会发现他们把所有在日志里输出了所有东西，这可是发布版啊。

根据经验，永远不要再正式版中输出日志。你应该配合使用 [**build-variants**](https://developer.android.com/studio/build/build-variants.html) 和 [**timber**](https://github.com/JakeWharton/timber) 来实现发布版和调试版中的不同日志输出。一个更简单的解决方案时提供一个 `debuggable` 标志位来让开发者设置以开关安卓库中的日志输出。

```
// In code
boolean debuggable = false;
MyAwesomeLibrary.init(apisecret,debuggable);

// In build.gradle
debuggable = true
```

### Do not crash silently and fail fast ###
### 避免悄悄的崩溃并快速失败 ###(这儿不知道咋翻)

![](https://cdn-images-1.medium.com/max/600/1*71OXRYnUcGsgX-Ut5aPK6A.png)

经常有开发者不在日志里输出错误和异常信息，我遇到过很多次这种情况。这让安卓库的使用者在调试的过程中感到十分的头疼。虽然上面说了不要在发布版中输出日志，但是你得理解无论是在*发布版*还是*调试版*中错误和异常信息都需要输出。如果你真的不愿意再发布版中输出，至少在初始化的时候提供一个方法来让使用者启用日志。

```
void init(ApiSecret apisecret,boolean debuggable){
      ...
      try{
        ...
      }catch(Exception ex){
        if(debuggable){
          // This is printed only when debuggable is true
          ex.printStackTrace();
        }
      }
      ....
}
```

当你的安卓库崩溃的时候要立刻向用户显示异常，而不是挂起并做一些处理。避免写一些会阻塞主进程的代码。

### 当发生错误的时候优雅的降级 ###

这个的意思是当你的代码崩溃后，请进行检查，禁用引起崩溃的代码以防止崩溃再次发生。

### 捕获特定的异常 ###

接上一条建议，你可以看到上面那段代码里我使用了 try-catch 语句。Catch 语句只是简单的捕获了所有的 `Exception` 。一个异常与另一个异常之间并没有什么太大的区别。因此，必须要根据手头的需求定义特定类型的异常。比如：`NULLPointerException`, `SocketTimeoutException`, `IOException` 等等。

### 对网络状况差的情况进行处理 ###

![](https://cdn-images-1.medium.com/max/800/1*I_Cs9YSx0ZbTVUWSwF6YCA.gif)

这很重要，严肃点！

如果你的安卓库需要进行网络请求，一个很容易护士的情况就是网速较慢或者请求无相应的情况。

据我观察，很多开发这都时假设网络状态良好。举个例子吧，你的安卓库需要从服务器上获取配置文件来进行初始化。如果你忽略了在网络状态差的时候没法下载配置文件，那么你的代码就可能因为获取不了配置文件而崩溃。如果你进行了网络状态检查，那么就能为你的库的使用者省很多事。

尽可能的批量处理你的网络请求，避免多次请求。这能够[节省很多电量](https://developer.android.com/training/monitoring-device-state/index.html)，再看下[这个](https://developer.android.com/training/efficient-downloads/efficient-network-access.html)。

通过将 *JSON* 与 *XML* 转成 [***Flatbuffers***](https://google.github.io/flatbuffers/) 来节省数据传输量。

[阅读更多有关网络管理的知识](https://developer.android.com/topic/performance/power/network/index.html)。

### 避免将大型库作为依赖 ###

这一点不需要太多的解释。就像安卓开发者都知道的那样，一个安卓应用最多只能有 65k 方法。如果你依赖了一个大型的库，那么会对使用你的库的应用带来两个不期望的影响。

1. 你会让应用的方法数将会大大增加，即使你的库只有很少一些方法，但是你依赖的库中的方法也被算上了。
2. 如果因为引入你的库而导致方法数达到了 65k，那么应用开发者不得不去使用 multi-dex。相信我，没人想用 multi-dex 的。
在这种情况下，为了解决一个问题你引入了一个更大的问题，你的库的使用者将会转而去使用别的库。

### 避免引用不是必需的库 ###

我觉得这应该时一条大家都知道的规则了，是不是？不要让你的安卓库因为引入了不需要的库而膨胀。但是需要注意的是即使你需要依赖，也不是必须要让你的用户下载它。比如，依赖不需要与你的安卓库绑定。
*那么现在的问题就是如果没有和我们的库绑定那么我们如何去使用它？*

答案很简单，要求用户在编译的时候提供你需要的依赖。可能不是每个用户都需要这个依赖提供的方法，对于这些用户来说，如果你找不到这些依赖，你只需要禁用某些方法就行了。对于那些需要的用户，它们会在 `build.gradle` 提供依赖。

#### **如何实现它？** 检查 classpath ####

```
private boolean hasOKHttpOnClasspath() {
   try {
       Class.forName("com.squareup.okhttp3.OkHttpClient");
       return true;
   } catch (ClassNotFoundException ex) {
       ex.printStackTrace();
   }
   return false;
}
```

接下来，你可以使用 `provided`(Gradle v2.12 或更低)或者 `compileOnly`(Gradle v2.12+)（[阅读完整内容]()），以便在编译时获取依赖库内定义的类。

```
dependencies {
   // for gradle version 2.12 and below
   provided 'com.squareup.okhttp3:okhttp:3.6.0'

   // or for gradle version 2.12+
   compileOnly 'com.squareup.okhttp3:okhttp:3.6.0'

}
```

> 多说一句，只有当依赖是纯 Java 的时候你才能使用里面的方法。比如，如果你在编译时引入安卓库，你就没法使用它的传递库或者资源文件，这些都必须在编译前被加入。另一方面，纯 Java 依赖只有 Java 类，这是可以在编译的过程中被加入 ClassPath 的。

### 不要阻塞启动过程 ###

![](https://cdn-images-1.medium.com/max/1200/1*78Ghqzo3iMUnaYjNcuu1xw.gif)

没开玩笑

我指的不要应用一启动就立刻初始化你的安卓库。这么做会降低应用的启动速度，即使应用什么都没做就只是初始化了你的库。

解决办法是不要在主线程里进行初始化工作，可以新建一个线程，更好的办法是使用 `Executors.newSingleThreadExecutor()` 让线程数量保持唯一。

另一个解决办法是**根据需要**初始化你的安卓库，比如只有在使用到的时候加载它们。

### 优雅地移除方法和功能 ###

不要在版本迭代的过程中移除 `public` 方法，这会导致使用你的库的应用无法使用，而开发者并不知道什么导致了这个问题。

解决方案：使用 `@Deprecated` 来标注方法并给出在未来版本的弃用计划。

### 使你的代码可测试 ###

确定你的代码里有测试实例，这不是一个规则，而是一个常识，你应该在你的每一个应用和库中这么做。

使用 Mock 来测试你的代码，避免 final 类，不要有静态方法等等。

基于接口编写你的 public  API 使你的安卓库能交换实现，反过来让你的代码可测试，比如，你可以在测试的石头提供 mock 实现。

### 为每一个东西编写文档 ###

![](https://cdn-images-1.medium.com/max/800/1*Qtged_3sWzcWmRstgkTGJQ.gif)

作为安卓库的创建者你很了解你的代码，但是使用者不知道除非你让他们去阅读你的代码（永远也不要这么做）。

编写文档，包括使用时的每个细节，你实现的每个功能。

1. 穿件一个 `Readme.md` 文件并将其放在库的根目录下。
2. 为代码里所有 `public` 写 `javadoc`。它们应该包括
- `public` 方法的目的
- `传入的参数`
- `返回的数据`
3. 提供一个示例应用来演示这个库的功能以及如何使用。
4. 确定你有一个详细的修改日志。放在 `release` 记录里或者特殊的版本 tag 里都比较合适。

![](https://cdn-images-1.medium.com/max/800/1*7cIRxmPZLxOzoR6sMYDXJQ.jpeg)

GitHub 里 Sensey 库的 Release 部分截图

这是 [*Sensey*](https://github.com/nisrulz/sensey) 的 [*release 链接*](https://github.com/nisrulz/sensey/releases)

### 提供一个极简的示例应用 ###

这都不用说了。始终提供一个最简洁的示例程序，这是开发者在学习使用你的库的过程中接触的第一个东西。它越简单就越好理解。让这个程序看起来很炫和复杂编码只会背离它的原本目的，它只是一个如何使用库的例子。

### 考虑加一个 License ###

很多时候开发者都忘了 License 这部分。这是别人决定要不要采纳你的库的一个因素。

如果你决定使用一种带限制的协议，比如 GRL，这意味着无论谁只要修改了你的代码那他必须要将修改提交到你的代码库中。这样的限制阻碍了安卓库的使用，开发者倾向于避免使用这样的代码库。

解决办法是使用诸如 MIT 或者 Apache 2 这样更为开放的协议。

在这个[简单的网站](https://choosealicense.com/)阅读有关协议的知识，以及关于你的[代码需要的 copyright](http://jeroenmols.com/blog/2016/08/03/copyright/)。

### 最后但同样重要的，获取反馈 ###

![](https://cdn-images-1.medium.com/max/600/1*Yqf4olqT9Xsrk_ApAk-uiA.gif)

是的，你听到了！

起初，你的安卓库是用来满足自己的需求的。一旦你发布出去让别人用，你将会发现大量的问题。从你的库的使用者那里听取意见收集反馈。基于这些意见在保持原有目的不变的情况下考虑增加新的功能和修复一些问题。

### 总结 ###

简而言之，你需要在编码过程中注意以下几点

- 避免多参数
- 易用
- 最小化权限
- 最小化前置条件
- 多版本支持
- 不要再发布版中打印日志
- 不要静默的崩溃或快速失败
- 优雅的处理错误
- 捕获特定异常
- 处理网络不良的情况
- 避免依赖大型库
- 除非特别需要，不要引入依赖
- 避免阻塞启动过程
- 优雅地移除功能和特性
- 让代码可测试
- 完善的文档
- 提供极简的示例应用
- 考虑加个协议
- 获取反馈

#### 根据经验，你的库应该依照 SPOIL 原则 ####

简单（**S**imple）—— 简洁而清晰的表达

目的（**P**urposeful）—— 解决问题

开源（**O**penSource）—— 自由访问，免费协议

习惯（**I**diamatic）—— 符合正常使用习惯

逻辑（**L**ogical) —— 清晰有理

> 我在曾经某个时候从某位作者的展示里看到这个，但我想不起来他是谁了。当时我记了笔记因为它很有意义，而且以很简洁的方式提供了图片。如果你知道他是谁，在下面评论，我会将他的链接加上。

### 最后的思考 ###

我希望这篇博客给那些正在开发更好的安卓库的开发者们带来帮助。安卓社区从开发者每天发布的库中获得了很大的益处。如果每个人都开始注意他们 API 设计，学会为用户（其他的安卓开发者）考虑，我们将会迎来一个更好的生态。

这个教程是基于我开发安卓库的经验。我很想知道你关于这些观点的意见。欢迎留下评论。

如果你有什么建议或者想让我加一些内容，请让我知道。

Till then keep crushing code 🤓

