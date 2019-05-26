> * 原文地址：[Flutter Layout Cheat Sheet](https://medium.com/flutter-community/flutter-layout-cheat-sheet-5363348d037e)
> * 原文作者：[Tomek Polański](https://medium.com/@tpolansk)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-layout-cheat-sheet.md](https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-layout-cheat-sheet.md)
> * 译者：
> * 校对者：

# Flutter Layout Cheat Sheet

![](https://cdn-images-1.medium.com/max/3538/1*Ktvy6_Ldzx9CjrrK3Vg9Fw.png)

Do you need simple layout samples for Flutter?
I present you my set of Flutter layout code snippets. I will keep it short, sweet and simple with loads of visual examples.
Still, it is work in progress — the catalog of samples will grow. I will focus more on the usage of Flutter widgets rather than showcasing the components ([Flutter Gallery](https://play.google.com/store/apps/details?id=io.flutter.gallery&hl=en) is great for that!).
If you have an issue with “layouting” your Flutter or you wanna share your snippets with others, please drop a line!

***

## Table of Contents

* Row and Column
* IntrinsicWidth and IntrinsicHeight
* Stack
* Expanded
* ConstrainedBox
* Container
  * decoration: BoxDecoration
  * image: DecorationImage
  * border: Border
  * borderRadius: BorderRadius
  * shape: BoxShape
  * boxShadow: `List<BoxShadow>`
  * gradient: RadialGradient
  * backgroundBlendMode: BlendMode
* SizedBox
* SafeArea

***

## Row and Column

### MainAxisAlignment

![](https://cdn-images-1.medium.com/max/2000/1*dkZ0sQRPFhGf9r7sO4LrzA.png)

![](https://cdn-images-1.medium.com/max/2000/1*Z8Utwfw9vPALRY0XOS4uSQ.png)

```dart
Row /*or Column*/( 
  mainAxisAlignment: MainAxisAlignment.start,
  children: <Widget>[
    Icon(Icons.star, size: 50),
    Icon(Icons.star, size: 50),
    Icon(Icons.star, size: 50),
  ],
),
```

***

![](https://cdn-images-1.medium.com/max/2000/1*NKci3PDfzyxSlcoZzN9WQg.png)

![](https://cdn-images-1.medium.com/max/2000/1*SDjCqaKjWtUSwTT5Ik_-Cw.png)

```dart
Row /*or Column*/( 
  mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[
    Icon(Icons.star, size: 50),
    Icon(Icons.star, size: 50),
    Icon(Icons.star, size: 50),
  ],
),
```

***

![](https://cdn-images-1.medium.com/max/2000/1*Q6pB5xw4RtehKSvWHffEgQ.png)

![](https://cdn-images-1.medium.com/max/2000/1*idDcokq5qV8CHrmplUCeNA.png)

```dart
Row /*or Column*/( 
  mainAxisAlignment: MainAxisAlignment.end,
  children: <Widget>[
    Icon(Icons.star, size: 50),
    Icon(Icons.star, size: 50),
    Icon(Icons.star, size: 50),
  ],
),
```

***

![](https://cdn-images-1.medium.com/max/2000/1*OdahXv1kvQAdn7PnsEKz7w.png)

![](https://cdn-images-1.medium.com/max/2000/1*vpvXC7fTvKWw-w9MGADbUg.png)

```dart
Row /*or Column*/( 
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: <Widget>[
    Icon(Icons.star, size: 50),
    Icon(Icons.star, size: 50),
    Icon(Icons.star, size: 50),
  ],
),
```

***

![](https://cdn-images-1.medium.com/max/2000/1*xPKN3e4hH54TxqIwLUn42A.png)

![](https://cdn-images-1.medium.com/max/2000/1*sAyW0aFJIYy4p1G3ekyrQQ.png)

```dart
Row /*or Column*/( 
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: <Widget>[
    Icon(Icons.star, size: 50),
    Icon(Icons.star, size: 50),
    Icon(Icons.star, size: 50),
  ],
),
```

***

![](https://cdn-images-1.medium.com/max/2000/1*LnttjdiEBxXI_mmWrHtxmw.png)

![](https://cdn-images-1.medium.com/max/2000/1*U38GUiD37VN0qN_ZexkIiQ.png)

```dart
Row /*or Column*/( 
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: <Widget>[
    Icon(Icons.star, size: 50),
    Icon(Icons.star, size: 50),
    Icon(Icons.star, size: 50),
  ],
),
```

***

![](https://cdn-images-1.medium.com/max/2000/1*MtiSZgu4yK6A4fSpGv6Zkg.png)

You should use `CrossAxisAlignment.baseline` if you require for the baseline of different text be aligned.

```dart
Row(
  crossAxisAlignment: CrossAxisAlignment.baseline,
  textBaseline: TextBaseline.alphabetic,
  children: <Widget>[
    Text(
      'Baseline',
      style: Theme.of(context).textTheme.display3,
    ),
    Text(
      'Baseline',
      style: Theme.of(context).textTheme.body1,
    ),
  ],
),
```

***

### CrossAxisAlignment

![](https://cdn-images-1.medium.com/max/2000/1*uJGtSW3UO8AjMgsViSmf6A.png)

![](https://cdn-images-1.medium.com/max/2000/1*VOB1npP6r7NNXG5gKYY3LQ.png)

```dart
Row /*or Column*/( 
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    Icon(Icons.star, size: 50),
    Icon(Icons.star, size: 200),
    Icon(Icons.star, size: 50),
  ],
),
```

***

![](https://cdn-images-1.medium.com/max/2000/1*NVCZBvvLBjcKKWU2tn7M9g.png)

![](https://cdn-images-1.medium.com/max/2000/1*q-6779AyXXa5jTtBeQdxWQ.png)

```dart
Row /*or Column*/( 
  crossAxisAlignment: CrossAxisAlignment.center,
  children: <Widget>[
    Icon(Icons.star, size: 50),
    Icon(Icons.star, size: 200),
    Icon(Icons.star, size: 50),
  ],
),
```

***

![](https://cdn-images-1.medium.com/max/2000/1*Vw2RkN4cDilzbx_Jx1l1_Q.png)

![](https://cdn-images-1.medium.com/max/2000/1*1gS9EP_Sta161SH4G_panQ.png)

```dart
Row /*or Column*/( 
  crossAxisAlignment: CrossAxisAlignment.end,
  children: <Widget>[
    Icon(Icons.star, size: 50),
    Icon(Icons.star, size: 200),
    Icon(Icons.star, size: 50),
  ],
),
```

***

![](https://cdn-images-1.medium.com/max/2000/1*67uV89an2F8qTEO2zEQkOA.png)

![](https://cdn-images-1.medium.com/max/2000/1*DQgDsWne5dp8dc0ZZ911Zg.png)

```dart
Row /*or Column*/( 
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: <Widget>[
    Icon(Icons.star, size: 50),
    Icon(Icons.star, size: 200),
    Icon(Icons.star, size: 50),
  ],
),
```

***

### MainAxisSize

![](https://cdn-images-1.medium.com/max/2000/1*8mB-TuJQHf5uz0LNrAJPNA.png)

![](https://cdn-images-1.medium.com/max/2000/1*mgRukOgzaOutbVFWGzii-A.png)

```dart
Row /*or Column*/( 
  mainAxisSize: MainAxisSize.max,
  children: <Widget>[
    Icon(Icons.star, size: 50),
    Icon(Icons.star, size: 50),
    Icon(Icons.star, size: 50),
  ],
),
```

***

![](https://cdn-images-1.medium.com/max/2000/1*j6rXI3zzwHlkQHb_9FNKOw.png)

![](https://cdn-images-1.medium.com/max/2000/1*TFkYeR-yqfHDH3pECJMM4Q.png)

```dart
Row /*or Column*/( 
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    Icon(Icons.star, size: 50),
    Icon(Icons.star, size: 50),
    Icon(Icons.star, size: 50),
  ],
),
```

***

## IntrinsicWidth and IntrinsicHeight

Want all the widgets inside Row or Column to be as tall/wide as the tallest/widest widget? Search no more!

In case you have this kind of layout:

![](https://cdn-images-1.medium.com/max/2000/1*9Ap8DHjFJssXHwkMFOu5zw.png)

```dart
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('IntrinsicWidth')),
    body: Center(
      child: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: () {},
            child: Text('Short'),
          ),
          RaisedButton(
            onPressed: () {},
            child: Text('A bit Longer'),
          ),
          RaisedButton(
            onPressed: () {},
            child: Text('The Longest text button'),
          ),
        ],
      ),
    ),
  );
}
```

But you would like to have all buttons as **wide** as **the widest**, just use `IntrinsicWidth` :

![](https://cdn-images-1.medium.com/max/2000/1*JS9b6Cvb-o2FGGgIC6zPiQ.png)

```dart
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('IntrinsicWidth')),
    body: Center(
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            RaisedButton(
              onPressed: () {},
              child: Text('Short'),
            ),
            RaisedButton(
              onPressed: () {},
              child: Text('A bit Longer'),
            ),
            RaisedButton(
              onPressed: () {},
              child: Text('The Longest text button'),
            ),
          ],
        ),
      ),
    ),
  );
}
```

In case you have a similar problem but you would like to have all the widgets as **tall** as **the tallest** just use combination of `IntrinsicHeight` and `Row` widgets.

***

## Stack

Perfect for overlaying Widgets on top of each other

![](https://cdn-images-1.medium.com/max/2000/1*3E_ll9conv_Ha7xTLtIn6Q.png)

```dart
@override
Widget build(BuildContext context) {
  Widget main = Scaffold(
    appBar: AppBar(title: Text('Stack')),
  );

  return Stack(
    fit: StackFit.expand,
    children: <Widget>[
      main,
      Banner(
        message: "Top Start",
        location: BannerLocation.topStart,
      ),
      Banner(
        message: "Top End",
        location: BannerLocation.topEnd,
      ),
      Banner(
        message: "Bottom Start",
        location: BannerLocation.bottomStart,
      ),
      Banner(
        message: "Bottom End",
        location: BannerLocation.bottomEnd,
      ),
    ],
  );
}
```

***

With your own Widgets, you need to place them in `Positioned` Widget

![](https://cdn-images-1.medium.com/max/2000/1*CkTumWbumdO9Ka6Mwa4S2A.png)

```dart
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('Stack')),
    body: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Material(color: Colors.yellowAccent),
        Positioned(
          top: 0,
          left: 0,
          child: Icon(Icons.star, size: 50),
        ),
        Positioned(
          top: 340,
          left: 250,
          child: Icon(Icons.call, size: 50),
        ),
      ],
    ),
  );
}
```

***

If you don’t want to guess the top/bottom values you can use `LayoutBuilder` to retrieve them

![](https://cdn-images-1.medium.com/max/2000/1*0_0q8qAbw4T_-gChblfV-A.png)

```dart
Widget build(BuildContext context) {
  const iconSize = 50;
  return Scaffold(
    appBar: AppBar(title: Text('Stack with LayoutBuilder')),
    body: LayoutBuilder(
      builder: (context, constraints) =>
        Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Material(color: Colors.yellowAccent),
            Positioned(
              top: 0,
              child: Icon(Icons.star, size: iconSize),
            ),
            Positioned(
              top: constraints.maxHeight - iconSize,
              left: constraints.maxWidth - iconSize,
              child: Icon(Icons.call, size: iconSize),
            ),
          ],
        ),
    ),
  );
}
```

***

## Expanded

`Expanded` works with [Flex\Flexbox](https://css-tricks.com/snippets/css/a-guide-to-flexbox/) layout and is great for distributing space between multiple items.

![](https://cdn-images-1.medium.com/max/2000/1*7CQEUQgzAHvbmJQwnessWA.png)

```dart
Row(
  children: <Widget>[
    Expanded(
      child: Container(
        decoration: const BoxDecoration(color: Colors.red),
      ),
      flex: 3,
    ),
    Expanded(
      child: Container(
        decoration: const BoxDecoration(color: Colors.green),
      ),
      flex: 2,
    ),
    Expanded(
      child: Container(
        decoration: const BoxDecoration(color: Colors.blue),
      ),
      flex: 1,
    ),
  ],
),
```

***

## ConstrainedBox

By default, most of the widgets will use as little space as possible:

![](https://cdn-images-1.medium.com/max/2000/1*c3l5JxXfY6-v6awf2VgggA.png)

```dart
Card(child: const Text('Hello World!'), color: Colors.yellow)
```

***

`ConstrainedBox` allows a widget to use the remaining space as desired.

![](https://cdn-images-1.medium.com/max/2000/1*QCTdn09Lb5uO4ZDuCGs1LA.png)

```dart
ConstrainedBox( 
  constraints: BoxConstraints.expand(),
  child: const Card(
    child: const Text('Hello World!'), 
    color: Colors.yellow,
  ), 
),
```

***

Using `BoxConstraints` you specify how much space a widget can have — you specify `min`/`max` of `height`/`width`.

`BoxConstraints.expand` uses infinite (all the available) amount of space unless specified:

![](https://cdn-images-1.medium.com/max/2000/1*q4nM3zvOd1PQFQMxCqZueQ.png)

```dart
ConstrainedBox(
  constraints: BoxConstraints.expand(height: 300),
  child: const Card(
    child: const Text('Hello World!'), 
    color: Colors.yellow,
  ),
),
```

And it’s the same as:

```dart
ConstrainedBox(
  constraints: BoxConstraints(
    minWidth: double.infinity,
    maxWidth: double.infinity,
    minHeight: 300,
    maxHeight: 300,
  ),
  child: const Card(
    child: const Text('Hello World!'), 
    color: Colors.yellow,
  ),
),
```

***

## Container

One of the most used Widgets — and for good reasons:

### Container as a layout tool

When you don’t specify the `height` and the `width` of the `Container`, it will match its `child`’s size

![](https://cdn-images-1.medium.com/max/2000/1*PLsAfFDKge7Gr7yl3M_iTA.png)

```dart
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('Container as a layout')),
    body: Container(
      color: Colors.yellowAccent,
      child: Text("Hi"),
    ),
  );
}
```

If you want to stretch the `Container` to match its parent, use `double.infinity` for the `height` and `width` properties

![](https://cdn-images-1.medium.com/max/2000/1*6Q_ynFTU1rDVZ65VCJsPlQ.png)

```dart
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('Container as a layout')),
    body: Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.yellowAccent,
      child: Text("Hi"),
    ),
  );
}
```

### Container as decoration

You can use color property to affect `Container`’s background but `decoration `and `foregroundDecoration`. (With those two properties, you can completely change how `Containe`r looks like but I will be talking about different decorations later as it quite big topic)
`decoration` is always placed behind the child, whereas `foregroundDecoration `is on top of the `child`

![decoration](https://cdn-images-1.medium.com/max/2000/1*EEpMF6tWMyvvsFF1yY_ewg.png)

```dart
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('Container.decoration')),
    body: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.yellowAccent),
      child: Text("Hi"),
    ),
  );
}
```

***

![decoration and foregroundDecoration](https://cdn-images-1.medium.com/max/2000/1*oOc21UE45kMa3dOSEikwHg.png)

```dart
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('Container.foregroundDecoration')),
    body: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.yellowAccent),
      foregroundDecoration: BoxDecoration(color: Colors.red.withOpacity(0.5)),
      child: Text("Hi"),
    ),
  );
}
```

### Container as Transform

If you don’t want to use `Transform` widget to change your layout, you can use `transform` property straight from the `Container`

![](https://cdn-images-1.medium.com/max/2000/1*pILEI4FBwKC1o422vFVhWw.png)

```dart
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('Container.transform')),
    body: Container(
      height: 300,
      width: 300,
      transform: Matrix4.rotationZ(pi / 4),
      decoration: BoxDecoration(color: Colors.yellowAccent),
      child: Text(
        "Hi",
        textAlign: TextAlign.center,
      ),
    ),
  );
}
```

***

## BoxDecoration

Decoration is usually used on a Container widget to change how the container looks.

### image: DecorationImage

Puts an image as a background:

![](https://cdn-images-1.medium.com/max/2000/1*_o7CH527uIZExmX1d_zb3Q.png)

```dart
Scaffold(
  appBar: AppBar(title: Text('image: DecorationImage')),
  body: Center(
    child: Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.yellow,
        image: DecorationImage(
          fit: BoxFit.fitWidth,
          image: NetworkImage(
            'https://flutter.io/images/catalog-widget-placeholder.png',
          ),
        ),
      ),
    ),
  ),
);
```

### border: Border

Specifies how should the border of the Container look like.

![](https://cdn-images-1.medium.com/max/2000/1*VdNLdpwXhSJ1IXSl37HzZg.png)

```dart
Scaffold(
  appBar: AppBar(title: Text('border: Border')),
  body: Center(
    child: Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.yellow,
        border: Border.all(color: Colors.black, width: 3),
      ),
    ),
  ),
);
```

### borderRadius: BorderRadius

Enables border corners to be rounded.

**`borderRadius` does not work if the `shape` of the decoration is `BoxShape.circle`**

![](https://cdn-images-1.medium.com/max/2000/1*jTE5_KqVyQFEwL8CwGNueQ.png)

```dart
Scaffold(
  appBar: AppBar(title: Text('borderRadius: BorderRadius')),
  body: Center(
    child: Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
          color: Colors.yellow,
          border: Border.all(color: Colors.black, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(18))),
    ),
  ),
);
```

### shape: BoxShape

Box decoration can be either a rectangle/square or an ellipse/circle.

**For any other shape, you can use `ShapeDecoration` instead of `BoxDecoration`**

![](https://cdn-images-1.medium.com/max/2000/1*7dqVoqn733edfeCVlEe25A.png)

```dart
Scaffold(
  appBar: AppBar(title: Text('shape: BoxShape')),
  body: Center(
    child: Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.yellow,
        shape: BoxShape.circle,
      ),
    ),
  ),
);
```

### boxShadow: `List<BoxShadow>`

Adds shadow to the Container.

This parameter is a list because you can specify multiple different shadows and merge them together.

![](https://cdn-images-1.medium.com/max/2000/1*h6w8aT1pJvb9lUlHJWELbg.png)

```dart
Scaffold(
  appBar: AppBar(title: Text('boxShadow: List<BoxShadow>')),
  body: Center(
    child: Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.yellow,
        boxShadow: const [
          BoxShadow(blurRadius: 10),
        ],
      ),
    ),
  ),
);
```

### gradient

There are three types of gradients: `LinearGradient`, `RadialGradient` and `SweepGradient`.

![`LinearGradient`](https://cdn-images-1.medium.com/max/2000/1*GDq_OI7bwYyOgOXQ88Dxvw.png)

```dart
Scaffold(
  appBar: AppBar(title: Text('gradient: LinearGradient')),
  body: Center(
    child: Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: const [
            Colors.red,
            Colors.blue,
          ],
        ),
      ),
    ),
  ),
);
```

***

![RadialGradient](https://cdn-images-1.medium.com/max/2000/1*wXgArqqmEpK-VNEkKGCAYQ.png)

```dart
Scaffold(
  appBar: AppBar(title: Text('gradient: RadialGradient')),
  body: Center(
    child: Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: const [Colors.yellow, Colors.blue],
          stops: const [0.4, 1.0],
        ),
      ),
    ),
  ),
);
```

***

![SweepGradient](https://cdn-images-1.medium.com/max/2000/1*QWdTe81Boo0UVv4slujaLQ.png)

```dart
Scaffold(
  appBar: AppBar(title: Text('gradient: SweepGradient')),
  body: Center(
    child: Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        gradient: SweepGradient(
          colors: const [
            Colors.blue,
            Colors.green,
            Colors.yellow,
            Colors.red,
            Colors.blue,
          ],
          stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
        ),
      ),
    ),
  ),
);
```

### backgroundBlendMode

`backgroundBlendMode` is the most complex property of `BoxDecoration`.
It’s responsible for mixing together colors/gradients of `BoxDecoration` and whatever `BoxDecoration` is on top of.

With `backgroundBlendMode` you can use a long list of algorithms specified in `BlendMode` enum.

First, let’s set `BoxDecoration` as `foregroundDecoration` which is drawn on top of `Container`’s child (whereas `decoration` is drawn behind the child).

![](https://cdn-images-1.medium.com/max/2000/1*oEl3AuLzeAfwJPDguSOVkg.png)

```dart
Scaffold(
  appBar: AppBar(title: Text('backgroundBlendMode')),
  body: Center(
    child: Container(
      height: 200,
      width: 200,
      foregroundDecoration: BoxDecoration(
        backgroundBlendMode: BlendMode.exclusion,
        gradient: LinearGradient(
          colors: const [
            Colors.red,
            Colors.blue,
          ],
        ),
      ),
      child: Image.network(
        'https://flutter.io/images/catalog-widget-placeholder.png',
      ),
    ),
  ),
);
```

`backgroundBlendMode` does not affect only the `Container` it’s localed in.

`backgroundBlendMode` changes the color of anything that is up the widget tree from the `Container`.
The following code has a parent `Container` that draws an `image` and child `Container` that uses `backgroundBlendMode`. Still, you would get the same effect as previously.

![](https://cdn-images-1.medium.com/max/2000/1*odhlbvPiq6RDvopcWdl2ZA.png)

```dart
Scaffold(
  appBar: AppBar(title: Text('backgroundBlendMode')),
  body: Center(
    child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://flutter.io/images/catalog-widget-placeholder.png',
          ),
        ),
      ),
      child: Container(
        height: 200,
        width: 200,
        foregroundDecoration: BoxDecoration(
          backgroundBlendMode: BlendMode.exclusion,
          gradient: LinearGradient(
            colors: const [
              Colors.red,
              Colors.blue,
            ],
          ),
        ),
      ),
    ),
  ),
);
```

***

## SizedBox

It’s one of the simplest but most useful Widgets

### SizedBox as ConstrainedBox

`SizedBox` can work in a similar fashion as `ConstrainedBox`

![](https://cdn-images-1.medium.com/max/2000/1*Zc3fvnsiRq_P_8luY2_BCQ.png)

```dart
SizedBox.expand(
  child: Card(
    child: Text('Hello World!'),
    color: Colors.yellowAccent,
  ),
),
```

***

### SizedBox as padding

When in need of adding padding or margin, you might choose `Padding` or `Container` widgets. But they can be more verbose and less redeable than adding a `Sizedbox`

![](https://cdn-images-1.medium.com/max/2000/1*UuPNTwfn0_U-PnczL0rSqg.png)

```dart
Column(
  children: <Widget>[
    Icon(Icons.star, size: 50),
    const SizedBox(height: 100),
    Icon(Icons.star, size: 50),
    Icon(Icons.star, size: 50),
  ],
),
```

### SizedBox as an Invisible Object

Many time you would like to hide/show a widget depending on a `bool`

![](https://cdn-images-1.medium.com/max/2000/1*80OncmeIsFh_T__VRTtO5A.png)

![](https://cdn-images-1.medium.com/max/2000/1*l6RFIsNdaX5p5Xj_HbZ0Iw.png)

```dart
Widget build(BuildContext context) {
  bool isVisible = ...
  return Scaffold(
    appBar: AppBar(
      title: Text('isVisible = $isVisible'),
    ),
    body: isVisible 
      ? Icon(Icons.star, size: 150) 
      : const SizedBox(),
  );
}
```

Because `SizedBox` has a `const` constructor, using `const SizedBox()` is really cheap**.

** One cheaper solution would be to use `Opacity` widget and change the `opacity` value to `0.0` . The drawback of this solution is that the given widget would be only invisible, still would occupy the space.

***

## SafeArea

On different Platforms, there are special areas like Status Bar on Android or the Notch on iPhone X that we might avoid drawing under.

The solution to this problem is `SafeArea` widget (example without/with `SafeArea`)

![](https://cdn-images-1.medium.com/max/2000/1*zaPTNnqSOLy4zj-usj-3Mw.png)

![](https://cdn-images-1.medium.com/max/2000/1*nbp1xowGxriVW9aNQn_20A.png)

```dart
Widget build(BuildContext context) {
  return Material(
    color: Colors.blue,
    child: SafeArea(
      child: SizedBox.expand(
        child: Card(color: Colors.yellowAccent),
      ),
    ),
  );
}
```

***

**More coming soon**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
