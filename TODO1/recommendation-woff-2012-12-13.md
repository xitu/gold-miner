> * 原文地址：[WOFF File Format 1.0](https://www.w3.org/TR/2012/REC-WOFF-20121213/)
> * 原文作者：[W3C](https://www.w3.org)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/recommendation-woff-2012-12-13.md](https://github.com/xitu/gold-miner/blob/master/TODO1/recommendation-woff-2012-12-13.md)
> * 译者：
> * 校对者：

# WOFF文件格式 1.0

## W3C 2012 年 12 月 13 日推荐

This version: [http://www.w3.org/TR/2012/REC-WOFF-20121213/](http://www.w3.org/TR/2012/REC-WOFF-20121213/)

Latest version: [http://www.w3.org/TR/WOFF/](http://www.w3.org/TR/WOFF/)

Previous version: [http://www.w3.org/TR/2012/PR-WOFF-20121011/](http://www.w3.org/TR/2012/PR-WOFF-20121011/)

Authors: Jonathan Kew (Mozilla Corporation), Tal Leming (Type Supply), Erik van Blokland (LettError)

Please refer to the [**errata**](http://www.w3.org/Fonts/REC-WOFF-20121213-errata.html) for this document, which may include some normative corrections.

See also [**translations**](http://www.w3.org/2003/03/Translations/byTechnology?technology=WOFF).

[Copyright](http://www.w3.org/Consortium/Legal/ipr-notice#Copyright) © 2012 [W3C](http://www.w3.org/)® ([MIT](http://www.csail.mit.edu/), [ERCIM](http://www.ercim.eu/), [Keio](http://www.keio.ac.jp/)), All Rights Reserved. W3C [liability](http://www.w3.org/Consortium/Legal/ipr-notice#Legal_Disclaimer), [trademark](http://www.w3.org/Consortium/Legal/ipr-notice#W3C_Trademarks) and [document use](http://www.w3.org/Consortium/Legal/copyright-documents) rules apply.

* * *

## 摘要

本文档指定了 WOFF 字体的打包格式。这种格式旨在提供轻量级的、易于实现的字体数据压缩，适用于 CSS @ font-face 规则。任何获得许可的 TrueType/OpenType/Open 字体格式文件都可以打包成 WOFF 格式以在 Web 上使用。用户代理解码 WOFF 文件以恢复字体数据，使其显示时与输入的字体相同。

WOFF 格式还允许附加元数据到相关文件；字体设计人员或供应商可以使用此字体来包含许可或者其他信息，而不是原始字体中的信息。这样的元数据不会以任何方式影响字体的呈现，但可以根据需要向用户显示。

WOFF 格式并不准备取代其他格式，例如 TrueType/OpenType/Open Font Format 或 SVG 字体，但为使用这些格式可能不太理想的情况下提供了一种替代方案，或者为因许可方面的原因导致使用不太合适的情况下提供了替代方案。

## 本文档的状态

本节介绍本文件发布时的状态。 其他文件可能会取代本文件。 当前的 W3C 出版物清单和此技术报告的最新版本可以在[W3C技术报告索引](http://www.w3.org/TR/) http://www.w3.org/TR/ 中找到。

这是“ WOFF 文件格式1.0 ”的 W3C 推荐标准。 本文档已由 W3C 会员，软件开发人员以及其他 W3C 团体和有关各方进行了审核，并由署长确认为 W3C 的推荐标准。 它是一个稳定的文件，可以用作参考资料或由其他文件引用。 W3C 在制定建议书时的角色是引起对规范的关注并促进其广泛部署。 这增强了Web的功能和互操作性。
W3C在制定推荐标准时的角色是引起对规范的关注并促进其广泛部署。这增强了 Web 的功能性和互操作性。

请将有关本文档的意见发送至[www-font@w3.org](mailto:www-font@w3.org)（在[public archive](http://lists.w3.org/Archives/Public/www-font/)可查看）。

相对于[2011年10月11日提议的推荐标准](http://www.w3.org/TR/2012/PR-WOFF-20121011/)，本规范已经进行了编辑，纳入了对互联网媒体类型注册的微小更改,这是 IANA 专家审核的结果。 [更改附录](#changes)描述了所做的更改。

CR退出标准是：

1. 已经收集了足够的实施经验报告来证明“ WOFF文件格式1.0 ”的语法和特征是可实施的并且以一致的方式解释。 为此，工作组将确保所有功能都至少以两种实现方式以可互操作的方式实施。

2. 这些实现是独立开发的。


工作组制定了如下公共测试程序组：

*  [用户代理测试](http://dev.w3.org/webfonts/WOFF/tests/UserAgent/Tests/xhtml1/testcaseindex.xht)

*  [创作工具测试](http://dev.w3.org/webfonts/WOFF/tests/AuthoringTool/Tests/xhtml1/testcaseindex.xht)

*  测试[文件格式本身](http://dev.w3.org/webfonts/WOFF/tests/Format/Tests/xhtml1/testcaseindex.xht)的数据
    

开发了一个[ WOFF 验证器](http://dev.w3.org/webfonts/WOFF/tools/validator/)，以进行规范中指明的所有文件格式的检查。 验证器通过了100%的测试。 新的 W3C 测试工具用于部署以下测试：[创作工具测试工具](http://www.w3c-test.org/framework/suite/woff-at/)和[用户代理测试工具](http://www.w3c-test.org/framework/suite/woff-ua/)。

[用户代理实施报告](http://w3c-test.org/framework/review/woff-ua/)和[创作工具实施报告](http://w3c-test.org/framework/review/woff-at/)是可用的。

本文档最初由[www-font@w3.org](mailto:www-font@w3.org) 邮件列表的贡献者撰写。 试用后，它成为 [WOFF 提交](http://www.w3.org/Submission/2010/SUBM-WOFF-20100408/)的内容，并由W3C的 [WebFonts工作组](http://www.w3.org/Fonts/WG/)进一步开发。

本文档由 [2004 年 2 月 5 日 W3C 专利政策](http://www.w3.org/Consortium/Patent-Policy-20040205/)下运营的小组编制。 W3C保留与工作组交付内容有关的[任何专利公开清单](http://www.w3.org/2004/01/pp-impl/44556/status); 该页面还包括披露专利的说明。具有专利实际知识的个人认为其包含[基本要求](http://www.w3.org/Consortium/Patent-Policy-20040205/#def-essential) ，必须根据 [W3C 专利政策第 6 部分](http://www.w3.org/Consortium/Patent-Policy-20040205/#sec-Disclosure)披露信息。

## 1.简介

本文档为字体指定了一种简单的压缩文件格式，主要用在 Web 上并称为 WOFF（Web Open Font Format）。 尽管它有这个名字，WOFF 应该被认为是一种容器格式，或者是已经存在的格式的字体数据的“包装”，而不是真正的字体格式。

WOFF 格式是一个容器，用于 比如 TrueType [[TrueType](#ref-TT)]，OpenType [[OpenType](#ref-OT)]和 Open Font Format[[OFF](#ref-OFF)] 字体等基于表的 sfnt 结构中， 以下简称sfnt字体。 WOFF文件仅仅是一个sfnt字体的重新包装版本，提供可选压缩字体数据表。 WOFF 文件格式还允许将字体元数据和专用数据与字体数据分别包含。 WOFF 编码工具将输入的 sfnt 字体转换为 WOFF 格式的文件，并且用户代理还原 sfnt 字体数据以用于 Web 文档。

解码的字体数据的结构和内容与格式正确的输入字体文件完全匹配。 生成 WOFF 文件的工具可能会提供其他字体编辑功能，例如字形子集，验证或字体功能添加，但这些被认为不在此格式的范围之内。独立于这些特征，工具和用户代理都希望能够保证底层字体数据的有效性。

### 符号规定

"MUST"、 "MUST NOT"、 "REQUIRED"、 "SHALL"、 "SHALL NOT"、 "SHOULD"、 "SHOULD NOT"、 "RECOMMENDED"、 "MAY"、和 "OPTIONAL" 中的全部大写关键字，本文档将按照 RFC 2119 [[RFC-2119](#ref-RFC-2119)] 中的描述进行解释。 如果这些词出现在较低或混合的情况下，则应按照其正常的英语含义进行解释。

本文件包括以“注释”形式出现并从规范的正文引出的文本。 这些注释的目的是作为某些信息的解释或澄清某些内容，它们是制定人和用户的提示或指导，但不属于规范性文本的一部分。

## 2. 一般要求

WOFF 格式的主要目的是通过 CSS @ font-face 规则打包并链接到 Web文档。 支持 WOFF 文件格式的链接字体的用户代理必须遵守 CSS3 字体规范（[[CSS3-Fonts](#ref-CSS3-Fonts)] [第 4.1 节：@ font-face 规则](http://www.w3.org/TR/css3-fonts/#font-face-rule)）的要求。 特别是，这种链接的字体只适用于引用它们的文档; 它们不能被用户系统上的其他应用程序或文档使用。

WOFF 格式旨在与 @ font-face 一起使用，以提供链接字体到特定的 Web 文档。 因此，在桌面操作系统或类似的环境中，不得将 WOFF 文件视为可安装的字体格式。 WOFF 封装的数据通常会被解码为 sfnt 格式，以供预期使用 OpenType 字体数据的字体渲染 API 使用，但此类解码字体不得暴露给其他文档或应用程序。

## 3. 整体文件结构

WOFF 文件的结构类似于 sfnt 字体的结构：一个表索引（包含单个字体数据表的长度和偏移量），其后是数据表本身。 sfnt 结构在 TrueType [[TrueType](#ref-TT)]、OpenType [[OpenType](#ref-OT)] 和 Open Font Format [[OFF](#ref-OFF)] 规范中有详细描述。

文件的主体由与输入 sfnt 字体相同的字体数据表集合组成，按照相同的顺序存储，此外，每个表可以被压缩，并且 sfnt 表索引被 WOFF 表索引替换。

WOFF 规范并不保证包装在有效的 WOFF 容器中的实际字体数据是正确和可用的。它仅需要 WOFF 的包装结构 —— 标题、表索引和压缩表 —— 符合此规范。包含的数据必须与以“原始”形式或通过任何其他打包方式传输的字体数据一样谨慎使用。

一个完整的 WOFF 文件由这几部分组成：一个 44 字节的头，紧跟着（按此顺序）的是一个可变大小的表索引，一个可变数量的字体表，一个可选的扩展元数据块和一个可选的专有块数据。除了在指定表长度或块偏移的4字节对齐的地方填充最多三个空字节外，WOFF 标题和表索引所指示的数据块或字体数据表之间**不得**存在任何无关数据，或超出最后一个如上所述的块或表。如果存在这样的无关数据，则符合规范的用户代理必须视该文件为无效并拒绝。如果任何数据块或字体表的偏移量和长度表明文件的重叠字节范围或文件的扩展范围超出文件末尾，则该文件也必须被视为无效并拒绝。

**WOFF 文件**

WOFFHeader（WOFF头）:包含基本字体类型和版本的文件头，以及元数据和专有数据块的偏移量。

TableDirectory（表索引）: 字体表的索引，指示 WOFF 文件内每个表的原始大小，压缩大小和位置。

FontTables（字体表）：来自输入 sfnt 字体的字体数据表，经过压缩以减少带宽需求。

ExtendedMetadata（扩展元数据）：扩展元数据的可选块，以XML格式表示并被压缩以便存储在 WOFF 文件中。

PrivateData（专有数据）：可供字体设计师，机构或供应商使用的可选的专有数据块。

存储在 WOFF Header 和 WOFF Table Directory 部分中的数据值以 big-endian （大端格式）格式存储，就像 sfnt 字体中的值一样。 以下基本数据类型使用如下描述：

**数据类型**

UInt32：32位（4字节）大端格式的无符号整数

UInt16：16位（2字节）大端格式的无符号整数

除非另有说明，否则本文档中描述的所有大小和偏移量均以字节为单位。

## 4. WOFF 头

标题包含识别签名，并指示文件中包含的特定种类的字体数据（TrueType 或 CFF 轮廓数据）; 它还有一个字体版本号，补充数据块的偏移量以及紧跟在标题后面的表索引中的条目数量：

**WOFF 头**

UInt32: signature  0x774F4646 `'wOFF'`

UInt32: flavor  输入字体的“ SFNT 版本”

UInt32: length  WOFF文件的总大小。

UInt16: numTables 字体表索引中的条目数。

UInt16: reserved 保留；设置为零。

UInt32: totalSfntSize  未压缩字体数据所需的总大小，包括 sfnt 头，索引和字体表（包括填充）。

UInt16: majorVersion WOFF文件的主要版本。

UInt16: minorVersion WOFF文件的次要版本。

UInt32: metaOffset 从WOFF文件开始到元数据块的偏移量。

UInt32: metaLength  压缩元数据块的长度。

UInt32: metaOrigLength 元数据块的未压缩长度。

UInt32: privOffset 从WOFF文件开始到专有数据块的偏移量。

UInt32: privLength 专有数据块的长度。

WOFF头中的 `signature` 字段必须包含“幻数” 0x774F4646。 如果该字段不包含此值，则用户代理必须拒绝该文件为无效。

'flavor' 字段对应于在 sfnt 文件开始处找到的 “sfnt version”字段，表示包含的字体数据的类型。 虽然目前仅支持类型 0x00010000（版本号1.0作为16.16定点值，表示TrueType字形数据）和 0x4F54544F（表示CFF字形数据的标签“OTTO”）的字体，但是如果 `flavor` 字段包含不同的值(（表示不同 sfnt flavor 的 WOFF打包版本），那么在 WOFF 文件也不会出错。（例如，值 0x74727565 `true'`已被用于Mac OS上的某些 TrueType-flavored 字体）。客户端软件是否实际上支持其他类型的 sfnt 字体数据不在 WOFF 规范的范围之内，该规范仅描述 sfnt 如何重新打包以供 Web 使用。

WOFF 的 “majorVersion” 和 “minorVersion” 字段表示给定的WOFF文件的版本号，该版本号可以基于输入字体的版本号，但不是必需的。 这些字段对用户代理中的字体加载或使用行为没有影响。

`totalSfntSize` 字段是未压缩字体表大小的总和，每个大小填充4个字节的倍数，再加上 sfnt 头和表索引的大小。 因此，这是将完整的 WOFF 打包字体（而不是元数据，不是输入 sfnt 文件的一部分）解码为标准 sfnt 结构所需的缓冲区大小。 这个值必须是4的倍数，因为包括最后一个的所有字体表都被填充到一个4字节的边界内。 如果此值不正确，则符合规范的用户代理必须视该文件为无效并拒绝。

sfnt头文件包含三个字段（`searchRange`，`entrySelector` 和 `rangeShift`），用于简化表索引的二进制搜索。 由于每个字段的正确值可以直接从字体表中计算出来，因此它们不会存储在 WOFF 文件中。 因此，将 WOFF 文件解码为 sfnt 结构的用户代理必须按照 OpenType / OFF 规范中的描述，计算 sfnt 头中这些字段的正确值。[[OFF]（#ref-OFF)]

注意：`totalSfntSize`的正确值可以用如下所示的伪代码进行计算：

```
totalSfntSize = 12 // size of sfnt header ("offset table" in the OpenType spec)
totalSfntSize += 16 * numTables // size of table record (directory of font tables)
for each table:
    totalSfntSize += (table.origLength + 3) & 0xFFFFFFFC // table size, padded
```

如果元数据或私有块中的任何一个或两个都不存在，相关的偏移和长度字段**务必**设置为零。 如果元数据或专有数据的偏移量和长度字段表示与其他数据块或表重叠，或者超出文件末尾的字节范围，则符合规范的用户代理必须视该文件为无效并拒绝。

标题包含一个 `reserved` 字段; 这个必须设置为零。如果该字段不为零，则符合规范的用户代理必须视该文件为无效并拒绝。

## 5. 表索引

表索引是一个关于 WOFF 表索引条目的数组，如下定义。 该索引紧跟在 WOFF 文件头的后面; 因此，在头中没有明确指向该块的偏移量。 其大小是通过将 WOFF 文件头中的 numTables 值乘以单个 WOFF 表索引的大小来计算的。 每个表索引指定单个字体数据表的大小和位置。

**WOFF TableDirectoryEntry（表索引条目）**

UInt32：tag 4 字节的 sfnt 表标识符。

UInt32：offset 从WOFF文件开始到数据的偏移量。

UInt32：compLength 压缩数据的长度，不包括填充。

UInt32：origLength 未压缩的表的长度，不包括填充。

UInt32：origChecksum 未压缩表的校验和。

`tag` 值的格式由 sfnt 字体的规格定义。 `offset` 和 `compLength` 字段标识压缩字体表的位置。 `origLength` 和 `origCheckSum` 字段是输入字体表索引中输入字体表的长度和校验和。

sfnt 格式规范要求字体表以4字节边界对齐。 长度不是4的倍数的字体表填充空字节，直到下一个4字节边界。 WOFF 文件中的字体数据表具有相同的要求：它们**必须**从4字节边界开始，并填充到下一个4字节边界。 表目录中的 `compLength` 和 `origLength` 字段存储确切的、未填充的长度。

如果`offset` 和 `compLength` 值指示的字节范围与其他数据块或字体表重叠，或者如果字节范围超出文件末尾，则符合规范的用户代理必须视该文件为无效并拒绝。

如果压缩字体表的长度等于或大于输入字体表的长度，则字体表**必须**未压缩存储在 WOFF 文件中，并将 `compLength` 设置为等于 `origLength`。 工具也**可以**选择不压缩其他表（例如，所有小于特定大小的表），在这种情况下，`compLength` 将等于这些表的 `origLength`。 包含 `compLength` 大于 `origLength` 的表索引条目的 WOFF 文件被认为是无效的，并且**不能**由用户代理加载。 包含压缩字体表的文件解压缩后的大小不等于 `origLength` 也被认为是无效的，并且**不能**被加载。

sfnt 字体规范要求表目录条目按 `tag` 值的升序进行排序。 为了简化处理，WOFF 生成工具必须生成一个表索引，其中的条目按照`tag` 值升序排列。 用户代理必须同样确保在将字体数据恢复到其未压缩状态时，sfnt 表索引按照升序`tag`顺序重新创建。字体表本身的排序与索引条目的顺序无关，如下所述。

sfnt 字体为表索引中的每个表存储校验和，以及为在`head`表中整个字体存储总体校验和（关于每个计算的定义，请参见 TrueType、OpenType 或 Open Font 格式规范）。 生成 WOFF 文件的工具必须验证这些校验和，并在发现错误时拒绝该字体。

WOFF 文件包含一组与创建它的输入字体相同的字体表。 这意味着，从符合规范的 WOFF 文件解压缩字体的总体字体校验和将始终与格式正确的输入字体中的校验和相匹配。在输入字体包含未引用数据（这些未引用数据在实际表之间或之后）的情况下，这会影响输入字体的总体校验和，但在创建 WOFF 文件时会丢失。

格式正确的输入字体没有结构异常，比如填充不正确，字体表重叠，表（将由WOFF生成器丢弃）之间的外部数据或校验和不正确。

一个格式良好的输入字体应符合 OpenType/OFF 规范中并不严格要求的某些规范，以确保从 sfnt 到 WOFF 和 back 的无损往返转换是可能的，尽管它们是常用的做法：

**字体表填充**

OpenType/OFF 规范并不完全清楚 sfnt 字体中的 **所有** 表是否必须用 0-3 个零字节填充到4字节长度的倍数，或者这仅适用于**中间**表，或者文件的最终表可能并不需要填充。 大多数常用工具和字体似乎都希望所有的表都被填充到一个4字节的边界，包括最后一个。 WOFF 规范假定了这种行为，并指定 WOFF 头中的`totalSfntLength` 字段提供了这种填充。 为了确保给定的字体可以打包成 WOFF 文件，然后解码为原始格式，并给出一个字节一个字节的相同结果，输入字体应该被填充为4个字节的倍数。

**无"隐藏"数据**

OpenType/OFF 规范没有明确禁止在字体表之间存在“额外”的数据或填充; 由于表索引包含每个实际表的偏移量和长度，这些数据将被忽略。 然而，在打包字体时，WOFF格式没有规定保留这种非字体表数据，因此在格式互相转换时它不会被保留。

**Header 字段是正确的**

因为 WOFF 格式不直接保存这些字段，所以设计用于提高表索引的二进制搜索的 OpenType/OFF header 字段（`searchRange`、`entrySelector`、`rangeShift`）必须在输入 sfnt 文件中是正确的，但假设 WOFF 解码器将根据需要重新计算它们。

**Checksums （校验和）是正确的**

WOFF 规范规定，表的 checksums 必须由 WOFF 创建者验证（并在必要时进行更正）。 因此，为了实现完整的往返保真度，输入 sfnt 文件中的 checksums 在 WOFF 封装之前也必须是正确的。

**无重叠表**

输入sfnt表索引中的偏移量和长度值不能指示输入字体的重叠字节范围。

创建一个 WOFF 文件然后解码这个文件以重新生成一个 sfnt 字体的结果必须产生一个最终字体，该字体与格式正确的输入字体按位相同。如果输入字体有缺陷或异常使得这个不可能， WOFF生成工具**应该**拒绝字体或发出适当的警告，即无法进行无损往返转换。

## 6. 字体数据表

WOFF 文件中的字体数据表与输入字体中的表完全相同，只是每个表可能已被压缩。如果是压缩的，那么它必须是被 zlib [[Compress2](ref-Compress2)]（或等效的兼容算法）的`compress2（）`函数压缩。 用户代理使用zlib [[Uncompress](#ref-Uncompress)]（或等效的兼容算法）的`uncompress（）`函数对每个表进行解压缩。 这些函数使用的基础格式在 ZLIB 规范[[ZLib](#ref-ZLIB)]中有描述。 用户代理或解码 WOFF 文件的其他程序必须能够处理已压缩的表。 如果任何表的解压缩函数失败，则 WOFF 文件无效并且不能被加载。

字体数据表**必须**存储在表索引之后，除了所需的任何填充（每个表末尾最多三个空字节）以确保4字节对齐之外，不能有间隙。

WOFF 文件中的字体表**必须**以与格式正确的输入字体相同的顺序存储。 表顺序由表索引中的 `offset` 值指定; 将表索引条目按照 `offset` 值升序排列，以与字体表顺序相同的顺序生成条目列表。

***

注意：用户代理不需要输入字体重建为一个字体数据表，并且可以在将 WOFF 文件解码为 sfnt 形式时将数据表重新排序;他们可以根据需要直接访问各个表。在这些情况下，生成的 sfnt 将不再是输入字体的精确副本，并且 checksums 或数字签名数据可能因此失效。

在某些情况下，将 WOFF 文件部署为 Web 字体的站点希望能够实现：将字符库集成到子集中，根据站点所需的特定功能优化表排序以实现高效的文本布局或光栅化，亦或删除（或添加）可选字体表。用户代理可能在解码期间对字体进行类似的修改，例如省略其特定文本显示系统不需要的表。

强烈建议在部署 WOFF 文件的任何阶段自动删除 OpenType 属性，例如 GPOS 和 GSUB 信息。世界各地的许多书写系统在他们使用的脚本中都依靠这些属性进行非常基本的文本显示。

如果 WOFF 创建工具或 WOFF 终端用户代理重新排序或以其他方式修改字体表的集合，则需要重新计算 `head` 表中的字体的 checksum，因为它将受到 sfnt 表索引中已更改的偏移量的影响。输入字体中的任何 `DSIG` 表也会因此类更改而失效，因此应从修改后的字体中删除。如 OpenType 和 Open Font Format 规范所述（如果适用的签名凭证可用于所涉及的工具），新的签名可以添加到修改的字体中。任何这样的预处理和/或后处理都表示对被打包的字体数据的进行了修改;虽然它可能与用于 Web 部署的 WOFF 打包一起完成，但它不属于 WOFF 规范的范围。

OpenType/OFF 规范没有明确禁止在 sfnt 格式的字体表之间存在“额外”数据或填充；由于表索引包含每个实际表的偏移量和长度，所以这些数据将被忽略。然而，在打包字体时，WOFF 格式没有规定保留这种“隐藏的”非字体表数据，因此它不能在格式互相转换时被保留。

***

## 7. 扩展的元数据块

WOFF 文件可能包含一个扩展的元数据块。这可能比 sfnt 表格中的元数据更广泛和更容易访问。元数据块由被 zlib 压缩的 XML 数据组成;文件头指定了实际压缩的大小和原始的未压缩大小，以便于内存分配。

元数据块的存在（或不存在）和内容不得影响用户代理的字体加载或渲染行为;它旨在提供纯粹的信息。用户代理可以为用户提供查看字体信息的方法（如“字体信息”面板）。如果提供了这样的信息，那么它们**必须**将元数据块视为主要来源，并且在相关的扩展元数据元素不存在时，**可以**从字体的 `name` 表条目提取信息。

如果存在，则必须压缩元数据;它从不以未压缩的形式存储。

元数据块必须紧跟在最后一个字体表之后。由于如果需要达到 4 字节的边界，所有字体数据表都填充了多达三个空字节，元数据块的开始始终是 4 字节对齐的。如果元数据块是 WOFF 文件中的最后一个块，那么在块结束后不应该有额外的填充。

扩展元数据**必须**是以 UTF-8 编码的格式良好的XML。

下面描述扩展元数据XML的模式。如果扩展元数据与该模式不匹配，则它是无效的。如果它不能通过 zlib 的 `uncompress（）` 函数（或等价的）解压缩，或者解压缩数据的长度与 WOFF 头中指定的 `metaOrigLength` 值不匹配，那么它也是无效的。因此，有效的元数据应该是格式良好，符合以下模式，并以压缩形式存储在 WOFF 文件中。符合规范的用户代理必须忽略无效的元数据块，就好像该块不存在一样。

[符合 RelaxNG 模式](metadata/woffmeta.rng) 的描述也是对的。如果 RelaxNG 模式与规范文本之间存在差异，则文本优先。

多个元素将其数据存储在 `text` 子元素中；这是为了支持本地化。可以在 XML 的命名空间 [[XML](#ref-XML)] 中为 `text` 元素赋予一个 `lang` 属性。为了向后兼容，默认命名空间中的 `lang` 属性在旧内容中也被接受，并且**应当**与 `xml：lang` 同等对待。新内容中**应当**使用`xml：lang`。

可以在BCP47 [[BCP47](#ref-BCP47)]中找到 `xml：lang` 属性值的语法。根据 BCP47 的规定，显示元数据的用户代理应该选择一个首选的语言/区域来显示可用的语言/区域，。

用户代理**应当**选择可用的 `text` 元素显示如下：

1. 如果可用的text元素与用户的首选语言相匹配（通过显式偏好确定或由当前语言环境确定），请使用此语言。
2. 如果用户代理具有“可接受”语言或默认列表的概念，请依次尝试每种方法并使用匹配的第一个。
3. 如果有一个没有 `xml：lang` 属性的 `text` 元素，就使用这个：如果存在多个，请使用其中的第一个。
4. 如果尚未找到匹配项，请使用第一个 `text` 元素。（因此，元数据创建者可以简单地通过在每个文本元素组中选择首先放置哪种语言来确定“最后的本地化手段”。）

这种可本地化的元素由“这个元素可以使用`text`子元素进行本地化”这个描述来表达，带 `xml：lang` 属性的 `text` 元素的内部结构对每个元素类型都不会重复。在每个本地化元素中，至少有一个文本子元素**必须**存在，除了`license`元素外（如下所述）。

**`metadata` 元素**

主元素。 这个元素是**必需的**。

**属性**

版本：指示 `metadata` 元素格式版本的版本号。 目前这是`1.0`。 该属性是**必需的**。

**子元素**

uniqueid: 零个或一个子元素

vendor: 零个或一个子元素

credits: 零个或一个子元素

description: 零个或一个子元素

license: 零个或一个子元素

copyright: 零个或一个子元素

trademark: 零个或一个子元素

licensee: 零个或一个子元素

extension: 零个或一个子元素

元数据的所有第一级子元素都是可选的，并且可以作为顶级元数据元素的子元素以任何顺序出现。

`extension` 元素旨在允许供应商在遵循标准模型的同时包含未在此定义的特定元素的元数据。 为用户提供查看 WOFF 文件元数据方法的用户代理**应当**在呈现给用户的元数据中包含这样的 `extension` 元素。

**`uniqueid` 元素**

字体的唯一标识字符串。 推荐使用此元素，但不要求元数据有效。 这个元素**必须**是元数据元素的子元素。 这是一个空元素。

**属性**

id：标识字符串。 该属性是**必需的**。

`uniqueid` 元素中定义的字符串并不保证是唯一的，因为没有中央注册机构或权威机构来确保这一点，但它的目的是让供应商可靠地识别特定字体的确切版本。 建议使用“反向 DNS ”前缀来提供“命名空间”; 这可以通过供应商自己设计的附加识别数据来增强。

注意：`uniqueid` 元素的 `id` 属性以及下面定义的其他几个元数据元素的 `id` 属性不需要符合 XML 类型的 ID 规则; 其形式由字体创建者或供应商自行决定。

**`vendor` 元素**

有关字体供应商的信息。 推荐使用此元素，但不要求元数据有效。 这个元素必须是元数据元素的子元素。这是一个空元素。

**属性**

name：字体供应商的名称。该属性是**必需的**。

url：字体供应商的网址。该属性是**可选的**。

dir：文本方向，可以是`ltr`（用于“从左到右”）或`rtl`（用于“从右到左”）。该属性是可选的，如果省略，则默认为`ltr`。

class：一组用空格任意分隔的令牌。 该属性是**可选的**。

**`credits` 元素**

字体的信用信息。 这可以包括供应商期望的任何类型的信用：设计师，调解员等等。 这个元素是**可选的**。 如果存在，它**必须**是`metadata` 元素的子元素，并且必须包含至少一个 `credit` 元素。 这个元素没有属性。

**子元素**

credit: 一个或多个子元素

**`credit` 元素**

单一的信用记录。 如果存在，它**必须**是 `credits` 元素的子元素。 这是一个空元素。

**属性**

name：被记入的实体的名称。 该属性是**必需的**。

url：被记录的实体的url。 该属性是**可选的**。

角色：被记入实体的角色。 该属性是**可选的**。

dir：文本方向，可以是`ltr`（用于“从左到右”）或`rtl`（用于“从右到左”）。 该属性是可选的，如果省略，则默认为`ltr`。

class：一组用空格任意分隔的令牌。 该属性是**可选的**。

**`description` 元素**

字体设计的任意文本描述，历史记录等。这个元素是**可选的**。 如果存在，它必须是 `metadata` 元素的子元素。 这个元素可以使用 `text` 子元素进行本地化。

**属性**

url：有关字体设计，历史等的更多信息的URL。此属性是**可选的**。

**子元素**

text：一个或多个包含字符数据的子元素，以及可选的`div`和/或`span`子元素

**`license` 元素**

字体的许可信息。 这个元素是**可选的**。 如果存在，它必须是 `metadata` 元素的子元素。 这个元素可以使用 `text` 子元素进行本地化; 但是，它被允许为空（例如，如果供应商更喜欢仅提供许可证URL而不包括许可证的实际文本）。

**属性**

url：许可证的 URL，有关许可证的更多信息等。此属性是**可选的**。

id：许可证的标识字符串。 该属性是**可选的**。

**子元素**

text：零个或多个子元素，包含字符数据和可选的`div`和/或`span`子元素

**`copyright` 元素**

字体的版权。 这个元素是**可选的**。 如果存在，它**必须**是元数据元素的子元素。 这个元素可以使用 `text` 子元素进行本地化。 这个元素没有属性。

**子元素**

text：一个或多个包含字符数据的子元素，以及可选的`div`和/或`span`子元素

**`trademark` 元素**

字体的商标。 这个元素是**可选的**。 如果存在，它**必须**是 `metadata` 元素的子元素。 这个元素可以使用 `text` 子元素进行本地化。 这个元素没有属性。

**子元素**

text：一个或多个包含字符数据的子元素，以及可选的`div`和/或`span`子元素

**`licensee` 元素**

字体的被许可人。 这个元素是**可选的**。 如果存在，它**必须**是 `metadata` 元素的子元素。 这是一个空白的元素。

**属性**

name：被许可人的名字。 该属性是**必需的**。

dir：文本方向，可以是`ltr`（用于“从左到右”）或`rtl`（用于“从右到左”）。 该属性是可选的，如果省略，则默认为`ltr`。

class：一组用空格任意分隔的令牌。 该属性是**可选的**。

尽管上面定义的元数据元素和结构预计足以满足大多数需求，但还是提供了扩展机制，以便字体供应商可以包含不符合上述标准元素的任意元数据项目：

**`extension` 元素**

A container element for extended metadata provided by the vendor. Zero or more `extension` elements may be present as children of the top-level metadata element. Each such metadata `extension` has an optional `name`, which may be provided in multiple languages, and one or more item elements.
供应商提供的扩展元数据的容器元素。 零个或多个 `extension` 元素可以是顶级元数据元素的子元素。 每个这样的 `extension` 元数据具有可选的 `name`，其可以以多种语言提供，并且具有一个或多个项目元素。

**属性**

id：供应商定义的任意标识符。 该属性是**可选的**。

**子元素**

name: 零个或多个子元素

item: 一个或多个子元素

item element：每个 `extension` 容器中**必须**至少存在一个项目元素。

**属性**

id：供应商定义的任意标识符。 该属性是**可选的**。

**子元素**

name: 一个或多个子元素

value: 一个或多个子元素

**`name` 元素**

可以使用零个或多个 `name` 元素来为扩展元素中的扩展元数据项集合提供一个人性化的名称。显示元数据的用户代理**应当**从每个指定 `extension` 元素的可用语言中选择最合适的语言。这个子元素在`extension`元素中是可选的；匿名扩展元素也是允许的。

还可以使用一个或多个 `name` 元素为特定的扩展元数据项提供人性化的名称。显示元数据的用户代理应该从每个 `item` 元素的可用语言中选择最合适的语言。 这个子元素在 `item` 元素中是**必需**的；没有 `name` 的 `item` 元素是无效的，应该被忽略。

**属性**

xml:lang: A language tag as defined in BCP47 [[BCP47](#ref-BCP47)]. This attribute is OPTIONAL.

dir: The text direction, either `ltr` (for "left to right") or `rtl` (for "right to left"). This attribute is OPTIONAL and, if omitted, defaults to `ltr`.

class: An arbitrary set of space-separated tokens. This attribute is OPTIONAL.

xml：lang：  BCP47 [[BCP47](#ref-BCP47)]中定义的语言标签。 该属性是可选的。

dir：  文本方向，可以是`ltr`（用于“从左到右”）或`rtl`（用于“从右到左”）。 该属性是可选的，如果省略，则默认为`ltr`。

class：  一组用空格任意分隔的令牌。 该属性是**可选的**。

**`value` 元素**

一个或多个`value`元素用于提供特定扩展元数据项的值。 显示元数据的用户代理**应当**从每个`item`元素的可用语言中选择最合适的语言值。这个子元素是必需的; 没有 `value` 的 `item` 元素是无效的，应该被忽略。

**属性**

xml：lang：  BCP47 [[BCP47](#ref-BCP47)]中定义的语言标签。 该属性是**可选的**。

dir：  文本方向，可以是`ltr`（用于“从左到右”）或`rtl`（用于“从右到左”）。 该属性是**可选的**，如果省略，则默认为`ltr`。

class：一组任意空格分隔的令牌。 该属性是**可选的**。

在使用'text'元素来包含（可本地化）内容的地方，也可以使用 `div` 和 `span` 子元素来提供进一步的结构，类似于HTML中使用的元素。

**`text` 元素**

一个用于包含元数据元素内容的特定本地化的元素。该元素具有混合内容模型; 除了下面提到的子元素之外，它可以直接包含字符数据。

**属性**

xml：lang：语言标记（如BCP47 [[BCP47](#ref-BCP47)]中指定的），指示元数据元素内容的此特定版本的语言。 该属性是可选的; 然而，对于元数据元素的多个 `text` 子元素要进行有效区分，他们**应当**使用适当的不同语言代码进行标记。

dir：文本方向，可以是`ltr`（用于“从左到右”）或`rtl`（用于“从右到左”）。 该属性是**可选的**，如果省略，则默认为`ltr`。

class：一组任意空格分隔的令牌。 该属性是**可选的**。

**子元素**

div：包含一段文字，如段落或标题。

span：包含内联文本。

**`div` 元素**

一个用于包含（比如）段落的块级元素。

**属性**

dir：文本方向，可以是`ltr`（用于“从左到右”）或`rtl`（用于“从右到左”）。 该属性是**可选的**，如果省略，则默认为`ltr`。

class：一组任意空格分隔的令牌。 该属性是**可选的**。

**`span` 元素**

用于指示（比如）具有不同文本方向或不同语言的文本的一连串的文本。

**子元素**

dir：文本方向，可以是`ltr`（用于“从左到右”）或`rtl`（用于“从右到左”）。 该属性是**可选的**，如果省略，则默认为`ltr`。

class：一组任意空格分隔的令牌。 该属性是**可选的**。

用于保存（可本地化）的文本的 `text` 元素分割成许多独立的元数据，因此具有由文本内容、`div` 和 `span` 元素组成的混合内容模型; `div` 元素具有文本内容、`div` 和 `span` 元素的混合内容模型; `span` 元素具有文本内容和 `span` 元素的混合内容模型。 换句话说，div 可以包含其他 `div` 元素; `span` 可以包含其他 `span` 元素; `span` 不需要包含 `div`。

[附录 A](#appendix-a) 包含了元数据块内容的几个例子。

注意：尽管元数据块是可选的，并且不需要用户代理为了渲染字体而对其进行处理，但是鼓励诸如 Web 浏览器的客户端提供一种手段（例如当前的“字体信息”对话框页面）供用户查看 WOFF 文件中包含的元数据。 并非每个客户端都必须具有适当的上下文，但是任何使用户能够找出 Web 文档所使用的资源的客户端都应该考虑公开有关所用字体的信息，并且在使用 WOFF 打包字体的情况下，元数据块是此信息的主要来源。

## 8. 专有数据块
WOFF 文件可以包含任意数据块，允许字体创建者包含他们希望的任何信息。这些数据的内容不得影响用户代理的字体使用或加载行为。用户代理**不得**对专有块的内容做任何假设；它可能（例如）包含 ASCII 或 Unicode 文本或某些供应商定义的二进制数据，它可能是压缩或加密的，但它没有公开定义的格式。符合规范的用户代理不会假设任何关于这些数据的结构。只有负责专有块的字体开发人员或供应商才能理解其内容。

专有数据块（如果存在）**必须**是 WOFF 文件中的最后一个块，跟随在所有字体表和任何扩展元数据块之后。私人数据块务必从 WOFF 文件中的一个4字节边界开始，如果需要的话，最多可以在任何前面的元数据块之后插入作为填充的三个空字节，以确保这一点。专有数据块的末尾必须对应于 WOFF 文件的末尾。

* * *

## 附录 A: 扩展元数据示例

本附录纯粹是指示性的，不是 WOFF 规范的正式部分。

这个“虚拟”元数据块描述了第 7 节中描述的元数据元素的用法，包括使用多个`text`子元素来提供某些元素的本地化版本。

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

元数据块的另一个例子（由 Ascender Corporation 许可转载）。 这是动态生成的，`uniqueid` 和 `uniqueid`元素被修改为每个用户都是唯一的。

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

下面是一个如何使用 div 元素的例子，可以从[Gentium Plus的XML文件](http://dev.w3.org/webfonts/WOFF/spec/metadata/GentiumPlus-WOFF-metadata .xml)的一部分修改，当以纯文本格式查看时，它具有段落格式。

原始的元数据文件包含：

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

使用`div`元素，可能会变成：

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

## 附录 B: 媒体类型注册

本附录根据 [BCP 13](http://www.ietf.org/rfc/rfc4288.txt) 和[W3CRegMedia](http://www.w3.org/2002/06/registering-mediatype.html)注册了一种新的 MIME 媒体类型。

**Type name:** application

**Subtype name:** font-woff

**Required parameters:** None.

**Optional parameters:** None.

**Encoding considerations:** binary.

**Security considerations:** 


字体是解释性的数据结构，表示各种语言和书写系统的字形轮廓、度量和布局信息的集合。目前，有许多标准化的字体数据表，允许未指定数量的条目，并且现有的预定义数据字段允许存储具有可变长度的二进制数据。 字体数据结构的灵活性可能会被利用，来隐藏伪装成字体数据组件的恶意二进制内容。

WOFF 基于以表格为基础的 SFNT（可扩展字体）格式，具有高度的可扩展性，并提供了在需要时引入额外数据结构的功能。 但是，这种相同的可扩展性可能会带来特定的安全问题 —— 定义新数据结构的灵活性和易用性使得任意数据都可以轻松添加和隐藏在字体文件中。

WOFF 字体可以包含用于将字形的图形元素与目标显示像素网格对齐的“提示”，并且取决于在创建字体中使用的字体技术，这些提示可以表示由字体光栅化器解释和执行的活动代码。尽管它们在字形大纲转换系统的范围内运行，并且不能在字体呈现机制之外访问，但是提示指令可能非常复杂，而且恶意设计的复杂字体可能会导致不必要的资源（例如内存或 CPU 周期）消耗在解释它的机器上。事实上，字体非常复杂，即使不是所有的解释器都不能完全免受恶意字体的影响，也不会受到不适当的性能损失。

广泛使用字体作为视觉内容呈现的必要组成部分，这要求当字体嵌入到电子文档中或与媒体内容一起作为链接资源传输时，应该仔细注意安全性方面的问题。

WOFF 使用 gzip 压缩。 WOFF 标题包含每个压缩表的未压缩长度。因此，应用程序可能会限制分配给解压缩的内存缓冲区的大小，如果恶意制作的 WOFF 文件实际上包含的数据比指示的数据多，则可能会停止写入。

WOFF 在内部不提供隐私保护; 如果需要，这些应该在外部提供。

WOFF 有一个专有数据块设施，可能包含任意的二进制数据。 WOFF不提供访问这个或者执行其中包含的任何代码的手段。 WOFF [要求](#conform-private-noeffect)该块的内容不会以任何方式影响字体呈现。

**互操作性考虑：**

**发布的规范：**此媒体类型注册摘自W3C的[WOFF规范](http://www.w3.org/TR/WOFF)。

**使用此媒体类型的应用程序：** WOFF由 Web 浏览器使用，通常与HTML 和 CSS 一起使用。

**附加信息：**

**幻数：** WOFF标题中的签名字段必须包含“幻数” 0x774F4646

**文件扩展名：** woff

**Macintosh 文件类型代码：**（不指定代码）

**Macintosh通用类型标识符代码：**  org.w3c.woff

**片段标识符：** 无。

**联系人和电子邮件地址以获取更多信息：** Chris Lilley（www-font@w3.org）。

**用途：** **通用**

**使用限制：** 无

**作者：** WOFF规范是万维网联盟 WebFonts 工作组的工作产品。

**更改控制权：** W3C对本规范有更改控制权。

## 附录 C: 修订记录

相对于[2010年7月27日的第一次公开工作草案](http://www.w3.org/TR/2010/WD-WOFF-20100727)，已做出以下更改。 除了元数据格式的增强选项功能外，没有添加任何新的功能; 剩下的更改是对现有功能的澄清和更正。

* 澄清 WOFF是一种字体**打包**或封装格式，而不是一种新的字体格式。
* 澄清填充和字节对齐的需求
* 首选术语 “input font” 而不是 “original file” 来描述转换为 WOFF 的字体
* 澄清在 WOFF 转换之前的任何subsetting（子集）、checksum-correction（校验和校正）或DSIG无效更改超出了WOFF规范的范围。
* 澄清 totalSfntSize 的含义。
* 定义了格式良好的输入字体的含义。
* 澄清“无效元数据”的含义 —— 必须格式良好，压缩并符合模式。
* 澄清了XML中的哪些元素和属性是必需的;对于某些元素，澄清了他们需要的父元素。
* 澄清了 id 属性不是 XML 意义上的类型ID
* 添加到 RelaxNG 语法的链接，该语法试图以机器可读的方式表达与文本相同的约束。如果有任何差异，文本是必须是规范的。
* 在解压缩时增加提醒检查是否溢出。
* 根据[W3C媒体类型注册]（http://www.w3.org/2002/06/registering-mediatype.html）策略的要求增加了媒体类型注册模板。
* 分开了规范性和信息性参考。
* 把RFC-2119关键字转换成了大写字母。
* 为所有可测试的断言添加了 id 和 class 属性。
* 增加了一些非规范的解释性说明。
* 对整个措辞做了小的澄清。
* 把相关的断言合并分组或为了提高可读性，将文本重新排列; 特别是，以前最佳做法放在附录中，现在已经整合到规范的主体中。
* 增加了这个更改附录。

最后一次修订有如下更改：

* 语言属性现在引用 BCP47，并使用 xml：lang。
* 增加了可选的 `div` 和 `span` 元素，可用于在元数据文本中提供构建。
* 为元数据元素添加了 `dir` 和 `class` 属性。
* 删除了一致性要求的摘要（和规范的主体部分有重复内容）。
* 稍微重新安排并澄清了元数据格式的描述。
* 注意到相同来源的请求是有风险的，期望 CSS3 字体可以处理这个问题。
* 提到重建 sfnt 头时需要计算二进制搜索字段。
* 要求以 UTF-8 编码元数据，而不是既允许使用 UTF-8 又允许使用 UTF-16。

用于准备最后工作草案的编辑草稿和用于编写候选推荐标准的编辑草稿之间的[颜色编码差异](http://dev.w3.org/cvsweb/webfonts/WOFF/spec/Overview.html.diff?r1=1.58;r2=1.96;f=h) 可用。

候选建议书发布后进行了以下更改：

* 删除加载 WOFF 字体的指定相同来源要求的文本（这在以前是危险的）以及 CORS 机制，以放宽限制，因为 CSS 工作组同意将其作为 @ font-face 规则的一部分包含在 CSS3 字体中。
* 由于移除了风险项目，将 CSS3-Fonts 从规范部分移至信息部分。
* 在一般介绍性声明中更正了 MUST 的错误使用

用于准备候选建议书的编辑草案和编写建议的建议书的编辑草案之间的[颜色编码差异](http://dev.w3.org/cvsweb/webfonts/WOFF/spec/Overview.html.diff?r1=1.99;r2=1.112;f=h)是可用的。

在提交建议书发布后做出以下更改：

* 媒体类型注册附录的安全考虑部分已更新，放在了规范的主体部分，提醒读者注意专有数据块，并指出 WOFF 没有提供执行任何可能包含在其中的二进制代码的机制。 这一变更是应 IANA 专家审查员的要求作出的。

* * *

## 参考

### 规范性参考文献

[BCP47]:  [BCP 47](http://www.rfc-editor.org/rfc/bcp/bcp47.txt) 识别语言和匹配语言标签的标签

[OFF]: [开放字体格式规范](http://standards.iso.org/ittf/PubliclyAvailableStandards/c052136_ISO_IEC_14496-22_2009(E).zip) (ISO/IEC 14496-22:2009).

[RFC-2119]: [RFC 2119:](http://tools.ietf.org/html/rfc2119) 在RFC中用于指示需求级别的关键词。 S. Bradner，编辑。 互联网工程任务组，1997年3月。

[ZLIB]: [RFC 1950](http://tools.ietf.org/html/rfc1950)  ZLIB压缩数据格式规范。 P. Deutsch，J-L。 Gailly，编辑。 互联网工程任务组，1996年5月。

### 信息性参考

[Compress2]: [zlib compress2() function](http://refspecs.linuxbase.org/LSB_3.0.0/LSB-Core-generic/LSB-Core-generic/zlib-compress2-1.html)

[CSS3-Fonts]: [CSS 字体模块级别 3](http://www.w3.org/TR/css3-fonts/). J. Daggett, 编辑。 万维网联盟，2011年10月4日。 [最新版本的CSS3字体](http://www.w3.org/TR/css3-fonts/) 可在http://www.w3.org/TR/css3-fonts/上找到。（工作正在进行中）。

[OpenType]: [微软 OpenTyp e规范](http://www.microsoft.com/typography/otspec/),版本1.6。 Microsoft，2009。OpenType是微软公司的注册商标。

[TrueType]: [Apple TrueType 参考手册](http://developer.apple.com/fonts/TTRefMan/)。
Apple，2002。TrueType 是苹果有限公司的注册商标。

[Uncompress]: [zlib uncompress() function](http://refspecs.linuxbase.org/LSB_3.0.0/LSB-Core-generic/LSB-Core-generic/zlib-uncompress-1.html)

[XML]: [可扩展标记语言](http://www.w3.org/TR/xml/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
