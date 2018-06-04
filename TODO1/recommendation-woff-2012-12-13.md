> * 原文地址：[WOFF File Format 1.0](https://www.w3.org/TR/2012/REC-WOFF-20121213/)
> * 原文作者：[W3C](https://www.w3.org)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/recommendation-woff-2012-12-13.md](https://github.com/xitu/gold-miner/blob/master/TODO1/recommendation-woff-2012-12-13.md)
> * 译者：
> * 校对者：

# WOFF File Format 1.0

## W3C Recommendation 13 December 2012

This version: [http://www.w3.org/TR/2012/REC-WOFF-20121213/](http://www.w3.org/TR/2012/REC-WOFF-20121213/)

Latest version: [http://www.w3.org/TR/WOFF/](http://www.w3.org/TR/WOFF/)

Previous version: [http://www.w3.org/TR/2012/PR-WOFF-20121011/](http://www.w3.org/TR/2012/PR-WOFF-20121011/)

Authors: Jonathan Kew (Mozilla Corporation), Tal Leming (Type Supply), Erik van Blokland (LettError)

Please refer to the [**errata**](http://www.w3.org/Fonts/REC-WOFF-20121213-errata.html) for this document, which may include some normative corrections.

See also [**translations**](http://www.w3.org/2003/03/Translations/byTechnology?technology=WOFF).

[Copyright](http://www.w3.org/Consortium/Legal/ipr-notice#Copyright) © 2012 [W3C](http://www.w3.org/)® ([MIT](http://www.csail.mit.edu/), [ERCIM](http://www.ercim.eu/), [Keio](http://www.keio.ac.jp/)), All Rights Reserved. W3C [liability](http://www.w3.org/Consortium/Legal/ipr-notice#Legal_Disclaimer), [trademark](http://www.w3.org/Consortium/Legal/ipr-notice#W3C_Trademarks) and [document use](http://www.w3.org/Consortium/Legal/copyright-documents) rules apply.

* * *

## Abstract

This document specifies the WOFF font packaging format. This format was designed to provide lightweight, easy-to-implement compression of font data, suitable for use with CSS @font-face rules. Any properly licensed TrueType/OpenType/Open Font Format file can be packaged in WOFF format for Web use. User agents decode the WOFF file to restore the font data such that it will display identically to the input font.

The WOFF format also allows additional metadata to be attached to the file; this can be used by font designers or vendors to include licensing or other information, beyond that present in the original font. Such metadata does not affect the rendering of the font in any way, but may be displayed to the user on request.

The WOFF format is not intended to replace other formats such as TrueType/OpenType/Open Font Format or SVG fonts, but provides an alternative solution for use cases where these formats may be less optimal, or where licensing considerations make their use less acceptable.

## Status of This Document

This section describes the status of this document at the time of its publication. Other documents may supersede this document. A list of current W3C publications and the latest revision of this technical report can be found in the [W3C technical reports index](http://www.w3.org/TR/) at http://www.w3.org/TR/.

This is the W3C Recommendation of "WOFF File Format 1.0". This document has been reviewed by W3C Members, by software developers, and by other W3C groups and interested parties, and is endorsed by the Director as a W3C Recommendation. It is a stable document and may be used as reference material or cited from another document. W3C's role in making the Recommendation is to draw attention to the specification and to promote its widespread deployment. This enhances the functionality and interoperability of the Web.

Please send comments about this document to [www-font@w3.org](mailto:www-font@w3.org) (with [public archive](http://lists.w3.org/Archives/Public/www-font/)).

This specification has been edited, relative to the [11 October 2011 Proposed Recommendation](http://www.w3.org/TR/2012/PR-WOFF-20121011/), to incorporate minor changes to the Internet Media Type registration, as a result of IANA expert review. There is a [changes appendix](#changes) describing the changes made.

The CR exit criteria were:

1.  Sufficient reports of implementation experience have been gathered to demonstrate that the “WOFF File Format 1.0” syntax and features are implementable and are interpreted in a consistent manner. To do so, the Working Group would insure that all features have been implemented in at least two implementation in an interoperable way.
2.  The implementations have been developed independently.

The Working Group has developed public test suites as follows:

*   [User Agent tests](http://dev.w3.org/webfonts/WOFF/tests/UserAgent/Tests/xhtml1/testcaseindex.xht)
    
*   [Authoring Tool tests](http://dev.w3.org/webfonts/WOFF/tests/AuthoringTool/Tests/xhtml1/testcaseindex.xht)
    
*   Test data for [the file format itself](http://dev.w3.org/webfonts/WOFF/tests/Format/Tests/xhtml1/testcaseindex.xht)
    

A [WOFF validator](http://dev.w3.org/webfonts/WOFF/tools/validator/) was developed, to make all the file format checks indicated in the specification. The validator passes 100% of these tests. The new W3C Test Harness was used to deploy the tests: [Authoring Tools test harness](http://www.w3c-test.org/framework/suite/woff-at/) and [User Agent test harness](http://www.w3c-test.org/framework/suite/woff-ua/).

The [User Agents implementation report](http://w3c-test.org/framework/review/woff-ua/) and [Authoring Tools implementation report](http://w3c-test.org/framework/review/woff-at/) are available.

This document was initially developed by contributors to the [www-font@w3.org](mailto:www-font@w3.org) mailing list. After trial implementation, it became the [WOFF Submission](http://www.w3.org/Submission/2010/SUBM-WOFF-20100408/) and was further developed by the [WebFonts Working Group](http://www.w3.org/Fonts/WG/) at W3C.

This document was produced by a group operating under the [5 February 2004 W3C Patent Policy](http://www.w3.org/Consortium/Patent-Policy-20040205/). W3C maintains a [public list of any patent disclosures](http://www.w3.org/2004/01/pp-impl/44556/status) made in connection with the deliverables of the group; that page also includes instructions for disclosing a patent. An individual who has actual knowledge of a patent which the individual believes contains [Essential Claim(s)](http://www.w3.org/Consortium/Patent-Policy-20040205/#def-essential) must disclose the information in accordance with [section 6 of the W3C Patent Policy](http://www.w3.org/Consortium/Patent-Policy-20040205/#sec-Disclosure).

## 1. Introduction

This document specifies a simple compressed file format for fonts, designed primarily for use on the Web and known as WOFF (Web Open Font Format). Despite this name, WOFF should be regarded as a container format or "wrapper" for font data in already-existing formats rather than an actual font format in its own right.

The WOFF format is a container for the table-based sfnt structure used in e.g. TrueType [[TrueType](#ref-TT)], OpenType [[OpenType](#ref-OT)] and Open Font Format [[OFF](#ref-OFF)] fonts, hereafter referred to as sfnt fonts. A WOFF file is simply a repackaged version of a sfnt font with optional compression of the font data tables. The WOFF file format also allows font metadata and private-use data to be included separately from the font data. WOFF encoding tools convert an input sfnt font into a WOFF formatted file, and user agents restore the sfnt font data for use with a Web document.

The structure and contents of decoded font data exactly match those of a well-formed input font file. Tools producing WOFF files may provide other font editing features such as glyph subsetting, validation or font feature additions but these are considered outside the scope of this format. Independent of these features, both tools and user agents are expected to assure that the validity of the underlying font data is preserved.

### Notational Conventions

The all-uppercase key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119 [[RFC-2119](#ref-RFC-2119)]. If these words occur in lower- or mixed case, they should be interpreted in accordance with their normal English meaning.

This document includes sections of text that are called out as "Notes" and set off from the main text of the specification. These notes are intended as informative explanations or clarifications, to serve as hints or guides to implementers and users, but are not part of the normative text.

## 2. General Requirements

The primary purpose of the WOFF format is to package fonts linked to Web documents by means of CSS @font-face rules. User agents supporting the WOFF file format for linked fonts must respect the requirements of the CSS3 Fonts specification ([[CSS3-Fonts](#ref-CSS3-Fonts)] [Section 4.1: The @font-face rule](http://www.w3.org/TR/css3-fonts/#font-face-rule)). In particular, such linked fonts are only available to the documents that reference them; they MUST NOT be made available to other applications or documents on the user's system.

The WOFF format is intended for use with @font-face to provide fonts linked to specific Web documents. Therefore, WOFF files must not be treated as an installable font format in desktop operating systems or similar environments. The WOFF-packaged data will typically be decoded to sfnt format for use by existing font-rendering APIs that expect OpenType font data, but such decoded font must not be exposed to other documents or applications.

## 3. Overall File Structure

The structure of WOFF files is similar to the structure of sfnt fonts: a table directory containing lengths and offsets to individual font data tables, followed by the data tables themselves. The sfnt structure is described fully in the TrueType [[TrueType](#ref-TT)], OpenType [[OpenType](#ref-OT)] and Open Font Format [[OFF](#ref-OFF)] specifications.

The main body of the file consists of the same collection of font data tables as the input sfnt font, stored in the same order, except that each table MAY be compressed, and the sfnt table directory is replaced by the WOFF table directory.

The WOFF specification does not guarantee that the actual font data packaged in a valid WOFF container is in fact correct and usable. It requires only that the WOFF packaging structure—header, table directory, and compressed tables—conforms to this specification. The contained data must be used with just as much caution as font data delivered in "raw" form or via any other packaging method.

A complete WOFF file consists of several blocks: a 44-byte header, immediately followed (in this order) by a variable-size table directory, a variable number of font tables, an optional block of extended metadata, and an optional block of private data. Except for padding with a maximum of three null bytes in places where 4-byte alignment of a table length or block offset is specified, there MUST NOT be any extraneous data between the data blocks or font data tables indicated by the WOFF header and table directory, or beyond the last such block or table. If such extraneous data is present a conforming user agent MUST reject the file as invalid. The file MUST also be rejected as invalid if the offsets and lengths of any data blocks or font tables indicate overlapping byte ranges of the file, or ranges that would extend beyond the end of the file.

**WOFF File**

WOFFHeader: File header with basic font type and version, along with offsets to metadata and private data blocks.

TableDirectory: Directory of font tables, indicating the original size, compressed size and location of each table within the WOFF file.

FontTables: The font data tables from the input sfnt font, compressed to reduce bandwidth requirements.

ExtendedMetadata: An optional block of extended metadata, represented in XML format and compressed for storage in the WOFF file.

PrivateData: An optional block of private data for the font designer, foundry, or vendor to use.

Data values stored in the WOFF Header and WOFF Table Directory sections are stored in big-endian format, just as values are within sfnt fonts. The following basic data types are used in the description:

**Data types**

UInt32: 32-bit (4-byte) unsigned integer in big-endian format

UInt16: 16-bit (2-byte) unsigned integer in big-endian format

All sizes and offsets described in this document are assumed to be in bytes unless otherwise noted.

## 4. WOFF Header

The header includes an identifying signature and indicates the specific kind of font data included in the file (TrueType or CFF outline data); it also has a font version number, offsets to additional data chunks, and the number of entries in the table directory that immediately follows the header:

**WOFFHeader**

UInt32: signature  0x774F4646 `'wOFF'`

UInt32: flavor  The "sfnt version" of the input font.

UInt32: length  Total size of the WOFF file.

UInt16: numTables  Number of entries in directory of font tables.

UInt16: reserved Reserved;  set to zero.

UInt32: totalSfntSize  Total size needed for the uncompressed font data, including the sfnt header, directory, and font tables (including padding).

UInt16: majorVersion  Major version of the WOFF file.

UInt16: minorVersion  Minor version of the WOFF file.

UInt32: metaOffset  Offset to metadata block, from beginning of WOFF file.

UInt32: metaLength  Length of compressed metadata block.

UInt32: metaOrigLength  Uncompressed size of metadata block.

UInt32: privOffset  Offset to private data block, from beginning of WOFF file.

UInt32: privLength  Length of private data block.

The `signature` field in the WOFF header MUST contain the "magic number" 0x774F4646. If the field does not contain this value, user agents MUST reject the file as invalid.

The `flavor` field corresponds to the "sfnt version" field found at the beginning of an sfnt file, indicating the type of font data contained. Although only fonts of type 0x00010000 (the version number 1.0 as a 16.16 fixed-point value, indicating TrueType glyph data) and 0x4F54544F (the tag `'OTTO'`, indicating CFF glyph data) are widely supported at present, it is not an error in the WOFF file if the `flavor` field contains a different value, indicating a WOFF-packaged version of a different sfnt flavor. (The value 0x74727565 `'true'` has been used for some TrueType-flavored fonts on Mac OS, for example.) Whether client software will actually support other types of sfnt font data is outside the scope of the WOFF specification, which simply describes how the sfnt is repackaged for Web use.

The WOFF `majorVersion` and `minorVersion` fields specify the version number for a given WOFF file, which can be based on the version number of the input font but is not required to be. These fields have no effect on font loading or usage behavior in user agents.

The `totalSfntSize` field is the sum of the uncompressed font table sizes, each padded to a multiple of 4 bytes, plus the size of the sfnt header and table directory. Thus, this is the size of buffer needed to decode the complete WOFF-packaged font (but not metadata, which is not part of the input sfnt file) into a standard sfnt structure. This value MUST be a multiple of 4, because all font tables including the last are to be padded to a 4-byte boundary. If this value is incorrect, a conforming user agent MUST reject the file as invalid.

The sfnt header includes three fields (`searchRange`, `entrySelector` and `rangeShift`) that are designed to facilitate a binary search of the table directory. As the proper value for each of these fields can be computed directly from the number of font tables, they are not stored in the WOFF file. User agents that decode WOFF files back to an sfnt structure MUST therefore compute the correct values for these fields in the sfnt header, as described in the OpenType/OFF specification.[[OFF](#ref-OFF)]

Note: The correct value for `totalSfntSize` may be computed as illustrated by the following pseudo-code:

```
totalSfntSize = 12 // size of sfnt header ("offset table" in the OpenType spec)
totalSfntSize += 16 * numTables // size of table record (directory of font tables)
for each table:
    totalSfntSize += (table.origLength + 3) & 0xFFFFFFFC // table size, padded
```

If either or both of the metadata or private blocks is not present, the relevant offset and length fields MUST be set to zero. If the metadata or private data offset and length fields indicate byte ranges that overlap other data blocks or tables, or extend beyond the end of the file, a conforming user agent MUST reject the file as invalid.

The header includes a `reserved` field; this MUST be set to zero. If this field is non-zero, a conforming user agent MUST reject the file as invalid.

## 5. Table Directory

The table directory is an array of WOFF table directory entries, as defined below. The directory follows immediately after the WOFF file header; therefore, there is no explicit offset in the header pointing to this block. Its size is calculated by multiplying the `numTables` value in the WOFF header times the size of a single WOFF table directory. Each table directory entry specifies the size and location of a single font data table.

**WOFF TableDirectoryEntry**

UInt32: tag  4-byte sfnt table identifier.

UInt32: offset  Offset to the data, from beginning of WOFF file.

UInt32: compLength  Length of the compressed data, excluding padding.

UInt32: origLength  Length of the uncompressed table, excluding padding.

UInt32: origChecksum  Checksum of the uncompressed table.

The format of `tag` values are defined by the specifications for sfnt fonts. The `offset` and `compLength` fields identify the location of the compressed font table. The `origLength` and `origCheckSum` fields are the length and checksum of the input font table from the table directory of the input font.

The sfnt format specifications require that font tables be aligned on 4-byte boundaries. Font tables whose length is not a multiple of 4 are padded with null bytes up to the next 4-byte boundary. Font data tables in the WOFF file have the same requirement: they MUST begin on 4-byte boundaries and be zero-padded to the next 4-byte boundary. The `compLength` and `origLength` fields in the table directory store the exact, unpadded length.

If the `offset` and `compLength` values indicate a byte range that overlaps other data blocks or font tables, or if the byte range extends beyond the end of the file, a conforming user agent MUST reject the file as invalid.

If the length of a compressed font table would be the same as or greater than the length of the input font table, the font table MUST be stored uncompressed in the WOFF file and the `compLength` set equal to the `origLength`. Tools MAY also opt to leave other tables uncompressed (e.g. all tables less than a certain size), in which case `compLength` will be equal to `origLength` for these tables as well. WOFF files containing table directory entries for which `compLength` is greater than `origLength` are considered invalid and MUST NOT be loaded by user agents. Files containing compressed font tables that decompress to a size other than `origLength` are also considered invalid and MUST NOT be loaded.

The sfnt font specifications require that table directory entries are sorted in ascending order of `tag` value. To simplify processing, WOFF-producing tools MUST produce a table directory with entries in ascending `tag` value order. User agents MUST likewise assure that the sfnt table directory is recreated in ascending `tag` order when restoring the font data to its uncompressed state. The ordering of the font tables themselves is independent of the order of directory entries, as described below.

sfnt fonts store a checksum for each table in the table directory, and an overall checksum for the entire font in the `head` table (see the TrueType, OpenType or Open Font Format specifications for the definition of each calculation). Tools producing WOFF files MUST validate these checksums, and reject the font if errors are found.

A WOFF file contains the same set of font tables as the input font from which it was created. This means that the overall font checksum of a font decompressed from a conformant WOFF file will always match the checksum in the well-formed input font. In the case where the input font included unreferenced data between or after the actual tables, this would affect the overall checksum of the input font, but would be dropped during creation of the WOFF file.

A well-formed input font does not have structural anomalies such as incorrect padding, overlapping font tables, extraneous data between tables (which will be discarded by the WOFF generator), or incorrect checksums.

To ensure that lossless round-trip conversion from sfnt to WOFF and back will be possible, a well-formed input font should conform to certain norms that are not strictly required by the OpenType/OFF specification, although they are common practice:

**Font table padding**

The OpenType/OFF specification is not entirely clear about whether _all_ tables in an sfnt font must be padded with 0-3 zero bytes to a multiple of 4 bytes in length, or whether this applies only _between_ tables, and the final table of the file may be left unpadded. Most current tools and fonts seem to expect all tables to be padded to a 4-byte boundary, including the last. The WOFF specification assumes this behavior, and specifies that the `totalSfntLength` field in the WOFF header provides for such padding. To ensure that a given font can be packaged as a WOFF file and then decoded to its original format and give a byte-for-byte identical result, the input font should therefore be padded to a multiple of 4 bytes in length.

**No "hidden" data**

The OpenType/OFF specification does not explicitly prohibit the presence of "extra" data or padding in between the font tables; as the table directory includes the offset and length of each actual table, such data would simply be ignored. However, the WOFF format makes no provision to preserve such non-font-table data when packaging a font, and therefore it would not survive a round-trip format conversion.

**Header fields are correct**

The OpenType/OFF header fields (`searchRange`, `entrySelector`, `rangeShift`) that are designed to facilitate a binary search of the table directory must be correct in the input sfnt file, as the WOFF format does not directly preserve these fields but assumes a WOFF decoder will recompute them as needed.

**Checksums are correct**

The WOFF specification says that table checksums must be validated (and corrected if necessary) by WOFF creators. In order for complete round-trip fidelity, therefore, the checksums in the input sfnt file must also be correct prior to WOFF packaging.

**No overlapping tables**

The offset and length values in the input sfnt table directory must not indicate overlapping byte ranges of the input font.

The result of creating a WOFF file and then decoding this to regenerate an sfnt font MUST result in a final font that is bitwise-identical to the well-formed input font.. If the input font has defects or anomalies that make this impossible, the WOFF-generating tool SHOULD either reject the font or issue an appropriate warning that lossless round-trip conversion will not be possible.

## 6. Font Data Tables

The font data tables in the WOFF file are exactly the same as the tables in the input font, except that each table MAY have been compressed. If compressed, it MUST have been compressed by the `compress2()` function of zlib [[Compress2](#ref-Compress2)] (or an equivalent, compatible algorithm). User agents use the `uncompress()` function of zlib [[Uncompress](#ref-Uncompress)](or an equivalent, compatible algorithm) to decompress each table. The underlying format these functions use is described in the ZLIB specification [[ZLib](#ref-ZLIB)]. User agents or other programs that decode WOFF files MUST be able to handle tables that have been compressed. If the decompression function fails for any table, the WOFF file is invalid and MUST NOT be loaded.

The font data tables MUST be stored immediately following the table directory, without gaps except for any padding that is required (up to three null bytes at the end of each table) to ensure 4-byte alignment.

Font tables in WOFF files MUST be stored in the same order as the well-formed input font. The table order is implied by `offset` values in the table directory; sorting table directory entries into ascending `offset` value order produces a list of entries in an order equivalent to that of the font tables.

***

Note: User agents need not necessarily reconstitute the input font as a whole, and may reorder tables when decoding the WOFF file to sfnt form; they may access individual tables directly as needed. Under these circumstances the resulting sfnt will no longer be an exact copy of the input font, and checksums or digital signature data may be invalidated as a result.

In some cases, sites deploying WOFF files as Web fonts may wish to subset the character repertoire, optimize table ordering for efficient text layout or rasterization, or remove (or add) optional font tables depending on the particular features needed for a site. User agents might make similar modifications to the font during decoding, such as omitting tables that are not needed by their particular text display system.

The automatic removal of OpenType features such as GPOS and GSUB information at any stage in the process of deploying a WOFF file is strongly discouraged. Many writing systems around the world rely on these features for very basic display of text in the script that they use.

If either a WOFF-creation tool or a WOFF-consuming user agent reorders or otherwise modifies the collection of font tables, the font checksum in the `head` table will need to be recalculated as it will be affected by the changed offsets in the sfnt table directory. Any `DSIG` table in the input font will also be invalidated by such changes, and should therefore be removed from the modified font. A new signature could be added to the modified font, as described by the OpenType and Open Font Format specifications (if appropriate signing credentials are available to the tool involved). Any such pre- and/or post-processing represents a modification of the font data being packaged; while it might be done in conjunction with WOFF packaging for Web deployment, it falls outside the scope of the WOFF specification.

The OpenType/OFF specification does not explicitly prohibit the presence of "extra" data or padding in between the font tables in the sfnt format; as the table directory includes the offset and length of each actual table, such data would simply be ignored. However, the WOFF format makes no provision to preserve such "hidden" non-font-table data when packaging a font, and therefore it would not survive a round-trip format conversion.

***

## 7. Extended Metadata Block

The WOFF file MAY include a block of extended metadata. This may be more extensive and more easily accesible than metadata present in sfnt tables. The metadata block consists of XML data compressed by zlib; the file header specifies both the size of the actual compressed and the original uncompressed size in order to facilitate memory allocation.

The presence (or absence) and content of the metadata block MUST NOT affect font loading or rendering behavior of user agents; it is intended to be purely informative. User agents MAY provide a means for users to view information about fonts (such as a "Font Information" panel). If such information is provided, then they MUST treat the metadata block as the primary source, and MAY fall back to presenting information from the font's `name` table entries when relevant extended metadata elements are not present.

If present, the metadata MUST be compressed; it is never stored in uncompressed form.

The metadata block MUST follow immediately after the last font table. As all font data tables are padded with up to three null bytes if needed to reach a 4-byte boundary, the beginning of the metadata block will always be 4-byte aligned. If the metadata block is the last block in the WOFF file, there SHOULD be no additional padding after the end of the block.

The extended metadata MUST be well-formed XML encoded in UTF-8.

The schema for the extended metadata XML is described below. If the extended metadata does not match this schema, it is invalid. It is also invalid if it cannot be decompressed by zlib's `uncompress()` function (or equivalent), or if the length of the decompressed data does not match the `metaOrigLength` value specified in the WOFF header. Thus, valid metadata is well formed, conforms to the schema below, and is stored in compressed form in the WOFF file. A conforming user agent MUST ignore an invalid metadata block, as if the block were not present.

This description is also available [as a RelaxNG schema](metadata/woffmeta.rng). In the event of a discrepancy between the RelaxNG schema and the text of the specification, the text takes precedence.

Several elements store their data in `text` child elements; this is to support localization. The `text` elements MAY be given a `lang` attribute in the XML namespace [[XML](#ref-XML)]. For backwards compatibility, `lang` attributes in the default namepsace are also accepted in older content, and SHOULD be treated the same as `xml:lang`. New content SHOULD instead use `xml:lang`.

The syntax of values of the `xml:lang` attribute can be found in BCP47 [[BCP47](#ref-BCP47)]. A user agent displaying metadata SHOULD choose a preferred language/locale to display from among those available, following BCP47.

The user agent SHOULD choose which of the available `text` elements to display as follows:

1.  If a `text` element is available that matches the user's preferred language, as determined via an explicit preference or implied by the current locale, use this language.
2.  If the user agent has a concept of a list of "acceptable" languages or defaults, try each of these in turn and use the first one for which a match found.
3.  If there is a `text` element with no `xml:lang` attribute, use this; in the event that more than one exists, use the first of them.
4.  If no match is found yet, use the first `text` element. (Thus, the metadata creator can determine the "localization of last resort" simply by choosing which language to put first in each group of text elements.)

Such localizable elements are indicated by the statement "This element may be localized using `text` child elements" in the description below; the internal structure of `text` elements with `xml:lang` attributes is not repeated for each element type. In each of these localizable elements, at least one text child element MUST be present, except in the case of the `license` element (as described below).

**`metadata` element**

The main element. This element is REQUIRED.

**attributes**

version: A version number indicating the format version of the `metadata` element. This is currently `1.0`. This attribute is REQUIRED.

**children**

uniqueid: Zero or one child elements

vendor: Zero or one child elements

credits: Zero or one child elements

description: Zero or one child elements

license: Zero or one child elements

copyright: Zero or one child elements

trademark: Zero or one child elements

licensee: Zero or one child elements

extension: Zero or more child elements

All first-level child elements of the `metadata` are OPTIONAL, and may occur in any order as children of the top-level metadata element.

The `extension` element is intended to allow vendors to include metadata that is not covered by the specific elements defined here, while following a standard model. User agents that provide a means for the user to view WOFF file metadata SHOULD include such `extension` elements in the metadata presented to the user.

**`uniqueid` element**

A unique identifier string for the font. This element is recommended, but not required for the metadata to be valid. This element MUST be a child of the `metadata` element. This is an empty element.

**attributes**

id: The identification string. This attribute is REQUIRED.

The string defined in the `uniqueid` element is not guaranteed to be truly unique, as there is no central registry or authority to ensure this, but it is intended to allow vendors to reliably identify the exact version of a particular font. The use of "reverse-DNS" prefixes to provide a "namespace" is recommended; this can be augmented by additional identification data of the vendor's own design.

Note: The `id` attribute of the `uniqueid` element, and of several further metadata elements defined below, is not required to conform to the rules for the XML type ID; its form is at the discretion of the font creator or vendor.

**`vendor` element**

Information about the font vendor. This element is recommended, but not required for the metadata to be valid. This element MUST be a child of the `metadata` element. This is an empty element.

**attributes**

name: The name of the font vendor. This attribute is REQUIRED.

url: The url for the font vendor. This attribute is OPTIONAL.

dir: The text direction, either `ltr` (for "left to right") or `rtl` (for "right to left"). This attribute is OPTIONAL and, if omitted, defaults to `ltr`.

class: An arbitrary set of space-separated tokens. This attribute is OPTIONAL.

**`credits` element**

Credit information for the font. This can include any type of credit the vendor desires: designer, hinter, and so on. This element is OPTIONAL. If present, it MUST be a child of the `metadata` element and it MUST contain at least one `credit` element. This element has no attributes.

**children**

credit: One or more child elements

**`credit` element**

A single credit record. If present, it MUST be a child of the `credits` element. This is an empty element.

**attributes**

name: The name of the entity being credited. This attribute is REQUIRED.

url: The url for the entity being credited. This attribute is OPTIONAL.

role: The role of the entity being credited. This attribute is OPTIONAL.

dir: The text direction, either `ltr` (for "left to right") or `rtl` (for "right to left"). This attribute is OPTIONAL and, if omitted, defaults to `ltr`.

class: An arbitrary set of space-separated tokens. This attribute is OPTIONAL.

**`description` element**

An arbitrary text description of the font's design, its history, etc. This element is OPTIONAL. If present, it MUST be a child of the `metadata` element. This element may be localized using `text` child elements.

**attributes**

url: The url for more information about the font design, history, etc. This attribute is OPTIONAL.

**children**

text: One or more child elements containing character data and optionally `div` and/or `span` children

**`license` element**

Licensing information for the font. This element is OPTIONAL. If present, it MUST be a child of the `metadata` element. This element may be localized using `text` child elements; however, it is permitted to be empty (for example, if the vendor prefers to just provide a license URL rather than including the actual text of the license.)

**attributes**

url: The url for the license, more information about the license, etc. This attribute is OPTIONAL.

id: An identifying string for the license. This attribute is OPTIONAL.

**children**

text: Zero or more child elements containing character data and optionally `div` and/or `span` children

**`copyright` element**

The copyright for the font. This element is OPTIONAL. If present, it MUST be a child of the metadata element. This element may be localized using `text` child elements. This element has no attributes.

**children**

text: One or more child elements containing character data and optionally `div` and/or `span` children

**`trademark` element**

The trademark for the font. This element is OPTIONAL. If present, it MUST be a child of the `metadata` element. This element may be localized using `text` child elements. This element has no attributes.

**children**

text: One or more child elements containing character data and optionally `div` and/or `span` children

**`licensee` element**

The licensee of the font. This element is OPTIONAL. If present, it MUST be a child of the `metadata` element. This is an empty element.

**attributes**

name: The name of the licensee. This attribute is REQUIRED.

dir: The text direction, either `ltr` (for "left to right") or `rtl` (for "right to left"). This attribute is OPTIONAL and, if omitted, defaults to `ltr`.

class: An arbitrary set of space-separated tokens. This attribute is OPTIONAL.

Although the metadata elements and structure defined above are expected to be sufficient for most needs, an extension mechanism is also provided so that font vendors can include arbitrary metadata items that do not fit the standard elements above:

**`extension` element**

A container element for extended metadata provided by the vendor. Zero or more `extension` elements may be present as children of the top-level metadata element. Each such metadata `extension` has an optional `name`, which may be provided in multiple languages, and one or more item elements.

**attributes**

id: An arbitrary identifier defined by the vendor. This attribute is OPTIONAL.

**children**

name: Zero or more child elements

item: One or more child elements

item element: At least one item element MUST be present in each `extension` container.

**attributes**

id: An arbitrary identifier defined by the vendor. This attribute is OPTIONAL.

**children**

name: One or more child elements

value: One or more child elements

**`name` element**

Zero or more `name` elements may be used to provide a human-friendly name for the collection of extended metadata items in an `extension` element. A user agent that displays metadata SHOULD choose the name with most the appropriate language from among those available for each named `extension` element. This child element is OPTIONAL in `extension` elements; anonymous extension elements are also permissible.

One or more `name` elements are also used to provide a human-friendly name for a specific extended metadata item. A user agent that displays metadata SHOULD choose the name with the most appropriate language from among those available for each `item` element. This child element is REQUIRED in `item` elements; an `item` element with no` name` is invalid and SHOULD be ignored.

**attributes**

xml:lang: A language tag as defined in BCP47 [[BCP47](#ref-BCP47)]. This attribute is OPTIONAL.

dir: The text direction, either `ltr` (for "left to right") or `rtl` (for "right to left"). This attribute is OPTIONAL and, if omitted, defaults to `ltr`.

class: An arbitrary set of space-separated tokens. This attribute is OPTIONAL.

**`value` element**

One or more `value` elements are used to provide the value of a specific extended metadata item. A user agent that displays metadata SHOULD choose the value with the most appropriate language from among those available for each `item` element. This child element is REQUIRED; an `item` element with no `value` is invalid and SHOULD be ignored.

**attributes**

xml:lang: A language tag as defined in BCP47 [[BCP47](#ref-BCP47)]. This attribute is OPTIONAL.

dir: The text direction, either `ltr` (for "left to right") or `rtl` (for "right to left"). This attribute is OPTIONAL and, if omitted, defaults to `ltr`.

class: An arbitrary set of space-separated tokens. This attribute is OPTIONAL.

Where `text` elements are used to contain (localizable) content, further structure MAY also be provided using `div` and `span` child elements similar to those used in HTML.

**`text` element**

An element used to contain a particular localization of a metadata element's contents. This element has a mixed content model; in addition to the child elements mentioned below, it may directly contain character data.

**attributes**

xml:lang: A language tag (as specified in BCP47 [[BCP47](#ref-BCP47)]) indicating the language of this particular version of the metadata element's content. This attribute is OPTIONAL; however, for multiple `text` children of a metadata element to be usefully distinguished, they SHOULD all be tagged with appropriate different language codes.

dir: The text direction, either `ltr` (for "left to right") or `rtl` (for "right to left"). This attribute is OPTIONAL and, if omitted, defaults to `ltr`.

class: An arbitrary set of space-separated tokens. This attribute is OPTIONAL.

**children**

div: Contains a block of text, such as a paragraph or heading.

span: Contains an inline run of text.

**`div` element**

A block-level element used, for example, to contain a paragraph.

**attributes**

dir: The text direction, either `ltr` (for "left to right") or `rtl` (for "right to left"). This attribute is OPTIONAL and, if omitted, defaults to `ltr`.

class: An arbitrary set of space-separated tokens. This attribute is OPTIONAL.

**`span` element**

An inline element used, for example, to indicate a run of text with a different text direction, or in a different language.

**attributes**

dir: The text direction, either `ltr` (for "left to right") or `rtl` (for "right to left"). This attribute is OPTIONAL and, if omitted, defaults to `ltr`.

class: An arbitrary set of space-separated tokens. This attribute is OPTIONAL.

The `text` elements used to hold (localizable) text for a number of the individual pieces of metadata thus have a mixed content model consisting of text content, `div` and `span` elements; `div` elements have a mixed content model of text content, `div` and `span` elements; and `span` elements have a mixed content model of text content and `span` elements. In other words, div can contain other `div` elements; `span` can contain other `span` elements; `span` does not require a containing `div`.

[Appendix A](#appendix-a) includes several examples of the content of the metadata block.

Note: Although the metadata block is optional, and there is no requirement for user agents to process it in order to render the font, clients such as Web browsers are encouraged to provide a means (such as a "Font Information" dialog for the current page) for users to view the metadata included in WOFF files. Not every client will necessarily have an appropriate context for this, but any client that enables the user to find out about the resources used by a Web document should consider exposing information about the fonts used, and in the case of WOFF-packaged fonts, the metadata block is the primary source of this information.

## 8. Private Data Block

The WOFF file MAY include a block of arbitrary data, allowing font creators to include whatever information they wish. The content of this data MUST NOT affect font usage or load behavior of user agents. User agents should make no assumptions about the content of a private block; it may (for example) contain ASCII or Unicode text, or some vendor-defined binary data, and it may be compressed or encrypted, but it has no publicly defined format. Conformant user agents will not assume anything about the structure of this data. Only the font developer or vendor responsible for the private block is expected to understand its contents.

The private data block, if present, MUST be the last block in the WOFF file, following all the font tables and any extended metadata block. The private data block MUST begin on a 4-byte boundary in the WOFF file, with up to three null bytes inserted as padding after any preceding metadata block if needed to ensure this. The end of the private data block MUST correspond to the end of the WOFF file.

* * *

## Appendix A: Extended Metadata Examples

This appendix is purely informative, not a normative part of the WOFF specification.

This "dummy" metadata block illustrates the use of the metadata elements described in section 7, including the use of multiple `text` child elements to provide localized versions of certain elements.

```
<?xml version="1.0" encoding="UTF-8"?>
<metadata version="1.0">
    <uniqueid id="com.example.fontvendor.demofont.rev12345" />
    <vendor name="Font Vendor" url="http://fontvendor.example.com" />
    <credits>
        <credit
            name="Font Designer"
            url="http://fontdesigner.example.com"
            role="Lead" />
        <credit
            name="Another Font Designer"
            url="http://anotherdesigner.example.org"
            role="Contributor" />
        <credit
            name="Yet Another"
            role="Hinting" />
    </credits>
    <description>
        <text xml:lang="en">
            A member of the Demo font family.
            This font is a humanist sans serif style designed
            for optimal legibility in low-resolution environments.
            It can be obtained from fontvendor.example.com.
        </text>
    </description>
    <license url="http://fontvendor.example.com/license"
             id="fontvendor-Web-corporate-v2">
        <text xml:lang="en">A license goes here.</text>
        <text xml:lang="fr">Un permis va ici.</text>
    </license>
    <copyright>
        <text xml:lang="en">Copyright ©2009 Font Vendor"</text>
        <text xml:lang="ko">저작권 ©2009 Font Vendor"</text>
    </copyright>
    <trademark>
        <text xml:lang="en">Demo Font is a trademark of Font Vendor</text>
        <text xml:lang="fr">Demo Font est une marque déposée de Font Vendor</text>
        <text xml:lang="de">Demo Font ist ein eingetragenes Warenzeichen der Font Vendor</text>
        <text xml:lang="ja">Demo FontはFont Vendorの商標である</text>
    </trademark>
    <licensee name="Wonderful Websites, Inc." />
    <extension id="org.example.fonts.metadata.v1">
        <name xml:lang="en">Additional font information</name>
        <name xml:lang="fr">L'information supplémentaire de fonte</name>
        <item id="org.example.fonts.metadata.v1.why">
            <name xml:lang="en">Purpose</name>
            <name xml:lang="fr">But</name>
            <value xml:lang="en">This font exists merely as an example of WOFF packaging.</value>
            <value xml:lang="fr">Cette fonte existe simplement comme exemple de l'empaquetage de WOFF.</value>
        </item>
    </extension>
</metadata>
```

A real-life example of a simple metadata block (reproduced by permission of FSI FontShop International GmbH).

```
<?xml version="1.0" encoding="UTF-8"?>
<metadata version="1.0">
   <uniqueid id="com.fontfont.PraterScriptWeb.7.504.1002"/>
   <vendor name="FSI FontShop International GmbH" url="http://www.fontfont.com"/>
   <credits>
       <credit name="Steffen Sauerteig" role="design"/>
       <credit name="Henning Wagenbreth" role="design"/>
       <credit name="FSI FontShop International GmbH" url="http://www.fontfont.com" role="production"/>
   </credits>
   <description>
       <text lang="en">A FontFont for the Web</text>
   </description>
   <license url="http://www.fontfont.com/support/licensing_web.ep" id="fontfont-Web-v1">
       <text lang="en">
	      FontFont Web license v 1.0.
	      For details see http://www.fontfont.com/eula/license_Webfonts_v_1_0.html
	    </text>
   </license>
   <copyright>
       <text lang="en">2009 Henning Wagenbreth, Steffen Sauerteig published by FSI FontShop International GmbH</text>
   </copyright>
   <trademark>
       <text lang="en">Prater is a trademark of FSI FontShop International GmbH</text>
   </trademark>
</metadata>
```

Another example of a metadata block (reproduced by permission of Ascender Corporation). This is dynamically generated, with the `uniqueid` and `licensee` elements modified to be unique for each customer.

```
<?xml version="1.0" encoding="UTF-8"?>
<metadata version="1.0">
<uniqueid id="037d0f6b-b5e3-b841-05afa509061b" />
<vendor name="Ascender Corp" url="http://www.fontslive.com" />
<license url="http://www.fontslive.com/info/Web-fonts-eula.aspx"
id="ascender-Webfonts-eula-v1">
<text lang="en">This font software is the valuable property of Ascender
Corporation and/or its suppliers and its use by you is covered under the
terms of the Web Font license agreement between you and Ascender
Corporation. You may ONLY use this font software with the licensed Web site.
Except as specifically permitted by the license, you may not copy this font
software. If you have any questions, please contact Ascender Corp.</text>
</license>
<licensee name="FontsLive.com" />
</metadata>
```

Here is an example of how the div element could be used, modified from a portion of the [XML file for Gentium Plus](http://dev.w3.org/webfonts/WOFF/spec/metadata/GentiumPlus-WOFF-metadata.xml) which, when viewed as plain text, has paragraph formatting.

The original metadata file contained:

```
<description>
 <text lang="en">
	Gentium ("belonging to the nations" in Latin) is a Unicode typeface family 
	designed to enable the many diverse ethnic groups around the world who use 
	the Latin, Cyrillic and Greek scripts to produce readable, high-quality
	publications. The design is intended to be highly readable, reasonably
	compact, and visually attractive. Gentium has won a "Certificate of Excellence
	in Typeface Design" in two major international typeface design competitions: 
	bukva:raz! (2001), TDC2003 (2003).

	The Gentium Plus font family is based on the original design. It currently 
	comes with regular and italic face only, although additional weights are in
	development.

	The goal for this product is to provide a single Unicode-based font family
	that contains a comprehensive inventory of glyphs needed for almost any
	Roman- or Cyrillic-based writing system, whether used for phonetic or
	orthographic needs, and provide a matching Greek face. In addition, there
	is provision for other characters and symbols useful to linguists. This
	font makes use of state-of-the-art font technologies to support complex
	typographic issues, such as the need to position arbitrary combinations
	of base glyphs and diacritics optimally.

   (and so on)
 </text>
</description>
```

Using the `div` element, this could become:

```
<description>
 <text xml:lang="en">
   <div>Gentium ("belonging to the nations" in Latin) is a Unicode
   typeface family designed to enable the many diverse ethnic groups
   around the world who use the Latin, Cyrillic and Greek scripts to
   produce readable, high-quality publications. The design is intended
   to be highly readable, reasonably compact, and visually attractive.
   Gentium has won a "Certificate of Excellence in Typeface
   Design" in two major international typeface design
   competitions: bukva:raz! (2001), TDC2003 (2003).</div>
   <div>The Gentium Plus font family is based on the original design.
   It currently comes with regular and italic face only, although
   additional weights are in development.</div>
   <div>The goal for this product is to provide a single Unicode-based
   font family that contains a comprehensive inventory of glyphs
   needed for almost any Roman- or Cyrillic-based writing system,
   whether used for phonetic or orthographic needs, and provide a
   matching Greek face. In addition, there is provision for other
   characters and symbols useful to linguists. This font makes use of
   state-of-the-art font technologies to support complex typographic
   issues, such as the need to position arbitrary combinations of base
   glyphs and diacritics optimally.</div>

   (and so on)
 </text>
</description>
```

## Appendix B: Media Type registration

This appendix registers a new MIME media type, in conformance with [BCP 13](http://www.ietf.org/rfc/rfc4288.txt) and [W3CRegMedia](http://www.w3.org/2002/06/registering-mediatype.html).

**Type name:** application

**Subtype name:** font-woff

**Required parameters:** None.

**Optional parameters:** None.

**Encoding considerations:** binary.

**Security considerations:** 
    
Fonts are interpreted data structures that represent collections of glyph outlines, metrics and layout information for various languages and writing systems. Currently, there are many standardized font data tables that allow an unspecified number of entries, and where existing, predefined data fields allow storage of binary data with variable length. There is a significant risk that the flexibility of font data structures may be exploited to hide malicious binary content disguised as a font data component.

WOFF is based on the table-based SFNT (scalable font) format which is highly extensible and offers an opportunity to introduce additional data structures when needed. However, this same extensibility may present specific security concerns – the flexibility and ease of defining new data structures makes it easy for any arbitrary data to be added and hidden inside a font file.

WOFF fonts may contain 'hints' for the alignment of graphical elements of the glyphs with the target display pixel grid, and depending on the font technology utilized in the creation of a font these hints may represent active code interpreted and executed by the font rasterizer. Even though they operate within the confines of the glyph outline conversion system and have no access outside the font rendering machinery, hint instructions can be, however, quite complex, and a maliciously designed complex font could cause undue resource consumption (e.g. memory or CPU cycles) on a machine interpreting it. Indeed, fonts are sufficiently complex that most if not all interpreters cannot be completely protected from malicious fonts without undue performance penalties.

Widespread use of fonts as necessary component of visual content presentation warrants that a careful attention should be given to security considerations whenever a font is either embedded into an electronic document or transmitted alongside media content as a linked resource.

WOFF uses gzip compression. The WOFF header contains the uncompressed length of each compressed table. Applications may therefore constrain the size of memory buffer allocated for decompression and may stop writing if a maliciously crafted WOFF file in fact contains more data than is indicated.

WOFF does not provide privacy protections internally; if needed, these should be provided externally.

WOFF has a private data block facility, which may contain arbitrary binary data. WOFF does not provide a means to access this, or to execute any code contained therein. WOFF [requires](#conform-private-noeffect) that the content of this block not affect font rendering in any way.

**Interoperability considerations:**

**Published specification:** This media type registration is extracted from the [WOFF specification](http://www.w3.org/TR/WOFF) at W3C.

**Applications that use this media type:** WOFF is used by Web browsers, often in conjunction with HTML and CSS.

**Additional information:**

**Magic number(s):** The signature field in the WOFF header MUST contain the "magic number" 0x774F4646

**File extension(s):** woff

**Macintosh file type code(s):** (no code specified)

**Macintosh Universal Type Identifier code:** org.w3c.woff

**Fragment Identifiers:** none.

**Person & email address to contact for further information:** Chris Lilley (www-font@w3.org).

**Intended usage:** COMMON

**Restrictions on usage:** None

**Author:** The WOFF specification is a work product of the World Wide Web Consortium's WebFonts Working Group.

**Change controller:** The W3C has change control over this specification.

## Appendix C: Changes

The following changes have been made, relative to the [27 July 2010 First Public Working Draft](http://www.w3.org/TR/2010/WD-WOFF-20100727). No new features have been added, except for optional enhancements to the metadata format; the remaining changes are clarifications and corrections to existing features.

*   Clarified that WOFF is a font _packaging_ or wrapper format, not a new font format as such.
*   Clarified padding and byte-alignment requirements throughout
*   Preferred the term 'input font' rather than 'original file' to describe the font which is converted to WOFF
*   Clarified that any subsetting, checksum-correction, or DSIG invalidating changes _prior_ to WOFF conversion are out of scope for the WOFF specification.
*   Clarified meaning of totalSfntSize.
*   Defined what is meant by a well formed input font.
*   Clarified meaning of 'invalid metadata' - must be well-formed, compressed, and conform to the schema.
*   Clarified which elements and attributes in the XML are required; for elements, clarified their required parents.
*   Clarified that the id attribute is not of type ID in the XML sense
*   Added link to a RelaxNG grammar, which tries to express the same constraints as the prose in a machine-readable manner. The prose is normative in case of any difference.
*   Added reminder to check for overflow when decompressing.
*   Added a Media Type registration template as required by [W3C Media Type registration](http://www.w3.org/2002/06/registering-mediatype.html) policies.
*   Separated normative and informative references.
*   Switched to upper-case for RFC-2119 keywords.
*   Added id and class attributes to all testable assertions.
*   Added some non-normative explanatory notes.
*   Minor clarifications to wording throughout.
*   Some re-ordering of text to group related assertions or to improve readability; in particular, the best practices were previously an appendix and are now integrated into the main body of the specification.
*   Added this Changes appendix.

The following changes were made as a result of Last Call:

*   Language attributes now reference BCP47, and use xml:lang.
*   Added optional `div` and `span` elements that can be used to provide structure within metadata text.
*   Added `dir` and `class` attributes to metadata elements.
*   Removed summary of conformance requirements (duplicated material from the main body of the specification).
*   Somewhat rearranged and clarified description of the metadata format.
*   Noted that same-origin requirements are at risk, in the expectation that CSS3 Fonts will handle this instead.
*   Mention the need to compute the binary search fields when reconstructing an sfnt header.
*   Require that metadata be encoded in UTF-8, rather than allowing either UTF-8 or UTF-16.

A [color-coded diff](http://dev.w3.org/cvsweb/webfonts/WOFF/spec/Overview.html.diff?r1=1.58;r2=1.96;f=h) between the editors draft used to prepare the Last Call Working Draft, and the editors draft used to prepare the Candidate Recommendation, is available.

The following changes were made after publication of the Candidate Recommendation:

*   Removed (previously at-risk) text specifying same-origin requirements for loading WOFF fonts, and CORS mechanism to relax the restriction, as the CSS WG agreed to include this in CSS3 Fonts as part of the specification of the @font-face rule.
*   Moved CSS3-Fonts from normative to informative section, due to removal of at-risk items.
*   Corrected erroneous use of MUST in a general introductory statement

A [color-coded diff](http://dev.w3.org/cvsweb/webfonts/WOFF/spec/Overview.html.diff?r1=1.99;r2=1.112;f=h) between the editors draft used to prepare the Candidate Recommendation, and the editors draft used to prepare the Proposed Recommendation, is available.

The following changes were made after publication of the Proposed Recommendation:

*   The security considerations section of the Media Type Registration appendix was updated to point into the body of the specification, alerting the reader to the private data block and indicating that WOFF does not provide a mechanism to execute any binary code that might be contained therein. This change was made at the request of the IANA Expert Reviewer.

* * *

## References

### Normative References

[BCP47]:  [BCP 47](http://www.rfc-editor.org/rfc/bcp/bcp47.txt) Tags for Identifying Languages and Matching of Language Tags

[OFF]: [Open Font Format specification](http://standards.iso.org/ittf/PubliclyAvailableStandards/
c052136_ISO_IEC_14496-22_2009(E).zip) (ISO/IEC 14496-22:2009).

[RFC-2119]: [RFC 2119:](http://tools.ietf.org/html/rfc2119) Key words for use in RFCs to Indicate Requirement Levels. S. Bradner, Editor. Internet Engineering Task Force, March 1997.

[ZLIB]: [RFC 1950](http://tools.ietf.org/html/rfc1950) ZLIB Compressed Data Format Specification. P. Deutsch, J-L. Gailly, Editors. Internet Engineeering Task Force, May 1996.

### Informative References

[Compress2]: [zlib compress2() function](http://refspecs.linuxbase.org/LSB_3.0.0/LSB-Core-generic/LSB-Core-generic/zlib-compress2-1.html)

[CSS3-Fonts]: [CSS Fonts Module Level 3](http://www.w3.org/TR/css3-fonts/). J. Daggett, Editor. World Wide Web Consortium, 4 October 2011. The [latest version of CSS3 Fonts](http://www.w3.org/TR/css3-fonts/) is available at http://www.w3.org/TR/css3-fonts/. (Work in Progress).

[OpenType]: [Microsoft OpenType specification](http://www.microsoft.com/typography/otspec/), version 1.6. Microsoft, 2009. OpenType is a registered trademark of Microsoft Corporation.

[TrueType]: [Apple TrueType Reference manual](http://developer.apple.com/fonts/TTRefMan/). Apple, 2002. TrueType is a registered trademark of Apple Computer, Inc.

[Uncompress]: [zlib uncompress() function](http://refspecs.linuxbase.org/LSB_3.0.0/LSB-Core-generic/LSB-Core-generic/zlib-uncompress-1.html)

[XML]: [Extensible Markup Language](http://www.w3.org/TR/xml/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
