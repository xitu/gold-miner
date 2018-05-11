> * 原文地址：[Parsing DrugBank XML (or any large XML file) in streaming mode in Go](http://bionics.it/posts/parsing-drugbank-xml-or-any-large-xml-file-in-streaming-mode-in-go)
> * 原文作者：[Samuel Lampa](https://disqus.com/by/samuellampa/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/parsing-drugbank-xml-or-any-large-xml-file-in-streaming-mode-in-go.md](https://github.com/xitu/gold-miner/blob/master/TODO1/parsing-drugbank-xml-or-any-large-xml-file-in-streaming-mode-in-go.md)
> * 译者：
> * 校对者：

# Parsing DrugBank XML (or any large XML file) in streaming mode in Go

I had a problem in which I thought I needed to parse the full [DrugBank](https://www.drugbank.ca) dataset, which comes as a [(670MB) XML file](https://www.drugbank.ca/releases/5-0-11/downloads/all-full-database) (For open access papers describing DrugBank, see: [[1]](https://doi.org/10.1093/nar/gkt1068), [[2]](https://doi.org/10.1093/nar/gkq1126), [[3]](https://doi.org/10.1093/nar/gkm958) and [[4]](https://doi.org/10.1093/nar/gkj067)).

It turned out what I needed was available as CSV files under "[Structure External Links](https://www.drugbank.ca/releases/latest#structures)". There is probably still some other uses of this approach, as the XML version of DrugBank seems to contain a lot more information in a single format, than the individual CSV files. And in any case, this forced me to figure out how to parse large XML files in a streaming fashion in Go, as older tools like [XMLStarlet](http://xmlstar.sourceforge.net/) chokes for many minutes upon the DrugBank file (trying to read it all into memory?), killing any attempt at an iterative development cycle. And, it turns out Go's support for streaming XML parsing is great!

While Go's XML stream-parsing support is great, the details of how to do that in a streaming fashion was not immediately clear from the docs, and I was thus saved by [this blog post](http://blog.davidsingleton.org/parsing-huge-xml-files-with-go/) by [David Singleton](http://twitter.com/dps). Basically, you could use his blog post as a starting point, but I wanted to write up my own post to document some specifics and peculiarities I figured out.

## Idea: Parse DrugBank XML to TSV

So in short, we want to parse the DrugBank XML, which contains tons of hierarchical information about each drug in the dataset, and extract just a few fields, and output that into a nicely formatted tab-separated (.tsv) file.

The fields which we want to extract in this example (which is based on my real world problem mentioned above) for each drug are:

*   InchiKey (a hashed ID representing a chemical structure)
*   Approved/Withdrawn status
*   ChEMBL ID (for the compound)
*   PubChem Compound ID (CID)
*   PubChem Substance ID (SID)

## The DrugBank XML format

The DrugBank XML format is a pretty simple one on its highest level: It is basically a lot of `<drug></drug>` elements thrown into a `<drugbank></drugbank>` enclosing tag. The relative complexity comes within the `<drug>` tag. But because of how Go parses XML to structs using tags, we can just skip most of that info, and only focus on the parts we are interested in.

A schematic example of the DrugBank XML containing only the fields we are interested could look like this:

```
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

(In reality, each `<drug>` element is far far many more lines than this, which really necessitates proper XML parsing tools).

## Mapping XML to Go Structs

The parsing strategy for XML in Go, is the same as for other formats such as JSON: Define one or more structs into which we parse certain XML elements and attributes. The mapping between XML (or JSON) and the struct fields are done using so called "tags" which are added within back-quotes after the fields in the struct definition. Thus, defining sensible structs and XML element-to-struct field mappings is the core of the work, and will directly influence how easy your code will be to work with.

Below you can see the struct-structure (sounds just right, right?) I defined to be able to parse out the data I'm interested in:

```
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

We can note the following:

*   As said, the stuff within back-quotes represent the structure in the XML to be mapped to a certain field.
*   Note how, for nested hierarchies, we need multiple struct types, such as the "Property" and "ExternalIdentifier" ones ... which are then linked to from the main "Drug" struct".
*   We also need a struct for the highest level element, `<drugbank>`.
*   Each struct needs to have a field of xml.Name type (named XMLName for simplicity), that defines its name in the XML, so that we have somewhere to add our XML-mapping tag.
*   Note, when we have a slice ("list") of things, such as the "CalculatedProperties" field in the "Drug" struct, how we need to specify a two level path (`xml:"calculated-properties**>**property"`) into the XML structure, so that we get down to the individual "property" XML elements which are placed inside a grouping "calculated-properties" element.

With that set up, we can create our Go code to loop over our XML file in a streaming fashion, along the lines of David's [blog post](http://blog.davidsingleton.org/parsing-huge-xml-files-with-go/), while also creating a TSV writer, which we use to stream-write our extracted output into a new file, drugbank_extracted.tsv (imports and main function left out for brevity):

```
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

## Turn into a reproducible workflow with SciPipe

Now, we could use SciPipe (Go-based workflow library I'm developing) to put this into a little workflow, where we also automaticalyl download the DrugBank data, Unzip it, and run the XML-to-TSV code. See [this gist](https://gist.github.com/samuell/fc82fad39e7efda7987fc18173777f7f) for the full workflow code.

To run the Go file in the gist, in short, what you need to do is:

*   Create a file drugbank_userinfo.txt, containing your DrugBank website username and password, on the form: USERNAME:PASSWORD
*   Install Go
*   Install scipipe with `go get github.com/scipipe/scipipe/...`
*   Make sure you have curl installed. On Ubuntu: `sudo apt-get install curl`

Then, you should be able to run it, with:

```
go run drugbank_xml_to_tsv_with_scipipe.go
```

## Full SciPipe workflow code example

I'm including the full SciPipe workflow code below as well, for the day when Github is down ;):

```
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

(Code license: [Public Domain](https://unlicense.org/))

* **Note I (2018-03-21):** [Pierre Lindenbaum](https://twitter.com/yokofakun) [kindly suggested](https://twitter.com/yokofakun/status/976488405654736896) an [alternative approach](https://gist.github.com/lindenb/5a76d95397a86b860386cdf3976726a2) using the [xjc](https://docs.oracle.com/javase/8/docs/technotes/tools/unix/xjc.html) tool to generate Java code, and a Makefile to provide for workflow functionality ([see code](https://gist.github.com/lindenb/5a76d95397a86b860386cdf3976726a2)). He also [provided a version](https://twitter.com/yokofakun/status/976515166002204673) implemented with XSLT ([see code](https://gist.github.com/lindenb/63c85ee0e8c21b6cc3e7d44b77dd93db))._

* **Note II (2018-03-21):** [Some comments on the post on reddit](https://www.reddit.com/r/golang/comments/854zl8/data_science_parsing_drugbank_xml_or_any_large)._


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
