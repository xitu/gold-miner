> * 原文地址：[Practical Redux, Part 1: Redux-ORM Basics](http://blog.isquaredsoftware.com/2016/10/practical-redux-part-1-redux-orm-basics/)
* 原文作者：[Mark Erikson](https://twitter.com/acemarke)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Practical Redux, Part 1: Redux-ORM Basics




_Useful techniques for using Redux-ORM to help manage your normalized state, part 1:  
Redux-ORM use cases and basic usage_

#### Series Table of Contents

## Intro

Over the last year, I’ve become a very big fan of a library called **[Redux-ORM](https://github.com/tommikaikkonen/redux-orm)**, by Tommi Kaikkonen. It helps solve a number of use cases that are common to many Redux applications, particularly related to managing normalized relational data in your store. I’ve used it heavily in my own application, and have come up with some useful techniques and approaches for using it. Hopefully you’ll find them useful in your own application as well.

This first post will cover **reasons why you might want to use Redux-ORM, and the basics of using it**. In Part 2, we’ll look at **specific concepts you should know when using Redux-ORM, and some of the ways I use it in my own application**.

> **Note**: The code examples in this post are intended to demonstrate the general concepts and workflow, and probably won’t entirely run as-is. **See the [series introduction](http://blog.isquaredsoftware.com/2016/10/practical-redux-part-0-introduction/)** for info on the example scenarios and plans for demonstrating these ideas in a working example application later.

## Why Use Redux-ORM?

Client-side applications frequently need to deal with data that is nested or relational in nature. The standard advice for a Redux application is to [store this data in a “normalized” form](http://redux.js.org/docs/faq/OrganizingState.html#organizing-state-nested-data). For a Redux app, that means organizing part of your store to look like a set of database tables. Each type of item that you want to store gets an object that is used as a lookup table by mapping item IDs to item entries. Since objects don’t have a real sense of order, arrays of item IDs are stored to indicate ordering.

> **Note**: For further information on normalization in Redux, see the [Structuring Reducers](http://redux.js.org/docs/recipes/StructuringReducers.html) section of the Redux docs.

Because data is often received from the server in nested form, it needs to be transformed into a normalized form to be properly added to the store. The typical approach is to use the [Normalizr](https://github.com/paularmstrong/normalizr) library for this. You can define schema objects and how they relate, pass the root schema and some nested data to Normalizr, and it gives you back a normalized version of the data suitable for merging into your state.

However, Normalizr is really only intended for one-time processing of incoming data. It doesn’t provide tools for dealing with normalized data once it’s in your store. For example, it doesn’t include a way to denormalize data and look up related items based on IDs, nor does it help with applying updates to that data. There are a couple of other libraries that can help, such as [Denormalizr](https://github.com/gpbl/denormalizr), but there’s a definite need for something that can make these steps easier to deal with.

Fortunately, such a tool exists: **Redux-ORM**. Let’s look at how it’s used, and how it can make it easier to manage normalized data within the store.

## Basic Usage

Redux-ORM comes with excellent documentation. The main [Redux-ORM README](https://github.com/tommikaikkonen/redux-orm), [Redux-ORM Primer tutorial](https://github.com/tommikaikkonen/redux-orm-primer), and the [API documentation](http://tommikaikkonen.github.io/redux-orm/index.html) cover the basics very well, but here’s a quick recap.

### Defining Model Classes

First, you need to determine your different data types, and how they relate to each other (specifically in database terms). Then, declare ES6 classes that extend from Redux-ORM’s `Model` class. Like other file types in a Redux app, there’s no specific requirement for where these declarations should live, but you might want to put them into a `models.js` file, or a `/models` folder in your project

As part of those declarations, add a static `fields` section to the class itself that uses Redux-ORM’s relational operators to define what relations this class has:

    import {Model, fk, oneToOne, many} from "redux-orm";

    export class Pilot extends Model{}
    Pilot.modelName = "Pilot";
    Pilot.fields = {
      mech : fk("Battlemech"),
      lance : oneToOne("Lance")
    };

    export class Battlemech extends Model{}
    Battlemech.modelName = "Battlemech";
    Battlemech.fields = {
        pilot : fk("Pilot"),
        lance : oneToOne("Lance"),
    };

    export class Lance extends Model{}
    Lance.modelName = "Lance";
    Lance.fields = {
        mechs : many("Battlemech"),
        pilots : many("Pilot")
    }

These definitions do not actually need to declare what specific attributes each class has - just the relations to other classes.

### Creating a Schema Instance

Once you’ve defined your models, you need to create an instance of the Redux-ORM Schema class, and pass the model classes to its `register` method. This Schema instance will be a singleton in your application:

    import {Schema} from "redux-orm";
    import {Pilot, Battlemech, Lance} from "./models";

    const schema = new Schema();
    schema.register(Pilot, Battlemech, Lance);
    export default schema;

### Setting Up the Store and Reducers

Next, you need to decide how to integrate Redux-ORM into your reducer structure. The docs suggest that you should define reducer functions on your model classes, then call `schema.reducer()` and attach the returned function into your root reducer using `combineReducers` (probably as a key named `orm`). That approach looks roughly like this:

    // Pilot.js
    class Pilot extends Model {
        static reducer(state, action, Pilot, session) {
            case "PILOT_CREATE": {
                Pilot.create(action.payload.pilotDetails);
                break;
            }
        }
    }

    // rootReducer.js
    import {combineReducers} from "redux";
    import schema from "models/schema";

    const rootReducer = combineReducers({
        orm : schema.reducer()
    });
    export default rootReducer;

**I personally have taken a somewhat different approach**. The majority of my reducer logic is more generic and not class-specific, so I opted instead to write my own slice reducer for this data and just use Redux-ORM as a tool to help with that. The basic approach looks like this:

    // entitiesReducer.js
    import schema from "models/schema";

    // This gives us a set of "tables" for our data, with the right structure
    const initialState = schema.getDefaultState();

    export default function entitiesReducer(state = initialState, action) {
        switch(action.type) {
            case "PILOT_CREATE": {
                const session = schema.from(state);
                const {Pilot} = session;

                // Queue up a "creation" action inside of Redux-ORM
                const pilot = Pilot.create(action.payload.pilotDetails);

                // Applies the queued actions and returns an updated
                // "tables" structure, with all updates handled immutably
                return session.reduce();            
            }    
            // Other actual action cases would go here
            default : return state;
        }
    }

    // rootReducer.js
    import {combineReducers} from "redux";
    import entitiesReducer from "./entitiesReducer";

    const rootReducer = combineReducers({
        entities: entitiesReducer
    });

    export default rootReducer;

### Selecting Data

Finally, the schema can be used to look up data and relationships in selectors and `mapState` functions:

    import React, {Component} from "react";
    import schema from "./schema";
    import {selectEntities} from "./selectors";

    export function mapState(state, ownProps) {
        // Create a Redux-ORM Session instance based on the "tables" in our entities slice
        const entities = selectEntities(state);
        const session = schema.from(entities);
        const {Pilot} = session;

        const pilotModel = Pilot.withId(ownProps.pilotId);

        // Retrieve a reference to the real underlying object in the store
        const pilot = pilotModel.ref;    

        // Dereference a relation and get the real object for it as well
        const battlemech = pilotModel.mech.ref;

        // Dereference another relation and read a field from that model
        const lanceName = pilotModel.lance.name;

        return {pilot, battlemech, lanceName};
    }

    export class PilotAndMechDetails extends Component { ....... }

    export default connect(mapState)(PilotAndMechDetails);

## Redux-ORM and Idiomatic Redux

There’s been numerous addon libraries people have built that try to put some kind of OOP layer on top of Redux, as demonstrated by the [“Variations” page](https://github.com/markerikson/redux-ecosystem-links/blob/master/variations.md) in my [Redux addons catalog](https://github.com/markerikson/redux-ecosystem-links). I’ve frequently pointed out that [Redux is primarily focused on Functional Programming principles](https://www.reddit.com/r/reactjs/comments/518qdr/anyone_have_experience_with_jumpsuit/d7arb9g/?context=3), and that [OOP wrappers over Redux aren’t idiomatic](https://news.ycombinator.com/item?id=11833301). So, given that I usually advise against using those sorts of libraries, you might ask why I encourage the use of Redux-ORM. What makes it different from other libraries like Jumpsuit or Radical?

Most of the OOP wrappers I’ve seen try to abstract things away by defining action creators as class methods, and often wind up ignoring the idea of multiple reducers being able to respond to a given action (or even making it impossible). **They treat Redux as something that needs to be hidden**, and end up throwing away many of the concepts that make Redux attractive.

On the other hand, **Redux-ORM doesn’t try to hide Redux**. It doesn’t pretend that action constants don’t exist, or that actions and reducers are always a 1:1 correspondence. It ultimately just provides an abstraction layer over something you would otherwise would have written yourself: CRUD operations for normalized data. It enables me to think a little less about “What specific steps do I need to follow to update or retrieve this data properly?”, and a little more about handling my data at a conceptual level.

## Final Thoughts

Redux-ORM has become a vital part of my toolkit for writing Redux apps. The data I’m working with is very nested and relational, and Redux-ORM is a perfect fit for my use cases. Although it’s not yet marked as version 1.0, the API has remained consistent and stable since its inception, and Tommi Kaikkonen has been extremely responsive to issues I’ve filed. The fact that the library actually comes with real meaningful documentation (both tutorials and API docs) is a huge plus as well.

Overall, **I highly recommend the use of Redux-ORM in any Redux app that needs to handle normalized nested/relational data**. It won’t magically keep you from having to think about managing that data, but it _will_ make it easier for you to deal with.



