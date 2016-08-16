> * 原文地址：[Explain Activity Launch Mode With Examples](http://www.songzhw.com/2016/08/09/explain-activity-launch-mode-with-examples/)
* 原文作者：[songzhw](http://www.songzhw.com/author/songzhw2012gmail-com/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： 
* 校对者： 

## adb shell dumpsys activity

This command can give you a clear view of each task, like how many tasks do you have, which activities are in which task.

Now I have one picture of this command’s output.

![](http://i2.wp.com/www.songzhw.com/wp-content/uploads/2016/08/20160214_01.png?w=644)

From this output, we can see, now ,we have two Task (#103, #102).

Task #103 : affinity = “cn.six.task2”, size = 3 (it has three activities in it)

— Activity One    
— Activity Three    
— ActivityTwo    

Task #102 : affinity = “cn.six.adv”, size = 1

— Activity One

With this “adb shell dumpsys activity” command, we can explor the LaunchMode easier….

## Default

The Default system always creates a new instance of the activity in the target task and routes the intent to it.

“Default” is also the default mode when you assign no launch mode to an Activity, which means if you do not assign any launch mode to a Activity, then that Activity will be the “default” launch mode.

## SingleTop

If an instance of the “SingleTop” activity already exists at the top of the target task, the system routes the intent to that instance through a call to itsonNewIntent() method, rather than creating a new instance of the activity.

p.s. It’s **NOT** clear_top !!!

## SingleTask

This is the most tricky one, and I have to spend much more time to explain it. And examples are a good way to explain this complex launch mode.

## 1\. A(Default) -> B(singleTask)

We have two Activity, A and B, and A is default mode, B is singleTask mode. Now A jump to B.

The manifest is like this:

```

<manifest xmlns:android="http://schemas.android.com/apk/res/android" package="cn.six.adv">
    <Activity android:name=".A"/>
    <Activity android:name=".B" android:launchMode="singleTask"/>
</manifest>

```

Android documents says, “The system(SingleTask) creates the activity at the root of a new task and routes the intent to it”. So it must be like this, right?

| Task 1 | Task 2 |
| :-: | :-: |
| A | B |

But actually, when we run the “adb shell dumpsys activity”, we found out that B is strangely in the same task with A.

| Task 1 | Task 2 |
| :-: | :-: |
| B
A | (null) |

This is a little complex to explain, because it involves the `android:taskAffinity` attribute. I will explain this attribute later.

## 2\. A(Default) -> B(singleTask) : B has a taskAffinity attribute

The manifest is like this:

```

<manifest xmlns:android="http://schemas.android.com/apk/res/android" package="cn.six.adv">
    <activity android:name=".A"/>
    <activity android:name=".B" android:launchMode="singleTask" android:taskAffinity="task2"/>
</manifest>

```

I have to tell you, the result of A starting B is different. The tasks are like this:

| Task 1 | Task 2 |
| :-: | :-: |
| A | B |

The only difference between this and the previous example is the “android:taskAffinity”. When you announced no affinity, then activity has a default affinity value : their package name. In this case, the default affinity value is “cn.six.adv”.

When A starts B, and B’s launch mode is singleTask. So B **intents to** to create a new task. But it will create a new task as long as B’s taskAffinity is different from A’s taskAffinity.

So this explains the previous examle: why A and B are in the same task. Because their have a same taskAffinity.

The logic is like this:

```

A --> B

  if(taskAffinity is the same) { 
    A and B are in the same Task
  }
  else { 
    B is in other new task, whose affinity is B's affinity
  }

```

And Coming to this example, A starts B, and B’s launchMode is “singleTask”, and B’s taskAffinity is not “cn.six.adv”. So B will really create a new task, and B is in this new task.

| Task 1 (affinity=”cn.six.adv”) | Task 2 (affinity=”task2″) |
| --- | --- |
| A | B |

## 3\. A(default) -> B(singleTask) -> C(singleTask) -> B(singleTask)

The manifest is like this:

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

Since C’s affinity is “task2”, which is already the affinity of one task, so C will be put in the Task 2.

| Task 1 (affinity=”cn.six.adv”) | Task 2 (affinity=”task2″) |
| --- | --- |
| A | C B|

(3) A -> B -> C -> B

Firstly, I want to show you the result

| Task 1 (affinity=”cn.six.adv”) | Task 2 (affinity=”task2″) |
| --- | --- |
| A | B |

Weird, right? Where is C?

Let me explain it. C->B. B is singleTask and its affinity is “task2”, then the system find a task whose affinity is task2 and will put B in this Task 2\. However, an instance of B is already existing in the Task 2\. So the system will invoke the existing instance of B by give it a flag **CLEAR_TOP**. This is why C is not existing anymore.

## 4\. Conclusion of SingleTask

```

    if( found a task whose affinity == Activity's affinity){
        if(an instance of this Activity already exists in this task){
            start this activity with a CLEAR_TOP flag
        } else {
            create a new instance of this activity in this task
        }
    } else { // do not find a proper task
        create a new task, whose affinity is this activity's affinity
        create a new instance of this activity in this new task
    }

```

## SingleInstance

SingleInstance is much easier than SingleTask.

Once one Activity is SingleInstance, this Activity will definitly in one new task, and this task can only hold this one Activity and no other Activities any more.

Let me show some examples.

### 1\. A(default) –> B(singleInstance) –> C(default)

(1). A -> B

| Task 1 | Task 2 |
| :-: | :-: |
| A | B |

(2). A -> B -> C

A “singleInstance” activity permits no other activities to be part of its task. It’s the only activity in the task. If it starts another activity, that activity is assigned to a different task — as if **FLAG_ACTIVITY_NEW_TASK** was in the intent.

Since B requires a quiet task which can only take him, so C will be added a FLAG_ACTIVITY_NEW_TASK flag. So C(default) becomes C(singleTask).

So the result is like this:

| Task 1 | Task 2 |
| :-: | :-: |
| c A | B |

p.s, if the process is “A(default) –> B(singleTask) –> C(default)”, then the result is like this.

| Task 1 | Task 2 |
| :-: | :-: |
| A | C B |

## how to use these launch mode

For example, you need to do some time-consuming job in the background service. And when you are done, you need to jump to a Activity from this Service. How can you do this?

Yes, Service is an extension of **Context**, and it has `startActivity(intent)` method. But if you really call `service.startActivity(intent)`, you will definitely get a crash. The crash info is :

```

            AndroidRuntimeException :   
                        "Calling startActivity() from outside of an Activity context 
                        requires the FLAG_ACTIVITY_NEW_TASK flag. 
                        Is this really what you want?"

```

The reason is actually what I just mentioned above. Activity A jumps to Activity B (default launch mode), so the B will in the same task with A. Now you want service jump to Activity B, but service is not an Activity, so service has no information about its task. Service is not in the Activity Task Stack. In this case, Activity B will have no idea which task stack it should be.

So the way to fix it is to tell Activity B that it should be in a new task :

```

// "this" is a service
Intent it = new Intent(this, ActivityB.class); 
it.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
this.startActivity(it); 

```

See, this is an example of how to use launch mode in your real development life.
