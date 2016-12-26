> * 原文地址：[Explain Activity Launch Mode With Examples](http://www.songzhw.com/2016/08/09/explain-activity-launch-mode-with-examples/)
* 原文作者：[songzhw](http://www.songzhw.com/author/songzhw2012gmail-com/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： [Liz](http://lizwangying.github.io/)
* 校对者： [mypchas6fans](https://github.com/mypchas6fans),[hackerkevin](https://github.com/hackerkevin)

# Activity 的正确打开方式

## adb shell dumpsys activity

输入这个命令可以得到一个清晰的 Task 视图，比如你有多少个 Task ，哪些 activity 在其对应的 Task 等相关信息。

下图是一张运行这个命令的输出截图。

![](http://i2.wp.com/www.songzhw.com/wp-content/uploads/2016/08/20160214_01.png?w=644)

从图中可以看出，有两个 Task (#103, #102) 。

Task #103 : affinity = “cn.six.task2”, size = 3 (它里面有三个activity)

— Activity One    
— Activity Three    
— ActivityTwo    

Task #102 : affinity = “cn.six.adv”, size = 1

— Activity One

拥有了这个神奇的命令—— “adb shell dumpsys activity” ，我们就可以更好地探索 Activity 的启动模式啦…

## Default

到达此 activity 的 Intent ，系统会默认地在目标 Task 中创建一个新的实例并将默认的启动模式属性设置为 "default" 。

“Default” 是 activity 的默认启动模式，也就是说当你未给 activity 指定启动模式的时候，系统默认会给一个 “Default” 作为它的启动模式。

## SingleTop

如果一个启动模式为 SingleTop 的 activity 实例在目标栈顶，intent 启动该 activity 时系统将通过 onNewIntent 的方法将 intent 传递给已有的那个实例而不会新创建一个的实例。

注意：并不是清除栈顶的 activity ！！！（也就是说只要栈顶不是本 activity ，都会创建新的实例，是本 activity 则重用不新建）。

## SingleTask

这个是最难理解的，下文中我会搭配几个例子来细细讲解这个复杂的启动模式。

## 1\. A(Default) -> B(singleTask)

我们有两个 Activity ，A 和 B ，其中 B 是 SingleTask 模式，现在从 A 跳转到 B 。

首先在 Manifest 中写入启动模式，如下：

```

<manifest xmlns:android="http://schemas.android.com/apk/res/android" package="cn.six.adv">
    <Activity android:name=".A"/>
    <Activity android:name=".B" android:launchMode="singleTask"/>
</manifest>

```

Android 官方文档中提到 “ intent 启动一个（SingleTask） 的 Activity ，系统会将这个 Activity 创建在一个新的 Task 根部”。 SO ,听起来会是这个样子？

| Task 1 | Task 2 |
| :-: | :-: |
| A | B |

但实际上，当我们运行命令 “adb shell dumpsys activity” 时，发现 B 这货诡异地和 A 出现在一个 Task 中。

| Task 1 | Task 2 |
| :-: | :-: |
| B
A | (null) |

这个问题有一点小难表达，因为这里面 B 使用了 `android:taskAffinity` 属性。 后文中会有详解。

## 2\. A(Default) -> B(singleTask) : B has a taskAffinity attribute

在 manifest 中这样写:

```

<manifest xmlns:android="http://schemas.android.com/apk/res/android" package="cn.six.adv">
    <activity android:name=".A"/>
    <activity android:name=".B" android:launchMode="singleTask" android:taskAffinity="task2"/>
</manifest>

```

在这里,  A 启动 B 的效果就不一样啦。如下:

| Task 1 | Task 2 |
| :-: | :-: |
| A | B |

这个和上一个例子的唯一不同就是属性 “android:taskAffinity” 。 当你不声明 affinity 属性, 那么 activity 就会以包名作为其默认值。在这个例子中, 默认的 affinity 值就是 “cn.six.adv” 。

当 A 启动 B ，即使 B 的启动模式是 singleTask ，但也只有当 `android:taskAffinity` 属性和 A 不同时才会创建新的 task 。

看到这里，第一个例子是不是就顿时豁然开朗？ 为什么 A 和 B 在同一个 Task 中呢？因为它们的 `taskAffinity` 属性值是一样滴。

用逻辑来表达，就像是这样:

```

A --> B

  if( taskAffinity 属性相同) { 
    A 和 B 在同一个 Task 中
  }
  else { 
    B 在新的 Task 中，并且此 Task 的 affinity 属性值就是 B 的
  }

```

那么这个例子中, A 跳转 B, B 的启动模式是 “singleTask” , 并且 B 的 taskAffinity 不是 “cn.six.adv” 。 所以 B 会在一个新建的 Task 中。

| Task 1 (affinity=”cn.six.adv”) | Task 2 (affinity=”task2″) |
| --- | --- |
| A | B |

## 3\. A(default) -> B(singleTask) -> C(singleTask) -> B(singleTask)

manifest 如下:

```

<manifest xmlns:android="http://schemas.android.com/apk/res/android" package="cn.six.adv">
    <activity android:name=".A"/>
    <activity android:name=".B" android:launchMode="singleTask" android:taskAffinity="task2"/>
    <activity android:name=".C" android:launchMode="singleTask" android:taskAffinity="task2"/>
</manifest>

```

(1). A -> B

| Task 1 (affinity=”cn.six.adv”) | Task 2 (affinity=”task2″) |
| --- | --- |
| A | B |

(2) A -> B -> C

因为 C 的 affinity 是 “task2” ，而 Task 中已经有一个和它一样属性值的 B ，所以 C 会被放在 Task 2 中。

| Task 1 (affinity=”cn.six.adv”) | Task 2 (affinity=”task2″) |
| --- | --- |
| A | C B|

(3) A -> B -> C -> B

首先看一下实际结果

| Task 1 (affinity=”cn.six.adv”) | Task 2 (affinity=”task2″) |
| --- | --- |
| A | B |

好奇怪啊！ C 去哪里啦？

事情呢，是这个样子滴。 C->B ， B 的启动模式是 singleTask 而且它的 affinity 属性值是 “task2”, 当系统发现有一个 affinity 属性值为 task2 的 Task 2 所以就把 B 放进去了。但是, 其中已经有一个 B 的实例在 Task 2 之中。 所以系统会将已有的 B 的实例赋予一个 **CLEAR_TOP** （清除顶部）标志。所以 C 是这么没的。

## 4\. SingleTask 小结

```

    if( 发现一个 Task 的 affinity == Activity 的 affinity ){
        if(此 Activity 的实例已经在这个 Task 中){
            这个 Activity 启动并且清除顶部的 Acitivity ，通过标识 CLEAR_TOP 
        } else {
            在这个 Task 中新建这个 Activity 实例
        }
    } else { // Task 的 affinity 属性值与 Activity 不一样
        新建一个 affinity 属性值与之相等的 Task
        新建一个 Activity 的实例并且将其放入这个 Task 之中
    }

```

## SingleInstance

SingleInstance 要比 SingleTask 好理解很多。

如果一个 Activity 的启动模式为 SingleInstance, 那么这个 Activity 必定会在一个新的 Task 之中, 并且这个 Task 之中有且只能有一个 Activity 。

再来一波栗子。

### 1\. A(default) –> B(singleInstance) –> C(default)

(1). A -> B

| Task 1 | Task 2 |
| :-: | :-: |
| A | B |

(2). A -> B -> C

拥有 “singleInstance” 启动模式的 activity 不予许其他任何 Activity 在它的 Task 之中。所以它是这个 Task 之中的独苗啊。当它跳转另外一个 activity 时, 那个 Activity 将会被分配到另外一个 Task 之中——就像是 intent 被赋予了 **FLAG_ACTIVITY_NEW_TASK** 标志一样。

由于 B 需要一个只能容纳它的 Task , 所以 C 会被加上一个 FLAG_ACTIVITY_NEW_TASK 标识。所以 C(default) 变成了 C(singleTask) 。

然后结果变成了这样:

| Task 1 | Task 2 |
| :-: | :-: |
| c A | B |

注：如果跳转的流程是 “A(default) –> B(singleTask) –> C(default)”, 那么结果会是这样：

| Task 1 | Task 2 |
| :-: | :-: |
| A | C B |

## 如何去运用启动模式呢？

假如, 你需要在 service 在后台中做一些耗时操作，当它完成时, 你需要从此 service 中跳转进入一个 Activity 中，你会怎样做？

Service 是 **Context** 一种扩展, 它含有 `startActivity(intent)` 方法。但是当你调用 `service.startActivity(intent)`时，你的程序必然会崩。报错如下：

```

            AndroidRuntimeException :   
                        "Calling startActivity() from outside of an Activity context 
                        requires the FLAG_ACTIVITY_NEW_TASK flag. 
                        Is this really what you want?"

```

这就是上文中提到的。当一个 Activity A 跳转进入另一个 Activity B (它们的启动模式都为默认的 default ), 所以这个 B 会和 A 在一个 Task 之中。但是当你想让 service 跳转到 Activity B, 由于 service 并不是一个 Activity , 所以它没有相关的 task 信息。所以 Service 不会出现在 Activity 的任务栈之中。这种情况下，Activity B 就不知道自己的 Task 在哪里了。

为了解决上述问题，我们可以告诉 Activity B 它应该在一个新的 Task 之中:

```

// "this" is a service
Intent it = new Intent(this, ActivityB.class); 
it.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
this.startActivity(it); 

```

瞅见没？这才是 Activity 的启动模式的正确打开方式。
