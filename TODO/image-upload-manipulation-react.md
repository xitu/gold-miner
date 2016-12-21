> * 原文地址：[Image Upload and Manipulation with React](https://css-tricks.com/image-upload-manipulation-react/)
* 原文作者：[Damon Bauer](http://damonbauer.me/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[DeadLion](https://github.com/DeadLion)
* 校对者：[mypchas6fans](https://github.com/mypchas6fans), [Kulbear](https://github.com/Kulbear)

# 如何用 React 完成图片上传功能？

_下面这篇特邀文章是由 [Damon Bauer](http://damonbauer.me/) 完成的，主题是关于一个 web 开发人员非常常见的工作：为用户提供图片上传功能。我想说这并不容易，但是有了一些功能强大的工具来帮忙做一些比较“重”的工作，这个任务会觉得比以前轻松许多。Damon 甚至全程在浏览器中完成了[这项任务](https://github.com/damonbauer/react-cloudinary)!_


对于 web 开发者来说，让用户能够上传图片是一件很常见的事情。一开始可能看起来小菜一碟，但是当真正创建一个图片上传组件的时候，还是有些问题需要去考虑的。这里有一些注意事项：

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

Cloudinary 是一个可以为图片提供存储、操作、管理、提供功能的云服务。我选择使用 Cloudinary 是因为它提供的免费账户包含了所有我所需要的功能。你至少需要一个免费帐户才能开始。

假如说你想裁剪，调整大小并给上传的图片增加滤镜。Cloudinary 有个_转换_的概念，和修改图片功能链接在一块的，不管你需不需要。一旦上传，就会转换、修改然后存储新的图片。

在 Cloudinary 控制面板中，找到 **Settings > Upload**，然后选择 “Upload presets” 下方 的 “Add upload preset”。

![](https://cdn.css-tricks.com/wp-content/uploads/2016/08/AddPreset.png)


下一步，将 “Mode” 改成 “Unsigned”。这是必须的，然后你就可以不需要使用服务器端语言来处理私钥也能直接上传到 Cloudinary 了。

![](https://cdn.css-tricks.com/wp-content/uploads/2016/08/Unsigned.png)


在 “Incoming Transformations” 部分选择 “Edit” 可以添加任何转换。 你可以裁剪、调整大小、改变质量、旋转、滤镜等等。保存预设，这就行了！你现在有地方上传、处理、存储图片了，能够为你的应用程序提供图片服务了。注意预设名称，我们稍后将用到它。让我们进入代码部分吧。

### 接受用户输入

为了处理图片上传，我用了 [react-dropzone](https://github.com/okonet/react-dropzone) 插件。它包含了一些功能，如拖放文件、文件类型限制和多文件上传。

首先，安装依赖。在命令行中输入下面的命令，运行：

```
npm install react react-dropzone superagent --save
```

然后在你的组件中导入 `React`、 `react-dropzone` 和 `superagent`。我使用 ES6 `import` 语法。

```
import React from 'react';
import Dropzone from 'react-dropzone';
import request from 'superagent';
```

我们稍后会用到 `superagent`。现在，在你的组件 render 方法中包含一个 `react-dropzone` 实例。

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

以下是这个组件的一些概要:

*   `multiple={false}` 同一时间只允许一个图片上传。
*   `accept="image/*"` 允许任何类型的图片。你可以明确的限制文件类型，只允许某些类型可以上传， 例如 `accept="image/jpg,image/png"`。
*   `onDrop` 是一个方法，当图片被上传的时候触发。

当使用 React ES5 类语法（`React.createClass`），所有方法是 “autobound（自动绑定）” 到类实例上。这篇文章中的代码使用 ES6 类语法（`extends React.Component`），不提供自动绑定的。所以我们在 `onDrop` 属性中用了 `.bind(this)` 。（如果你不熟悉 `.bind`，你可以看看[这篇文章](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/bind)了解下。）

### 处理拖拽图片

现在，让我们设置当上传一个图像时，做某些事情的方法。


首先，为两条重要的上传信息设置一个 `const` 。

1.  上传预设 ID (当你创建了上传预设时自动生成)
2.  你的 Cloudinary 上传 URL

```
// import statements

const CLOUDINARY_UPLOAD_PRESET = 'your_upload_preset_id';
const CLOUDINARY_UPLOAD_URL = 'https://api.cloudinary.com/v1_1/your_cloudinary_app_name/upload';

export default class ContactForm extends React.Component {
// render()
```

然后，增加一条记录到组件初始化 state （使用 `this.setState`）；我给这个属性起了个名字 `uploadedFileCloudinaryUrl`。最终，这将存放一个上传成功后由 Cloudinary 生成的图片 URL。我们稍后会用到这条 state。

```
export default class ContactForm extends React.Component {

  constructor(props) {
    super(props);

    this.state = {
      uploadedFileCloudinaryUrl: ''
    };
  }
```

`react-dropzone` 文档说它总是返回一个上传文件的数组，所以我们将该数组传递给 `onImageDrop` 方法的 `files` 参数。我们设置了一次只能传一张图片，所以图片总是在数组的第一个位置。

调用 `handleImageUpload` ，将图片（`files[0]`）传入该方法。我将这个方法分离出一个单独的方法，遵循[单一职责原则](https://en.wikipedia.org/wiki/Single_responsibility_principle)。从本质上讲，这一原则方法教你保持方法紧凑，只做一件事。


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

### 处理图片上传和转换

首先，用 `superagent` 将我们之前设置的两个 `const` POST 到 Cloudinary 。 [`.field` 方法](https://visionmedia.github.io/superagent/#field-values) 能让我们将数据附加到 POST 请求中。这些数据包含了 Cloudinary 处理上传图片的所有信息。通过调用 `.end`，执行请求并提供回调。

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

在 `.end` 回调中，打印所有返回错误的同时，最好也告诉用户出现了一个错误。

接下来，我们接收到的响应中包含一个 URL，检查下它是不是一个空字符串。这就是图片被上传，处理后 Cloudinary 生成的一个 URL。举个例子，如果一个用户正在编辑他的资料，上传了一张图片，你可以将 Cloudinary 返回的新的图片 URL 保存到你的数据库中。

我们目前写的代码，支持用户拖拽一张图片，组件将图片发送到 Cloudinary，然后收到一个给我们用的转换后的图片 URL。

### 渲染阶段

组件最后一部分是一个 `div`，可以预览上传后的图片。

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

如果 `uploadedFileCloudinaryUrl` state 是一个空字符串，三元运算符将输出 `null` （什么都没有）。回想下，组件的 `uploadedFileCloudinaryUrl` state 默认是一个空字符串；这就意味着组件渲染时，这个 `div` 将是空的。

然而，当 Cloudinary 返回一个 URL，state 不再是空字符串，因为我们在 `handleImageUpload` 更新了 state。此时，该组件将重新渲染，显示上传的文件名称和变换后的图像的预览。

### 结束

This is just the groundwork for an image upload component. There are plenty of additional features you could add, like:

这只是为图片上传组件做的准备工作。有很多可以添加的附加功能，比如：

*   允许多图片上传
*   清除上传的图片
*   如果因为某些原因上传失败，展示错误
*   使用移动设备相机作为上传源

目前为止，这些设置已经满足我工作的需求了。硬编码上传预设不是完美的，但我还没有碰到任何问题。

希望你们已经理解了如何不用服务器端语言，使用 React 就能上传，存储和操作图片。如果你们有任何问题或者点评，我很乐意听到你们的反馈！我已经建好了一个仓库，你们可以[点击链接](https://github.com/damonbauer/react-cloudinary)查看代码.
