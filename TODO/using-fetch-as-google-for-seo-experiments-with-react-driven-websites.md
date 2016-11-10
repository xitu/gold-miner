> * 原文地址：[Testing a React-driven website’s SEO using “Fetch as Google”](https://medium.freecodecamp.com/using-fetch-as-google-for-seo-experiments-with-react-driven-websites-914e0fc3ab1#.sv5ov6im3)
* 原文作者：[Patrick Hund](https://medium.freecodecamp.com/@wiekatz)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Testing a React-driven website’s SEO using “Fetch as Google”
I recently tested whether client-side rendering would prevent websites from being crawled by search engine robots. As [my article](https://medium.freecodecamp.com/seo-vs-react-is-it-neccessary-to-render-react-pages-in-the-backend-74ce5015c0c9#.eg3w0nh17) showed, React doesn’t seem to hurt search engine indexing at all.

Now I’m taking it to the next level. I’ve set up a sandbox React project to see exactly what Google can crawl and index.

### Setting up a small web application

My goal was to create a bare-bones React application, and minimize time spent configuring Babel, webpack, and other tools. I would then deploy this app to a publicly accessible website as quickly as possible.

I also wanted to be able to deploy updates to production within seconds.

Given these goals, the ideal tools were [create-react-app](https://github.com/facebookincubator/create-react-app) and GitHub Pages.

With _create-react-app_, I built a little React app within 30 minutes. It was just a matter of typing these commands:

    create-react-app seo-sandbox
    cd seo-sandbox/
    npm start

I changed the default text and logo, played around with the formatting, and voilá — a web page that is rendered 100% on the client side, to give the Googlebot something to chew on!

You can see my project [on GitHub](https://github.com/pahund/seo-sandbox).

### Deploying to GitHub Pages

_create-react-app_ was helpful. Almost psychic. After I did an _npm run build_, it recognized that I was planning to publish my project on GitHub Pages, and told me how to do this:









![](https://cdn-images-1.medium.com/max/1600/1*7CQ1cPQcIOdIX_a_lYqiew.png)





Here’s my SEO Sandbox hosted on GitHub Pages: [https://pahund.github.io/seo-sandbox/](https://pahund.github.io/seo-sandbox/)









![](https://cdn-images-1.medium.com/max/1600/1*Gt05ZDhSLvblN6MSmZ3xSg.png)



I used “Argelpargel” as name for my website because that’s a word that Google had zero search results for



### Configuring the Google Search Console

Google provides a free suite of tools called the [Google Search Console](https://www.google.com/webmasters/tools) for web masters to test their websites.

To set it up, I added what they call a “property” for my web page:









![](https://cdn-images-1.medium.com/max/1600/1*nub51dXnRU6rkpDjU2tkvQ.png)





To verify that I am in fact the owner of the website, I had to upload a special file for Google to find to the website. Thanks to the nifty _npm run deploy_mechanism, I was able to do this in a matter of seconds.

### Looking at my web page through Google’s eyes

With the configuration done, I could now use the “Fetch as Google” tool to look at my SEO sandbox page the way the Googlebot sees it:









![](https://cdn-images-1.medium.com/max/1600/1*JEcIMWqYZUEud80zFUjppQ.png)





When I clicked on “Fetch and Render”, I could examine what parts of my React-driven page could actually be indexed by Googlebot:









![](https://cdn-images-1.medium.com/max/1600/1*DSNHJvO_S2H3oAJHKiWkCw.png)





### What I’ve discovered so far

#### Discovery #1: Googlebot reads content that is loaded asynchronously

The first thing I wanted to test was whether Googlebot will not index or crawl parts of the page that are rendered asynchronously.

After the page has been loaded, my React app does an Ajax request for data, then updates parts of the page with that data.

To simulate this, I added a constructor to my App component that sets component state with a [window.setTimeout](https://developer.mozilla.org/en-US/docs/Web/API/WindowTimers/setTimeout) call.

    constructor(props) {
        super(props);
        this.state = {
            choMessage: null,
            faq1: null,
            faq2: null,
            faq3: null
        };
        window.setTimeout(() => this.setState(Object.assign(this.state, {
            choMessage: 'yada yada'
        })), 10);
        window.setTimeout(() => this.setState(Object.assign(this.state, {
            faq1: 'bla bla'
        })), 100);
        window.setTimeout(() => this.setState(Object.assign(this.state, {
            faq2: 'shoo be doo'
        })), 1000);
        window.setTimeout(() => this.setState(Object.assign(this.state, {
            faq3: 'yacketiyack'
        })), 10000);
    }

→ [See the actual code on GitHub](https://github.com/pahund/seo-sandbox/blob/v1.0.0/src/App.js#L14)

I used 4 different timeouts of 10 milliseconds, 100 milliseconds, 1 second and 10 seconds.

As it turns out, Googlebot will only give up on the 10-second timeout. The other 3 text blocks show up in the “Fetch as Google” window:









![](https://cdn-images-1.medium.com/max/1600/1*rsEVVsvrbTyOJtQHh24Xfg.png)





#### React Router confuses Googlebot

I added [React Router](https://react-router.now.sh/) (version 4.0.0-alpha.5) to my web app to create a menu bar that loads various sub pages (copied and pasted straight from their docs):









![](https://cdn-images-1.medium.com/max/1600/1*aZPZSQDC7WyneE2PcHRCvA.png)





Surprise, surprise — when I did a “Fetch As Google” I just got an empty green page:









![](https://cdn-images-1.medium.com/max/1600/1*nq4ujsqCxHz5zeMEuxuPoA.png)





It appears that using React Router for client-side-rendered pages is problematic in terms of search engine friendliness. It remains to be seen whether this is only a problem of the alpha version of React Router 4, or if it is also a problem with the stable React Router 3.

### Future experiments

Here are some other things I want to test with my setup:

*   does Googlebot follow links in the asynchronously rendered text blocks?
*   can I set meta tags like _description_ asynchronously with my React application and have Googlebot understand them?
*   how long does it take Googlebot to crawl a React-rendered website with many, many, many pages?

Maybe y’all have some more ideas. I would love to read about them in the comments!