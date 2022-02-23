> * 原文地址：[Introduction to Android Multi-Touch](https://medium.com/better-programming/introduction-to-android-multi-touch-bdae5f8002f4)
> * 原文作者：[ZhangKe](https://medium.com/@kezhang404)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/introduction-to-android-multi-touch.md](https://github.com/xitu/gold-miner/blob/master/article/2022/introduction-to-android-multi-touch.md)
> * 译者：
> * 校对者：

# Introduction to Android Multi-Touch

![](https://cdn-images-1.medium.com/max/2880/1*q056ZGQtRdsHt-0o1_gZ3g.png)

Multi-finger touch refers to monitoring the touch events of multiple fingers. We can override the `onTouchEvent` method in `View`, or use the `setOnTouchListener` method to handle touch events.

First, let’s take a look at how to determine the event type of multi-finger touch.

## Event Types in MotionEvent

Generally speaking, we judge the type of input event by judging the action of `MotionEvent`, so as to make corresponding processing.
Without considering multiple fingers, we generally only focus on the following event types:

* `MotionEvent.ACTION_DOWN`
Tap the screen with the first finger
* `MotionEvent.ACTION_UP`
The last finger leaves the screen
* `MotionEvent.ACTION_MOVE`
A finger is swiping on the screen
* `MotionEvent.ACTION_CANCEL`
event blocked

So for multi-finger touch, in addition to the above-mentioned common event types, we also need to pay attention to two other event types:

* MotionEvent.ACTION_POINTER_DOWN
A finger already exists on the screen before the tap
* `MotionEvent.ACTION_POINTER_UP`
When one finger on the screen is lifted, there are still other fingers on the screen

It should be noted that the above two types cannot be obtained by using the `MotionEvent#getAction` method as before, and need to use `getActionMasked`.

So when dealing with multi-finger touch, our `onTouch` method can generally be written like this:

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

When multiple fingers touch the screen at the same time, we need to track different fingers. There are several other concepts involved here.

## Finger Tracking

There are several methods for tracking different fingers in `MotionEvent`.

![](https://cdn-images-1.medium.com/max/2000/1*h597DR0PR1XCmQCwy2dN9g.png)

## ActionIndex (event index)

`ActionIndex` can be obtained directly through the `getActionIndex` method, which can be roughly understood as describing the number of fingers that the current event occurs on. For example, when we monitor the finger lift, we may want to know which finger is lifted, then it can be judged by `ActionIndex`.

In addition, for the same finger, the value of `ActionIndex` may change as the finger is pressed and lifted, so we cannot use it to identify a finger.
It seems that the only purpose of `ActionIndex` is to get the `PointerId`.

In particular, it should be noted that this method is only valid for the `ACTION_POINTER_DOWN` and `ACTION_POINTER_UP` events. The `ACTION_MOVE` event cannot accurately obtain the value. We need to make a comprehensive judgment in combination with other events.

## PointerId (finger ID)

The `PointerId` is obtained through the `getPointerId(int)` method, and the parameter is `ActionIndex`.

We can identify a finger by `PointerId`. For the same finger, the `PointerId` is fixed throughout the process from pressing to lifting.

Also note that this value may be reused, for example, a finger with an `id` of 0 may also have an `id` of 0 when a finger is re-pressed after it has been lifted.

## PointerIndex (finger index)

`PointerIndex` is obtained through `findPointerIndex(int)`, the parameter is `PointerId`.

This value is used to get more content of the event.

If we want to get the click point position of the event, when we get the coordinates through the `getX()`/`getY()` method, we can only get the position of the first finger, but these two methods provide an overload:

```
float getX(int pointerIndex);
float getY(int pointerIndex);
```

## Use

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
