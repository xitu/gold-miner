> * 原文链接 : [FlatBuffers in Android](http://frogermcs.github.io/flatbuffers-in-android-introdution/)
* 原文作者 : [froger_mcs dev blog](http://frogermcs.github.io/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [lihb (lhb)](https://github.com/lihb)
* 校对者: [yinshudi](https://github.com/yinshudi) [404neko](https://github.com/404neko)

# Android 上的数据格式 FlatBuffers 介绍

JSON 格式 - 一个基本上人人知道的、轻量级的、并被现代服务器所广泛使用的数据格式。相对过时的、讨厌的 XML 数据格式来说，它量级轻、易于人们阅读、对开发人员也更为友好。 JSON 是一种独立于语言存在的数据格式，但是它解析数据并将之转换成如 Java 对象时，会消耗我们的时间和内存资源。几天前，Facebook 宣称自己的 Android app 在数据处理的性能方面有了极大的提升。在几乎整个 app 中，他们放弃了 JSON 而用 FlatBuffers 取而代之。请查阅[这篇文章](https://code.facebook.com/posts/872547912839369/improving-facebook-s-performance-on-android-with-flatbuffers/)来获取关于 FlatBuffers 的基础知识以及从 JSON 格式过渡到 FlatBuffers 格式后的结果。

虽然这个结果非常激动人心，但咋一看如何使用不是很明显，Facebook 没有对实现进行过多的说明。这也是我发表这篇文章的原因，我将在文章中说明如何使用 FlatBuffers 来开始我们的工作。

## FlatBuffers 介绍

简而言之, [FlatBuffers](https://github.com/google/flatbuffers) 是一个来自 Google 的跨平台序列化库, 被 Google 开发出来专门用在游戏开发中，并在构建平滑和高响应的 Android UI 中遵循 [16 毫秒规则](https://www.youtube.com/watch?v=CaMTIgxCSqU)，就像 Facebook 向我们展示的那样。

_但是，嘿。。哥们，在你转移所有数据到 FlatBuffers 之前，请慎重考虑你是否真的需要它。因为有时候这点性能的影响是可以忽略的，有时候[数据安全](https://publicobject.com/2014/06/18/im-not-switching-to-flatbuffers/)可比只有几十毫秒区别的计算速度更为重要。_

什么原因使得 FlatBuffers 如此高效？

*   因为有了扁平二进制缓冲区，访问序列化数据甚至层级数据都不要解析。归功于此，我们不需要花费时间去初始化解析器（意味着构建复杂的字段映射）和解析数据。

*   FlatBuffers 数据相比使用自己的缓冲区，不需要分配其他更多的内存。我们不需要像 JSON 那样在解析数据的时候，为整个层级数据分配额外的内存对象。

更具体的原因，请再次查看关于如何迁移到 FlatBuffers 的 [facebook 文章](https://code.facebook.com/posts/872547912839369/improving-facebook-s-performance-on-android-with-flatbuffers/)，或者查阅 [Google 官方文档](http://google.github.io/flatbuffers/)。

## 实现步骤

该文将介绍在 Android app 中使用 FlatBuffers 最简单的方法。

*   在app项目以外的_某个地方_，JSON 数据将被转换成 FlatBuffers 格式的数据（如，API 会返回一个二进制文件或者目录）
*   数据模型（Java 类）是使用 **flatc**（FlatBuffers 编译器）手动生成的
*   对 JSON 文件的一些限制条件（不能使用空字段，日期类型将被解析成字符串类型）

不久后，我们可能准备介绍一些更复杂的解决方法。

## FlatBuffers 编译器

首先，我们必须得到 **flatc** - FlatBuffers 编译器，你可以通过源码来构建，源码放在 Google 的 [FlatBuffers 仓库](https://github.com/google/flatbuffers)。我们将源码下载或者克隆到本地。整个构建过程在[构建 FlatBuffers](https://google.github.io/flatbuffers/md__building.html)  文档中有详细描述。如果你是 Mac 用户，你需要做的仅仅是：

1.  进入下载好了的源码目录 `\{extract directory}\build\XcodeFlatBuffers.xcodeproj`
2.  按下 **Play** 按钮或者`⌘ + R`快捷键运行 **flatc** 结构描述文件（默认会被选中）
3.  运行完成后，**flatc** 可执行文件将会出现在项目的根目录中

现在，我们可以使用放在其他地方的[结构描述文件编译器](https://google.github.io/flatbuffers/md__compiler.html)来根据指定的结构描述文件（Java，C#，Python，GO 和 C++）生成模型类，或者将 JSON 文件转换成 FlatBuffer 格式的二进制文件。

## 结构描述文件

现在我们准备一份结构描述文件，该文件定义了我们想要序列化/反序列化的数据结构。我们使用该文件和 flatc 工具，去生成 Java 数据模型并将 JSON 格式的文件转换成 FlatBuffer 格式的二进制文件。

JSON 文件的部分代码如下所示：

     {
      "repos": [
        {
          "id": 27149168,
          "name": "acai",
          "full_name": "google/acai",
          "owner": {
            "login": "google",
            "id": 1342004,
            ...
            "type": "Organization",
            "site_admin": false
          },
          "private": false,
          "html_url": "https://github.com/google/acai",
          "description": "Testing library for JUnit4 and Guice.",
          ...
          "watchers": 21,
          "default_branch": "master"
        },
        ...
      ]
    }


整个 JSON 文件可以在[这里](https://github.com/frogermcs/FlatBuffs/blob/master/flatbuffers/repos_json.json)下载。该文件是调用 Github 的 API 来[获取 google 在 github 上的仓库](https://api.github.com/users/google/repos)结果的一个修改版本。

要编写一份 Flatbuffer 结构描述文件，请参考[这篇文档](https://google.github.io/flatbuffers/md__schemas.html)，我不会在此对它做深入的探索，因此我们使用的结构描述文件不会很复杂。我们所需要做的仅仅是创建3张表。`ReposList` 表，`Repo` 表和 `User` 表, 以及定义一个 `root_type`。这份结构描述文件的核心部分如下所示：

     table ReposList {
        repos : [Repo];
    }

    table Repo {
        id : long;
        name : string;
        full_name : string;
        owner : User;
        //...
        labels_url : string (deprecated);
        releases_url : string (deprecated);
    }

    table User {
        login : string;
        id : long;
        avatar_url : string;
        gravatar_id : string;
        //...
        site_admin : bool;
    }

    root_type ReposList;

该结构描述文件的完整版本可从[这里](https://github.com/frogermcs/FlatBuffs/blob/master/flatbuffers/repos_schema.fbs)下载。

## FlatBuffers 数据文件

好了，现在我们要做的是将 `repos_json.json` 文件转换成 FlatBuffers 的二进制文件以及生成 Java 模型，该 Java 模型是以一种对 Java 来说很友好的方式来展现的（所有我们需要的文件都可在[这里](https://github.com/frogermcs/FlatBuffs/tree/master/flatbuffers)下载）：

`$ ./flatc -j -b repos_schema.fbs repos_json.json`

如果一切顺利，将生成以下文件列表：

*   repos_json.bin （我们将把该文件重命名成 repos_flat.bin）
*   Repos/Repo.java
*   Repos/ReposList.java
*   Repos/User.java

## Android 程序

现在，让我们创建一个例子程序来展示 FlatBuffers 格式在实际开发中是如何工作的。程序截图如下所示。
![截图](http://frogermcs.github.io/images/17/screenshot.png "ScreenShot")

ProgressBar 用来展示不正确的数据处理（在 UI 主线程中）将会对用户界面的平滑性产生怎样的影响。

本程序中的 `app/build.gradle` 文件如下所示：

    apply plugin: 'com.android.application'
    apply plugin: 'com.jakewharton.hugo'

    android {
        compileSdkVersion 22
        buildToolsVersion "23.0.0 rc2"

        defaultConfig {
            applicationId "frogermcs.io.flatbuffs"
            minSdkVersion 15
            targetSdkVersion 22
            versionCode 1
            versionName "1.0"
        }
        buildTypes {
            release {
                minifyEnabled false
                proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
            }
        }
    }

    dependencies {
        compile fileTree(dir: 'libs', include: ['*.jar'])
        compile 'com.android.support:appcompat-v7:22.2.1'
        compile 'com.google.code.gson:gson:2.3.1'
        compile 'com.jakewharton:butterknife:7.0.1'
        compile 'io.reactivex:rxjava:1.0.10'
        compile 'io.reactivex:rxandroid:1.0.0'
    }

当然，你没有必要在该示例程序中使用 RxJava 或 ButterKnife 库，但是，我们为什么不使用他们来使得我们的程序变得更好一点呢 😉 ？

将 repos_flat.bin 文件和 repos_json.json 文件放在项目的`res/raw/`目录。

程序中，帮助我们读取 raw 文件的工具类 [RawDataReader](https://github.com/frogermcs/FlatBuffs/blob/master/app/src/main/java/frogermcs/io/flatbuffs/utils/RawDataReader.java) 可在此下载。

最后，将 `Repo`，`ReposList` 和 `User` 文件放在项目源码的某个地方。

### FlatBuffers 类库

在 Java 中，Flatbuffers 直接提供了 Java 类库来处理这种格式的数据。该 [flatbuffers-java-1.2.0-SNAPSHOT.jar](https://github.com/frogermcs/FlatBuffs/blob/master/app/libs/flatbuffers-java-1.2.0-SNAPSHOT.jar) 文件可在此处下载。如果你想手动生成该类库，请返回到 Flatbuffers 的源码目录，进入到 `java/` 目录，使用 Maven 构建来得到该类库。

`$ mvn install`

现在，将.jar文件放在Android项目的 `app/libs/` 目录下。

好，现在我们所需要做的是去实现 `MainActivity` 类，该文件的完整代码如下所示：

    public class MainActivity extends AppCompatActivity {

        @Bind(R.id.tvFlat)
        TextView tvFlat;
        @Bind(R.id.tvJson)
        TextView tvJson;

        private RawDataReader rawDataReader;

        private ReposListJson reposListJson;
        private ReposList reposListFlat;

        @Override
        protected void onCreate(Bundle savedInstanceState) {
            super.onCreate(savedInstanceState);
            setContentView(R.layout.activity_main);
            ButterKnife.bind(this);
            rawDataReader = new RawDataReader(this);
        }

        @OnClick(R.id.btnJson)
        public void onJsonClick() {
            rawDataReader.loadJsonString(R.raw.repos_json).subscribe(new SimpleObserver() {
                @Override
                public void onNext(String reposStr) {
                    parseReposListJson(reposStr);
                }
            });
        }

        private void parseReposListJson(String reposStr) {
            long startTime = System.currentTimeMillis();
            reposListJson = new Gson().fromJson(reposStr, ReposListJson.class);
            for (int i = 0; i < reposListJson.repos.size(); i++) {
                RepoJson repo = reposListJson.repos.get(i);
                Log.d("FlatBuffers", "Repo #" + i + ", id: " + repo.id);
            }
            long endTime = System.currentTimeMillis() - startTime;
            tvJson.setText("Elements: " + reposListJson.repos.size() + ": load time: " + endTime + "ms");
        }

        @OnClick(R.id.btnFlatBuffers)
        public void onFlatBuffersClick() {
            rawDataReader.loadBytes(R.raw.repos_flat).subscribe(new SimpleObserver() {
                @Override
                public void onNext(byte[] bytes) {
                    loadFlatBuffer(bytes);
                }
            });
        }

        private void loadFlatBuffer(byte[] bytes) {
            long startTime = System.currentTimeMillis();
            ByteBuffer bb = ByteBuffer.wrap(bytes);
            reposListFlat = frogermcs.io.flatbuffs.model.flat.ReposList.getRootAsReposList(bb);
            for (int i = 0; i < reposListFlat.reposLength(); i++) {
                Repo repos = reposListFlat.repos(i);
                Log.d("FlatBuffers", "Repo #" + i + ", id: " + repos.id());
            }
            long endTime = System.currentTimeMillis() - startTime;
            tvFlat.setText("Elements: " + reposListFlat.reposLength() + ": load time: " + endTime + "ms");

        }
    }

我们应该重点关心的方法：

*    `parseReposListJson(String reposStr)` - 该方法初始化 Gson 解析器，并将 json 字符串转换成 Java 实体类
*    `loadFlatBuffer(byte[] bytes)` - 该方法将字节码文件（我们的 repos_flat.bin 文件）转换成 Java 实体类

## 结果

现在，让我们看看分别使用 JSON 和 FlatBuffers 来解析数据时，在加载时间和消耗资源方面的区别。测试在运行 Android M (beta) 系统的 Nexus 5 手机中进行。

## 加载时间

评价标准是将全部元素（90 个）转换成对应的 Java 文件。

JSON - 平均加载时间为 200ms（波动范围在：180ms - 250ms），JSON 文件大小：478kb。FlatBuffers - 平均加载时间为 5ms （波动范围在: 3ms - 10ms），FlatBuffers 二进制文件大小：362kb。

还记得我们的 [16 毫秒规则](https://www.youtube.com/watch?v=CaMTIgxCSqU)吗？我们将在 UI 线程中调用上述方法，用来观察我们界面的显示行为：

### JSON 加载数据

![JSON](http://frogermcs.github.io/images/17/json.gif "JSON")

### FlatBuffer 加载数据

![FlatBuffers](http://frogermcs.github.io/images/17/flatbuffers.gif "FlatBuffers")

看到区别了吗？当使用 JSON 加载数据时，ProgressBar 明显冻住了一会儿，这使得我们的界面不舒服（操作耗时超过了 16ms）。

### 内存分配，CPU 使用情况等

想用更多标准来测试？这可能是尝试使用 [Android Studio 1.3](http://android-developers.blogspot.com/2015/07/get-your-hands-on-android-studio-13.html) 和其新特性的好机会。Android Studio 1.3 可用来进行测试的新特性有内存分配跟踪，内存查看和方法追踪等。

## 源代码

完整的项目源代码可以在 Github 的[这里](https://github.com/frogermcs/FlatBuffs)下载到。你不必了解整个 Flatbuffers 项目 - 你所需要的都在 `flatbuffers/` 目录。

## 作者信息

[Miroslaw Stanek](http://about.me/froger_mcs)
[Azimo Money Transfer](https://azimo.com) 公司_移动开发主管_

如果你喜欢这篇文章，请在 Twitter上 [分享给你们的粉丝](https://twitter.com/intent/tweet?url=http://frogermcs.github.io/flatbuffers-in-android-introdution/&text=FlatBuffers%20in%20Android%20-%20introduction&via=froger_mcs)，或者在 Twitter 上[关注](https://twitter.com/froger_mcs)我！

