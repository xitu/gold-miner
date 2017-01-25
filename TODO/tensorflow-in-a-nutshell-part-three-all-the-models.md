> * 原文地址：[TensorFlow in a Nutshell — Part Three: All the Models](https://hackernoon.com/tensorflow-in-a-nutshell-part-three-all-the-models-be1465993930?gi=ce7ca5538f3e#.ji73p7x7j)
* 原文作者：[Camron Godbout](https://hackernoon.com/@camrongodbout)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[edvardhua](https://github.com/edvardHua)
* 校对者：[marcmoore](https://github.com/marcmoore), [cdpath](https://github.com/cdpath)

# 简明 TensorFlow 教程 —  第三部分: 所有的模型


#### 快速上手世界上最流行的深度学习框架

请务必查看其他文章。 >>[点击查看](http://camron.xyz/)<<

#### 概述

在本文中，我们将讨论 TensorFlow 中当前可用的所有抽象模型，并描述该特定模型的用例以及简单的示例代码。 [完整的工作示例源码](https://github.com/c0cky/TensorFlow-in-a-Nutshell)。


* * *




![](https://cdn-images-1.medium.com/max/800/1*lQ4izz9ZbhKYD8NClZpsmQ.png)


一个循环神经网络。


#### 递归神经网络 简称 RNN

用例:语言建模，机器翻译，词嵌入，文本处理。

自从长短期记忆神经网络（LSTM）和门限循环单元（GRU）的出现，循环神经网络在自然语言处理中的发展迅速，远远超越了其他的模型。他们可以被用于传入向量以表示字符，依据训练集生成新的语句。这个模型的优点是它保持句子的上下文，并得出“猫坐在垫子上”的意思，意味着猫在垫子上。 TensorFlow 的出现让创建这些网络变得越来越简单。关于 TensorFlow 的更多隐藏特性可以从 [Denny Britz 文章](http://www.wildml.com/2016/08/rnns-in-tensorflow-a-practical-guide-and-undocumented-features/) 中找到。

    import tensorflow as tf
    import numpy as np
    # Create input data
    X = np.random.randn(2, 10, 8)

    # The second example is of length 6 
    X[1,6,:] = 0
    X_lengths = [10, 6]

    cell = tf.nn.rnn_cell.LSTMCell(num_units=64, state_is_tuple=True)
    cell = tf.nn.rnn_cell.DropoutWrapper(cell=cell, output_keep_prob=0.5)
    cell = tf.nn.rnn_cell.MultiRNNCell(cells=[cell] * 4, state_is_tuple=True)

    outputs, last_states = tf.nn.dynamic_rnn(
        cell=cell,
        dtype=tf.float64,
        sequence_length=X_lengths,
        inputs=X)

    result = tf.contrib.learn.run_n(
        {"outputs": outputs, "last_states": last_states},
        n=1,
        feed_dict=None)



* * *






![](https://cdn-images-1.medium.com/max/800/1*N4h1SgwbWNmtrRhszM9EJg.png)



卷积网络



#### 卷积网络
用例:图像处理, 面部识别, 计算机视觉

卷积神经网络（Convolutional Neural Networks-简称 CNN ）是独一无二的，因为他可以直接输入原始图像，避免了对图像复杂前期预处理。 CNN 用固定的窗口（下图窗口为 3x3 ）从左至右从上往下遍历图像。 其中我们称该窗口为卷积核，每次卷积（与前面遍历对应）都会计算其卷积特征。







![](https://cdn-images-1.medium.com/max/800/1*ZCjPUFrB6eHPRi4eyP6aaA.gif)



[图片来源 ](http://deeplearning.standford.edu/wiki/index.php/Feature_extraction_using_convolution)



我们可以使用卷积特征来做边缘检测，从而允许 CNN 描述图像中的物体。








![](https://cdn-images-1.medium.com/max/800/1*3H4Ho1lX_saXzqK243Ic9w.jpeg)



[GIMP 手册](https://docs.gimp.org/2.8/zh_CN/)上边缘检测的例子



上图使用的卷积特征矩阵如下所示：




![](https://cdn-images-1.medium.com/max/800/1*h5XnUMUF7XcmTCFrU5pTeQ.png)



GIMP 手册中的卷积特征


下面是一个代码示例，用于从 MNIST 数据集中识别手写数字。

    ### Convolutional network
    def max_pool_2x2(tensor_in):
      return tf.nn.max_pool(
          tensor_in, ksize=[1, 2, 2, 1], strides=[1, 2, 2, 1], padding='SAME')
    def conv_model(X, y):
      # reshape X to 4d tensor with 2nd and 3rd dimensions being image width and
      # height final dimension being the number of color channels.
      X = tf.reshape(X, [-1, 28, 28, 1])
      # first conv layer will compute 32 features for each 5x5 patch
      with tf.variable_scope('conv_layer1'):	
        h_conv1 = learn.ops.conv2d(X, n_filters=32, filter_shape=[5, 5],
                                   bias=True, activation=tf.nn.relu)
        h_pool1 = max_pool_2x2(h_conv1)
      # second conv layer will compute 64 features for each 5x5 patch.
      with tf.variable_scope('conv_layer2'):
        h_conv2 = learn.ops.conv2d(h_pool1, n_filters=64, filter_shape=[5, 5],
                                   bias=True, activation=tf.nn.relu)
        h_pool2 = max_pool_2x2(h_conv2)
        # reshape tensor into a batch of vectors
        h_pool2_flat = tf.reshape(h_pool2, [-1, 7 * 7 * 64])
      # densely connected layer with 1024 neurons.
      h_fc1 = learn.ops.dnn(
          h_pool2_flat, [1024], activation=tf.nn.relu, dropout=0.5)
      return learn.models.logistic_regression(h_fc1, y)


* * *




![](https://cdn-images-1.medium.com/max/800/1*toBL6XleRkwABSwTAFaY_g.png)





#### 前馈型神经网络
用例：分类和回归

这些网络由一层层的感知器组成，这些感知器接收将信息传递到下一层的输入，由网络中的最后一层输出结果。 在给定层中的每个节点之间没有连接。 没有原始输入和没有最终输出的图层称为隐藏图层。

这个网络的目标类似于使用反向传播的其他监督神经网络，使得输入后得到期望的受训输出。 这些是用于分类和回归问题的一些最简单的有效神经网络。 下面代码展示如何轻松地创建前馈型神经网络来分类手写数字：

    def init_weights(shape):
        return tf.Variable(tf.random_normal(shape, stddev=0.01))
    def model(X, w_h, w_o):
        h = tf.nn.sigmoid(tf.matmul(X, w_h)) # this is a basic mlp, think 2 stacked logistic regressions
        return tf.matmul(h, w_o) # note that we dont take the softmax at the end because our cost fn does that for us
    mnist = input_data.read_data_sets("MNIST_data/", one_hot=True)
    trX, trY, teX, teY = mnist.train.images, mnist.train.labels, mnist.test.images, mnist.test.labels
    X = tf.placeholder("float", [None, 784])
    Y = tf.placeholder("float", [None, 10])
    w_h = init_weights([784, 625]) # create symbolic variables
    w_o = init_weights([625, 10])
    py_x = model(X, w_h, w_o)
    cost = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits(py_x, Y)) # compute costs
    train_op = tf.train.GradientDescentOptimizer(0.05).minimize(cost) # construct an optimizer
    predict_op = tf.argmax(py_x, 1)
    # Launch the graph in a session
    with tf.Session() as sess:
        # you need to initialize all variables
        tf.initialize_all_variables().run()
    for i in range(100):
            for start, end in zip(range(0, len(trX), 128), range(128, len(trX)+1, 128)):
                sess.run(train_op, feed_dict={X: trX[start:end], Y: trY[start:end]})
            print(i, np.mean(np.argmax(teY, axis=1) ==
                             sess.run(predict_op, feed_dict={X: teX, Y: teY})))



* * *




![](https://cdn-images-1.medium.com/max/800/1*Sy_6ipmBh_21KD0_dds1HQ.png)





#### 线性模型

用例：分类和回归

线性模型根据 X 轴值的变化，并产生用于Y轴值的分类和回归的最佳拟合线。 例如，如果你有一片区域房子的大小和价钱，那么我们就可以利用线性模型来根据房子的大小来预测价钱。

需要注意的一点是，线性模型可以用于多个特征。 例如在住房示例中，我们可以根据房子大小，房间数量和浴室数量以及价钱来构建一个线性模型，然后利用这个线性模型来根据房子的大小，房间以及浴室个数来预测价钱。

    import numpy as np
    import tensorflow as tf

    import numpy as np
    import tensorflow as tf
    def weight_variable(shape):
        initial = tf.truncated_normal(shape, stddev=1)
        return tf.Variable(initial)
    # dataset
    xx = np.random.randint(0,1000,[1000,3])/1000.
    yy = xx[:,0] * 2 + xx[:,1] * 1.4 + xx[:,2] * 3
    # model
    x = tf.placeholder(tf.float32, shape=[None, 3])
    y_ = tf.placeholder(tf.float32, shape=[None])
    W1 = weight_variable([3, 1])
    y = tf.matmul(x, W1)
    # training and cost function
    cost_function = tf.reduce_mean(tf.square(tf.squeeze(y) - y_))
    train_function = tf.train.AdamOptimizer(1e-2).minimize(cost_function)
    # create a session
    sess = tf.Session()
    # train
    sess.run(tf.initialize_all_variables())
    for i in range(10000):
        sess.run(train_function, feed_dict={x:xx, y_:yy})
        if i % 1000 == 0:
            print(sess.run(cost_function, feed_dict={x:xx, y_:yy}))



* * *


![](https://cdn-images-1.medium.com/max/800/1*XwNZplJ1p-xnUKRQPMS6Aw.png)





#### 支持向量机

用例：目前只能用来做二进制分类

SVM 背后的一般思想是存在线性可分离模式的最佳超平面。 对于不可线性分离的数据，我们可以使用内核函数将原始数据转换为新空间。 SVM 使分离超平面的边界最大化。 它们在高维空间中非常好地工作，并且如果维度大于取样的数量，SVM 仍然有效。

    def input_fn():
          return {
              'example_id': tf.constant(['1', '2', '3']),
              'price': tf.constant([[0.6], [0.8], [0.3]]),
              'sq_footage': tf.constant([[900.0], [700.0], [600.0]]),
              'country': tf.SparseTensor(
                  values=['IT', 'US', 'GB'],
                  indices=[[0, 0], [1, 3], [2, 1]],
                  shape=[3, 5]),
              'weights': tf.constant([[3.0], [1.0], [1.0]])
          }, tf.constant([[1], [0], [1]])
    price = tf.contrib.layers.real_valued_column('price')
        sq_footage_bucket = tf.contrib.layers.bucketized_column(
            tf.contrib.layers.real_valued_column('sq_footage'),
            boundaries=[650.0, 800.0])
        country = tf.contrib.layers.sparse_column_with_hash_bucket(
            'country', hash_bucket_size=5)
        sq_footage_country = tf.contrib.layers.crossed_column(
            [sq_footage_bucket, country], hash_bucket_size=10)
        svm_classifier = tf.contrib.learn.SVM(
            feature_columns=[price, sq_footage_bucket, country, sq_footage_country],
            example_id_column='example_id',
            weight_column_name='weights',
            l1_regularization=0.1,
            l2_regularization=1.0)
    svm_classifier.fit(input_fn=input_fn, steps=30)
        accuracy = svm_classifier.evaluate(input_fn=input_fn, steps=1)['accuracy']



* * *




![](https://cdn-images-1.medium.com/max/800/1*EaDupDnQB1QYL6MPvr3w_Q.png)





#### 深和宽的模型

用例：推荐系统，分类和回归

深和宽模型在[第二部分](https://medium.com/@camrongodbout/tensorflow-in-a-nutshell-part-two-hybrid-learning-98c121d35392#.oubizxp18)中有更详细的描述，所以我们在这里不会讲解太多。 宽和深的网络将线性模型与前馈神经网络结合，使得我们的预测将具有记忆和泛化。 这种类型的模型可以用于分类和回归问题。 这允许利用相对准确的预测来减少特征工程。 因此，能够结合两个模型得出最好的结果。 下面的代码片段摘自[第二部分](https://github.com/c0cky/TensorFlow-in-a-Nutshell/tree/master/part2)。

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
        return feature_cols
    m = build_estimator(model_dir)
    m.fit(input_fn=lambda: input_fn(df_train, True), steps=200)
    print m.predict(input_fn=lambda: input_fn(df_test))
    results = m.evaluate(input_fn=lambda: input_fn(df_train, True), steps=1)
    for key in sorted(results):
      print("%s: %s" % (key, results[key]))


* * *



![](https://cdn-images-1.medium.com/max/800/1*breo9La3b-US5oG4KUuZqw.png)





#### 随机森林

用例：分类和回归

随机森林模型中有很多不同分类树，每个分类树都可以投票来对物体进行分类，从而选出票数最多的类别。

随机森林不会过拟合，所以你可以使用尽可能多的树，而且执行的速度也是相对较快的。 下面的代码片段是对鸢尾花数据集（[Iris flower data set](https://en.wikipedia.org/wiki/Iris_flower_data_set)）使用随机森林：

    hparams = tf.contrib.tensor_forest.python.tensor_forest.ForestHParams(
            num_trees=3, max_nodes=1000, num_classes=3, num_features=4)
    classifier = tf.contrib.learn.TensorForestEstimator(hparams)
    iris = tf.contrib.learn.datasets.load_iris()
    data = iris.data.astype(np.float32)
    target = iris.target.astype(np.float32)
    monitors = [tf.contrib.learn.TensorForestLossMonitor(10, 10)]
    classifier.fit(x=data, y=target, steps=100, monitors=monitors)
    classifier.evaluate(x=data, y=target, steps=10)



* * *



![](https://cdn-images-1.medium.com/max/800/1*yu7chokfJ6Ufut79peUNlw.png)





#### 贝叶斯强化学习（Bayesian Reinforcement Learning）

用例：分类和回归

在 TensorFlow 的 contrib 文件夹中有一个名为 BayesFlow 的库。 除了一个 REINFORCE 算法的例子就没有其他文档了。 该算法在 Ronald Williams 的[论文](http://incompleteideas.net/sutton/williams-92.pdf)中提出。


> 获得的递增 = 非负因子 * 强化偏移 * 合格的特征

这个网络试图解决立即强化学习任务，在每次试验获得强化值后调整权重。 在每次试验结束时，每个权重通过学习率因子乘以增强值减去基线乘以合格的特征而增加。 Williams 的论文还讨论了使用反向传播来训练强化网络。

    """Build the Split-Apply-Merge Model.
      Route each value of input [-1, -1, 1, 1] through one of the
      functions, plus_1, minus_1\.  The decision for routing is made by
      4 Bernoulli R.V.s whose parameters are determined by a neural network
      applied to the input.  REINFORCE is used to update the NN parameters.
      Returns:
        The 3-tuple (route_selection, routing_loss, final_loss), where:
          - route_selection is an int 4-vector
          - routing_loss is a float 4-vector
          - final_loss is a float scalar.
      """
      inputs = tf.constant([[-1.0], [-1.0], [1.0], [1.0]])
      targets = tf.constant([[0.0], [0.0], [0.0], [0.0]])
      paths = [plus_1, minus_1]
      weights = tf.get_variable("w", [1, 2])
      bias = tf.get_variable("b", [1, 1])
      logits = tf.matmul(inputs, weights) + bias
    # REINFORCE forward step
      route_selection = st.StochasticTensor(
          distributions.Categorical, logits=logits)


* * *



![](https://cdn-images-1.medium.com/max/800/1*1MHiieXwdKo75p-_4VkFnQ.png)





#### 线性链条件随机域 （Linear Chain Conditional Random Fields，简称 CRF）

用例：序列数据

CRF 是根据无向模型分解的条件概率分布。 他们预测单个样本的标签，保留来自相邻样本的上下文。 CRF 类似于隐马尔可夫模型。 CRF 通常用于图像分割和对象识别，以及浅分析，命名实体识别和基因发现。

    # Train for a fixed number of iterations.
    session.run(tf.initialize_all_variables())
      for i in range(1000):
        tf_unary_scores, tf_transition_params, _ = session.run(
           [unary_scores, transition_params, train_op])
        if i % 100 == 0:
          correct_labels = 0
          total_labels = 0
          for tf_unary_scores_, y_, sequence_length_ in zip(tf_unary_scores, y, sequence_lengths):
            # Remove padding from the scores and tag sequence.
            tf_unary_scores_ = tf_unary_scores_[:sequence_length_]
            y_ = y_[:sequence_length_]

            # Compute the highest scoring sequence.
            viterbi_sequence, _ = tf.contrib.crf.viterbi_decode(
                tf_unary_scores_, tf_transition_params)

            # Evaluate word-level accuracy.
            correct_labels += np.sum(np.equal(viterbi_sequence, y_))
            total_labels += sequence_length_
          accuracy = 100.0 * correct_labels / float(total_labels)
          print("Accuracy: %.2f%%" % accuracy)



* * *







#### 总结

自从 TensorFlow 发布以来，围绕该项目的社区一直在添加更多的组件，示例和案例来使用这个库。 即使在撰写本文时，还有更多的模型和示例代码正在编写。 很高兴看到 TensorFlow 在过去几个月中的成长。 组件的易用性和多样性正在增加，在未来也会平稳的增加。


#### 译者参考文献

1. [词嵌入](https://www.zhihu.com/question/32275069)
2. [长短记忆网络](https://en.wikipedia.org/wiki/Long_short-term_memory)
3. [卷积神经网络](http://blog.csdn.net/stdcoutzyx/article/details/41596663)
4. [前馈神经网络](http://baike.baidu.com/view/1986922.htm)