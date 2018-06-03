> * 原文地址：[Test Driving away Coupling in Activities](https://www.philosophicalhacker.com/post/test-driving-away-coupling-in-activities/)
> * 原文作者：[philosohacker](https://twitter.com/philosohacker)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[mnikn](https://github.com/mnikn)
> * 校对者：[phxnirvana](https://github.com/phxnirvana)，[stormrabbit](https://github.com/stormrabbit)

# 通过测试来解耦Activity

`Activity` 和 `Fragment`，可能是因为一些[奇怪的历史巧合](https://www.philosophicalhacker.com/post/why-android-testing-is-so-hard-historical-edition/)，从 Android 推出之时起就被视为构建 Android 应用的**最佳**构件。我们把`Activity` 和 `Fragment` 是应用的最佳构件这种想法称为“android-centric”架构。

本系列博文是关于 android-centric 架构的可测试性和其它问题之间的联系的，而这些问题正导致 Android 开发者们排斥这种架构。这些博文也涉及单元测试怎样试图告诉我们：`Activity` 和 `Fragment` 不是应用的最佳构件，因为它们迫使我们写出**高耦合**和**低内聚**的代码。


[上次](https://www.philosophicalhacker.com/post/what-unit-tests-are-trying-to-tell-us-about-activities-pt-2/)，我们发现`Activity` 和 `Fragment`有低内聚的倾向。这次，通过测试我们将会发现 `Activity` 是高耦合的。我们还会发现如何通过测试来驱使实现一个耦合度更低的设计，这样我们就能轻易地改变应用和有更多的机会来减去重复代码。像本系列博文中的其他文章一样，我们依然以 Google I/O 应用为例子进行探讨。

### 目标代码

我们想要测试的“目标代码”，做了以下工作：当用户进入展示所有 Google I/O session 的地图界面时，app 会请求当前位置。如果用户拒绝提供定位权限，我们会弹出一个 toast 来提示用户已禁用此权限。这是其中的截图：

![拒绝请求的 toast](https://www.philosophicalhacker.com/images/permission-denied-snackbar.png)

这是实现代码：

```
@Override
public void onRequestPermissionsResult(final int requestCode,
        @NonNull final String[] permissions,
        @NonNull final int[] grantResults) {

    if (requestCode != REQUEST_LOCATION_PERMISSION) {
        return;
    }

    if (permissions.length == 1 &&
            LOCATION_PERMISSION.equals(permissions[0]) &&
            grantResults[0] == PackageManager.PERMISSION_GRANTED) {
        // Permission has been granted.
        if (mMapFragment != null) {
            mMapFragment.setMyLocationEnabled(true);
        }
    } else {
        // Permission was denied. Display error message.
        Toast.makeText(this, R.string.map_permission_denied,
                Toast.LENGTH_SHORT).show();
    }
    super.onRequestPermissionsResult(requestCode, permissions,
            grantResults);
}
```

### 测试代码 

让我们尝试测试下这些代码，我们的测试代码看起来是这样的：

```
@Test
public void showsToastIfPermissionIsRejected()
        throws Exception {
    MapActivity mapActivity = new MapActivity();

    mapActivity.onRequestPermissionsResult(
            MapActivity.REQUEST_LOCATION_PERMISSION,
            new String[]{MapActivity.LOCATION_PERMISSION}, new int[]{
                    PackageManager.PERMISSION_DENIED});

    assertToastDisplayed();
}
```

当然你很希望能知道 `assertToastDisplayed()` 是怎么实现的。重点来了：我们不会直接实现该方法。为了避免实现后再重构我们的代码，我们需要使用 Roboelectric 和 Powermock。（译者注：Roboelectric 和 Powermock 均为测试框架）

不过，既然我们更希望根据测试来[改变我们写代码的方式，而不是仅仅改变写测试的方式](https://www.philosophicalhacker.com/post/why-i-dont-use-roboletric/)，我们要停一会来想一想这些测试想要告诉我们什么事情：

> 我们在 `MapActivity` 里面的代码逻辑和 `Toast` 紧密地耦合在一起。

这之间的耦合驱使我们使用 Roboelectric 来模拟 android 行为和 powermock 来模拟静态的 `Toast.makeText` 方法。作为替换，让我们以测试为驱动来去除耦合。

为了让我们重构有个方向，我们先写测试。这将确保我们的**新**类已经解耦。为了避免使用 Roboelectric 框架，我们需要在这特殊情况下创建一个新类，但是通常来说，我们只需重构已存在的类来解耦。

```
@Test
public void displaysErrorWhenPermissionRejected() throws Exception {

    OnPermissionResultListener onPermissionResultListener =
            new OnPermissionResultListener(mPermittedView);

    onPermissionResultListener.onPermissionResult(
            MapActivity.REQUEST_LOCATION_PERMISSION,
            new String[]{MapActivity.LOCATION_PERMISSION},
            new int[]{PackageManager.PERMISSION_DENIED});

    verify(mPermittedView).displayPermissionDenied();
}
```

我们已经介绍过 `OnPermissionResultListener`，它的工作就是处理用户对 app 请求权限的反应。代码如下：

```
void onPermissionResult(final int requestCode,
            final String[] permissions, final int[] grantResults) {
    if (requestCode != MapActivity.REQUEST_LOCATION_PERMISSION) {
        return;
    }

    if (permissions.length == 1 &&
            MapActivity.LOCATION_PERMISSION.equals(permissions[0]) &&
            grantResults[0] == PackageManager.PERMISSION_GRANTED) {
        // Permission has been granted.
        mPermittedView.displayPermittedView();

    } else {
        // Permission was denied. Display error message.
        mPermittedView.displayPermissionDenied();
    }
}
```

我们把对 `MapFragment` 和 `Toast` 的调用替换为对 `PermittedView` 里面方法的调用，这个对象通过构造函数来传递。`PermittedView` 是一个接口：

```
interface PermittedView {
    void displayPermissionDenied();

    void displayPermittedView();
}
```

它在 `MapActivity` 里实现:

```
public class MapActivity extends BaseActivity
        implements SlideableInfoFragment.Callback, MapFragment.Callbacks,
        ActivityCompat.OnRequestPermissionsResultCallback,
        OnPermissionResultListener.PermittedView {
    @Override
    public void displayPermissionDenied() {
        Toast.makeText(MapActivity.this, R.string.map_permission_denied,
                Toast.LENGTH_SHORT).show();
    }
}
```

这也许不是**最好**的解决方案，但是这能让我们抓住可以在哪里测试这一重心。这**要求** `OnPermissionResultListener` 降低和 `PermittedView` 的耦合度。解耦 == 显而易见的进步。

### 有必要么？

对于这一点，一些读者可能会有所怀疑。“这样真的算优化代码吗？”他们会大惑不解。有两点理由可以确认为什么这样设计**更好**。

（无论我给出哪一个理由，你都会发现其解释是“因为它的可测试性更好，所以它设计得更好”，这是一个很重要的原因。）

#### 更容易改变

首先，因为所组成的内容耦合度低，从而能够更容易地改变代码，而且更精彩的是：我们刚刚测试 Google I/O 应用的代码**实际上已经改变了**，通过我们的测试，能让其改代码变得更容易。所测试的代码来自[一个较旧的 commit](https://github.com/google/iosched/blob/bd31a838ce4ddc123c71025c859959517c7ae178/android/src/main/java/com/google/samples/apps/iosched/map/MapActivity.java)。之后，写 I/O 应用的人们决定把 `Toast` 替换为 `Snackbar`：

![snackbar 拒绝请求](https://www.philosophicalhacker.com/images/permission-denied-snackbar.png)

这是一个小改变，但是因为我们已经把 `OnPermissionResultListener` 从 `PermittedView` 中分离出来，我们可以只专注于改变 `PermittedView` 在 `MapActivity` 里面的实现，而无需担心 `OnPermissionResultListener`。

这是我们改变代码后的样子，使用他们的 `PermissionUtils` 类来显示 `SnackBar`。

```
@Override
public void displayPermissionDenied() {
    PermissionsUtils.displayConditionalPermissionDenialSnackbar(this,
            R.string.map_permission_denied, new String[]{LOCATION_PERMISSION},
            REQUEST_LOCATION_PERMISSION);
}
```

请再留意，我们可以不用考虑 `OnPermissionResultListener` 就直接改变其内容。这实际就是 Larry Constantine 在 70 年代提出对耦合这一概念的定义：

> 我们尽力让系统解耦。。。这样我们就能研究（或者调试、维护）其中一个模块而无需考虑系统中的其他模块
> 
> –Edward Yourdon and Larry Constantine, Structured Design

#### 去重

另一个“为什么实际上通过我们的测试来迫使我们解耦是一件好事”的有趣原因是：耦合通常会导致重复。Kent Beck 曾对此有相关看法：

> 依赖是任意规模的软件开发的重点问题。。。如果依赖成为了问题，这就会体现在重复上。
> 
> -Kent Beck, TDD By Example, pg 7.

如果这是对的，当我们解耦，我们将会发现更多的去重机会。的确，在我们这次案例中这个观点显得很准确。事实上有另外一个类的 `onRequestPermissionsResult` 和 `MapActivity` 的几乎一样：[`AccountFragment`](https://github.com/google/iosched/blob/bd31a838ce4ddc123c71025c859959517c7ae178/android/src/main/java/com/google/samples/apps/iosched/welcome/AccountFragment.java#L139)。我们的测试指引我们来创建 `OnPermissionResultListener` 和 `PermittedView` 这两个接口，因此无需任何修改就可以在其他类中复用。

### 结论

所以，当我们难以测试 `Activity` 和 `Fragment`时，通常是因为我们的测试尝试告诉我们所写的代码耦合度太高。测试对耦合度的警告通常以我们无法对代码做出断言的形式表现出来。

当我们听从我们的测试时，与其通过 Roboelectric 和 powermock 替换测试代码，不如改变被测代码，让其耦合度降低，这样我们就能更容易改代码和有更多的机会去重。

### 注意

1. 这也可能表现为无法让你的被测代码在测试中以一个正确的状态表现出来。例如我们在本篇中所看到的。

### 我们在 [Unikey](http://www.unikey.com/) 招聘中级 Android 开发者。如果你想要在 Orlando 智能锁定空间里的一间初创公司工作，请发邮件给我。
---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
