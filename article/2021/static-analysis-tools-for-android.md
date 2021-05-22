> * 原文地址：[Static analysis tools for Android](https://proandroiddev.com/static-analysis-tools-for-android-9531334954f6)
> * 原文作者：[Cristopher Oyarzun](https://medium.com/@coyarzun)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/static-analysis-tools-for-android.md](https://github.com/xitu/gold-miner/blob/master/article/2021/static-analysis-tools-for-android.md)
> * 译者：
> * 校对者：

# Static analysis tools for Android

![Photo by [Zach Vessels](https://unsplash.com/@zvessels55?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/static?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/8966/1*rnX0nlbNDAkelzWjpkFHhA.jpeg)

Let’s take a look into the most popular static code analysis tools that you can use to implement and enforce custom rules in your codebase. Some of the benefit from using a linter. These benefits are: enforce standards programmatically, automate code quality and code maintenance.

In Android Studio you’re probably familiar with these kind of messages.

![](https://cdn-images-1.medium.com/max/2704/1*ToPnjqZ_4pONDNRAbb86PA.png)

You can write your own rules by using these tools:

* [Android Lint API](https://developer.android.com/studio/write/lint)
* [ktlint](https://github.com/pinterest/ktlint)
* [detekt](https://github.com/detekt/detekt)

We’ll describe the step by step process to write some rules on a demo project that you can find [here](https://github.com/coyarzun89/custom-lint-rules).

## Custom rules with Android Lint API

To start with, we’re going to write rules by using the Android Lint API. Some of the advantages are:

* You can write rules for Java, Kotlin, Gradle, XML and some other file types.
* No need to add plugins to make the warnings/errors visible on Android Studio
* Simpler integration with your project.

One of the disadvantages is this footnote on their repository [https://github.com/googlesamples/android-custom-lint-rules](https://github.com/googlesamples/android-custom-lint-rules)

> The lint API is not a final API; if you rely on this be prepared to adjust your code for the next tools release.

So, these are the steps to create our first rule:

1. Create a new module in your project where your custom rules will live in. We’ll call this module **android-lint-rules.**
2. Modify the **build.gradle** file on that module to something like this.

```Gradle
apply plugin: 'kotlin'
apply plugin: 'com.android.lint'


dependencies {
    compileOnly "com.android.tools.lint:lint-api:$lintVersion"

    testImplementation "com.android.tools.lint:lint:$lintVersion"
    testImplementation "com.android.tools.lint:lint-tests:$lintVersion"
}

jar {
    manifest {
        attributes("Lint-Registry-v2": "dev.cristopher.lint.DefaultIssueRegistry")
    }
}
```

Here we’re importing as a **compileOnly** the dependency that will allow us to write our custom rules **com.android.tools.lint:lint-api**. **You should also beware that here I’m using the** lint-api:27.2.0**, which is still on** beta**.

Here we also specify the **Lint-Registry-v2** which will point to the class that will contain the list of rules.

3. Write the first rule to avoid hardcoded colors on our layouts.

```Kotlin
@Suppress("UnstableApiUsage")
class HardcodedColorXmlDetector : ResourceXmlDetector() {

    companion object {
        val REGEX_HEX_COLOR = "#[a-fA-F\\d]{3,8}".toRegex()

        val ISSUE = Issue.create(
            id = "HardcodedColorXml",
            briefDescription = "Prohibits hardcoded colors in layout XML",
            explanation = "Hardcoded colors should be declared as a '<color>' resource",
            category = Category.CORRECTNESS,
            severity = Severity.ERROR,
            implementation = Implementation(
                HardcodedColorXmlDetector::class.java,
                Scope.RESOURCE_FILE_SCOPE
            )
        )
    }

    override fun getApplicableAttributes(): Collection<String>? {
        // Return the set of attribute names we want to analyze. The `visitAttribute` method
        // below will be called each time lint sees one of these attributes in a
        // XML resource file. In this case, we want to analyze every attribute
        // in every XML resource file.
        return XmlScannerConstants.ALL
    }

    override fun visitAttribute(context: XmlContext, attribute: Attr) {
        // Get the value of the XML attribute.
        val attributeValue = attribute.nodeValue
        if (attributeValue.matches(REGEX_HEX_COLOR)) {
            context.report(
                issue = ISSUE,
                scope = attribute,
                location = context.getValueLocation(attribute),
                message = "Hardcoded hex colors should be declared in a '<color>' resource."
            )
        }
    }
}
```

Depending on the rule that we want to implement, we’ll extend from a different **Detector** class. A detector is able to find a particular problem. Each problem type is uniquely identified as an **Issue**. In this case we’ll use a **ResourceXmlDetector** since we want to check for hardcoded hexadecimal colors in each xml resource.

After the class declaration we create all the information needed to define an **Issue**. Here we can specify the category and severity, along with the explanation that will be display in the IDE if the rule is triggered.

Then we need to specify the attributes that are going to be scanned. We can return a specific list of attributes like this **mutableListOf(“textColor”, “background”)** or we can return **XmlScannerConstants.ALL** to scan all the attributes on each layout. That’ll depend on your use case.

Finally we have to add the logic needed to decide if that attribute is an hexadecimal color, so we can raise a report.

4. Create a class called **DefaultIssueRegistry** that extends **IssueRegistry.** Then you need to override the **issues** variable and list all of them.

If you are going to create more rules, you need to add all of them here.

```Kotlin
class DefaultIssueRegistry : IssueRegistry() {
    override val issues = listOf(
        HardcodedHexColorXmlDetector.ISSUE
    )

    override val api: Int
        get() = CURRENT_API
}

```

5. To check that the rule is doing their job correctly we’re going to implement some tests. We need to have on our **build.gradle** these two dependencies as **testImplementation**: **com.android.tools.lint:lint-tests** and **com.android.tools.lint:lint.** Those will allow us to define a xml file right in the code and scan their content to see if the rule is working fine.

1. The first test check if our rule still works if we’re using a custom property. So the TextView will contain a property called **someCustomColor** with the color **#fff**. Then, we can add several issues to scan the mock file, in our case we just specify our only written rule. Finally we say that the expected result should be 1 issue with an error severity.
2. In the second test the behavior is really similar. The only change is that we’re testing our rule with a normal property and the hexadecimal color is including the alpha transparency.
3. In the last test we check that our rule doesn’t raise any error if we specify a color by using our resources. In that case we set a text color with **@color/primaryColor** and the expected result is a clean execution.

```Kotlin
class HardcodedColorXmlDetectorTest {

    @Test
    fun `Given a hardcoded color on a custom text view property, When we analyze our custom rule, Then display an error`() {
        lint()
            .files(
                xml(
                    "res/layout/layout.xml",
                    """
                    <TextView xmlns:app="http://schemas.android.com/apk/res-auto"
                    app:someCustomColor="#fff"/>
                    """
                ).indented()
            )
            .issues(HardcodedColorXmlDetector.ISSUE)
            .allowMissingSdk()
            .run()
            .expectCount(1, Severity.ERROR)
    }

    @Test
    fun `Given a hardcoded color on a text view, When we analyze our custom rule, Then display an error`() {
        lint()
            .files(
                xml(
                    "res/layout/layout.xml",
                    """
                        <TextView xmlns:android="http://schemas.android.com/apk/res/android"
                            android:textColor="#80000000"/>
                        """
                ).indented()
            )
            .issues(HardcodedColorXmlDetector.ISSUE)
            .allowMissingSdk()
            .run()
            .expectCount(1, Severity.ERROR)
    }

    @Test
    fun `Given a color from our resources on a text view, When we analyze our custom rule, Then expect no errors`() {
        lint()
            .files(
                xml(
                    "res/layout/layout.xml",
                    """
                        <TextView xmlns:android="http://schemas.android.com/apk/res/android"
                            android:textColor="@color/primaryColor"/>
                        """
                ).indented()
            )
            .issues(HardcodedColorXmlDetector.ISSUE)
            .allowMissingSdk()
            .run()
            .expectClean()
    }
}

```

6. Now in the **app module**, where we want to apply all these rules, we’re going to add this line to the **build.gradle** file:

```
dependencies {
       lintChecks project(':android-lint-rules')
    ....
}
```

And that’s it! If we try to set a hardcoded color in any layout an error will be prompt 🎉

![](https://cdn-images-1.medium.com/max/3200/1*VeAC6BcQlTP0dm7WKOhajw.png)

This repository can be a good source if you need more ideas to add some custom rules [https://github.com/vanniktech/lint-rules](https://github.com/vanniktech/lint-rules)

## Custom rules with ktlint

ktlint define itself as an anti-bikeshedding Kotlin linter with built-in formatter. One of the coolest things is that you can write your rules along with a way to autocorrect the issue, so the user can easily fix the problem. One of the disadvantages is that it’s specifically for Kotlin, so you can’t write rules for XML files, as we previously did. Also if you want to visualize the issues on Android Studio, you need to install a plugin. I’m using this one [https://plugins.jetbrains.com/plugin/15057-ktlint-unofficial-](https://plugins.jetbrains.com/plugin/15057-ktlint-unofficial-)

So, in this case we’re going to enforce a rule about Clean Architecture. Probably, you have heard that we shouldn’t expose our models from the data layer in our domain or presentation layers. Some people add a prefix on each model from the data layer to make them easy to identify. In this case we want to check that every model which is part of a package ended on **data.dto** should have a prefix **Data** in their name.

These are the steps to write a rule using ktlint:

1. Create a new module where your custom rules will live in. We’ll call this module **ktlint-rules**
2. Modify the **build.gradle** file on that module:

```Gradle
plugins {
    id 'kotlin'
}

dependencies {
    compileOnly "com.github.shyiko.ktlint:ktlint-core:$ktlintVersion"

    testImplementation "junit:junit:$junitVersion"
    testImplementation "org.assertj:assertj-core:$assertjVersion"
    testImplementation "com.github.shyiko.ktlint:ktlint-core:$ktlintVersion"
    testImplementation "com.github.shyiko.ktlint:ktlint-test:$ktlintVersion"
}
```

3. Write a rule to enforce the use of a prefix (**Data**) in all the models inside a package name ending on **data.dto.**

First we need to extend the **Rule** class that ktlint provide for us and specify an id for your rule.

Then we override the **visit** function. Here we’re going to set some conditions to detect that the package ends with **data.dto** and verify if the classes inside that file has the prefix **Data**. If the classes doesn’t have that prefix, then we’re going to use the emit lambda to trigger the report and we’ll also offer a way to fix the problem.

```Kotlin
class PrefixDataOnDtoModelsRule : Rule("prefix-data-on-dto-model") {

    companion object {
        const val DATA_PREFIX = "Data"
        const val IMPORT_DTO = "data.dto"
    }

    override fun visit(
        node: ASTNode,
        autoCorrect: Boolean,
        emit: (offset: Int, errorMessage: String, canBeAutoCorrected: Boolean) -> Unit
    ) {
        if (node.elementType == ElementType.PACKAGE_DIRECTIVE) {
            val qualifiedName = (node.psi as KtPackageDirective).qualifiedName
            if (qualifiedName.isEmpty()) {
                return
            }

            if (qualifiedName.endsWith(IMPORT_DTO)) {
                node.treeParent.children().forEach {
                    checkClassesWithoutDataPrefix(it, autoCorrect, emit)
                }
            }
        }
    }

    private fun checkClassesWithoutDataPrefix(
        node: ASTNode,
        autoCorrect: Boolean,
        emit: (offset: Int, errorMessage: String, canBeAutoCorrected: Boolean) -> Unit
    ) {
        if (node.elementType == ElementType.CLASS) {
            val klass = node.psi as KtClass
            if (klass.name?.startsWith(DATA_PREFIX, ignoreCase = true) != true) {
                emit(
                    node.startOffset,
                    "'${klass.name}' class is not using " +
                        "the prefix Data. Classes inside any 'data.dto' package should " +
                        "use that prefix",
                    true
                )
                if (autoCorrect) {
                    klass.setName("$DATA_PREFIX${klass.name}")
                }
            }
        }
    }
}

```

4. Create a class called **CustomRuleSetProvider** that extends **RuleSetProvider.** Then you need to override the **get()** function and list all your rules there.

```Kotlin
class CustomRuleSetProvider : RuleSetProvider {
    private val ruleSetId: String = "custom-ktlint-rules"

    override fun get() = RuleSet(ruleSetId, PrefixDataOnDtoModelsRule())
}

```

5. Create a file in the folder **resources/META-INF/services**. This file must contain the path to the class created on the step 4.

![](https://cdn-images-1.medium.com/max/6592/1*Des3IkNn0cqX_uSBHNSTgg.png)

6. Now in our project we’re going to add this module, so the rules can be applied. Also we created a task to execute ktlint and generate a report:

```
configurations {
    ktlint
}

dependencies {
    ktlint "com.github.shyiko:ktlint:$ktlintVersion"
    ktlint project(":ktlint-rules")
    ...
}

task ktlint(type: JavaExec, group: "verification", description: "Runs ktlint.") {
    def outputDir = "${project.buildDir}/reports/ktlint/"

    main = "com.github.shyiko.ktlint.Main"
    classpath = configurations.ktlint
    args = [
            "--reporter=plain",
            "--reporter=checkstyle,output=${outputDir}ktlint-checkstyle-report.xml",
            "src/**/*.kt"
    ]

    inputs.files(
            fileTree(dir: "src", include: "**/*.kt"),
            fileTree(dir: ".", include: "**/.editorconfig")
    )
    outputs.dir(outputDir)
}
```

7. I also highly recommend to install this plugin so you can be notified in the same Android Studio about any errors found.

![](https://cdn-images-1.medium.com/max/4436/1*bzBNZqnlPF4WR7k-zH6eiA.png)

To see your custom rules in Android Studio you need to generate a jar from your module and add that path in the external rulset JARs like this:

![](https://cdn-images-1.medium.com/max/4436/1*GSevjiWQufDEf3cmZMvtLg.png)

## Custom rules with detekt

detekt is a static code analysis tool for the **Kotlin** programming language. It operates on the abstract syntax tree provided by the Kotlin compiler. Their focus is find code smells, although you can also use it as a formatting tool.

If you want to visualize the issues on Android Studio, you need to install a plugin. I’m using this one [https://plugins.jetbrains.com/plugin/10761-detekt](https://plugins.jetbrains.com/plugin/10761-detekt)

The rule that we’re going to implement will enforce the use of a specific prefix for the Repository implementations. It’s just to show that we can create a custom standard in our project. In this case if we have a **ProductRepository** interface, we want that the implementation use the prefix **Default** instead of the suffix **Impl.**

The steps to write a rule using detekt are:

1. Create a new module where your custom rules will live in. We’ll call this module **detekt-rules**
2. Modify the **build.gradle** file on that module:

```Gradle
plugins {
    id 'kotlin'
}

dependencies {
    compileOnly "io.gitlab.arturbosch.detekt:detekt-api:$detektVersion"

    testImplementation "junit:junit:$junitVersion"
    testImplementation "org.assertj:assertj-core:$assertjVersion"
    testImplementation "io.gitlab.arturbosch.detekt:detekt-api:$detektVersion"
    testImplementation "io.gitlab.arturbosch.detekt:detekt-test:$detektVersion"
}

```

3. Write a rule to enforce the use of a prefix (**Default**) in all the repository implementations.

First we need to extend the **Rule** class that detekt provide for us. Also we need to override the issue class member and specify name, type of issue, description and how much time it requires to solve the problem.

Then we override the **visitClassOrObject** function. Here we check for each implementation of each class. If some of these ends in the keyword **Repository**, then we’re going to verify if the class name doesn’t start with our prefix. Inside that condition we will report the problem as a **CodeSmell.**

```Kotlin
class PrefixDefaultOnRepositoryRule(config: Config = Config.empty) : Rule(config) {

    companion object {
        const val PREFIX_REPOSITORY = "Default"
        const val REPOSITORY_KEYWORD = "Repository"
    }
    override val issue: Issue = Issue(
        javaClass.simpleName,
        Severity.Style,
        "Use the prefix Default on every 'XXXRepository' implementations.",
        Debt.FIVE_MINS
    )

    override fun visitClassOrObject(classOrObject: KtClassOrObject) {
        for (superEntry in classOrObject.superTypeListEntries) {
            if (superEntry.text.endsWith(REPOSITORY_KEYWORD) &&
                classOrObject.name?.contains(REPOSITORY_KEYWORD) == true &&
                classOrObject.name?.startsWith(PREFIX_REPOSITORY) == false
            ) {
                report(
                    classOrObject,
                    "The repository implementation '${classOrObject.name}' needs to start with the prefix 'Default'."
                )
            }
        }
    }

    private fun report(classOrObject: KtClassOrObject, message: String) {
        report(CodeSmell(issue, Entity.atName(classOrObject), message))
    }
}

```

The next steps are pretty similar to the ones on ktlint.

4. Create a class called **CustomRuleSetProvider** that extends **RuleSetProvider.** Then you need to override the **ruleSetId()** and the **instance(config: Config)** functions and list all your rules there.

```Kotlin
class CustomRuleSetProvider : RuleSetProvider {

    override val ruleSetId: String = "custom-detekt-rules"

    override fun instance(config: Config) =
        RuleSet(ruleSetId, listOf(PrefixDefaultOnRepositoryRule(config)))
}
```

5. Create a file in the folder **resources/META-INF/services**. This file must contain the path to the class created on the step 4.

![](https://cdn-images-1.medium.com/max/6592/1*Des3IkNn0cqX_uSBHNSTgg.png)

6. Now in our project we’re going to add this module, so the rules can be applied. To use detekt in your project you also need to a yaml style configuration file. You can get the default configuration from the same detekt repository [here](https://github.com/detekt/detekt/blob/main/detekt-core/src/main/resources/default-detekt-config.yml).

```
detekt {
    input = files("$rootDir/app/src")
    config = files("$rootDir/app/config/detekt.yml")
}

dependencies {
    detektPlugins "io.gitlab.arturbosch.detekt:detekt-cli:$detektVersion"
    
    detektPlugins project(path: ':detekt-rules')
    ...
}
```

7. I also highly recommend to install this plugin so you can be notified in the same Android Studio about any errors found.

![](https://cdn-images-1.medium.com/max/4436/1*bzBNZqnlPF4WR7k-zH6eiA.png)

To see your custom rules in Android Studio you need to generate a jar from your module and add that path in the external rulset JARs like this:

![](https://cdn-images-1.medium.com/max/4436/1*ixNVSRgIr996lB8YtIob1w.png)

And that’s it! Now you can see your custom rule applied 🎉

![](https://cdn-images-1.medium.com/max/4288/1*jSPXuDQnZRVwFBNqRqG_eA.png)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
