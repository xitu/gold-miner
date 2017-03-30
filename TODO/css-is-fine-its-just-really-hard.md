> * 原文地址：[CSS is Fine, It’s Just Really Hard](https://medium.com/@jdan/css-is-fine-its-just-really-hard-638da7a3dce0)
> * 原文作者：[Jordan Scales](https://medium.com/@jdan)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者： 
> * 校对者：

---

# CSS is Fine, It’s Just Really Hard

Everyone’s upset about CSS again. Now’s the time where I would sit firmly on my high horse and [write some satire](https://medium.com/friendship-dot-js) to make myself feel better, but instead here are some hot takes.

CSS is fine. It’s just really hard, so I compile to it.

—

My name is Jordan and I write a lot of JavaScript and CSS. I’m really, *really* good at those two things. If CSS were an olympic event I’d easily qualify but probably wouldn’t get a medal. But I don’t need a medal, because I have a trophy with a computer on it.

![](https://cdn-images-1.medium.com/max/1600/1*ioYNZ-FgsSpoos6b3iKblg.png)

I’ve been drawing rectangles on computer and telephone screens for a long, long time. I’ve written lots of bad CSS, many thousands of lines of poor Less code, and megabytes of terrible Sass. It’s in my blood.

But I’ve also written lots of good CSS! I’ve made triangles with borders, bezier curves with CSS transforms, 60fps scrolling animations, and tooltips that would knock your socks off.

It’s a great technology. Give me 30 seconds I can write some plain HTML and get some fancy Times New Roman text and hyperlinks with the worst shade of blue you’ve ever seen. Give me another 30 seconds and I’ll make that shade of blue a little nicer, and I’ll use a pretty font.

It’s intuitive! If I want all my links to look the same, I can do that! Images with pretty borders and margins? No problem. That’s what this shit was *made for.*

It’s performant! Many person-centuries have gone into making CSS fast, debuggable, and all-around pleasant to look at. CSS is here to stay, and it’s a wonderful thing that we’re able to use such sophisticated tooling for free. Not to mention the countless blog posts and cool demos we have access to with a quick Google search.

—

When I was younger, I realized that I wanted my borders and link text to be the same color — and changing it in two or three different places every time was super awful. Then I discovered Less. Now I could make a `@wonderfulBlue` and use it everywhere. *Well actually Jordan CSS has variables now…*

Then I started second-guessing all the long comments I left for why`#left-section` was exactly 546px wide. (250 * 2 + 23 * 2 duh). Then I started writing my math in Less: `2 * @sectionWidth + 2 * @sectionPadding`. *I guess you’re unfamiliar with calc(), Jordan, because that has phenomenal browser support…*

Back when `border-radius` had to be polyfilled, I started including all the prefixes everywhere, then moved things over to a `border-radius()` mixin that I could just drop-in when I needed it. *Well if you had only used component clas — *Dude can you stop? Let me finish my article here. *Sorr — *It’s fine don’t worry about it, just hold on.

I was writing Less when CSS wasn’t cutting it for me. CSS was still getting written, let me assure you, and it was working great on my users’ machines. I just wasn’t the one writing it — I was too busy 10x’ing.

—

I started [working on teams](https://www.khanacademy.org/), on these big pages with lots of classes and variables. My work then involved navigating the existing markup, reusing variables, refactoring out common patterns into their own utility classes and mixins, and all the other things that developers get paid to do.

Some of those pages got really big, so often times we would split up our CSS (well, Less) and JavaScript into individual files so the users didn’t have to download code for the exercise page to watch a video.

Sometimes, we’d remove too much code, and things wouldn’t look right. Because the homepage menu would expect `.left-arrow` to be around, but now the styles for that class were in `exercise.css`. Sometimes we wouldn’t notice because that `.left-arrow` would be neatly tucked away behind a couple mouse clicks in a nav bar. *Well you should have had screenshot testing or a stricter QA proce — * What did I **just** say?

Phew, this was hard work! But hey code has bugs in it sometimes, it’s cool. Fix ’em and move on.

Solutions to this problem existed in the form of [BEM](http://getbem.com/) and [SMACSS](https://smacss.com/). You know, those funky class names you see with all the dashes and underscores. Yeah, they’re sweet, and they’re a really nice way to organize your code.

But, meh, this was weird. Why was I spending time manually refactoring our CSS into these funky class names? It was automatic, it was grunt work, but it was riddled with human error.

—

Now’s the time where I throw in a personal story about my grandmother writing machine code onto punch cards by hand. But, my grandma didn’t do that. She worked for our senator on the welfare board and didn’t have time for the computer stuff, though she was certainly smart enough. I could lie but why do this dance?

Anyway imagine a world where my grandmother *did* write machine code by hand onto punch cards. Again, riddled with human error! Got a bug? Punch ’em all again. Dropped the cards on the floor? Pick ’em all up and re-sort them, or just start over. Weird right? Couldn’t we make robots do this for us?

So that’s exactly what my theoretical grandmother did, she built a machine to punch the cards for her. Okay, she didn’t, but someone else did! And we got cool stuff like assembly code, and FORTRAN, and C. Each step of the way folks took to their equivalent twitter dot com and chastised this new technology. **Just use punch cards! Just use FORTRAN! Just use C — ** okay I guess people still do this one.

—

Which leads me to the point of this article.

CSS is fine, it’s fast, and it’s been fine tuned for over 20 years now for all sorts of applications.

But I really don’t like writing it. A lot of people don’t, so we develop these cool patterns to write it in. I don’t like writing in those patterns either, I have better stuff to do. And JavaScript is cool. *Actually JavaScript has even more prob — **ahem*. [So I write my CSS with JavaScript](https://github.com/khan/aphrodite).

Turning this:

    const Example = () => (
      <h1 className={css(styles.heading, styles.callout)}>
        Hello, world!
      </h1>
    )

    const styles = StyleSheet.create({
      heading: {
        fontFamily: "Comic Sans MS",
      },
      callout: {
        color: "tomato",
      },
      unused: {
        width: 600,
      },
    })

Into this:

    <h1 class="heading_1flg42u-o_O-callout_1ih983s">Hello, world!</h1>

    ...

    .heading_1flg42u-o_O-callout_1ih983s {
        font-family: Comic Sans MS !important;
        color: tomato !important;
    }

See? Still CSS. Clean CSS. Perfect CSS. To-the-**book** CSS. But I didn’t write it. The robots did. The unused stuff is gone, and I can render `<Example>`*anywhere* and know what it will look like.

[Rendering Khan Academy’s Learn Menu Wherever I Please](https://medium.com/@jdan/rendering-khan-academys-learn-menu-wherever-i-please-4b58d4a9432d)

—

I’m on the same team as you. CSS is great, and it would be silly to replace it all together. Just as FORTRAN didn’t replace even lower-level assembly code, [aphrodite](https://github.com/khan/aphrodite) and [styled-components](https://github.com/styled-components/styled-components) aren’t replacing CSS. They’re writing CSS.

Just promise me you’ll stop telling me to “learn CSS.” I know CSS. Scroll up, I have a trophy with a computer on it. My CSS is great, but it’s even better now that I’m removing as much human error as possible from it. Shouldn’t we both celebrate that?

And hey, I’ll promise you that I’ll stop saying “CSS is bad.” It’s just so much fewer characters than this blog post. It fits in a hashtag! So let’s be friends again, yeah?

—

Go ahead and [follow me on twitter](https://twitter.com/jdan) so we can yell at each other there. If I had a book I’d probably link it here, but no one will give me a book deal. Hope you enjoyed this post ❤

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
