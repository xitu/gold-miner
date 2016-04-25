>* 原文链接 : [Developing small JavaScript components WITHOUT frameworks](https://jack.ofspades.com/developing-small-javascript-components-without-frameworks/)
* 原文作者 : [Jack Tarantino](https://github.com/jacopotarantino)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


A mistake that a lot of developers make when they first approach a problem (me included!) is to start thinking about the problem from the top down. They start thinking of the problem at hand in terms of frameworks and plugins and pre-processors and post-processors and object-oriented patterns and some great medium post they read once and if there's a generator for the kind of thing they're now scaffolding... But with all of these great tools and powerful plugins we tend to lose sight of what it is that we're actually building and why. For the most part we don't actually need _any_ of those tools though! Let's look at an example of a simple component that we can build _without_ any JavaScript frameworks or tools whatsoever. This post is intended for mid- to advanced-level programmers as a reminder that they can do anything without the use of frameworks and bloatware. However, the lessons and code examples should be readable and usable by more junior engineers.

Let's build a list of recent employees at our company (normally I'd say a list of recent tweets or something but they now require you to set up an app to access their API and that's just complicated). Our product manager wants us to put a list of recent employees on the homepage of the corporate website and we want to do it programmatically so we don't have to update it manually later. The list should have a photo of the new employee along with their name and city they are located in. Nothing too crazy, right? So, in the current scope, let's say that the corporate homepage is isolated from the rest of the codebase and that it's already got jQuery on it for a couple animation effects. So, this is our scope:

*   a semi-live-updating list
*   on one page only
*   you're the only developer on this project
*   you're allowed to take as much time and resources as you want
*   the page already has jQuery on it

So where do you start? Do you immediately reach for Angular because you know you can whip up a `$scope.employees` and `ng-repeat` in no time flat? Do you go for React because it'll make sticking the employee markup into the list **crazy fast**? What about switching the homepage over to a static site and using Webpack to wire things up? Then you can write your HTML in Jade and your CSS in Sass because honestly who can even look at raw markup anymore? Not gonna lie, that last one sounds _really_ appealing to me. But do we really need it? The correct answer is 'no'. None of these things actually solve the problem at hand. And they all make the software stack way more confusing. Think about the next time another engineer has to pick up this project, especially if they're more junior; You don't want another engineer to be confused by all the bells and whistles when they just want to make a simple change. So what should our simple component look like in terms of code?

    <ul class="employee-list js-employee-list"></ul>  

That's it. That's all I'm starting with. You'll notice that I added a second class to the div that starts with `js-`. If you're unfamiliar with this pattern, it's because I want to indicate to any future developers that this component also has JavaScript that interacts with it. This way we can separate classes that are _just_ for JS to interact with and those that have CSS tied to them. It makes refactoring so much easier. Now let's at least make the list a _little_ prettier (Note for the reader: I am like the world's worst designer). I would prefer to use a CSS structure like BEM or SMACSS but for the sake of this example let's keep the names terse and holding their own structure:

    * { box-sizing: border-box; }

    .employee-list {
      background: lavender;
      padding: 2rem 0.5rem;
      border: 1px solid royalblue;
      border-radius: 0.5rem;
      max-width: 320px;
    }

So now we've got a list and it has an appearance. It's not much but it's progress. Now let's add in an example employee:

    <ul class="employee-list js-employee-list">  
      <li class="employee">
        <!--   Placeholder services really are your best friend   -->
        <img src="http://placebeyonce.com/100-100" alt="Photo of Beyoncé" class="employee-photo">
        <div class="employee-name">Beyoncé Knowles</div>
        <div class="employee-location">Santa Monica, CA</div>
      </li>
    </ul>  

    .employee {
      list-style: none;
    }

    .employee + .employee {
      padding-top: 0.5rem;
    }

    .employee:after {
      content: ' ';
      height: 0;
      display: block;
      clear: both;
    }

    .employee-photo {
      float: left;
      padding: 0 0.5rem 0.5rem 0;
    }

Great! So now we have a single employee in the list with some simple styles for layout. So what's left? There should probably be more than one employee. And we need to fetch them dynamically. Let's start by getting that sweet sweet employee data:

    // wrap things in an IIFE to keep them neatly isolated from other code.
    (() => {
      // strict mode to prevent errors and enable some ES6 features
      'use strict'

      // let's use jQuery's ajax method to keep the code terse.
      // Pull data from randomuser.me as a stub for our 'employee API'
      // (recall that this is really just a fake tweet list).
      $.ajax({
        url: 'https://randomuser.me/api/',
        dataType: 'json',
        success: (data) => {
          // success! we got the data!
          alert(JSON.stringify(data))
        }
      })
    })()

Brilliant! We got the employee data and we managed to do it without a framework, without a complicated preprocessor and without spending 2 hours arguing with a scaffolding tool. For now instead of using a testing framework we're just `alert`ing the data to make sure it came through as expected. Now, we need to parse the data through some sort of template to stick into the `.employee-list` so yank that Bey out of there and let's get templating:

    $.ajax({
      url: 'https://randomuser.me/api/',
      // query string parameters to append
      data: {
        results: 3
      },
      dataType: 'json',
      success: (data) => {
          // success! we got the data!
        let employee = `<li class="employee">
            <img src="${data.results[0].picture.thumbnail}" alt="Photo of ${data.results[0].name.first}" class="employee-photo">
            <div class="employee-name">${data.results[0].name.first} ${data.results[0].name.last}</div>
            <div class="employee-location">${data.results[0].location.city}, ${data.results[0].location.state}</div>
          </li>`
          $('.js-employee-list').append(employee)
        }
      })

Fantastic! Now we have a script that fetches users, can stick a user into a template and put that user into a spot on the page. It's a bit sloppy though and it only handles one user. Time to refactor:

    // takes an employee and turns it into a block of markup
    function employee_markup (employee) {  
      return `<li class="employee">
        <img src="${employee.picture.thumbnail}" alt="Photo of ${employee.name.first}" class="employee-photo">
        <div class="employee-name">${employee.name.first} ${employee.name.last}</div>
        <div class="employee-location">${employee.location.city}, ${employee.location.state}</div>
      </li>`
    }

    $.ajax({
      url: 'https://randomuser.me/api/',
      dataType: 'json',
      // query string parameters to append
      data: {
        results: 3
      },
      success: (data) => {
        // success! we got the data!
        let employees_markup = ''
        data.results.forEach((employee) => {
          employees_markup += employee_markup(employee)
        })
        $('.js-employee-list').append(employees_markup)
      }
    })

And there you have it! A fully-functioning small JavaScript component with no frameworks and no build process. It's only 66 lines including comments and can totally be extended to add an animation, links, analytics, whatever with very little fuss. Check out the finished working component below:

<iframe height='266' scrolling='no' src='//codepen.io/jacopotarantino/embed/MyGVOv/?height=266&theme-id=0&default-tab=js,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='http://codepen.io/jacopotarantino/pen/MyGVOv/'>MyGVOv</a> by jacopotarantino (<a href='http://codepen.io/jacopotarantino'>@jacopotarantino</a>) on <a href='http://codepen.io'>CodePen</a>.
</iframe>

See the Pen [MyGVOv](http://codepen.io/jacopotarantino/pen/MyGVOv/) by jacopotarantino ([@jacopotarantino](http://codepen.io/jacopotarantino)) on [CodePen](http://codepen.io).

Now, clearly this is just a VERY simple component and might not handle all of your needs for your specific project. If you keep simplicity in mind you can still hold to this no-framework principle and add more to it. Or, if your needs are many but your complexity is low, consider a build tool like Webpack. Build tools (for the sake of this argument) are not exactly the same as frameworks and plugins in what they achieve. Build tools only exist on your box but they don't add bloat to the final code that's served to a user. This is important because while we're stripping out frameworks the goal is to create a better experience for end users and create more manageable code for ourselves. Webpack handles a lot of the heavy lifting so that you can focus on more interesting things. I use it in my [UI Component Generator](https://github.com/jacopotarantino/generator-ui-component) which also introduces very little in the way of frameworks and tools allowing you to write tons of functional code without all the bloat. When you're working in JavaScript without frameworks, things can get very "wild west" very quickly and the code can get confusing. So when you're working on these components make sure to think about a structure and stick to it. Consistency is the key to good code.

And remember, above all you must test and document your code.  
"If it's not documented, it doesn't exist." - [@mirisuzanne](https://twitter.com/mirisuzanne)

## Extra credit

I cheated a little bit in this post by using jQuery. This was mostly for the sake of brevity and I do not endorse using jQuery when you don't need it. For those that are curious, here's a few things that we can replace with super-readable and almost-fun vanilla JavaScript.

### AJAX request in plain JavaScript

Sadly this one hasn't gotten any prettier but you can still do it yourself with relatively little code.

    (() => {
      'use strict'

      // create a new XMLHttpRequest. This is how we do AJAX without frameworks.
      const xhr = new XMLHttpRequest()
      // tell it which HTTP method to use and where to request
      xhr.open('GET', 'https://randomuser.me/api/?results=3')
      // in a GET request what you send doesn't matter
      // in a POST request this is the request body
      xhr.send(null)

      // we need to wait for the 'readystatechange' event to fire on the xhr object
      xhr.onreadystatechange = function () {
        // if the xhr has not finished we're not ready yet so just return
        if (xhr.readyState !== 4 ) { return }
        // if it didn't get a 200 status back log the error
        if (xhr.status !== 200) { return console.log('Error: ' + xhr.status) }

        // everything went well! log the response
        console.log(xhr.responseText)
      }
    })()

### DOM insertion in plain JavaScript

This one is crazy easy now that browsers have basically adopted all of jQuery's selector capabilities:

    (() => {
      'use strict'

      const employee_list = document.querySelector('.js-employee-list')
      const employees_markup = `
        <li class="employee"></li>
        <li class="employee"></li>
        <li class="employee"></li>
      `
      employee_list.innerHTML = employees_markup
    })()

That's it!

### Developing without ES6 features

I really wouldn't recommend going back to ES5 but if your job requires it, here's what you can substitute.

#### String interpolation

Substitute out all the ``Photo of ${employee}.`` blocks with `'Photo of ' + employee + '.'`

#### `let` and `const`

You can safely replace all of the `let` and `const` keywords in these examples with `var` but be careful in your own code.

#### Arrow functions

Substitute out all the `(employee) => {` blocks with `function (employee) {`. Again, it should work fine in this code but be careful in your own. `let`, `const`, and arrow functions all have different scoping than `var` and `function` and switching between them can wreak havoc on your code if you're not very careful and structured.

