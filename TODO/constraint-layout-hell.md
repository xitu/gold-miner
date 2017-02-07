> * 原文地址：[Constraint Layout ( What the hell is this )](http://www.uwanttolearn.com/android/constraint-layout-hell/)
* 原文作者：[Hafiz Waleed Hussain](http://www.uwanttolearn.com/about/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

WOW, we got one more day so its time to make this day awesome by learning something new :).

Hello Guys, Today we are going to learn Constraint Layout in Android.

**Motivation:
**I want to discuss my own experience with this awesome layout. When Google announced this layout, I start learning but I faced a lot of issues. I try to get some good tutorials but always get Visual Editor, Drag & Drop images in tutorials. Which not make sense for me. After two months I changed my strategy. I analysed my self and I got answer. I am good in XML with Linear, Relative, Frame … layouts, so I should work with XML of Constraint Layout but again when I drag drop some views on Visual Editor and opened a XML, I am in more difficult situation because there are lot of new tags which I don’t know. I am frustrated but I never give up. Then I changed again my strategy. I decided I will not use Visual Editor, create my own Relative Layout then convert to Constraint Layout. Now magic happens 🙂 , it took only one whole day and now I am really comfortable with Constraint Layout.

After that I choose the same strategy with Linear Layout to Constraint, Frame Layout to Constraint. Today I am choosing same strategy with this post. Every body has different learning and thinking capacity. So may be there is a possibility you are not agree with my approach but those who are struggling, I am giving you surety this approach is awesome. One more good news, now I know how I can use Visual Editor without any confusion. Every thing is crystal clear. Its time to start playing with our best friend **CONSTRAINT LAYOUT**.

We need to download 2.3 Android studio. In previous versions Visual Editor is not good and that show some wrong info on Design Tab. So that is really important download 2.3 beta which is available when I am writing this post.

Create a new project.

[![Create a new project.](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-9.39.45-AM-300x152.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-9.39.45-AM.png)

[![New proejct](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-9.44.51-AM-300x180.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-9.44.51-AM.png)

[![screen-shot-2017-01-07-at-9-45-10-am](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-9.45.10-AM-300x188.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-9.45.10-AM.png)

[![screen-shot-2017-01-07-at-9-45-29-am](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-9.45.29-AM-300x173.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-9.45.29-AM.png)

Now our project is ready. As I selected Add No Activity. I have no Java and XML layout files in our project as shown below.

[![screen-shot-2017-01-07-at-9-53-17-am](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-9.53.17-AM-300x267.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-9.53.17-AM.png)

In this whole post we most probably work with layouts files.

**1. Relative to Constraint Layout:
**

Now I am going to make first Relative Layout and later we will change that into Constraint Layout.

[![screen-shot-2017-01-07-at-10-11-05-am](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-10.11.05-AM-1024x437.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-10.11.05-AM.png)

As shown above. We can see, that is the most used design pattern in Android lists. How I achieve this I will show you later in XML. Only first focus on Arrows which you can see easily in image. Basically these arrows are telling you how we use relative layout tags to manage this UI.

Like Title TextView is android:layout_toRightOf ImageView.

As a user requirement

1. I want a ImageView on left side of screen having 4:3 ratio in size.

2. I want a Title with one line text after Image view up to end of screen.

3. I want a Description, below title and after image view up to end of a screen with max 2 lines.

4. I want a Button, below ImageView and left align with description.

Now I am going to explain XML. Important tags are **bold**.

    <?xml version="1.0" encoding="utf-8"?>
    <RelativeLayout xmlns:android="http://schemas.android.com/apk/res/android"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:padding="16dp">

        <!-- 4:3 ratio -->
        <ImageView
    **        android:id="@+id/listingImageView"**
            android:layout_width="96dp"
            android:layout_height="72dp"
            android:scaleType="centerCrop"
            android:src="@drawable/image" />

        <TextView
    **        android:id="@+id/titleTextView"**
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:layout_marginBottom="5dp"
            android:layout_marginLeft="5dp"
            android:layout_marginRight="5dp"
    **        android:layout_toRightOf="@id/listingImageView"**
            android:lines="1"
            android:text="Hey I am title"
            android:textSize="20sp"

            android:textStyle="bold" />

        <TextView
    **        android:id="@+id/descriptionTextView"**
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
    **        android:layout_below="@id/titleTextView"**
            android:layout_marginLeft="5dp"
            android:layout_marginRight="5dp"
    **        android:layout_toRightOf="@id/listingImageView"**
            android:ellipsize="end"
            android:lines="2"
            android:text="Hey I am description. Yes I am description. Believe on me I am description."
            android:textSize="16sp"
            />

        <Button
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
    **        android:layout_alignLeft="@id/descriptionTextView"****        android:layout_below="@id/listingImageView"**
            android:text="What! Button, Why " />

    </RelativeLayout>

Now I think every body knows easily how I implemented this UI but for revision purposes I am taking important tags from UI.

    **ImageView       android:id="@+id/listingImageView"**

    **TextView        android:id="@+id/titleTextView"****[android:layout_toRightOf="@id/listingImageView"](https://developer.android.com/reference/android/widget/RelativeLayout.LayoutParams.html#attr_android:layout_toRightOf)**

    **TextView        android:id="@+id/descriptionTextView"**[**                android:layout_below="@id/titleTextView"**](https://developer.android.com/reference/android/widget/RelativeLayout.LayoutParams.html#attr_android:layout_below)[**                android:layout_toRightOf="@id/listingImageView"**](https://developer.android.com/reference/android/widget/RelativeLayout.LayoutParams.html#attr_android:layout_toRightOf)

    **Button          [android:layout_alignLeft="@id/descriptionTextView"](https://developer.android.com/reference/android/widget/RelativeLayout.LayoutParams.html#attr_android:layout_alignLeft)**[**                android:layout_below="@id/listingImageView"**](https://developer.android.com/reference/android/widget/RelativeLayout.LayoutParams.html#attr_android:layout_below)

Now Its time to convert this layout into Constraint Layout. For that we need to add dependency into gradle file and sync.

     compile 'com.android.support.constraint:constraint-layout:1.0.0-beta4'

Now our UI is ready in Constraint Layout as shown below.

[![screen-shot-2017-01-07-at-10-49-16-am](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-10.49.16-AM-1024x568.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-10.49.16-AM.png)

This is 100% just like Relative Layout. This time may be you can ask this question. Why I am not showing arrows on this image? So for that my answer is, I don’t want to confuse you. So guys now I am ready to show you image with arrows but promise don’t confuse only saw below image, enjoy and start reading don’t do focus a lot. 🙂

[![screen-shot-2017-01-07-at-10-49-47-am](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-10.49.47-AM-1024x632.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-10.49.47-AM.png)

Haha one short story.  At that time when I am learning, I created this UI without seeing Visual Editor but when I opened, I am amazed what I did, how I did. So after learning XML I can do this same thing using Visual Editor in minutes. So its time to learn first its XML. Important tags are **bold.**

    <?xml version="1.0" encoding="utf-8"?>
    <android.support.constraint.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
        xmlns:app="http://schemas.android.com/apk/res-auto"
        android:layout_width="match_parent"
        android:layout_height="match_parent">
        <!-- 4:3 ratio -->

        <ImageView
            android:id="@+id/listingImageView"
            android:layout_width="96dp"
            android:layout_height="72dp"
            android:layout_marginLeft="16dp"
            android:layout_marginStart="16dp"
            android:layout_marginTop="16dp"
            android:scaleType="centerCrop"
            android:src="@drawable/image"
            **app:layout_constraintLeft_toLeftOf="parent"****        app:layout_constraintTop_toTopOf="parent"** />

        <TextView
            android:id="@+id/titleTextView"
            **android:layout_width="0dp"**
            android:layout_height="wrap_content"
            android:layout_marginBottom="5dp"
            android:layout_marginLeft="5dp"
            android:layout_marginRight="5dp"
            android:layout_marginTop="16dp"
            android:lines="1"
            android:text="Hey I am title"
            android:textSize="20sp"
            android:textStyle="bold"
            **app:layout_constraintLeft_toRightOf="@+id/listingImageView"****        app:layout_constraintRight_toRightOf="parent"****        app:layout_constraintTop_toTopOf="parent"** />

        <TextView
            android:id="@+id/descriptionTextView"
            **android:layout_width="0dp"**
            android:layout_height="wrap_content"
            android:layout_marginLeft="5dp"
            android:layout_marginRight="5dp"
            android:layout_marginTop="0dp"
            android:ellipsize="end"
            android:lines="2"
            android:text="Hey I am description. Yes I am description. Believe on me I am description."
            android:textSize="16sp"
            **app:layout_constraintLeft_toRightOf="@+id/listingImageView"****        app:layout_constraintRight_toRightOf="parent"****        app:layout_constraintTop_toBottomOf="@+id/titleTextView"** />


        <Button
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:layout_marginLeft="0dp"
            android:layout_marginStart="0dp"
            android:layout_marginTop="0dp"
            android:text="What! Button, Why "
            **app:layout_constraintLeft_toLeftOf="@+id/descriptionTextView"****        app:layout_constraintTop_toBottomOf="@+id/listingImageView"** />

    </android.support.constraint.ConstraintLayout>

Before jumping into more detail. I want to clear one thing. Basically this is a secret recipe of Constraint Layout in my opinion. How to read XML tags.

Just like in Relative Layout we use **android:layout_toRightOf=”@id/abc” **means take my current View to right of the given resource view. So its mean Editor automatically knows we are talking about current view. I did not mention any thing about my current view. I only mentioned the other view by using id.

In Constraint Layout I need to mention about my current view plus the other view. I feel this is a secret recipe of Constraint Layout. Like below example. (**only focus on tag names not on concept**)

    **app:layout_constraintLeft_toLeftOf="@+id/descriptionTextView
    **Here if you do focus, I mentioned first "**layout_constraintLeft"_   **toLeftOf.

So I am saying hey take my left edge and then I am saying to take that edge toLeftOf given Id. Simple, now back to the topic.

For simplicity I am going to copy again only required tags which we need to discuss.

    <android.support.constraint.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
        xmlns:app="http://schemas.android.com/apk/res-auto"
        android:layout_width="match_parent"
        android:layout_height="match_parent">
        <!-- 4:3 ratio -->

    **ImageView       android:id="@+id/listingImageView"****app:layout_constraintLeft_toLeftOf="parent"****                app:layout_constraintTop_toTopOf="parent"** />

    **TextView        android:id="@+id/titleTextView"****android:layout_width="0dp"****app:layout_constraintLeft_toRightOf="@+id/listingImageView"****                app:layout_constraintRight_toRightOf="parent"****                app:layout_constraintTop_toTopOf="parent"** />

    **TextView        android:id="@+id/descriptionTextView"****android:layout_width="0dp"****app:layout_constraintLeft_toRightOf="@+id/listingImageView"****                app:layout_constraintRight_toRightOf="parent"****                app:layout_constraintTop_toBottomOf="@+id/titleTextView"** />

    **Button****app:layout_constraintLeft_toLeftOf="@+id/descriptionTextView"****                app:layout_constraintTop_toBottomOf="@+id/listingImageView"** />


OK guys now I am taking here only descriptionTextView for explaining. Again remember the secret recipe of Constraint Layout. You need to mention first, current view and then other view.

**android:id=”@+id/titleTextView”:****
**I think that is simple. No need to explain.

**android:layout_width=”0dp”:
**Width 0dp means width should be managed by some other constraints. Which you will see later.

**app:layout_constraintLeft_toRightOf=”@+id/listingImageView”:
**Now here I am giving order to renderer. Hey take my (Current TextView) left edge and place right of a ImageView (@+id/listingImageView). Hurray now we know how to use this layout. This is really simple if you grasp this reading strategy.
**
**** app:layout_constraintRight_toRightOf=”parent”:
**Here I am giving order to renderer. Hey take my (Current TextView) right edge and place up to parent right edge. Now my width is the reamining space on UI from ImageView to the end of parent. That’s why we have 0dp width and managed here.
**Imporant note: **

There is not match_parent tag instead if you use, that will not work. You always need to use parent. Now question is why. I am not sure but what I feel parent will give more sense when you read your XML.
**

app:layout_constraintTop_toTopOf=”parent”:
**Here I am giving order to renderer. Hey take my (Current TextView) top edge and place up to parent top edge. So it is just like I am always top parent true.

Now most important thing you guys should do practice and you will learn in minutes. I give a lot of time to learn this layout but I want you should save your time.

Now I want to show you a complete image. How our image is showing in Visual Editor.

[![screen-shot-2017-01-07-at-11-24-22-am](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-11.24.22-AM-1024x798.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-07-at-11.24.22-AM.png)

Here guys you can take a break. Try to implement this same example, after that I am 100% sure you are comfortable with this layout, play with other XML tags which I mention below.

    app:layout_constraintTop_toTopOf="@id/view"
    app:layout_constraintTop_toBottomOf="@id/view"
    app:layout_constraintRight_toLeftOf="@id/view"
    app:layout_constraintRight_toRightOf="@id/view"
    app:layout_constraintBottom_toBottomOf="@id/view"
    app:layout_constraintBottom_toTopOf="@id/view"
    app:layout_constraintLeft_toLeftOf="@id/view"
    app:layout_constraintLeft_toRightOf="@id/view"
    app:layout_constraintStart_toStartOf="@id/view"
    app:layout_constraintStart_toEndOf="@id/view"
    app:layout_constraintEnd_toStartOf="@id/view"
    app:layout_constraintEnd_toEndOf="@id/view"

After playing with these tags. When you feel comfortable. We will start new things about Constraint Layout in next post. Really important grasp these tags after that all new concepts in Constraint Layout are nothing.

OK guys. Its time to say BYE. We will meet again in next post.

[**Constraint Layout Concepts ( What the hell is this )[ (Tips and Tricks) Part 2 ]**](http://www.uwanttolearn.com/android/constraint-layout-concepts-hell-tips-tricks-part-2/)
[![Share on Facebook](http://www.uwanttolearn.com/wp-content/plugins/social-media-feather/synved-social/image/social/regular/96x96/facebook.png)](http://www.facebook.com/sharer.php?u=http%3A%2F%2Fwww.uwanttolearn.com%2F%3Fp%3D803&amp;t=Constraint%20Layout%20%28%20What%20the%20hell%20is%20this%20%29&amp;s=100&amp;p[url]=http%3A%2F%2Fwww.uwanttolearn.com%2F%3Fp%3D803&amp;p[images][0]=http%3A%2F%2Fwww.uwanttolearn.com%2Fwp-content%2Fuploads%2F2017%2F01%2FScreen-Shot-2017-01-07-at-9.45.29-AM-300x173.png&amp;p[title]=Constraint%20Layout%20%28%20What%20the%20hell%20is%20this%20%29)
[![Share on Twitter](http://www.uwanttolearn.com/wp-content/plugins/social-media-feather/synved-social/image/social/regular/96x96/twitter.png)](https://twitter.com/intent/tweet?url=http%3A%2F%2Fwww.uwanttolearn.com%2F%3Fp%3D803&amp;text=Hey%20check%20this%20out)
[![Share on Google+](http://www.uwanttolearn.com/wp-content/plugins/social-media-feather/synved-social/image/social/regular/96x96/google_plus.png)](https://plus.google.com/share?url=http%3A%2F%2Fwww.uwanttolearn.com%2F%3Fp%3D803)
[![Share on Reddit](http://www.uwanttolearn.com/wp-content/plugins/social-media-feather/synved-social/image/social/regular/96x96/reddit.png)](http://www.reddit.com/submit?url=http%3A%2F%2Fwww.uwanttolearn.com%2F%3Fp%3D803&amp;title=Constraint%20Layout%20%28%20What%20the%20hell%20is%20this%20%29)
[![Pin it with Pinterest](http://www.uwanttolearn.com/wp-content/plugins/social-media-feather/synved-social/image/social/regular/96x96/pinterest.png)](http://pinterest.com/pin/create/button/?url=http%3A%2F%2Fwww.uwanttolearn.com%2F%3Fp%3D803&amp;media=http%3A%2F%2Fwww.uwanttolearn.com%2Fwp-content%2Fuploads%2F2017%2F01%2FScreen-Shot-2017-01-07-at-9.45.29-AM-300x173.png&amp;description=Constraint%20Layout%20%28%20What%20the%20hell%20is%20this%20%29)
[![Share on Linkedin](http://www.uwanttolearn.com/wp-content/plugins/social-media-feather/synved-social/image/social/regular/96x96/linkedin.png)](http://www.linkedin.com/shareArticle?mini=true&amp;url=http%3A%2F%2Fwww.uwanttolearn.com%2F%3Fp%3D803&amp;title=Constraint%20Layout%20%28%20What%20the%20hell%20is%20this%20%29)
[![Share by email](http://www.uwanttolearn.com/wp-content/plugins/social-media-feather/synved-social/image/social/regular/96x96/mail.png)](mailto:?subject=Constraint%20Layout%20%28%20What%20the%20hell%20is%20this%20%29&amp;body=Hey%20check%20this%20out:%20http%3A%2F%2Fwww.uwanttolearn.com%2F%3Fp%3D803)
[by ![feather](http://www.uwanttolearn.com/wp-content/plugins/social-media-feather/synved-social/image/icon.png)](http://synved.com/wordpress-social-media-feather/)
