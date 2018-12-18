> * 原文地址：[Supercharging your app development speed with custom file templates](https://android.jlelse.eu/supercharging-your-app-development-speed-with-custom-file-templates-3e6acb6db6c3)
> * 原文作者：[Rajdeep Singh](https://android.jlelse.eu/@rajdeepsingh?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/supercharging-your-app-development-speed-with-custom-file-templates.md](https://github.com/xitu/gold-miner/blob/master/TODO1/supercharging-your-app-development-speed-with-custom-file-templates.md)
> * 译者：
> * 校对者：

# Supercharging your app development speed with custom file templates

![](https://cdn-images-1.medium.com/max/800/1*HAbuqnwz3oOVnoC18pAbQQ.png)

Credits : Google Inc. , via Wikimedia Commons and [Vexels](https://www.vexels.com/vectors/preview/143495/yellow-lightning-bolt-icon)

While working on the android app at [Wishfie](https://wishfie.com/), we often had to write a lot of boilerplate code for creation of each of our new Activity and Fragment. I’ll give you an example of what i mean:

As we were following MVP architecture, each of our new Activity or Fragment required a Contract class, a Presenter class, a Dagger module and the Activity class itself and that was a lot of boilerplate code to be written every time.

This is what our Activity, Module, Contract and Presenter looked like:

```
public class DemoActivity extends DemoBaseActivity<DemoContract.Presenter> implements DemoContract.View {
  
    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_demo);
    }
  
}
```

```
@Module
public abstract class DemoActivityModule {
    @Binds
    @PerActivity
    abstract DemoContract.Presenter providesPresenter(DemoPresenter demoPresenter);

    @Binds
    @PerActivity
    abstract DemoContract.View providesView(DemoActivity demoActivity);
}
```

```
public interface DemoContract {
    interface View extends DemoBaseContract.ActivityView {
      
    }

    interface Presenter extends DemoBaseContract.Presenter {
    
    }
}
```

```
public class DemoPresenter extends DemoBasePresenter<DemoContract.View> implements DemoContract.Presenter {

    @Inject
    public DemoPresenter(DemoContract.View view) {
        super(view);
    }

    @Override
    public void unSubscribe() {

    }

    @Override
    public void subscribe() {

    }
}
```

That’s a common pattern in android and many of you might be using the same. So that was the problem statement we had and the solution came from reading about this awesome feature of Android Studio known as Custom template.

By the end of this article, we will create a template to create all of these files in just one click every time with different suffixes. So, let’s begin:

#### What are templates in Android Studio?

![](https://cdn-images-1.medium.com/max/800/1*mhuRtb7tc-omJhG21orBtg.png)

Android Studio activity creation template

According to IntelliJ:

> File templates are specifications of the default contents to be generated when creating a new file. Depending on the type of file you are creating, templates provide initial code and formatting that is expected to be in all files of that type (according to industry standards, your corporate policy, or for other reasons).

In short, templates are used to create files that already contains some boilerplate code for you. Most of the time when you create an Activity, Fragment, Service, etc from the set of pre defined options, a lot of boilerplate code is already written for you, which basically is created from a set of prewritten templates created by the Android Studio team. For example, an empty activity created from above shown menu consists of the following boilerplate code by default along with an XML file and an entry into manifest file.

```
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

public class EmptyActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main2);
    }
}
```

#### What type of templates can you create?

1.  You can create **.java**, **.xml**, **.cpp**, etc type file templates.

2.  You can create your own live templates. If you’ve ever used **Toast** template or **psfi** for **public static final int**, those are known as live templates.

3.  You can create a group of file templates. For example, see how the Android Studio creates and **.xml** and **.java** file for Activity as well as enter the details of that created activity in our manifest file.

#### What language is used for template creation?

Apache [Velocity Template Language](http://velocity.apache.org) is used for creating these templates.

#### Pitstops in this tutorial:

1.  We’ll begin with creating a basic file template that will create a RecyclerView Adapter along with an inner ViewHolder class, as it is one of the most frequently used class.

2.  We will create our own live template.

3.  We will end this by writing a template for creation of above mentioned 4 files to follow mvp pattern in our app.

### Pitstop 1:

*   Right click on any of the package folder, and then **New** -> **Edit File Templates.**

![](https://cdn-images-1.medium.com/max/800/1*wNZih86oMFetOcKFTNzbdA.png)

*   Click on the **+** button to create a new template and name it anything you want. I am going to name it RecyclerViewAdapter.

*   Paste the following template code in the area below Name field. I’ll go step by step and explain what is going on in code:

```
#if (${PACKAGE_NAME} && ${PACKAGE_NAME} != "")package ${PACKAGE_NAME};#end

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import java.util.List;

#parse("File Header.java")
public class ${NAME} extends RecyclerView.Adapter<${VIEWHOLDER_CLASS}> {
    private final Context context;
    private List<${ITEM_CLASS}> items;
   
    public ${NAME}(List<${ITEM_CLASS}> items, Context context) {
        this.items = items;
        this.context = context;
    }

    @Override
    public ${VIEWHOLDER_CLASS} onCreateViewHolder(ViewGroup parent,
                                             int viewType) {
        View v = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.${LAYOUT_RES_ID}, parent, false);
        return new ${VIEWHOLDER_CLASS}(v);
    }

    @Override
    public void onBindViewHolder(${VIEWHOLDER_CLASS} holder, int position) {
        ${ITEM_CLASS} item = items.get(position);
        holder.set(item);
    }

    @Override
    public int getItemCount() {
        if (items == null){
            return 0;
        }
        return items.size();
    }
    
    public class ${VIEWHOLDER_CLASS} extends RecyclerView.ViewHolder {

        public ${VIEWHOLDER_CLASS}(View itemView) {
            super(itemView);
        }

        public void set(${ITEM_CLASS} item) {
            //UI setting code
        }
    }
 }
```

*   If you give a quick read to the **Description** panel below the code input field in android studio, most of the above code will be easy to understand.

*   ${<VARIABLE_NAME>} is used to create variables which are used throughout the template and you are prompted to enter values for them when you use the template to create code. There are also some predefined variables such as ${PACKAGE_NAME}, ${DATE}, etc.

*   The `#if` directive is used to check whether the package name is not empty, and if so, add the name to the package statement passed as the `${PACKAGE_NAME}` variable.

*   The `#parse` directive is used to insert the contents of another template named `File Header.java` which you can find under includes tab in the same window. Yours might look like:

![](https://cdn-images-1.medium.com/max/800/1*vfDxhq_L1UyLgBcaA1G1cw.png)

*   The rest of the code uses these variables and static text, code and comments to create the file.

*   Now right click any folder, then click **New** and you will find your template right there. Clicking on that will open up a prompt box to enter the value for placeholders we had defined earlier.

![](https://cdn-images-1.medium.com/max/800/1*I1grsNn29tB8FDyK9wwIGg.png)

![](https://cdn-images-1.medium.com/max/800/1*7wqct-BknCZ9WME6HP8p7Q.png)

*   This is what our generated template looks like:

```
package io.github.rajdeep1008.templatedemo;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import java.util.List;

public class SchoolData extends RecyclerView.Adapter<SchoolData> {
    private final Context context;
    private List<SchoolItem> items;

    public SchoolData(List<SchoolItem> items, Context context) {
        this.items = items;
        this.context = context;
    }

    @Override
    public SchoolData onCreateViewHolder(ViewGroup parent,
                                         int viewType) {
        View v = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.R.layout.item_school, parent, false);
        return new SchoolData(v);
    }

    @Override
    public void onBindViewHolder(SchoolData holder, int position) {
        SchoolItem item = items.get(position);
        holder.set(item);
    }

    @Override
    public int getItemCount() {
        if (items == null) {
            return 0;
        }
        return items.size();
    }

    public class SchoolData extends RecyclerView.ViewHolder {

        public SchoolData(View itemView) {
            super(itemView);
        }

        public void set(SchoolItem item) {
            //UI setting code
        }
    }
}
```

File generated using our Android Studio template.

### Pitstop 2:

*   This pitstop has nothing much to do with our end goal of creating template for mvp source files, but it’s nice to know about each of the option Android Studio provides us with.

*   Live templates are shortcuts that you can use in your code to quickly get code snippets. You can also add arguments to quickly tab through them.

![](https://cdn-images-1.medium.com/max/800/1*xW6JeRcXOtmACPgJzZnsJA.gif)

Toast live templates in Android Studio

*   For mac users, go to **Android Studio -> Preferences -> Editor -> Live Templates.** Here, you’ll see a box containing all the existing live templates, like fbc for findViewById cast, foreach for loop creation, etc.

*   Now, click on **Android -> + ->LiveTemplate.** You’ll get an option to add an abbreviation to use the template, a description about what your template does and the template text for your template.

*   Select the type of files your template will be available in by selecting the **Define** option and select XML for now.

![](https://cdn-images-1.medium.com/max/800/1*ADiN8bCoe1F1vaXWq2xuYg.png)

Live template creation wizard in Android Studio

*   Click ok to save it and start using it. Open your layout XML file and start typing rv and press tab to use your newly created template.

![](https://cdn-images-1.medium.com/max/800/1*kYNihMp3L84Uq8nPEyA0gg.gif)

Our newly created live template in action

### Pitstop 3:

Pheww!! We have covered a lot of things and now it’s time to start with creating our mvp template. We need to create an Activity, DaggerModule, Contract and Presenter. The prefix will be taken as user input and rest will be in format as described during the beginning of this article.

*   Navigate to Android Studio folder in your Windows/Linux/Mac file system and go to **plugins -> android -> lib -> templates -> other. C**reate an empty folder with name that you’d like to see in the menu. I’ll name it MVP Template.

*   In mac, the location for folder should be **/Applications/Android/Studio.app/Contents/plugins/android/lib/templates/other/** and for windows or linux, you can find it at **{ANDROID_STUDIO_LOCATION}/plugins/android/lib/templates/other/**

*   Be sure to checkout the activities folder in templates to see how EmptyActivity, BasicActivity and others are created through templates, it will help a lot in writing your own templates.

*   Now, in the newly created MVP Template folder, create **template.xml, recipe.xml.ftl** and **globals.xml.ftl**. Also, create a folder named **root** which will hold our actual template files. I’ll explain what each of these files do one by one:

1.  **template.xml **— This handles the UI part of the configuration screen. It defines the user input fields, checkboxes, dropdowns, etc that the user see while using template to create files.

2.  **recipe.xml.ftl **— This is the file using which, your templates from root folder are converted to actual java files in Android Studio. It contains information about what files are to be created and from what templates and so on.

3.  **globals.xml.ftl** — This contain all the global variables. Its a good practice to define variables for src and res directory path in here.

*   In template.xml, paste the following code:

```
<template format="4"
        revision="1"
        name="MVP Template Activity"
        description="Creates a new MVP classes - Presenter, View, Contract and Dagger Module.">

    <category value="Other"/>

    <parameter id="className"
        name="Functionality Name"
        type="string"
        constraints="class|unique|nonempty"
        default="MvpDemo"
        help="The name of the functionality that requires MVP views"/>

    <globals file="globals.xml.ftl" />
    <execute file="recipe.xml.ftl" />

</template>
```

**template.xml** describes the parameters that should be asked from the user :

1.  **id** is the unique id for that element.
2.  **name** is nothing but a hint (just like hint in EditText) that is shown to user.
3.  **type** defines whether user should be shown a text input or spinner in case of enum or a checkbox in case of boolean.
4.  **default** is the default value in case user leaves the input empty.
5.  **globals** and **execute** attributes links our globals and recipe files.

*   In recipe.xml.ftl, paste this:

```
<?xml version="1.0"?>
<recipe>

    <instantiate from="src/app_package/Contract.java.ftl"
                   to="${escapeXmlAttribute(srcOut)}/${className}Contract.java" />
    <instantiate from="src/app_package/Activity.java.ftl"
                   to="${escapeXmlAttribute(srcOut)}/${className}Activity.java" />
    <instantiate from="src/app_package/Presenter.java.ftl"
                   to="${escapeXmlAttribute(srcOut)}/${className}Presenter.java" />
    <instantiate from="src/app_package/ActivityModule.java.ftl"
                   to="${escapeXmlAttribute(srcOut)}/${className}ActivityModule.java" />


    <open file="${srcOut}/${className}Presenter.java"/>
    <open file="${srcOut}/${className}Contract.java"/>
    <open file="${srcOut}/${className}Activity.java"/>
    <open file="${srcOut}/${className}ActivityModule.java"/>
</recipe>
```

**recipe.xml.ftl** defines what files should be created from which template and what files should be opened after the creation. It can also copy code from our templates to existing files like manifest.xml or string.xml and so on. Be sure to checkout the default template examples for creating activities.

**className** variable is the id of input we took from the user, the code for that is written in template.xml and **srcOut** is defined in globals.xml.ftl. The rest of file is pretty self explanatory.

*   In globals.xml.ftl :

```
<?xml version="1.0"?>
<globals>
 <global id="resOut" value="${resDir}" />
 <global id="srcOut" value="${srcDir}/${slashedPackageName(packageName)}" />
</globals>
```

*   Now, in root folder, create **src/app_package/** folder and paste these four files in it :

```
package ${packageName};

public class ${className}Activity extends DemoBaseActivity<${className}Contract.Presenter> implements ${className}Contract.View {
    
    @Override
    protected void onCreate(final Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_demo);
    }

}
```

```
package ${packageName};

@Module
public abstract class ${className}ActivityModule {
    @Binds
    @PerActivity
    abstract ${className}Contract.Presenter providesPresenter(${className}Presenter presenter);

    @Binds
    @PerActivity
    abstract ${className}Contract.View providesView(${className}Activity activity);
}
```

```
package ${packageName};

public interface ${className}Contract{
    
    interface View extends DemoBaseContract.ActivityView {

    }

    interface Presenter extends DemoBaseContract.Presenter {

    }
}
```

```
package ${packageName};

public class ${className}Presenter extends DemoBasePresenter<${className}Contract.View> implements ${className}Contract.Presenter {

    @Inject
    public ${className}Presenter(${className}Contract.View view){
        super(view);
    } 

    @Override
    public void subscribe() {

    }

    @Override
    public void unSubscribe() {

    }
}
```

These files contain the templates which will be converted exactly to java or xml codes and the arguments will be replaced by their actual values.

And we’re finally done with all the steps. Just restart the Android Studio for this template to come into action and become available in the menu.

![](https://cdn-images-1.medium.com/max/800/1*ZHFpf63w9bJV-UUoluzb3w.png)

Our newly created MVP template

![](https://cdn-images-1.medium.com/max/800/1*DufMHGSGcj1XUdAhza7jhw.png)

If used properly, Android Studio templating is a powerful feature to speed up the app development process. These templates can be spread across your whole android team to ease the boilerplate code creation.

That’s all folks. If you liked the article and found it useful, don’t forget to clap and share this article with other android devs. Happy coding 💗.

**By the way**, **i am starting with a weekly newsletter** [**thedevweekly**](https://www.thedevweekly.com/) **where i will handpick articles across web, mobile and systems and will balance out articles about learning new technologies as well as learning insides of the tech stack from some of the biggest tech companies.**

So, if you are a beginner dev or an experienced one and looking for a weekly digest of nicely curated tech articles, sign up [**here**](https://www.thedevweekly.com/)**.**

* * *

### References:

*   [https://www.jetbrains.com/help/idea/using-file-and-code-templates.html](https://www.jetbrains.com/help/idea/using-file-and-code-templates.html)
*   [https://medium.com/google-developers/writing-more-code-by-writing-less-code-with-android-studio-live-templates-244f648d17c7](https://medium.com/google-developers/writing-more-code-by-writing-less-code-with-android-studio-live-templates-244f648d17c7)
*   [https://medium.com/androidstarters/mastering-android-studio-templates-ed8fdd98cb78](https://medium.com/androidstarters/mastering-android-studio-templates-ed8fdd98cb78)
*   [https://riggaroo.co.za/custom-file-templates-android-studio/](https://riggaroo.co.za/custom-file-templates-android-studio/)

*   [Android App Developmen](https://android.jlelse.eu/tagged/android-app-development?source=post)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
