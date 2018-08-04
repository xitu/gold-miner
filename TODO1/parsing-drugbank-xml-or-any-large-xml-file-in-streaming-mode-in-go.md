> * 原文地址：[Parsing DrugBank XML (or any large XML file) in streaming mode in Go](http://bionics.it/posts/parsing-drugbank-xml-or-any-large-xml-file-in-streaming-mode-in-go)
> * 原文作者：[Samuel Lampa](https://disqus.com/by/samuellampa/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/parsing-drugbank-xml-or-any-large-xml-file-in-streaming-mode-in-go.md](https://github.com/xitu/gold-miner/blob/master/TODO1/parsing-drugbank-xml-or-any-large-xml-file-in-streaming-mode-in-go.md)
> * 译者：[steinliber](https://github.com/steinliber)
> * 校对者：[SergeyChang](https://github.com/SergeyChang)

# 使用 Go 语言的流模式来解析 DrugBank 的 XML（或者任何 XML 大文件）

当我想解析 [DrugBank](https://www.drugbank.ca) 的整个数据集时碰到了一个问题，这个数据集包含了一个 [(670MB) XML 文件](https://www.drugbank.ca/releases/5-0-11/downloads/all-full-database)（如果想要描述 DrugBank 的公开论文，可以看：[[1]](https://doi.org/10.1093/nar/gkt1068)、[[2]](https://doi.org/10.1093/nar/gkq1126)、[[3]](https://doi.org/10.1093/nar/gkm958) 以及 [[4]](https://doi.org/10.1093/nar/gkj067)）。

事实上，我想要的是 [Structure External Links](https://www.drugbank.ca/releases/latest#structures) 链接下的 CSV 文件。使用这种方式解析似乎还有一些其它的用处，因为 DrugBank 版本的 XML 格式似乎比单独的 CSV 文件包含更多的信息。所以不管怎么样，这迫使我想出如何在 Go 中使用流模式来解析大型 XML 文件的方法，像 [XMLStarlet](http://xmlstar.sourceforge.net/) 这些旧的工具会在处理 DrugBank 文件阻塞好几分钟（也许是试图把文件的内容全部读入内存？），这让人在迭代开发周期中失去了任何想法。而且，Go 对流式解析 XML 的支持非常棒。

尽管 Go 对流式解析 XML 的支持很不错，但在文档里面并没有详细讲述如何使用流的方式来实现它，还好 [David Singleton](http://twitter.com/dps) 的[这篇博客](http://blog.davidsingleton.org/parsing-huge-xml-files-with-go/)启发了我。基本上，你可以从他的文章来开始学习，但是我也想写一篇自己的博客来记录过程中想到的一些具体细节和特征。

## 想法：把 DrugBank 的 XML 解析为 TSV


简而言之，我们想要解析 DrugBank 的 XML 文件，这文件里包含了数据集中每种药物的大量分层信息，并只想提取其中的部分字段，然后把这些字段信息输出到由制表符分隔的格式优美的（.tsv）文件中。

以下是在这个例子中针对每种药物我们想要提取的字段（基于上面提到的现实问题）：

*   InchiKey（一个表示化学结构的散列 ID）
*   Approved/Withdrawn status
*   ChEMBL ID（化合物包含字段）
*   PubChem Compound ID (CID)
*   PubChem Substance ID (SID)

## DrugBank 的 XML 格式

DugBank 的 XML 格式在其最外层是最简单的：它基本上只包含了很多在 `<drugbank></drugbank>` 闭标签里的 `<drug></drug>` 元素。而 `<drug>` 标签内的相对来说比较复杂。但因为 Go 使用标签来将 XML 解析为结构体，我们可以跳过大部分信息，而只关注感兴趣的部分。

一个仅包含我们感兴趣字段的 DrugBank XML 概要示例如下：


```xml
<?xml version="1.0" encoding="UTF-8"?>
<drugbank xmlns="http://www.drugbank.ca" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.drugbank.ca http://www.drugbank.ca/docs/drugbank.xsd" version="5.0" exported-on="2017-12-20">
<drug type="small molecule" created="2005-06-13" updated="2017-12-19">
  <name>Bivalirudin</name>
  <groups>
    <group>approved</group>
    <group>investigational</group>
  </groups>
  <external-identifiers>
    <external-identifier>
      <resource>PubChem Compound</resource>
      <identifier>16129704</identifier>
    </external-identifier>
    <external-identifier>
      <resource>PubChem Substance</resource>
      <identifier>46507415</identifier>
    </external-identifier>
    <external-identifier>
      <resource>ChEMBL</resource>
      <identifier>CHEMBL2103749</identifier>
    </external-identifier>
  </external-identifiers>
  <calculated-properties>
    <property>
      <kind>InChIKey</kind>
      <value>OIRCOABEOLEUMC-GEJPAHFPSA-N</value>
      <source>ChemAxon</source>
    </property>
  </calculated-properties>
</drug>
</drugbank>
```

实际上，每个 `<drug>` 元素内容的行数都比这多，那就确实需要合适的 XML 解析工具。

## 把 XML 映射到 Go 的结构体

Go 中 XML 的解析使用和 JSON 等其它格式相同的策略：定义一个或多个解析特定 XML 元素和属性的结构体。XML（或 JSON ）和结构字段之间的映射是使用所谓的“标记”完成的，这些标记在结构体所定义字段之后的单引号中添加。因此，定义合理的结构体以到 XML 元素的字段映射是该完成工作的核心，并且这将直接影响你实现代码的简单程度。

下面你可以看到我定义的结构体（听起来是对的，对吗？）从中可以解析出我感兴趣的数据：

```go
type Drugbank struct {
	XMLName xml.Name `xml:"drugbank"`
	Drugs   []Drug   `xml:"drug"`
}

type Drug struct {
	XMLName              xml.Name             `xml:"drug"`
	Name                 string               `xml:"name"`
	Groups               []string             `xml:"groups>group"`
	CalculatedProperties []Property           `xml:"calculated-properties>property"`
	ExternalIdentifiers  []ExternalIdentifier `xml:"external-identifiers>external-identifier"`
}

type Property struct {
	XMLName xml.Name `xml:"property"`
	Kind    string   `xml:"kind"`
	Value   string   `xml:"value"`
	Source  string   `xml:"source"`
}

type ExternalIdentifier struct {
	XMLName    xml.Name `xml:"external-identifier"`
	Resource   string   `xml:"resource"`
	Identifier string   `xml:"identifier"`
}
```

我们可以注意到以下几点：

*   如前所述，后面单引号内的内容代表 XML 中要映射到特定字段的结构。
*   请注意，对于嵌套层次结构，我们需要多个结构类型，例如 “Property” 和 “ExternalIdentifier” ...然后把它们链接到主 “Drug” 结构体中。
*   我们还需要一个架构体来表示最高级别元素 <`drugbank>`。
*   每个结构体都需要有一个 xml.Name 类型的字段（为了简单起见，命名为 XMLName ），该字段在XML中定义了它的名字，这样我们就有地方可以添加我们的 XML 映射标签了。
*   注意，当我们有一些字段的切片（“列表”）时，比如 “Drug” 结构体中的 “CalculatedProperties” 字段，我们需要指定一个二级路径（`xml:"calculated-properties**>**property"`）并将其放入 XML 结构体中，以便能获取到位于分组 ”calculate-properties“ 元素内的单个 ”property“ XML 元素。

设置好结构体之后，我们就可以写 Go 代码了，这份代码会按照 David 的[博客](http://blog.davidsingleton.org/parsing-huge-xml-files-with-go/)以流的方式循环遍历读取一个 XML 文件，同时也会创建一个 TSV 写入器，这样我们就可以用流的方式将提取到的输出写入到一个 drugbank_extracted.tsv 新文件（为简洁起见，导入和主函数都省略了）。

```go
xmlFile, err := os.Open("drugbank.xml")
if err != nil {
	panic("Could not open file: drugbank.xml")
}

tsvFile, err := os.Create("drugbank_extracted.tsv")
if err != nil {
	panic("Could not create file: drugbank_extracted.tsv")
}

tsvWrt := csv.NewWriter(tsvFile)
tsvWrt.Comma = '\t'
tsvHeader := []string{"inchikey", "status", "chembl_id", "pubchem_sid", "pubchem_cid"}
tsvWrt.Write(tsvHeader)

// Implement a streaming XML parser according to guide in
// http://blog.davidsingleton.org/parsing-huge-xml-files-with-go
xmlDec := xml.NewDecoder(xmlFile)
for {
	t, tokenErr := xmlDec.Token()
	if tokenErr != nil {
		if tokenErr == io.EOF {
			break
		} else {
			panic("Failed to read token:" + tokenErr.Error())
		}
	}
	switch startElem := t.(type) {
	case xml.StartElement:
		if startElem.Name.Local == "drug" {
			var status string
			var inchiKey string
			var chemblID string
			var pubchemSID string
			var pubchemCID string

			drug := &Drug{}
			decErr := xmlDec.DecodeElement(drug, &startElem)
			if err != nil {
				panic("Could not decode element" + decErr.Error())
			}
			for _, g := range drug.Groups {
				if g == "approved" {
					status = "A"
				}
				// Withdrawn till "shadow" (what's the correct term?) approved status
				if g == "withdrawn" {
					status = "W"
				}
			}
			for _, p := range drug.CalculatedProperties {
				if p.Kind == "InChIKey" {
					inchiKey = p.Value
				}
			}

			for _, eid := range drug.ExternalIdentifiers {
				if eid.Resource == "ChEMBL" {
					chemblID = eid.Identifier
				} else if eid.Resource == "PubChem Substance" {
					pubchemSID = eid.Identifier
				} else if eid.Resource == "PubChem Compound" {
					pubchemCID = eid.Identifier
				}
			}

			tsvWrt.Write([]string{inchiKey, status, chemblID, pubchemSID, pubchemCID})
		}
	case xml.EndElement:
		continue
	}
}
tsvWrt.Flush()
xmlFile.Close()
tsvFile.Close()
```

## 使用 SciPipe 来使之变成一个可重复的工作流

现在，我们可以使用 SciPipe（我正在开发的基于 Go 的工作流库）将它放到一个小工作流中，在这里我们会自动下载 DrugBank 数据，解压缩它之后再运行 XML 到 TSV 的 代码。查看这个 [gist](https://gist.github.com/samuell/fc82fad39e7efda7987fc18173777f7f) 来了解完整的工作流代码。

要在 gist 中运行这个 Go 文件，简单来说你需要做以下几步：

*   创建一个文件 drugbank_userinfo.txt ，文件中包含使用以下形式记录的 DrugBank 网站用户名和密码：USERNAME：PASSWORD
*   安装 Go 语言
*   使用 `go get github.com/scipipe/scipipe/...` 命令安装 scipipe
*   确保你已经安装了 curl，在 Ubuntu 上：可以使用 `sudo apt-get install curl` 命令安装

然后，你应该就可以运行它了，使用下面这个命令：

```
go run drugbank_xml_to_tsv_with_scipipe.go
```

## 完整的 SciPipe 工作流代码示例

我还在下面列出了完整的 SciPipe 工作流代码，（我）会一直维护到 Github 关闭的那一天;）：

```go
package main

import (
	"encoding/csv"
	"encoding/xml"
	"io"
	"os"

	sp "github.com/scipipe/scipipe"
)

// --------------------------------------------------------------------------------
// Workflow definition
// --------------------------------------------------------------------------------

func main() {
	wf := sp.NewWorkflow("exvsdb", 2)

	// DrugBank XML
	download := wf.NewProc("download", "curl -Lfv -o {o:zip} -u $(cat drugbank_userinfo.txt) https://www.drugbank.ca/releases/5-0-11/downloads/all-full-database")
	download.SetPathStatic("zip", "dat/drugbank.zip")

	unzip := wf.NewProc("unzip", `unzip -d dat/ {i:zip}; mv "dat/full database.xml" {o:xml}`)
	unzip.SetPathStatic("xml", "dat/drugbank.xml")
	unzip.In("zip").Connect(download.Out("zip"))

	xmlToTSV := wf.NewProc("xml2tsv", "# Custom Go code with input: {i:xml} and output: {o:tsv}")
	xmlToTSV.SetPathExtend("xml", "tsv", ".extr.tsv")
	xmlToTSV.In("xml").Connect(unzip.Out("xml"))
	xmlToTSV.CustomExecute = NewXMLToTSVFunc() // Getting the custom Go function in a factory method for readability

	wf.Run()
}

// --------------------------------------------------------------------------------
// DrugBank struct definitions
// --------------------------------------------------------------------------------

type Drugbank struct {
	XMLName xml.Name `xml:"drugbank"`
	Drugs   []Drug   `xml:"drug"`
}

type Drug struct {
	XMLName              xml.Name             `xml:"drug"`
	Name                 string               `xml:"name"`
	Groups               []string             `xml:"groups>group"`
	CalculatedProperties []Property           `xml:"calculated-properties>property"`
	ExternalIdentifiers  []ExternalIdentifier `xml:"external-identifiers>external-identifier"`
}

type Property struct {
	XMLName xml.Name `xml:"property"`
	Kind    string   `xml:"kind"`
	Value   string   `xml:"value"`
	Source  string   `xml:"source"`
}

type ExternalIdentifier struct {
	XMLName    xml.Name `xml:"external-identifier"`
	Resource   string   `xml:"resource"`
	Identifier string   `xml:"identifier"`
}

// --------------------------------------------------------------------------------
// Components
// --------------------------------------------------------------------------------

// NewXMLToTSVFunc returns a CustomExecute function to be used by the XML to TSV
// component in the workflow above
func NewXMLToTSVFunc() func(t *sp.Task) {
	return func(t *sp.Task) {
		fh, err := os.Open(t.InPath("xml"))
		if err != nil {
			sp.Fail("Could not open file", t.InPath("xml"))
		}

		tsvWrt := csv.NewWriter(t.OutIP("tsv").OpenWriteTemp())
		tsvWrt.Comma = '\t'
		tsvHeader := []string{"inchikey", "status", "chembl_id", "pubchem_sid", "pubchem_cid"}
		tsvWrt.Write(tsvHeader)

		// Implement a streaming XML parser according to guide in
		// http://blog.davidsingleton.org/parsing-huge-xml-files-with-go
		xmlDec := xml.NewDecoder(fh)
		for {
			t, tokenErr := xmlDec.Token()
			if tokenErr != nil {
				if tokenErr == io.EOF {
					break
				} else {
					sp.Fail("Failed to read token:", tokenErr)
				}
			}
			switch startElem := t.(type) {
			case xml.StartElement:
				if startElem.Name.Local == "drug" {
					var status string
					var inchiKey string
					var chemblID string
					var pubchemSID string
					var pubchemCID string

					drug := &Drug{}
					decErr := xmlDec.DecodeElement(drug, &startElem)
					if err != nil {
						sp.Fail("Could not decode element", decErr)
					}
					for _, g := range drug.Groups {
						if g == "approved" {
							status = "A"
						}
						// Withdrawn till "shadow" (what's the correct term?) approved status
						if g == "withdrawn" {
							status = "W"
						}
					}
					for _, p := range drug.CalculatedProperties {
						if p.Kind == "InChIKey" {
							inchiKey = p.Value
						}
					}

					for _, eid := range drug.ExternalIdentifiers {
						if eid.Resource == "ChEMBL" {
							chemblID = eid.Identifier
						} else if eid.Resource == "PubChem Substance" {
							pubchemSID = eid.Identifier
						} else if eid.Resource == "PubChem Compound" {
							pubchemCID = eid.Identifier
						}
					}

					tsvWrt.Write([]string{inchiKey, status, chemblID, pubchemSID, pubchemCID})
				}
			case xml.EndElement:
				continue
			}
		}
		tsvWrt.Flush()
		fh.Close()
	}
}
```

（代码许可证：[Public Domain](https://unlicense.org/)）

* **Note I（2018-03-21）：** [Pierre Lindenbaum](https://twitter.com/yokofakun)  [友善的建议我](https://twitter.com/yokofakun/status/976488405654736896)了一个[替代方案](https://gist.github.com/lindenb/5a76d95397a86b860386cdf3976726a2)，即使用这个 [xjc](https://docs.oracle.com/javase/8/docs/technotes/tools/unix/xjc.html) 来生成 JAVA 代码， 并且一个 Makefile 文件来提供工作流功能（[看代码](https://gist.github.com/lindenb/5a76d95397a86b860386cdf3976726a2)）。他也[提供了一个](https://twitter.com/yokofakun/status/976515166002204673)使用 XSLT（[看代码](https://gist.github.com/lindenb/63c85ee0e8c21b6cc3e7d44b77dd93db)）实现的版本。

* **Note II （2018-03-21）：** [在 reddit 上关于这个帖子的一些评论](https://www.reddit.com/r/golang/comments/854zl8/data_science_parsing_drugbank_xml_or_any_large)。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
