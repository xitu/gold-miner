> * 原文地址：[Supercharging your app development speed with custom file templates](https://android.jlelse.eu/supercharging-your-app-development-speed-with-custom-file-templates-3e6acb6db6c3)
> * 原文作者：[Rajdeep Singh](https://android.jlelse.eu/@rajdeepsingh?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/supercharging-your-app-development-speed-with-custom-file-templates.md](https://github.com/xitu/gold-miner/blob/master/TODO1/supercharging-your-app-development-speed-with-custom-file-templates.md)
> * 译者：[nanjingboy](https://github.com/nanjingboy)
> * 校对者：[tuozhaobing](https://github.com/tuozhaobing)

# 使用自定义文件模板加快你的应用开发速度

![](https://cdn-images-1.medium.com/max/800/1*HAbuqnwz3oOVnoC18pAbQQ.png)

感谢：Google Inc.，维基共享资源和 [Vexels](https://www.vexels.com/vectors/preview/143495/yellow-lightning-bolt-icon)

在 [Wishfie](https://wishfie.com/) 开发 Android 应用时，我们经常需要编写大量的样板代码以用于创建新的 Activity 和 Fragment。我会举一个例子来说明我的意思：

当我们遵循 MVP 架构时，每个新增的 Activity 或 Fragment 都需要一个 Contract 类，一个 Presenter 类，一个 Dagger 模板及 Activity 类自身，这导致我们每次都需要编写大量的相似代码。

下面便是我们的 Activity、Module、Contract 和 Presenter：

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

这是 android 中常见的模式，很多人可能都在使用它。这就是我们所遇到的问题，它的解决方案来源于 Android Studio 中一个很棒的功能（自定义模板）。

在本文的最后，我们将创建一个根据不同后缀一次创建所有必须文件的模板。那么，让我们开始吧：

#### Android Studio 中的模板是什么？

![](https://cdn-images-1.medium.com/max/800/1*mhuRtb7tc-omJhG21orBtg.png)

Android Studio activity 创建模板

IntelliJ 描述如下：

> 文件模板是创建新文件时要生成的默认内容规范。根据你创建的文件类型，模板提供了在该类型文件中所预期的初始化代码和格式（根据行业标准，你的公司政策或其他内容）。

简单来说，模板用于创建包含一些样板代码的文件。大多数情况下，当你从预定义选项集中创建 Activity、Fragment 和 Service 等文件时，它已经为你编写了许多样板代码，这些代码基本上都是由 Android Studio 团队创建的一组预先编写好的模板创建的。例如，从上图显示菜单创建的 empty activity 默认包含以下样板代码，XML 文件以及 manifest 文件的入口配置。

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

#### 你能创建什么类型的模板？

1. 你可以创建 **.java**、**.xml**、**.cpp** 等类型的文件模板。

2. 你可以创建你自己的实时模板。如果你曾经用过 **Toast** 模板或用于定义 **public static final int** 的 **psfi**，这些被称为实时模板。

3. 你可以创建一组文件模板。比如，查看 Android Studio 如何为 Activity 创建 **.xml** 和 **.java** 文件，并且在 manifest 文件中添加该 activity 的详细信息。

#### 用什么语言创建模板？

使用 Apache [Velocity Template Language](http://velocity.apache.org) 创建这些模板。

#### 本文章节：

1.  我们将首先创建一个基本文件模板，该模板将创建一个 RecyclerView Adapter 以及一个内部 ViewHolder 类，因为它是最常用的类之一。

2.  我们将创建我们自己的实时模板。

3.  我们将通过编写用于创建上述 4 个文件的模板来结束此操作，以便在我们的应用中遵循 mvp 架构。

### 章节 1：

*   右键单击任何包目录，然后选择 **New** -> **Edit File Templates**。

![](https://cdn-images-1.medium.com/max/800/1*wNZih86oMFetOcKFTNzbdA.png)

*   单击 **+** 按钮创建一个新模板，并将其命名为你想要的任何名称。我将它命名为 RecyclerViewAdapter。

*   将下面的模板代码粘贴到名称字段下方的区域中。我会一步一步解释代码中发生了什么：

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

*   如果你快速阅读 android studio 中代码输入字段下面的 **Description** 面板，上面的大部分代码都很容易理解。

*   ${<VARIABLE_NAME>} 用于创建在整个模板中使用的变量，并且当你使用模板创建代码时，系统会提示你为它们输入值。这还有一些预定义的变量，比如 ${PACKAGE_NAME}，${DATE}等。

*   `#if` 指令用来检查包名是否为空，如果不为空，则将名称添加到作为 `${PACKAGE_NAME}` 变量传递的包语句中。

*   `#parse`  指令用于插入另一个名为 `File Header.java` 模板的内容，你可以在同一窗口的 includes 选项卡下找到该模板。看起来像这样：

![](https://cdn-images-1.medium.com/max/800/1*vfDxhq_L1UyLgBcaA1G1cw.png)

*   其余代码使用这些变量和静态文本，代码和注释来创建文件。

*   现在右键单击任何目录，然后单击 **New**，你将在那里找到你的模板。单击它将打开一个提示框，输入我们之前定义的占位符的值。

![](https://cdn-images-1.medium.com/max/800/1*I1grsNn29tB8FDyK9wwIGg.png)

![](https://cdn-images-1.medium.com/max/800/1*7wqct-BknCZ9WME6HP8p7Q.png)

*   以下是我们生成的模板：

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

使用我们的 Android Studio 模板生成文件。

### 章节 2：

*   这个章节与我们为 mvp 源文件创建模板的最终目的没什么关系，但知道 Android Studio 为我们提供的每个选项是有好处的。

*   实时模板是你在代码中快速获取代码段的快捷方式。你还可以添加参数来快速标记它们。

![](https://cdn-images-1.medium.com/max/800/1*xW6JeRcXOtmACPgJzZnsJA.gif)

在 Android Studio 中播放实时模板。

*   对于 mac 用户，导航到 **Android Studio -> Preferences -> Editor -> Live Templates**，在这里你将看到一个包含已有实时模板的列表框，比如 fbc 用于 findViewById 映射，foreach 用于创建 loop 等。

*   现在点击 **Android -> + ->LiveTemplate**，你可以选择添加缩写来使用模板，说明模板的功能以及模板的模板文本。

*   现在点击 **Define** 并选择弹框中的 XML 选项来选择模板可用的文件类型。

![](https://cdn-images-1.medium.com/max/800/1*ADiN8bCoe1F1vaXWq2xuYg.png)

Android Studio 中实时模版创建向导

*   单击确定保存并开始使用它。打开 XML 布局文件并开始输入 rv 并按 Tab 以适用新创建的模板。

![](https://cdn-images-1.medium.com/max/800/1*kYNihMp3L84Uq8nPEyA0gg.gif)

我们新创建的实时模板

### 章节 3：

Pheww！我们已经介绍了很多东西，现在是时候开始创建我们的 mvp 模板了。我们需要创建一个 Activity、DaggerModule、Contract 和 Presenter。前缀将作为用户输入，剩下的将采用本文开头所述的格式。

*   导航到你的 Windows/Linux/Mac 文件系统中的 Android Studio 目录，然后转到 **plugins -> android -> lib -> templates -> other**，用你希望在菜单中看到的名称创建一个空目录，我将其命名为 MVP Template。

*   在 mac 中，目录的位置应该为 **/Applications/Android/Studio.app/Contents/plugins/android/lib/templates/other/**，对于 windows 或 linux，你可以在 **{ANDROID_STUDIO_LOCATION}/plugins/android/lib/templates/other/** 中找到它。

*   确保检查模板中的 activities 目录，看看如何模板创建 EmptyActivity、BasicActivity 以及其他文件，这将有助于编写自己的模板。

*   现在，在新创建的 MVP Template 目录中，创建 **template.xml、recipe.xml.ftl** 和 **globals.xml.ftl**。并且创建一个名为 **root** 的目录，它将保存我们创建的实际模板文件。我将逐一解释每个文件的作用：

1.  **template.xml** — 它用来处理屏幕配置的 UI 部分。 它定义了用户在使用模板创建文件时看到的用户输入字段、复选框和下拉列表等。

2.  **recipe.xml.ftl** — 这是使用的文件，你的根目录中的模板将转换为 Android Studio 中真实的 java 文件。它包含有关要创建哪些文件以及从哪些模板创建等信息。

3.  **globals.xml.ftl** — 这包含所有全局变量。在这里为 src 和 res 定义目录路径是一个很好的做法。

*   在 template.xml 文件中，粘贴以下代码：

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

**template.xml** 描述了应该从用户那里获得的参数：

1.  **id** 是该元素的唯一 id。
2.  **name** 只是向用户显示的提示（就像在 EditText 中的提示一样）。
3.  **type** 定义用户应该显示文本输入还是下拉控件中的枚举值，或在布尔值的情况下显示复选框。
4.  **default** 用户输入为空时的默认值。
5.  **globals** 和 **execute** 属性链接我们的全局变量和配置文件。

*   在 recipe.xml.ftl 文件中，粘贴以下代码：

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

**recipe.xml.ftl** 定义从哪个模板创建哪些文件以及创建后打开哪些文件。它还可以将代码从我们的模板复制到 manifest.xml 或 string.xml 等文件中。请务必查看用于创建 activities 的默认模板示例。

**className** 变量是我们从用户那里获取的输入的 id，其代码用 template.xml 编写，**srcOut** 在 globals.xml.ftl 中定义。文件的其他部分具有很好的自我解释能力。

*   在 globals.xml.ftl 中：

```
<?xml version="1.0"?>
<globals>
 <global id="resOut" value="${resDir}" />
 <global id="srcOut" value="${srcDir}/${slashedPackageName(packageName)}" />
</globals>
```

*   现在，在根目录中，创建 **src/app_package/** 目录并将以下四个文件复制到该目录中：

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

这些文件包含将完全转换为 java 或 xml 代码的模板，参数将被实际值替换。

我们终于完成了所有步骤。只需要重启 Android Studio 即可启用此模板，并显示在菜单中。

![](https://cdn-images-1.medium.com/max/800/1*ZHFpf63w9bJV-UUoluzb3w.png)

我们新创建的 MVP 模板

![](https://cdn-images-1.medium.com/max/800/1*DufMHGSGcj1XUdAhza7jhw.png)

如果使用得当，Android Studio 模板是加快应用开发速度的强大功能。这些模板可以分布在整个 Android 团队中，以便简化样板代码的创建。

以上便是本文的所有内容。如果你喜欢这篇文章并发现它有用，请不要忘记点赞并与其他 Android 开发者分享它。Happy coding 💗。

**顺便说一句**，**我开通了每周简报** [**thedevweekly**](https://www.thedevweekly.com/)。 **我将通过网站、移动设备和系统上精心挑选文章，并在有关新技术学习及一些大科技公司内部学习文章之间取得平衡。**

因此，无论你是初学者还是专家，如果你正在寻找精心策划的科技文章的每周摘要，请在 [**这里**](https://www.thedevweekly.com/) 注册 **.**

* * *

### 参考资料：

*   [https://www.jetbrains.com/help/idea/using-file-and-code-templates.html](https://www.jetbrains.com/help/idea/using-file-and-code-templates.html)
*   [https://medium.com/google-developers/writing-more-code-by-writing-less-code-with-android-studio-live-templates-244f648d17c7](https://medium.com/google-developers/writing-more-code-by-writing-less-code-with-android-studio-live-templates-244f648d17c7)
*   [https://medium.com/androidstarters/mastering-android-studio-templates-ed8fdd98cb78](https://medium.com/androidstarters/mastering-android-studio-templates-ed8fdd98cb78)
*   [https://riggaroo.co.za/custom-file-templates-android-studio/](https://riggaroo.co.za/custom-file-templates-android-studio/)

*   [Android 应用开发](https://android.jlelse.eu/tagged/android-app-development?source=post)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
