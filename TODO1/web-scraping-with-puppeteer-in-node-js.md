> * 原文地址：[Web Scraping with Puppeteer in Node.js](https://medium.com/javascript-in-plain-english/web-scraping-with-puppeteer-in-node-js-4a32d85df183)
> * 原文作者：[Belle Poopongpanit](https://medium.com/@bellex0)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/web-scraping-with-puppeteer-in-node-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/web-scraping-with-puppeteer-in-node-js.md)
> * 译者：
> * 校对者：

# Web Scraping with Puppeteer in Node.js

![](https://cdn-images-1.medium.com/max/2328/1*laoZh8fB6iCGTuBbR_2zig.png)

Have you ever wanted to use your favorite company’s or favorite website’s API for a new app project and discovered that they either a) never had one to begin with or b) eradicated it’s API for public use? (I’m looking at you, Netflix) Well, that’s what happened to me and being the persistent person that I am, I uncovered a solution for this problem: web scraping.

Web scraping is the technique of automatically extracting and collecting data from a website using software. After collecting the data, you can use it to make your own API’s.

There are numerous technologies that can be used for web scraping; Python is a popular language that is used. However, I am a JavaScript kinda girl. So, in this blog I will use Node.js and Puppeteer.

Puppeteer is a Node.js library that allows us to run a Chrome browser in the background (called a headless browser since it doesn’t need a graphic user interface) and helps extract data from a website.

Since the majority of us have been held hostage in our homes by COVID-19, Netflix binge-watching has been a popular pastime for many (what else are we supposed to do aside from crying?). To support my fellow indecisive and bored Netflix-watchers, I found a website, [https://www.digitaltrends.com/movies/best-movies-on-netflix/](https://www.digitaltrends.com/movies/best-movies-on-netflix/) that lists the current best movies to watch in April 2020. Once I scrape this page and retrieve the data, I want to store it in a JSON file. That way, if I ever need a best current Netflix movies API, I can go back and obtain the data from this repository.

## Getting Started

To get started, I created a folder in my VSCode called `webscraper` . Within the folder, I will create a file called `netflixscrape.js` .

In the terminal, we need to install puppeteer.

```
npm i puppeteer
```

Next, we need to import the required modules and libraries. The first lines of code in `netflixscrape.js` will be:

```
const puppeteer= require('puppeteer')
const fs = require('fs')
```

`fs` is the Node.js file system module. We will need to use this to create a JSON file from our data.

## Writing the scrape function

Let’s begin coding our `scrape()` function.

```
async function scrape (url) {
const browser = await puppeteer.launch();
const page = await browser.newPage();
await page.goto(url)
```

`scrape()` is going to take in an argument of a url. We start up our browser using `puppeteer.launch()` . `browser.newPage()` opens a blank page on the browser. Then, we tell the browser to go to the specified url.

#### How to retrieve the data we want to scrape

In order to scrape the data we want from the site, we need to grab the data using their specific HTML elements. Go to [https://www.digitaltrends.com/movies/best-movies-on-netflix/](https://www.digitaltrends.com/movies/best-movies-on-netflix/) and open up Inspector/Chrome DevTools. To do this:

“command + option + j” on a Mac or “control + shift + j” on Windows

Since I want to grab the movies’ titles and their summaries from the article, I see that I have to select `h2` elements (title) and its’ sibling `p` elements (summary).

![h2 for movie title](https://cdn-images-1.medium.com/max/5724/1*BEQd106SvxT1_jGuS4I23A.png)

![p for movie summary](https://cdn-images-1.medium.com/max/5760/1*RH8gGDJeIGE8Wz3VcDgyaQ.png)

#### How to manipulate the retrieved data

Continuing with our code:

```
var movies = await page.evaluate(() => {
   var titlesList = document.querySelectorAll('h2');
   var movieArr = [];

   for (var i = 0; i < titlesList.length; i++) {
      movieArr[i] = {
     title: titlesList[i].innerText.trim(),
     summary: titlesList[i].nextElementSibling.innerText.trim()
   };
}
return movieArr;
})
```

`page.evaluate()` is used to enter the DOM of the website and allows us to run custom JavaScript code as if we were executing it in the DevTools console.

`document.querySelector('h2')` selects ALL `h2` elements on the page. We save them all in the `titlesList` variable.

Then, we create an empty array called `movieArr`.

We want to save each movie’s title and summary in their own individual object. In order to do this, we run a **for loop**. The loop indicates that each element in the `movieArr` is equal to an object with properties of `title` and `summary`.

To get the movie title, we have to go through the `titlesList`, which are all `h2` element nodes. We apply the `innerText` property to get the text of the `h2`. Then, we apply the `.trim()` method to remove any white space.

If you’ve carefully navigated through the DevTools console, you’ll notice that the page has many `p` elements with no unique classes or id’s. Thus, it’s really difficult to precisely grab the summary `p` element we need. In order to get around this, we call the `.nextElementSibling` property on the `h2` node (titlesList[i]). When you take a closer look at the console, you see that the `p` element of the summary is a sibling of the `h2` element of the title.

#### Storing the scraped data to a JSON file

Now that we’ve completed the main data extraction part, let’s store all of this in a JSON file.

```
fs.writeFile("./netflixscrape.json", JSON.stringify(movies, null, 3), (err) => {
if (err) {
console.error(err);
return;
};
console.log("Great Success");
});
```

`fs.writeFile()` creates a new JSON file containing our movies data. It takes in 3 arguments: 1) the name of the file to be created

2) **JSON**. **stringify**() method converts a JavaScript object to a **JSON** string. Takes in 3 arguments here. The object: `movies`, replacer (which filters out what properties you do or don’t want to be included): `null `, and space (used to insert white space into the output JSON string for readability): `3` . This way essentially makes the JSON file prettier and clean.

3) `err`, in case we get an error

`err` takes a callback function which states that if there is an error, console.log the error. If there is no error, console.log “Great Success.”

Finally, putting the whole code together:

We add `browser.close()` to close the puppeteer browser. We call the `scrape()` function in the last line with our url.

## Last Step: Run scrape() function

Let’s run this code by typing `node netflixscrape.js` in the terminal.

If all goes well (which it should), you will get “Great Success” in your console and you will see a newly created JSON file with all the Netflix movie titles and summaries.

![](https://cdn-images-1.medium.com/max/5220/1*J8LazvNXbPlTgSCTs0n5cQ.png)

Congrats!!👏 You’re officially a hacker! Just kidding. But now you know how to scrape the web to obtain data and create your own API’s, which is so much more thrilling.

#### A note from JavaScript In Plain English

We have launched three new publications! Show some love for our new publications by following them: [**AI in Plain English**](https://medium.com/ai-in-plain-english), [**UX in Plain English**](https://medium.com/ux-in-plain-english), **[Python in Plain English](https://medium.com/python-in-plain-english)** — thank you and keep learning!

We are also always interested in helping to promote quality content. If you have an article that you would like to submit to any of our publications, send us an email at **[submissions@plainenglish.io](mailto:submissions@plainenglish.io)** with your Medium username and we will get you added as a writer. Also let us know which publication/s you want to be added to.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
