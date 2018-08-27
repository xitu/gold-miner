
> * 原文地址：[DEALING WITH IMBALANCED DATA: UNDERSAMPLING, OVERSAMPLING AND PROPER CROSS-VALIDATION](http://www.marcoaltini.com/blog/dealing-with-imbalanced-data-undersampling-oversampling-and-proper-cross-validation)
> * 原文作者：[Marco Altini](https://twitter.com/marco_alt)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/dealing-with-imbalanced-data-undersampling-oversampling-and-proper-cross-validation.md](https://github.com/xitu/gold-miner/blob/master/TODO/dealing-with-imbalanced-data-undersampling-oversampling-and-proper-cross-validation.md)
> * 译者：[edvardhua](https://github.com/edvardHua)
> * 校对者：[lileizhenshuai](https://github.com/lileizhenshuai), [lsvih](https://github.com/lsvih)

# 在使用过采样或欠采样处理类别不均衡的数据后，如何正确的做交叉验证？

**[关于我在这篇文章中使用的术语可以在 [Physionet](http://www.physionet.org/pn6/tpehgdb/) 网站中找到。 本篇博客中用到的代码可以在 [github](https://github.com/marcoalt/Physionet-EHG-imbalanced-data)中找到]**

几个星期前我阅读了一篇[交叉验证的技术文档（Cross Validation Done Wrong）](http://www.alfredo.motta.name/cross-validation-done-wrong)， 在交叉验证的过程中，我们希望能够了解到我们的模型的泛化性能，以及它是如何预测我们感兴趣的未知样本的。基于这个出发点，作者提出了很多好的观点（尤其是关于特征选择的）。我们的确经常在进行交叉验证之前进行特征选择，但是需要注意的是我们在特征选择的时候，不能将验证集的数据加入到特征选择这个环节中去。

但是，这篇文章并没有涉及到我们在实际应用经常出现的问题。例如，如何在不均衡的数据上合理的进行交叉验证。在医疗领域，我们所拥有的数据集一般只包含两种类别的数据， **正常** 样本和 **相关** 样本。譬如说在癌症检查的应用我们可能只有很小一部分病人患上了癌症（相关样本）而其余的大部分样本都是健康的个体。就算不在医疗领域，这种情况也存在（甚至更多），比如欺诈识别，它们的数据集中的相关样本和正常样本的比例都有可能会是 1:100000。

## 手头的问题

因为分类器对数据中类别占比较大的数据比较敏感，而对占比较小的数据则没那么敏感，所以我们需要在交叉验证之前对不均衡数据进行预处理。所以如果我们不处理类别不均衡的数据，分类器的输出结果就会存在偏差，也就是在预测过程中大多数情况下都会给出偏向于某个类别的结果，这个类别是训练的时候占比较大的那个类别。这个问题并不是我的研究领域，但是自从我在[做早产预测的工作的时候](https://medium.com/40-weeks/37-772d7f519f9)经常会遇到这种问题。早产是指短于 37 周的妊娠，大部分欧洲国家的早产率约占 6-7％，美国的早产率为 11％，因此我们可以看到数据是非常不均衡的。

我最近无意中发现两篇关于早产预测的文章，他们是使用 Electrohysterography (EHG)数据来做预测的。作者只使用了一个单独的 EHG 横截面数据（通过捕获子宫电活动获得）训练出来的模型就声称在预测早产的时候具备很高的精度（ [2], 对比没有使用过采样时的 AUC = 0.52-0.60，他的模型的 **AUC 可以达到 0.99** ）.

这个结果给我们的感觉像是 **过拟合和错误的交叉验证** 所造成的，在我解释原因之前，让我们先来观看下面的数据：

![Picture](http://www.marcoaltini.com/uploads/1/3/2/3/13234002/8966602.jpg?449)

这四张密度图表示的是他所用到的四个特征的在两个类别上的分布，这两个类别为正常分娩与早产（f = false，表示正常分娩，使用红色的线表示；t = true, 则表示为早产，用蓝色的线表示）。我们从图中可以看到这四个特征并没有很强的区分两个类别的能力。他所提取出来的特征在两个特征上的分布基本上就是重叠的。我们可以认为这是一个无用输入，无用输出的例子，而不是说这个模型缺少数据。

只要稍微思考一下该问题所在的领域，我们就会对 auc=0.99 这个结果提出质疑。因为区分正常分娩和早产没有一个很明确的区分。假设我们设置 37 周就为正常的分娩时间。 **那么如果你在第 36 周后的第 6 天分娩，那么我们则标记为早产。反之，如果在 37 周后 1 天妊娠，我们则标记为在正常的妊娠期内。** 很明显，这两种情况下区分早产和正常分娩是没有意义的，37 周只是一个惯例，因此，预测结果会大受影响并且对于分娩时间在 37 周左右的样本，结果会非常不精确。

在[这里](http://www.physionet.org/pn6/tpehgdb/)可以下载到所使用的数据集。在这篇文章中我会重复的展示数据集中的一部分特点，并且展示我们在过采样的情况下该如何进行合适的交叉验证。希望我在这个问题上所提出的一些矫正方案能够在未来让我们避免再犯这样的错误。

## 数据集，特征，性能评估和交叉验证技术

**数据集**

我们使用的数据来自于卢布尔雅那医学中心大学妇产科，数据中涵盖了从1997 年到 2005 年斯洛维尼亚地区的妊娠记录。他包含了从正常怀孕的 EHG 截面数据。 **这个数据是非常不均衡的，因为 300 个记录中只有 38 条才是早孕。** 更加详细的信息可以在 [3] 中找到。简单来说，我们选择 EHG 截面的理由是因为 EHG 测量的是子宫的电活动图，而这个活动图在怀孕期间会不断的变化，直到导致子宫收缩分娩出孩子。因此，研究推断非侵入性情况下监测怀孕活动可以尽早的发现哪些孕妇会早产。

**特征与分类器**

在 Physionet 上，你可以找到所有关于该研究的原始数据，但是为了让下面的实验不那么复杂，我们用到的是作者提供的另外一份数据来进行分析，这份数据中包含的特征是从原始数据中筛选出来的，筛选的条件是根据特征与 EHG 活动之间的相关频率。我们有四个特征（EHG信号的均方根，中值频率，频率峰值和样本熵，[这里](http://physionet.mit.edu/pn6/tpehgdb/tpehgdb.pdf) 有关如何计算这些特征值的更多信息）。据收集数据集的研究人员所说，大部分有价值的信息都是来自于渠道 3，因此我将使用从渠道 3 预提取出来的特征。详细的数据集也在 [github](https://github.com/marcoalt/Physionet-EHG-imbalanced-data) 可以找到。因为我们是要训练分类器分类器，所以我使用了一些常见的训练分类器的算法：逻辑回归、分类树、SVM 和随机森林。在博客中我不会做任何特征选择，而是将所有的数据都用来训练模型。

**评测指标**

在这里我们使用 **召回率** ， **真假率** 和 **AUC** 作为评测指标，关于指标的含义可以查看 [wikipedia](https://en.wikipedia.org/wiki/Sensitivity_and_specificity)

**交叉验证**

我决定使用 **留一法** 来做交叉验证。这种技术在使用数据集时或者当欠采样时不会有任何错误的余地。但是，当过采样时，情况又会有点不一样，所以让我们看下面的分析。

## 类别不均衡的数据

当我们遇到数据不均衡的时候，我们该如何做：

- 忽略这个问题
- 对占比较大的类别进行欠采样
- 对占比较小的类别进行过采样

## 忽略这个问题

如果我们使用不均衡的数据来训练分类器，那么训练出来的分类器在预测数据的时候总会返回数据集中占比最大的数据所对应的类别作为结果。这样的分类器具备太大的偏差，下面是训练这样的分类器所对应的代码：

```R
#leave one participant out cross-validation
results_lr <- rep(NA, nrow(data_to_use))
results_tree <- rep(NA, nrow(data_to_use))
results_svm <- rep(NA, nrow(data_to_use))
results_rf <- rep(NA, nrow(data_to_use))

for(index_subj  in 1:nrow(data_to_use))
{
  #remove subject to validate
  training_data <- data_to_use[-index_subj, ]
  training_data_formula <- training_data[, c("preterm", features)]

  #select features in the validation set
  validation_data <- data_to_use[index_subj, features]

  #logistic regression
  glm.fit <- glm(preterm ~.,
                 data = training_data_formula,
                 family = binomial)
  glm.probs <- predict(glm.fit, validation_data, type = "response")
  predictions_lr <- ifelse(glm.probs < 0.5, "t", "f")
  results_lr[index_subj] <- predictions_lr

  #classification tree
  tree.fit <- tree(preterm ~.,
                   data = training_data_formula)
  predictions_tree <- predict(tree.fit, validation_data, type = "class")
  results_tree[index_subj] <- predictions_tree

  #svm
  svm <- svm(preterm ~.,
             data = training_data_formula
  )
  predictions_svm <- predict(svm, validation_data)
  results_svm[index_subj] <- predictions_svm

  #random forest      
  rf <- randomForest(preterm ~.,
                     data = training_data_formula)
  predictions_rf <- predict(rf, validation_data)
  results_rf[index_subj] <- predictions_rf   
}
```

从上面的代码可以看出，在每次迭代中，我只需选择 index_subj 下标所对应的数据作为验证集，然后使用剩余的数据（即训练数据）构建模型。结果如下图所示


![Picture](http://www.marcoaltini.com/uploads/1/3/2/3/13234002/8399061.png?281)

如预期的那样，分类器的偏差太大，召回率为零或非常接近零，而真假率为1或非常接近于1，即所有或几乎所有记录被检测为会正常分娩，因此基本没有识别出早产的记录。下面的实验则使用了欠采样的方法。

## 对大类样本进行欠采样

处理类别不平衡数据的最常见和最简单的策略之一是对大类样本进行欠采样。 尽管过去也有很多关于解决数据不均衡的办法（例如，对具体样本进行欠采样，例如“远离决策边界”的方法）[4]，但那些方法都不能改进在简单随机选择样本的情况下有任何性能上的提升。 因此，我们的实验将从占比较大的类别下的样本中随机选择 *n* 个样本，其中 *n* 的值等于占比较小的类别下的样本的总数，并在训练阶段使用它们，然后在验证中排除掉这些样本。 代码如下：

```R
#leave one participant out cross-validation
results_lr <- rep(NA, nrow(data_to_use))
results_tree <- rep(NA, nrow(data_to_use))
results_svm <- rep(NA, nrow(data_to_use))
results_rf <- rep(NA, nrow(data_to_use))

rows_preterm <- sum(data_to_use$preterm == " t         ") #weird string, haven't changed it for now
for(index_subj  in 1:nrow(data_to_use))
{
  #remove subject to validate
  training_data <- data_to_use[-index_subj, ]
  training_data_preterm <- training_data[training_data$preterm == " t         ", ]
  training_data_term <- training_data[training_data$preterm == " f         ", ]

  #get subsample to balance dataset
  indices <- sample(nrow(training_data_term), rows_preterm)
  training_data_term <- training_data_term[indices, ]
  training_data <- rbind(training_data_preterm, training_data_term)

  #select features in the training set
  training_data_formula <- training_data[, c("preterm", features)]

  #select features in the validation set
  validation_data <- data_to_use[index_subj, features]

  #logistic regression
  glm.fit <- glm(preterm ~.,
                 data = training_data_formula,
                 family = binomial)
  glm.probs <- predict(glm.fit, validation_data, type = "response")
  predictions_lr <- ifelse(glm.probs < 0.5, "t", "f")
  results_lr[index_subj] <- predictions_lr

  #classification tree
  tree.fit <- tree(preterm ~.,
                   data = training_data_formula)
  predictions_tree <- predict(tree.fit, validation_data, type = "class")
  results_tree[index_subj] <- predictions_tree

  #svm
  svm <- svm(preterm ~.,
                    data = training_data_formula
  )
  predictions_svm <- predict(svm, validation_data)
  results_svm[index_subj] <- predictions_svm

  #random forest      
  rf <- randomForest(preterm ~.,
                                     data = training_data_formula,
                                     sampsize = c(nrow(training_data_preterm), nrow(training_data_preterm)))
  predictions_rf <- predict(rf, validation_data)
  results_rf[index_subj] <- predictions_rf   
}
```

如上所述，上面的代码与之前最大的不同的是在每次迭代的时候，我们从占比较大的类别下的样本中选取了 *n* ，然后使用这个 n 个样本和占比类别较小的样本组成了训练集来训练我们的分类器。结果如下图所示：

![Picture](http://www.marcoaltini.com/uploads/1/3/2/3/13234002/3234654.png?293)

通过欠采样，我们解决了数据类别不均衡的问题，并且提高了模型的召回率，但是，模型的表现并不是很好。其中一个原因可能是因为我们用来训练模型的数据过少。一般来说，如果我们的数据集中的类别越不均衡，那么我们在欠采样中抛弃的数据就会越多，那么就意味着我们可能抛弃了一些潜在的并且有用的信息。现在我们应该这样问我们自己，我们是否训练了一个弱的分类器，而原因是因为我们没有太多的数据？还是说我们依赖了不好的特征，所以就算数据再多对模型也没有帮助？

## 对少数类样本过采样

如果我们在 **交叉验证** 之前进行过采样会导致 **过拟合** 的问题。那么产生这个问题的原因是什么呢？让我们来看下面的一个关于过采样的简单实例。

最简单的过采样方式就是对占比类别较小下的样本进行重新采样，譬如说创建这些样本的副本，或者手动制造一些相同的数据。现在，如果我们在交叉验证之前做了过采样，然后使用留一法做交叉验证，也就是说我们在每次迭代中使用 N-1 份样本做训练，而只使用 1 份样本验证。 **但是我们注意到在其实在 N-1 份的样本中是包含了那一份用来做验证的样本的。所以这样做交叉验证完全违背了初衷。** 让我们用图形化的方式来更好的审视这个问题。

![Picture](http://www.marcoaltini.com/uploads/1/3/2/3/13234002/2639934.jpg?401)

最左边那列表示的是原始的数据，里面包含了少数类下的两个样本。我们拷贝这两个样本作为副本，然后再进行交叉验证。在迭代的过程，我们的训练样本和验证样本会包含相同的数据，如最右那张图所示，这种情况下会导致过拟合或误导的结果，合适的做法应该如下图所示。

![Picture](http://www.marcoaltini.com/uploads/1/3/2/3/13234002/9101820.jpg?372)

也就是说我们每次迭代做交叉验证之前先将验证样本从训练样本中分离出来，然后再对训练样本中少数类样本进行过采样（橙色那块图所示）。在这个示例中少数类样本只有两个，所以我拷贝了三份副本。这种做法与之前最大的不同就是训练样本和验证样本是没有交集的。因为我们获得一个比之前好的结果。即使我们使用其他的交叉验证方法，譬如 k-flod ，做法也是一样的。

这是一个简单的例子，当然我们也可以使用更加好的方法来做过采样。其中一种使用的过采样方法叫做 **SMOTE** 方法，SMOTE 方法并不是采取简单复制样本的策略来增加少数类样本， **而是通过分析少数类样本来创建新的样本** 的同时对多数类样本进行欠采样。正常来说当我们简单复制样本的时候，训练出来的分类器在预测这些复制样本时会很有信心的将他们识别出来，你为他知道这些复制样本的所有边界和特点，而不是以概括的角度来刻画这些少数类样本。但是，SMOTE 可以有效的强制让分类的边界更加的泛化，一定程度上解决了不够泛化而导致的过拟合问题。在 SMOTE 的[论文](https://www.jair.org/media/953/live-953-2037-jair.pdf)中用了很多图来进行解释这个问题的原理和解决方案，所以我建议大家可以去看看。

但是，我们有一定必须要清楚的是 **使用 SMOTE 过采样的确会提升决策边界，但是却并没有解决前面所提到的交叉验证所面临的问题。** 如果我们使用相同的样本来训练和验证模型，模型的技术指标肯定会比采样了合理交叉验证方法所训练出来的模型效果好。也就是说我在上面所举的例子对应的问题是仍然存在的。 **下面让我们来看一下在交叉验证之前进行过采样会得出怎样的结果。** 

**错误的使用交叉验证和过采样**

下面的代码将会先进行过采样，然后再进入交叉验证的循环，我们使用 SMOTE 方法合成了我们的样本：

```R
data_to_use <- tpehgdb_features
data_to_use_smote <- SMOTE(preterm ~ . , cbind(data_to_use[, c("preterm", features)]), k=5, perc.over = 600)

metrics_all <- data.frame()

#leave one participant out cross-validation
results_lr <- rep(NA, nrow(data_to_use_smote))
results_tree <- rep(NA, nrow(data_to_use_smote))
results_svm <- rep(NA, nrow(data_to_use_smote))
results_rf <- rep(NA, nrow(data_to_use_smote))

for(index_subj  in 1:nrow(data_to_use_smote))
{
  #remova subject to validate
  training_data <- data_to_use[-index_subj, ]

  #no need to balance the dataset anymore     
  #select features in the training set
  training_data_formula <- training_data[, c("preterm", features)]

  #select features in the validation set
  validation_data <- data_to_use_smote[index_subj, features]

  #logistic regression
  glm.fit <- glm(preterm ~.,
                 data = training_data_formula,
                 family = binomial)
  glm.probs <- predict(glm.fit, validation_data, type = "response")
  predictions_lr <- ifelse(glm.probs < 0.5, "t", "f")
  results_lr[index_subj] <- predictions_lr

  #classification tree
  tree.fit <- tree(preterm ~.,
                   data = training_data_formula)
  predictions_tree <- predict(tree.fit, validation_data, type = "class")
  results_tree[index_subj] <- predictions_tree

  #svm
  svm <- svm(preterm ~.,
             data = training_data_formula
  )
  predictions_svm <- predict(svm, validation_data)
  results_svm[index_subj] <- predictions_svm

  #random forest      
  rf <- randomForest(preterm ~.,
                     data = training_data_formula)
  predictions_rf <- predict(rf, validation_data)
  results_rf[index_subj] <- predictions_rf   
}

metrics_lr <- data.frame(binary_metrics(as.numeric(as.factor(results_lr)), as.numeric(data_to_use_smote$preterm), class_of_interest = 2))
metrics_lr[, c("classifier")] <- c("logistic_regression")
metrics_all <- rbind(metrics_all, metrics_lr)

metrics_tree <- data.frame(binary_metrics(results_tree, as.numeric(data_to_use_smote$preterm), class_of_interest = 2))
metrics_tree[, c("classifier")] <- c("tree")
metrics_all <- rbind(metrics_all, metrics_tree)

metrics_svm <- data.frame(binary_metrics(results_svm, as.numeric(data_to_use_smote$preterm), class_of_interest = 2))
metrics_svm[, c("classifier")] <- c("svm")
metrics_all <- rbind(metrics_all, metrics_svm)

metrics_rf <- data.frame(binary_metrics(results_rf, as.numeric(data_to_use_smote$preterm), class_of_interest = 2))
metrics_rf[, c("classifier")] <- c("random_forests")
metrics_all <- rbind(metrics_all, metrics_rf)  
```

R 包中的 SMOTE 函数在这里可以查看 [DMwR](https://cran.r-project.org/web/packages/DMwR/DMwR.pdf)。训练的结果如下：

![Picture](http://www.marcoaltini.com/uploads/1/3/2/3/13234002/9150552.png?297)

结果相当不错。尤其是随机森林在没有做任何特征工程和调参的前提下 **auc 的值达到了 0.93** ，但是与前面不同的是我们使用了 SMOTE 方法进行欠采样，现在这个问题的核心在于我们应该在什么时候使用恰当的方法，而不是使用哪种方法。在交叉验证之前使用过采样的确获得很高的精度，但模型已经 **过拟合** 了。你看，就算是最简单的分类树都可以获得 0.84 的 AUC 值。

**正确的使用过采样和交叉验证**

正确的在交叉验证中配合使用过拟合的方法很简单。就和我们在交叉验证中的每次循环中做特征选择一样，我们也要在每次循环中做过采样。 **根据我们当前的少数类创建样本，然后选择一个样本作为验证样本，假装我们没有使用在训练集中的数据来作为验证样本，这是毫无意义的。** 这一次，我们在交叉验证循环中过采样，因为验证集已经从训练样本中移除了，因为我们只需要插入那些不用于验证的样本来合成数据，我们交叉验证的迭代次数将和样本数一样，如下代码所示：

```R
data_to_use <- tpehgdb_features

metrics_all <- data.frame()

#leave one participant out cross-validation
results_lr <- rep(NA, nrow(data_to_use))
results_tree <- rep(NA, nrow(data_to_use))
results_svm <- rep(NA, nrow(data_to_use))
results_rf <- rep(NA, nrow(data_to_use))

for(index_subj  in 1:nrow(data_to_use))
{
  #remove subject to validate
  training_data <- data_to_use[-index_subj, ]
  training_data_smote <- SMOTE(preterm ~ . , cbind(training_data[, c("preterm", features)]), k=5, perc.over = 600)

  #no need to balance the dataset anymore     
  #select features in the training set
  training_data_formula <- training_data_smote[, c("preterm", features)]

  #select features in the validation set
  validation_data <- data_to_use[index_subj, features]

  #logistic regression
  glm.fit <- glm(preterm ~.,
                 data = training_data_formula,
                 family = binomial)
  glm.probs <- predict(glm.fit, validation_data, type = "response")
  predictions_lr <- ifelse(glm.probs < 0.5, "t", "f")
  results_lr[index_subj] <- predictions_lr

  #classification tree
  tree.fit <- tree(preterm ~.,
                   data = training_data_formula)
  predictions_tree <- predict(tree.fit, validation_data, type = "class")
  results_tree[index_subj] <- predictions_tree

  #svm
  svm <- svm(preterm ~.,
             data = training_data_formula
  )
  predictions_svm <- predict(svm, validation_data)
  results_svm[index_subj] <- predictions_svm

  #random forest      
  rf <- randomForest(preterm ~.,
                     data = training_data_formula)
  predictions_rf <- predict(rf, validation_data)
  results_rf[index_subj] <- predictions_rf   
}
```

最后，使用了 SMOTE 过采样技术和合适交叉验证下模型的结果如下所示：

![Picture](http://www.marcoaltini.com/uploads/1/3/2/3/13234002/5452864.png?314)

如之前所说，更多的数据并没有解决任何的问题，对于使用“智能”的过采样。它带来了非常高的精确度，但那是过拟合。下面是一些关于召回率和真假率指标的结果的分析和总结可以看看。

**召回率**

[![Picture](http://www.marcoaltini.com/uploads/1/3/2/3/13234002/8854367.jpg?402)](/uploads/1/3/2/3/13234002/8854367_orig.jpg?402)

[![Picture](http://www.marcoaltini.com/uploads/1/3/2/3/13234002/4587025.jpg?402)](/uploads/1/3/2/3/13234002/4587025_orig.jpg?402)

[![Picture](http://www.marcoaltini.com/uploads/1/3/2/3/13234002/3900757.jpg?402)](/uploads/1/3/2/3/13234002/3900757_orig.jpg?402)

[![Picture](http://www.marcoaltini.com/uploads/1/3/2/3/13234002/6433809.jpg?402)](/uploads/1/3/2/3/13234002/6433809_orig.jpg?402)

**真假率**

[![Picture](http://www.marcoaltini.com/uploads/1/3/2/3/13234002/6424600.jpg?402)](/uploads/1/3/2/3/13234002/6424600_orig.jpg?402)

[![Picture](http://www.marcoaltini.com/uploads/1/3/2/3/13234002/7570624.jpg?402)](/uploads/1/3/2/3/13234002/7570624_orig.jpg?402)

[![Picture](http://www.marcoaltini.com/uploads/1/3/2/3/13234002/5755279.jpg?402)](/uploads/1/3/2/3/13234002/5755279_orig.jpg?402)

[![Picture](http://www.marcoaltini.com/uploads/1/3/2/3/13234002/9325217.jpg?402)](/uploads/1/3/2/3/13234002/9325217_orig.jpg?402)

正如我们所看到，分别使用合适的过采样（第四张图）和欠采样（第二张图）在这个数据集上训练出来的模型差距并不是很大。

## 总结

在这篇文章中，我使用了不平衡的 EHG 数据来预测是否早产，目的是讲解在使用过采样的情况下该如何恰当的进行交叉验证。关键是过采样必须是交叉验证的一部分，而不是在交叉验证之前来做过采样。

总结一下，当在交叉验证中使用过采样时，请确保执行了以下步骤从而保证训练的结果具备泛化性：

- 在每次交叉验证迭代过程中，验证集都不要做任何与特征选择，过采样和构建模型相关的事情

- 过采样少数类的样本，但不要选择已经排除掉的那些样本。

- 用对少数类过采样和大多数类的样本混合在一起的数据集来训练模型，然后用已经排除掉的样本做为验证集

- 重复 *n* 次交叉验证的过程，*n* 的值是你训练样本的个数（如果你使用留一交叉验证法的话）

## **关于 EHG 数据、妊娠、分娩和早产分类的一份声明**

显然，分析结果并不意味着利用 EHG 数据检测是否早产是不可能的。只能说明一个横截面记录和这些基本特征并不够用来区分早产。这里最可能需要的是多重生理信号的纵向记录（如EHG、ECG、胎儿心电图、hr/hrv等）以及有关活动和行为的信息。多参数纵向数据可以帮助我们更好地理解这些信号在怀孕结果方面的变化，以及对个体差异的建模，类似于我们在其他复杂的应用中所看到的，从生理学的角度来看，这是很不容易理解的。在 [Bloom](http://www.bloom.life/)，我们正致力于更好地建模这些变量，以有效地预测早产风险。然而，这一问题的内在局限性，仅仅关乎参考值是如何定义的（例如，37周这个阈值是非常武断的），因此需要小心地分析近乎完美的分类，正如我们在这篇文章中所看到的那样。



## 引用文献

[1] Fergus, Paul, et al. "Prediction of preterm deliveries from EHG signals using machine learning." (2013): e77154. PloS one.

[2] Ren, Peng, et al. "Improved Prediction of Preterm Delivery Using Empirical Mode Decomposition Analysis of Uterine Electromyography Signals." PloS one. 10.7 (2015): e0132116.

[3] Fele-Žorž, Gašper, et al. "A comparison of various linear and non-linear signal processing techniques to separate uterine EMG records of term and pre-term delivery groups." Medical & biological engineering & computing 46.9 (2008): 911-922.

[4] Japkowicz, N. (2000). The Class Imbalance Problem: Significance and Strategies. In Proceedings of the 200 International Conference on Artificial Intelligence (IC-AI’2000): Special Track on Inductive Learning Las Vegas, Nevada.

[5] Chawla, Nitesh V., et al. "SMOTE: synthetic minority over-sampling technique."Journal of artificial intelligence research (2002): 321-357.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
