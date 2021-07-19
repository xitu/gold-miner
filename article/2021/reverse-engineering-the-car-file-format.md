> * 原文地址：[Reverse engineering the .car file format (compiled Asset Catalogs)](https://blog.timac.org/2018/1018-reverse-engineering-the-car-file-format/)
> * 原文作者：[Timac](https://blog.timac.org/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/reverse-engineering-the-car-file-format.md](https://github.com/xitu/gold-miner/blob/master/article/2021/reverse-engineering-the-car-file-format.md)
> * 译者：
> * 校对者：

# Reverse engineering the .car file format (compiled Asset Catalogs)

An `Asset Catalog` is an important piece of any iOS, tvOS, watchOS and macOS application. It lets you organize and manage the different assets used by an app, such as images, sprites, textures, ARKit resources, colors and data.

Apple is also extending the asset catalog features each year:

* Xcode 9 added support for Color Asset and improve support for vector assets (PDF). See the WWDC 2017 session [What’s New in Cocoa](https://developer.apple.com/videos/play/wwdc2017/207/).
* Xcode 10 added support for High Efficiency Image, Apple Deep Pixel Image Compression, Dark Mode for macOS Mojave. See the WWDC 2018 session [Optimizing App Assets](https://developer.apple.com/videos/play/wwdc2018/227/).

It is less known that an asset catalog is compiled to a `.car` file when the application is built with Xcode. The car file format is evidently not documented by Apple and surprisingly I could not find much information online.

In this article I attempt to remedy this lack of information on the car file format by describing its global structure and its different elements. Along the article, I build a tool `CARParser` to manually parse car files. The complete source code of this tool is available for download at the end of the article.

Note that the documentation in this article and the `CARParser` tool are purely meant for educational purpose. You shouldn’t have to directly deal with car files as done here. There are several tools (including my own that I plan to open source at some point) that can dump the content of a car file. But these tools simply use some private APIs from Apple and don’t directly parse the files. Also as always with reverse engineering, there is no guarantee that the data is fully accurate. At the time of publishing, this article should reflect the state in macOS Mojave and iOS 12. It might however become obsolete with future macOS or iOS releases.

## What are Asset Catalogs?

Asset Catalogs have been introduced in Xcode 5 and make it easier to manage images especially when dealing with multiple resolutions (@1x, @2x, @3x, …). In Xcode, an asset catalog appears as a .xcassets folder and [its use is well described by Apple](https://help.apple.com/xcode/mac/current/#/dev10510b1f7). The .xcassets format on disk is also well described by Apple in the [Asset Catalog Format Reference](https://developer.apple.com/library/content/documentation/Xcode/Reference/xcode_ref-Asset_Catalog_Format/index.html).

For the purpose of this article, I created a simple asset catalog containing various types of assets. This sample asset catalog can be [downloaded here](DemoAssets.xcassets.zip). The corresponding car file can be [downloaded here](Assets.car).

This asset catalog has its deployment target set to iOS 12 and contains:

* a PNG with 3 resolutions @1x, @2x and @3x
* a PDF
* a text file
* a jpg image
* a color (red with 50% transparency)

![](https://blog.timac.org/2018/1018-reverse-engineering-the-car-file-format/DemoAsset.png)

## What is a car file?

When a developer builds an iOS, watchOS, tvOS or macOS app, the asset catalogs containing the various assets (images, icons, textures, …) are not simply copied to the app bundle but they are compiled as car files.

When the application runs on iOS, getting an image from a car file is as simple as performing:

```objc
UIImage *myImage = [UIImage imageNamed:@"MyImage"];

```

When this line is executed, the private CoreUI.framework (/System/Library/PrivateFrameworks/CoreUI.framework) is asked to give the best UIImage corresponding to the asset named `MyImage`. `MyImage` is the `Asset Name`, also called `Facet Name`. The car file can contain multiple images for a given asset name: @1x resolution, @2x resolution, @3x resolution, dark mode, … These representations of the asset are called `renditions`. Each rendition has a unique identifier called the `rendition key`. The rendition key is in fact a list of attributes describing the properties of the rendition: original facet, resolution, …

What is the meaning of the `CAR` extension? It might stand for **C**ompiled **A**sset **R**ecord according to various methods found in the IBFoundation framework in Xcode.

On macOS there are several closed source tools to deal with asset catalogs:

* Xcode lets you edit your asset catalogs and compile them
* `actool` lets you compile, print, update, and verify asset catalogs
* `assetutil` lets you process car files. It can remove unneeded assets from a car file but it can also parse a car file and produce a JSON output.

Running `assetutil -I Assets.car` will print some interesting information about the car file:

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

## A special bom file

Opening a car file in [HexFiend](http://ridiculousfish.com/hexfiend/) reveals some useful information:

![](https://blog.timac.org/2018/1018-reverse-engineering-the-car-file-format/BomStore.png)

The magic value `BOMStore` tells us that a car file is a special `bom` file. BOM - Bill of Materials - is a file format inherited from NeXTSTEP and still used in the macOS installer to determine which files to install, remove, or upgrade. You can find some basic information in `man 5 bom`:

```text
The Mac OS X Installer uses a file system "bill of materials" to determine which files to install, remove, or upgrade. A bill of materials, bom, contains all the files within a directory, along with some information about each file. File information includes: the file's UNIX permissions, its owner and group, its size, its time of last modification, and so on. Also included are a checksum of each file and information about hard links.
```

macOS contains several closed source tools to manipule bom files like `lsbom` and `mkbom`. It is possible to use `lsbom` to inspect the installer receipts located in `/private/var/db/receipts/`. For example running `lsbom /private/var/db/receipts/com.apple.pkg.Numbers5.bom` will print all the files installed by Apple Numbers (path, permissions, UID/GID, size and CRC32 checksum):

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

Sadly the bom file format itself is undocumented and the tools to manipule bom files are not working with car files. Joseph Coffland and Julian Devlin [reimplemented lsbom](https://github.com/cooljeanius/osxbom) and the code contains some useful information about the BOM file format. We can see that a BOM can store among other things blocks and trees.

However contrary to a **regular** bom file, a car file contains several bom ‘blocks’:

* CARHEADER
* EXTENDED_METADATA
* KEYFORMAT
* CARGLOBALS
* KEYFORMATWORKAROUND
* EXTERNAL_KEYS

as well as several databases stored as bom ‘trees’:

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

Some of the blocks and trees are optionals. In this article I only describe the important blocks: `CARHEADER`, `EXTENDED_METADATA`, `KEYFORMAT` as well as the important trees: `FACETKEYS`, `RENDITIONS` and `APPEARANCEKEYS`. The other blocks and trees are generally absent or empty.

## Parsing the BOM

On macOS, the private CoreUI.framework takes care of extracting the assets and thus contains code to parse the BOM. It turns out that it uses the same code as the private Bom.framework located in /System/Library/PrivateFrameworks/Bom.framework. I decided to parse the BOM using this private framework.

Reversing the APIs needed to parse a car file is straightforward by looking at the CoreUI framework calls and I ended up with these C APIs:

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

By using the private APIs of the Bom.framework, accessing the data of the `CARHEADER` block is as easy as executing:

```objc
NSData *blockData = GetDataFromBomBlock(bomStorage, "CARHEADER");
```

where the `GetDataFromBomBlock()` method is implemented as:

```objc
NSData *GetDataFromBomBlock(BOMStorage inBOMStorage, const char *inBlockName)
{
	NSData *outData = nil;
	
	BOMBlockID blockID = BOMStorageGetNamedBlock(inBOMStorage, inBlockName);
	size_t blockSize = BOMStorageSizeOfBlock(inBOMStorage, blockID);
	if(blockSize > 0)
	{
		void *mallocedBlock = malloc(blockSize);
		int res = BOMStorageCopyFromBlock(inBOMStorage, blockID, mallocedBlock);
		if(res == noErr)
		{
			outData = [[NSData alloc] initWithBytes:mallocedBlock length:blockSize];
		}
		
		free(mallocedBlock);
	}
	
	return outData;
}
```

Similarly a simple method can be used to get all the keys/values of a BOM tree. For example to get all the keys/values of the `FACETKEYS` tree, the following lines can be executed:

```objc
ParseBOMTree(bomStorage, "FACETKEYS", ^(NSData *inKey, NSData *inValue)
{
	// This Objective-C block is called for each key found.
	// The value corresponding to the key is passed as parameter.
});
```

where the `ParseBOMTree()` method is implemented as following:

```objc
typedef void (^ParseBOMTreeCallback)(NSData *inKey, NSData *inValue);
void ParseBOMTree(BOMStorage inBOMStorage, const char *inTreeName, ParseBOMTreeCallback keyValueCallback)
{
	NSData *keyData = nil;
	NSData *keyValue = nil;
	
	// Open the BOM tree
	BOMTree bomTree = BOMTreeOpenWithName(inBOMStorage, inTreeName, false);
	if(bomTree == NULL)
		return;

	// Create a BOMTreeIterator and loop until the end
	BOMTreeIterator	bomIterator = BOMTreeIteratorNew(bomTree, NULL, NULL, NULL);
	while(!BOMTreeIteratorIsAtEnd(bomIterator))
	{
		// Get the key
		void * key = BOMTreeIteratorKey(bomIterator);
		size_t keySize = BOMTreeIteratorKeySize(bomIterator);
		keyData = [NSData dataWithBytes:key length:keySize];
		
		// Get the value associated to the key
		size_t valueSize = BOMTreeIteratorValueSize(bomIterator);
		if(valueSize > 0)
		{
			void * value = BOMTreeIteratorValue(bomIterator);
			if(value != NULL)
			{
				keyValue = [NSData dataWithBytes:value length:valueSize];
			}
		}
		
		if(keyData != nil)
		{
			keyValueCallback(keyData, keyValue);
		}
		
		// Next item in the tree
		BOMTreeIteratorNext(bomIterator);
	}
}
```

Now that we can access to the content of the BOM, let’s look at the different blocks and trees.

## CARHEADER block

The `CARHEADER` block contains information about the number of assets in the file as well as versioning information. It has a fixed size of 436 bytes. Accessing the data can be done using the previously explained `GetDataFromBomBlock()`:

```c
NSData *blockData = GetDataFromBomBlock(bomStorage, "CARHEADER");
if(blockData != nil)
{
	struct carheader *carHeader = (struct carheader *)[blockData bytes];
	[...]
}
```

To help understand the structures, I used the [Synalyze It! Pro](https://www.synalysis.net) application with custom created grammars to parse the various blocks of data. Here is how the structure of the `CARHEADER` looks in Synalyze It! Pro:

![](https://blog.timac.org/2018/1018-reverse-engineering-the-car-file-format/carheader.png)

Recovering the structure is straightforward and we can see that the data starts with the tag `CTAR`:

```c
struct carheader
{
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

Here is what you would see when parsing the demo asset:

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

## EXTENDED_METADATA block

The `EXTENDED_METADATA` block has a fixed size of 1028 bytes and contains a couple of extra information:

![](https://blog.timac.org/2018/1018-reverse-engineering-the-car-file-format/extendedMetadata.png)

The structure is simple and starts with the tag `META`:

```c
struct carextendedMetadata {
    uint32_t tag;								// 'META'
    char thinningArguments[256];
    char deploymentPlatformVersion[256];
    char deploymentPlatform[256];
    char authoringTool[256];
} __attribute__((packed));
```

Here is what you could see when dumping such a block:

```text
EXTENDED_METADATA:
	 thinningArguments: 
	 deploymentPlatformVersion: 12.0
	 deploymentPlatform: ios
	 authoringTool: @(#)PROGRAM:CoreThemeDefinition  PROJECT:CoreThemeDefinition-346.29
```

## APPEARANCEKEYS tree

Before we look at the more complex trees, let’s start with the `APPEARANCEKEYS` tree. This tree is used to support the new Dark Mode in macOS Mojave. Since there is no Dark Mode in iOS, you won’t see a `APPEARANCEKEYS` tree for car files for iOS applications - at least not in iOS 12 and earlier.

In this tree, the keys are the appearance names (strings) while the values are the appareance unique identifiers (uint16_t). Parsing the key/value pairs is thus trivial:

```objc
ParseBOMTree(bomStorage, "APPEARANCEKEYS", ^(NSData *inKey, NSData *inValue)
{
	NSString *appearanceName = [[NSString alloc] initWithBytes:[inKey bytes] length:[inKey length] encoding:NSUTF8StringEncoding];
	uint16_t appearanceIdentifier = 0;
	if(inValue != nil)
	{
		appearanceIdentifier = *(uint16_t *)([inValue bytes]);
	}
	
	fprintf(stderr, "\t '%s': %u\n", [appearanceName UTF8String], appearanceIdentifier);
});
```

Running this code on a macOS car file produces for example:

```text
Tree APPEARANCEKEYS
	 'NSAppearanceNameAccessibilityDarkAqua': 6
	 'NSAppearanceNameAccessibilitySystem': 3
	 'NSAppearanceNameDarkAqua': 1
	 'NSAppearanceNameSystem': 0
```

## FACETKEYS tree

The `FACETKEYS` tree contains the facet name - which is a synonym for asset name - for the keys and its attributes for the values. For example for the key `MyColor` in the demo asset, we can see the value:

```text
<00000000 03000100 55000200 D9001100 9FAF>
```

The value is a `renditionkeytoken` structure containing a list of attributes:

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

The `cursorHotSpot` field seems to be a relic of some old cursor features. Following it, we can see the number of attributes followed by the list of attributes. The attributes themselves are key/value pairs with a simple structure with the name and value:

```c
struct renditionAttribute {
	uint16_t name;
	uint16_t value;
} __attribute__((packed));
```

There are a bunch of possible attributes name:

```c
enum RenditionAttributeType
{
	kRenditionAttributeType_ThemeLook 				= 0,
	kRenditionAttributeType_Element					= 1,
	kRenditionAttributeType_Part					= 2,
	kRenditionAttributeType_Size					= 3,
	kRenditionAttributeType_Direction				= 4,
	kRenditionAttributeType_placeholder				= 5,
	kRenditionAttributeType_Value					= 6,
	kRenditionAttributeType_ThemeAppearance			= 7,
	kRenditionAttributeType_Dimension1				= 8,
	kRenditionAttributeType_Dimension2				= 9,
	kRenditionAttributeType_State					= 10,
	kRenditionAttributeType_Layer					= 11,
	kRenditionAttributeType_Scale					= 12,
	kRenditionAttributeType_Unknown13				= 13,
	kRenditionAttributeType_PresentationState		= 14,
	kRenditionAttributeType_Idiom					= 15,
	kRenditionAttributeType_Subtype					= 16,
	kRenditionAttributeType_Identifier				= 17,
	kRenditionAttributeType_PreviousValue			= 18,
	kRenditionAttributeType_PreviousState			= 19,
	kRenditionAttributeType_HorizontalSizeClass		= 20,
	kRenditionAttributeType_VerticalSizeClass		= 21,
	kRenditionAttributeType_MemoryLevelClass		= 22,
	kRenditionAttributeType_GraphicsFeatureSetClass = 23,
	kRenditionAttributeType_DisplayGamut			= 24,
	kRenditionAttributeType_DeploymentTarget		= 25
};
```

Once we know the structures, parsing the `FACETKEYS` tree can be done using the following code:

```objc
ParseBOMTree(bomStorage, "FACETKEYS", ^(NSData *inKey, NSData *inValue)
{
	NSString *facetName = [[NSString alloc] initWithBytes:[inKey bytes] length:[inKey length] encoding:NSUTF8StringEncoding];
	fprintf(stderr, "\t '%s':", [facetName UTF8String]);
	
	const void *bytes = [inValue bytes];
	if(bytes != NULL)
	{
		struct renditionkeytoken *renditionkeytoken = (struct renditionkeytoken *)bytes;
		uint16_t numberOfAttributes = renditionkeytoken->numberOfAttributes;
		for(uint16_t keyIndex = 0 ; keyIndex < numberOfAttributes ; keyIndex++)
		{
			struct renditionAttribute renditionAttribute = renditionkeytoken->attributes[keyIndex];
			fprintf(stderr, "\n\t\t %s: %04X", [GetNameOfAttributeType(renditionAttribute.name) UTF8String], renditionAttribute.value);
		}
	}
	
	fprintf(stderr, "\n");
});
```

Running this code on the demo asset will print:

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

## KEYFORMAT block and the rendition keys of the RENDITION tree

As we will see soon, the `RENDITION` tree stores the pairs (rendition keys, rendition data). A rendition key looks like this:

```text
<00000100 00000000 00000000 00000000 00000000 000006fe 5500b500 00000000 00000000>
```

The rendition key is a list of values corresponding to the attributes in the `KEYFORMAT` block. In order to understand the rendition key, we first need to understand the `KEYFORMAT` block.

Here is an example of `KEYFORMAT` block from the demo asset:

![](https://blog.timac.org/2018/1018-reverse-engineering-the-car-file-format/KeyFormat.png)

The structure of the `KEYFORMAT` block starts with the tag `kfmt`:

```c
struct renditionkeyfmt {
    uint32_t tag;								// 'kfmt'
    uint32_t version;
    uint32_t maximumRenditionKeyTokenCount;
    uint32_t renditionKeyTokens[];
} __attribute__((packed));
```

Parsing this block can be done using the following code:

```objc
NSData *blockData = GetDataFromBomBlock(bomStorage, "KEYFORMAT");
if(blockData != nil)
{
	struct renditionkeyfmt *keyFormat = (struct renditionkeyfmt *)[blockData bytes];
	
	fprintf(stderr, "\nKEYFORMAT:\n"
		"\t maximumRenditionKeyTokenCount: %u\n",
		keyFormat->maximumRenditionKeyTokenCount);
	
	for(uint32_t renditionKeyTokenIndex = 0 ; renditionKeyTokenIndex < keyFormat->maximumRenditionKeyTokenCount ; renditionKeyTokenIndex++)
	{
		NSString *attributeName = GetNameOfAttributeType(keyFormat->renditionKeyTokens[renditionKeyTokenIndex]);
		fprintf(stderr, "\t renditionKeyTokens: %s\n", [attributeName UTF8String]);
		[keyFormatStrings addObject:attributeName];
	}
}
```

When running this code on the demo asset, we get:

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

Now that we have the list of attributes from the `KEYFORMAT` block, we can decode the example of rendition key from the `RENDITION` tree:

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

As we can see, this rendition key corresponds to the facet with the identifier `FE06` and a `scale` of @1x. Using the `FACETKEYS` tree, we can see that this rendition key corresponds to the asset `MyPDF`.

## RENDITION tree

The `RENDITION` tree is a complex structure containing the data of the assets. The keys are the rendition keys that we already analyzed while the values are the asset data prefixed by some headers.

Since the structure is complex, let’s start by looking at the rendition of the text file in the demo asset. Here is the rendition data for a text.txt file containing the content `blog.timac.org`:

![](https://blog.timac.org/2018/1018-reverse-engineering-the-car-file-format/RenditionTextHex.png)

The rendition value is composed of 3 parts:

* the `csiheader` header, common to all the types of renditions. This header has a fixed length of 184 bytes.
* a list of TLV (Type-length-value) whose length is specified in the `csiheader` header. It contains extended informations about the rendition that could not fit in the 184 bytes of the `csiheader` header, like the UTI of the asset.
* the rendition data starting with a header specific to the type of the rendition followed by the data of the asset. The data could be compressed or uncompressed depending of the rendition type.

Here is a screenshot made using Synalyze It! Pro to visualize the 3 parts:

* the `csiheader` header is in blue
* the list of TLV is in green
* the rendition data is in orange.

![](https://blog.timac.org/2018/1018-reverse-engineering-the-car-file-format/RenditionData.png)

### csiheader

As already mentioned, the rendition value starts with a fixed length header (184 bytes) containing various information about the asset:

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

* The `tag` has its value set to `CTSI` which appears to be the acronym for `Core Theme Structured Image`.
* The `version` is always 1.
* The `renditionFlags` is a 32-bit integer whose bits indicate some properties of the rendition:

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
} __attribute__((packed));
```

* The `width` and `height` describe the size in pixels of the images. If the asset has no width or height, these values are set to 0.
* The `scaleFactor` is the scale factor multipled by 100. For example a @2x image has its scaleFactor set to 200.
* The `pixelFormat` can contain multiple values depending on the type of rendition: ‘ARGB’, ‘GA8 ‘, ‘RGB5’, ‘RGBW’, ‘GA16’, ‘JPEG’, ‘HEIF’, ‘DATA’…
* The `colorSpaceID` identifies which color space should be used. As of macOS Mojave and iOS 12, there are 6 different possible color spaces supported:
    
```objc
NSString *GetColorSpaceNameWithID(int64_t inColorSpaceID) { 
    switch (inColorSpaceID) { 
        case 0:
        default: 
            {
                return @"SRGB"; 
            } 
            break;

        case 1:
            {
                return @"GrayGamma2_2";
            }
            break;

        case 2:
            {
                return @"DisplayP3";
            }
            break;

        case 3:
            {
                return @"ExtendedRangeSRGB";
            }
            break;

        case 4:
            {
                return @"ExtendedLinearSRGB";
            }
            break;

        case 5:
            {
                return @"ExtendedGray";
            }
            break;
    }
}
```

* The `csimetadata` structure contains some important informations about the asset: its name, its layout and modification time.

```c
struct csimetadata { 
    uint32_t modtime; 
    uint16_t layout; 
    uint16_t zero; 
    char name[128]; 
} __attribute__((packed)); 
```

The `layout` field is particularly interesting as it identifies the kind of data stored: image, data, texture, color, ... For images a subtype is stored in the layout:

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

* Finally the `csibitmaplist` contains the size of the data of the rendition (renditionLength). This structure is followed by a list of TLV (Type-length-value) whose length is written in the `tvlLength` field:
    
```c
struct csibitmaplist { 
    uint32_t tvlLength; // Length of all the TLV following the csiheader 
    uint32_t unknown; 
    uint32_t zero; 
    uint32_t renditionLength; 
} __attribute__((packed));
```

Using the structure described above, we can create a custom grammar in Synalyze It! Pro to quickly understand the structure:

![](https://blog.timac.org/2018/1018-reverse-engineering-the-car-file-format/RenditionText.png)

### TVL

Following the `csibitmaplist` at the end of the `csiheader`, there is a list of TLV (Type-length-value). In the case of the text file, the TLV data is:

```text
<EC030000 08000000 00000000 0000803F EE030000 04000000 01000000>
```

Here are the list of possible tags:

```c
enum RenditionTLVType
{
	kRenditionTLVType_Slices 				= 0x3E9,
	kRenditionTLVType_Metrics 				= 0x3EB,
	kRenditionTLVType_BlendModeAndOpacity	= 0x3EC,
	kRenditionTLVType_UTI	 				= 0x3ED,
	kRenditionTLVType_EXIFOrientation		= 0x3EE,
	kRenditionTLVType_ExternalTags			= 0x3F0,
	kRenditionTLVType_Frame					= 0x3F1,
};
```

The following code can be used to dump the TLV:

```c
// Print the TLV
uint32_t tvlLength = csiHeader->csibitmaplist.tvlLength;
if(tvlLength > 0)
{
	fprintf(stderr, "\t\t\t tlv:\n");
	
	const void *tlvBytes = valueBytes + sizeof(*csiHeader);
	const void *tlvPos = tlvBytes;
	
	while(tlvBytes + tvlLength > tlvPos)
	{
		uint32_t tlvTag = *(uint32_t *)tlvPos;
		uint32_t tlvLength = *(uint32_t *)(tlvPos + 4);
		
		fprintf(stderr, "\t\t\t\t %s: " , [GetTLVTNameWithType(tlvTag) UTF8String]);
		for(uint32_t valuePos = 0 ; valuePos < tlvLength ; valuePos++)
		{
			fprintf(stderr, "%02X" , *(uint8_t*)(tlvPos + 8 + valuePos));
		}
		
		fprintf(stderr, "\n");
		
		tlvPos += 8 + tlvLength;
	}
}
```

Running this code on the text file gives us:

```text
tlv:
	BlendModeAndOpacity: 000000000000803F
	EXIFOrientation: 01000000
```

On the PDF asset, we clearly see the `com.adobe.pdf` UTI:

```text
tlv:
	BlendModeAndOpacity: 000000000000803F
	UTI: 0E00000000000000636F6D2E61646F62652E70646600
	EXIFOrientation: 01000000
```

### The different types of renditions

The rendition data can be seen after these complex structures. It contains a header specific to the type of the rendition followed by the actual data either compressed or uncompressed. The length is set in the `renditionLength` field of the `csibitmaplist` structure.

In the case of the text file, the rendition data contains a simple header followed by the string `blog.timac.org`:

```text
<44574152 00000000 0E000000 626C6F67 2E74696D 61632E6F 7267>
```

However the rendition data are not always that simple. In fact as of macOS Mojave there are 21 types of renditions:

* CUIRawDataRendition
* CUIRawPixelRendition
* CUIThemeColorRendition
* CUIThemePixelRendition
* CUIPDFRendition
* CUIThemeModelMeshRendition
* CUIMutableThemeRendition
* CUIThemeEffectRendition
* CUIThemeMultisizeImageSetRendition
* CUIThemeGradientRendition
* CUIExternalLinkRendition
* CUIThinningPlaceholderRendition
* CUIThemeTextureRendition
* CUIThemeTextureImageRendition
* CUIInternalLinkRendition
* CUINameContentRendition
* CUIThemeSchemaRendition
* CUIThemeSchemaEffectRendition
* CUIThemeModelAssetRendition

and 2 subclasses of CUIRawDataRendition:

* CUILayerStackRendition
* CUIRecognitionObjectRendition

The `pixelFormat` and `layout` fields of the `csiheader` header are used to know which rendition type should be used. In this article I will only describe the 4 most common rendition types:

* CUIRawDataRendition: pixelFormat is set to ‘DATA’ and layout to kRenditionLayoutType_Data
* CUIRawPixelRendition: pixelFormat is ‘JPEG’ or ‘HEIF’. The layout is set to an image subtype.
* CUIThemeColorRendition: pixelFormat is 0 and layout to kRenditionLayoutType_Color
* CUIThemePixelRendition: pixelFormat is set to ‘ARGB’, ‘GA8 ‘, ‘RGB5’, ‘RGBW’ or ‘GA16’ while the layout is set to an image subtype.

### CUIRawDataRendition

Let’s start with the `CUIRawDataRendition` rendition type which is used by the text file. As we have seen, the structure is simple:

```c
struct CUIRawDataRendition {
    uint32_t tag;					// RAWD
    uint32_t version;
    uint32_t rawDataLength;
	uint8_t rawData[];
} __attribute__((packed));
```

Here is the code to parse the CUIRawDataRendition to recover the original raw data:

```c
if(csiHeader->pixelFormat == 'DATA')
{
	struct CUIRawDataRendition *rawDataRendition = (struct CUIRawDataRendition *)renditionBytes;
	if(rawDataRendition->tag == 'RAWD')
	{
		uint32_t rawDataLength = rawDataRendition->rawDataLength;
		uint8_t *rawData = rawDataRendition->rawData;
		if(rawDataLength > 4)
		{
			fprintf(stderr, "\t\t\t Found RawDataRendition with size %u: 0x%02X%02X%02X%02X...\n", rawDataLength, *(uint8_t*)rawData, *(uint8_t*)(rawData + 1), *(uint8_t*)(rawData + 2), *(uint8_t*)(rawData + 3));
		}
		else
		{
			fprintf(stderr, "\t\t\t Found RawDataRendition with size %u\n", rawDataLength);
		}
	}
}
```

### CUIRawPixelRendition

The structure used by CUIRawPixelRendition to store `JPEG` and `HEIF` is identical to the CUIRawDataRendition structure:

```c
struct CUIRawPixelRendition {
    uint32_t tag;					// RAWD
    uint32_t version;
    uint32_t rawDataLength;
	uint8_t rawData[];
} __attribute__((packed));
```

The code to recover the image is straightforward too:

```
else if(csiHeader->pixelFormat == 'JPEG' || csiHeader->pixelFormat == 'HEIF')
{
	struct CUIRawPixelRendition *rawPixelRendition = (struct CUIRawPixelRendition *)renditionBytes;
	if(rawPixelRendition->tag == 'RAWD')
	{
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

By running this code in Xcode, we can see the recovered image with QuickLook:

![](https://blog.timac.org/2018/1018-reverse-engineering-the-car-file-format/CUIRawPixelRendition.png)

### CUIThemeColorRendition

The CUIThemeColorRendition rendition is used to store named colors and contains:

* the number of color components
* the values for the color components
* the color space

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

Accessing the `CGColorRef` can be done with this code:

```c
else if(csiHeader->pixelFormat == 0 && csiHeader->csimetadata.layout == kRenditionLayoutType_Color)
{
	struct csicolor *colorRendition = (struct csicolor *)renditionBytes;
	
	if(colorRendition->numberOfComponents == 4)
	{
		// Use the hardcoded DeviceRGB color space instead of the real colorSpace from the colorSpaceID
		CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
		CGColorRef __unused theColor = CGColorCreate(colorSpaceRef, colorRendition->components);
		CFRelease(theColor);
		CFRelease(colorSpaceRef);
		
		NSString *colorString = [NSString stringWithFormat:@"%f,%f,%f,%f", colorRendition->components[0], colorRendition->components[1], colorRendition->components[2], colorRendition->components[3]];
		fprintf(stderr, "\n\t\t Found Color %s with colorspace ID %d\n", [colorString UTF8String], colorRendition->colorSpace.colorSpaceID & 0xFF);
	}
	else
	{
		fprintf(stderr, "\n\t\t Found Color with colorspace ID %d but with %u components\n", colorRendition->colorSpace.colorSpaceID & 0xFF, colorRendition->numberOfComponents);
	}
}
```

By running this code in Xcode, we can see the recovered `CGColorRef` with QuickLook:

![](https://blog.timac.org/2018/1018-reverse-engineering-the-car-file-format/RenditionColor.png)

### CUIThemePixelRendition

The CUIThemePixelRendition is slightly more complex and is used for example for the PNG images. As with the other types of renditions, the CUIThemePixelRendition has a specific header:

```c
struct CUIThemePixelRendition {
    uint32_t tag;					// 'CELM'
    uint32_t version;
    uint32_t compressionType;
    uint32_t rawDataLength;
	uint8_t rawData[];
} __attribute__((packed));
```

* the `tag` has its value set to `CELM`
* the `version` is always set to 0
* the `compressionType` can be set to one of the following:
    
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

When a compression is used, the raw data is compressed and should be decoded with the corresponding algorithm. The decompression algorithms used is out of the scope of this article.

* the `rawDataLength` contains the size of the `rawData`.    
* Finally the `rawData` contains the real data - either uncompressed or compressed. If the data is compressed, you will need to decompress it using the algorithm specified in the `compressionType` field.

Here is how a png rendition looks like in Synalyze It! Pro. Note in red the raw data compressed:

![](https://blog.timac.org/2018/1018-reverse-engineering-the-car-file-format/CUIThemePixelRendition.png)

## Conclusion

The car files can stored a lot of different types of assets which makes this file format fairly complex. In this article, I described the most important structures and how to dump them. A similar approach could be used to analyze and understand the other structures.

The complete source code of the `CARParser` application can be [downloaded here](CARParser.zip). This tool could easily be modified to produce the same output as `assetutil -I Assets.car`.

Here is the output you will see when running `CARParser` on the demo asset:

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

You can find my QuickLook plugin to visualize .car files in a new article here: [QuickLook plugin to visualize .car files (compiled Asset Catalogs)](https://blog.timac.org/2018/1112-quicklook-plugin-to-visualize-car-files/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
