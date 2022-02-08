> * 原文地址：[Reverse engineering the .car file format (compiled Asset Catalogs)](https://blog.timac.org/2018/1018-reverse-engineering-the-car-file-format/)
> * 原文作者：[Timac](https://blog.timac.org/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/reverse-engineering-the-car-file-format.md](https://github.com/xitu/gold-miner/blob/master/article/2021/reverse-engineering-the-car-file-format.md)
> * 译者：[LoneyIsError](https://github.com/LoneyIsError)
> * 校对者：[jaredliw](https://github.com/jaredliw)

# 逆向 `.car` 文件（已编译的 Asset Catalogs）

`Asset Catalog` 是任何 iOS、tvOS、watchOS 和 macOS 应用程序的重要组成部分。它让你可以组织和管理应用程序使用的不同素材，例如图像、Sprites（精灵帧）、纹理、ARKit 资源、颜色和数据。

Apple 每年都还在扩展 Asset Catalogs 的功能：

- Xcode 9 添加了对 Color Asset 的支持并改进了对矢量资源（PDF）的支持。参阅 WWDC 2017 session [Cocoa 新功能](https://developer.apple.com/videos/play/wwdc2017/207/)。
- Xcode 10 添加了对高效图像、Apple 深度像素图像压缩以及对 macOS Mojave 暗模式的支持。 参阅 WWDC 2018 session [优化 App 素材](https://developer.apple.com/videos/play/wwdc2018/227/)。

鲜为人知的是，当使用 Xcode 构建应用程序时，`Asset Catalog` 会被编译成 `.car` 文件。但是，Apple 并没有关于 `.car` 文件的文档，而且令人惊讶的是，我在网上找不到太多信息。

在本文中，我试图通过描述 `.car` 文件的全局结构及其不同元素来弥补有关 `.car` 格式文件信息的不足。在本文中，我构建了一个 `CARParser` 工具来手动解析 `.car` 文件。该工具的完整源代码可在文末下载。 

请注意，本文中的文档和 `CARParser` 工具仅用于教育目的。你不应该像这里那样直接处理 `.car` 文件。有几种工具（包括我自己的，我计划在某个时候开源）可以转储 `.car` 文件的内容。但是这些工具只是使用了一些 Apple 的私有 API，并不能直接解析文件。同样，对于逆向工程，谁也不能保证数据是完全准确的。在发布时，本文应反映 macOS Mojave 和 iOS 12 中的状态。然而，它可能会随着未来的 macOS 或 iOS 版本更新而过时。

## 什么是 Asset Catalogs?

Xcode 5 中引入了 `Asset Catalog`，可以更轻松地管理图像，尤其是在处理多种分辨率的 PNG 图像（@1x、@2x、@3x 等）时。在 Xcode 中， `Asset Catalog` 显示为 `.xcassets` 文件夹，[Apple 详细地描述了它的用途](https://help.apple.com/xcode/mac/current/#/dev10510b1f7)。Apple 在 [Asset Catalog Format Reference](https://developer.apple.com/library/content/documentation/Xcode/Reference/xcode_ref-Asset_Catalog_Format/index.html) 中也很好地描述了磁盘上的 `.xcassets` 格式。

出于本文的目的，我创建了一个包含各种类型素材的示例 `Asset Catalog`。可以在[此处下载](https://blog.timac.org/2018/1018-reverse-engineering-the-car-file-format/DemoAssets.xcassets.zip)此示例 `Asset Catalog`。对应的 `.car` 文件可以在[这里下载](https://blog.timac.org/2018/1018-reverse-engineering-the-car-file-format/Assets.car)。

设置为 iOS 12 的 `Asset Catalog` 中包含了以下文件：

* 具有 3 个分辨率 @1x、@2x 和 @3x 的 PNG 文件
* 一个 PDF 文件
* 一个文本文件
* 一个 jpg 图片
* 一个颜色文件（红色，透明度为 50%）

![DemoAsset](https://blog.timac.org/2018/1018-reverse-engineering-the-car-file-format/DemoAsset.png)

## 什么是 `car` 文件?

当开发人员构建 iOS、watchOS、tvOS 或 macOS 应用程序时，包含各种素材（图像、图标、纹理等）的 `Asset Catalog` 不会简单地复制到应用程序包中，而是被编译为 `car` 文件。

当应用程序在 iOS 上运行时，从 `car` 文件获取图片非常简单，只需执行以下操作：

```objc
UIImage *myImage = [UIImage imageNamed:@"MyImage"];
```

执行这行代码时，从私有的 CoreUI.framework（`/System/Library/PrivateFrameworks/CoreUI.framework`）提供与名为 `MyImage` 的素材所对应的最合适的 UIImage。 `MyImage` 是`素材名称`，同样被叫作`维面名称`。 `car` 文件可以包含给定素材名称的多个图像：@1x 分辨率、@2x 分辨率、@3x 分辨率、暗模式、… 这些资源的表示形式称为`副本`。每个副本都有一个唯一的标识符，称为`副本键`。实际上，`副本键`是描述副本的属性列表：原始纬度、分辨率、…


`CAR` 扩展是什么意思？以 Xcode 中 IBFoundation 框架中的各种方法的名称为例，它可能代表已编译的素材记录（**C**ompiled **A**sset **R**ecord）。

在 macOS 上，有几个闭源工具来处理 `Asset Catalog`：

- Xcode 允许你编辑 `Asset Catalog` 并编译它们
- `actool` 允许你编译、打印、更新和验证 `Asset Catalog` 
- `assetutil` 允许你处理 `car` 文件。它可以从 `car` 文件中删除不需要的素材，但也可以解析 `car` 文件并生成  JSON 文件输出。

运行  `assetutil -I Assets.car` 命令将打印一些关于 `car` 文件的有趣信息：

```json
[
  {
    "AssetStorageVersion" : "IBCocoaTouchImageCatalogTool-10.0",
    "Authoring Tool" : "@(#)PROGRAM:CoreThemeDefinition  PROJECT:CoreThemeDefinition-346.29\n",
    "CoreUIVersion" : 498,
    "DumpToolVersion" : 498.4599999999998976,
    "Key Format" : [
      "kCRThemeAppearanceName",
      "kCRThemeScaleName",
      "kCRThemeIdiomName",
      "kCRThemeSubtypeName",
      "kCRThemeDeploymentTargetName",
      "kCRThemeGraphicsClassName",
      "kCRThemeMemoryClassName",
      "kCRThemeDisplayGamutName",
      "kCRThemeDirectionName",
      "kCRThemeSizeClassHorizontalName",
      "kCRThemeSizeClassVerticalName",
      "kCRThemeIdentifierName",
      "kCRThemeElementName",
      "kCRThemePartName",
      "kCRThemeStateName",
      "kCRThemeValueName",
      "kCRThemeDimension1Name",
      "kCRThemeDimension2Name"
    ],
    "MainVersion" : "@(#)PROGRAM:CoreUI  PROJECT:CoreUI-498.40.1\n",
    "Platform" : "ios",
    "PlatformVersion" : "12.0",
    "SchemaVersion" : 2,
    "StorageVersion" : 15
  },
  {
    "AssetType" : "Data",
    "Compression" : "uncompressed",
    "Data Length" : 7284,
    "Idiom" : "universal",
    "Name" : "MyPDF",
    "Scale" : 1,
    "SizeOnDisk" : 7538,
    "UTI" : "com.adobe.pdf"
  },
  {
    "AssetType" : "Data",
    "Compression" : "uncompressed",
    "Data Length" : 14,
    "Idiom" : "universal",
    "Name" : "MyText",
    "Scale" : 1,
    "SizeOnDisk" : 238,
    "UTI" : "UTI-Unknown"
  },
  {
    "AssetType" : "Image",
    "BitsPerComponent" : 8,
    "ColorModel" : "RGB",
    "Colorspace" : "srgb",
    "Compression" : "palette-img",
    "Encoding" : "ARGB",
    "Idiom" : "universal",
    "Image Type" : "kCoreThemeOnePartScale",
    "Name" : "MyPNG",
    "Opaque" : false,
    "PixelHeight" : 28,
    "PixelWidth" : 28,
    "RenditionName" : "Timac.png",
    "Scale" : 1,
    "SizeOnDisk" : 1007,
    "Template Mode" : "automatic"
  },
  {
    "AssetType" : "Color",
    "Color components" : [
      1,
      0,
      0,
      0.5
    ],
    "Colorspace" : "srgb",
    "Idiom" : "universal",
    "Name" : "MyColor",
    "Scale" : 1
  },
  {
    "AssetType" : "Image",
    "BitsPerComponent" : 8,
    "ColorModel" : "RGB",
    "Encoding" : "JPEG",
    "Idiom" : "universal",
    "Image Type" : "kCoreThemeOnePartScale",
    "Name" : "MyJPG",
    "Opaque" : true,
    "PixelHeight" : 200,
    "PixelWidth" : 200,
    "RenditionName" : "TimacJPG.jpg",
    "Scale" : 1,
    "SizeOnDisk" : 8042,
    "Template Mode" : "automatic"
  },
  {
    "AssetType" : "Image",
    "BitsPerComponent" : 8,
    "ColorModel" : "RGB",
    "Colorspace" : "srgb",
    "Compression" : "palette-img",
    "Encoding" : "ARGB",
    "Idiom" : "universal",
    "Image Type" : "kCoreThemeOnePartScale",
    "Name" : "MyPNG",
    "Opaque" : false,
    "PixelHeight" : 56,
    "PixelWidth" : 56,
    "RenditionName" : "Timac@2x.png",
    "Scale" : 2,
    "SizeOnDisk" : 1102,
    "Template Mode" : "automatic"
  },
  {
    "AssetType" : "Image",
    "BitsPerComponent" : 8,
    "ColorModel" : "RGB",
    "Colorspace" : "srgb",
    "Compression" : "palette-img",
    "Encoding" : "ARGB",
    "Idiom" : "universal",
    "Image Type" : "kCoreThemeOnePartScale",
    "Name" : "MyPNG",
    "Opaque" : false,
    "PixelHeight" : 84,
    "PixelWidth" : 84,
    "RenditionName" : "Timac@3x.png",
    "Scale" : 3,
    "SizeOnDisk" : 1961,
    "Template Mode" : "automatic"
  }
]
```

## 特殊的 BOM 文件

在 [HexFiend](http://ridiculousfish.com/hexfiend/) 中打开 `car` 文件会显示一些有用的信息：

![img](https://blog.timac.org/2018/1018-reverse-engineering-the-car-file-format/BomStore.png)

魔术值 `BOMStore` 告诉我们 `car` 文件是一种特殊的 `bom` 文件。BOM（物料清单）是一种从 NeXTSTEP 继承的文件格式，仍然在 macOS 安装程序中使用，以确定要安装、删除或升级的文件。你可以在 `man 5 bom` 中找到一些基本信息：

```text
The Mac OS X Installer uses a file system "bill of materials" to determine which files to install, remove, or upgrade. A bill of materials, bom, contains all the files within a directory, along with some information about each file. File information includes: the file's UNIX permissions, its owner and group, its size, its time of last modification, and so on. Also included are a checksum of each file and information about hard links.
```

macOS 提供了几个闭源工具来处理 bom 文件，比如 `lsbom` 和 `mkbom`。可以使用 `lsbom` 检查位于 /private/var/db/receipts/ 中的安装程序。例如，运行 `lsbom /private/var/db/receipts/com.apple.pkg.Numbers5.bom` 将打印 Apple Numbers 安装的所有文件（路径、权限、UID/GID、大小和 CRC32 校验和）：

```bash
.	40775	0/0
./Applications	40775	0/80
./Applications/Numbers.app	40755	0/0
./Applications/Numbers.app/Contents	40755	0/0
./Applications/Numbers.app/Contents/Info.plist	100644	0/0	7093	2611993997
./Applications/Numbers.app/Contents/MacOS	40755	0/0
./Applications/Numbers.app/Contents/MacOS/Numbers	100755	0/0	9838697539155192
./Applications/Numbers.app/Contents/PkgInfo	100644	0/0	8	3080130777
[...]
```

遗憾的是，`bom` 文件格式本身并没有文档记录，操作 `bom` 文件的工具不能处理 `car` 文件。由 Joseph Coffland 和 Julian Devlin [重新实现的 lsbom](https://github.com/cooljeanius/osxbom)，其代码中包含一些关于 BOM 文件格式的有用的信息。 我们可以看到，BOM 能存储块和树 。

然而，与**常规**的 `bom` 文件相反， `car` 文件中包含多个 `bom` 块：

* CARHEADER

* EXTENDED_METADATA
* KEYFORMAT
* CARGLOBALS
* KEYFORMATWORKAROUND
* EXTERNAL_KEYS

以及存储多个数据库的 `bom` 树：

* FACETKEYS

* RENDITIONS
* APPEARANCEKEYS
* COLORS
* FONTS
* FONTSIZES
* GLYPHS
* BEZELS
* BITMAPKEYS
* ELEMENT_INFO
* PART_INFO

一些块和树是可选的。在这篇文章中，我只描述一些重要的块： `CARHEADER`、`EXTENDED_METADATA`、`KEYFORMAT` 以及重要的树：`FACETKEYS`、 `RENDITIONS` 和 `APPEARANCEKEYS`。其他的块和树一般都是空的或不存在。

## 解析 BOM

在 macOS 上，私有 CoreUI.framework 负责提取这些素材，因此包含了解析 BOM 的代码。事实证明，它使用与位于 /System/Library/PrivateFrameworks/Bom.framework 中的私有 Bom.framework 相同的代码。我决定使用这个私有框架来解析 BOM。

通过查看 CoreUI 框架的调用，可以很容易地逆推解析 `car` 文件所需的 API，我最终得到了这些 C 类 API：

```c
typedef uint32_t BOMBlockID;
typedef struct BOMStorage *BOMStorage;

typedef struct BOMTree *BOMTree;
typedef struct BOMTreeIterator *BOMTreeIterator;

// Opening a BOM
BOMStorage BOMStorageOpen(const char *inPath, Boolean inWriting);

// Accessing a BOM block
BOMBlockID BOMStorageGetNamedBlock(BOMStorage inStorage, const char *inName);
size_t BOMStorageSizeOfBlock(BOMStorage inStorage, BOMBlockID inBlockID);
int BOMStorageCopyFromBlock(BOMStorage inStorage, BOMBlockID inBlockID, void *outData);

// Accessing a BOM tree
BOMTree BOMTreeOpenWithName(BOMStorage inStorage, const char *inName, Boolean inWriting);
BOMTreeIterator BOMTreeIteratorNew(BOMTree inTree, void *, void *, void *);
Boolean BOMTreeIteratorIsAtEnd(BOMTreeIterator iterator);
void BOMTreeIteratorNext(BOMTreeIterator iterator);

// Accessing the keys and values of a BOM tree
void * BOMTreeIteratorKey(BOMTreeIterator iterator);
size_t BOMTreeIteratorKeySize(BOMTreeIterator iterator);
void * BOMTreeIteratorValue(BOMTreeIterator iterator);
size_t BOMTreeIteratorValueSize(BOMTreeIterator iterator);
```

通过使用 Bom.framework 的私有 API，访问 `CARHEADER` 块的数据就像执行命令一样简单：

```objc
NSData *blockData = GetDataFromBomBlock(bomStorage, "CARHEADER");
```

其中 `GetDataFromBomBlock()` 方法实现为：

```objc
NSData *GetDataFromBomBlock(BOMStorage inBOMStorage, const char *inBlockName) {
	NSData *outData = nil;
	
	BOMBlockID blockID = BOMStorageGetNamedBlock(inBOMStorage, inBlockName);
	size_t blockSize = BOMStorageSizeOfBlock(inBOMStorage, blockID);
	if(blockSize > 0) {
		void *mallocedBlock = malloc(blockSize);
		int res = BOMStorageCopyFromBlock(inBOMStorage, blockID, mallocedBlock);
		if(res == noErr) {
			outData = [[NSData alloc] initWithBytes:mallocedBlock length:blockSize];
		}
		
		free(mallocedBlock);
	}
	
	return outData;
}
```

类似地，可以使用一个简单的方法来获取 BOM 树的所有键/值。例如要获取 `FACETKEYS` 树的所有键/值，可以执行下面的代码：

```objc
ParseBOMTree(bomStorage, "FACETKEYS", ^(NSData *inKey, NSData *inValue) {
	// This Objective-C block is called for each key found.
	// The value corresponding to the key is passed as parameter.
});
```

其中  `ParseBOMTree()` 方法实现如下：

```objc
typedef void (^ParseBOMTreeCallback)(NSData *inKey, NSData *inValue);
void ParseBOMTree(BOMStorage inBOMStorage, const char *inTreeName, ParseBOMTreeCallback keyValueCallback) {
	NSData *keyData = nil;
	NSData *keyValue = nil;
	
	// Open the BOM tree
	BOMTree bomTree = BOMTreeOpenWithName(inBOMStorage, inTreeName, false);
	if(bomTree == NULL)
		return;

	// Create a BOMTreeIterator and loop until the end
	BOMTreeIterator	bomIterator = BOMTreeIteratorNew(bomTree, NULL, NULL, NULL);
	while(!BOMTreeIteratorIsAtEnd(bomIterator)) {
		// Get the key
		void * key = BOMTreeIteratorKey(bomIterator);
		size_t keySize = BOMTreeIteratorKeySize(bomIterator);
		keyData = [NSData dataWithBytes:key length:keySize];
		
		// Get the value associated to the key
		size_t valueSize = BOMTreeIteratorValueSize(bomIterator);
		if(valueSize > 0) {
			void * value = BOMTreeIteratorValue(bomIterator);
			if(value != NULL) {
				keyValue = [NSData dataWithBytes:value length:valueSize];
			}
		}
		
		if(keyData != nil) {
			keyValueCallback(keyData, keyValue);
		}
		
		// Next item in the tree
		BOMTreeIteratorNext(bomIterator);
	}
}
```

现在我们可以访问 BOM 的内容，让我们看看不同的块和树。

## CARHEADER 块

`CARHEADER` 块包含有关文件中素材数量的信息以及版本信息。它的固定大小为 436 字节。 可以使用前面介绍的 `GetDataFromBomBlock()` 方法来访问数据 ：

```c
NSData *blockData = GetDataFromBomBlock(bomStorage, "CARHEADER");
if(blockData != nil) {
	struct carheader *carHeader = (struct carheader *)[blockData bytes];
	[...]
}
```

为了帮助理解这些结构，我使用了具有自定义创建语法的应用程序 [Synalyze It! Pro](https://www.synalysis.net/) 来解析各种数据块。在 Synalyze It! Pro 中 `CARHEADER`  的结构如下所示：

![img](https://blog.timac.org/2018/1018-reverse-engineering-the-car-file-format/carheader.png)

逆向出的结构很简单，我们可以看到数据以标签 `CTAR` 开头：

```c
struct carheader {
    uint32_t tag;								// 'CTAR'
    uint32_t coreuiVersion;
    uint32_t storageVersion;
    uint32_t storageTimestamp;
    uint32_t renditionCount;
    char mainVersionString[128];
    char versionString[256];
    uuid_t uuid;
    uint32_t associatedChecksum;
    uint32_t schemaVersion;
    uint32_t colorSpaceID;
    uint32_t keySemantics;
} __attribute__((packed));
```

以下是解析演示素材时看到的内容：

```text
CARHEADER:
	 coreuiVersion: 498
	 storageVersion: 15
	 storageTimestamp: 1539543253 (2018-10-14T18:54:13Z)
	 renditionCount: 7
	 mainVersionString: @(#)PROGRAM:CoreUI  PROJECT:CoreUI-498.40.1
	 versionString: IBCocoaTouchImageCatalogTool-10.0
	 uuid: 9EA56D07-3242-4F88-8BC1-C16C25EA65F2
	 associatedChecksum: 0x79965D18
	 schemaVersion: 2
	 colorSpaceID: 1
	 keySemantics: 2
```

## EXTENDED_METADATA 块

The `EXTENDED_METADATA` 块的固定大小为 1028 字节，并包含一些额外信息：

![img](https://blog.timac.org/2018/1018-reverse-engineering-the-car-file-format/extendedMetadata.png)

结构很简单，并且以标记 `META` 开始:

```c
struct carextendedMetadata {
    uint32_t tag;								// 'META'
    char thinningArguments[256];
    char deploymentPlatformVersion[256];
    char deploymentPlatform[256];
    char authoringTool[256];
} __attribute__((packed));
```

以下是您在分析此类块时可以看到的内容：

```text
EXTENDED_METADATA:
	 thinningArguments: 
	 deploymentPlatformVersion: 12.0
	 deploymentPlatform: ios
	 authoringTool: @(#)PROGRAM:CoreThemeDefinition  PROJECT:CoreThemeDefinition-346.29
```

## APPEARANCEKEYS 树

在我们查看更复杂的树之前，让我们从 `APPEARANCEKEYS`  树开始。此树用于支持 macOS Mojave 中的新的暗模式。由于 iOS 中没有暗模式，因此你不会从 iOS 应用程序的 `car` 文件的看到 `APPEARANCEKEYS` 树 —— 至少在 iOS 12 及更早版本中不会。

> 在 iOS 13 中就会了

在这棵树中，键是外观名称（字符串），而值是外观唯一标识符（uint16_t）。因此解析键/值对是轻而易举的：

```objc
ParseBOMTree(bomStorage, "APPEARANCEKEYS", ^(NSData *inKey, NSData *inValue) {
	NSString *appearanceName = [[NSString alloc] initWithBytes:[inKey bytes] length:[inKey length] encoding:NSUTF8StringEncoding];
	uint16_t appearanceIdentifier = 0;
	if(inValue != nil) {
		appearanceIdentifier = *(uint16_t *)([inValue bytes]);
	}
	
	fprintf(stderr, "\t '%s': %u\n", [appearanceName UTF8String], appearanceIdentifier);
});
```

例如，在 macOS `car` 文件上运行此代码会生成：

```text
Tree APPEARANCEKEYS
	 'NSAppearanceNameAccessibilityDarkAqua': 6
	 'NSAppearanceNameAccessibilitySystem': 3
	 'NSAppearanceNameDarkAqua': 1
	 'NSAppearanceNameSystem': 0
```

## FACETKEYS 树

 `FACETKEYS`  树包含维面名称 —— 这是素材名称的同义词 - 用于键及其属性的值。例如，对于演示素材中的键 `MyColor` 来说，我们可以看到其值：

```text
<00000000 03000100 55000200 D9001100 9FAF>
```

该值是一个包含属性列表的 `renditionkeytoken` 结构：

```c
struct renditionkeytoken {
  struct {
    uint16_t x;
    uint16_t y;
  } cursorHotSpot;
  
  uint16_t numberOfAttributes;
  struct renditionAttribute attributes[];
} __attribute__((packed));
```

 `cursorHotSpot` 字段似乎是旧光标功能的遗物。在这之后，我们可以看到属性的数量，然后是属性列表。 属性本身是具有名称和值的简单结构的键/值对：

```c
struct renditionAttribute {
	uint16_t name;
	uint16_t value;
} __attribute__((packed));
```

有一组可能的属性名称：

```c
enum RenditionAttributeType {
	kRenditionAttributeType_ThemeLook       = 0,
	kRenditionAttributeType_Element	        = 1,
	kRenditionAttributeType_Part		= 2,
	kRenditionAttributeType_Size		= 3,
	kRenditionAttributeType_Direction	= 4,
	kRenditionAttributeType_placeholder	= 5,
	kRenditionAttributeType_Value	        = 6,
	kRenditionAttributeType_ThemeAppearance = 7,
	kRenditionAttributeType_Dimension1  = 8,
	kRenditionAttributeType_Dimension2  = 9,
	kRenditionAttributeType_State       = 10,
	kRenditionAttributeType_Layer       = 11,
	kRenditionAttributeType_Scale       = 12,
	kRenditionAttributeType_Unknown13   = 13,
	kRenditionAttributeType_PresentationState = 14,
	kRenditionAttributeType_Idiom	          = 15,
	kRenditionAttributeType_Subtype		  = 16,
	kRenditionAttributeType_Identifier	  = 17,
	kRenditionAttributeType_PreviousValue	  = 18,
	kRenditionAttributeType_PreviousState	  = 19,
	kRenditionAttributeType_HorizontalSizeClass     = 20,
	kRenditionAttributeType_VerticalSizeClass	= 21,
	kRenditionAttributeType_MemoryLevelClass	= 22,
	kRenditionAttributeType_GraphicsFeatureSetClass = 23,
	kRenditionAttributeType_DisplayGamut		= 24,
	kRenditionAttributeType_DeploymentTarget	= 25
};
```

了解结构后，可以使用以下代码解析 `FACETKEYS` 树：

```objc
ParseBOMTree(bomStorage, "FACETKEYS", ^(NSData *inKey, NSData *inValue)
{
	NSString *facetName = [[NSString alloc] initWithBytes:[inKey bytes] length:[inKey length] encoding:NSUTF8StringEncoding];
	fprintf(stderr, "\t '%s':", [facetName UTF8String]);
	
	const void *bytes = [inValue bytes];
	if(bytes != NULL) {
		struct renditionkeytoken *renditionkeytoken = (struct renditionkeytoken *)bytes;
		uint16_t numberOfAttributes = renditionkeytoken->numberOfAttributes;
		for(uint16_t keyIndex = 0 ; keyIndex < numberOfAttributes ; keyIndex++) {
			struct renditionAttribute renditionAttribute = renditionkeytoken->attributes[keyIndex];
			fprintf(stderr, "\n\t\t %s: %04X", [GetNameOfAttributeType(renditionAttribute.name) UTF8String], renditionAttribute.value);
		}
	}
	
	fprintf(stderr, "\n");
});
```

在示例项目上运行此代码将打印：

```text
Tree FACETKEYS
	 'Image1':
		 Element: 0055
		 Part: 00B5
		 Identifier: 8019
	 'Image2':
		 Element: 0055
		 Part: 00B5
		 Identifier: 0C7A
	 'Image3':
		 Element: 0055
		 Part: 00B5
		 Identifier: 98DB
	 'Image4':
		 Element: 0055
		 Part: 00B5
		 Identifier: 253C
	 'Image5':
		 Element: 0055
		 Part: 00B5
		 Identifier: B19D
	 'Image6':
		 Element: 0055
		 Part: 00B5
		 Identifier: 3DFE
	 'Image7':
		 Element: 0055
		 Part: 00B5
		 Identifier: CA5F
	 'Image8':
		 Element: 0055
		 Part: 00B5
		 Identifier: 56C0
```

## KEYFORMAT 块和 RENDITION 树的`副本键`

正如我们很快将看到的，RENDITION 树存储对（`副本键`、`副本值`）。`副本键`如下所示：

```text
<00000100 00000000 00000000 00000000 00000000 000006fe 5500b500 00000000 00000000>
```

`副本键` 是与 `KEYFORMAT`  块中的属性相对应的值列表。为了理解`副本键`，我们首先需要了解一下 `KEYFORMAT` 块。

以下是演示项目中 `KEYFORMAT` 块的示例：

![img](https://blog.timac.org/2018/1018-reverse-engineering-the-car-file-format/KeyFormat.png)

`KEYFORMAT` 块的结构以标签 `kfmt` 开头：

```c
struct renditionkeyfmt {
    uint32_t tag;								// 'kfmt'
    uint32_t version;
    uint32_t maximumRenditionKeyTokenCount;
    uint32_t renditionKeyTokens[];
} __attribute__((packed));
```

可以使用以下代码解析此块：

```objc
NSData *blockData = GetDataFromBomBlock(bomStorage, "KEYFORMAT");
if(blockData != nil) {
	struct renditionkeyfmt *keyFormat = (struct renditionkeyfmt *)[blockData bytes];
	
	fprintf(stderr, "\nKEYFORMAT:\n"
		"\t maximumRenditionKeyTokenCount: %u\n",
		keyFormat->maximumRenditionKeyTokenCount);
	
	for(uint32_t renditionKeyTokenIndex = 0 ; renditionKeyTokenIndex < keyFormat->maximumRenditionKeyTokenCount ; renditionKeyTokenIndex++) {
		NSString *attributeName = GetNameOfAttributeType(keyFormat->renditionKeyTokens[renditionKeyTokenIndex]);
		fprintf(stderr, "\t renditionKeyTokens: %s\n", [attributeName UTF8String]);
		[keyFormatStrings addObject:attributeName];
	}
}
```

在示例项目上运行此代码，我们得到：

```text
KEYFORMAT:
	 maximumRenditionKeyTokenCount: 18
	 renditionKeyTokens: Theme Appearance
	 renditionKeyTokens: Scale
	 renditionKeyTokens: Idiom
	 renditionKeyTokens: Subtype
	 renditionKeyTokens: Deployment Target
	 renditionKeyTokens: Graphics Feature Set Class
	 renditionKeyTokens: Memory Level Class
	 renditionKeyTokens: Display Gamut
	 renditionKeyTokens: Direction
	 renditionKeyTokens: Horizontal Size Class
	 renditionKeyTokens: Vertical Size Class
	 renditionKeyTokens: Identifier
	 renditionKeyTokens: Element
	 renditionKeyTokens: Part
	 renditionKeyTokens: State
	 renditionKeyTokens: Value
	 renditionKeyTokens: Dimension 1
	 renditionKeyTokens: Dimension 2
```

现在我们有了来自 `KEYFORMAT` 块的属性列表，我们可以解码来自 `RENDITION` 树的`副本键` 示例：

```text
 Key '<00000100 00000000 00000000 00000000 00000000 000006fe 5500b500 00000000 00000000>'
	 Theme Appearance: 0000
	 Scale: 0001
	 Idiom: 0000
	 Subtype: 0000
	 Deployment Target: 0000
	 Graphics Feature Set Class: 0000
	 Memory Level Class: 0000
	 Display Gamut: 0000
	 Direction: 0000
	 Horizontal Size Class: 0000
	 Vertical Size Class: 0000
	 Identifier: FE06
	 Element: 0055
	 Part: 00B5
	 State: 0000
	 Value: 0000
	 Dimension 1: 0000
	 Dimension 2: 0000
```

如我们所见，此`副本键`对应于具有标识符 `FE06` 和 `比例`为 @1x 的维面。使用 `FACETKEYS` 树，我们可以看到此`副本键`对应的 `MyPDF` 素材。

## RENDITION 树

`RENDITION` 树是一个包含素材数据的复杂结构。键是我们已经分析过的`副本键`，而值是一些报头前缀的素材数据。

由于结构很复杂，我们从查看示例项目中的文本文件开始。这是包含 `blog.timac.org` 内容的 `text.txt` 文件的副本数据：

![img](https://blog.timac.org/2018/1018-reverse-engineering-the-car-file-format/RenditionTextHex.png)

`副本键`由 3 部分组成：

- `csiheader` 报头，适用于所有类型的再现。该报头的固定长度为 184 字节。
- TLV（类型-长度-值）列表，其长度在 `csiheader`  报头中指定。它包含有关无法容纳在 `csiheader` 报头中的扩展信息，例如素材中的 UTI。
- 副本数据以特定于副本类型的报头开始，后跟素材的数据。根据副本类型的不同，数据可以是压缩的，也可以是解压缩的。

以下是使用 Synalyze It! Pro 制作的屏幕截图，用于可视化这 3 个部分：

- `csiheader` 头部为蓝色。
- TLV 列表为绿色。
- 副本数据为橙色。

![img](https://blog.timac.org/2018/1018-reverse-engineering-the-car-file-format/RenditionData.png)

### csiheader

如前所述，副本的值以包含关于素材的各种信息的固定长度的报头（184 字节）开始：

```c
struct csiheader {
    uint32_t tag;								// 'CTSI'
    uint32_t version;
    struct renditionFlags renditionFlags;
    uint32_t width;
    uint32_t height;
    uint32_t scaleFactor;
    uint32_t pixelFormat;
	struct {
		uint32_t colorSpaceID:4;
		uint32_t reserved:28;
    } colorSpace;
    struct csimetadata csimetadata;
    struct csibitmaplist csibitmaplist;
} __attribute__((packed));
```

- 该`标签`的值设置为 `CTSI`，它似乎是 `Core Theme Structured Image` 的首字母缩写。
- `version` 值始终为 1。
- `renditionFlags`  是一个 32 位整数，其位表示副本的某些属性：

```c
struct renditionFlags { 
  uint32_t isHeaderFlaggedFPO:1; 
  uint32_t isExcludedFromContrastFilter:1; 
  uint32_t isVectorBased:1; 
  uint32_t isOpaque:1; 
  uint32_t bitmapEncoding:4; 
  uint32_t optOutOfThinning:1; 
  uint32_t isFlippable:1; 
  uint32_t isTintable:1; 
  uint32_t preservedVectorRepresentation:1; 
  uint32_t reserved:20; 
} attribute((packed));
```

`width` 和 `height` 以像素为单位描述图像的大小。如果该素材没有宽度或高度，值为 0。

`scaleFactor` 是比例值，其值乘以 100。例如，@2x 图像的 `scaleFactor` 值为 200。

`pixelFormat` 可以包含多个值，具体取决于副本素材的类型，如： `ARGB`，`GA8`，`RGB5`，`RGBW`，`GA16`， `JPEG`， `HEIF`，`DATA`…

`colorSpaceID` 标识应该使用哪个颜色空间。从 MacOS Mojave 和 iOS 12 开始，可以支持 6 种不同的颜色空间：

```objc
NSString *GetColorSpaceNameWithID(int64_t inColorSpaceID) { 
  switch (inColorSpaceID) { 
    case 0: 
    default: { 
      return @"SRGB";
    } 
      break;
    case 1: {
      return @"GrayGamma2_2";
    }
      break;
    case 2: {
        return @"DisplayP3";
    }
      break;
    case 3: {
      return @"ExtendedRangeSRGB";
    }
      break;
    case 4: {
      return @"ExtendedLinearSRGB";
    }
      break;
    case 5: {
      return @"ExtendedGray";
    }
      break;
  }
}
```

* `csimetadata` 结构包含有关素材的一些重要信息：名称、布局和修改时间。

```c
struct csimetadata { 
  uint32_t modtime; 
  uint16_t layout; 
  uint16_t zero; 
  char name[128]; 
} __attribute__((packed)); 
```

`layout` 字段特别有趣，因为它标识存储的**数据**的类型：图像、**数据**、纹理、颜色…… 对于图像，**子类型存储在布局中**：

```c
enum RenditionLayoutType { 
    kRenditionLayoutType_TextEffect = 0x007,
    kRenditionLayoutType_Vector = 0x009,
    kRenditionLayoutType_Data = 0x3E8,
    kRenditionLayoutType_ExternalLink = 0x3E9,
    kRenditionLayoutType_LayerStack = 0x3EA,
    kRenditionLayoutType_InternalReference = 0x3EB,
    kRenditionLayoutType_PackedImage = 0x3EC,
    kRenditionLayoutType_NameList = 0x3ED,
    kRenditionLayoutType_UnknownAddObject = 0x3EE,
    kRenditionLayoutType_Texture = 0x3EF,
    kRenditionLayoutType_TextureImage = 0x3F0,
    kRenditionLayoutType_Color = 0x3F1,
    kRenditionLayoutType_MultisizeImage = 0x3F2,
    kRenditionLayoutType_LayerReference = 0x3F4,
    kRenditionLayoutType_ContentRendition = 0x3F5,
    kRenditionLayoutType_RecognitionObject = 0x3F6,
};

enum CoreThemeImageSubtype {
    kCoreThemeOnePartFixedSize = 10, 
    kCoreThemeOnePartTile = 11, 
    kCoreThemeOnePartScale = 12, 
    kCoreThemeThreePartHTile = 20, 
    kCoreThemeThreePartHScale = 21, 
    kCoreThemeThreePartHUniform = 22, 
    kCoreThemeThreePartVTile = 23, 
    kCoreThemeThreePartVScale = 24, 
    kCoreThemeThreePartVUniform = 25, 
    kCoreThemeNinePartTile = 30, 
    kCoreThemeNinePartScale = 31, 
    kCoreThemeNinePartHorizontalUniformVerticalScale = 32, 
    kCoreThemeNinePartHorizontalScaleVerticalUniform = 33, 
    kCoreThemeNinePartEdgesOnly = 34, 
    kCoreThemeManyPartLayoutUnknown = 40, 
    kCoreThemeAnimationFilmstrip = 50 
}; 
```

* 最后，`csibitmaplist` 包含副本数据的大小（`renditionLength`）。后面紧跟着 TLV（类型长度值）列表，其长度写在 `tvlLength` 字段中：

```c
struct csibitmaplist { 
  uint32_t tvlLength; // Length of all the TLV following the csiheader 
  uint32_t unknown; 
  uint32_t zero; 
  uint32_t renditionLength; 
} __attribute__((packed));
```

使用上述结构，我们可以在 Synalyze It! Pro 中创建自定义语法以快速理解该结构：

![img](https://blog.timac.org/2018/1018-reverse-engineering-the-car-file-format/RenditionText.png)

### TVL

紧跟着 `csiheader` 末尾的 `csibitmaplist` 之后，有一个 TLV（类型长度值）列表。对于文本文件，TLV 数据为：

```text
<EC030000 08000000 00000000 0000803F EE030000 04000000 01000000>
```

以下是可能的标签列表：

```c
enum RenditionTLVType {
	kRenditionTLVType_Slices 				= 0x3E9,
	kRenditionTLVType_Metrics 				= 0x3EB,
	kRenditionTLVType_BlendModeAndOpacity	= 0x3EC,
	kRenditionTLVType_UTI	 				= 0x3ED,
	kRenditionTLVType_EXIFOrientation		= 0x3EE,
	kRenditionTLVType_ExternalTags			= 0x3F0,
	kRenditionTLVType_Frame					= 0x3F1,
};
```

以下代码可用于转储 TLV：

```c
// Print the TLV
uint32_t tvlLength = csiHeader->csibitmaplist.tvlLength;
if(tvlLength > 0) {
	fprintf(stderr, "\t\t\t tlv:\n");
	
	const void *tlvBytes = valueBytes + sizeof(*csiHeader);
	const void *tlvPos = tlvBytes;
	
	while(tlvBytes + tvlLength > tlvPos) {
		uint32_t tlvTag = *(uint32_t *)tlvPos;
		uint32_t tlvLength = *(uint32_t *)(tlvPos + 4);
		
		fprintf(stderr, "\t\t\t\t %s: " , [GetTLVTNameWithType(tlvTag) UTF8String]);
		for(uint32_t valuePos = 0 ; valuePos < tlvLength ; valuePos++) {
			fprintf(stderr, "%02X" , *(uint8_t*)(tlvPos + 8 + valuePos));
		}
		
		fprintf(stderr, "\n");
		
		tlvPos += 8 + tlvLength;
	}
}
```

在文本文件上运行此代码可以获得以下信息：

```text
tlv:
	BlendModeAndOpacity: 000000000000803F
	EXIFOrientation: 01000000
```

对 PDF 素材来说，我们清楚地看到 `com.adobe.pdf` UTI：

```text
tlv:
	BlendModeAndOpacity: 000000000000803F
	UTI: 0E00000000000000636F6D2E61646F62652E70646600
	EXIFOrientation: 01000000
```

## 不同类型的副本

在这些复杂的结构之后可以看到副本数据。它包含特定副本类型的报头，后跟压缩或未压缩的实际数据。长度设置在 `csibitmaplist` 结构的 `renditionLength` 字段中。

对于文本文件，副本数据包含一个简单的标题，后接字符串 `blog.timac.org`：

```text
<44574152 00000000 0E000000 626C6F67 2E74696D 61632E6F 7267>
```

然而，副本数据并不总是那么简单。事实上，截至 macOS Mojave，共有 21 种类型的副本：

- CUIRawDataRendition
- CUIRawPixelRendition
- CUIThemeColorRendition
- CUIThemePixelRendition
- CUIPDFRendition
- CUIThemeModelMeshRendition
- CUIMutableThemeRendition
- CUIThemeEffectRendition
- CUIThemeMultisizeImageSetRendition
- CUIThemeGradientRendition
- CUIExternalLinkRendition
- CUIThinningPlaceholderRendition
- CUIThemeTextureRendition
- CUIThemeTextureImageRendition
- CUIInternalLinkRendition
- CUINameContentRendition
- CUIThemeSchemaRendition
- CUIThemeSchemaEffectRendition
- CUIThemeModelAssetRendition

和 2 种 CUIRawDataRendition 的子类型：

- CUILayerStackRendition
- CUIRecognitionObjectRendition

`csiheader` 报头的 `pixelFormat` 和 `layout` 字段用于了解应使用哪种副本类型。在本文中，我将仅描述 4 种最常见的副本类型：

- CUIRawDataRendition：pixelFormat 设置为 `DATA`，布局设置为 kRenditionLayoutType_Data
- CUIRawPixelRendition：pixelFormat 为 `JPEG` 或 `HEIF`。布局设置为图像的子类型。
- CUIThemeColorRendition：pixelFormat 为 0，布局为 kRenditionLayoutType_Color
- CUIThemePixelRendition：pixelFormat 设置为 `ARGB`、`GA8`、`RGB5`、`RGBW` 或 `GA16`，而布局设置为图像子类型。

### CUIRawDataRendition

让我们从文本文件使用的 `CUIRawDataRendition` 副本类型开始。正如我们所见，结构很简单：

```c
struct CUIRawDataRendition {
    uint32_t tag;					// RAWD
    uint32_t version;
    uint32_t rawDataLength;
	uint8_t rawData[];
} __attribute__((packed));
```

以下是解析 CUIRawDataRendition 以恢复原始数据的代码：

```c
if(csiHeader->pixelFormat == 'DATA') {
	struct CUIRawDataRendition *rawDataRendition = (struct CUIRawDataRendition *)renditionBytes;
	if(rawDataRendition->tag == 'RAWD') {
		uint32_t rawDataLength = rawDataRendition->rawDataLength;
		uint8_t *rawData = rawDataRendition->rawData;
		if(rawDataLength > 4) {
			fprintf(stderr, "\t\t\t Found RawDataRendition with size %u: 0x%02X%02X%02X%02X...\n", rawDataLength, *(uint8_t*)rawData, *(uint8_t*)(rawData + 1), *(uint8_t*)(rawData + 2), *(uint8_t*)(rawData + 3));
		}
		else {
			fprintf(stderr, "\t\t\t Found RawDataRendition with size %u\n", rawDataLength);
		}
	}
}
```

### CUIRawPixelRendition

用于存储 `JPEG`  和 `HEIF` 的 CUIRawPixelRendition 结构与 CUIRawDataRendition 结构相同：

```c
struct CUIRawPixelRendition {
    uint32_t tag;					// RAWD
    uint32_t version;
    uint32_t rawDataLength;
	uint8_t rawData[];
} __attribute__((packed));
```

恢复图像的代码也很简单：

```objc
else if(csiHeader->pixelFormat == 'JPEG' || csiHeader->pixelFormat == 'HEIF') {
	struct CUIRawPixelRendition *rawPixelRendition = (struct CUIRawPixelRendition *)renditionBytes;
	if(rawPixelRendition->tag == 'RAWD') {
		uint32_t rawDataLength = rawPixelRendition->rawDataLength;
		uint8_t *rawDataBytes = rawPixelRendition->rawData;
		
		NSData *rawData = [[NSData alloc] initWithBytes:rawDataBytes length:rawDataLength];
		CGImageSourceRef sourceRef = CGImageSourceCreateWithData((CFDataRef)rawData, NULL);
		CGImageRef imageRef = CGImageSourceCreateImageAtIndex(sourceRef, 0, NULL);
		fprintf(stderr, "\t\t\t Found RawPixelRendition of size (%ld x %ld) with rawDataLength %u\n", CGImageGetWidth(imageRef), CGImageGetHeight(imageRef), rawDataLength);
		CFRelease(imageRef);
		CFRelease(sourceRef);
	}
}
```

通过在 Xcode 中运行此代码，我们可以使用 QuickLook 插件查看恢复的图像：

![img](https://blog.timac.org/2018/1018-reverse-engineering-the-car-file-format/CUIRawPixelRendition.png)

### CUIThemeColorRendition

CUIThemeColorRendition 副本用于存储已命名色值并包含：

- 色彩组成的数量

  >  color components 是一种元信息，主要存在于图像文件中，本文中译为色彩组成。

- 色彩组成的值

- 色彩空间

```c
struct csicolor {
	uint32_t tag;					// COLR
	uint32_t version;
	struct {
		uint32_t colorSpaceID:8;
		uint32_t unknown0:3;
		uint32_t reserved:21;
    } colorSpace;
	uint32_t numberOfComponents;
	double components[];
} __attribute__((packed));
```

可以使用以下代码访问 `CGColorRef`：

```objc
else if(csiHeader->pixelFormat == 0 && csiHeader->csimetadata.layout == kRenditionLayoutType_Color) {
	struct csicolor *colorRendition = (struct csicolor *)renditionBytes;
	
	if(colorRendition->numberOfComponents == 4) {
		// Use the hardcoded DeviceRGB color space instead of the real colorSpace from the colorSpaceID
		CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
		CGColorRef __unused theColor = CGColorCreate(colorSpaceRef, colorRendition->components);
		CFRelease(theColor);
		CFRelease(colorSpaceRef);
		
		NSString *colorString = [NSString stringWithFormat:@"%f,%f,%f,%f", colorRendition->components[0], colorRendition->components[1], colorRendition->components[2], colorRendition->components[3]];
		fprintf(stderr, "\n\t\t Found Color %s with colorspace ID %d\n", [colorString UTF8String], colorRendition->colorSpace.colorSpaceID & 0xFF);
	}
  else {
		fprintf(stderr, "\n\t\t Found Color with colorspace ID %d but with %u components\n", colorRendition->colorSpace.colorSpaceID & 0xFF, colorRendition->numberOfComponents);
	}
}
```

通过在 Xcode 中运行此代码，可以使用 QuickLook 插件查看恢复的 `CGColorRef`：

![img](https://blog.timac.org/2018/1018-reverse-engineering-the-car-file-format/RenditionColor.png)

### CUIThemePixelRendition

并不是所有的结构都这么简单，例如用于 PNG 图像的 CUIThemePixelRendition 就稍微复杂一些。与其他类型的副本一样，CUIThemePixelRendition 具有特定的报头：

```c
struct CUIThemePixelRendition {
    uint32_t tag;					// 'CELM'
    uint32_t version;
    uint32_t compressionType;
    uint32_t rawDataLength;
	uint8_t rawData[];
} __attribute__((packed));
```

- `tag` 的值设为 `CELM`

- `version` 始终设为 0

- `compressionType` 被设置为以下某个选项：

  ```c
  enum RenditionCompressionType { 
      kRenditionCompressionType_uncompressed = 0,
      kRenditionCompressionType_rle, 
      kRenditionCompressionType_zip, 
      kRenditionCompressionType_lzvn, 
      kRenditionCompressionType_lzfse, 
      kRenditionCompressionType_jpeg_lzfse, 
      kRenditionCompressionType_blurred, 
      kRenditionCompressionType_astc, 
      kRenditionCompressionType_palette_img, 
      kRenditionCompressionType_deepmap_lzfse, 
  }; 
  ```

当**使用**压缩时，原数据会被压缩，然后需要使用相应的算法进行解码。具体所使用的解压缩算法超出了**本文的范围**。

* `rawDataLength` 包含 `rawData` 的大小。

* 最后 `rawData` 包含真实数据 —— 未压缩或压缩。如果数据被压缩，你需要使用  `compressionType`  字段中指定的算法对其进行解压缩。

下面是 PNG 格式的副本在 Synalyze It! Pro 中的展示。注：用红色表示的是压缩的原数据：

![img](https://blog.timac.org/2018/1018-reverse-engineering-the-car-file-format/CUIThemePixelRendition.png)

## 总结

`.car` 文件可以存储许多不同类型的资产，这使得这种文件格式相当复杂。在本文中，我描述了最重要的结构以及如何转储它们。类似的方法可应用于分析和理解其他结构。

`CARParser` 应用程序的完整源代码可以从[此处下载](https://blog.timac.org/2018/1018-reverse-engineering-the-car-file-format/CARParser.zip)。你可以很容易地修改此工具，以生成与 `assetutil -I Assets.car` 相同的输出。

这是在演示项目上运行 `CARParser` 时你将看到的输出：

```text
CARHEADER:
	 coreuiVersion: 498
	 storageVersion: 15
	 storageTimestamp: 1539543253 (2018-10-14T18:54:13Z)
	 renditionCount: 7
	 mainVersionString: @(#)PROGRAM:CoreUI  PROJECT:CoreUI-498.40.1
	 versionString: IBCocoaTouchImageCatalogTool-10.0
	 uuid: 9EA56D07-3242-4F88-8BC1-C16C25EA65F2
	 associatedChecksum: 0x79965D18
	 schemaVersion: 2
	 colorSpaceID: 1
	 keySemantics: 2

EXTENDED_METADATA:
	 thinningArguments: 
	 deploymentPlatformVersion: 12.0
	 deploymentPlatform: ios
	 authoringTool: @(#)PROGRAM:CoreThemeDefinition  PROJECT:CoreThemeDefinition-346.29

KEYFORMAT:
	 maximumRenditionKeyTokenCount: 18
	 renditionKeyTokens: Theme Appearance
	 renditionKeyTokens: Scale
	 renditionKeyTokens: Idiom
	 renditionKeyTokens: Subtype
	 renditionKeyTokens: Deployment Target
	 renditionKeyTokens: Graphics Feature Set Class
	 renditionKeyTokens: Memory Level Class
	 renditionKeyTokens: Display Gamut
	 renditionKeyTokens: Direction
	 renditionKeyTokens: Horizontal Size Class
	 renditionKeyTokens: Vertical Size Class
	 renditionKeyTokens: Identifier
	 renditionKeyTokens: Element
	 renditionKeyTokens: Part
	 renditionKeyTokens: State
	 renditionKeyTokens: Value
	 renditionKeyTokens: Dimension 1
	 renditionKeyTokens: Dimension 2

Tree APPEARANCEKEYS

Tree FACETKEYS
	 'MyColor':
		 Element: 0055
		 Part: 00D9
		 Identifier: AF9F
	 'MyJPG':
		 Element: 0055
		 Part: 00B5
		 Identifier: BCAD
	 'MyPDF':
		 Element: 0055
		 Part: 00B5
		 Identifier: FE06
	 'MyPNG':
		 Element: 0055
		 Part: 00B5
		 Identifier: 7F71
	 'MyText':
		 Element: 0055
		 Part: 00B5
		 Identifier: 9236

Tree RENDITIONS

	 Key '<00000100 00000000 00000000 00000000 00000000 000006fe 5500b500 00000000 00000000>'
		 Theme Appearance: 0000
		 Scale: 0001
		 Idiom: 0000
		 Subtype: 0000
		 Deployment Target: 0000
		 Graphics Feature Set Class: 0000
		 Memory Level Class: 0000
		 Display Gamut: 0000
		 Direction: 0000
		 Horizontal Size Class: 0000
		 Vertical Size Class: 0000
		 Identifier: FE06
		 Element: 0055
		 Part: 00B5
		 State: 0000
		 Value: 0000
		 Dimension 1: 0000
		 Dimension 2: 0000

		 csiHeader:
			 version: 1
			 renditionFlags: bitmapEncoding 0
			 width: 0
			 height: 0
			 scaleFactor: 100 (@1x)
			 pixelFormat: 'DATA' (0x44415441)
			 colorSpaceID: 1
			 modtime: 0
			 layout: Data
			 name: CoreStructuredImage
			 tvlLength: 58
			 renditionLength: 7296
			 tlv:
				 BlendModeAndOpacity: 000000000000803F
				 UTI: 0E00000000000000636F6D2E61646F62652E70646600
				 EXIFOrientation: 01000000
			 Found RawDataRendition with size 7284: 0x25504446...

	 Key '<00000100 00000000 00000000 00000000 00000000 00003692 5500b500 00000000 00000000>'
		 Theme Appearance: 0000
		 Scale: 0001
		 Idiom: 0000
		 Subtype: 0000
		 Deployment Target: 0000
		 Graphics Feature Set Class: 0000
		 Memory Level Class: 0000
		 Display Gamut: 0000
		 Direction: 0000
		 Horizontal Size Class: 0000
		 Vertical Size Class: 0000
		 Identifier: 9236
		 Element: 0055
		 Part: 00B5
		 State: 0000
		 Value: 0000
		 Dimension 1: 0000
		 Dimension 2: 0000

		 csiHeader:
			 version: 1
			 renditionFlags: bitmapEncoding 0
			 width: 0
			 height: 0
			 scaleFactor: 100 (@1x)
			 pixelFormat: 'DATA' (0x44415441)
			 colorSpaceID: 14
			 modtime: 0
			 layout: Data
			 name: text.txt
			 tvlLength: 28
			 renditionLength: 26
			 tlv:
				 BlendModeAndOpacity: 000000000000803F
				 EXIFOrientation: 01000000
			 Found RawDataRendition with size 14: 0x626C6F67...

	 Key '<00000100 00000000 00000000 00000000 00000000 0000717f 5500b500 00000000 00000000>'
		 Theme Appearance: 0000
		 Scale: 0001
		 Idiom: 0000
		 Subtype: 0000
		 Deployment Target: 0000
		 Graphics Feature Set Class: 0000
		 Memory Level Class: 0000
		 Display Gamut: 0000
		 Direction: 0000
		 Horizontal Size Class: 0000
		 Vertical Size Class: 0000
		 Identifier: 7F71
		 Element: 0055
		 Part: 00B5
		 State: 0000
		 Value: 0000
		 Dimension 1: 0000
		 Dimension 2: 0000

		 csiHeader:
			 version: 1
			 renditionFlags: bitmapEncoding 1
			 width: 28
			 height: 28
			 scaleFactor: 100 (@1x)
			 pixelFormat: 'ARGB' (0x41524742)
			 colorSpaceID: 1
			 modtime: 0
			 layout: Image (One Part Scaled)
			 name: Timac.png
			 tvlLength: 104
			 renditionLength: 719
			 tlv:
				 Slices: 0100000000000000000000001C0000001C000000
				 Metrics: 01000000000000000000000000000000000000001C0000001C000000
				 BlendModeAndOpacity: 000000000000803F
				 EXIFOrientation: 01000000
				 Unknown 0x03EF: 80000000

		 Found ThemePixelRendition with size 703 and compression palette-img

	 Key '<00000100 00000000 00000000 00000000 00000000 00009faf 5500d900 00000000 00000000>'
		 Theme Appearance: 0000
		 Scale: 0001
		 Idiom: 0000
		 Subtype: 0000
		 Deployment Target: 0000
		 Graphics Feature Set Class: 0000
		 Memory Level Class: 0000
		 Display Gamut: 0000
		 Direction: 0000
		 Horizontal Size Class: 0000
		 Vertical Size Class: 0000
		 Identifier: AF9F
		 Element: 0055
		 Part: 00D9
		 State: 0000
		 Value: 0000
		 Dimension 1: 0000
		 Dimension 2: 0000

		 csiHeader:
			 version: 1
			 renditionFlags: bitmapEncoding 0
			 width: 0
			 height: 0
			 scaleFactor: 0
			 pixelFormat: 0x0000
			 colorSpaceID: 1
			 modtime: 0
			 layout: Color
			 name: MyColor
			 tvlLength: 28
			 renditionLength: 48
			 tlv:
				 BlendModeAndOpacity: 0000000000000000
				 EXIFOrientation: 01000000

		 Found Color 1.000000,0.000000,0.000000,0.500000 with colorspace ID 1

	 Key '<00000100 00000000 00000000 00000000 00000000 0000adbc 5500b500 00000000 00000000>'
		 Theme Appearance: 0000
		 Scale: 0001
		 Idiom: 0000
		 Subtype: 0000
		 Deployment Target: 0000
		 Graphics Feature Set Class: 0000
		 Memory Level Class: 0000
		 Display Gamut: 0000
		 Direction: 0000
		 Horizontal Size Class: 0000
		 Vertical Size Class: 0000
		 Identifier: BCAD
		 Element: 0055
		 Part: 00B5
		 State: 0000
		 Value: 0000
		 Dimension 1: 0000
		 Dimension 2: 0000

		 csiHeader:
			 version: 1
			 renditionFlags: bitmapEncoding 1
			 width: 0
			 height: 0
			 scaleFactor: 100 (@1x)
			 pixelFormat: 'JPEG' (0x4A504547)
			 colorSpaceID: 14
			 modtime: 0
			 layout: Image (One Part Scaled)
			 name: TimacJPG.jpg
			 tvlLength: 92
			 renditionLength: 7766
			 tlv:
				 Slices: 010000000000000000000000C8000000C8000000
				 Metrics: 0100000000000000000000000000000000000000C8000000C8000000
				 BlendModeAndOpacity: 000000000000803F
				 EXIFOrientation: 01000000
			 Found RawPixelRendition of size (200 x 200) with rawDataLength 7754

	 Key '<00000200 00000000 00000000 00000000 00000000 0000717f 5500b500 00000000 00000000>'
		 Theme Appearance: 0000
		 Scale: 0002
		 Idiom: 0000
		 Subtype: 0000
		 Deployment Target: 0000
		 Graphics Feature Set Class: 0000
		 Memory Level Class: 0000
		 Display Gamut: 0000
		 Direction: 0000
		 Horizontal Size Class: 0000
		 Vertical Size Class: 0000
		 Identifier: 7F71
		 Element: 0055
		 Part: 00B5
		 State: 0000
		 Value: 0000
		 Dimension 1: 0000
		 Dimension 2: 0000

		 csiHeader:
			 version: 1
			 renditionFlags: bitmapEncoding 1
			 width: 56
			 height: 56
			 scaleFactor: 200 (@2x)
			 pixelFormat: 'ARGB' (0x41524742)
			 colorSpaceID: 1
			 modtime: 0
			 layout: Image (One Part Scaled)
			 name: Timac@2x.png
			 tvlLength: 104
			 renditionLength: 814
			 tlv:
				 Slices: 0100000000000000000000003800000038000000
				 Metrics: 01000000000000000000000000000000000000003800000038000000
				 BlendModeAndOpacity: 000000000000803F
				 EXIFOrientation: 01000000
				 Unknown 0x03EF: E0000000

		 Found ThemePixelRendition with size 798 and compression palette-img

	 Key '<00000300 00000000 00000000 00000000 00000000 0000717f 5500b500 00000000 00000000>'
		 Theme Appearance: 0000
		 Scale: 0003
		 Idiom: 0000
		 Subtype: 0000
		 Deployment Target: 0000
		 Graphics Feature Set Class: 0000
		 Memory Level Class: 0000
		 Display Gamut: 0000
		 Direction: 0000
		 Horizontal Size Class: 0000
		 Vertical Size Class: 0000
		 Identifier: 7F71
		 Element: 0055
		 Part: 00B5
		 State: 0000
		 Value: 0000
		 Dimension 1: 0000
		 Dimension 2: 0000

		 csiHeader:
			 version: 1
			 renditionFlags: bitmapEncoding 1
			 width: 84
			 height: 84
			 scaleFactor: 300 (@3x)
			 pixelFormat: 'ARGB' (0x41524742)
			 colorSpaceID: 1
			 modtime: 0
			 layout: Image (One Part Scaled)
			 name: Timac@3x.png
			 tvlLength: 104
			 renditionLength: 1673
			 tlv:
				 Slices: 0100000000000000000000005400000054000000
				 Metrics: 01000000000000000000000000000000000000005400000054000000
				 BlendModeAndOpacity: 000000000000803F
				 EXIFOrientation: 01000000
				 Unknown 0x03EF: 60010000

		 Found ThemePixelRendition with size 1657 and compression palette-img

Tree 'COLORS'

Tree 'FONTS'

Tree 'FONTSIZES'

Tree 'GLYPHS'

Tree 'BEZELS'

Tree 'BITMAPKEYS'
	 Key '' -> <01000000 00000000 4c000000 12000000 ffffffff 0e000000 01000000 01000000 01000000 01000000 01000000 01000000 01000000 01000000 01000000 ffffffff ffffffff ffffffff 01000000 ffffffff 01000000 01000000>
	 Key '' -> <01000000 00000000 4c000000 12000000 ffffffff 02000000 01000000 01000000 01000000 01000000 01000000 01000000 01000000 01000000 01000000 ffffffff ffffffff ffffffff 01000000 ffffffff 01000000 01000000>
	 Key '' -> <01000000 00000000 4c000000 12000000 ffffffff 02000000 01000000 01000000 01000000 01000000 01000000 01000000 01000000 01000000 01000000 ffffffff ffffffff ffffffff 01000000 ffffffff 01000000 01000000>
	 Key '' -> <01000000 00000000 4c000000 12000000 ffffffff 02000000 01000000 01000000 01000000 01000000 01000000 01000000 01000000 01000000 01000000 ffffffff ffffffff ffffffff 01000000 ffffffff 01000000 01000000>
	 Key '' -> <01000000 00000000 4c000000 12000000 ffffffff 02000000 01000000 01000000 01000000 01000000 01000000 01000000 01000000 01000000 01000000 ffffffff ffffffff ffffffff 01000000 ffffffff 01000000 01000000>

Tree 'ELEMENT_INFO'

Tree 'PART_INFO'
```

你可以在这篇文章中找到我的可视化 `.car` 文件的 QuickLook 插件：[可视化 `.car` 文件的 QuickLook 插件（编译后的 Asset Catalogs）](https://blog.timac.org/2018/1112-quicklook-plugin-to-visualize-car-files/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
