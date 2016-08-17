> * 原文地址：[Image Upload and Manipulation with React](https://css-tricks.com/image-upload-manipulation-react/)
* 原文作者：[Damon Bauer](http://damonbauer.me/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：


_下面这篇特邀文章是由 [Damon Bauer](http://damonbauer.me/) 完成的，主题是关于一个 web 开发人员非常常见的工作：为用户提供图片上传功能。毫无疑问，我会认为这很简单，不过还是需要一些功能强大的工具来帮忙做一些比较“重”的工作，看完这篇文章，再做这任务会觉得比以前轻松的多。Damon 甚至全程在浏览器中完成了[这项任务](https://github.com/damonbauer/react-cloudinary)!_


对于 web 开发者来说，让用户拥有上传图片的能力是一件很常见的事情。一开始可能看起来微不足道，但是当创建一个图片上传组件的时候，还是有些事情需要去考虑的。这里有一些注意事项：

*   允许什么类型的图片上传?
*   需要多大的图片? 这对性能有何影响?
*   图片长宽比例应该是多少?
*   如何管理图片? 能扑捉到不良图片吗?
*   图片存储在哪? 如何运维?


诸如 [Paperclip](https://github.com/thoughtbot/paperclip) 和 [ImageProcessor](http://github.com/JimBobSquarePants/ImageProcessor) 这样的服务器端工具，能解决上面大部分的问题。不幸的是，目前还没有一个能用在单页应用上的现成的工具。我将向你们展示我是如何在一个 [React](https://facebook.github.io/react/) 应用中解决这个问题的，完全没有用到服务器端语言。

这是我们将要构建的应用的一个小样品。

![](http://ac-Myg6wSTV.clouddn.com/35688e25409731fdba7b.gif)

### 工具包

我用到了下面三个工具:

*   [react-dropzone](https://github.com/okonet/react-dropzone) 来接受用户的图片
*   [superagent](https://github.com/visionmedia/superagent) 转换上传的图片
*   [Cloudinary](https://cloudinary.com) 存储图片和编辑图片。

### 设置 Cloudinary

Cloudinary 是一个基于云的服务，可以为图片提供存储、操作、管理等服务。我选择使用 Cloudinary 因为它有一定免费的额度，而且包括所有我需要的功能。你至少需要一个免费帐户才能开始。

Let's say you want to crop, resize, and add a filter to uploaded images. Cloudinary has the concept of _transformations_, which are chained together to modify images however you need. Once uploaded, the transformations occur, modifying and storing the new image.

假如说你想裁剪，调整大小并增加过滤器到上传的图片。

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
