> * 原文地址：[Create a Line Chart in SwiftUI Using Paths](https://medium.com/better-programming/create-a-line-chart-in-swiftui-using-paths-183d0ddd4578)
> * 原文作者：[Anupam Chugh](https://medium.com/@anupamchugh)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/create-a-line-chart-in-swiftui-using-paths.md](https://github.com/xitu/gold-miner/blob/master/TODO1/create-a-line-chart-in-swiftui-using-paths.md)
> * 译者：
> * 校对者：

# Create a Line Chart in SwiftUI Using Paths

> Create beautiful stock charts in your iOS application

![Photo by [Chris Liverani](https://unsplash.com/@chrisliverani?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral).](https://cdn-images-1.medium.com/max/8064/0*eZh1HfzXfAjD_9ME)

Introduced at WWDC 2019, the SwiftUI framework gave the iOS community a lot to cheer about. An easy-to-use, declarative API written in Swift lets developers quickly build UI prototypes.

While we can leverage the Shapes protocol to build [Bar Charts](https://medium.com/better-programming/swiftui-bar-charts-274e9fbc8030) from the ground up, the same cannot be said about Line Charts. Thankfully, we’ve got the `Paths` structure to help us with that.

Using SwiftUI paths, which are similar to `CGPaths` from the Core Graphics framework, we can combine lines and curves to build beautiful logos and shapes.

Being true to the declarative way of writing UI, SwiftUI paths are built with a set of instructions. In the next few sections, we’ll discuss what that means.

## Our Goal

* Exploring SwiftUI’s Path API and creating simple shapes out of it.
* Using Combine and URLSession to fetch the historical stock data. We’ll be using [Alpha Vantage](https://www.alphavantage.co/)’s API to retrieve the stock information.
* Creating a Line Chart in SwiftUI that displays the stock’s prices over time.

By the end of this article, you should be able to create an iOS application similar to the one below:

![An NSE India and two US-based stock charts.](https://cdn-images-1.medium.com/max/2000/1*0_IPSWXsxHgGDRk51CAPbw.png)

## Create a Simple SwiftUI Path

Here’s an example of creating a right-angled triangle using paths in SwiftUI:

```Swift
var body: some View {
Path { path in
path.move(to: CGPoint(x: 100, y: 100))
path.addLine(to: CGPoint(x: 100, y: 300))
path.addLine(to: CGPoint(x: 300, y: 300))
}.fill(Color.green)
}
```

The Path API consists of a bunch of functions. `move` is responsible for setting the starting point of the path. `addLine` is responsible for drawing a straight line to the destination point specified.

`addArc`, `addCurve`, `addQuadCurve`, `addRect`, and `addEllipse` are just a few other methods that let us create circular arcs or Bezier curves among many other things with paths.

Appending two or more paths is possible using `addPath`.

The following illustration shows a triangle followed by a circular pie:

![](https://cdn-images-1.medium.com/max/2186/1*8XNc1miVjNhzzDCYW44p8g.png)

Now that we’ve got an idea of how to create paths in SwiftUI, let’s jump to Line Charts in SwiftUI.

## SwiftUI Line Chart

The model to decode the JSON response from the API is given below:

```Swift
struct StockPrice : Codable{
    let open: String
    let close: String
    let high: String
    let low: String
    
    private enum CodingKeys: String, CodingKey {
        
        case open = "1. open"
        case high = "2. high"
        case low = "3. low"
        case close = "4. close"
    }
}

struct StocksDaily : Codable {
    let timeSeriesDaily: [String: StockPrice]?
    
    private enum CodingKeys: String, CodingKey {
        case timeSeriesDaily = "Time Series (Daily)"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        timeSeriesDaily = try (values.decodeIfPresent([String : StockPrice].self, forKey: .timeSeriesDaily))
    }
}
```

Let’s create an `ObservableObject` class. We’ll perform the API requests using the URLSession’s Combine Publisher and transform the results using the Combine operators.

```Swift
class Stocks : ObservableObject{
    
    @Published var prices = [Double]()
    @Published var currentPrice = "...."
    var urlBase = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=NSE:YESBANK&apikey=demo&datatype=json"
    
    var cancellable : Set<AnyCancellable> = Set()
    
    init() {
        fetchStockPrice()
    }
    
    func fetchStockPrice(){
        
        URLSession.shared.dataTaskPublisher(for: URL(string: "\(urlBase)")!)
            .map{output in
                
                return output.data
        }
        .decode(type: StocksDaily.self, decoder: JSONDecoder())
        .sink(receiveCompletion: {_ in
            print("completed")
        }, receiveValue: { value in

            var stockPrices = [Double]()
            
            let orderedDates =  value.timeSeriesDaily?.sorted{
                guard let d1 = $0.key.stringDate, let d2 = $1.key.stringDate else { return false }
                return d1 < d2
            }
            
            guard let stockData = orderedDates else {return}
            
            for (_, stock) in stockData{
                if let stock = Double(stock.close){
                    if stock > 0.0{
                        stockPrices.append(stock)
                    }
                }
            }
            
            DispatchQueue.main.async{
                self.prices = stockPrices
                self.currentPrice = stockData.last?.value.close ?? "..."
            }
        })
            .store(in: &cancellable)
        
    }
}

extension String {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    var stringDate: Date? {
        return String.shortDate.date(from: self)
    }
}
```

The API results consist of nested JSON with the key being the dates. These are unordered in the dictionary and we need to sort them. For that, we’ve declared an extension that converts the string to date and does a comparison in the `sort` function.

Now that we’ve got the prices and stock data in the `Published` properties, we need to pass them to the `LineView` — a custom SwiftUI view that we will see next:

```Swift
struct LineView: View {
    var data: [(Double)]
    var title: String?
    var price: String?

    public init(data: [Double],
                title: String? = nil,
                price: String? = nil) {
        
        self.data = data
        self.title = title
        self.price = price
    }
    
    public var body: some View {
        GeometryReader{ geometry in
            VStack(alignment: .leading, spacing: 8) {
                Group{
                    if (self.title != nil){
                        Text(self.title!)
                            .font(.title)
                    }
                    if (self.price != nil){
                        Text(self.price!)
                            .font(.body)
                        .offset(x: 5, y: 0)
                    }
                }.offset(x: 0, y: 0)
                ZStack{
                    GeometryReader{ reader in
                        Line(data: self.data,
                             frame: .constant(CGRect(x: 0, y: 0, width: reader.frame(in: .local).width , height: reader.frame(in: .local).height)),
                             minDataValue: .constant(nil),
                             maxDataValue: .constant(nil)
                        )
                            .offset(x: 0, y: 0)
                    }
                    .frame(width: geometry.frame(in: .local).size.width, height: 200)
                    .offset(x: 0, y: -100)

                }
                .frame(width: geometry.frame(in: .local).size.width, height: 200)
        
            }
        }
    }
}
```

The view above gets invoked from our SwiftUI ContentView, where the name, price, and an array of price history are passed. Using the GeometryReader, we’ll pass the width and height of the frame to the `Line` struct, where we’ll eventually join the points using SwiftUI paths:

```Swift
struct Line: View {
    var data: [(Double)]
    @Binding var frame: CGRect

    let padding:CGFloat = 30
    
    var stepWidth: CGFloat {
        if data.count < 2 {
            return 0
        }
        return frame.size.width / CGFloat(data.count-1)
    }
    var stepHeight: CGFloat {
        var min: Double?
        var max: Double?
        let points = self.data
        if let minPoint = points.min(), let maxPoint = points.max(), minPoint != maxPoint {
            min = minPoint
            max = maxPoint
        }else {
            return 0
        }
        if let min = min, let max = max, min != max {
            if (min <= 0){
                return (frame.size.height-padding) / CGFloat(max - min)
            }else{
                return (frame.size.height-padding) / CGFloat(max + min)
            }
        }
        
        return 0
    }
    var path: Path {
        let points = self.data
        return Path.lineChart(points: points, step: CGPoint(x: stepWidth, y: stepHeight))
    }
    
    public var body: some View {
        
        ZStack {

            self.path
                .stroke(Color.green ,style: StrokeStyle(lineWidth: 3, lineJoin: .round))
                .rotationEffect(.degrees(180), anchor: .center)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .drawingGroup()
        }
    }
}
```

`stepWidth` and `stepHeight` are computed for constraining the chart within a given width and height of the frame. They’re then passed to the extension function of the `Path` struct to create the line chart:

```Swift
extension Path {
    
    static func lineChart(points:[Double], step:CGPoint) -> Path {
        var path = Path()
        if (points.count < 2){
            return path
        }
        guard let offset = points.min() else { return path }
        let p1 = CGPoint(x: 0, y: CGFloat(points[0]-offset)*step.y)
        path.move(to: p1)
        for pointIndex in 1..<points.count {
            let p2 = CGPoint(x: step.x * CGFloat(pointIndex), y: step.y*CGFloat(points[pointIndex]-offset))
            path.addLine(to: p2)
        }
        return path
    }
}
```

Finally, the SwiftUI application displaying the stocks chart in action is ready. The following illustration showcases that:

![](https://cdn-images-1.medium.com/max/2186/1*51q3BlLa-XLLKtHn-mgTOA.png)

## Conclusion

In this article, we managed to bring together SwiftUI and Combine once again — this time for fetching stock prices and displaying them in a Line Chart. Knowing the intricacies of SwiftUI paths is a good starting point for working with SwiftUI shapes, which require you to implement the `path` function.

You can take the SwiftUI Line Charts above a step further by using gestures to highlight the points and their respective values. To know how to do that and more, refer [to this repository](https://github.com/AppPear/ChartView).

The full source code of the application above is available in the [GitHub repository](https://github.com/anupamchugh/iowncode/tree/master/SwiftUILineChart).

That’s it for this one. Thanks for reading.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
