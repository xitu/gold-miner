> * 原文地址：[TensorFlow in a Nutshell — Part Two: Hybrid Learning](https://chatbotnewsdaily.com/tensorflow-in-a-nutshell-part-two-hybrid-learning-98c121d35392#.5mqhrid6c)
* 原文作者：[Camron Godbout](https://chatbotnewsdaily.com/@camrongodbout)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[edvardhua](https://github.com/edvardHua)
* 校对者：[marcmoore](https://github.com/marcmoore), [futureshine](https://github.com/futureshine)

# 简明 TensorFlow 教程 — 第二部分：混合学习
#### 快速上手世界上最流行的深度学习框架。

确保你已经阅读了[第一部分](https://github.com/xitu/gold-miner/blob/master/TODO/tensorflow-in-a-nutshell-part-one-basics.md)


在本文中，我们将演示一个宽 N 深度网络，它使用广泛的线性模型与前馈网络同时训练，以证明它比一些传统的机器学习技术能提供精度更高的预测结果。下面我们将使用混合学习方法预测泰坦尼克号乘客的生存概率。

混合学习技术已被 Google 应用在 Play 商店中提供应用推荐。Youtube 也在使用类似的混合学习技术来推荐视频。

本文的代码可以在[这里](https://github.com/c0cky/TensorFlow-in-a-Nutshell/tree/master/part2)找到。

#### 广泛深度网络

宽和深网络将线性模型与前馈神经网络结合，使得我们的预测将具有记忆和通用化。 这种类型的模型可以用于分类和回归问题。 这种方法能够在减少特征工程的同时拥有相对精确的预测结果，可谓一箭双雕。


![](https://cdn-images-1.medium.com/max/2000/1*UutPkDr3n0DF6RrlnsAJEA.png)



#### 数据

我们将使用泰坦尼克号 Kaggle 数据来预测乘客的生存率是否和某些属性有关，如姓名、性别、船票、船舱的类型等。有关此数据的更多信息请点击[这里](https://www.kaggle.com/c/titanic/data)。

首先，我们要将所有列定义为连续或分类。

连续的列 - 连续范围内的任何数值。 像钱或年龄。

分类列 - 有限集的一部分。 像男性或女性，或着乘客的国籍。

    CATEGORICAL_COLUMNS = ["Name", "Sex", "Embarked", "Cabin"]
    CONTINUOUS_COLUMNS = ["Age", "SibSp", "Parch", "Fare", "PassengerId", "Pclass"]

因为我们只是想看看一个人是否幸存下来，这是一个二元分类问题。 所以预测结果 1 表示该乘客幸存下来，而结果 0 表示没有幸存。（也即创建一列来储存预测结果）

    SURVIVED_COLUMN = "Survived"

#### 网络

现在我们可以创建列和添加嵌入层。 当我们构建我们的模型时，我们想要将我们的分类列变成稀疏列。 对于没有那么多类别（例如 Sex 或 Embarked（S，Q 或 C））的列，我们根据类名将它们转换为稀疏列。

    sex = tf.contrib.layers.sparse_column_with_keys(column_name="Sex",
                                                         keys=["female",
                                                     "male"])
      embarked = tf.contrib.layers.sparse_column_with_keys(column_name="Embarked",
                                                       keys=["C",
                                                             "S",
                                                             "Q"])

对于类别较多的分类列，由于我们没有一个词汇表文件将所有可能的类别映射为一个整数，所以我们使用哈希值作为键值。

    cabin = tf.contrib.layers.sparse_column_with_hash_bucket(
          "Cabin", hash_bucket_size=1000)
          name = tf.contrib.layers.sparse_column_with_hash_bucket(
          "Name", hash_bucket_size=1000)

我们的连续列使用的是真实的值。 因为 passengerId 是连续的而不是分类的，并且他们已经是整数的 ID 而不是字符串。

    age = tf.contrib.layers.real_valued_column("Age")
          passenger_id = tf.contrib.layers.real_valued_column("PassengerId")
    sib_sp = tf.contrib.layers.real_valued_column("SibSp")
    parch = tf.contrib.layers.real_valued_column("Parch")
    fare = tf.contrib.layers.real_valued_column("Fare")
    p_class = tf.contrib.layers.real_valued_column("Pclass")

我们需要根据年龄对乘客进行分类。 桶化（Bucketization ）允许我们找到乘客对应年龄组的生存相关性，而不是将所有年龄作为一个大整体，从而提高我们的准确性。

    age_buckets = tf.contrib.layers.bucketized_column(age,
                                                        boundaries=[
                                                            5, 18, 25,
                                                            30, 35, 40,
                                                            45, 50, 55,
                                                             65
                                                        ])

最后，我们将定义我们的广度列和深度列。 我们的宽列将有效地记住我们与特征之间的交互。 我们的宽列不会将我们的特征通用化，这是深度列的用处。

    wide_columns = [sex, embarked, p_class, cabin, name, age_buckets,
                      tf.contrib.layers.crossed_column([p_class, cabin],
                                                       hash_bucket_size=int(1e4)),
                      tf.contrib.layers.crossed_column(
                          [age_buckets, sex],
                          hash_bucket_size=int(1e6)),
                      tf.contrib.layers.crossed_column([embarked, name],
                                                       hash_bucket_size=int(1e4))]

拥有这些深度列的好处是，它会将我们提供的高维度稀疏的特征进行降维来计算。

    deep_columns = [
          tf.contrib.layers.embedding_column(sex, dimension=8),
          tf.contrib.layers.embedding_column(embarked, dimension=8),
          tf.contrib.layers.embedding_column(p_class,
                                             dimension=8),
          tf.contrib.layers.embedding_column(cabin, dimension=8),
          tf.contrib.layers.embedding_column(name, dimension=8),
          age,
          passenger_id,
          sib_sp,
          parch,
          fare,
      ]

我们通过使用深度列和广度列来创建分类器，以完成我们的函数。

    return tf.contrib.learn.DNNLinearCombinedClassifier(
             linear_feature_columns=wide_columns,
            dnn_feature_columns=deep_columns,
            dnn_hidden_units=[100, 50])

我们在运行网络之前要做的最后一件事是为我们的连续和分类列创建映射。 我们先创建一个输入函数给我们的数据框，它能将我们的数据框转换为 Tensorflow 可以操作的对象。 这样做的好处是，我们可以改变和调整我们的 tensors 创建过程。 例如说我们可以将特征列传递到 _.fit_ _.feature .predict_ 作为一个单独创建的列，就像我们上面所描述的一样，但这个是一个更加简洁的方案。

    def input_fn(df, train=False):
      """Input builder function."""
      # Creates a dictionary mapping from each continuous feature column name (k) to
      # the values of that column stored in a constant Tensor.
      continuous_cols = {k: tf.constant(df[k].values) for k in CONTINUOUS_COLUMNS}
      # Creates a dictionary mapping from each categorical feature column name (k)
      # to the values of that column stored in a tf.SparseTensor.
      categorical_cols = {k: tf.SparseTensor(
        indices=[[i, 0] for i in range(df[k].size)],
        values=df[k].values,
        shape=[df[k].size, 1])
                          for k in CATEGORICAL_COLUMNS}
      # Merges the two dictionaries into one.
      feature_cols = dict(continuous_cols)
      feature_cols.update(categorical_cols)
      # Converts the label column into a constant Tensor.
      if train:
        label = tf.constant(df[SURVIVED_COLUMN].values)
          # Returns the feature columns and the label.
        return feature_cols, label
      else:
        # so we can predict our results that don't exist in the csv
        return feature_cols

现在，做完了以上工作，我们就可以开始编写训练功能了

    def train_and_eval():
      """Train and evaluate the model."""
      df_train = pd.read_csv(
          tf.gfile.Open("./train.csv"),
          skipinitialspace=True)
      df_test = pd.read_csv(
          tf.gfile.Open("./test.csv"),
          skipinitialspace=True)

      model_dir = "./models"
      print("model directory = %s" % model_dir)

      m = build_estimator(model_dir)
      m.fit(input_fn=lambda: input_fn(df_train, True), steps=200)
      print m.predict(input_fn=lambda: input_fn(df_test))
      results = m.evaluate(input_fn=lambda: input_fn(df_train, True), steps=1)
      for key in sorted(results):
        print("%s: %s" % (key, results[key]))

我们读取预处理后的 csv 文件，像处理缺失值等。为了让文章保持简洁，更多有关预处理的代码和内容可以在代码仓库中找到。

这些 csv 文件将通过调用 input_fn 函数转换为 tensors 。 我们先构建评价指标，然后打印我们的预测和评估结果。

### 结果


![](https://cdn-images-1.medium.com/max/1600/1*WP9Rh1BvPNJyZw9-UYDhWg.png)





网络结果

运行我们的代码为我们提供了相当好的结果，不需要添加任何额外的列或做任何特征工程。 而且只要很少的微调这个模型可以得到相对较好的结果。



![](https://cdn-images-1.medium.com/max/1600/1*CVoes2yr1puyXkWT69nMlw.png)



与传统广度线性模型一起添加嵌入层的能力，允许通过将稀疏维度降低到低维度来进行准确的预测。

### 结论

这部分偏离了传统的深度学习，说明 Tensorflow 还有许多其他用途和应用。 本文主要根据 Google 提供的论文和代码进行广泛深入的学习。 研究论文可以在[这里](https://arxiv.org/abs/1606.07792)找到。 Google 将此模型用作 Google Play 商店的产品推荐引擎，并帮助他们在提高应用销量上给出了建议。 YouTube 也发布了一篇关于他们使用混合模型做推荐系统的[文章](https://static.googleusercontent.com/media/research.google.com/en//pubs/archive/45530.pdf)。 这些模型开始更多地被各种公司推荐，并且会因为优秀的嵌入能力越来越流行。