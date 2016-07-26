>* 原文链接 : [MVVM with Flow Controller-First Step](https://medium.com/@digoreis/mvvm-with-flow-controller-first-step-83e60ade0018)
* 原文作者 : [Rodrigo Reis]()
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


> I was watching video of Krzysztof Zabłocki on the concept of MVVM and thought there is only one way to understand something: Create my project!

After much reading about apps architectures, the last 6 months I have been work on a model with MVVM protocols. To understand the origin of this have to quote an article of [**Natasha The Robot**](https://www.natashatherobot.com/swift-2-0-protocol-oriented-mvvm/) and all knowledge about programming oriented protocols. If you do not idea what I’m talking about a good idea is to read [**Natasha The Robot**](https://www.natashatherobot.com/).

A month ago, I ended up watching a lecture by [**Steve “Scotty” Scott**](https://twitter.com/macdevnet) on MVVM-C. In one of the best videos I’ve seen this year, a defense that what matters is not the abbreviations technologies but what an architecture can help us improve our software. I have nothing against the people defending a technology “silver bullet”, but I prefer the strategy to get the best out of each idea to find the best possible solution.

[![](https://i.ytimg.com/vi_webp/9VojuJpUuE8/sddefault.webp)](https://www.youtube.com/embed/9VojuJpUuE8)

In recent weeks, I thought a lot about how to improve my MVVM and create an architecture that supports developments. So I ended up seeing the conversation [**Krzysztof Zabłocki**](https://twitter.com/merowing_) on architectures apps, and it was very inspiring. This content is in [video](http://slideslive.com/38897361/good-ios-application-architecture-en) and in a [post on your blog](http://merowing.info/2016/01/improve-your-ios-architecture-with-flowcontrollers/).

After reading that content I ended up resolving to do a project, try to implement a better architecture to use in current projects. So architecture is defined making clear objectives.

### General objectives

Always before choosing architectures, I learned this many years ago in the Java development world, I create a list of desired goals that are the focus of architecture. This helps to define the strengths in our architecture. Below are the points that motivated me to test.

#### Modules

I wish my architecture, it was possible to create modules for a better use of code. Creating structures that can reuse throughout the project and at the same time can use a specific technology on an interface without having to migrate the entire project.

#### Yes, tests

Unit Tests and UI tests, I believe not need to justify why this focus. But my focus is on architecture isolate layers for automated testing, releasing QA analyst to think of new strategies to maintain the quality of the app.

#### Test A/B

Definitions of new interfaces and functionality, increasingly complex applications day in the mobile market, have the possibility of measuring results of different strategies. I put as an important point the ability to customize and experimenter the user experience.

### MVVM + Flow Controller

In this concept, I decided to create a clear division using MVVM as life-cycle interface. Injecting the necessary dependencies. Management of dependencies and control which interfaces will be used will be the Flow Controller.

#### Flow Controller

Flow Controller is a small set of classes and structs to control the user’s path. This enables us to create different streams for A/B testing for example, and permissions management. Communication between the flow occurs through a common object that passes the Window references or Navigation Controller, that lets you create navigations with different flows.

Another important thing to this model, he is responsible for instantiating the ViewModel + Model to inject the ViewControllers. This helps in dependency injection allowing greater reuse of code. For this to happen it is necessary to explore the Swift Generics, which still has some problems.

#### MVVM

This strategy is very similar to the previous one of my projects, the only difference is that the **VC** must receive a compatible ViewModel (Through a definition of protocols). Thus the **VC** are isolated and self-contained, something important to facilitate testing and increase the reuse of code.

This isolation mentioned it is useful at the point wherein a controller I can use to Reactive Interface if it gives me an advantage. Another example is the exchange of similar interfaces, such as a list by a grid using the same ViewModel. The increased complexity is normal for abstraction, but the gain is increasing as your app grows or undergoes changes with time.

I talk about the culture of keeping an app, and how to evolve the code of a finished product is as important as creating the first version. More detailed in this article: [https://medium.com/@digoreis/your-app-is-getting-old-at-this-time-e025662e20e7#.py9qlarui](https://medium.com/@digoreis/your-app-is-getting-old-at-this-time-e025662e20e7#.py9qlarui)

After this explanation of why to test the architecture in the following text, I will exemplify the initial results.

### Practical Project

I decided to create a simple project, a list, and detail. CocoaPods not used, because are not used dependence, to facilitate understanding and prove another very important point I want to test.

One thing I notice that over time we accept that the Build Team in the development of Apps is very high, this occurs by the accumulation of abuse problems compiling with the principal and several steps project. Something that may seem a simple detail in a first assessment, in fact, a waste team time waiting for XCode translate and organize the project.

[**digoreis/ExampleMVVMFlow** _ExampleMVVMFlow - One Example of MVVM w/ Flow Controller_github.com](https://github.com/digoreis/ExampleMVVMFlow)

#### Storyboard

I am not an advocate of Storyboard does away with what is evil in our Xcode environment. However, the result of not using it is considerable, unfortunately. In the next projects will consider not using it, which is nothing more than an XML representation of a native code. With a team of maturity which to maintain a feature that increases the complexity of the merge and build time. I think everyone should think a little about it.

**But please without controversy!**

#### Challenges

The first phase of the challenge is quite simple, as an item list display them and select a display detail. I believe that the most common task in the development of App.At this point is a simple list of owls, with name, photo, and description. The display is configured through FlowController and settings enums.

I will not go much into the details of that I decided to build it was kind of chaotic because I was testing my abstraction limit in a short period of time (8 hours) and am now working on refining the code instead of increasing the project. In the next section, I speak of the results of the experiment.

#### Results

The first step was to remove the Storyboards (Only the left LaunchScreen) and remove everything that would not use. Then just in the application start to take a start on system flows.

    import UIKit

    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {

        var window: UIWindow?

        func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
            window = UIWindow(frame : UIScreen.mainScreen().bounds)
            let configure = FlowConfigure(window: window, navigationController: nil, parent: nil)
            let mainFlow = MainFlowController(configure: configure)
            mainFlow.start()

            return true
        }
    }

After delivering the application window for the flow system, it starts a system that looks like a tree that is shown in the diagram below. If I wanted to keep a UINavigationController to use navigation so you can start the flow through both: UIWindow or UINavigationController.

![](https://cdn-images-1.medium.com/max/1600/1*oUJ72oZR6wpVkufvCbrMWg.png)

Basic Scheme about MVM with Flow Controller. Source : Me

A Flow has its initializer building a ViewModel and Model (or more if necessary) and **start** method it creates the necessary interfaces, injecting its dependencies. This takes the coupling between these entities more advantage of the code. We can see in the case of OwlsFlowController that through a configuration it selects whether to Grid or List display of the data, in this case, is fixed but it could be a test simple A / B.

    import UIKit

    class OwlsFlowController : FlowController, GridViewControllerDelegate, ListTableViewControllerDelegate {

        private let showType = ShowType.List
        private let configure : FlowConfigure
        private let model = OwlModel()
        private let viewModel : ListViewModel<OwlModel>

        required init(configure : FlowConfigure) {
            self.configure = configure
            viewModel = ListViewModel<OwlModel>(model: model)
        }

        func start() {

            switch showType {
            case .List:
                let configureTable = ConfigureTable(styleTable: .Plain, title: "List of Owls",delegate: self)
                let viewController = ListTableViewController<OwlModel>(viewModel: viewModel, configure: configureTable) { owl, cell in
                    cell.textLabel?.text = owl.name
                }
                configure.navigationController?.pushViewController(viewController, animated: false)
                break
            case .Grid:
                 let layoutGrid = UICollectionViewFlowLayout()
                layoutGrid.scrollDirection = .Vertical
                let configureGrid = ConfigureGrid(viewLayout: layoutGrid, title: "Grid of Owls", delegate: self)
                let viewController = GridViewController<OwlModel>(configure: configureGrid) { owl, cell in
                    cell.image?.image = owl.avatar
                }
                 viewController.configure(viewModel:viewModel)
                configure.navigationController?.pushViewController(viewController, animated: false)
                break
            }

        }

        private enum ShowType {
            case List
            case Grid
        }

        func openDetail(id : Int) {
             let detail = FlowConfigure(window: nil, navigationController: configure.navigationController, parent: self)
             let childFlow = OwlDetailFlowController(configure: detail,item: viewModel.item(ofIndex: id))
             childFlow.start()
        }
    }

The advantage of this model is the case most lists an application share the same behavior and the same interface infrastructure. In this case, only the data and the cell change and can be passed as a parameter and creating a reuse a code base for all lists.

An interesting idea here is that implemented two response protocols: one for Grid and one for List. But the implementation is the same for both. And this is interesting because I have separate actions for each type of interface, but the common actions can be shared. And without the use of inheritance.

    import UIKit

    struct ConfigureTable {
        let styleTable : UITableViewStyle
        let title : String
        let delegate : ListTableViewControllerDelegate
    }

    protocol ListTableViewControllerDelegate {
        func openDetail(id : Int)
    }

    class ListTableViewController<M : ListModel>: UITableViewController {

        var viewModel : ListViewModel<M>
        var populateCell : (M.Model,UITableViewCell) -> (Void)
        var configure : ConfigureTable

        init(viewModel model : ListViewModel<M>, configure : ConfigureTable, populateCell : (M.Model,UITableViewCell) -> (Void)) {
            self.viewModel = model
            self.populateCell = populateCell
            self.configure = configure
            super.init(style: configure.styleTable)
            self.title = configure.title
        }

        override func viewDidLoad() {
            super.viewDidLoad()
        }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }

        override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
        }

        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.count()
        }

        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
            populateCell(viewModel.item(ofIndex: indexPath.row), cell)
            return cell
        }

        override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            configure.delegate.openDetail(indexPath.row)
        }

    }

The implementation of the interface is clear and clean, it is an objective infrastructure which has simple parameters to display. All creation was removed and leaving him with nothing business implementation.

Another thing is the passage of a Closure to populate the cell, something that will allow us to pass which phone to use as a parameter in the near future. The idea of this architecture is to think of the interface into two parts, the first a series of ready infrastructure and reusable throughout the project.

The second part would UIViews and cells that are customized for each situation and for each data set. So we have much of our interface covered by generic tests, increasing security implementation.

**_PS: For some reason, in some cases, the Swift will not accept a Generic type as a protocol parameter of an init method. Still investigating if a Swift Bug or a deliberate limitation._**

The result was a very clean code and maximizing the reuse of interfaces. and explored the use of Generics and protocols as a way of abstracting problems. Other result is the build time is noticeably much faster.

These are initial results in a few weeks I hope other results and that I will explore in other articles. If they want to keep up on Github try to document well there or here in Medium, I’ll put the articles.

Following the next steps and thanks.

### Next Steps

*   Tests : Unit tests and UITest with Mock Objects ( I start the test , 78% coverage)
*   Expand Models : Other Objects (I need to find other animals)
*   Infrastructure of Interface : Create others cell types and use the same UIViewController

My next article will be how to build effective tests, simple and easy to maintain. Cross your fingers for me.

### Special Thanks

First my wife the inspiration of owls. She likes owls. I also need you thank Hootsuite for having created this package so cool images.

I tried to mark the reference of all I read to write this code when I quoted, sorry if I forgot someone.

I can not forget to thank [Mikail Freitas](https://github.com/mikailcf) for helping me identify the initializers error with Generic protocols. We will never understand why in one case works and the other does not.
