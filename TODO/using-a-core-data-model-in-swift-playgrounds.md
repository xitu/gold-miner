> * 原文链接 : [using-a-core-data-model-in-swift-playgrounds](https://www.andrewcbancroft.com/2016/07/10/using-a-core-data-model-in-swift-playgrounds/)
* 原文作者 : [Andrew Bancroft](https://www.andrewcbancroft.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:

Did you know that you can tinker with Core Data inside of Swift playgrounds in Xcode? You can!

[Jeremiah Jessel](https://twitter.com/JCubedApps), author at [http://www.learncoredata.com](http://www.learncoredata.com), wrote up an article in 2015 [detailing how you can use the Core Data framework inside a playground](http://www.learncoredata.com/core-data-and-playgrounds/). He shows how you can do everything from setting up the Core Data stack, to creating NSManagedObjects programmatically in code. Great stuff!

After I read his guide, I got to thinking: _I wonder_ if you can take an .xcdatamodeld file created with Xcode’s Data Model designer and use _it_ in a Playground….

The short answer is, **kinda**. You can’t use the .xcdatamodeld file (at least, I couldn’t find a way), BUT, you _can_ use the _compiled_ “momd” file that gets created when you build your app.

## Limitations

There’s at least two limitations / caveats I’ve come across as I’ve been playing with this concept:

## No NSManagedObject subclasses

While you can create instances of the Entities in the model, if you’ve created `NSManagedObject` subclasses for your Entities, you won’t be able to use those in the playground. You’d have to resort back to setting properties on your `NSManagedObject` instances using `setValue(_: forKey:)`.

But this is a minor drawback, especially if you’re just wanting to tinker.

## Model updates

After you read the [walkthrough](https://www.andrewcbancroft.com/2016/07/10/using-a-core-data-model-in-swift-playgrounds/#walkthrough), you’ll know how to get the model into your playground.

Here’s the deal though: If you ever make _changes_ to your model, you’ll need to go through the steps necessary to _re_-add a freshly-compiled model to the playground’s Resources folder that includes the changes. This is because resources that are added to a playground are _copied_, not referenced.

I don’t think that’s a terrible draw-back, especially once you know how to do it.

So how do you do it? Here’s how:

## Walkthrough

Get started by adding a Data Model to your project. If you’ve got a project already going that uses Core Data, you probably already have a .xcdatamodeld file in your project. If you don’t, though, one is easily add-able from the File menu:

## Add Data Model file (unless you already have one)

File -> New -> File…  
![New Data Model](https://www.andrewcbancroft.com/wp-content/uploads/2016/07/new-model.png)

For my “smoke test”, just to see if it was possible, I left the default value for the model name as “Model.xcdatamodeld”.

## Add entity with attribute

Once I had the data model added to the project, I went in and added an entity (named “Entity”) with an attribute (named “attribute” of type Integer 16):

![Add an entity with an attribute.](https://www.andrewcbancroft.com/wp-content/uploads/2016/07/add-entity-and-attributes.png)

## Add a playground

Next up, I added a new playground to my project:

File -> New -> Playground…  
![Add new playground](https://www.andrewcbancroft.com/wp-content/uploads/2016/07/new-playground.png)

## Build project; Locate “momd” file

With a playground and a data model has some structure to it, I built the project (CMD + B) so that the .xcdatamodeld file would be compiled into an “momd” file. It’s the _momd_ file that needs to be added to the playground as a resource.

To find the “momd” file, expand “Products” in your project navigator, right-click the .app file, and click “Show in Finder”:  
![Show product in finder](https://www.andrewcbancroft.com/wp-content/uploads/2016/07/show-product-in-finder.png)

## Show .app package contents

In the finder window, right-click the .app file, and click “Show package contents”:  
![Show package contents](https://www.andrewcbancroft.com/wp-content/uploads/2016/07/show-package-contents.png)

## Drag “momd” file from Finder to playground Resources folder

![Locate ](https://www.andrewcbancroft.com/wp-content/uploads/2016/07/locate-momd-file.png)

![Drag ](https://www.andrewcbancroft.com/wp-content/uploads/2016/07/drag-momd-to-resources.png)

## Write Core Data code to use model

That’s it! Now that the “momd” file is in the playground’s Resources folder, you’re set to write code against it. You can insert `NSManagedObject` instances, perform fetch requests, etc. Here’s an example that I wrote up:


Core Data Playground
```
import UIKit
import CoreData

// Core Data Stack Setup for In-Memory Store
public func createMainContext() -> NSManagedObjectContext {
    
    // Replace "Model" with the name of your model
    let modelUrl = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")
    guard let model = NSManagedObjectModel.init(contentsOfURL: modelUrl!) else { fatalError("model not found") }
    
    let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
    try! psc.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
    
    let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    context.persistentStoreCoordinator = psc
    
    return context
}

let context = createMainContext()

// Insert a new Entity
let ent = NSEntityDescription.insertNewObjectForEntityForName("Entity", inManagedObjectContext: context)
ent.setValue(42, forKey: "attribute")

try! context.save()

// Perform a fetch request
let fr = NSFetchRequest(entityName: "Entity")
let result = try! context.executeFetchRequest(fr)

print(result)
```

![Fetch request result](https://www.andrewcbancroft.com/wp-content/uploads/2016/07/printed-result.png)

Woohoo! I thought this was pretty cool.

**Don’t forget**: If you make updates to your model, you need to re-build your app, delete the “momd” folder from your playground’s resources, re-drag the freshly-compiled “momd” file to your playground again to work with the latest version of the model.

## Potential usefulness

The other important question to ask, besides “I wonder if this is possible?” is “How is this useful?”

*   Learning. Playgrounds in and of themselves make sense as a learning tool. How cool is it to be able to build the model you’re thinking of in the Xcode designer, import that into a playground, and tinker with it as a learning exercise??
*   This could also be useful when you need to try out your data model but don’t really want to wire it up to an actual user interface yet. Strip away all the UI complexity and just work with the data model… in a playground! It just seems like a more elegant solution to the “print it out to the console” method of experimenting with the model.
*   There might be situations when you’re building semi-complicated `NSPredicate` instances for a fetch request – why not get it working in a playground first, then migrate it over to your app? Just an idea!
