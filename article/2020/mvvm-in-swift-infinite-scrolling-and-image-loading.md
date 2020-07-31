> * 原文地址：[MVVM in Swift: Infinite Scrolling and Image Loading](https://medium.com/better-programming/mvvm-in-swift-infinite-scrolling-and-image-loading-d47780b06e23)
> * 原文作者：[Zafar Ivaev](https://medium.com/@z.ivaev)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/mvvm-in-swift-infinite-scrolling-and-image-loading.md](https://github.com/xitu/gold-miner/blob/master/article/2020/mvvm-in-swift-infinite-scrolling-and-image-loading.md)
> * 译者：[chaingangway](https://github.com/chaingangway)
> * 校对者：[lsvih](https://github.com/lsvih)

# 在 Swift 中使用 MVVM 架构实现无限滚动和图片加载

![Photo by [Julian O'hayon](https://unsplash.com/@anckor?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/6400/0*VKT7xUSB-F86d8-H)

在本文中，我们将基于示例程序来探索一个完整的响应式 MVVM 架构实现，该示例程序的主要功能是从 [Unsplash API](https://unsplash.com/developers) 获取照片数据并以异步方式加载它们。

我们将介绍如何实现无限滚动，图片缓存以及导航功能。由于 MVVM 仅负责表示层，我们还将学习如何根据整体应用架构处理一些较低级别的功能。

本项目的源代码位于文章底部。

事不宜迟，我们开始吧。

## 快速设置

首先，为了使应用按我们想要的方式运行，我们需要申请一个免费的 Unsplash API 密钥：
[**Unsplash Image API | Free HD Photo API**](https://unsplash.com/developers)


将其粘贴到 `Core Layer/Network/API Keys` 目录下的 `APIKeys.swift` 文件中：

```Swift
import Foundation

struct APIKeys {
    static let unsplash = "YOUR UNSPLASH API KEY"
}
```

下面我们开始探索项目。

## 开始

我们的项目分为四层（文件夹）:

* **应用层：** 包含 `AppDelegate.swift` 文件和 `AppCoordinator`，它们负责设置应用程序初始的视图控制器（下文将详细说明）。
* **表示层：** 包含视图控制器，视图模型及其协调器。它有两个场景：`Photos` （在 `UICollectionView` 中显示 Unsplash 的图片）和 `PhotoDetail`（显示用户在 `Photos` 场景中选择的图片）。
* **业务逻辑层：** 由模型和服务组成。`UnsplashPhoto` 结构体充当模型，代表我们从 API 中获取的特定照片。服务用来实现业务逻辑—例如，获取 Unsplash 照片列表并从网络上加载数据。
* **核心层：** 定义我们的业务逻辑层和其它小工具所需的所有设置。例如，它包含基本的 URL、API 密钥和网络客户端。

![](https://cdn-images-1.medium.com/max/2000/1*b7fL11UWBMkqkhhzYsUsDw.png)

## 使用协调器（Coordinator）

MVVM 架构中并不包括应用内的导航，因此我选择使用协调器设计模式。这种模式相对简单，您可以在阅读本文时了解它的内涵，还可以随时来[这里](https://medium.com/better-programming/leverage-the-coordinator-design-pattern-in-swift-5-cd5bb9e78e12)学习。

我们定义基本的 `Coordinator` 协议并且让 `PhotosCoordinator` 和 `PhotoDetailCoordinator` 实现这个协议：

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

`start()` 方法负责创建当前的视图控制器及其依赖。当我们需要导航至另一个视图控制器时，则执行 `coordinate(to)` 方法，它按其顺序触发另一个视图控制器的 `start()` 方法。

现在，我们可以开发应用的初始功能了。我们定义了 `AppCoordinator`，它依赖于 `AppDelegate` 提供的 `UIWindow` 属性：

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

在 `AppCoordinator` 的 `start()` 方法内部，我们与 `PhotosCoordinator` 进行通信，创建了应用的初始场景：`Photos`。

现在来看看它的实现。

## Photos 场景

`PhotosCoordinator` 创建了 `PhotosViewController` 和 `PhotosViewModel`，如下：

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

我们为 PhotosViewModel 提供了三个依赖项：

* `UnsplashPhotosService`：获取 `UnsplashPhoto` 模型数组
* `DataLoadingService`：根据提供的 URL 加载并返回 `Data`
* `DataToImageService`：基于提供的 `Data` 返回 `UIImage`

界面效果如下：

![](https://cdn-images-1.medium.com/max/2680/1*JmScSaJIuhw1as8CY_p2Hw.png)

我们将详细研究视图模型和视图控制器的实现（因为它是独立于 UI 之外的，并且具有明确的输入/输出的区别，之后再研究视图控制器的代码会更有意义）。

#### 实现 PhotosViewModel

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

在这个文件中定义 `PhotosViewModel` 协议并实现它。该协议描述了输入（从视图控制器接收的事件）和输出（视图控制器用来驱动 UI 的视图模型数据）。在  `PhotosViewModelImplementation` 内部响应输入的事件并提供输出值：

* `PhotosViewController` 加载并将值发送到视图模型中的 `viewDidLoad` relay
* 触发视图模型中的 `getPhotos()` 方法
* 处理 `UnsplashPhotos` 数组并将其发送到 `unsplashPhotos` relay

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

注意，我们还将相关的 `Bool` 事件发送到 `isLoadingFirstPage` 和 `isLoadingAdditionalPhotos` relay 上，视图控制器使用这些事件来显示/隐藏加载指示符（有关更多信息，请参见视图控制器章节）。

* `PhotosViewController` 使用 `unsplashPhotos` 属性来驱动 `UICollectionView` 并根据接收到的模型的数量显示对应数量的 cell
* `PhotosViewController` 将值发送到视图模型的 `willDisplayCellAtIndex` 属性，这会触发数据加载
* 加载图片后，将其发送到 `imageRetrievedSuccess` relay 上，`PhotosViewController` 把图片显示在相应的 cell

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

首先，我们检查一下 `unsplashPhotos` 属性是否包含要显示的 cell 的索引。然后，获取图像的 URL，调用 `DataLoadingService` 的 `loadData(at:)` 方法，为了不阻塞主线程，我们在后台线程观察结果。

收到 `Data` 时，我们调用 `DataToImageService` 的 `getImage(from:)` 方法来获取 `UIImage` 对象。最后，如果图像获取成功，我们将事件发送至 `imageRetrievedSuccess`  relay，否则发送到 `imageRetrievedError` relay。

为了优化内存使用，如果正在加载数据的 cell 从屏幕上消失了，我们还要取消数据加载任务。为此，我们实现了 `didEndDisplayingCellAtIndex` relay，其用法如下：

* 视图控制器监听到在滚动 `UICollectionView` 时某个 cell 消失了，会将其索引发送到 `didEndDisplayingCellAtIndex` 属性上
* 视图模型调用 `DataLoadingService` 的 `stopLoading(at:)` 方法来取消正在进行的任务

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

`DataLoadingService` 会将任务存储到字典中，并处理掉我们不需要的任务：

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

当点击图片时，界面需要导航到新的场景并在其中显示点击的图片及其描述，因此我们定义了 `didChoosePhotoWithId` relay。当 relay 接收到值时，我们触发 `PhotosCoordinator` 的 `pushToPhotoDetail(with:)` 方法：

```Swift
private func bindOnDidChoosePhoto() {
    didChoosePhotoWithId
        .subscribe(onNext: { [unowned self] (id) in
            self.coordinator.pushToPhotoDetail(with: id)
        })
        .disposed(by: disposeBag)
}
```

现在我们还剩下最后一个功能要实现—无限滚动。它允许我们按页面加载 `UnsplashPhoto`，这样可以节省 API 资源并优化性能。我们的做法是生成一个额外的 `UnsplashPhoto` 数组并将其附加到现有数组中。通过在视图模型内部定义 `didScrollToTheBottom` relay 来实现：

* 视图控制器监听用户滚动到最后一个可用的 cell，并向 `didScrollToTheBottom` relay 发送一个 `Void` 事件。
* 视图模型中增加 `pageNumber` 的值，并获取新数据

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

我们实现的分页功能效果如下：

![](https://cdn-images-1.medium.com/max/2000/1*8byt48cw_FgHp8LrABYjiA.gif)

#### 实现 PhotosViewController

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

我们不打算讲解 UI 的创建方式，因为它不是本文的重点。如果您想了解的 `UICollectionView` 的编码实现，请访问[这篇](https://medium.com/cleansoftware/quickly-implement-tableview-collectionview-programmatically-df12da694af9)文章。现在我们重点关注两个关键职责：为视图模型提供输入；将视图模型的输出连接 UI。

我们创建 `cachedImages` 属性将加载的图片保存在字典中，以便于稍后可以在 cell 中使用缓存的图像来节省资源，而不是再次触发数据加载操作。

这是将视图模型的 `unsplashPhotos` 属性绑定到 `photosCollectionView` 的方式：

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

将值发送到 `willDisplayCellAtIndex` 上以触发数据加载（如果在该索引处未找到缓存的图像）：

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

我们还会对视图模型中的 `imageRetrievedSuccess` 和 `imageRetrievedError` 事件做出响应：

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

当某个 cell 消失时，我们将值发送到视图模型的 `didEndDisplayingCellAtIndex` relay 上：

```Swift
/// Cancelling image loading operation for a cell that disappeared
photosCollectionView.rx.didEndDisplayingCell
    .map { $0.1 }
    .map { $0.item }
    .bind(to: viewModel.didEndDisplayingCellAtIndex)
    .disposed(by: disposeBag)
```

再次使用 RxSwift 的 `willDisplayCell` 包装器，来确定是否滑动到列表末尾。

如果是，我们将 `Void` 值发送到 `didScrollToTheBottom` relay 上：

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

通过更新 `navigationItem` 上的标题对视图模型的 `isLoadingFirstPage` 和 `isLoadingAdditionalPhotos` 做出响应，并在每个 `PhotoCell` 中显示/隐藏加载指示器：

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

最后，当我们点击某个单元格时，我们获取所选 `UnsplashPhoto` 的 `id` 并将其 `Int` 值发送到 `didChoosePhotoWithId` relay ：

```Swift
photosCollectionView.rx.modelSelected(UnsplashPhoto.self)
    .compactMap { $0.id }
    .bind(to: viewModel.didChoosePhotoWithId)
    .disposed(by: disposeBag)
```

我们已经介绍了 `Photos` 场景，现在进入最后一个场景— `PhotoDetail`。

## 实现 PhotoDetail

此场景由 `Photos` 场景过渡而来，其中 `PhotoDetailCoordinator` 的实现如下：

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

我们可以看到，前一个协调器的 `photoId` 属性赋值给了 `PhotoDetailViewModel` 的 `photoId`。

#### 实现 PhotoDetailViewModel
 
与 `PhotosViewModel` 中的操作类似，在这里我们将 `viewDidLoad` 属性用作输入，并将 `isLoading`、`imageRetrievedError`、`imageRetrievedSuccess` 和 `description` 属性作为输出：

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

和之前一样，当我们在 `viewDidLoad` 上收到一个 `Void` 值时，我们将触发 `getPhoto()` 方法，该方法将结果绑定到 `unsplashPhoto` 属性：

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

这样就会触发图片数据及其描述的加载：

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

#### 实现 PhotoDetailViewController

这里的实现也类似，我们将事件发送到 `viewDidLoad` 属性，并将 `imageRetrievedSuccess`、`imageRetrievedError`、`description` 和 `isLoading` 绑定到 UI：

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

最后的功能已完成，效果如下：

![](https://cdn-images-1.medium.com/max/2000/1*Eh1Sn4gGfe6U2BrtfxpKsw.gif)

至此，我们已经用 MVVM 响应式架构实现了一个纯函数式的应用。

## 资源


该项目的源代码可在 GitHub 上找到：
[**zafarivaev/MVVM-RxSwift**](https://github.com/zafarivaev/MVVM-RxSwift)

---

## 结束

想更多地了解架构设计模式？请随时查看我的其他相关文章：

* [在 Swift 5 中实现外观模式](https://medium.com/better-programming/implement-the-facade-design-pattern-in-swift-dcc4325754ff)
* [在 Swift 5 中实现生成器模式](https://medium.com/better-programming/implement-the-builder-design-pattern-in-swift-5-ff5bc6f2fc3d)”
* [在 Swift 5 中实现策略模式](https://medium.com/better-programming/implement-the-strategy-design-pattern-in-swift-5d9c3f221277)
* [在 Swift 5 中实现 VIPER 架构](https://medium.com/better-programming/how-to-implement-viper-architecture-in-your-ios-app-rest-api-and-kingfisher-f494a0891c43)

感谢阅读!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
