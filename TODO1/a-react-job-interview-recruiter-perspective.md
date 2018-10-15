> * 原文地址：[A React job interview — recruiter perspective.](https://medium.com/@baphemot/a-react-job-interview-recruiter-perspective-f1096f54dd16)
> * 原文作者：[Bartosz Szczeciński](https://medium.com/@baphemot?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-react-job-interview-recruiter-perspective.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-react-job-interview-recruiter-perspective.md)
> * 译者：
> * 校对者：

# A React job interview — recruiter perspective.

![](https://cdn-images-1.medium.com/max/1000/1*MQNFrJwbmP7AmaSU-rxuBg.jpeg)

Photo by [rawpixel](https://unsplash.com/@rawpixel) via unsplash

> **Important**  
> This article is not a list of questions to expect on an interview and complete answers to them. The point of this post is to show what questions I ask, what I’m looking for in an answer and why there are no bad answers.  
> If you want a list of “best react interview questions 2018” check out [https://github.com/sudheerj/reactjs-interview-questions](https://github.com/sudheerj/reactjs-interview-questions)

Part of my job is performing the so called “technical interviews” during which I evaluate potential candidates that are applying for a “Frontend Developer with React” position.

If you’ve ever Googled “react interview questions” (or any other “[tech] interview questions”) you’ve probably seen countless results of “top 10 react interview questions” which are either outdated or rehash the same “what’s the difference between state and props” or “what’s virtual dom” questions.

Knowing answers to those questions _should not_ be the basis on which the interviewer decides to hire or not. That’s something a candidate **needs to know,** understand and implement in his daily work. If you’re a candidate being asked those questions either the person interviewing you has no tech background (a HR person or “linkedin headhunter”) or they see this as a formality.

The interview should not be a waste of time. It should give you an idea about the candidate past experience, past knowledge and development opportunities. The candidate should learn about your organisation and project (if possible) and get feedback on his performance vs. your expectations. There should be no bad answers in a job interview (unless the questions is strictly technical) — an answer should give you an insight into the person thought process.

**The article is written from the perspective of the person conducting the interview!**

### Let’s get to know each other

In many cases the interview will be conducted via Skype or other voice (or voice+video) communication platform. Getting to know the potential hire is a good way to get them to open up.

#### Can you tell me a bit about your previous job, how did you fit in the team? What were your responsibilities?

Knowing what the person did at his previous work place (if he’s allowed to share) is a good way to start. This gives you some basic idea about the previous work experience: soft skills (“I was a sole developer on …”, “I, and my colleagues…”, “I managed a team of 6 developers …”) and hard skills (“… we created an application used by 1 mil people”, “… I helped optimize rendering time of the application”, “… created dozens automated tests”).

#### What’s the main selling point of React _to you._ Why did _you_ chose to go with React?

I don’t expect you to mention JSX, VDOM etc. — we already get that from reading the “features” blurb on the homepage. Why did *you* start using React?

Was it because of the “easy to learn, hard to master” API (which _is_ quite small when you compare it to other solutions)? Good — say that, it means you’re willing to learn new things, and learn them as you go.

Was it because of the “job opportunities”? Good — you’re a person that can adapt to the market and will have no issues moving on in 5 years when The Next Big Framework comes. We have enough of jQuery developers already.

Think of this a bit like an “elevator pitch” scenario (you are in an elevator with your boss and need to convince him to use new technology before he gets out on his 20th floor). I wan’t to know you know what React has to offer that can benefit the client and you, the developer.

### Let’s start to get a bit more technical

As I mentioned in one of the opening paragraphs — I’m not going to ask you what VDOM is. We know it, I will however ask you …

#### What is JSX and how come we can write it in our JavaScript code — how do the browser recognize it?

You know this — JSX is just a notation, that Facebook popularized, which — thanks to tools like Babel / TSC — allows us to write `React.createElement` calls in a form that’s a bit more pleasant to the eye.

Why do I ask this question? I want to know if you understand the technical side of JSX and all the limitations that come from it: why do we need to `import React from 'react'` on the top of the file even if we don’t use `React` in our code; why can’t the component directly return multiple elements.

**Bonus question: why do the Component names in JSX start with capital letter?  
**Answering that this is how React knows to render a Component, and not a HTML Element should be good enough.

Bonus points: there are exceptions to that rule. E.g. assigning a component to `this.component` and then doing `<this.component />` will work.

#### What are the main 2 types of components you can declare in React, and when would you use one over another.

Some people will think this is about presentation and container components, but this is more about `React.Component` and function components.

A proper answer should mention life cycle methods and component state.

#### Since we mentioned life cycle — can you walk me through the cycle of mounting a stateful component? What functions are called in what order? Where would you place a request for data from the API? Why?

Ok, that’s a long one. Feel free to break it into two smaller ones. You’re now thinking “but you said you don’t ask about life cycle!”. I don’t, I don’t care about the life cycle. I care about the changes that happened in the life cycle in the very recent months.

If the answer contains `componentWillMount` you can assume that the person has been either working with an older version of React exclusively, or has done some outdated tutorials. Both cases should rise some concerns. `getDerivedStateFromProps` is what you’re looking for.

Bonus points: differences in the way the process goes on server-side is mentioned.

Same goes for the question about data fetching — `componentDidMount` is the one you want to say/hear.

**Bonus question: why** `**componentDidMount**` **and not** `**constructor**`**?  
**Two reasons you want to hear are: “the data will not be there before render happens” — although not the main reason, it shows you that the person understands the way components are handled; “with the new asynchronous rendering in React Fiber …” — someone has been doing his homework.

#### We mentioned fetching data from an API — how would you go about making sure the data is not re-fetched when the component is re-mounted?

We assume “cache invalidation” is not a thing. This one is not strictly React related, but if the answer is limited to React it’s also good — maybe he worked with GraphQL which does the heavy lifting for you?

I ask this to see if the candidate understands the idea of not-coupling the UI and other layers in an application. An API that’s external to the React structure can be mentioned.

#### Can you explain the idea of “lifting the state up”?

Ok, I do ask some typical React questions. This one is crucial though, it will allow you to give the candidate some breathing room.

Answers ranging from “it allows to pass data between siblings” to “it allows you to have more pure-presentational components, which make re-usability easier” are preferred. Redux might get mentioned here, though that could as well be a bad thing, because it signifies that the candidate just goes with whatever the community recommends without understanding why he needs it.

**Bonus question: how would you go about passing data across multiple levels of depth, without passing it from component to component?**  
Context has become mainstream ever since React 16.3 — it was there before, but the documentation was lacking (on purpose). Being able to explain how context works (and at the same time showing knowledge of the function-as-child pattern) is a plus.

If Redux / MobX gets a mention here, it’s also good.

### React ecosystem

Developing React apps is part of the process — there’s a lot more to it: debugging, testing, documenting.

#### How would you go about debugging an issue in React code; what tools have you used? How would you go about investigating why a component does not re-render?

Everyone should be familiar with the basic tools like a linter (eslint, jslint) and debuggers (React Developer Tools).

Using RDT to debug the issue by checking if the component state/props are properly set is a good answer, mentioning using the Developer Tools to setup breakpoints is also a good one.

#### What testing tools have you used to write unit / E2E tests? What’s snapshot testing and what are the benefits of it?

In most cases tests are a “necessary evil” but those are things we need. There are many good answers here: karma, mocha, jasmin, jest, cypres, selenium, enzyme, react-test-library etc. The worst thing is the candidate answers “we didn’t do unit tests at my previous company, only manual tests”.

The snapshot testing part also depends on what you use in your project; if you don’t find it beneficial, don’t ask about it. But if you do, fast and easy regression tests for the UI layer (generated HTML + CSS).

### Small code challenges

When possible, I also do small code challenges which should take no more than a minute or two to fix/explain, e.g.:

```
/** * What is wrong with this example, and how would you go
* about fixing or improving the component?
*/

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      name: this.props.name || 'Anonymous'
    }
  }

  render() {
    return (
      <p>Hello {this.state.name}</p>
    );
  }
}
```

There are multiple ways to solve it: remove the state and use props, implement `getDerivedStateFromProps` or (preferably) change to a function components.

```
/**
 * Can you explain the differences between all those ways
 * of passing function to a component?
 *
 * What happens when you click each of the buttons?
 */

class App extends React.Component {
  
  constructor() {
    super(); 
    this.name = 'MyComponent';
    
    this.handleClick2 = this.handleClick1.bind(this);
  }
  
  handleClick1() {
    alert(this.name);
  }
  
  handleClick3 = () => alert(this.name);

render() {
    return (
      <div>
        <button onClick={this.handleClick1()}>click 1</button>
        <button onClick={this.handleClick1}>click 2</button>
        <button onClick={this.handleClick2}>click 3</button>
        <button onClick={this.handleClick3}>click 4</button>
      </div>
    );
  }
}
```

This one takes a bit more, because there’s just more code. If the candidate answers correctly follow up with “why?”. Why will `click 2` work the way it works?

Not a React question, if someone starts with “because in React …” it means that they don’t really understand the JS event loop.

```
/**
 * What's the issue with this component. Why?
 * How would you go about fixing it?
 */

class App extends React.Component {

state = { search: '' }

handleChange = event => {

/**
     * This is a simple implementation of a "debounce" function,
     * which will queue an expression to be called in 250ms and
     * cancel any pending queued expressions. This way we can 
     * delay the call 250ms after the user has stoped typing.
     */
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      this.setState({
        search: event.target.value
      })
    }, 250);
  }

render() {
    return (
      <div>
        <input type="text" onChange={this.handleChange} />
        {this.state.search ? <p>Search for: {this.state.search}</p> : null}
      </div>
    )
  }
}
```

OK, this one will need some explaining. There’s no error in the debounce function. The way the application is expected to work, is it will update the state 250 ms after the user has stooped typing, and then render the string “Search for: …”.

The issue here is that the `event` is a `SyntheticEvent` in React, and if the interaction with it is delayed (e.g. via `setTimeout`) it will be cleared and the `.target.value` reference will no longer be valid.

**Bonus points: the candidate is able to explain why that is.**

### We’re done with the tech questions.

This should be enough to give you some idea about the technical skills of the candidate. You should still have some time left for more open-ended questions.

#### What was the biggest problem you’ve faced on your past projects; what was your biggest achievement?

This goes back to the very first question — the answer can vary from developer to developer and position to position. A junior developer will say his biggest problem was getting thrown in a complex process, but he was able to conquer it. Someone looking for a more senior position will explain how he optimized the app performance, and someone that can lead teams explain how he improved velocity by doing pair programming.

#### If you had unlimited time budget and could fix / improve / change one thing in your last project, what would it be and why?

And another open ended question, answer to which depends on what you’re looking for in the candidate. Will he try to replace Redux with MobX? Improve the testing setup? Write better documentation?

### Reversing the tables and feedback

Now’s the time to change the roles. You probably have a solid idea about the candidate skills and potential to grow. Let him ask the questions — not only will it allow him to get to know the company and product more, the questions he ask might give you some indication about the direction he want’s to grow in.

[Carl Vitullo](https://medium.com/@vcarl) wrote some good articles on the topic of what questions to ask your potential employer, I’ll refer you to those — be ready to answer them, or say that you can’t on given step due to NDA requirements etc.:

*   [onboarding and the workplace](https://medium.com/@vcarl/questions-to-ask-your-interviewer-82a26e67ce6c)
*   [development and emergencies](https://medium.com/@vcarl/questions-to-ask-your-interviewer-development-and-emergencies-f7fbc4519e5b)
*   [growth](https://medium.com/@vcarl/questions-to-ask-your-interviewer-growth-c88eed119ce2)

#### Give feedback

If the candidate under-performed on some questions or got them wrong (or different than you would expect) — you might want to clarify those at this point. Don’t make it sound like you’re patronizing the person, just explain the problems you’ve noticed — offer solution and some resources he can use to improve himself.

If the rest of the recruitment process is up to you, tell them you will get back o them in X days, if not, tell them that someone from your company will do that. If you know the process will take longer than 2–3 days, tell them that. IT is a big market at this point, and the candidate might have done multiple interviews — he might not wait for you to get back before accepting another offer.

**Do not ignore the candidate — that’s literally the main complaint people share on social media.**

> The opinions expressed in this blog post are those of my own and do not reflect the opinions of any of my past or current employer, client or collaborator.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
