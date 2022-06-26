> - 原文地址：[Introduction to Android Multi-Touch](https://medium.com/better-programming/introduction-to-android-multi-touch-bdae5f8002f4)
> - 原文作者：[ZhangKe](https://medium.com/@kezhang404)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/introduction-to-android-multi-touch.md](https://github.com/xitu/gold-miner/blob/master/article/2022/introduction-to-android-multi-touch.md)
> - 译者：[YueYong](https://github.com/YueYongDev)
> - 校对者：

# 安卓多点触控指南

![](https://cdn-images-1.medium.com/max/2880/1*q056ZGQtRdsHt-0o1_gZ3g.png)

多点触摸指的是监控多个手指的触摸事件。我们可以重写（Override） `View` 中的 `onTouchEvent` 方法，或者使用 `setOnTouchListener` 方法来处理触摸事件。

首先，让我们看一下如何定义多指触摸的事件类型。

## MotionEvent 中的事件类型

一般来说，我们通过判断`MotionEvent`的动作来判断输入事件的类型，从而做出相应的处理。
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

需要注意的是，以上两种类型不能像以前那样通过使用`MotionEvent#getAction`方法获得，需要使用`getActionMasked`。

所以在处理多指触摸时，我们的`onTouch`方法一般可以这样写。

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

在`MotionEvent`中，有几种方法可以追踪不同的手指。

![](https://cdn-images-1.medium.com/max/2000/1*h597DR0PR1XCmQCwy2dN9g.png)

## ActionIndex (事件索引)

`ActionIndex`可以直接通过`getActionIndex`方法获得，可以粗略理解为描述当前事件发生在哪个手指上。例如，当我们监测到手指被抬起时，我们可能想知道哪个手指被抬起，那么可以通过`ActionIndex'来判断。

此外，对于同一个手指，`ActionIndex`的值可能会随着手指的按压和抬起而改变，所以我们不能用它来识别一个手指。
似乎`ActionIndex`的唯一目的是为了获得`PointerId`。

特别要注意的是，这个方法只对`ACTION_POINTER_DOWN`和`ACTION_POINTER_UP`事件有效。`ACTION_MOVE`事件不能准确获得数值。我们需要结合其他事件来进行综合判断。

## PointerId (finger ID)

通过`getPointerId(int)`方法获得`PointerId`，参数是`ActionIndex`。

我们可以通过`PointerId`来识别一个手指。对于同一个手指，在从按下到抬起的整个过程中，`PointerId`是固定的。

还要注意，这个值可以重复使用，例如，一个`id`为0的手指在被抬起后重新按压时，`id`也可能为0。

## PointerIndex (finger index)

`PointerIndex` 通过 `findPointerIndex(int)` 获得，参数是`PointerId`。

该值用于获取事件的更多内容。

当我们通过`getX()`/`getY()`方法获得坐标时，如果我们想获得事件的点击位置，我们只能获得第一个手指的位置，但这两个方法提供了一个重载。

```
float getX(int pointerIndex);
float getY(int pointerIndex);
```

## 使用

通过上面的介绍，我们已经大致了解了多点触控的一些关键点，现在让我们把它们应用到实践中。

Through the above introduction, we have roughly understood some key points of multi-touch, and now let’s apply them in practice.

Here I will make a `DrawView` for drawing finger movement trajectory, and it can track the trajectory of multiple fingers at the same time. The effect is as follows:

![](https://cdn-images-1.medium.com/max/2000/1*0XEBZxtsJDA-iKdKU3QXbg.gif)

The picture above is the effect when swiping four fingers at the same time.

## Analyze

To achieve this effect, there are two main issues to consider:

The first is how to accurately track the sliding trajectory of a finger, because as mentioned above, `ACTION_MOVE` cannot obtain `ActionIndex`. But when God closes the door, he will definitely open a window. We can track it through `PointerId`. First, listen to the two events of `ACTION_DOWN` and `ACTION_POINTER_DOWN`, get the `PointerId` of the new finger here, traverse all the fingers in the `ACTION_MOVE` event, and then compare `PointerId` can be either.

Second, because `MotionEvent` will package multiple consecutive sliding trajectories into one `MotionEvent`, we need to use `getHistoricalX` to get the historical trajectory of this sliding. The method signature is as follows:

```
float getHistoricalX(int pointerIndex, int pos);
```

The first parameter, `pointerIndex`, is easy to solve. The first question has already been mentioned, mainly the second parameter.

Because `HistoricalX` is a list, we need to read one by one through the index, and the second pos parameter is the index, but only if we know the length of the list. This can be solved with only one `for` loop.

`MotionEvent` provides a method to get the length of this list:

```
int getHistorySize();
```

But this provides this method, there are no other overloads, so you can’t get the length of the history track list of a certain finger’s slide this time through `pointerIndex`!

However, after my test, no matter which finger slides, you can get the length of the historical track through the `getHistorySize` method, and then call the `getHistoricalX` method to obtain the coordinates of the historical track.

Although I don’t know why it is designed this way, it does solve this problem.

## Accomplish

We first define an inner class to act as drawing metadata:

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

The above `DrawPath` corresponds to the life cycle of a finger slide, that is, the trajectory experienced in the middle from DOWN to UP.

Then define a list of `DrawPath` and variables such as brushes, track color arrays, etc.:

```Java
private Paint mPaint = new Paint();
// historical path
private List<DrawPath> mDrawMoveHistory = new ArrayList<>();
// Used to generate random numbers, randomly take out the color in the color array
private Random random = new Random();
```

Initialize it:

```Java
private void init() {
    mPaint.setAntiAlias(true);
    mPaint.setStyle(Paint.Style.STROKE);
    mPaint.setStrokeCap(Paint.Cap.ROUND);
    mPaint.setStrokeWidth(dip2px(getContext(), 5));
}
```

Now let’s override the `onTouchEvent` method:

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

There are comments above, so I won’t go into detail.

Then rewrite the `onDraw` method. Although this is a control for drawing tracks, there is not much code in the `onDraw` method:

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

In this way, a simple control that supports multi-finger drawing is realized, and we can also add some methods such as undoing the previous step to it. I won’t talk about it here.

The complete code for `DrawView` has been put on GitHub.

You’re welcome to [check it out](https://github.com/0xZhangKe/Collection/blob/master/DrawView/DrawView.java).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
