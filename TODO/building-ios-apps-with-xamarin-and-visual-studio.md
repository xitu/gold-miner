>* 原文链接 : [Building iOS Apps with Xamarin and Visual Studio](https://www.raywenderlich.com/134049/building-ios-apps-with-xamarin-and-visual-studio)
* 原文作者 : [Bill Morefield](https://www.raywenderlich.com/u/bmorefield)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


![](https://cdn4.raywenderlich.com/wp-content/uploads/2016/07/VisualStudioXamarin-Feature-250x250.png)

When creating iOS apps, developers typically turn to the languages and IDE provided by Apple: Objective-C / Swift and Xcode. However, this isn’t the only option—you can create iOS apps using a variety of languages and frameworks.

One of the most popular options is [Xamarin](https://xamarin.com), a cross-platform framework that allows you to develop iOS, Android, OS X and Windows apps using C# and Visual Studio. The major benefit here is Xamarin can allow you to share code between your iOS and Android app.

Xamarin has a big advantage over other cross-platform frameworks: with Xamarin, your project compiles to native code, and can use native APIs under the hood. This means a well written Xamarin app should be indistinguishable from an app made with Xcode. For more details, check out this great [Xamarin vs. Native App Development](http://willowtreeapps.com/blog/xamarin-vs-native-app-development/) article.

Xamarin had a big disadvantage too in the past too: its price. Because of the steep licensing cost of $1,000 per platform per year, you’d have to give up your daily latte or frappuccino to even _think_ about affording it … and programming without coffee can get dangerous. Because of this steep price, until recently Xamarin appealed mostly to enterprise projects with big budgets.

However, this recently changed when Microsoft purchased Xamarin and announced that it would be included in all new versions of Visual Studio, including the free [Community Edition](https://www.visualstudio.com/en-us/products/visual-studio-community-vs.aspx) that’s available to individual developers and small organizations.

Free? Now that’s a price to celebrate!

[![More money for coffee!](https://cdn1.raywenderlich.com/wp-content/uploads/2016/06/dollar-941246_1280-427x320.jpg)](https://cdn2.raywenderlich.com/wp-content/uploads/2016/06/dollar-941246_1280.jpg)

More money for coffee!



Besides cost (or lack thereof), Xamarin’s other virtues include allowing programmers to:

*   Leverage existing C# libraries and tools to create mobile apps.
*   Reuse code between apps on different platforms.
*   Share code between ASP.Net backends and customer-facing apps.

Xamarin also offers a choice of tools, depending on your needs. To maximize cross-platform code reuse, use [Xamarin Forms](https://www.xamarin.com/forms). This works especially well for apps that don’t need platform-specific functionality or a particularly custom interface.

If your app does require platform-specific features or designs, use [Xamarin.iOS](https://developer.xamarin.com/guides/ios/), [Xamarin.Android](https://developer.xamarin.com/guides/android/) and other platform-specific modules to get direct interaction with native APIs and frameworks. These modules provide the flexibility to create very custom user interfaces, yet still allow sharing of common code across platforms.

In this tutorial, you’ll use _Xamarin.iOS_ to create an iPhone app that displays a user’s photo library.

This tutorial doesn’t require any prior iOS or Xamarin development experience, but to get the most from it you’ll need a basic understanding of C#.

## Getting Started

To develop an iOS app with Xamarin and Visual Studio, you’ll ideally need two machines:

1.  _A Windows machine_ to run Visual Studio and write your project’s code.
2.  _A Mac machine_ with Xcode installed to act as a build host. This doesn’t have to be a dedicated computer for building, but it must be network accessible during development and testing from your Windows computer.

It greatly helps if your machines are physically near each other, since when you build and run on Windows, the iOS Simulator will load on your Mac.

I can hear some of you saying, “What if I don’t have both machines?!”

*   _For Mac-only users_, Xamarin does provide an IDE for OS X, but in this tutorial we will be focusing on the shiny new Visual Studio support. So if you’d like to follow along, you can run Windows as a virtual machine on your Mac. Tools such as [VMWare Fusion](https://www.vmware.com/products/fusion) or the free, open-source [VirtualBox](https://www.virtualbox.org/) make this an effective way to use a single computer.

    If using Windows as a virtual machine, you’ll need to ensure that Windows has network access to your Mac. In general, if you can `ping` your Mac’s IP address from inside Windows, you should be good to go.

*   _For Windows-only users_, go buy a Mac right now. I’ll wait! :] If that’s not an option, hosted services such as [MacinCloud](http://www.macincloud.com/) or [Macminicolo](https://macminicolo.net/) provide remote Mac access for building.

This tutorial assumes you’re using separate Mac and Windows computers, but don’t worry—the instructions are basically the same if you’re using Windows inside a virtual machine on your Mac.

### Installing Xcode and Xamarin

If you don’t have it already, [download and install Xcode](https://itunes.apple.com/us/app/xcode/id497799835) on your Mac. This is just like installing any other app from the App Store, but since it’s several gigabytes of data, it may take a while.

[![Installing Xcode? Perfect time for a cookie break!](https://cdn1.raywenderlich.com/wp-content/uploads/2016/06/danish-butter-cookies-1032894_1280-480x270.jpg)](https://cdn5.raywenderlich.com/wp-content/uploads/2016/06/danish-butter-cookies-1032894_1280.jpg)

Perfect time for a cookie break!


After Xcode is installed, [download Xamarin Studio](https://www.xamarin.com/download) onto your Mac. You’ll need to provide your email, but the download is otherwise free. Optional: do a happy dance for all the coffees you can still afford.

Once the download is complete, _open the installer package_ and double click _Install Xamarin.app_. Accept the terms and conditions and continue.

The installer will search for already-installed tools and check for current platform versions. It will then show you a list of development environments. Make sure _Xamarin.iOS_ is checked, then click _Continue_.

![Xamarin Installer](https://cdn1.raywenderlich.com/wp-content/uploads/2016/05/xamarin-installer.png)

Next you’ll see a confirmation list summarizing the items to be installed. Click _Continue_ to proceed. You will be given a summary and an option to launch Xamarin Studio. Instead, click _Quit_ to complete the installation.

### Installing Visual Studio and Xamarin

For this tutorial you can use any version of Visual Studio, including the free [Community Edition](https://www.visualstudio.com/en-us/products/visual-studio-community-vs.aspx). Some features are [absent](https://www.visualstudio.com/products/compare-visual-studio-2015-products-vs) in the Community Edition, but nothing that will prevent you from developing complex apps.

Your Windows computer should meet the [Visual Studio minimum system requirements](https://www.visualstudio.com/en-us/downloads/visual-studio-2015-system-requirements-vs.aspx#1). For a smooth development experience, you’ll want at least 3 GB of RAM.

If you don’t already have Visual Studio installed, download the Community Edition installer by clicking the green _Download Community 2015_ button on the [Community Edition web site](https://www.visualstudio.com/en-us/products/visual-studio-community-vs.aspx).

Run the installer to begin the installation process, and choose the _Custom_ installation option. In the features list, expand _Cross Platform Mobile Development_, and select _C#/.NET (Xamarin v4.0.3)_ (where v4.0.3 is the current version when this tutorial was written, but will likely be different in the future).

![vs-installer](https://cdn5.raywenderlich.com/wp-content/uploads/2016/05/vs-installer-354x500.png)

Click _Next_ and wait for the installation to complete. This will likely take a while; go take a walk to burn off all the cookies you ate while installing Xcode. :]

If you already have Visual Studio installed but don’t have the Xamarin tools, go to _Programs and Features_ on your Windows computer and find _Visual Studio 2015_. Select it, click _Change_ to access its setup, then select _Modify_.

You’ll find Xamarin under _Cross Platform Mobile Development_ as _C#/.NET (Xamarin v4.0.3)_. Select it and click _Update_ to install.

Whew—that’s a lot of installations, but now you’ve got everything you need!

![Install_Powers](https://cdn1.raywenderlich.com/wp-content/uploads/2016/06/Install_Powers.png)

## Creating the App

Open Visual Studio and select _File\New\Project_. Under Visual C# expand _iOS_, select _iPhone_ and pick the _Single View App_ template. This template creates an app with a single view controller, which is simply a class that manages a view in an iOS app.

![NewProject](https://cdn1.raywenderlich.com/wp-content/uploads/2016/06/NewProject-461x320.png)

For both the _Name_ and the _Solution Name_, enter _ImageLocation_. Choose a location on your computer for your app and click _OK_ to create the project.

Visual Studio will prompt you to prepare your Mac to be the Xamarin build host:

1.  On the Mac, open _System Preferences_ and select _Sharing_.
2.  Turn on _Remote Login_.
3.  Change _Allow access_ to _Only these users_ and add a user that has access to Xamarin and Xcode on the Mac.  
    ![Setup Mac as Build Host](https://cdn5.raywenderlich.com/wp-content/uploads/2016/05/build-host-setup-629x500.png)
4.  Dismiss the instructions and return to your Windows computer.

Back in Visual Studio, you will be asked to select the Mac as the build host. Select your Mac and click _Connect_. Enter the username and password, then click _Login_.

You can verify you’re connected by checking the toolbar.

[![Connected_Indicator](https://cdn1.raywenderlich.com/wp-content/uploads/2016/06/Connected_Indicator-480x68.png)](https://cdn3.raywenderlich.com/wp-content/uploads/2016/06/Connected_Indicator.png)

Select _iPhone Simulator_ from the Solution Platform dropdown—this will automatically pick a simulator from the build host. You can also change the device simulator by clicking the small arrow next to the current simulator device.

[![Change_Simulator](https://cdn2.raywenderlich.com/wp-content/uploads/2016/06/Change_Simulator-1.png)](https://cdn2.raywenderlich.com/wp-content/uploads/2016/06/Change_Simulator-1.png)

Build and run by pressing the green _Debug_ arrow or the shortcut key _F5_.

[![Build_and_Run](https://cdn4.raywenderlich.com/wp-content/uploads/2016/06/Build_and_Run.png)](https://cdn1.raywenderlich.com/wp-content/uploads/2016/06/Build_and_Run.png)

Your app will compile and execute, but you won’t see it running on Windows. Instead, you’ll see it on your Mac build host. This is why it helps to have your two machines nearby :]

At the recent [Evolve conference](https://evolve.xamarin.com/), Xamarin announced [iOS Simulator Remoting](https://blog.xamarin.com/live-from-evolve-new-xamarin-previews/) that will soon allow you to interact with apps running in Apple’s iOS Simulator as though the simulator were running on your Windows PC. For now, however, you’ll need to interact with the simulator on your Mac.

You should see a splash screen appear on the simulator and then an empty view. Congratulations! Your Xamarin setup is working.

[![Template App](https://cdn1.raywenderlich.com/wp-content/uploads/2016/05/template-app-running-1-272x500.png)](https://cdn2.raywenderlich.com/wp-content/uploads/2016/05/template-app-running-1-272x500.png)

Stop the app by pressing the _red stop button_ (shortcut _Shift + F5_).

## Creating the Collection View

The app will display thumbnails of the user’s photos in a Collection View, which is an iOS control for displaying several items in a grid.

To edit the app’s storyboard, which contains the “scenes” for the app, open _Main.storyboard_ from the _Solution Explorer_.

[![](https://cdn5.raywenderlich.com/wp-content/uploads/2016/06/Main_Storyboard-269x320.png)](https://cdn3.raywenderlich.com/wp-content/uploads/2016/06/Main_Storyboard.png)

Open the _Toolbox_ and type _collection_ into the text box to filter the list of items. Under the _Data Views_ section, drag the _Collection View_ object from the toolbox into the middle of the empty view.

[![Add Collection View](https://cdn4.raywenderlich.com/wp-content/uploads/2016/06/Drag_Collection_View-650x456.png)](https://cdn2.raywenderlich.com/wp-content/uploads/2016/06/Drag_Collection_View.png)

Select the collection view; you should see _hollow circles_ on each side of the view. If instead you see _T shapes_ on each side, click it again to switch to the circles.

[![Resizing the Collection View](https://cdn5.raywenderlich.com/wp-content/uploads/2016/05/resize-collection-view-521x500.gif)](https://cdn5.raywenderlich.com/wp-content/uploads/2016/05/resize-collection-view-521x500.gif)

Click and drag each circle to the edge of the view until blue lines appear. The edge should snap to this location when you release the mouse button.

Now you’ll set up Auto Layout Constraints for the collection view; these tell the app how the view should be resized when the device rotates. In the toolbar at the top of the storyboard, click on the _green plus sign_ next to the _CONSTRAINTS_ label. This will automatically add constraints for the collection view.

[![Add_Constraints](https://cdn5.raywenderlich.com/wp-content/uploads/2016/06/Add_Constraints-650x112.png)](https://cdn3.raywenderlich.com/wp-content/uploads/2016/06/Add_Constraints.png)

The generated constraints are almost correct, but you’ll need to modify some of them. On the _Properties_ window, switch to the _Layout_ tab and scroll down to the _Constraints_ section.

The two constraints defined from the edges are correct, but the height and width constraints are not. Delete the _Width_ and _Height_ constraints by clicking the _X_ next to each.

[![Delete Constraints](https://cdn1.raywenderlich.com/wp-content/uploads/2016/06/Delete_Constraints-304x500.png)](https://cdn3.raywenderlich.com/wp-content/uploads/2016/06/Delete_Constraints.png)

Notice how the collection view changes to an orange tint. This is an indicator that the constraints need to be fixed.

Click on the collection view to select it. If you see the circles as before, click again to change the icons to green _T shapes_. Click and drag the T on the _top edge_ of the collection view up to the green rectangle named _Top Layout Guide_. Release to create a constraint relative to the top of the view.

Lastly, click and drag the T on the _left side_ of the collection view to the left until you see a _blue dotted line_. Release to create a constraint relative to the left edge of the view.

At this point, your constraints should look like this:

![Constraints](https://cdn5.raywenderlich.com/wp-content/uploads/2016/06/Constraints.png)

## Configuring the Collection View Cell

You may have noticed the outlined square inside the collection view, inside of which is a red circle containing an exclamation point. This is a collection view cell, which represents a single item in the collection view.

To configure this cell’s size, which is done on the collection view, select the collection view and scroll to the top of the _Layout_ tab. Under _Cell Size_, set the _Width_ and _Height_ to _100_.

[![cell-size](https://cdn5.raywenderlich.com/wp-content/uploads/2016/06/cell-size.png)](https://cdn5.raywenderlich.com/wp-content/uploads/2016/06/cell-size.png)

Next, click the _red circle_ on the collection view cell. A pop-up will inform you that you haven’t set a reuse identifier for the cell, so select the cell and go to the _Widget_ tab. Scroll down to the _Collection Reusable View_ section and enter _ImageCellIdentifier_ for the _Identifier_. The error indicator should vanish.

[![Set_Reuse_Identifier](https://cdn2.raywenderlich.com/wp-content/uploads/2016/06/Set_Reuse_Identifier-480x202.png)](https://cdn5.raywenderlich.com/wp-content/uploads/2016/06/Set_Reuse_Identifier.png)

Continue scrolling down to the _Interaction Section_. Set the _Background Color_ by selecting _Predefined_ and _blue_.

[![Set Cell Background Color](https://cdn5.raywenderlich.com/wp-content/uploads/2016/06/Set_Cell_Background_Color-427x320.png)](https://cdn2.raywenderlich.com/wp-content/uploads/2016/06/Set_Cell_Background_Color.png)

The scene should look like the following:

![Collection Cell with Color](https://cdn5.raywenderlich.com/wp-content/uploads/2016/05/collection-cell-with-color-470x500.png)

Scroll to the top of the _Widget_ section and set the _Class_ as _PhotoCollectionImageCell_.

[![Set Cell Class](https://cdn4.raywenderlich.com/wp-content/uploads/2016/06/Set_Cell_Class.png)](https://cdn4.raywenderlich.com/wp-content/uploads/2016/06/Set_Cell_Class.png)

Visual Studio will automatically create a class with this name, inheriting from `UICollectionViewCell`, and create `PhotoCollectionImageCell.cs` for you. Sweet, I wish Xcode did that! :]

## Creating the Collection View Data Source

You’ll need to manually create a class to act as the `UICollectionViewDataSource`, which will provide data for the collection view.

Right-click on _ImageLocation_ in the _Solution Explorer_. Select _Add \ Class_, name the class _PhotoCollectionDataSource.cs_ and click _Add_.

Open the newly added `PhotoCollectionDataSource.cs` and add the following at the top of the file:

    using UIKit;
    
This gives you access to the iOS `UIKit` framework.

Change the definition of the class to the following:


    public class PhotoCollectionDataSource : UICollectionViewDataSource
    {
    }


Remember the reuse identifier you defined on the collection view cell earlier? You’ll use that in this class. Add the following right inside the class definition:

    private static readonly string photoCellIdentifier = "ImageCellIdentifier";


The `UICollectionViewDataSource` class contains two abstract members you must implement. Add the following right inside the class:



    public override UICollectionViewCell GetCell(UICollectionView collectionView, 
        NSIndexPath indexPath)
    {
        var imageCell = collectionView.DequeueReusableCell(photoCellIdentifier, indexPath)
           as PhotoCollectionImageCell;

        return imageCell;
    }

    public override nint GetItemsCount(UICollectionView collectionView, nint section)
    {
        return 7;
    }


`GetCell()` is responsible for providing a cell to be displayed within the collection view.

`DequeueReusableCell` reuses any cells that are no longer needed, for example if they’re offscreen, which you then simply return. If no reusable cell is available, a new one is created automatically.

`GetItemsCount` tells the collection view to display seven items.

Next you’ll add a reference to the collection view to the `ViewController` class, which is the view controller that manages the scene containing the collection view. Switch back to _Main.storyboard_, select the collection view, then select the _Widget_ tab. Enter _collectionView_ for the _Name_.

[![Set Collection View Name](https://cdn4.raywenderlich.com/wp-content/uploads/2016/06/Set_CollectionView_Name-480x160.png)](https://cdn1.raywenderlich.com/wp-content/uploads/2016/06/Set_CollectionView_Name.png)

Visual Studio will automatically create an instance variable with this name on the `ViewController` class.

_Note:_ You won’t see this instance variable within _ViewController.cs_ itself. To see the the instance variable, click the disclosure indicator to the left of _ViewController.cs_ to reveal _ViewController.designer.cs_ inside. This contains the `collectionView` instance variable automatically generated by Visual Studio.

Open _ViewController.cs_ from the Solution Explorer and add the following field right inside the class:



    private PhotoCollectionDataSource photoDataSource;



At the end of `ViewDidLoad()`, add these lines to instantiate the data source and connect it to the collection view.


    photoDataSource = <a href="http://www.google.com/search?q=new+msdn.microsoft.com">new</a> PhotoCollectionDataSource();
    collectionView.DataSource = photoDataSource;


This way the `photoDataSource` will provide the data for the collection view.

Build and run. You should see the collection view with seven blue squares.

![App Running with collection view](https://cdn3.raywenderlich.com/wp-content/uploads/2016/05/cells-no-photo-app-272x500.png)

Nice – the app is really coming along!

![Blue Squares!](https://cdn5.raywenderlich.com/wp-content/uploads/2016/06/Blue_Squares-230x320.png)

## Showing Photos

While blue squares are cool, you’ll next update the data source to actually retrieve photos from the device and display them on the collection view. You’ll use the `Photos` framework to access photo and video assets managed by the Photos app.

To start, you’ll add a view to display an image on the collection view cell. Open _Main.storyboard_ again and select the collection view cell. On the _Widget_ tab, scroll down and change the _Background_ color back to the default.

[![Set_Default_Cell_Background_Color](https://cdn3.raywenderlich.com/wp-content/uploads/2016/06/Set_Default_Cell_Background_Color-480x247.png)](https://cdn3.raywenderlich.com/wp-content/uploads/2016/06/Set_Default_Cell_Background_Color.png)

Open the _Toolbox_, search for _Image View_, then drag an _Image View_ onto the _collection view Cell_.

[![Drag Image View](https://cdn4.raywenderlich.com/wp-content/uploads/2016/06/Drag_Image_View-650x400.png)](https://cdn4.raywenderlich.com/wp-content/uploads/2016/06/Drag_Image_View.png)

The image view will initially be much larger than the cell; to resize it, select the image view and go to the _Properties \ Layout_ tab. Under the _View_ section, set both the _X_ and _Y_ values to 0 and the _Width_ and _Height_ values to _100_.

[![Set Image View Size](https://cdn5.raywenderlich.com/wp-content/uploads/2016/06/Set_Image_View_Size-480x296.png)](https://cdn1.raywenderlich.com/wp-content/uploads/2016/06/Set_Image_View_Size.png)

Switch to the _Widget_ tab for the image view and set the _Name_ as _cellImageView_. Visual Studio will automatically create a field named `cellImageView` for you.

[![Set Image View Name](https://cdn3.raywenderlich.com/wp-content/uploads/2016/06/Set_Image_View_Name-480x152.png)](https://cdn2.raywenderlich.com/wp-content/uploads/2016/06/Set_Image_View_Name.png)

Scroll to the _View_ section and change the _Mode_ to _Aspect Fill_. This keeps the images from becoming stretched.

[![Set Image View Mode](https://cdn5.raywenderlich.com/wp-content/uploads/2016/06/Set_Image_View_Mode-480x147.png)](https://cdn4.raywenderlich.com/wp-content/uploads/2016/06/Set_Image_View_Mode.png)

_Note:_ Again, if you open _PhotoCollectionImageCell.cs_, you won’t see the new field. Instead the class is declared as `partial`, which indicates that the field is in another file.

In the _Solution Explorer_, select the arrow to the left of `PhotoCollectionImageCell.cs` to expand the files. Open `PhotoCollectionImageCell.designer.cs` to see `cellImageView` declared there.

[![](https://cdn1.raywenderlich.com/wp-content/uploads/2016/06/Expand_PhotoCollectionImageCell-480x248.png)](https://cdn3.raywenderlich.com/wp-content/uploads/2016/06/Expand_PhotoCollectionImageCell.png)

This file is automatically generated; do **not** not make any changes to it. If you do, they may be overwritten without warning or break links between the class and storyboard, resulting in runtime errors.



Since this field isn’t public, other classes cannot access it. Instead, you’ll need to provide a method to be able to set the image.

Open `PhotoCollectionImageCell.cs` and add the following method to the class:



    public void SetImage(UIImage image)
    {
        cellImageView.Image = image;
    }



Now you’ll update `PhotoCollectionDataSource` to actually retrieve photos.

Add the following at the top of _PhotoCollectionDataSource.cs_:

    using Photos;


Add the following fields to the `PhotoCollectionDataSource`:



    private PHFetchResult imageFetchResult;
    private PHImageManager imageManager;



The `imageFetchResult` field will hold an ordered list of photo entity objects, and you’ll get this photos list from the `imageManager`.

Right above `GetCell()`, add the following constructor:



    public PhotoCollectionDataSource()
    {
        imageFetchResult = PHAsset.FetchAssets(PHAssetMediaType.Image, null);
        imageManager = new PHImageManager();
    }



This constructor gets a list of all image assets in the Photos app and stores the result in the `imageFetchResult` field. It then sets the `imageManager`, which the app will query for more information about each image.

Dispose of the `imageManager` object when the class finishes by adding this destructor below the constructor.



    ~PhotoCollectionDataSource()
    {
        imageManager.Dispose();
    }



To make the `GetItemsCount` and `GetCell` methods use these resources and return images instead of empty cells, change `GetItemsCount()` to the following:



    public override nint GetItemsCount(UICollectionView collectionView, nint section)
    {
        return imageFetchResult.Count;
    }



Then replace `GetCell` with the following:



    public override UICollectionViewCell GetCell(UICollectionView collectionView, 
        NSIndexPath indexPath)
    {
        var imageCell = collectionView.DequeueReusableCell(photoCellIdentifier, indexPath) 
            as PhotoCollectionImageCell;

        // 1
        var imageAsset = imageFetchResult[indexPath.Item] as PHAsset;

        // 2
        imageManager.RequestImageForAsset(imageAsset, 
            <a href="http://www.google.com/search?q=new+msdn.microsoft.com">new</a> CoreGraphics.CGSize(100.0, 100.0), PHImageContentMode.AspectFill,
            <a href="http://www.google.com/search?q=new+msdn.microsoft.com">new</a> PHImageRequestOptions(),
             // 3
             (UIImage image, NSDictionary info) =>
            {
               // 4
               imageCell.SetImage(image);
            });

        return imageCell;
    }



Here’s a breakdown of the changes above:

1.  The `indexPath` contains a reference to which item in the collection view to return. The `Item` property is a simple index. Here you get the asset at this index and cast it to a `PHAsset`.
2.  You use `imageManager` to request the image for the asset with a desired size and content mode.
3.  Many iOS framework methods use deferred execution for requests that can take time to complete, such as `RequestImageForAsset`, and take a delegate to be called upon completion. When the request completes, the delegate will be called with the image and information about it.
4.  Lastly, the image is set on the cell.

Build and run. You’ll see a prompt requesting permission access.

[![](https://cdn2.raywenderlich.com/wp-content/uploads/2016/06/Permission_Prompt-333x500.png)](https://cdn3.raywenderlich.com/wp-content/uploads/2016/06/Permission_Prompt.png)

If you select _OK_, however, the app … doesn’t do anything. _So_ disappointing!

![Why_no_work](https://cdn3.raywenderlich.com/wp-content/uploads/2016/06/Why_no_work-248x320.png)

iOS considers access to users’ photos to be sensitive information, and prompts the user for permission. However, the app must also register to be notified when the user has granted this permission, so it can reload its views. You’ll do this next.

## Registering for Photo Permission Changes

First, you’ll add a method to the `PhotoCollectionDataSource` class to inform it to re-query for photo changes. Add the following to the end of the class:



    public void ReloadPhotos()
    {
        imageFetchResult = PHAsset.FetchAssets(PHAssetMediaType.Image, null);
    }



Next, open _ViewController.cs_ and add the following framework to the top of the file:
  
    using Photos;

Then add this code to the end of `ViewDidLoad()`:



    // 1
    PHPhotoLibrary.SharedPhotoLibrary.RegisterChangeObserver((changeObserver) =>
    {
        //2
        InvokeOnMainThread(() =>
        {
            // 3
            photoDataSource.ReloadPhotos();
            collectionView.ReloadData();
        });
    });



Here’s what this does:

1.  The app registers a delegate on the shared photo library to be called whenever the photo library changes.
2.  `InvokeOnMainThread()` ensures that UI changes are always processed on the main thread; otherwise a crash may result.
3.  You call `photoDataSource.ReloadPhotos()` to reload the photos and `collectionView.ReloadData()` to tell the collection view to redraw.

Finally, you’ll handle the initial case, in which the app has not yet been given access to photos, and request permission.

In `ViewDidLoad()`, add the following code right before setting `photoDataSource`:



    if (PHPhotoLibrary.AuthorizationStatus == PHAuthorizationStatus.NotDetermined)
    {
        PHPhotoLibrary.RequestAuthorization((PHAuthorizationStatus newStatus) =>
        { });
    }



This checks the current authorization status, and if it’s `NotDetermined`, explicitly requests permission to access photos.

In order to trigger the photos permission prompt again, reset the iPhone simulator by going to _Simulator \ Reset Content and Settings_.

Build and run the app. You’ll be prompted for photo permission, and after you press _Ok_ the app will show the collection view with thumbnails for all the device’s photos!

![Final Project Running](https://cdn5.raywenderlich.com/wp-content/uploads/2016/05/photo-collection-app-272x500.png)

## Where to Go From Here?

You can download the completed Visual Studio project from [here](https://cdn1.raywenderlich.com/wp-content/uploads/2016/07/ImageLocation.zip).

In this tutorial, you learned a bit about how Xamarin works and how to use it to create iOS apps.

The [Xamarin Guides Site](https://developer.xamarin.com/guides/) provides several good resources to learn more about the Xamarin platform. To better understand building cross-platforms apps, view the Xamarin tutorials on building the same app for [iOS](https://www.xamarin.com/getting-started/ios) and [Android](https://www.xamarin.com/getting-started/android).

Microsoft’s purchase of Xamarin introduced many exciting changes. The announcements at Microsoft’s Build conference and [Xamarin Evolve](https://blog.xamarin.com/xamarin-evolve-2016-recap/) can give you guidance on Xamarin’s new direction. Xamarin also released [videos of the sessions](https://evolve.xamarin.com/#sessions) from the recent Evolve Conference that provide more information on working with Xamarin and the future direction of the product.

Do you think you’ll try Xamarin when building apps? If you have any questions or comments about this tutorial, please feel free to post in the comments section below.
