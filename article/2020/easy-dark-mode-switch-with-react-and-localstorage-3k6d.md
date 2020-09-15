> * 原文地址：[Easy Dark Mode Switch with React and localStorage](https://dev.to/alekswritescode/easy-dark-mode-switch-with-react-and-localstorage-3k6d)
> * 原文作者：[Aleks Popovic](https://dev.to/alekswritescode)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/easy-dark-mode-switch-with-react-and-localstorage-3k6d.md](https://github.com/xitu/gold-miner/blob/master/article/2020/easy-dark-mode-switch-with-react-and-localstorage-3k6d.md)
> * 译者：
> * 校对者：

# Easy Dark Mode Switch with React and localStorage

![Cover image for Easy Dark Mode Switch with React and localStorage](https://res.cloudinary.com/practicaldev/image/fetch/s--lHC3LOAh--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://dev-to-uploads.s3.amazonaws.com/i/7x4y32vfxgcyhx8rggob.png)

Having a dark mode on a website or application has become very popular. Many big websites and applications are coming up with their own version of it and if you want to make one for your own React app you can easily do so with very little JavaScript code and a bit of custom CSS.

I am going to show you how you can make a simple, yet versatile React component which you can use to change your website's mode from light to dark. If you want you can later expand it to handle multiple application skins or themes.

If you prefer a video version you can watch me create this Dark Mode component on Youtube:

I started a new create-react-app project and I've modified it a bit by adding some HTML to the App component. There is a simple nav bar, some text paragraphs and an image div that we will use to show how to switch image backgrounds between different page modes.

I also created a new component in the components folder and named it DarkMode.js. We will also add a CSS file for styling it which we will call DarkMode.css. We can import both of them in the App component right away.  

```jsx
import React from "react"
import "./styles/App.css"
import DarkMode from "./components/DarkMode"

function App() {
  return (
    <div className="App">
      <nav>
        <a href="/">Home</a>
        <a href="/">Projects</a>
        <a href="/">About</a>
        <a href="/">Contact</a>
        <DarkMode />
      </nav>
      <h1>Hello World</h1>
      <div id="image"></div>
      <p>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum eget
        scelerisque neque, quis scelerisque erat. Quisque venenatis molestie
        sapien, dapibus viverra nulla hendrerit eget. Pellentesque egestas
        ultrices accumsan. Ut ac magna vel ex maximus ultricies. Nulla facilisi.
        Suspendisse gravida sem eu odio mattis ullamcorper. Curabitur feugiat
        ipsum vel vulputate ultricies.
      </p>
      <p>
        Praesent pulvinar faucibus risus in iaculis. Sed erat felis, pretium sit
        amet ultricies non, porta et lacus. Curabitur a urna mi. Sed eleifend
        sed erat eget viverra. Quisque sit amet purus viverra massa posuere
        congue. Suspendisse efficitur venenatis enim, id hendrerit enim ultrices
        sed. Nam sed dapibus nisi.
      </p>
    </div>
  )
}
export default App
```

We will start building out the component by making it a constant with no inputs and export it as a default. Its basic functionality is going to be returning a button element which we will use to change the mode or theme. Lets import the CSS file right away and we will change its contents later.  

```jsx
import React from "react";
import "../styles/DarkMode.css";

const DarkMode = () => {
  return (
    <button></button>
  );
};

export default DarkMode;
```

For everything to work we need to set up a few properties.  

```jsx
import React from "react";
import "../styles/DarkMode.css";

const DarkMode = () => {
  let clickedClass = "clicked";
  const body = document.body;
  const lightTheme = "light";
  const darkTheme = "dark";
  let theme;

  return (
    <button></button>
  );
};

export default DarkMode;
```

The body is the document's body element. We need a reference to it so we can apply different styling to it once we click the dark mode button. Light theme and dark theme are going to be the class names that we will apply to the body. Theme is a local property which we will use to handle the currently selected theme or mode.

The clicked class is going to be applied to the button when we click on it. This way we will signal the change of its state. Since we are mentioning state you may be wondering if we will use React's state to set up our logic and the answer is no, we will not. We could, but it's a really simple use case that doesn't require it. What we will do is use the local storage, which is browser's internal memory space designed just for stuff like this. It has a limited memory capacity and it's not considered secure, but it's perfect for a situation like this where you just need to keep track of a single property value. Local storage is also very handy because its values persist when you switch the page or close the browser altogether, so you can set the values and not worry about them getting deleted or expiring.

In terms of JavaScript - the local storage is an object which is a part of the window object, so we can access it directly and try to find an item that's stored inside. For this we use the getItem function and pass in the property we are looking for.  

```jsx
import React from "react";
import "../styles/DarkMode.css";

const DarkMode = () => {
  let clickedClass = "clicked";
  const body = document.body;
  const lightTheme = "light";
  const darkTheme = "dark";
  let theme;

  if (localStorage) {
    theme = localStorage.getItem("theme");
  }

  if (theme === lightTheme || theme === darkTheme) {
    body.classList.add(theme);
  } else {
    body.classList.add(lightTheme);
  }

  return (
    <button></button>
  );
};

export default DarkMode;
```

In this case we will be expecting to find one of the two values - light or dark, because these are the values we will be setting in the local storage. If we find such value we will add that CSS class to the document body. If not we will default to not using the dark mode by setting the light class. Of course, if you want dark mode to be the default value you can do that too.

To make our button do something on click we need to set up an on click event for it which we'll call the switchTheme function. We will also add an id to it so we can style it more easily later, and we will add the clicked class to it if the dark mode is on.  

```jsx
import React from "react";
import "../styles/DarkMode.css";

const DarkMode = () => {
  let clickedClass = "clicked";
  const body = document.body;
  const lightTheme = "light";
  const darkTheme = "dark";
  let theme;

  if (localStorage) {
    theme = localStorage.getItem("theme");
  }

  if (theme === lightTheme || theme === darkTheme) {
    body.classList.add(theme);
  } else {
    body.classList.add(lightTheme);
  }

  const switchTheme = (e) => {
    if (theme === darkTheme) {
      body.classList.replace(darkTheme, lightTheme);
      e.target.classList.remove(clickedClass);
      localStorage.setItem("theme", "light");
      theme = lightTheme;
    } else {
      body.classList.replace(lightTheme, darkTheme);
      e.target.classList.add(clickedClass);
      localStorage.setItem("theme", "dark");
      theme = darkTheme;
    }
  };

  return (
    <button
      className={theme === "dark" ? clickedClass : ""}
      id="darkMode"
      onClick={(e) => switchTheme(e)}
    ></button>
  );
};

export default DarkMode;
```

The switch theme function is going to check which theme is currently active and do a couple of different things depending on that. If the dark mode is currently on it will replace the dark theme body class with the light one. It will remove the clicked class from the dark mode button and set the local storage theme property to light. Finally, we will set the theme property to light theme, since dark mode will no longer be active.

In case the dark mode was already off we will want to turn it on. To do that we will do almost the same thing as before. We replace the light theme body class with the dark one, mark the button as clicked, set the local storage property to dark and finally set the theme to dark.

With this, our component is finished and we can import it inside of the App component. Now we need to set up its CSS.  

```css
#darkMode {
  background: transparent url("../moon.png") no-repeat center;
  background-size: 30px 30px;
  width: 45px;
  height: 45px;
  filter: grayscale(100%);
  border: none;
  border-radius: 50%;
  transition: background-color 0.3s ease-in-out, filter 0.3s ease-in-out;
}

#darkMode:hover,
#darkMode:focus {
  filter: none;
  background-color: black;
  cursor: pointer;
}

#darkMode.clicked {
  filter: none !important;
  background-color: black;
}
```

Our button has the dark mode Id so that's what we will use to style it. For the background image I am using a [moon icon that I found on flaticon.com](https://www.flaticon.com/free-icon/moon_768442). I am setting its dimensions and borders so it's shaped like a circle and I'm adding it a grayscale filter so it looks grayed-out when in default non-clicked state.

For hover and focus states we are going to remove the filter and set the background to black, so the icon looks like a yellow moon and stars with a night sky background. We will do the same for the clicked button class.

Our components CSS is now set up and we need to take care of the two body classes, one for dark mode and one for light mode. To change between two different looks we will use CSS variables. You can declare them anywhere you want if the body element has access to them. As as start we will add two color variables in the root selector.  

```css
:root {
  --blue: rgb(26, 57, 87);
  --white: rgb(236, 236, 236);
}
```

To simplify the example I will use the white color for background and the blue color for text in light mode and we will switch between them when we turn on the dark mode. To do so we will add more CSS variables inside of the light class selector, which will use the variables from the root. We will also modify the font weight when switching themes, as well as the background image below the hello world heading. This is not something I recommend doing, especially for the background image, but it is an option if you want to play around with it.  

```css
body.light {
  --background-color: var(--white);
  --text-color: var(--blue);
  --font-weight: 400;
  --image: url("../day.jpg");
}
```

For the dark mode class we will do something similar. We will switch the colors for background and text, give the font a bit more weight and we'll use a different night time image.  

```css
body.dark {
  --background-color: var(--blue);
  --text-color: var(--white);
  --font-weight: 500;
  --image: url("../night.jpg");
}
```

Now that we have dark and light mode classes set up we need to make the body selector use them, which is easy enough. Just set your properties to use the correct CSS variables. We can also set our background and color transition so the mode switch isn't so sudden.  

```css
body {
  background: var(--background-color);
  color: var(--text-color);
  font-weight: var(--font-weight);
  transition: background 0.3s ease-in-out, color 0.6s ease-in-out;
}
```

Of course, we also need to set up the image container to use the image variable.  

```css
#image {
  width: 100%;
  height: 300px;
  background-attachment: fixed;
  background-position: center;
  background-repeat: no-repeat;
  background-size: cover;
  transition: background-image 0.7s ease-in-out;
  background-image: var(--image);
}
```

If we want to take this a bit further, we can also set up the nav bar to change the background and text color in different modes.  

```css
nav {
  padding: 1rem 25%;
  margin: 0 auto;
  display: flex;
  justify-content: space-evenly;
  align-items: center;
  background: var(--text-color);
}

nav a {
  text-decoration: none;
  text-transform: uppercase;
  color: var(--background-color);
}

```

If you followed through everything you should now have your own functioning customizable dark mode switch built in React. If you want to take a closer look at the project code you can grab the source files on [GitHub](https://github.com/alekspopovic/DarkMode) along with all of the images I used for it.


> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
