>* 原文链接 : [Build A Journaling App with Meteor 1.3 (Beta), React, React-Bootstrap, and Mantra](https://medium.com/@kenrogers/build-a-journaling-app-with-meteor-1-3-beta-react-react-bootstrap-and-mantra-7965d9e9fc23#.bjcr4yhbf)
* 原文作者 : [Ken Rogers](https://medium.com/@kenrogers)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:



In this Meteor tutorial we’ll be taking a look at the Meteor 1.3 beta release. Meteor 1.3 is in the works, and we have access to the beta version so we can start hacking on it right away. Although Meteor 1.3 is awesome and comes with some great changes, there is a bit of fuzziness on exactly how to develop with it. MDG is working on the Meteor Guide for Meteor 1.3, and hopefully when that comes out, along with the official release of 1.3, we will have some solid information on the best way to develop with Meteor 1.3.

**_Side note: I wrote a book on developing applications using Meteor 1.3, React, and React-Bootstrap, following the Mantra spec. Learn more and get the first three chapters free_ **[**_here_**](http://kenrogers.co/meteor-react)**_._**

I created this guide to get developers up and running with Meteor 1.3 in its current state. As you work through this guide, keep in mind that 1.3 is still in beta, so things will change. I will try my best to keep this updated as new versions are released, and if you find something out of date, please reach out and let me know.

In this guide, we’ll be building a simple todo list, nah just kidding, no more todo lists. We’ll build a basic journaling app using Meteor 1.3, React, and React-Bootstrap.

We’ll also take advantage of Arunoda’s Mantra specification. If you aren’t familiar with Mantra, you can learn more about it and its purpose [here](https://github.com/kadirahq/mantra). Basically, Mantra is an application architecture specification that gives us a maintainable way to build Meteor apps.

Before we get started, you should already have Meteor installed and should have a pretty decent understanding of how it works. If you don’t, check out the [official Meteor tutorial](https://www.meteor.com/tutorials/react/creating-an-app).

First we’ll walk through some resources for getting familiar with Meteor 1.3 and Mantra, then we’ll use these to create a simple little journaling app.

#### Getting to Know Meteor 1.3

First let’s get introduced to Meteor 1.3 and what the main changes are. The biggest change is that 1.3 has full support for ES2015 and its module functionality.

At first it’s a pretty big departure from the way we used to develop Meteor apps, but once you get used to it, it’s actually really nice, especially when you have a system to follow like the one provided by Mantra.

For a great introduction to how modules work in Meteor 1.3, read this writeup: [https://github.com/meteor/meteor/blob/release-1.3/packages/modules/README.md](https://github.com/meteor/meteor/blob/release-1.3/packages/modules/README.md)

Modules make it much easier to make our code more, well, modular. We can more easily organize our application, and since it also comes with npm package support, we don’t have to rely on only Meteor packages anymore.

Next up, check out these three posts to get yourself familiar with how to set up Meteor 1.3 with React and use it to handle data. The second one will introduce you to the concept of container components, which are a major aspect of developing using Mantra.

1.  [https://voice.kadira.io/getting-started-with-meteor-1-3-and-react-15e071e41cd1#.qn4zj3420](https://voice.kadira.io/getting-started-with-meteor-1-3-and-react-15e071e41cd1#.qn4zj3420)
2.  [https://voice.kadira.io/let-s-compose-some-react-containers-3b91b6d9b7c8#.pd37xdmpn](https://voice.kadira.io/let-s-compose-some-react-containers-3b91b6d9b7c8#.pd37xdmpn)
3.  [https://voice.kadira.io/using-meteor-data-and-react-with-meteor-1-3-13cb0935dedb#.3oe66g4ye](https://voice.kadira.io/using-meteor-data-and-react-with-meteor-1-3-13cb0935dedb#.3oe66g4ye)

#### Step 1 — Project Setup

Normally, the first thing we would do is create our Meteor project with Meteor 1.3 like this.

    meteor create journal --release 1.3-modules-beta.8

**But hold off on that.** There is a lot of project setup when building an application with Mantra, so to speed up the process, I created a boilerplate project built around Meteor 1.3, React, and Mantra. So let’s get started with that instead.

If you want an idea of what all this does, check out the [Mantra spec](https://kadirahq.github.io/mantra/) and the [Mantra sample blog app](https://github.com/mantrajs/mantra-sample-blog-app).

Now let’s get this boilerplate project installed. It’s complete with all of the core files and directories you need to start up a Meteor project that follows the Mantra spec.

Set it up by cloning it with the following command:

    git clone git@github.com:kenrogers/mantraplate.git

Now switch into the directory it just created and run

    npm install

That will install all of the packages you need for the app to run. Look through the sample project and familiarize yourself with the directory structure.

It’s complete with a layout, routing system, and user system with register and login/logout functionality.

In this tutorial, we’re going to be talking about how everything works together and adding the ability for users to add journal entries to the app.

Before we actually add anything, take a look at the directory structure of the boilerplate. You can see that within the client folder we break our app up into modules. These modules are the main parts of your app.

We always have a core module, and if your app is small, this can be all you need. In our app we currently have the core module and the users module, we’ll also add an entries module for adding our journal entries.

This modular architecture makes it very easy to keep our code organized.

Within the users module, take a look at the NewUser files in the containers folder and the components folder. The container looks like this.

    import NewUser from ‘../components/NewUser.jsx’;
    import {useDeps, composeWithTracker, composeAll} from ‘mantra-core’;
    export const composer = ({context, clearErrors}, onData) => {
     const {LocalState} = context();
     const error = LocalState.get(‘CREATE_USER_ERROR’);
     onData(null, {error});
     return clearErrors;
    };
    export const depsMapper = (context, actions) => ({
     create: actions.users.create,
     clearErrors: actions.users.clearErrors,
     context: () => context
    });
    export default composeAll(
     composeWithTracker(composer),
     useDeps(depsMapper)
    )(NewUser);

You can see that we aren’t actually rendering anything in here, we are only doing some set up and clean up, then in the NewUser component, we actually render a view.

If you run the app and visit the /register route, then open up React dev tools, you can see what react-komposer is actually doing behind the scenes. It is creating a container component that is in charge of handling the data for the underlying child component, or UI component.

The usefulness of container components will become more clear when we actually have to fetch data, which we aren’t doing here.

#### Step 2 — Prototyping

For this journaling app we’re going to be using React-Bootstrap. It’s a fantastic project that makes creating React apps with Bootstrap much easier. It’s easy to work with and modular, just the way we like it.

Let’s get it set up and add a simple form.

First up add react-bootstrap to the project with

    npm install react-bootstrap

React-Bootstrap doesn’t depend on any specific Bootstrap library, so we’ll need to add that on our own. Let’s just add the official Meteor package from Twitter.

    meteor add twbs:bootstrap

First we’ll modify the MainLayout.jsx file to use React-Bootstrap by changing its contents to the following:

    import React from ‘react’;
    import {Grid, Row} from ‘react-bootstrap’;
    const Layout = ({content = () => null }) => (
     <grid>
      <row>
       <h1>Journal</h1>
       {content()}
      </row>
     </grid>
    );
    export default Layout;

Here we’re importing the Grid and Row components from the react-bootstrap package and using the components just like we would by using a div with the proper bootstrap classes. To learn more about how this awesome package works, check out the list of components [here](https://react-bootstrap.github.io/components.html).

Now let’s modify the NewUser and Login UI components to make them more Bootstrap friendly. Open up NewUser.jsx and change it to the following:

    import React from ‘react’;
    import { Col, Panel, Input, ButtonInput, Glyphicon } from ‘react-bootstrap’;
    class NewUser extends React.Component {
     render() {
     const {error} = this.props;
     return (
       <col xs="{12}" sm="{6}" smoffset="{3}">
        <panel>
         <h1>Register</h1>
         {error ? <p style="{{color:" ‘red’}}="">{error}</p> : null}
         <form>
          <input ref="”email”" type="”email”" placeholder="”Email”">
          <input ref="”password”" type="”password”" placeholder="”Password”">
          <buttoninput onclick="{this.createUser.bind(this)}" bsstyle="”primary”" type="”submit”" value="”Sign" up”="">
         </buttoninput></form>
        </panel>

      )
     }
    createUser(e) {
     e.preventDefault();
     const {create} = this.props;
     const {email, password} = this.refs;
     create(email.getValue(), password.getValue());
     email.getInputDOMNode().value = ‘’;
     password.getInputDOMNode().value = ‘’;
     }
    }
    export default NewUser;

This form is pretty simple, and is just in charge of displaying the form itself and calling the create action. Let’s talk about that a bit.

In our actions files we handle the logic of our app. And this line:

    create(email.getValue(), password.getValue());

calls that action and creates the actual user. Mantra places heavy emphasis on separating everything into separate files. So we have separate files for display and logic, as well as each component of the app.

Now let’s change the login form as well:

    import React from ‘react’;
    import { Col, Panel, Input, ButtonInput, Glyphicon } from ‘react-bootstrap’;
    class Login extends React.Component {
     render() {
      const {error} = this.props;
      return (
       <col xs="{12}" sm="{6}" smoffset="{3}">
        <panel>
         <h1>Login</h1>
         {error ? <p style="{{color:" ‘red’}}="">{error}</p> : null}
         <form>
          <input ref="”email”" type="”email”" placeholder="”Email”">
          <input ref="”password”" type="”password”" placeholder="”Password”">
          <buttoninput onclick="{this.login.bind(this)}" bsstyle="”primary”" type="”submit”" value="”Login”/">
         </buttoninput></form>
        </panel>

      )
     }
    login(e) {
     e.preventDefault();
     const {loginUser} = this.props;
     const {email, password} = this.refs;
     loginUser(email.getValue(), password.getValue());
     email.getInputDOMNode().value = ‘’;
     password.getInputDOMNode().value = ‘’;
     }
    }
    export default Login;

This is basically the same form, but we are using the login function instead.

React-Bootstrap is pretty simple to work with, we simply have to install the project, import any components we want to use via the import function, and then render those components just like any other.

The way we work with data is a bit different though, since it is a component, and not an actual input we are working with, we have to use a special React-Bootstrap function called getValue() that simply fetches the value for us.

#### Step 2 — Adding the Entries Module

Now we’ll add the new module in charge of our entries. First let’s set up the directories and files.

    mkdir client/modules/entries
    cd client/modules/entries
    mkdir actions components containers
    touch index.js
    touch actions/index.js actions/entries.js
    touch components/NewEntry.jsx components/Entry.jsx components/EntryList.jsx
    touch containers/NewEntry.js containers/Entry.js containers/EntryList.js

Alright, now we have all the files and folders we need to build the rest of our little application, let’s get into some real development work.

First let’s take a look at the structure we just created. Here we have made a simple Mantra module. Let’s go through the directories and files, and see how they all interact with each other. Walking through this will give you a good understanding of how to work with Meteor 1.3 and Mantra.

**Index**

Mantra is big on single entry points. This index file is in charge of importing and then exporting the routes and actions so that they are available when we import this module. By doing this we don’t have to worry about importing each file individually.

    import actions from ‘./actions’;
    import routes from ‘../core/routes.jsx’;
    export default {
     routes,
     actions
    };

**Actions**

The actions folder is in charge of all of the logic of our application. You can see we’ve created two files in here. The first is an index file. This serves a similar purpose to the module’s index file. Put the following contents into it.

    import entries from ‘./entries’;
    export default {
     entries
    };

All it does is import the entries file where we’ll put our actions. Once again, this is just to make it easier to import our actions from other files.

Next we’ll add the actual actions. These contain the logic of our app. This is where we’ll put the functions to create a new entry.

You can get an example for how these work by looking in the actions file for the users module.

Add the following the actions.js file for the entries module.

    export default {
     create({Meteor, LocalState, FlowRouter}, text) {
      if (!text) {
       return LocalState.set(‘CREATE_ENTRY_ERROR’, ‘Text is required.’);
      }
      LocalState.set(‘CREATE_ENTRY_ERROR’, null);
      Meteor.call(‘entries.create’, text, (err) => {
       if (err) {
        return LocalState.set(‘CREATE_ENTRY_ERROR’, err.message);
       }
      });
     }
    };

When we fill out the form to create a new entry, this is the action that will be executed. We’ll set up the components in a second, first let’s get the server stuff out of the way and create the collection and method for our entries.

Open up the collections.js file in the lib directory and add an entries collection.

    export const Entries = new Mongo.Collection(‘entries’);

Now add an entries.js file to the methods directory within the server directory and add the following to create the method to create a new entry.

    import {Entries} from ‘/lib/collections’;
    import {Meteor} from ‘meteor/meteor’;
    import {check} from ‘meteor/check’;
    export default function () {
     Meteor.methods({
      ‘entries.create’(text) {
       check(text, String);
       const createdAt = new Date();
       const entry = {text, createdAt};
       Entries.insert(entry);
      }
     });
    }

This is the method that the action we just created will call.

We’ll also add the following to the index.js file of the methods folder.

    import entries from ‘./entries’;
    export default function () {
     entries();
    }

**Components**

The components directory is where our UI components will go. These are the components that are only responsible for displaying our interface, they don’t handle any data. That’s what the container components are for.

Let’s create our UI components, then we’ll set up the corresponding container components.

    import React from ‘react’;
    import {Grid, Row, Col} from 'react-bootstrap';
    const Entry = ({entry}) => (
     <grid>
      <row>
       <col xs="{6}" xsoffset="{3}">
        <p>
         {entry.text}
        </p> 

      </row>
     </grid>
    );
    export default Entry;

The {entry} object that is being fetched is the property that our container component will pass to this one. It contains our data.

Next up we’ll create the NewEntry component.

    import React from ‘react’;
    import { Col, Panel, Input, ButtonInput, Glyphicon } from ‘react-bootstrap’;
    class NewEntry extends React.Component {
     render() {
      const {error} = this.props;
      return (
       <col xs="{12}" sm="{6}" smoffset="{3}">
        <panel>
         <h1>Add a New Entry</h1>
         {error ? <p style="{{color:" ‘red’}}="">{error}</p> : null}
         <form>
          <input ref="”text”" type="”textarea”" placeholder="”Add" your="" entry”="">
          <buttoninput onclick="{this.newEntry.bind(this)}" bsstyle="”primary”" type="”submit”" value="”Create”/">
         </buttoninput></form>
        </panel>

      )
     }
     newEntry(e) {
      e.preventDefault();
      const {create} = this.props;
      const {text} = this.refs;
      create(text.getValue());
      text.getInputDOMNode().value = ‘’;
     }
    }
    export default NewEntry;

Here we’re using some more React-Bootstrap components. You’ll notice that in order to get the value of the inputs, we use a special getValue() function. That’s because the components we are rendering aren’t actual input fields, the input fields are inside them, so we use this function to access it.

Finally, we’ll create the EntryList component.

    import React from ‘react’;
    import {Grid, Row, Col, Panel} from ‘react-bootstrap’;
    const EntryList = ({entries}) => (
     <grid>
      <row>
       {entries.map(entry => (
        <col xs="{3}" key="{entry._id}">
         <panel>
          <p>{entry.title}</p>
          <a href="{`/entry/${entry._id}`}">View Entry</a>
         </panel>

       ))}
      </row>
     </grid>
    );
    export default EntryList;

Once again, we’re pulling the data in via props, setting up some React-Bootstrap components, and mapping each entry to it’s own panel.

Now let’s get the container components for these set up. First, the simplest one, the NewEntry container component.

    import NewEntry from ‘../components/NewEntry.jsx’;
    import {useDeps, composeWithTracker, composeAll} from ‘mantra-core’;
    export const composer = ({context, clearErrors}, onData) => {
     const {LocalState} = context();
     const error = LocalState.get(‘CREATE_ENTRY_ERROR’);
     onData(null, {error});
     return clearErrors;
    };
    export const depsMapper = (context, actions) => ({
     create: actions.entries.create,
     clearErrors: actions.entries.clearErrors,
     context: () => context
    });
    export default composeAll(
     composeWithTracker(composer),
     useDeps(depsMapper)
    )(NewEntry);

You should be familiar with react-komposer. That’s what we are using to create this container components. It’s in charge of creating the container component, which handles errors, calls the proper actions, and in most cases, fetches data and passes it to the UI component as a prop.

The depsMapper is what retrieves the actions and the context and passes them to the UI component with the useDeps function from react-komposer.

The clearErrors function is in charge of clearing out any errors when the component unmounts.

Let’s create the action now right under the create action for our entries.

    clearErrors({LocalState}) {
     return LocalState.set(‘SAVING_ERROR’, null);
    }

Now we’ll create the container component for the EntryList component. This one will be slightly more complex, since we actually have to retrieve some data.

    import EntryList from ‘../components/EntryList.jsx’;
    import {useDeps, composeWithTracker, composeAll} from ‘mantra-core’;
    export const composer = ({context}, onData) => {
     const {Meteor, Collections} = context();
     if (Meteor.subscribe(‘entries.list’).ready()) {
      const entries = Collections.Entries.find().fetch();
      onData(null, {entries});
     }
    };
    export default composeAll(
     composeWithTracker(composer),
     useDeps()
    )(EntryList);

This really similar to the other container component, with one important difference. We are subscribing to our entry collection, and then assigning them to a variable. Finally, we pass that variable to the UI component with the onData function.

Let’s set up that publication now within an entries.js file in the publications directory.

    import {Entries} from ‘/lib/collections’;
    import {Meteor} from ‘meteor/meteor’;
    import {check} from ‘meteor/check’;
    export default function () {
     Meteor.publish(‘entries.list’, function () {
      const selector = {};
      const options = {
       fields: {_id: 1, text: 1},
       sort: {createdAt: -1}
      };
      return Entries.find(selector, options);
     });
    }

And we’ll create the index file for the publications.

    import entries from ‘./entries’;
    export default function () {
     entries();
    }

Real quickly, we need to open up the main.js file in our server directory and uncomment the lines to pull in the publications and methods so the file looks like this.

    import publications from ‘./publications’;
    import methods from ‘./methods’;

    // publications();
    // methods();

And finally we’ll create the container component for the single Entry component.

    import Entry from ‘../components/Entry.jsx’;
    import {useDeps, composeWithTracker, composeAll} from ‘mantra-core’;
    export const composer = ({context, entryId}, onData) => {
     const {Meteor, Collections} = context();
     if (Meteor.subscribe(‘entries.single’, entryId).ready()) {
      const entry = Collections.Entries.findOne(entryId);
      onData(null, {entry});
     } else {
      const entry = Collections.Entries.findOne(entryId);
      if (entry) {
       onData(null, {entry});
      } else {
       onData();
      }
     }
    };
    export default composeAll(
     composeWithTracker(composer),
     useDeps()
    )(Entry);

This container is using an entryId (passed through by a route we’ll set up in a moment) and then finding the proper entry and passing it to the UI component via props.

Let’s set up the publication for this real quick right below the entries.list publication we set up earlier.

    Meteor.publish(‘entries.single’, function (entryId) {
     check(entryId, String);
     const selector = {_id: entryId};
     return Entries.find(selector);
    });

Let’s set up our routes now.

**Routes**

Open up the routes file and add a few new routes. Modify the routes file to look like the following.

    import React from ‘react’;
    import {mount} from ‘react-mounter’;
    import Layout from ‘./components/MainLayout.jsx’;
    import Home from ‘./components/Home.jsx’;
    import NewUser from ‘../users/containers/NewUser.js’;
    import Login from ‘../users/containers/Login.js’;
    import EntryList from ‘../entries/containers/EntryList.js’;
    import Entry from ‘../entries/containers/Entry.js’;
    import NewEntry from ‘../entries/containers/NewEntry.js’;
    export default function (injectDeps, {FlowRouter}) {
     const MainLayoutCtx = injectDeps(Layout);
     FlowRouter.route(‘/’, {
      name: ‘items.list’,
      action() {
       mount(MainLayoutCtx, {
        content: () => (<entrylist>)
       });
      }
     });
     FlowRouter.route(‘/entry/:entryId’, {
      name: ‘entries.single’,
      action({entryId}) {
       mount(MainLayoutCtx, {
        content: () => (<entry entryid="{entryId}/">)
       });
      }
     });
    FlowRouter.route(‘/new-entry’, {
      name: ‘newEntry’,
      action() {
       mount(MainLayoutCtx, {
        content: () => (<newentry>)
       });
      }
     });

     FlowRouter.route(‘/register’, {
      name: ‘users.new’,
      action() {
       mount(MainLayoutCtx, {
        content: () => (<newuser>)
       });
      }
     });
    FlowRouter.route(‘/login’, {
      name: ‘users.login’,
      action() {
       mount(MainLayoutCtx, {
        content: () => (<login>)
       });
      }
     });
    FlowRouter.route(‘/logout’, {
      name: ‘users.logout’,
      action() {
       Meteor.logout();
       FlowRouter.go(‘/’);
      }
     }); 
    }</login></newuser></newentry></entry></entrylist>

We have to do one last thing before we run our app. Open up the main.js file and import our entries module by changing the contents of the file to the following.

    import {createApp} from ‘mantra-core’;
    import initContext from ‘./configs/context’;
    // modules
    import coreModule from ‘./modules/core’;
    import usersModule from ‘./modules/users’;
    import entriesModule from ‘./modules/entries’;
    // init context
    const context = initContext();
    // create app
    const app = createApp(context);
    app.loadModule(coreModule);
    app.loadModule(usersModule);
    app.loadModule(entriesModule);
    app.init();

Now we have all our routes set up and our app is ready to go. Go ahead and run the project by switching into the root and running

    meteor

And you should see the app up and running with a default loading screen provided by Mantra. Let’s add an entry so we can see something up on the screen.

Visit localhost:3000/new-entry and fill out and submit the form to add an entry.

Then visit the root and you should see a list of your entries with links to view them individually.

Hopefully this whirlwind tour of Mantra and the current beta of Meteor 1.3 helped solidify how to develop apps with them.

![](http://ww3.sinaimg.cn/large/a490147fjw1f391r94o1nj20go0lgq5b.jpg)
