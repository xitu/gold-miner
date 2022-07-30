> - 原文地址：[Introduction to Android Multi-Touch](https://medium.com/better-programming/introduction-to-android-multi-touch-bdae5f8002f4)
> - 原文作者：[ZhangKe](https://medium.com/@kezhang404)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/introduction-to-android-multi-touch.md](https://github.com/xitu/gold-miner/blob/master/article/2022/introduction-to-android-multi-touch.md)
> - 译者：[YueYong](https://github.com/YueYongDev)
> - 校对者：[haiyang-tju](https://github.com/haiyang-tju)

# 安卓多点触控介绍

![](https://cdn-images-1.medium.com/max/2880/1*q056ZGQtRdsHt-0o1_gZ3g.png)

多点触摸是指监控多个手指的触摸事件。我们可以重写（Override） `View` 中的 `onTouchEvent` 方法，或者使用 `setOnTouchListener` 方法来处理触摸事件。

首先，让我们看一下如何定义多指触摸的事件类型。

## MotionEvent 中的事件类型

一般来说，我们通过判断 `MotionEvent` 的动作来判断输入事件的类型，从而做出相应的处理。
在不考虑多指的情况下，我们一般只关注以下事件类型：

- `MotionEvent.ACTION_DOWN`
  用第一根手指点击屏幕
- `MotionEvent.ACTION_UP`
  最后一根手指离开屏幕
- `MotionEvent.ACTION_MOVE`
  一根手指在屏幕上划动
- `MotionEvent.ACTION_CANCEL`
  事件被阻断

所以对于多点触控，除了上述常见的事件类型外，我们还需要注意另外两种事件类型。

- `MotionEvent.ACTION_POINTER_DOWN`
  在点击之前，屏幕上已经有一个手指存在。
- `MotionEvent.ACTION_POINTER_UP`
  当屏幕上的一个手指被抬起时，屏幕上仍有其他手指。

需要注意的是，以上两种类型不能像以前那样通过使用 `MotionEvent#getAction` 方法获得，需要使用 `getActionMasked`。

所以在处理多指触摸时，我们的 `onTouch` 方法一般可以这样写。

```Text
public boolean onTouchEvent(MotionEvent event) {
    switch (event.getActionMasked()) {
        case MotionEvent.ACTION_DOWN: break;
        case MotionEvent.ACTION_UP: break;
        case MotionEvent.ACTION_MOVE: break;
        case MotionEvent.ACTION_POINTER_DOWN: break;
        case MotionEvent.ACTION_POINTER_UP: break;
    }
    return true;
}
```

当多个手指同时接触屏幕时，我们需要跟踪不同的手指。这里还涉及其他几个概念。

## 手指追踪

在 `MotionEvent` 中，有几种方法可以追踪不同的手指。

![](https://cdn-images-1.medium.com/max/2000/1*h597DR0PR1XCmQCwy2dN9g.png)

## ActionIndex (事件索引)

`ActionIndex` 可以直接通过 `getActionIndex` 方法获得，可以粗略理解为描述当前事件发生在哪个手指上。例如，当我们监测到手指被抬起时，我们可能想知道哪个手指被抬起，那么可以通过`ActionIndex'来判断。

此外，对于同一个手指，`ActionIndex` 的值可能会随着手指的按压和抬起而改变，所以我们不能用它来识别一个手指。
似乎 `ActionIndex` 的唯一目的是为了获得 `PointerId`。

特别要注意的是，这个方法只对 `ACTION_POINTER_DOWN` 和 `ACTION_POINTER_UP` 事件有效。 `ACTION_MOVE` 事件不能准确获得数值。我们需要结合其他事件来进行综合判断。

## PointerId (手指 ID)

通过 `getPointerId(int)` 方法获得 `PointerId`，参数是 `ActionIndex`。

我们可以通过 `PointerId` 来识别一个手指。对于同一个手指，在从按下到抬起的整个过程中，`PointerId` 是固定的。

还要注意，这个值可以重复使用，例如，一个 `id` 为 0 的手指在被抬起后重新按压时，`id` 也可能为 0。

## PointerIndex (finger index)

`PointerIndex` 通过 `findPointerIndex(int)` 获得，参数是 `PointerId`。

该值用于获取事件的更多内容。

当我们通过 `getX()` / `getY()` 方法获得坐标时，如果我们想获得事件的点击位置，我们只能获得第一个手指的位置，但这两个方法提供了一个重载。

```
float getX(int pointerIndex);
float getY(int pointerIndex);
```

## 使用

通过上面的介绍，我们已经大致了解了多点触控的一些关键点，现在让我们实际体验一下。

这里我将制作一个 `DrawView`，用于绘制手指运动轨迹，它可以同时跟踪多个手指的运动轨迹。效果如下：

![](https://cdn-images-1.medium.com/max/2000/1*0XEBZxtsJDA-iKdKU3QXbg.gif)

上图是四个手指同时移动时的效果。

## 分析

为了达到这一效果，有两个核心问题需要考虑。

首先是如何准确追踪手指的滑动轨迹，因为如上所述，`ACTION_MOVE` 不能获得 `ActionIndex`。但是当上帝关上了门，他一定会打开一扇窗。我们可以通过 `PointerId` 跟踪它。首先，监听 `ACTION_DOWN` 和 `ACTION_POINTER_DOWN` 两个事件，在这里获得新手指的 `PointerId`，在 `ACTION_MOVE` 事件中遍历所有的手指，然后比较 `PointerId` 可以是其中之一。

其次，由于 `MotionEvent` 会将多个连续的滑动轨迹打包成一个 `MotionEvent`，我们需要使用 `getHistoricalX` 来获得这个滑动的历史轨迹。该方法的签名如下。

```
float getHistoricalX(int pointerIndex, int pos);
```

第一个参数，`pointerIndex`，很容易解决。第一个问题已经提到过了，主要是第二个参数。

因为 `HistoricalX` 是一个列表，我们需要通过索引逐一读取，第二个 pos 参数是索引，但前提是我们知道列表的长度。这只需要一个 `for` 循环就可以解决。

`MotionEvent` 提供了一个方法来获取这个列表的长度。

```
int getHistorySize();
```

但是这提供了这个方法，没有其他的重载，所以你不能通过 `pointerIndex` 来获得某个手指这次滑动的历史轨迹列表的长度!

然而，经过我的测试，无论哪个手指滑动，你都可以通过 `getHistorySize` 方法得到历史轨迹的长度，然后调用 `getHistoricalX` 方法得到历史轨迹的坐标。

虽然我不知道为什么这样设计，但它确实解决了这个问题。

## 完成

我们首先定义一个内层类，作为绘图元数据。

```Java
private static class DrawPath {

    // Finger ID, the default is -1, set to -1 after the finger leaves
    private int pointerId = -1;
    // Curve color
    private int drawColor;
    // curved path
    private Path path;
    // Track list, used to determine whether the target track has been added
    private Stack<List<PointF>> record;

    DrawPath(int pointerId, int drawColor, Path path) {
        this.pointerId = pointerId;
        this.drawColor = drawColor;
        this.path = path;
        record = new Stack<>();
    }
}
```

上述 `DrawPath` 对应于手指滑动的生命周期，也就是中间经历的从下降到上升的轨迹。

然后定义一个 `DrawPath` 和变量的列表，如画笔、轨道颜色阵列等。

```Java
private Paint mPaint = new Paint();
// historical path
private List<DrawPath> mDrawMoveHistory = new ArrayList<>();
// Used to generate random numbers, randomly take out the color in the color array
private Random random = new Random();
```

初始化：

```Java
private void init() {
    mPaint.setAntiAlias(true);
    mPaint.setStyle(Paint.Style.STROKE);
    mPaint.setStrokeCap(Paint.Cap.ROUND);
    mPaint.setStrokeWidth(dip2px(getContext(), 5));
}
```

现在让我们重写 `onTouchEvent` 方法。

```Java
@Override
public boolean onTouchEvent(MotionEvent event) {
    // Multi-touch requires use of getActionMasked
    switch (event.getActionMasked()) {
        case MotionEvent.ACTION_DOWN: {
            // Handling click events
            performClick();
            // Reset all PointerIds to -1
            clearTouchRecordStatus();
            // add a track
            addNewPath(event);
            invalidate();
            return true;
        }
        case MotionEvent.ACTION_MOVE: {
            if (mDrawMoveHistory.size() > 0) {
                for (int i = 0; i < event.getPointerCount(); i++) {
                    // Iterate over all fingers on the current screen
                    int itemPointerId = event.getPointerId(i);// Get the ID of this finger
                    for (DrawPath itemPath : mDrawMoveHistory) {
                        // Traverse the drawing record table and find the corresponding record by ID
                        if (itemPointerId == itemPath.pointerId) {
                            int pointerIndex = event.findPointerIndex(itemPointerId);
                            // Get all historical tracks of this sliding event through pointerIndex
                            List<PointF> recordList = readPointList(event, pointerIndex);
                            if (!listEquals(recordList, itemPath.record.peek())) {
                                // Determine whether the List already exists, and add it if it does not exist
                                itemPath.record.push(recordList);
                                addPath(recordList, itemPath.path);
                            }
                        }
                    }
                }
                invalidate();
            }
            return true;
        }
        case MotionEvent.ACTION_POINTER_UP:
            // Event when one finger is raised on the screen, but other fingers are not raised
            int pointerId = event.getPointerId(event.getActionIndex());
            for (DrawPath item : mDrawMoveHistory) {
                if (item.pointerId == pointerId) {
                    // The finger has been drawn, reset this PointerId to -1
                    item.pointerId = -1;
                }
            }
            break;
        case MotionEvent.ACTION_POINTER_DOWN:
            // There is already a finger on the screen, and there is an event when another finger clicks
            addNewPath(event);
            invalidate();
            break;
        case MotionEvent.ACTION_UP:
            // Last finger lift resets all PointerIds
            clearTouchRecordStatus();
            break;
        case MotionEvent.ACTION_CANCEL:
            clearTouchRecordStatus();
            break;
    }
    return true;
}
```

上面的代码有注释，这里我就不细说了。

然后重写 `onDraw` 方法。虽然这是一个绘制轨迹的控件，但在 `onDraw` 方法中没有太多代码:

```Java
@Override
protected void onDraw(Canvas canvas) {
    super.onDraw(canvas);
    if (mDrawMoveHistory == null || mDrawMoveHistory.isEmpty()) {
        return;
    }
    for (DrawPath item : mDrawMoveHistory) {
        mPaint.setColor(item.drawColor);
        canvas.drawPath(item.path, mPaint);
    }
}
```

通过这种方式，了一个简单的支持多指绘制的控件就实现了，我们还可以添加一些方法，如撤销上一步。这里我就不多讲了。

`DrawView` 的完整代码已放在 GitHub 上。

欢迎你[查看访问](https://github.com/0xZhangKe/Collection/blob/master/DrawView/DrawView.java)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
