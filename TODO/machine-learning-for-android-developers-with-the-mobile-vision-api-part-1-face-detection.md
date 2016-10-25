> * 原文地址：[Machine Learning for Android Developers with the Mobile Vision API— Part 1 — Face Detection](https://hackernoon.com/machine-learning-for-android-developers-with-the-mobile-vision-api-part-1-face-detection-e7e24a3e472f#.9ay7ilk9b)
* 原文作者：[Moyinoluwa Adeyemi](https://hackernoon.com/@moyinoluwa)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Machine Learning for Android Developers with the Mobile Vision API— Part 1 — Face Detection


Machine learning is a very interesting field in Computer Science that has ranked really high on my to-learn list for a long while now. With so many updates from RxJava, Testing, Android N, Android Studio and other Android goodies, I haven’t been able to dedicate time to learn it. There’s even a Nanodegree course on Machine Learning by Udacity. Pheew.

I was very excited to discover that Machine Learning can now implemented by anyone in their Android Apps based on the Mobile Vision APIs from Google without needing to have prior knowledge in the field. All you need is to know is how to use APIs.

There are a lot of APIs for Machine Learning on the cloud and mobile, but in this series I’m going to focus only on the Mobile Vision APIs since those are created specifically for Android developers. The Mobile Vision API currently consists of three kinds; Face Detection API, Barcode Detection API and the Text API. We’ll deal with Face Detection in this article and cover the remaining two kinds in follow-up articles.

### Face Detection API

This API is used to detect and track of human faces in images or videos but it doesn’t offer face recognition capabilities yet. It allows for the detection of landmarks on the face and offers face classification too. Landmarks are points of interest within a face such as the eye, nose and mouth. Face classification is used to check the landmarks for certain characteristics such as smiling faces or closed eyes which are currently the only supported classifications. The API also detects faces at different angles and reports the Euler Y and Euler Z angles.

### Getting Started

We are going to create an app called printf(“%s Story”, yourName) with two filters. Please note that the aim of this post is just to show the use of the API so the initial versions of this code will not have tests or follow any specific architecture. Also note that all the processing is better done off the UI thread. The [code on Github](https://github.com/moyheen/face-detector) will be updated to reflect that.

Here we go…

*   Create a new project in Android Studio.
*   Import Google Play Services SDK for the Mobile Vision API into your app level build.gradle file. As at the time of writing this article, the latest version is 9.6.1\. Take extreme caution here as you are bound to hit the 65k method limit if you import the whole SDK instead of the specific one (play-services-vision) you need.

    compile 'com.google.android.gms:play-services-vision:9.6.1'

*   To enable that the available libraries are present for face detection, add this meta-data to your manifest file.

    

*   Next, you’ll need to add an _ImageView_ and a _Button_ to your layout. The button starts the processing of the image by selecting an image, processing it and then displaying it in the _ImageView_. The image can be loaded from the device either via the camera or the gallery. To save time, I just saved an image to my drawable folder and used that.
*   In the click action for your button, create a new _BitmapFactory.Options_object and set _inmutable_ to true. This is to ensure that the bitmap is mutable so that we are able to programmatically apply effects to it.

    BitmapFactory.Options bitmapOptions = new BitmapFactory.Options();
    bitmapOptions.inMutable = true;

*   Next, create a new Bitmap with the _decodeResource_ method from the BitmapFactory class. You’ll use both the image from your drawable folder and the _BitmapOptions_ object created in the previous step as parameters for this method.

    Bitmap defaultBitmap = BitmapFactory.decodeResource(getResources(), R.drawable.image, bitmapOptions);

*   Create a _Paint_ object and set the style to stroke. This ensures that the shape is not filled in because we want to see the parts of the head that make it into the rectangle.

_Note_: If you were building a game called _!(Recognize Me)_ where you need to block out the faces in an image so that your players have to guess who it is, you’ll probably want to set the style to fill like so _Paint.Style.FILL_.

    Paint rectPaint = new Paint();
    rectPaint.setStrokeWidth(5);
    rectPaint.setColor(Color.CYAN);
    rectPaint.setStyle(Paint.Style.STROKE);

*   We need a canvas to display our bitmap. We are going to create the canvas with a temporary bitmap first. This temporary bitmap will have the same dimensions as the original bitmap but that’s where the similarities end. We would later draw the original bitmap on the same canvas.

    Bitmap temporaryBitmap = Bitmap.createBitmap(defaultBitmap.getWidth(), defaultBitmap
            .getHeight(), Bitmap.Config.RGB_565);

    Canvas canvas = new Canvas(temporaryBitmap);
    canvas.drawBitmap(defaultBitmap, 0, 0, null);

*   Finally, we get to point where we use the _FaceDectector_ API. Tracking is disabled because we are using a static image. It should be enabled for videos.

    FaceDetector faceDetector = new FaceDetector.Builder(this)
            .setTrackingEnabled(false)
            .setLandmarkType(FaceDetector.ALL_LANDMARKS)
            .build();

*   Check if the face detector is operational already. There’s a possibility that it won’t work the first time because a library needs to be downloaded to the device and it might not have been completed in time when you need to use it.

    if (!faceDetector.isOperational()) {
                new AlertDialog.Builder(this)
                .setMessage("Face Detector could not be set up on your device :(")
                .show();

        return;
    }

*   Next, we create a frame using the default bitmap and call on the face detector to get the face objects.

    Frame frame = new Frame.Builder().setBitmap(defaultBitmap).build();
    SparseArray sparseArray = faceDetector.detect(frame);

*   The rectangle is drawn over the faces in this step. We can only get the left and top position from each of the faces but we also need the right and bottom dimensions to draw the rectangle. To resolve this, we add the width and height to the left and top positions respectively.

    for (int i = 0; i < sparseArray.size(); i++) {
        Face face = sparseArray.valueAt(i);

        float left = face.getPosition().x;
        float top = face.getPosition().y;
        float right = left + face.getWidth();
        float bottom = right + face.getHeight();
        float cornerRadius = 2.0f;

        RectF rectF = new RectF(left, top, right, bottom);

        canvas.drawRoundRect(rectF, cornerRadius, cornerRadius, rectPaint);
    }

*   We then create a new _BitmapDrawable_ with the temporary bitmap and set that on the ImageView from our layout after which we release the face detector.

    imageView.setImageDrawable(new BitmapDrawable(getResources(), temporaryBitmap));

    faceDetector.release();

These steps are just enough to draw the rectangle on each face. If you want to highlight the landmarks on each face, all you need to do is modify the loop from the last two steps. You’ll now loop through the landmark for each face, get the landmark x and y positions and draw a circle on each of them like so.

    for (int i = 0; i < sparseArray.size(); i++) {
        Face face = sparseArray.valueAt(i);

        float left = face.getPosition().x;
        float top = face.getPosition().y;
        float right = left + face.getWidth();
        float bottom = right + face.getHeight();
        float cornerRadius = 2.0f;

        RectF rectF = new RectF(left, top, right, bottom);
        canvas.drawRoundRect(rectF, cornerRadius, cornerRadius, rectPaint);

        for (Landmark landmark : face.getLandmarks()) {
            int x = (int) (landmark.getPosition().x);
            int y = (int) (landmark.getPosition().y);
            float radius = 10.0f;

            canvas.drawCircle(x, y, radius, rectPaint);
        }
    }



Picture with facial landmarks highlighted

I was curious to know how the landmarks were represented so I used _landmark.getType();_ to find that out. It turns out each of the landmarks have specific numbers attached to them.

    for (Landmark landmark : face.getLandmarks()) {

        int cx = (int) (landmark.getPosition().x);
        int cy = (int) (landmark.getPosition().y);

        // canvas.drawCircle(cx, cy, 10, rectPaint);

        String type = String.valueOf(landmark.getType());
        rectPaint.setTextSize(50);    
        canvas.drawText(type, cx, cy, rectPaint);
    }









![](http://ac-Myg6wSTV.clouddn.com/9c2c504ae6c38fe051bc.png)





This knowledge is useful when we want to position objects on the screen relative to a particular facial landmark. If we were going to build our printf(“%s Story”, yourName) app, all we have to do is position an image relative to one of the landmark’s position since we now know what number it is represented as. Let’s proceed to do that below…

Say we were pirates at sea and we wanted to depict that through one of our really cool printf(“%s Story”, yourName) app filters, we’ll need an eye-patch over our left eye. The position of the eyePatchBitmap is drawn relative to the left eye.

    for (Landmark landmark : face.getLandmarks()) {

        int cx = (int) (landmark.getPosition().x);
        int cy = (int) (landmark.getPosition().y);

        // canvas.drawCircle(cx, cy, 10, rectPaint);

        // String type = String.valueOf(landmark.getType());
        // rectPaint.setTextSize(50);
        // canvas.drawText(type, cx, cy, rectPaint);

        // the left eye is represented by 4 
        if (landmark.getType() == 4) {
            canvas.drawBitmap(eyePatchBitmap, cx - 270, cy - 250, null);
        }
    }





Here’s more from the printf(“%s Story”, yourName) app…

There’s still a lot more to cover with this API. We can update the app to track faces in videos and allow the filters move along with the head. The code from this article is [on Github here](https://github.com/moyheen/face-detector).



