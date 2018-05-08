> * 原文地址：[Interpreting predictive models with Skater: Unboxing model opacity](https://www.oreilly.com/ideas/interpreting-predictive-models-with-skater-unboxing-model-opacity)
> * 原文作者：[Pramit Choudhary](https://www.oreilly.com/people/2391d-pramit-choudhary)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/interpreting-predictive-models-with-skater-unboxing-model-opacity.md](https://github.com/xitu/gold-miner/blob/master/TODO1/interpreting-predictive-models-with-skater-unboxing-model-opacity.md)
> * 译者：[radialine](https://github.com/radialine)
> * 校对者：[ALVINYEH](https://github.com/ALVINYEH)、[luochen1992](https://github.com/luochen1992)

# 用 Skater 解读预测模型：打开模型的黑箱

本文将把模型解释作为一个理论概念进行深入探讨，并对 Skater 进行高度概括。

![立方体模型](https://d3tdunqjn7n0wj.cloudfront.net/360x240/model-3211631_1920_crop-e62adea7b63b80a1074f5023cec1e4cd.jpg)

立方体模型（来源：[Pixabay](https://pixabay.com/en/model-3d-background-cube-blue-3211631/)）

> [查看 Pramit Choudhary 在纽约 AI 会议上的演讲“深度学习中的模型评估” 2018.04.29 - 2018.05.02](https://conferences.oreilly.com/artificial-intelligence/ai-ny/public/schedule/detail/65118?intcmp=il-data-confreg-lp-ainy18_new_site_interpreting-predictive-models-with-skater-unboxing-model-opacity_top_cta)

多年来，机器学习（ML）已经取得了长足的发展，它从纯粹的学术环境中作为实验研究的存在，到被行业广泛采用成为自动化解决实际问题的手段。但是，由于对这些模型的内部运作方式缺乏了解，这些算法通常仍被视为魔术（参见 [Ali Rahimi, NIPS'17](https://youtu.be/Qi1Yry33TQE)）。因此常常需要通常验证这种 ML 系统的运作过程，以使算法更加可信。研究人员和从业人员正在努力克服依赖可能对人类生活产生意想不到影响的预测模型所带来的道德问题，这类预测模型有评估抵押贷款资格模型，或为自动驾驶汽车提供动力的算法（参见 Kate Crawford, NIPS '17，[“偏差带来的麻烦”](https://youtu.be/6Uao14eIyGc)）。数据科学家 Cathy O’Neil 最近撰写了[一本书](https://weaponsofmathdestructionbook.com/author/mathbabe/)，其内容全部是可解释性差模型的例子，这些模型提出了对潜在社会大屠杀的严重警告 —— 例如，[犯罪判决模型中的模型偏见](https://www.propublica.org/article/machine-bias-risk-assessments-in-criminal-sentencing)或在建立财务模型时因为人为偏见使用虚假特征的例子。

![传统的解释预测模型的方法是不够的](https://d3ansictanv2wj.cloudfront.net/FigureArt-0eccc75aa2e5a5f72e91ef990cb2dc59.png)

图 1：传统的解释预测模型的方法是不够的。图片由 Pramit Choudhary 提供。

在平衡模型的可解释性和性能方面也存在[折衷](https://www.ncbi.nlm.nih.gov/pubmed/21554073)。从业者通常选择线性模型而不是复杂模型，牺牲性能换取更好的可解释性。对于那些预测错误后果不严重的用例而言，这种方式是可行的。但在某些情况下，如[信用评分](https://www.consumer.ftc.gov/articles/pdf-0096-fair-credit-reporting-act.pdf)或[司法系统](https://www.propublica.org/article/making-algorithms-accountable)的模型必须既高度准确又易于理解。事实上，法律已经要求保证这类预测模型的公平性和透明度。

我在 [DataScience.com](https://www.datascience.com/) 作为首席数据科学家时，我们对帮助从业者使用模型确保安全性、无差别和透明度这份工作充满激情。我们认识到人类的可解释性的需求，因此最近我们开源了一个名为 [Skater](https://www.datascience.com/resources/tools/skater) 的 Python 框架，作为为数据科学领域的研究人员和应用从业人员提供模型解释性的第一步。

模型评估是一个复杂的问题，因此我将分两部分进行讨论。在第一部分中，我将把模型解释作为一个概念进行深入探讨，并对 Skater 进行高度概括。在第二部分中，我将分享 Skater 目前支持的算法的详细解释以及 Skater 库的未来功能蓝图。

## 什么是模型解释？

在机器学习领域，模型解释还是一个新的、很大程度上主观的、有时还存在争议的概念。（参见 [Yann LeCun 对 Ali Rahimi 谈话的看法](https://www.facebook.com/yann.lecun/posts/10154938130592143)）模型解释能够解释和验证预测模型决策，以实现算法决策的公平性，问责性和透明度（关于机器学习透明度定义的更详细解释，请参见 Adrian Weller 的文章[“透明度挑战”](https://arxiv.org/pdf/1708.01870.pdf) ）。更正式的说明是，模型解释可以被定义为以人类可解释的方式，更好地理解机器学习响应函数的决策策略以解释自变量（输入）和因变量（目标）之间关系的能力。

理想情况下，您应该能够探究模型以了解其算法决策的内容，原因和方式。

*   **模型提供了哪些信息来避免预测错误？**您应该能够探究和了解潜在变量之间的相互作用，以便及时评估和了解是什么特征推动了预测。这些信息将确保模型的公平性。
*   **为什么这个模型的有这样的表现？**您应该能够识别和验证驱动模型决策的相关变量。这样做可以让您即使在无法得到所预测的真实数据的情况下，也相信预测模型的可靠性。这样的模型理解将确保模型的可靠性和安全性。
*   **我们怎样才能相信模型所做的预测？**您应该能够验证任何给定的数据，以向业务利益相关方证明该模型的表现确实和预期一致。这将确保模型的透明度。

## 现有技术捕捉模型的解释

模型解释是为了更好地理解数学模型，这种理解最有可能通过更好地了解模型中重要的特征来获得。理解方式可以是使用流行的数据探索和可视化方法，如[层次聚类](https://en.wikipedia.org/wiki/Hierarchical_clustering)和降维技术来实现。模型的进一步评估和验证可以使用比较模型的算法，使用模型特性评分方法 —— AUC-ROC（[接收者操作特征曲线下面积](http://www.math.utah.edu/~gamez/files/ROC-Curves.pdf)）和 MAE（[平均绝对误差](https://medium.com/human-in-a-machine-world/mae-and-rmse-which-metric-is-better-e60ac3bde13d)）进行分类和回归。让我们快速谈谈其中的一些方法。

### 探索性数据分析和可视化

探索性数据分析可以让您更好地了解您的数据，从而提供构建更好预测模型所需的专业知识。在模型建立过程中，理解模型意味着探索数据集，以便可视化并理解其“有意义”的内部结构，并以容易理解的方式提取有强影响力的直观特征。这种方式对于无监督学习问题可能更加有用。我们来看看属于模型解释类别的一些流行数据探索技术。

*   **聚类：**[分层聚类](https://en.wikipedia.org/wiki/Hierarchical_clustering)
*   **降维：**[主成分分析（PCA）](https://lazyprogrammer.me/tutorial-principal-components-analysis-pca/)（见图 2）
*   **变分自编码器：**使用[变分自编码器](https://arxiv.org/pdf/1606.05908.pdf)（VAE）的自动生成方法
*   **[流形学习](https://en.wikipedia.org/wiki/Nonlinear_dimensionality_reduction)：**t 分布式随机相邻嵌入（[t-SNE](https://distill.pub/2016/misread-tsne/)）（见图 3）

在本文中，我们将重点讨论监督学习问题的模型解释。

![解释高维 MNIST 数据](https://d3ansictanv2wj.cloudfront.net/Figure1-f6f5f16454b0120a1607e76836236b23.png)

图 2：使用 PCA 以三维可视化技术解释高维 MNIST 数据，以便使用 TensorFlow 构建领域知识。图片由 Pramit Choudhary 和 Datascience.com 团队提供。

![可视化 MNIST 数据](https://d3ansictanv2wj.cloudfront.net/Figure2-2cd5b53ded24be25e376418d041a0bee.png)

图 3：用 sklearn 库可视化 MNIST 数据。图片由 Pramit Choudhary 和 Datascience.com 团队提供。

### B. 模型比较和性能评估

除了数据探索技术外，还可以使用[模型评估技术](https://sebastianraschka.com/blog/2016/model-evaluation-selection-part1.html)进行简单的模型解释。分析师和数据科学家可能会使用模型比较和评估方法来评估模型的准确性。例如，使用交叉验证和评估指标进行分类和回归，您可以衡量预测模型的[性能](https://www.cs.cornell.edu/courses/cs578/2003fa/performance_measures.pdf)。您可以通过优化超参数调整偏差与方差之间的平衡（请参阅文章[“了解偏差 - 方差取舍”](http://scott.fortmann-roe.com/docs/BiasVariance.html)）。

*   **分类：**如 F1-scores，AUC-ROC，brier-score 等。如图3，该图显示了 AUC-ROC 如何帮助衡量流行虹膜数据集的分类模型的模型性能。ROC AUC 是一种广泛使用的指标，有助于在真阳性率（TPR）和假阳性率（FPR）之间进行平衡。它在处理偏斜类问题上也非常强大。如图 3 所示，86％的 ROC AUC（ 2 类）意味着训练的分类器向正例（属于 2 类）分配较高分数的概率与负例（不属于 2 类）相比约为 86％。这种汇总的性能指标有助于阐明模型的整体性能。但是，如果分类错误，它并不能给出关于错误分类原因的详细信息 —— 为什么属于 0 类的例子被分类为 2 类，属于 2 类的例子却被分为 1 类？不能忽略的事实是，每个错误分类都可能造成不同程度的潜在业务影响。
*   **回归：**例如，r-square 值（[决定系数](http://itfeature.com/correlation-and-regression-analysis/coefficient-of-determination)），均方误差等。

![使用 ROC 曲线衡量模型性能](https://d3ansictanv2wj.cloudfront.net/Figure3-ed3699bfaad2cc688ba68e0c0bf1dea5.png)

图 4：通过计算 Iris 数据集的接收者操作特征曲线（ROC 曲线）下面积，使用 sklearn 库解决多类问题，从而测量模型性能。图片由 Pramit Choudhary 和 Datascience.com 团队提供。

## 为什么需要更好的模型解释？

如果预测模型的目标函数（试图优化的损失函数）与商业指标（与真实目标紧密相关的指标）能够匹配，则使用上述提到的评估技术所计算的数据探索和点估计足以测量样本数据集的总体表现，而且我们知道用于训练的数据集是固定的。 然而，在现实世界中这种情况很少发生，即，使用点估计衡量模型性能是不够的。例如，[入侵检测系统](https://ir.library.louisville.edu/etd/2790/)（IDS）是一种网络安全应用程序，容易被作为逃逸攻击的目标。在逃逸攻击中，攻击者会使对抗输入来击败安全系统（注：[对抗输入](https://arxiv.org/abs/1602.02697)是攻击者有意设计的，用来欺骗机器学习模型做出错误的预测）。这种情况下模型的目标函数可能是实际目标的弱代理。更优化的模型解释需要识别算法中的盲点，以便通过修复易受对抗攻击的训练数据集来构建安全的模型（有关进一步阅读，请参见 Moosavi-Dezfooli et al., 2016, [**DeepFool**](https://arxiv.org/pdf/1511.04599.pdf), Goodfellow et al., 2015，[**解释和利用对抗样本**](https://arxiv.org/abs/1412.6572)）。

此外，在静态数据集上训练时（不考虑新数据中的变化），模型的性能会随着时间的推移而稳定下来。例如，现有的特征空间可能在模型在新的环境操作之后发生了变化，或者训练数据集中添加了新数据，引入了新的未观察到的关联关系。这意味着简单地重新训练模型不足以改进模型的预测。为了有效地调试模型以理解算法行为或将新的关联关系结合到数据集中，需要更好的模型解释方法。

也许还有一种情况：模型的预测本质上是正确的 —— 模型的预测与预期一致 —— 但由于[数据偏倚](https://www.nytimes.com/2014/11/25/opinion/is-harvard-unfair-to-asian-americans.html?_r=0)，它无法证明其在社会环境中的决策是合理的（例如，[“仅仅因为我喜欢黑泽并不意味着我想看《忍者小英雄》“](https://www.cinemablend.com/pop/Netflix-Using-Amazon-Cloud-Explore-Artificial-Intelligence-Movie-Recommendations-62248.html)）。此时，可能需要对算法的内部工作进行更严格和透明的诊断，以建立更有效的模型。

即使有人不同意所有上述原因作为需要更好模型解释这个需求的动机，传统的模型评估形式需要对统计测试的算法或特性有一个合理的理论认识。非专家可能很难掌握有关算法的细节并常常导致数据驱动行为失败。人类可理解的模型解释（HII）可以提供有用信息，可以轻松地在同行（分析师，管理人员，数据科学家，数据工程师）之间共享。

使用这种可以根据输入和输出来进行解释的方式，有助于促进更好的沟通和协作，使企业能够做出更加自信的决定（例如[金融机构的风险评估/审计风险分析](https://www.journalofaccountancy.com/issues/2006/jul/assessingandrespondingtorisksinafinancialstatementaudit.html)）。重申一下，目前我们将模型解释定义为在监督学习问题上，模型解释能够考虑预测模型的公平性（无偏性/无差别性）、问责性（产生可靠结果）和透明度（能够查询和验证预测性决策）。

## 性能和与解释之间的二分法

算法的性能和可解释性之间似乎有一个基本的平衡。从业人员通常使用更容易解释的模型（简单线性，逻辑回归和决策树）来解决问题，因为这些模型更容易被验证和解释。如果能够理解其内部原理或其决策方法，就能够信任模型。但是，当人们试图应用这些预测模型，使用高维异构复杂数据集来解决实际问题（自动化信贷应用程序，检测欺诈或预顾客终生价值）时，解释模型往往在性能方面表现不好。由于从业者试图使用更复杂的算法来提高模型的性能（如准确性），他们常常[难以在性能和可解释性之间取得平衡](https://www.oreilly.com/ideas/predictive-modeling-striking-a-balance-between-accuracy-and-interpretability)。

![模型性能和可解释性的对比](https://d3ansictanv2wj.cloudfront.net/Figure4-c4705368d6a633a22b5aa7ef3aa027d4.png)

图 5：模型性能和可解释性的对比。图片由 Pramit Choudhary 和 Datascience.com 团队提供。

借用一个例子，我们来看看平衡性能和解释性的问题。参考上图 5。假设有人正在建立一个模型来预测特定客户群体的贷款审批结果。使用线性模型（例如线性分类器，如使用对数损失函数的[逻辑回归](https://en.wikipedia.org/wiki/Logistic_regression)或回归的[普通最小二乘法](https://en.wikipedia.org/wiki/Ordinary_least_squares)（OLS））更易于解释，因为输入变量与模型输出之间的关系可以使用模型的系数在量值和方向上进行量化权重。如果决策边界单调递增或递减，这种思路就行得通。但是，真实世界的数据很少出现这种情况。因此产生了模型的性能和可解释性之间的平衡问题。

为了捕捉自变量和模型的响应函数之间的非单调关系，通常需要使用更复杂的模型：集成、有大量决策树的随机森林或有多重隐藏的神经网络层。随着文本（使用[分层相关传播（LRP）](http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0130140)[**解释 NLP 中的非线性分类器的预测**](https://arxiv.org/abs/1606.07298)）、计算机视觉（Ning et.al，NIPS'17，[**相关输入概念到卷积神经网络决策**](https://arxiv.org/abs/1711.08006)）和基于语音的模型需求的复杂度增加，模型可解释性需求也在增加。例如，对基于语言的模型的理解仍然是一个[棘手的问题](https://www.oreilly.com/ideas/language-understanding-remains-one-of-ais-grand-challenges)，因为相似词语的使用存在模糊性和不确定性。使用人类可解释性来理解语言模型中的这种模糊性对于构建用例特定规则来理解、验证和改进模型决策十分有用。

## 介绍 Skater

在 Datascience.com，我们在许多分析用例和项目中遇到了解释性挑战，因此了解到我们需要更好的模型解释 —— 最好是用人类解释性解释（HII）作为输入变量和模型输出（非专家人员也容易理解）。我记得曾经在一个项目上，我们正在建立一个机器学习模型来总结消费者评论。我们想要捕捉消费者情绪（正面或负面）以及每种情绪的具体原因。受时间限制，我们认为值得尝试使用现成的模型进行情绪分析。我们研究了市场上的许多机器学习模型，但由于信任问题，我们无法决定使用哪个，并且体会到了需要用更好的方式来解释、验证和确认模型的必要。

然而我们当时无法在市场上找到一个能够始终如一地支持全局（基于完整数据集）和局部（基于[单个预测](https://arxiv.org/abs/0912.1128)）解释的成熟的开源库，因此我们从零开发了一个库：Skater（见图 6）。

Skater 是一个 Python 库，旨在解释使用任意语言或框架的任意类型的预测模型的内部行为。目前，它能够解释监督学习算法。

![全局解释和局部解释的总结](https://d3ansictanv2wj.cloudfront.net/Figure5-452aaf48771d7e201175954c1de6eed1.png)

图 6：全局解释和局部解释的总结。图片由 Pramit Choudhary 和 Datascience.com 团队提供。

目前支持的解释算法是事后性质的。与之类似，虽然 Skater 提供了一种事后机制来评估和验证基于自变量（输入）和因变量（目标）的预测模型的内部行为，但它不支持构建可解释模型（例如[规则集](https://arxiv.org/abs/0811.1679)、[弗里德曼](https://arxiv.org/find/stat/1/au:+Friedman_J/0/1/0/all/0/1)、[贝叶斯规则列表](https://arxiv.org/abs/1511.01644)）。

这种方法有助于我们根据分析用例将解释性应用到机器学习系统中 —— 因为事后操作可能很昂贵，并且可能不是一直需要宽泛的解释。Skater 库采用了面向对象和功能性编程范例，以保证提供可伸缩性和并发性的同时，保持代码简洁性。图 7 显示了这种可解释系统的高层次简述。

![使用 Skater 解释机器学习系统](https://d3ansictanv2wj.cloudfront.net/Figure6-53d0033f567200502a5a56f5610257ba.png)

图 7：一个使用 Skater 的可解释的机器学习系统，使用者能够优化泛化错误，从而获得更好和更有可信度的预测。图片由 Pramit Choudhary 和 Datascience.com 团队提供。

### 用 Skater 解释模型

注意：以下例子的完整代码在图片相关的的参考链接中。

使用 Skater 可以做到：

*   **评估模型对完整数据集或单个数据的预测成果：** 通过利用和改进现有技术的组合，Skater 能够做到全局的和局部的模型解释。对于全局解释，目前 Skater 利用模型未知[变量的重要性](http://ftp.uni-bayreuth.de/math/statlib/R/CRAN/doc/vignettes/caret/caretVarImp.pdf)和部分依赖关系图来判断模型的偏差，并了解模型的一般行为。为了验证模型对单一预测的决策策略是否可靠，Skater 采用了一种名为"局部可理解的与模型无关的解释"（[LIME](https://arxiv.org/abs/1602.04938)）的新技术，它使用局部替代模型来评估性能（点击获取 [LIME 的更多细节](https://www.oreilly.com/learning/introduction-to-local-interpretable-model-agnostic-explanations-lime)）。其他算法正在研发中。

```
From
```

![使用 Skater 对比模型](https://d3ansictanv2wj.cloudfront.net/Figure7-0762e7d37531c3e573a90e21cfb224a1.png)

图 8：[不同类型的监督预测模型之间使用 Skater 的比较结果](https://github.com/datascienceinc/Skater/blob/master/examples/ensemble_model.ipynb)。图中，模型未知特征的重要性被用于比较有相似 F1 值的不同模型。根据模型的预测变量的假设、响应变量及其关系，图中可以看到不同的模型类型对特征进行的排序的不同。这种比较方法使得机器学习领域的专家们或非专家们可以评估其选定特征的相关性并得到一致的结果。图片由 Pramit Choudhary 和 Datascience.com 团队提供。

*   **识别潜在变量的交互并建立域知识：** 从业者可使用 Skater 来发现隐藏的特征交互 —— 例如，信用风险模型应该如何使用银行客户的信用记录，如何通过检查账户现状或现有信用额度来批准或拒绝他申请信用卡的请求，并使用该信息进行未来的分析。

```
# 用模型不可知的部分依赖图进行的全局模型解释
```

![隐藏特征之间的交互](https://d3ansictanv2wj.cloudfront.net/Figure8-87aabff2421d4c265668030d8c1503cc.jpg)

图 9：[使用乳腺癌数据集的单向和双向交互发掘隐藏特征的交互](https://github.com/datascienceinc/Skater/blob/master/examples/ensemble_model.ipynb)。图片由 Pramit Choudhary 和 Datascience.com 团队提供。

```
# 使用 LIME 做模型不可知的局部解释
```

![单个预测的特征相关性](https://d3ansictanv2wj.cloudfront.net/Figure9-178eb31a31928a269986be6c36f5b03a.png)

图 10：[通过 LIME，使用线性代理模型理解单个预测的特征相关性](https://github.com/datascienceinc/Skater/blob/master/examples/ensemble_model.ipynb)。图片由 Pramit Choudhary 和 Datascience.com 团队提供。

*   **衡量模型性能在部署到生产环境后如何变化：** Skater 保证了模型在内存中和运行时模型解释能力的一致性，帮助使用者衡量不同模型版本间的特征交互是如何变化的（如图 11）。若使用机器学习市场上现有预测模型（例如 algorithmia），这种形式的解释也能帮助建立对模型的信任。例如，在图 12 和图 13 中，分别用 indico.io 和 algorithmia 的两个现有情绪分析模型对 IMBD 内《纸牌屋》的影评进行分析，并使用 Skater 比较两个模型并进行评价。两个模型都得出了影评中的情绪是积极情绪的结果（1 为积极，0 为消极）。但是，indico.io 的模型考虑了停止词，例如“是”，“那个”和“属于”，这些词在大多情况下应该被忽略。因此，尽管与 algorithmia 相比，indico.io 的模型能得出更高概率的积极情绪，但最后被采用的可能是 indico.io 的模型。

![仍在内存中的模型和已部署模型的解释需求](https://d3ansictanv2wj.cloudfront.net/Figure10-a24a43e0b4db2062565adf38a04e75f1.png)

图 11：高亮了在内存中的模型（未运行的模型）和已部署模型（已运行的模型）的解释需求。更好的解释特征的方法会带来更好的特征工程和特征选择。图像来源：在 Juhi Sodani 和 Datascience.com 团队的帮助下设计的图像。

```
# 使用 Skater 验证市场上的第三方 ML 模型
```

![解释现有模型](https://d3ansictanv2wj.cloudfront.net/Figure11-17c1f9d9e6d651ea22eddb16e9116947.png)

图 12：在使用 [indico.io 的预训练过的部署模型](https://github.com/datascienceinc/Skater/blob/master/examples/third_party_model/algorithmia_indico.ipynb)中解释模型。图片由 Pramit Choudhary 和 Datascience.com 团队提供。

![解释现有模型](https://d3ansictanv2wj.cloudfront.net/Figure12-609514e916a9ff0655369f5384e59961.png)

图 13：在使用 [algorithmia 的预训练过的部署模型](https://github.com/datascienceinc/Skater/blob/master/examples/third_party_model/algorithmia_indico.ipynb)中解释模型。图片由 Pramit Choudhary 和 Datascience.com 团队提供。

## 结论

在当前的预测建模市场环境中，为了提高透明度而出现的能够解释和证明算法决策策略的技术方法将发挥重要作用。尤其对于有监管需求的行业，模型的解释说明能够促进更复杂的算法的应用。随着 Skater 的初始发布，我们正在帮助机器学习领域的专家们和非专家们，朝着提高预测模型的决策策略的公平性、问责性和透明度迈出新的一步。如果您想了解更多在实际案例中应用 Skater 模型解释功能的例子，您可以查看用[《基于 Python 的实用机器学习》](https://github.com/dipanjanS/practical-machine-learning-with-python)一书。

在本系列的第二部分中，我们将深入了解 Skater 目前支持的算法以及未来的规划，以更好地进行模型解释。

![总结 Skater](https://d3ansictanv2wj.cloudfront.net/Figure13-9efdc5a382e6e30da27c611a3b58288d.png)

图 14：总结 Skater。图片由 Pramit Choudhary 和 Datascience.com 团队提供。

想了解更多信息，请查阅[资源和工具](https://www.datascience.com/resources/tools/skater)、[例子](https://github.com/datascienceinc/Skater/tree/master/examples)，或 [gitter channel](https://gitter.im/datascienceinc-skater/Lobby)。

### 致谢

我想特别感谢 Aaron Kramer、Brittany Swanson、Colin Schmidt、Dave Goodsmith、Dipanjan Sarkar、Jean-RenéGauthie、Paco Nathan、Ruslana Dalinina 以及所有不知名评论者在我撰写本文的过程中帮助我。

### 参考和延伸阅读

*   Zachary C. Lipton, 2016. _[The Mythos of Model Interpretability](https://arxiv.org/pdf/1606.03490v2.pdf)_
*   Marco Tulio Ribeiro, Sameer Singh, Carlos Guestrin. [_Nothing Else Matters: Model-Agnostic Explanations By Identifying Prediction Invariance_](https://arxiv.org/abs/1611.05817), 2016
*   Finale Doshi-Velez and Been Kim, 2017. [_Towards A Rigorous Science of Interpretable Machine Learning_](https://arxiv.org/abs/1702.08608)
*   [Parliament and Council of the European Union](http://ec.europa.eu/justice/data-protection/reform/files/regulation_oj_en.pdf). General data protection regulation, 2016
*   ["Ideas on interpreting Machine Learning"](https://www.oreilly.com/ideas/ideas-on-interpreting-machine-learning)
*   [_Explaining and Interpreting Deep Neural Networks_](http://iphome.hhi.de/samek/pdf/DTUSummerSchool2017_1.pdf)
*   John P. Cunningham et. al, 2016. [_Linear Dimensionality Reduction_](https://arxiv.org/pdf/1406.0873.pdf)
*   Saleema Amershi et.al, 2015. [_Model Tracker_](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/amershi.CHI2015.ModelTracker.pdf)
*   [Peter Norvig’s thoughts on value of explainable AI](https://www.computerworld.com.au/article/621059/google-research-chief-questions-value-explainable-ai/)
*   Kate Crawford et. al, 2014: [_Toward a Framework to Redress Predictive Privacy Harms_](http://lawdigitalcommons.bc.edu/cgi/viewcontent.cgi?article=3351&context=bclr)
*   A. Weller, ICML 2017: [_Challenges for Transparency_](https://arxiv.org/abs/1708.01870)
*   ["Inspecting algorithms for bias"](https://www.technologyreview.com/s/607955/inspecting-algorithms-for-bias/)
*   ["There is a blind spot in AI research,"](https://www.nature.com/news/there-is-a-blind-spot-in-ai-research-1.20805) Kate Crawford & Ryan Calo
*   [PCA](https://lazyprogrammer.me/tutorial-principal-components-analysis-pca/)
*   [How to use t-SNE effectively](https://distill.pub/2016/misread-tsne/)
*   Sebastian Raschka, 2016. [_Model Evaluation and Selection_](https://sebastianraschka.com/blog/2016/model-evaluation-selection-part1.html)

查看 Pramit Choudhary 在 2018.04.29 - 05.02 纽约人工智能会议上的演讲，[“深度学习中的模型评估”](https://conferences.oreilly.com/artificial-intelligence/ai-ny/public/schedule/detail/65118?intcmp=il-data-confreg-lp-ainy18_new_site_interpreting-predictive-models-with-skater-unboxing-model-opacity_end_cta)。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
