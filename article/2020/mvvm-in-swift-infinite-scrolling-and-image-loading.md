> * 原文地址：[MVVM in Swift: Infinite Scrolling and Image Loading](https://medium.com/better-programming/mvvm-in-swift-infinite-scrolling-and-image-loading-d47780b06e23)
> * 原文作者：[Zafar Ivaev](https://medium.com/@z.ivaev)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/mvvm-in-swift-infinite-scrolling-and-image-loading.md](https://github.com/xitu/gold-miner/blob/master/article/2020/mvvm-in-swift-infinite-scrolling-and-image-loading.md)
> * 译者：
> * 校对者：

# MVVM in Swift: Infinite Scrolling and Image Loading

![Photo by [Julian O'hayon](https://unsplash.com/@anckor?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/6400/0*VKT7xUSB-F86d8-H)

In this article, we’ll explore a complete reactive MVVM implementation based on the sample app that fetches photos from the [Unsplash API](https://unsplash.com/developers) and loads them in an asynchronous manner.

We’ll cover how to implement infinite scrolling, image caching, and doing navigation just right. We’ll also learn how to deal with some lower-level features in accordance to the overall app architecture, as MVVM is responsible only for the presentation layer.

The source code of the project is available at the bottom of the article.

Without further ado, let’s get started.

## Quick Setup

First, in order for our app to function the way we want, we need to obtain a free Unsplash API key:
[**Unsplash Image API | Free HD Photo API**
**Create with the largest collection of high-quality images that are free to use. Trusted by Trello, Medium, and…**unsplash.com](https://unsplash.com/developers)

Paste it into the the `APIKeys.swift` file inside the `Core Layer/Network/API Keys` directory:

```Swift
import Foundation

struct APIKeys {
    static let unsplash = "YOUR UNSPLASH API KEY"
}
```

Now we’re ready to explore the project.

## Let’s Start

Our project is divided into four layers (folders):

* **Application Layer:** Contains the `AppDelegate.swift` file and `AppCoordinator`, which is responsible for setting up the initial view controller of our app (you’ll learn more about it soon in this article)
* **Presentation Layer:** Contains view controllers, view models, and their coordinators. It has two scenes: `Photos` (displays Unsplash photos in a `UICollectionView`) and `PhotoDetail` (shows a photo that the user selects on the `Photos` scene).
* **Business Logic Layer:** Consists of a model and services. The `UnsplashPhoto` struct acts as a model and represents a particular photo we retrieve from the API. We use services to implement a certain business logic — e.g., fetching a list of Unsplash photos and loading data from the internet.
* **Core Layer:** Defines all of the settings we need for our Business Logic Layer to function and other small utilities. For example, it contains base URLs, API keys, and a network client.

![](https://cdn-images-1.medium.com/max/2000/1*b7fL11UWBMkqkhhzYsUsDw.png)

## Using Coordinators

I’ve chosen to use the Coordinator design pattern because MVVM doesn’t cover navigation inside the app. Though it’s relatively simple and you could catch the idea of it reading this article, feel free to learn about it [here](https://medium.com/better-programming/leverage-the-coordinator-design-pattern-in-swift-5-cd5bb9e78e12).

We provide the base `Coordinator` protocol, which `PhotosCoordinator` and `PhotoDetailCoordinator` will conform to:

```Swift
protocol Coordinator: class {
    func start()
    func coordinate(to coordinator: Coordinator)
}

extension Coordinator {
    func coordinate(to coordinator: Coordinator) {
        coordinator.start()
    }
}
```

The `start()` method is responsible for creating the current view controller and its dependencies, while the `coordinate(to)` is run when we want to navigate to another view controller, which, in its order, triggers the `start()` method of that view controller.

Now we can set up the initial flow of our app. We define the `AppCoordinator`, which has a dependency on the `UIWindow` property that `AppDelegate` provides:

```Swift
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        appCoordinator = AppCoordinator(window: window!)
        appCoordinator?.start()
        return true
    }

}
```

```Swift
import UIKit

class AppCoordinator: Coordinator {
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let navigationController = UINavigationController()
        if #available(iOS 13.0, *) {
            navigationController.overrideUserInterfaceStyle = .light
        }
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        let photosCoordinator = PhotosCoordinatorImplementation(navigationController: navigationController)
        coordinate(to: photosCoordinator)
    }
}
```

We can see that inside the `start()` method of the `AppCoordinator`, we coordinate to the `PhotosCoordinator`, which creates the initial scene of our app: `Photos`.

Let’s explore its implementation.

## The ‘Photos’ Scene

The `PhotosCoordinator` constructs the `PhotosViewController` and `PhotosViewModel`, as follows:

```Swift
import UIKit

protocol PhotosCoordinator: class {
    func pushToPhotoDetail(with photoId: String)
}

class PhotosCoordinatorImplementation: Coordinator {
    unowned let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let photosViewController = PhotosViewController()
        let photosViewModel = PhotosViewModelImplementation(
            photosService: UnsplashPhotosServiceImplementation(),
            photoLoadingService: DataLoadingServiceImplementation(),
            dataToImageService: DataToImageConversionServiceImplementation(),
            coordinator: self
        )
        photosViewController.viewModel = photosViewModel
        
        navigationController
            .pushViewController(photosViewController, animated: true)
    }
}

extension PhotosCoordinatorImplementation: PhotosCoordinator {
    
    func pushToPhotoDetail(with photoId: String) {
        let photoDetailCoordinator = PhotoDetailCoordinatorImplementation(
            navigationController: navigationController,
            photoId: photoId
        )
        
        coordinate(to: photoDetailCoordinator)
    }
}
```

We provide three dependencies for the `PhotosViewModel`:

* `UnsplashPhotosService`: Fetches an array of `UnsplashPhoto` models
* `DataLoadingService`: Loads and returns `Data` based on the URL provided
* `DataToImageService`: Returns a `UIImage` based on the provided `Data`

This is how our screen looks like:

![](https://cdn-images-1.medium.com/max/2680/1*JmScSaJIuhw1as8CY_p2Hw.png)

Let’s explore the view model and view controller implementations in detail (we’ll start with the view model because it is UI-independent and has clear input/output distinctions, so the view controller’s code will make more sense after this).

#### ‘PhotosViewModel’

```Swift
import RxSwift
import RxCocoa

/// View model interface that is visible to the PhotosViewController
protocol PhotosViewModel: class {
    // Input
    var viewDidLoad: PublishRelay<Void>
    { get }
    var willDisplayCellAtIndex: PublishRelay<Int>
    { get }
    var didEndDisplayingCellAtIndex: PublishRelay<Int>
    { get }
    var didChoosePhotoWithId: PublishRelay<String>
    { get }
    var didScrollToTheBottom: PublishRelay<Void>
    { get }
    
    // Output
    var isLoadingFirstPage: BehaviorRelay<Bool>
    { get }
    var isLoadingAdditionalPhotos: BehaviorRelay<Bool>
    { get }
    var unsplashPhotos: BehaviorRelay<[UnsplashPhoto]>
    { get }
    var imageRetrievedSuccess: PublishRelay<(UIImage, Int)>
    { get }
    var imageRetrievedError: PublishRelay<Int>
    { get }
}

final class PhotosViewModelImplementation: PhotosViewModel {
    
    // MARK: - Private Properties
    private let photosService: UnsplashPhotosService
    private let photoLoadingService: DataLoadingService
    private let dataToImageService: DataToImageConversionService
    private let coordinator: PhotosCoordinator
    
    private let disposeBag = DisposeBag()
    private let pageNumber = BehaviorRelay<Int>(value: 1)
    lazy var pageNumberObs = pageNumber.asObservable()
    
    // MARK: - Input
    let viewDidLoad
        = PublishRelay<Void>()
    let didChoosePhotoWithId
        = PublishRelay<String>()
    let willDisplayCellAtIndex
        = PublishRelay<Int>()
    let didEndDisplayingCellAtIndex
        = PublishRelay<Int>()
    let didScrollToTheBottom
        = PublishRelay<Void>()
    
    // MARK: - Output
    let isLoadingFirstPage
        = BehaviorRelay<Bool>(value: false)
    let isLoadingAdditionalPhotos
        = BehaviorRelay<Bool>(value: false)
    let unsplashPhotos
        = BehaviorRelay<[UnsplashPhoto]>(value: [])
    let imageRetrievedSuccess
        = PublishRelay<(UIImage, Int)>()
    let imageRetrievedError
        = PublishRelay<Int>()
    
    // MARK: - Initialization
    init(photosService: UnsplashPhotosService,
         photoLoadingService: DataLoadingService,
         dataToImageService: DataToImageConversionService,
         coordinator: PhotosCoordinator) {
        
        self.photosService = photosService
        self.photoLoadingService = photoLoadingService
        self.dataToImageService = dataToImageService
        self.coordinator = coordinator
        
        bindOnViewDidLoad()
        bindOnWillDisplayCell()
        bindOnDidEndDisplayingCell()
        bindOnDidScrollToBottom()
        bindPageNumber()
        
        bindOnDidChoosePhoto()
    }
    
    // MARK: - Bindings
    private func bindOnViewDidLoad() {
        viewDidLoad
            .observeOn(MainScheduler.instance)
            .do(onNext: { [unowned self] _ in
                self.getPhotos()
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func bindOnWillDisplayCell() {
        willDisplayCellAtIndex
            .customDebug(identifier: "willDisplayCellAtIndex")
            .filter({ [unowned self] index in
                self.unsplashPhotos.value.indices.contains(index)
            })
            .map { [unowned self] index in
                (index, self.unsplashPhotos.value[index])
            }
            .compactMap({ [weak self] (index, photo) in
                guard let urlString = photo.urls?.regular else {
                    DispatchQueue.main.async {
                        self?.imageRetrievedError.accept(index)
                    }
                    return nil
                }
                return (index, urlString)
            })
            .flatMap({ [unowned self] (index, urlString) in
                self.photoLoadingService
                    .loadData(at: index, for: urlString)
                    .observeOn(
                        ConcurrentDispatchQueueScheduler(qos: .background)
                    )
                    .concatMap { (data, error) in
                        Observable.of((index, data, error))
                    }
            })
            .subscribe(onNext: { [weak self] (index, data, error) in
                guard let self = self else { return }
                
                guard let imageData = data,
                    let image = self.dataToImageService
                        .getImage(from: imageData) else {
                    self.imageRetrievedError.accept(index)
                    return
                }
            
                 self.imageRetrievedSuccess
                    .accept((image, index))
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOnDidEndDisplayingCell() {
        didEndDisplayingCellAtIndex
            .subscribe(onNext: { [weak self] (index) in
                guard let self = self else { return }
                
                self.photoLoadingService.stopLoading(at: index)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOnDidScrollToBottom() {
        didScrollToTheBottom
            .flatMap({ [unowned self] _ -> Observable<Int> in
                let newPageNumber = self.pageNumber.value + 1
                return Observable.just(newPageNumber)
            })
            .bind(to: pageNumber)
            .disposed(by: disposeBag)
    }
    
    private func bindPageNumber() {
        pageNumber
            .subscribe(onNext: { [weak self] _ in
                self?.getPhotos()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOnDidChoosePhoto() {
        didChoosePhotoWithId
            .subscribe(onNext: { [unowned self] (id) in
                self.coordinator.pushToPhotoDetail(with: id)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Service Methods
    private func getPhotos() {
        if pageNumber.value == 1 {
            isLoadingFirstPage.accept(true)
        } else {
            isLoadingAdditionalPhotos.accept(true)
        }
        
        photosService.getPhotos(pageNumber: pageNumber.value, perPage: 30)
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }

                if self.pageNumber.value == 1 {
                    self.isLoadingFirstPage.accept(false)
                } else {
                    self.isLoadingAdditionalPhotos
                        .accept(false)
                }
            })
            .filter { $0.1 == nil && $0.0 != nil }
            .map { return $0.0! }
            .flatMap({ [unowned self] (unsplashPhotos) -> Observable<[UnsplashPhoto]> in
                
                var photos: [UnsplashPhoto] = []
                
                // Add previously fetched photos to the array
                let existingPhotos = self.unsplashPhotos.value
                if !existingPhotos.isEmpty {
                    photos.append(contentsOf: existingPhotos)
                }
                
                // Add newly fetched photos to the array
                photos.append(contentsOf: unsplashPhotos)
                
                return Observable.just(photos)
            })
            .bind(to: unsplashPhotos)
            .disposed(by: disposeBag)
    }
}
```

We define the `PhotosViewModel` protocol and its implementation in this file. The protocol describes input (events received from the view controller) and output (results of the view model’s work that’s used by the view controller to drive its UI). Here’s how we react to input and provide output inside the `PhotosViewModelImplementation`:

* `PhotosViewController` loads and sends a value on to the `viewDidLoad` relay of the view model
* The `getPhotos()` method of the view model is fired
* An array of `UnsplashPhoto`s is retrieved and sent onto the `unsplashPhotos` relay

```Swift
private func bindOnViewDidLoad() {
    viewDidLoad
        .observeOn(MainScheduler.instance)
        .do(onNext: { [unowned self] _ in
            self.getPhotos()
        })
        .subscribe()
        .disposed(by: disposeBag)
}
```

```Swift
private func getPhotos() {
    if pageNumber.value == 1 {
        isLoadingFirstPage.accept(true)
    } else {
        isLoadingAdditionalPhotos.accept(true)
    }

    photosService.getPhotos(pageNumber: pageNumber.value, perPage: 30)
        .do(onNext: { [weak self] _ in
            guard let self = self else { return }

            if self.pageNumber.value == 1 {
                self.isLoadingFirstPage.accept(false)
            } else {
                self.isLoadingAdditionalPhotos
                    .accept(false)
            }
        })
        .filter { $0.1 == nil && $0.0 != nil }
        .map { return $0.0! }
        .flatMap({ [unowned self] (unsplashPhotos) -> Observable<[UnsplashPhoto]> in

            var photos: [UnsplashPhoto] = []

            // Add previously fetched photos to the array
            let existingPhotos = self.unsplashPhotos.value
            if !existingPhotos.isEmpty {
                photos.append(contentsOf: existingPhotos)
            }

            // Add newly fetched photos to the array
            photos.append(contentsOf: unsplashPhotos)

            return Observable.just(photos)
        })
        .bind(to: unsplashPhotos)
        .disposed(by: disposeBag)
}
```

Notice that we also send relevant `Bool` events onto the `isLoadingFirstPage` and `isLoadingAdditionalPhotos` relays, which our view controller uses to show/hide a loading indicator (more about this in the view controller part).

* `PhotosViewController` uses the `unsplashPhotos` property to drive the `UICollectionView` and to display a number of cells corresponding to the count of models received
* `PhotosViewController` sends values onto the `willDisplayCellAtIndex` property of the view model, which triggers the loading of data
* When the image is loaded, it’s sent onto the `imageRetrievedSuccess` relay, which `PhotosViewController` uses to display the image in the corresponding cell

```Swift
private func bindOnWillDisplayCell() {
    willDisplayCellAtIndex
        .customDebug(identifier: "willDisplayCellAtIndex")
        .filter({ [unowned self] index in
            self.unsplashPhotos.value.indices.contains(index)
        })
        .map { [unowned self] index in
            (index, self.unsplashPhotos.value[index])
        }
        .compactMap({ [weak self] (index, photo) in
            guard let urlString = photo.urls?.regular else {
                DispatchQueue.main.async {
                    self?.imageRetrievedError.accept(index)
                }
                return nil
            }
            return (index, urlString)
        })
        .flatMap({ [unowned self] (index, urlString) in
            self.photoLoadingService
                .loadData(at: index, for: urlString)
                .observeOn(
                    ConcurrentDispatchQueueScheduler(qos: .background)
                )
                .concatMap { (data, error) in
                    Observable.of((index, data, error))
                }
        })
        .subscribe(onNext: { [weak self] (index, data, error) in
            guard let self = self else { return }

            guard let imageData = data,
                let image = self.dataToImageService
                    .getImage(from: imageData) else {
                self.imageRetrievedError.accept(index)
                return
            }

             self.imageRetrievedSuccess
                .accept((image, index))
        })
        .disposed(by: disposeBag)
}
```

First, we check if the `unsplashPhotos` property contains the index of the cell that’s being displayed. Then, we obtain the URL of the image and fire the `DataLoadingService`’s `loadData(at:)` method and observe for the result in the background so our main thread isn’t blocked.

When we receive `Data`, we call the `DataToImageService`’s `getImage(from:)` method to obtain a `UIImage` object. Finally, we either send an event onto the `imageRetrievedError` property (if we couldn’t obtain an image) or to the `imageRetrievedSuccess` relay.

To optimize memory usage, we also want to cancel a data-loading task if the cell for which it was intended for disappears from the screen. For this purpose, we provide the `didEndDisplayingCellAtIndex` relay, which is used as follows:

* The view controller notices that a certain cell disappeared while scrolling the `UICollectionView` and sends its index onto the `didEndDisplayingCellAtIndex` property
* The view model calls the `DataLoadingService`’s `stopLoading(at:)` method to cancel the task in progress

```Swift
private func bindOnDidEndDisplayingCell() {
    didEndDisplayingCellAtIndex
        .subscribe(onNext: { [weak self] (index) in
            guard let self = self else { return }

            self.photoLoadingService.stopLoading(at: index)
        })
        .disposed(by: disposeBag)
}
```

The `DataLoadingService` keeps track of tasks in a dictionary and disposes ones we no longer need:

```Swift
import RxSwift

protocol DataLoadingService: class {
    func loadData(for urlString: String) -> Observable<(Data?, Error?)>
    func loadData(at index: Int,
                  for urlString: String) -> Observable<(Data?, Error?)>
    func stopLoading(at index: Int)
}

class DataLoadingServiceImplementation: DataLoadingService {
    private var tasks: [Int: Disposable] = [:]
    
    func loadData(at index: Int, for urlString: String) -> Observable<(Data?, Error?)> {
        return Observable.create { [weak self] observer in
            guard let url = URL(string: urlString) else {
                observer.onNext((nil, NetworkError.invalidURL))
                return Disposables.create()
            }
            
            let task = NetworkClient.getData(url)
                .subscribe(onNext: { (data, error) in
                    guard let data = data, error == nil else {
                        observer.onNext((nil, error))
                        return
                    }
                    
                    observer.onNext((data, nil))
                })
            self?.tasks[index] = task
            
            return Disposables.create {
                task.dispose()
            }
        }
    }
    
    func loadData(for urlString: String) -> Observable<(Data?, Error?)> {
         return Observable.create { observer in
            
            guard let url = URL(string: urlString) else {
                observer.onNext((nil, NetworkError.invalidURL))
                return Disposables.create()
            }
            
            let task = NetworkClient.getData(url)
                .subscribe(onNext: { (data, error) in
                    guard let data = data, error == nil else {
                        observer.onNext((nil, error))
                        return
                    }
                    
                    observer.onNext((data, nil))
                })
            
            return Disposables.create {
                task.dispose()
            }
        }
    }
    
    func stopLoading(at index: Int) {
        print("Cancel task at index: \(index)")
        tasks[index]?.dispose()
    }
}

```

We also want to navigate to another screen and display a selected image and its description in it, so we define the `didChoosePhotoWithId` relay. When a value is sent onto the relay, we trigger `PhotosCoordinator`’s `pushToPhotoDetail(with:)` method:

```Swift
private func bindOnDidChoosePhoto() {
    didChoosePhotoWithId
        .subscribe(onNext: { [unowned self] (id) in
            self.coordinator.pushToPhotoDetail(with: id)
        })
        .disposed(by: disposeBag)
}
```

Now the final feature remains — infinite scrolling. It allows us to load `UnsplashPhoto`s by pages, saving API resources and optimizing performance. So our goal is to load an additional array of `UnsplashPhoto`s and append it to the existing array. We do it by defining the `didScrollToTheBottom` relay inside the view model and using it like this:

* The view controller notices that the user scrolled till the last cell available and sends a `Void` event onto the `didScrollToTheBottom` relay
* The view model reacts by incrementing the `pageNumber` and triggering an additional data fetching

```Swift
private func bindOnDidScrollToBottom() {
    didScrollToTheBottom
        .flatMap({ [unowned self] _ -> Observable<Int> in
            let newPageNumber = self.pageNumber.value + 1
            return Observable.just(newPageNumber)
        })
        .bind(to: pageNumber)
        .disposed(by: disposeBag)
}

private func bindPageNumber() {
    pageNumber
        .subscribe(onNext: { [weak self] _ in
            self?.getPhotos()
        })
        .disposed(by: disposeBag)
}
```

As a result, we have the pagination feature implemented:

![](https://cdn-images-1.medium.com/max/2000/1*8byt48cw_FgHp8LrABYjiA.gif)

#### ‘PhotosViewController’

```Swift
import UIKit

import RxSwift
import RxCocoa

class PhotosViewController: UIViewController {
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindCollectionView()
        bindLoadingState()
        bindBottomActivityIndicator()
        
        viewModel.viewDidLoad.accept(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        setupNavigationItem()
    }
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    var viewModel: PhotosViewModel!
    private var cachedImages: [Int: UIImage] = [:]
    
    lazy var photosCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.backgroundColor = .white
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var bottomConstraint: NSLayoutConstraint?
    
    lazy var bottomActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
}

// MARK: - Binding
extension PhotosViewController {
    private func bindCollectionView() {
        /// Bind unsplash photos to the collection view items
        viewModel.unsplashPhotos
            .bind(to: photosCollectionView.rx.items(
                cellIdentifier: PhotoCell.reuseIdentifier,
                cellType: PhotoCell.self)) { _, _, _ in }
            .disposed(by: disposeBag)
        
        /// Prepare for cell to be displayed. Launch photo loading operation if no cached image is found
        photosCollectionView.rx.willDisplayCell
            .filter { $0.cell.isKind(of: PhotoCell.self) }
            .map { ($0.cell as! PhotoCell, $0.at.item)}
            .do(onNext: { (cell, index) in
                cell.imageView.image = nil
            })
            .subscribe(onNext: { [weak self] (cell, index) in
                if let cachedImage = self?.cachedImages[index] {
                    print("Using cached image for: \(index)")
                    cell.imageView.image = cachedImage
                } else {
                    cell.activityIndicator.startAnimating()
                    self?.viewModel
                        .willDisplayCellAtIndex
                        .accept(index)
                }
            })
            .disposed(by: disposeBag)
        
        /// On image retrival, 1)stop activity indicator, 2) animate the cell, 3) assign the image, and 4) add it to cached images
        viewModel.imageRetrievedSuccess
            .customDebug(identifier: "imageRetrievedSuccess")
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] (image, index) in
                if let cell = self?.photosCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? PhotoCell {
                    
                    // 1
                    cell.activityIndicator.stopAnimating()
                    
                    // 2
                    cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    UIView.animate(withDuration: 0.25) {
                        cell.transform = .identity
                    }
                    
                    // 3
                    cell.imageView.image = image
                    
                    // 4
                    self?.cachedImages[index] = image
                }
            })
            .disposed(by: disposeBag)
        
        /// On image retrieval error, stop activity indicator, and assign image to **nil**
        viewModel.imageRetrievedError
            .customDebug(identifier: "imageRetrievedError")
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] (index) in
                if let cell = self?.photosCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? PhotoCell {
                    cell.activityIndicator.stopAnimating()
                    cell.imageView.image = nil
                }
            })
            .disposed(by: disposeBag)
        
        /// Cancelling image loading operation for a cell that disappeared
        photosCollectionView.rx.didEndDisplayingCell
            .map { $0.1 }
            .map { $0.item }
            .bind(to: viewModel.didEndDisplayingCellAtIndex)
            .disposed(by: disposeBag)
        
        photosCollectionView.rx.modelSelected(UnsplashPhoto.self)
            .compactMap { $0.id }
            .bind(to: viewModel.didChoosePhotoWithId)
            .disposed(by: disposeBag)
        
        /// Infinite scrolling
        photosCollectionView.rx.willDisplayCell
            .flatMap({ (_, indexPath) -> Observable<(section: Int, row: Int)> in
                return Observable.of((indexPath.section, indexPath.row))
            })
            .filter { (section, row) in
                let numberOfSections = self.photosCollectionView.numberOfSections
                let numberOfItems = self.photosCollectionView.numberOfItems(inSection: section)
                
                return section == numberOfSections - 1
                    && row == numberOfItems - 1
            }
            .map { _ in () }
            .bind(to: viewModel.didScrollToTheBottom)
            .disposed(by: disposeBag)
    }
    
    private func bindLoadingState() {
        viewModel.isLoadingFirstPage
            .observeOn(MainScheduler.instance)
            .map({ (isLoading) in
                return isLoading ? "Fetching..." : "Unsplash Photos"
            })
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
    }
    
    private func bindBottomActivityIndicator() {
        viewModel.isLoadingAdditionalPhotos
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] isLoading in
                self?.updateConstraintForMode(loadingMorePhotos: isLoading)
            })
            .bind(to: bottomActivityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}

// MARK: - UI Setup
extension PhotosViewController {
    private func setupUI() {
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        self.view.backgroundColor = .white
        self.view.addSubview(photosCollectionView)
        self.view.addSubview(bottomActivityIndicator)
        
        bottomConstraint = photosCollectionView.bottomAnchor
            .constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        
        NSLayoutConstraint.activate([
            photosCollectionView.leftAnchor
                .constraint(equalTo: self.view.leftAnchor),
            photosCollectionView.topAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            photosCollectionView.rightAnchor
                .constraint(equalTo: self.view.rightAnchor),
            bottomConstraint!
        ])
        
        NSLayoutConstraint.activate([
            bottomActivityIndicator.centerXAnchor
                .constraint(equalTo: self.view.centerXAnchor),
            bottomActivityIndicator.bottomAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            bottomActivityIndicator.widthAnchor
                .constraint(equalToConstant: 44),
            bottomActivityIndicator.heightAnchor
                .constraint(equalToConstant: 44)
        ])
    }
    
    /// Changes photoCollectionView's bottom constraint with a subtle animation
    private func updateConstraintForMode(loadingMorePhotos: Bool) {
        self.bottomConstraint?.constant = loadingMorePhotos ? -20 : 0
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupNavigationItem() {
        self.navigationItem.title = "Unsplash Photos"
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = Dimensions.photosItemSize
        let numberOfCellsInRow = floor(Dimensions.screenWidth / Dimensions.photosItemSize.width)
        let inset = (Dimensions.screenWidth - (numberOfCellsInRow * Dimensions.photosItemSize.width)) / (numberOfCellsInRow + 1)
        layout.sectionInset = .init(top: inset,
                                    left: inset,
                                    bottom: inset,
                                    right: inset)
        return layout
    }
}
```

We won’t cover how the UI is created, as it’s not the focus of this article. If you wish to learn about programmatic `UICollectionView` implementation, visit [this](https://medium.com/cleansoftware/quickly-implement-tableview-collectionview-programmatically-df12da694af9) article. We’ll focus on two key responsibilities here: providing input for the view model and hooking up the output from the view model to our UI.

We create the `cachedImages` property to save loaded images in a dictionary so we can later save resources by using a cached image in a cell, instead of firing a data-loading operation again.

This is how we bind the view model’s `unsplashPhotos` property to the `photosCollectionView`:

```Swift
// MARK: - Binding
extension PhotosViewController {
    private func bindCollectionView() {
        /// Bind unsplash photos to the collection view items
        viewModel.unsplashPhotos
            .bind(to: photosCollectionView.rx.items(
                cellIdentifier: PhotoCell.reuseIdentifier,
                cellType: PhotoCell.self)) { _, _, _ in }
            .disposed(by: disposeBag)
    ....
```

Send the value onto the `willDisplayCellAtIndex` to trigger data loading (if no cached image is found at that index):

```Swift
photosCollectionView.rx.willDisplayCell
    .filter { $0.cell.isKind(of: PhotoCell.self) }
    .map { ($0.cell as! PhotoCell, $0.at.item)}
    .do(onNext: { (cell, index) in
        cell.imageView.image = nil
    })
    .subscribe(onNext: { [weak self] (cell, index) in
        if let cachedImage = self?.cachedImages[index] {
            print("Using cached image for: \(index)")
            cell.imageView.image = cachedImage
        } else {
            cell.activityIndicator.startAnimating()
            self?.viewModel
                .willDisplayCellAtIndex
                .accept(index)
        }
    })
    .disposed(by: disposeBag)
```

We also react to the view model’s `imageRetrievedSuccess` and `imageRetrievedError` events:

```Swift
/// On image retrival, 1)stop activity indicator, 2) animate the cell, 3) assign the image, and 4) add it to cached images
viewModel.imageRetrievedSuccess
    .customDebug(identifier: "imageRetrievedSuccess")
    .observeOn(MainScheduler.asyncInstance)
    .subscribe(onNext: { [weak self] (image, index) in
        if let cell = self?.photosCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? PhotoCell {

            // 1
            cell.activityIndicator.stopAnimating()

            // 2
            cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            UIView.animate(withDuration: 0.25) {
                cell.transform = .identity
            }

            // 3
            cell.imageView.image = image

            // 4
            self?.cachedImages[index] = image
        }
    })
    .disposed(by: disposeBag)

/// On image retrieval error, stop activity indicator, and assign image to **nil**
viewModel.imageRetrievedError
    .customDebug(identifier: "imageRetrievedError")
    .observeOn(MainScheduler.asyncInstance)
    .subscribe(onNext: { [weak self] (index) in
        if let cell = self?.photosCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? PhotoCell {
            cell.activityIndicator.stopAnimating()
            cell.imageView.image = nil
        }
    })
    .disposed(by: disposeBag)
```

We send a value onto the `didEndDisplayingCellAtIndex` relay of the view model when a particular cell disappears:

```Swift
/// Cancelling image loading operation for a cell that disappeared
photosCollectionView.rx.didEndDisplayingCell
    .map { $0.1 }
    .map { $0.item }
    .bind(to: viewModel.didEndDisplayingCellAtIndex)
    .disposed(by: disposeBag)
```

Using RxSwift’s `willDisplayCell` wrapper again, we determine if we reached the end of the list.

If so, we send a `Void` value onto the `didScrollToTheBottom` relay:

```Swift
/// Infinite scrolling
photosCollectionView.rx.willDisplayCell
    .flatMap({ (_, indexPath) -> Observable<(section: Int, row: Int)> in
        return Observable.of((indexPath.section, indexPath.row))
    })
    .filter { (section, row) in
        let numberOfSections = self.photosCollectionView.numberOfSections
        let numberOfItems = self.photosCollectionView.numberOfItems(inSection: section)

        return section == numberOfSections - 1
            && row == numberOfItems - 1
    }
    .map { _ in () }
    .bind(to: viewModel.didScrollToTheBottom)
    .disposed(by: disposeBag)
```

We react to the view model’s `isLoadingFirstPage` and `isLoadingAdditionalPhotos` by changing the title on the `navigationItem` and showing/hiding a loading indicator in each `PhotoCell`:

```Swift
private func bindLoadingState() {
    viewModel.isLoadingFirstPage
        .observeOn(MainScheduler.instance)
        .map({ (isLoading) in
            return isLoading ? "Fetching..." : "Unsplash Photos"
        })
        .bind(to: navigationItem.rx.title)
        .disposed(by: disposeBag)
}

private func bindBottomActivityIndicator() {
    viewModel.isLoadingAdditionalPhotos
        .observeOn(MainScheduler.instance)
        .do(onNext: { [weak self] isLoading in
            self?.updateConstraintForMode(loadingMorePhotos: isLoading)
        })
        .bind(to: bottomActivityIndicator.rx.isAnimating)
        .disposed(by: disposeBag)
}
```

Finally, when we tap on a particular cell, we grab the selected `UnsplashPhoto`’s `id` and send an `Int` value to the `didChoosePhotoWithId` relay:

```Swift
photosCollectionView.rx.modelSelected(UnsplashPhoto.self)
    .compactMap { $0.id }
    .bind(to: viewModel.didChoosePhotoWithId)
    .disposed(by: disposeBag)
```

Great! We’ve covered the `Photos` scene, let’s now move on to the final one — `PhotoDetail`.

## ‘PhotoDetail’

When we coordinate to this scene from `Photos`, the `PhotoDetailCoordinator` constructs it like this:

```Swift
import UIKit

protocol PhotoDetailCoordinator: class {}

class PhotoDetailCoordinatorImplementation: Coordinator {
    unowned let navigationController: UINavigationController
    let photoId: String
    
    init(navigationController: UINavigationController, photoId: String) {
        self.navigationController = navigationController
        self.photoId = photoId
    }
    
    func start() {
        let photoDetailViewController = PhotoDetailViewController()
        let photoDetailViewModel = PhotoDetailViewModelImplementation(
            photosService: UnsplashPhotosServiceImplementation(),
            photoLoadingService: DataLoadingServiceImplementation(),
            dataToImageService: DataToImageConversionServiceImplementation(),
            coordinator: self,
            photoId: photoId
        )
        photoDetailViewController.viewModel = photoDetailViewModel
        
        navigationController.pushViewController(photoDetailViewController,
                                                animated: true)
    }
}

extension PhotoDetailCoordinatorImplementation: PhotoDetailCoordinator {}
```

We can see we have the `photoId` property that we get from a previous coordinator and assign it to the `photoId` property of the `PhotoDetailViewModel`.

#### ‘PhotoDetailViewModel’

Similarly to how we did it in the `PhotosViewModel`, here we use the `viewDidLoad` property as an input and the `isLoading`, `imageRetrievedError`, `imageRetrievedSuccess`, and `description` properties as outputs:

```Swift
import RxSwift
import RxRelay

/// View model interface that is visible to the PhotoDetailViewController
protocol PhotoDetailViewModel: class {
    // Input
    var viewDidLoad: PublishRelay<Void> { get }
    
    // Output
    var isLoading: BehaviorRelay<Bool> { get }
    var imageRetrievedError: PublishRelay<Void> { get }
    var imageRetrievedSuccess: PublishRelay<UIImage> { get }
    var description: PublishRelay<String> { get }
}

final class PhotoDetailViewModelImplementation: PhotoDetailViewModel {
    
    // MARK: - Input
    let viewDidLoad = PublishRelay<Void>()
    
    // MARK: - Output
    let isLoading = BehaviorRelay<Bool>(value: false)
    let imageRetrievedError = PublishRelay<Void>()
    let imageRetrievedSuccess = PublishRelay<UIImage>()
    let description = PublishRelay<String>()
    
    // MARK: - Private Properties
    private let photosService: UnsplashPhotosService
    private let photoLoadingService: DataLoadingService
    private let dataToImageService: DataToImageConversionService
    private let coordinator: PhotoDetailCoordinator
    
    private let disposeBag = DisposeBag()
    private let unsplashPhoto = PublishRelay<UnsplashPhoto>()
    private let photoId: String
    
    // MARK: - Initialization
    init(photosService: UnsplashPhotosService,
         photoLoadingService: DataLoadingService,
         dataToImageService: DataToImageConversionService,
         coordinator: PhotoDetailCoordinator,
         photoId: String) {
        
        self.photosService = photosService
        self.photoLoadingService = photoLoadingService
        self.dataToImageService = dataToImageService
        self.coordinator = coordinator
        
        self.photoId = photoId
        
        bindOnViewDidLoad()
        bindOnPhotoRetrieval()
    }
    
    private func bindOnViewDidLoad() {
        viewDidLoad
            .do(onNext: { [unowned self] _ in
                self.getPhoto()
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func bindOnPhotoRetrieval() {
        // Bind to description
        unsplashPhoto
            .flatMap({ (unsplashPhoto) -> Observable<String?> in
                var description: String?
                
                if let photoDescription = unsplashPhoto.description {
                    description = photoDescription
                } else if let alternativeDescription = unsplashPhoto.altDescription {
                    description = alternativeDescription
                }
                
                return Observable.just(description)
            })
            .compactMap { $0 }
            .bind(to: description)
            .disposed(by: disposeBag)
        
        // Bind to image
        unsplashPhoto
            .flatMap { [weak self] (photo) -> Observable<(Data?, Error?)> in
                guard let self = self else { return .empty() }
                
                if let photoURL = photo.urls?.regular {
                    return self.photoLoadingService
                        .loadData(for: photoURL)
                        .observeOn(
                            ConcurrentDispatchQueueScheduler(qos: .background)
                    )
                } else {
                    self.imageRetrievedError.accept(())
                    return Observable.of((nil, NetworkError.decodingFailed))
                }
            }
            .do(onNext: { [weak self] _ in
                self?.isLoading.accept(false)
            })
            .map({ [weak self] (data, error) -> (UIImage?, Error?) in
                if let imageData = data,
                    let image = self?.dataToImageService.getImage(from: imageData) {
                    return (image, nil)
                } else {
                    self?.imageRetrievedError.accept(())
                    return (nil, NetworkError.decodingFailed)
                }
            })
            .compactMap { $0.0 }
            .bind(to: imageRetrievedSuccess)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Service Methods
    private func getPhoto() {
        isLoading.accept(true)
        
        photosService.getPhoto(id: photoId)
            .compactMap({ [weak self] (unsplashPhoto, error) in
                guard let photo = unsplashPhoto, error == nil else {
                    self?.imageRetrievedError.accept(())
                    return nil
                }
                
                return photo
            })
            .bind(to: unsplashPhoto)
            .disposed(by: disposeBag)
    }
    
}
```

As before, when we receive a `Void` value on `viewDidLoad`, we fire the `getPhoto()` method, which binds the result to the `unsplashPhoto` property:

```Swift
private func getPhoto() {
    isLoading.accept(true)

    photosService.getPhoto(id: photoId)
        .compactMap({ [weak self] (unsplashPhoto, error) in
            guard let photo = unsplashPhoto, error == nil else {
                self?.imageRetrievedError.accept(())
                return nil
            }

            return photo
        })
        .bind(to: unsplashPhoto)
        .disposed(by: disposeBag)
}
```

As a result, it triggers the loading of image data and its description:

```Swift
private func bindOnPhotoRetrieval() {
    // Bind to description
    unsplashPhoto
        .flatMap({ (unsplashPhoto) -> Observable<String?> in
            var description: String?

            if let photoDescription = unsplashPhoto.description {
                description = photoDescription
            } else if let alternativeDescription = unsplashPhoto.altDescription {
                description = alternativeDescription
            }

            return Observable.just(description)
        })
        .compactMap { $0 }
        .bind(to: description)
        .disposed(by: disposeBag)

    // Bind to image
    unsplashPhoto
        .flatMap { [weak self] (photo) -> Observable<(Data?, Error?)> in
            guard let self = self else { return .empty() }

            if let photoURL = photo.urls?.regular {
                return self.photoLoadingService
                    .loadData(for: photoURL)
                    .observeOn(
                        ConcurrentDispatchQueueScheduler(qos: .background)
                )
            } else {
                self.imageRetrievedError.accept(())
                return Observable.of((nil, NetworkError.decodingFailed))
            }
        }
        .do(onNext: { [weak self] _ in
            self?.isLoading.accept(false)
        })
        .map({ [weak self] (data, error) -> (UIImage?, Error?) in
            if let imageData = data,
                let image = self?.dataToImageService.getImage(from: imageData) {
                return (image, nil)
            } else {
                self?.imageRetrievedError.accept(())
                return (nil, NetworkError.decodingFailed)
            }
        })
        .compactMap { $0.0 }
        .bind(to: imageRetrievedSuccess)
        .disposed(by: disposeBag)
}
```

#### ‘PhotoDetailViewController’

Here we similarly send events on to the `viewDidLoad` property and bind `imageRetrievedSuccess`, `imageRetrievedError`, `description`, and `isLoading` to the UI:

```Swift
import UIKit
import RxSwift

class PhotoDetailViewController: UIViewController {
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindImageView()
        bindDescriptionLabel()
        bindActivityIndicator()
        
        viewModel.viewDidLoad.accept(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        setupNavigationItem()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        activityIndicator.center = self.photoImageView.center
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    var viewModel: PhotoDetailViewModel!
    
    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView
            .translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        return indicator
    }()
}

// MARK: - Binding
extension PhotoDetailViewController {
    func bindImageView() {
        viewModel.imageRetrievedSuccess
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] _ in
                self?.photoImageView.alpha = 0
                UIView.animate(withDuration: 0.25) {
                    self?.photoImageView.alpha = 1.0
                }
            })
            .bind(to: photoImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.imageRetrievedError
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] _ in
                self?.photoImageView.alpha = 0
                UIView.animate(withDuration: 0.25) {
                    self?.photoImageView.alpha = 1.0
                    self?.photoImageView.backgroundColor = .black
                }
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func bindDescriptionLabel() {
        viewModel.description
            .observeOn(MainScheduler.instance)
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func bindActivityIndicator() {
        viewModel.isLoading
            .observeOn(MainScheduler.instance)
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}

// MARK: - UI Setup
extension PhotoDetailViewController {
    private func setupUI() {
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        self.view.backgroundColor = .white
        
        self.view.addSubview(photoImageView)
        self.view.addSubview(descriptionLabel)
        photoImageView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            photoImageView.leftAnchor
                .constraint(equalTo: self.view.leftAnchor),
            photoImageView.topAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            photoImageView.rightAnchor
                .constraint(equalTo: self.view.rightAnchor),
            photoImageView.heightAnchor
                .constraint(equalToConstant: Dimensions.screenHeight * 0.3)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.leftAnchor
                .constraint(equalTo: self.view.leftAnchor,
                            constant: 20),
            descriptionLabel.topAnchor
                .constraint(equalTo: self.photoImageView.bottomAnchor,
                            constant: 20),
            descriptionLabel.rightAnchor
                .constraint(equalTo: self.view.rightAnchor,
                            constant: -20),
        ])
    }
    
    private func setupNavigationBar() {
           self.navigationController?.navigationBar.barTintColor = .white
           self.navigationController?.navigationBar.isTranslucent = false
       }
       
       private func setupNavigationItem() {
           self.navigationItem.title = "Photo Detail"
       }
}
```

As a result, we have this final workflow:

![](https://cdn-images-1.medium.com/max/2000/1*Eh1Sn4gGfe6U2BrtfxpKsw.gif)

We’ve implemented a fully functional app using a reactive MVVM architecture.

## Resources

The source code of the project is available on GitHub:
[**zafarivaev/MVVM-RxSwift**
**Reactive MVVM demo app fetching photos from Unsplash and displaying them in a UICollectionView. Showcases usage of the…**github.com](https://github.com/zafarivaev/MVVM-RxSwift)

---

## Wrapping Up

Want to learn more about design or architectural patterns? Feel free to check out my other relevant pieces:

* [“Implement the Facade Design Pattern in Swift 5](https://medium.com/better-programming/implement-the-facade-design-pattern-in-swift-dcc4325754ff)”
* [“Implement the Builder Design Pattern in Swift 5](https://medium.com/better-programming/implement-the-builder-design-pattern-in-swift-5-ff5bc6f2fc3d)”
* [“Implement the Strategy Design Pattern in Swift 5](https://medium.com/better-programming/implement-the-strategy-design-pattern-in-swift-5d9c3f221277)”
* [“Implement a VIPER Architecture in Swift 5](https://medium.com/better-programming/how-to-implement-viper-architecture-in-your-ios-app-rest-api-and-kingfisher-f494a0891c43)”

Thanks for reading!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
