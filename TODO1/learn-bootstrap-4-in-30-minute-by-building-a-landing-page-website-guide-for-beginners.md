> * 原文地址：[Learn Bootstrap 4 in 30 minutes by building a landing page website](https://medium.freecodecamp.org/learn-bootstrap-4-in-30-minute-by-building-a-landing-page-website-guide-for-beginners-f64e03833f33)
> * 原文作者：[SaidHayani@](https://medium.freecodecamp.org/@saidhayani?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/learn-bootstrap-4-in-30-minute-by-building-a-landing-page-website-guide-for-beginners.md](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-bootstrap-4-in-30-minute-by-building-a-landing-page-website-guide-for-beginners.md)
> * 译者：[Zheng7426](https://github.com/Zheng7426)
> * 校对者：[Park-ma](https://github.com/Park-ma), [Moonliujk](https://github.com/Moonliujk)

# 用 30 分钟建立一个网站的方式来学习 Bootstrap 4

![](https://cdn-images-1.medium.com/max/800/1*1_a4TocueD3AqEpsDDv4bA.jpeg)

来自 [templatetoaster](https://blog.templatetoaster.com/bootstrap-4/)

![](https://cdn-images-1.medium.com/max/800/1*a9OoxPsn-hrbjYpbNV6DzA.gif)

### 新人指南

> “Bootstrap 是一个为网站及网页应用设计而生的开源前端代码库。它基于 HTML 和 CSS 的设计模板涵盖了文字设计、表单、按钮、导航、其他界面组件以及一些 JavaScript 扩展包。与很多其他网页框架不一样的是，Bootstrap 对自身的定位是仅仅适用于前端开发而已。” — [维基百科](https://en.wikipedia.org/wiki/Bootstrap_%28front-end_framework)

> [嘿嘿，在我们开始之前，你可以看看我开设的学习 Bootstrap 4 的完整课程，你不仅可以学到 bootstrap 的新特性，还能学到如何借助这些特性来实现更棒的用户体验。](https://skl.sh/2NbSAYj)。

Bootstrap 有不少版本，其中最新的是第四版。在这篇文章里我们就是要来用 Bootstrap 4 来构建一个网站。

### 必备知识

在开始学习和使用 Bootstrap 框架之前，有一些知识你得先掌握：

*   HTML 基本知识
*   CSS  基本知识
*   以及对 JQuery 略懂一二

### 目录

在构建网站的过程中我们会谈到的话题：

*   [Bootstrap 4 的下载及安装](https://medium.com/p/f64e03833f33/#57f4)
*   [Bootstrap 4 的新特性](https://medium.com/p/f64e03833f33/#8a73)
*   [Bootstrap 网格系统](https://medium.com/p/f64e03833f33/#06ac)
*   [导航栏](https://medium.com/p/f64e03833f33/#e7c2)
*   [标题](https://medium.com/p/f64e03833f33/#a500)
*   [按钮](https://medium.com/p/f64e03833f33/#74b8)
*   [“关于我”版块](https://medium.com/p/f64e03833f33/#89ac)
*   [作品集版块](https://medium.com/p/f64e03833f33/#7504)
*   [博客版块](https://medium.com/p/f64e03833f33/#9bb6)
*   [卡片](https://medium.com/p/f64e03833f33/#6767)
*   [团队版块](https://medium.com/p/f64e03833f33/#6db4)
*   [联系表单](https://medium.com/p/f64e03833f33/#971e)
*   [字体](https://medium.com/p/f64e03833f33/#f161)
*   [划动效果](https://medium.com/p/f64e03833f33/#6c7e)
*   [总结](https://medium.com/p/f64e03833f33/#a0a8)

### 下载及安装 Bootstrap 4

想要在你的项目中添上 Bootstrap 4 一共有三种办法： 

1. 通过 npm（Node 包管理器）

你可以使用这行命令来安装 Bootstrap 4 —— `npm install bootstrap`。

2. 通过 CDN（内容分发网络）

你可以在你项目的 head 标签之间添上这个链接：

```
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
```

3. 通过下载这个 [Bootstrap 4](http://getbootstrap.com/) 代码库并在本地使用。

整个项目的结构应该看起来像这样： 
![](https://cdn-images-1.medium.com/max/800/1*cyhB-vVWlIwbNpDH_JNZYg.png)

### Bootstrap 4 的新特性

Bootstrap 4 有什么新花样呢？ 它和 Bootstrap 3 又有何不同？ 

比起上一个版本，Bootstrap 4 加入了以下一些很棒的新特性：  

*   Bootstrap 4 是由 Flexbox Grid 写成的，而 Bootstrap 3 是由 float 方法写就。
    如果你没听过 Flexbox 的话可以查看[这个教程](https://scrimba.com/p/pL65cJ/canLGCw)。
*   Bootstrap 4 使用了 `rem` CSS 单位，而 Bootstrap 3 使用的是 `px`。 
    [了解这两种单位的区别](https://zellwk.com/blog/media-query-units/)
*   Panels, thumbnails 和 wells 在这个新版本中全被舍弃了。 
    想要更详细地了解在 Bootstrap 4 中被移除的特性和新增的改动吗？[点这里](http://getbootstrap.com/docs/4.0/migration/#global-changes).

先不要在意这些这些细节，我们来接着谈其他重要的话题吧。

### Bootstrap 网格系统 (Grid system)

Bootstrap 网格系统有助于创建你的布局以及轻松地构建一个响应式网站。 在 Bootstrap 4 里唯一对 class 名称的改动就是去除了 `.xs` class。

网格一共被分成了 12 列 （columns），所以你的布局将会基于这 12 列来实现。 
使用这个网格系统的前提在于，你得在主要的 _div_ 里加上一个名为 `.row` 的 class。 

```
col-lg-2 // 这个 class 适用于大型设备（如笔记本电脑）
col-md-2 // 这个 class 适用于中型设备（如平板电脑）
col-sm-2// 这个 class 适用于小型设备 （如手机）
```

### 导航栏（Navbar）

![](https://cdn-images-1.medium.com/max/800/1*VbIQyNsPrZ143nV8LaHLAg.png)

Bootstrap 4 中导航栏的封装可以说非常酷炫，它在构建一个响应式导航栏的时候可以帮上大忙。

要想运用导航栏，咱们得在文件 `index.html` 中加入 `navbar` 这个 class ：

```
<nav class="navbar navbar-expand-lg fixed-top ">
   <a class="navbar-brand" href="#">Home</a>
   <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
     <span class="navbar-toggler-icon"></span>
   </button>
   
<div class="collapse navbar-collapse " id="navbarSupportedContent">
     <ul class="navbar-nav mr-4">
       
       <li class="nav-item">
         <a class="nav-link" href="#">About</a>
       </li>
       <li class="nav-item">
         <a class="nav-link " href="#">Portfolio</a>
       </li>
       <li class="nav-item">
         <a class="nav-link " href="#">Team</a>
       </li>
       <li class="nav-item">
         <a class="nav-link " href="#">Post</a>
       </li>
       <li class="nav-item">
         <a class="nav-link " href="#">Contact</a>
       </li>
     </ul>
     
   </div>
</nav>
```

创建并加入一个 `main.css` 文件来定义你自己的 CSS 风格。

在你的 `index.html` 文件中，把以下这行代码塞入两个 `head` 标签之中： 

```
<link rel="stylesheet" type="text/css" href="css/main.css">
```

咱们给导航栏添一些色彩：

```
.navbar{
 background:#F97300;
}
.nav-link , .navbar-brand{
 color: #f4f4f4;
 cursor: pointer;
}
.nav-link{
 margin-right: 1em !important;
}
.nav-link:hover{
 background: #f4f4f4;
 color: #f97300;
}
.navbar-collapse{
 justify-content: flex-end;
}
.navbar-toggler{
  background:#fff !important;
}
```

新的 Bootstrap 网格是基于 Flexbox 构建的，所以你得使用 Flexbox 的性质来进行网站元素的排列。打个比方，若想要把导航栏菜单放在右边，咱得加入一个 `justify-content` 性质，并且赋值 `flex-end` 。

```
.navbar-collapse{  
 justify-content: flex-end;  
}
```

之后，给导航栏加上 `.fixed-top` class 并且给予其一个固定位置。
若想让导航栏的背景变成淡色，加上 `.bg-light` ；若想要一个深色的背景，则加上 `.bg-dark`。至于淡蓝色的背景，可以加上 `.bg-primary` 。

代码应该看起来如下图： 

```
.bg-dark{  
background-color:#343a40!important  
}  
.bg-primary{  
background-color:#007bff!important  
}
```

### 标题（Header）

```
<header class="header">  
    
</header>
```

咱们来试试创建一个标题的布局。

为了让标题能够占据 window 对象的高度，我们得用上一点点 JQuery 代码。
首先创建一个 `main.js` 文件，然后将其链接放在 `index.html` 文件中 `body` 的前面：

```
<script type="text/javascript" src='js/main.js'></script>
```

往 `main.js` 文件中插入这么一小点 JQuery 代码： 

```
$(document).ready(function(){  
 $('.header').height($(window).height());

})
```

如果我们往标题页配上一张不错的背景图，看起来会很酷：

```
/*header style*/
.header{
 background-image: url('../images/headerback.jpg');
 background-attachment: fixed;
 background-size: cover;
 background-position: center;
}
```

![](https://cdn-images-1.medium.com/max/800/1*LmLTI-enV2RSKjsO9hzPxQ.png)

为了让标题页看起来更专业，可以加上一个覆盖层： 

把以下代码添进你的 `index.html` 文件：

```
<header class="header">  
  <div class="overlay"></div>  
</header>
```

然后在你的 `main.css` 文件中加入这些代码：

```
.overlay{  
 position: absolute;  
 min-height: 100%;  
 min-width: 100%;  
 left: 0;  
 top: 0;  
 background: rgba(244, 244, 244, 0.79);  
}
```

现在咱们需要在标题里加上描述的部分。

为了加上描述，首先需要写一个 `div` 并给它添上叫 `.container` 的 class 。

`.container` 是一个可以封装你的内容并且使你的布局具有响应性的 Bootstrap class ：

```
<header class="header">  
  <div class="overlay"></div>  
   <div class="container">  
      
   </div>  
    
</header>
```

在那之后，另写一个包含描述版块的 `div` 。

```
<div class="description text-center">  
   <h3>  
    Hello ,Welcome To My officail Website  
    <p>  
    cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non  
    proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>  
    <button class="btn btn-outline-secondary">See more</button>  
   </h3>  
  </div>
```

咱们在这个 `div` 的 class 里写 `.description` ，并且加上 `.text-center` 来确保这个描述版块里的内容会出现在整个页面的中央。

#### 按钮（Buttons）

现在往 `button` 元素加一个名为 `.btn btn-outline-secondary` 的 class。Bootstrap 还有不少其他为按钮而生的 class 。

来看看一些例子：

* [**CodePen Embed — bootstrap 4 中的按钮**： 各种按钮样式](https://codepen.io/Saidalmaghribi/embed/oEWgbw)

以下是 `main.css` 文件中 `.description` 的 CSS 代码：

```
.description{  
    position: absolute;  
    top: 30%;  
    margin: auto;  
    padding: 2em;

}  
.description h1{  
 color:#F97300 ;  
}  
.description p{  
 color:#666;  
 font-size: 20px;  
 width: 50%;  
 line-height: 1.5;  
}  
.description button{  
 border:1px  solid #F97300;  
 background:#F97300;  
 color:#fff;  
}
```

至此，咱们的标题看起来会是这样的： 

![](https://cdn-images-1.medium.com/max/800/1*kV7umhOF5QPveMmADXUCSw.png)

有没有很炫？ :)

### “关于我”版块（About)

![](https://cdn-images-1.medium.com/max/800/1*VWnyo3Jg4brsW5YRZToCiQ.png)

咱们会用一些 Bootstrap 网格来将这个板块一分为二。
开始使用网格的前提在于，咱们必须让 `.row` 这个 class 成为 parent `div`。（译者注：把这个div放在最外面）

```
<div class="row></div>
```

第一个部分会在左边，包含一张图片。第二个部分会在右边，包含一段描述。

每一个 `div` 会占据 6 列 —— 也就是说整个版块一半的空间。要记住一个网格被分成了 12 列。

在左边第一个 `div` 里面：

```
<div class="row"> 
 // 左边
<div class="col-lg-4 col-md-4 col-sm-12">
    <img src="images/team-3.jpg" class="img-fluid">
    <span class="text-justify">S.Web Developer</span>
 </div>
</div>
```

在给右边的版块加入 HTML 元素之后，整个代码的结构看起来会是这样子：

```
<div class="row">
   <div class="col-lg-4 col-md-4 col-sm-12">
    <img src="images/team-3.jpg" class="img-fluid">
    <span class="text-justify">S.Web Developer</span>
   </div>
   <div class="col-lg-8 col-md-8 col-sm-12 desc">
     
    <h3>D.John</h3>
    <p>
       ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
     tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
     quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
     consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
     cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
     proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
    </p>
   </div>
</div>
```

这里是我对其外观的改动：

```
.about{
 margin: 4em 0;
 padding: 1em;
 position: relative;
}
.about h1{
 color:#F97300;
 margin: 2em;
}
.about img{
 height: 100%;
    width: 100%;
    border-radius: 50%
}
.about span{
 display: block;
 color: #888;
 position: absolute;
 left: 115px;
}
.about .desc{
 padding: 2em;
 border-left:4px solid #10828C;
}
.about .desc h3{
 color: #10828C;
}
.about .desc p{
 line-height:2;
 color:#888;
}
```

### 作品集版块（Portfolio）

现在咱们再接再厉，来创建一个包含一个图库的作品集版块。
![](https://cdn-images-1.medium.com/max/800/1*fNaqxcagCvh8Ue3lZvK6Vw.png)

作品集版块的 HTML 代码的结构看起来是这样子的：
```
<!-- portfolio -->
<div class="portfolio">
     <h1 class="text-center">Portfolio</h1>
 <div class="container">
  <div class="row">
   <div class="col-lg-4 col-md-4 col-sm-12">
    <img src="images/portfolio/port13.png" class="img-fluid">
   </div>
   <div class="col-lg-4 col-md-4 col-sm-12">
    <img src="images/portfolio/port1.png" class="img-fluid">
   </div>
   <div class="col-lg-4 col-md-4 col-sm-12">
    <img src="images/portfolio/port6.png" class="img-fluid">
   </div>
<div class="col-lg-4 col-md-4 col-sm-12">
    <img src="images/portfolio/port3.png" class="img-fluid">
   </div>
   <div class="col-lg-4 col-md-4 col-sm-12">
    <img src="images/portfolio/port11.png" class="img-fluid">
   </div>
   <div class="col-lg-4 col-md-4 col-sm-12">
    <img src="images/portfolio/electric.png" class="img-fluid">
   </div>
<div class="col-lg-4 col-md-4 col-sm-12">
    <img src="images/portfolio/Classic.jpg" class="img-fluid">
   </div>
   <div class="col-lg-4 col-md-4 col-sm-12">
    <img src="images/portfolio/port1.png" class="img-fluid">
   </div>
   <div class="col-lg-4 col-md-4 col-sm-12">
    <img src="images/portfolio/port8.png" class="img-fluid">
   </div>
  </div>
 </div>
</div>
```

给每一张图片加入 `.img-fluid` 使其具备响应性。 

咱们图库中每一张图片会占据 4 列（记住，`col-md-4`适用于中型设备，`col-lg-4` 适用于大型设备），也就是说相当于大型设备（如台式机和大型平板电脑）宽度的  33.3333% 。同样的，小型设备上（如手机）的 12 列将占据整个容器宽度的 100% 。
给咱们的图库加上些风格样式：

```
/*作品集*/
.portfolio{
 margin: 4em 0;
    position: relative; 
}
.portfolio h1{
 color:#F97300;
 margin: 2em; 
}
.portfolio img{
  height: 15rem;
  width: 100%;
  margin: 1em;
}
```

### 博客版块(Blog)

![](https://cdn-images-1.medium.com/max/800/1*3y9bIjRwf2RtGRzMIXwZIQ.png)

#### 卡片(Card)

Bootstrap 4 中的卡片使得设计博客简单了好多。这些卡片适用于文章和帖子。 

为了创建卡片，咱们使用名为 `.card` 的 class ，并且写在一个 _div_ 元素里。

这个卡片 class 包含不少特性：

*   `.card-header`: 定义卡片的标题
*   `.card-body`:  用于卡片的主体
*   `.card-title`: 卡片的题目
*   `card-footer`:  定义卡片的脚注
*   `.card-image`: 用于卡片的图像

所以呢，咱们网站的 HTML 看起来会是这样的： 
```
<!-- Posts section -->
<div class="blog">
 <div class="container">
 <h1 class="text-center">Blog</h1>
  <div class="row">
   <div class="col-md-4 col-lg-4 col-sm-12">
    <div class="card">
     <div class="card-img">
      <img src="images/posts/polit.jpg" class="img-fluid">
     </div>
     
     <div class="card-body">
     <h4 class="card-title">Post Title</h4>
      <p class="card-text">
       
       proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
      </p>
     </div>
     <div class="card-footer">
      <a href="" class="card-link">Read more</a>
     </div>
    </div>
   </div>
   <div class="col-md-4 col-lg-4 col-sm-12">
    <div class="card">
     <div class="card-img">
      <img src="images/posts/images.jpg" class="img-fluid">
     </div>
     
     <div class="card-body">
        <h4 class="card-title">Post Title</h4>
      <p class="card-text">
       
       proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
      </p>
     </div>
     <div class="card-footer">
      <a href="" class="card-link">Read more</a>
     </div>
    </div>
   </div>
   <div class="col-md-4 col-lg-4 col-sm-12">
    <div class="card">
     <div class="card-img">
      <img src="images/posts/imag2.jpg" class="img-fluid">
     </div>
     
     <div class="card-body">
     <h4 class="card-title">Post Title</h4>
      <p class="card-text">
       
       proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
      </p>
     </div>
     <div class="card-footer">
      <a href="" class="card-link">Read more</a>
     </div>
    </div>
   </div>
  </div>
 </div>
</div>
```

我们需要往卡片里加一些 CSS ： 

```
.blog{  
 margin: 4em 0;  
 position: relative;   
}  
.blog h1{  
 color:#F97300;  
 margin: 2em;   
}  
.blog .card{  
 box-shadow: 0 0 20px #ccc;  
}  
.blog .card img{  
 width: 100%;  
 height: 12em;  
}  
.blog .card-title{  
 color:#F97300;  
    
}  
.blog .card-body{  
 padding: 1em;  
}
```

添加了博客版块之后，网站的设计看起来会是这样的： 

![](https://cdn-images-1.medium.com/max/800/1*mHMPSea2jWdZ2dc_b658eA.png)

有没有非常炫？ 😄

### 团队版块 (Team)

![](https://cdn-images-1.medium.com/max/800/1*1PaKtdHChKl534aExUfjCQ.png)

在这个版块里我们会使用网格系统来平均地分配图片与图片之间的空间。每一张图片占据容器的 3 列 (`.col-md-3`) —— 等于是整个空间的 25% 。
咱们的 HTML 结构：

```
<!-- 团队版块 -->
<div class="team">
 <div class="container">
    <h1 class="text-center">Our Team</h1>
  <div class="row">
   <div class="col-lg-3 col-md-3 col-sm-12 item">
    <img src="images/team-2.jpg" class="img-fluid" alt="team">
    <div class="des">
      Sara
     </div>
    <span class="text-muted">Manager</span>
   </div>
   <div class="col-lg-3 col-md-3 col-sm-12 item">
    <img src="images/team-3.jpg" class="img-fluid" alt="team">
    <div class="des">
       Chris
     </div>
    <span class="text-muted">S.enginner</span>
   </div>
   <div class="col-lg-3 col-md-3 col-sm-12 item">
    <img src="images/team-2.jpg" class="img-fluid" alt="team">
    <div class="des">
      Layla 
     </div>
    <span class="text-muted">Front End Developer</span>
   </div>
   <div class="col-lg-3 col-md-3 col-sm-12 item">
    <img src="images/team-3.jpg" class="img-fluid" alt="team">
     <div class="des">
      J.Jirard
     </div>
    <span class="text-muted">Team Manger</span>
   </div>
  </div>
 </div>
</div>
```

现在加上一些风格样式：

```
.team{
 margin: 4em 0;
 position: relative;  
}
.team h1{
 color:#F97300;
 margin: 2em; 
}
.team .item{
 position: relative;
}
.team .des{
 background: #F97300;
 color: #fff;
 text-align: center;
 border-bottom-left-radius: 93%;
 transition:.3s ease-in-out;
}

```

在图片的悬浮效果上用动画加上一个覆盖层会很不错 😄。

![](https://cdn-images-1.medium.com/max/800/1*SxGguj9S8JMncs-D3uNcsA.gif)

为了达到这个效果，在 `main.css` 中加入以下风格样式： 

```
.team .item:hover .des{  
 height: 100%;  
 background:#f973007d;  
 position: absolute;  
 width: 89%;  
 padding: 5em;  
 top: 0;  
 border-bottom-left-radius: 0;  
}
```

超级酷炫有木有！ 😙

### 联络表单（Contact Form)

![](https://cdn-images-1.medium.com/max/800/1*vaI3jh3TFwSKBn6BcsBedw.png)

在咱们完事之前，联络表单是需要添加的最后一个版块😃。

这个版块会包含一个访问者可以发送电子邮件或提出反馈的表单。咱们将使用一些 Bootstrap classes 来使设计看起来又漂亮又具有响应性。

就像 Bootstrap 3 那样，对于对输入栏，Bootstrap 4 也运用了名为 `.form-control` 的 class ，但是还有些新的特性可以使用 —— 比如说从使用 `.input-group-addon`（已经停用）转换到 `**.input-group-prepend**` （像使用 label 那样来使用 icon）。

想要了解更多这方面的资料的话可以查看 [Bootstrap 4 文档] (https://getbootstrap.com/docs/4.0/migration/#input-groups)。在咱们的联络表单中我们将封装每一个拥有 class `.form-group` 的 `div` 之间的输入栏。
现在 `index.html` 文件的代码看起来会是这样的：

```
<!-- 联络表单 -->
<div class="contact-form">
 <div class="container">
  <form>
   <div class="row">
    <div class="col-lg-4 col-md-4 col-sm-12">
      <h1>Get in Touch</h1> 
    </div>
    <div class="col-lg-8 col-md-8 col-sm-12 right">
       <div class="form-group">
         <input type="text" class="form-control form-control-lg" placeholder="Your Name" name="">
       </div>
       <div class="form-group">
         <input type="email" class="form-control form-control-lg" placeholder="YourEmail@email.com" name="email">
       </div>
       <div class="form-group">
         <textarea class="form-control form-control-lg">
          
         </textarea>
       </div>
       <input type="submit" class="btn btn-secondary btn-block" value="Send" name="">
    </div>
   </div>
  </form>
 </div>
</div>
```

联络版块的风格样式：

**main.css**

```
.contact-form{
 margin: 6em 0;
 position: relative;  
}
.contact-form h1{
 padding:2em 1px;
 color: #F97300; 
}
.contact-form .right{
 max-width: 600px;
}
.contact-form .right .btn-secondary{
 background:  #F97300;
 color: #fff;
 border:0;
}
.contact-form .right .form-control::placeholder{
 color: #888;
 font-size: 16px;
}
```

#### 字体 (Font)

我觉着系统自带的字体比较丑陋，所以使用了 Google Font 接口，然后选择 Google 字体里的 **Raleway** 。这是个不错的字体而且很适合咱们的样板。

在你的 `main.css` 文件中添上这个链接： 

```
@import url('https://fonts.googleapis.com/css?family=Raleway');
```

然后设置 HTML 和标题标签的全局风格样式：

```
html,h1,h2,h3,h4,h5,h6,a{
 font-family: "Raleway";
}
```

#### 划动效果 (Scroll Effect)

![](https://cdn-images-1.medium.com/max/800/1*a9OoxPsn-hrbjYpbNV6DzA.gif)

最后缺席的就是划动效果了。现在我们将要用到一些 JQuery 。如果你对 JQuery 不是很熟悉，不要担心，直接复制粘贴以下的代码到你的 `main.js` 文件：

```
$(".navbar a").click(function(){  
  $("body,html").animate({  
   scrollTop:$("#" + $(this).data('value')).offset().top  
  },1000)  
    
 })
```

然后给每一个导航栏链接加上 `data-value` 特性：

```
<li class="nav-item">  
         <a class="nav-link" data-value="about" href="#">About</a>  
       </li>  
       <li class="nav-item">  
         <a class="nav-link " data-value="portfolio" href="#">Portfolio</a>  
       </li>  
       <li class="nav-item">  
         <a class="nav-link " data-value="blog" href="#">Blog</a>  
       </li>  
       <li class="nav-item">  
         <a class="nav-link " data-value="team" href="#">  
         Team</a>  
       </li>  
       <li class="nav-item">  
         <a class="nav-link " data-value="contact" href="#">Contact</a>  
       </li>
```

再给每一个版块加上 `id` 属性。

**记住**: 为了使拉动效果正常工作，`id` 必须要和导航栏链接中的 `data-value` 属性一模一样：

```
<div class="about" id="about"></div>
```

### 总结

Bootstrap 4 是一个构建你网页应用很棒的选择。它提供高质量的 UI 元素而且易于自定义调整、与其他框架组合以及使用。不但如此，它也帮助你在网页中加入响应性，所以能够给你的用户带来非常棒的体验。

关于这个项目的文件都可以在[这里找到] (https://github.com/hayanisaid/bootstrap4-website)。

要想学习 Bootstrap 4，也可以查看我的 Bootstrap 课程： 

* [**Bootstrap 4 crash course: 从基础到进阶 | Said Hayani | Skillshare**: 在这个课程里你将学习 Bootstrap 的第四版，是一个 CSS 框架用以构建灵活的页面以及……](https://skl.sh/2LaD1ym)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
