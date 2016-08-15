> * 原文地址：[Image Upload and Manipulation with React](https://css-tricks.com/image-upload-manipulation-react/)
* 原文作者：[Damon Bauer](http://damonbauer.me/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： 
* 校对者： 


_The following is a guest post by [Damon Bauer](http://damonbauer.me/), who tackles a pretty common web developer job: offering user image uploads. I'd hesitate to call it _easy_, but with the help of some powerful tools that do a lot of the heavy lifting, this job has gotten a heck of a lot easier than it used to be. Damon even [does it](https://github.com/damonbauer/react-cloudinary) entirely in the browser!_

A common thing web developers need to do is give users the ability to upload images. At first it might seem trivial, but there are things to think about when building an image upload component. Here are just some of the considerations:

*   What image types will you allow?
*   What size do the images need to be? How will that impact performance?
*   What aspect ratio should the images be?
*   How will the images be moderated? Inappropriate images be caught?
*   Where will the images be hosted? How will that be administered?

Server-side tools such as [Paperclip](https://github.com/thoughtbot/paperclip) and [ImageProcessor](http://github.com/JimBobSquarePants/ImageProcessor) provide a solution for most of these concerns. Unfortunately, there isn't an off-the-shelf tool to use in a single page app (that I've found). I'll show you how I solved this inside a [React](https://facebook.github.io/react/) application that doesn't use a server-side language at all.

Here's a little demo of what we'll be building:

![](http://ac-Myg6wSTV.clouddn.com/35688e25409731fdba7b.gif)

### Toolkit

The three tools I used include:

*   [react-dropzone](https://github.com/okonet/react-dropzone) to accept an image from a user
*   [superagent](https://github.com/visionmedia/superagent) to transfer the uploaded image
*   [Cloudinary](https://cloudinary.com) to store and manipulate the images

### Setting Up Cloudinary

[Cloudinary](http://cloudinary.com/) is a cloud-based service where you can store, manipulate, manage and serve images. I chose to use Cloudinary because it has a free tier that includes all the features I need. You'll need at least a free account to get started.

Let's say you want to crop, resize, and add a filter to uploaded images. Cloudinary has the concept of _transformations_, which are chained together to modify images however you need. Once uploaded, the transformations occur, modifying and storing the new image.

In the Cloudinary dashboard, go to **Settings > Upload** and select "Add upload preset" under Upload presets.

![](https://cdn.css-tricks.com/wp-content/uploads/2016/08/AddPreset.png)

On the following screen, change "Mode" to "Unsigned". This is necessary so you can upload right to Cloudinary without negotiating a private key using a server-side language.

![](https://cdn.css-tricks.com/wp-content/uploads/2016/08/Unsigned.png)

Add any transformations by selecting "Edit" in the "Incoming Transformations" section. This is where you can crop, resize, change quality, rotate, filter, etc. Save the preset, and that's it! You now have a place to upload, manipulate, store, and serve images for your app. Take note of the _preset name_, as we'll use it later on. Let's move on to the code.

### Accepting User Input

To handle the image upload, I used [react-dropzone](https://github.com/okonet/react-dropzone). It includes features such as drag and drop, file type restriction, and multiple file uploading.

To begin, install the dependencies. In your command line, run:

```
npm install react react-dropzone superagent --save
```

Then import `React`, `react-dropzone`, and `superagent` into your component. I'm using the ES6 `import` syntax:

```
import React from 'react';
import Dropzone from 'react-dropzone';
import request from 'superagent';
```

We'll use `superagent` later on. For now, in your component's render method, include a `react-dropzone` instance:

```
export default class ContactForm extends React.Component {

  render() {
    <Dropzone
      multiple={false}
      accept="image/*"
      onDrop={this.onImageDrop.bind(this)}>
      <p>Drop an image or click to select a file to upload.</p>
    </Dropzone>
  }
```

Here's a rundown of what this component is doing:

*   `multiple={false}` allows only one image to be uploaded at a time.
*   `accept="image/*"` allows any image type. You can be more explicit to limit only certain file types, e.g. `accept="image/jpg,image/png"`.
*   `onDrop` is a method that is fired when an image is uploaded.

When using the React ES5 class syntax (`React.createClass`), all methods are "autobound" to the class instance. The code in this post uses the ES6 class syntax (`extends React.Component`), which does not provide autobinding. That's why we use `.bind(this)` in the `onDrop` prop. (If you aren't familiar with `.bind`, you can [read about it here](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/bind).

### Handling the Image Drop

Now, let's set up the method to do something when an image is uploaded.

First, set up a `const` for two pieces of important upload information:

1.  The upload preset ID (created automatically for you when you created your upload preset)
2.  Your Cloudinary upload URL

```
// import statements

const CLOUDINARY_UPLOAD_PRESET = 'your_upload_preset_id';
const CLOUDINARY_UPLOAD_URL = 'https://api.cloudinary.com/v1_1/your_cloudinary_app_name/upload';

export default class ContactForm extends React.Component {
// render()
```

Next, add an entry to the component's initial state (using `this.setState`); I've called this `uploadedFileCloudinaryUrl`. Eventually, this will hold an uploaded image URL created by Cloudinary. We'll use this piece of state a little bit later.

```
export default class ContactForm extends React.Component {

  constructor(props) {
    super(props);

    this.state = {
      uploadedFileCloudinaryUrl: ''
    };
  }
```

The `react-dropzone` documentation states that it will always return an array of the uploaded file(s), so we'll pass that array to the `files` parameter of the `onImageDrop` method. As we only allow one image at a time, we know that the image will always be in the first position of the array.

Call `handleImageUpload`, passing the image (`files[0]`) to this method. I broke this into a separate method, following the [Single responsibility principle](https://en.wikipedia.org/wiki/Single_responsibility_principle). Essentially, this principle teaches you to keep methods compact and only do one thing.

```
export default class ContactForm extends React.Component {

  constructor(props) { ... }

  onImageDrop(files) {
    this.setState({
      uploadedFile: files[0]
    });

    this.handleImageUpload(files[0]);
  }

  render() { ... }

}
```

### Handling the Image Upload and Transfer

First, use `superagent` to POST to Cloudinary using the two `const` we set up earlier. Using the [`.field` method](https://visionmedia.github.io/superagent/#field-values) gives us the ability to attach data to the POST request. These pieces of data contain all the information Cloudinary needs to handle the uploaded image. By calling `.end`, the request is performed and a callback is provided.

```
export default class ContactForm extends React.Component {

  constructor(props) { ... }

  onImageDrop(files) { ... }

  handleImageUpload(file) {
    let upload = request.post(CLOUDINARY_UPLOAD_URL)
                        .field('upload_preset', CLOUDINARY_UPLOAD_PRESET)
                        .field('file', file);

    upload.end((err, response) => {
      if (err) {
        console.error(err);
      }

      if (response.body.secure_url !== '') {
        this.setState({
          uploadedFileCloudinaryUrl: response.body.secure_url
        });
      }
    });
  }

  render() { ... }

}
```

Inside of the `.end` callback, I'm logging any errors that are returned. It's probably best to tell the user that an error occurred as well.

Next, we check if the response we received contains a URL that is not an empty string. This means that the image was uploaded and manipulated and Cloudinary generated a URL. For example, if a user was editing their profile and uploaded an image, you could store the new image URL from Cloudinary in your database.

With the code we've written thus far, a user can drop an image and the component will send it to Cloudinary and receives a transformed image URL for us to use.

### Render, continued

The last part of the component is a `div` that holds a preview of the uploaded image.

```
export default class ContactForm extends React.Component {

  constructor(props) { ... }

  onImageDrop(files) { ... }

  handleImageUpload(file) { ... }

  render() {
    <div>
      <div className="FileUpload">
        ...
      </div>

      <div>
        {this.state.uploadedFileCloudinaryUrl === '' ? null :
        <div>
          <p>{this.state.uploadedFile.name}</p>
          <img src={this.state.uploadedFileCloudinaryUrl} />
        </div>}
      </div>
    </div>
  }
```

The ternary operator outputs `null` (nothing) if the `uploadedFileCloudinaryUrl` state is an empty string. Recall that by default, we set the component's `uploadedFileCloudinaryUrl` state to an empty string; this means that when the component is rendered, this `div` will be empty.

However, When Cloudinary responds with a URL, the state is no longer an empty string because we updated the state in `handleImageUpload`. At this point, the component will re-render, displaying the name of the uploaded file and a preview of the transformed image.

### Wrap Up

This is just the groundwork for an image upload component. There are plenty of additional features you could add, like:

*   Allowing uploading multiple images
*   Removal of uploaded images
*   Displaying errors if uploading fails for any reason
*   Using a mobile device's camera as the upload source

So far, this set up has worked well for my needs. Having to hardcode the upload preset isn't perfect, but I've yet to experience any issues with it.

Hopefully you've gotten an understanding of how you can upload, store and manipulate images using React without a server-side language. If you have any questions or comments, I'd love to hear them! I've created a repository where you can [see this code in action](https://github.com/damonbauer/react-cloudinary).

