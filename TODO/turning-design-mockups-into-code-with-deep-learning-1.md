> * 原文地址：[Turning Design Mockups Into Code With Deep Learning - Part 1](https://blog.floydhub.com/turning-design-mockups-into-code-with-deep-learning/)
> * 原文作者：[Emil Wallner](https://twitter.com/EmilWallner)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/turning-design-mockups-into-code-with-deep-learning-1.md](https://github.com/xitu/gold-miner/blob/master/TODO/turning-design-mockups-into-code-with-deep-learning-1.md)
> * 译者：
> * 校对者：

# Turning Design Mockups Into Code With Deep Learning - Part 1

- [Turning Design Mockups Into Code With Deep Learning - Part 1](https://github.com/xitu/gold-miner/blob/master/TODO/turning-design-mockups-into-code-with-deep-learning-1.md)
- [Turning Design Mockups Into Code With Deep Learning - Part 2](https://github.com/xitu/gold-miner/blob/master/TODO/turning-design-mockups-into-code-with-deep-learning-2.md)

Within three years deep learning will change front-end development. It will increase prototyping speed and lower the barrier for building software.

The field took off last year when Tony Beltramelli introduced the [pix2code paper](https://arxiv.org/abs/1705.07962) and Airbnb launched [sketch2code](https://airbnb.design/sketching-interfaces/).

Currently, the largest barrier to automating front-end development is computing power. However, we can use current deep learning algorithms, along with synthesized training data, to start exploring artificial front-end automation right now.

In this post, we’ll teach a neural network how to code a basic a HTML and CSS website based on a picture of a design mockup. Here's a quick overview of the process:

### 1) Give a design image to the trained neural network

![](https://blog.floydhub.com/static/image_to_notebookfile-3354b407064e4d95a0217612a5463434-6c1a3.png)

### 2) The neural network converts the image into HTML markup

![](/generate_html_markup-b6ceec69a7c9cfd447d188648049f2a4.gif)

### 3) Rendered output

![](https://blog.floydhub.com/static/render_example-4c9df7e5e8bb455c71dd7856acca7aae-6c1a3.png)

We’ll build the neural network in three iterations.

In the first version, we’ll make a bare minimum version to get a hang of the moving parts. The second version, HTML, will focus on automating all the steps and explaining the neural network layers. In the final version, Bootstrap, we’ll create a model that can generalize and explore the LSTM layer.

All the code is prepared on [Github](https://github.com/emilwallner/Screenshot-to-code-in-Keras/blob/master/README.md) and [FloydHub](https://www.floydhub.com/emilwallner/projects/picturetocode) in Jupyter notebooks. All the FloydHub notebooks are inside the `floydhub` directory and the local equivalents are under `local`.

The models are based on Beltramelli‘s [pix2code paper](https://arxiv.org/abs/1705.07962) and Jason Brownlee’s [image caption tutorials](https://machinelearningmastery.com/blog/page/2/). The code is written in Python and Keras, a framework on top of TensorFlow.

If you’re new to deep learning, I’d recommend getting a feel for Python, backpropagation, and convolutional neural networks. My three earlier posts on FloydHub’s blog will get you started [[1]](https://blog.floydhub.com/my-first-weekend-of-deep-learning/) [[2]](https://blog.floydhub.com/coding-the-history-of-deep-learning/) [[3]](https://blog.floydhub.com/colorizing-b&w-photos-with-neural-networks/).

## Core Logic

Let’s recap our goal. We want to build a neural network that will generate HTML/CSS markup that corresponds to a screenshot.

When you train the neural network, you give it several screenshots with matching HTML.

It learns by predicting all the matching HTML markup tags one by one. When it predicts the next markup tag, it receives the screenshot as well as all the correct markup tags until that point.

Here is a simple [training data example](https://docs.google.com/spreadsheets/d/1xXwarcQZAHluorveZsACtXRdmNFbwGtN3WMNhcTdEyQ/edit?usp=sharing) in a Google Sheet.

Creating a model that predicts word by word is the most common approach today. There are [other approaches](https://machinelearningmastery.com/deep-learning-caption-generation-models/), but that’s the method that we’ll use throughout this tutorial.

Notice that for each prediction it gets the same screenshot. So if it has to predict 20 words, it will get the same design mockup twenty times. For now, don’t worry about how the neural network works. Focus on grasping the input and output of the neural network.

![](https://blog.floydhub.com/static/neural_network_overview-82bea09299f242ad5d6e1236b9661ec6-6c1a3.png)

Let’s focus on the previous markup. Say we train the network to predict the sentence “I can code”. When it receives “I”, then it predicts “can”. Next time it will receive “I can” and predict “code”. It receives all the previous words and only has to predict the next word.

![](https://blog.floydhub.com/static/input_and_output_data-555f7b04c75a202041f0a4438af5cd51-6c1a3.png)

From the data the neural network creates features. The neural network builds features to link the input data with the output data. It has to create representations to understand what is in each screenshot, the HTML syntax, that it has predicted. This builds the knowledge to predict the next tag.

When you want to use the trained model for real-world usage, it's similar to when you train the model. The text is generated one by one with the same screenshot each time. Instead of feeding it with the correct HTML tags, it receives the markup it has generated so far. Then it predicts the next markup tag. The prediction is initiated with a "start tag" and stops when it predicts an “end tag” or reaches a max limit. Here's another example in [a Google Sheet](https://docs.google.com/spreadsheets/d/1yneocsAb_w3-ZUdhwJ1odfsxR2kr-4e_c5FabQbNJrs/edit?usp=sharing).

![](https://blog.floydhub.com/static/model_prediction-801ad7af1d2205276ba64fdc6d7c7ec8-6c1a3.png)

## **Hello World Version**

Let’s build a hello world version. We’ll feed a neural network a screenshot with a website displaying “Hello World!”, and teach it to generate the markup.

![](/hello_world_generation-039d78c27eb584fa639b89d564b94772.gif)

First, the neural network maps the design mockup into a list of pixel values. From 0 - 255 in three channels - red, blue, and green.

![](https://blog.floydhub.com/static/website_pixels-6f11057880ea91a87ddc087c27d063a7-6c1a3.png)

To represent the markup in a way that the neural network understands, I use [one hot encoding](https://machinelearningmastery.com/how-to-one-hot-encode-sequence-data-in-python/). Thus, the sentence “I can code”, could be mapped like the below.

![](https://blog.floydhub.com/static/one_hot_encoding-2a72d2b794b26e6e4c4cc9c5f8bd4649-6c1a3.png)

In the above graphic, we include the start and end tag. These tags are cues for when the network starts its predictions and when to stop.

For the input data, we will use sentences, starting with the first word and then adding each word one by one. The output data is always one word.

Sentences follow the same logic as words. They also need the same input length. Instead of being capped by the vocabulary they are bound by maximum sentence length. If it’s shorter than the maximum length, you fill it up with empty words, a word with just zeros.

![](https://blog.floydhub.com/static/one_hot_sentence-6b3c930c8a7808b928639201cac78ebe-6c1a3.png) 

As you see, words are printed from right to left. This forces each word to change position for each training round. This allows the model to learn the sequence instead of memorizing the position of each word.

In the below graphic there are four predictions. Each row is one prediction. To the left are the images represented in their three color channels: red, green and blue and the previous words. Outside of the brackets, are the predictions one by one, ending with a red square to mark the end.

![](https://blog.floydhub.com/static/model_function-068c180c2ba3efdbb54193f21a5d5d7d-6c1a3.png) 

```
    #Length of longest sentence
    max_caption_len = 3
    #Size of vocabulary 
    vocab_size = 3

    # Load one screenshot for each word and turn them into digits 
    images = []
    for i in range(2):
        images.append(img_to_array(load_img('screenshot.jpg', target_size=(224, 224))))
    images = np.array(images, dtype=float)
    # Preprocess input for the VGG16 model
    images = preprocess_input(images)

    #Turn start tokens into one-hot encoding
    html_input = np.array(
                [[[0., 0., 0.], #start
                 [0., 0., 0.],
                 [1., 0., 0.]],
                 [[0., 0., 0.], #start <HTML>Hello World!</HTML>
                 [1., 0., 0.],
                 [0., 1., 0.]]])

    #Turn next word into one-hot encoding
    next_words = np.array(
                [[0., 1., 0.], # <HTML>Hello World!</HTML>
                 [0., 0., 1.]]) # end

    # Load the VGG16 model trained on imagenet and output the classification feature
    VGG = VGG16(weights='imagenet', include_top=True)
    # Extract the features from the image
    features = VGG.predict(images)

    #Load the feature to the network, apply a dense layer, and repeat the vector
    vgg_feature = Input(shape=(1000,))
    vgg_feature_dense = Dense(5)(vgg_feature)
    vgg_feature_repeat = RepeatVector(max_caption_len)(vgg_feature_dense)
    # Extract information from the input seqence 
    language_input = Input(shape=(vocab_size, vocab_size))
    language_model = LSTM(5, return_sequences=True)(language_input)

    # Concatenate the information from the image and the input
    decoder = concatenate([vgg_feature_repeat, language_model])
    # Extract information from the concatenated output
    decoder = LSTM(5, return_sequences=False)(decoder)
    # Predict which word comes next
    decoder_output = Dense(vocab_size, activation='softmax')(decoder)
    # Compile and run the neural network
    model = Model(inputs=[vgg_feature, language_input], outputs=decoder_output)
    model.compile(loss='categorical_crossentropy', optimizer='rmsprop')

    # Train the neural network
    model.fit([features, html_input], next_words, batch_size=2, shuffle=False, epochs=1000)
```

In the hello world version we use three tokens: “start”, “Hello World!” and “end”. A token can be anything. It can be a character, word or sentence. Character versions require a smaller vocabulary but constrain the neural network. Word level tokens tend to perform best.

Here we make the prediction:

```
    # Create an empty sentence and insert the start token
    sentence = np.zeros((1, 3, 3)) # [[0,0,0], [0,0,0], [0,0,0]]
    start_token = [1., 0., 0.] # start
    sentence[0][2] = start_token # place start in empty sentence

    # Making the first prediction with the start token
    second_word = model.predict([np.array([features[1]]), sentence])

    # Put the second word in the sentence and make the final prediction
    sentence[0][1] = start_token
    sentence[0][2] = np.round(second_word)
    third_word = model.predict([np.array([features[1]]), sentence])

    # Place the start token and our two predictions in the sentence 
    sentence[0][0] = start_token
    sentence[0][1] = np.round(second_word)
    sentence[0][2] = np.round(third_word)

    # Transform our one-hot predictions into the final tokens
    vocabulary = ["start", "<HTML><center><H1>Hello World!</H1></center></HTML>", "end"]
    for i in sentence[0]:
        print(vocabulary[np.argmax(i)], end=' ')
```

## Output

* **10 epochs:** `start start start`
* **100 epochs:** `start <HTML><center><H1>Hello World!</H1></center></HTML> <HTML><center><H1>Hello World!</H1></center></HTML>`
* **300 epochs:** `start <HTML><center><H1>Hello World!</H1></center></HTML> end`

### Mistakes I made:

* **Build the first working version before gathering the data.** Early on in this project, I managed to get a copy of an old archive of the Geocities hosting website. It had 38 million websites. Blinded by the potential, I ignored the huge workload that would be required to reduce the 100K-sized vocabulary.
* **Dealing with a terabyte worth of data requires good hardware or a lot of patience.** After having my mac run into several problems I ended up using a powerful remote server. Expect to rent a rig with 8 modern CPU cores and a 1GPS internet connection to have a decent workflow.
* **Nothing made sense until I understood the input and output data.** The input, X, is one screenshot and the previous markup tags. The output, Y, is the next markup tag. When I got this, it became easier to understand everything between them. It also became easier to experiment with different architectures.
* **Be aware of the rabbit holes.** Because this project intersects with a lot of fields in deep learning, I got stuck in plenty of rabbit holes along the way. I spent a week programming RNNs from scratch, got too fascinated by embedding vector spaces, and was seduced by exotic implementations.
* **Picture-to-code networks are image caption models in disguise.** Even when I learned this, I still ignored many of the image caption papers, simply because they were less cool. Once I got some perspective, I accelerated my learning of the problem space.

## Running the code on FloydHub

FloydHub is a training platform for deep learning. I came across them when I first started learning deep learning and I’ve used them since for training and managing my deep learning experiments. You can install it and run your first model within 10 minutes. It’s hands down the best option to run models on cloud GPUs.

If you are new to FloydHub, do their [2-min installation](https://www.floydhub.com/) or [my 5-minute walkthrough.](https://www.youtube.com/watch?v=byLQ9kgjTdQ&t=21s)

Clone the repository

```
git clone https://github.com/emilwallner/Screenshot-to-code-in-Keras.git
```

Login and initiate FloydHub command-line-tool

```
cd Screenshot-to-code-in-Keras
floyd login
floyd init s2c
```

Run a Jupyter notebook on a FloydHub cloud GPU machine:

```
floyd run --gpu --env tensorflow-1.4 --data emilwallner/datasets/imagetocode/2:data --mode jupyter
```

All the notebooks are prepared inside the floydhub directory. The local equivalents are under local. Once it’s running, you can find the first notebook here: floydhub/Hello_world/hello_world.ipynb .

If you want more detailed instructions and an explanation for the flags, check [my earlier post](https://blog.floydhub.com/colorizing-b&w-photos-with-neural-networks/).

## HTML Version

In this version, we’ll automate many of the steps from the Hello World model. This section will focus on creating a scalable implementation and the moving pieces in the neural network.

This version will not be able to predict HTML from random websites, but it’s still a great setup to explore the dynamics of the problem.

![](/html_generation-2476413d4299a3a8b407ee9cdb6774b6.gif)

### Overview

If we expand the components of the previous graphic it looks like this.

![](https://blog.floydhub.com/static/model_more_details-68db3bf26f6df205ffe4c541ace33a92-6c1a3.png) 

There are two major sections. First, the encoder. This is where we create image features and previous markup features. Features are the building blocks that the network creates to connect the design mockups with the markup. At the end of the encoder, we glue the image features to each word in the previous markup.

The decoder then takes the combined design and markup feature and creates a next tag feature. This feature is run through a fully connected neural network to predict the next tag.

##### Design mockup features

Since we need to insert one screenshot for each word, this becomes a bottleneck when training the network ([example](https://docs.google.com/spreadsheets/d/1xXwarcQZAHluorveZsACtXRdmNFbwGtN3WMNhcTdEyQ/edit#gid=0)). Instead of using the images, we extract the information we need to generate the markup.

The information is encoded into image features. This is done by using an already pre-trained convolutional neural network (CNN). The model is pre-trained on Imagenet.

We extract the features from the layer before the final classification.

![](https://blog.floydhub.com/static/ir2_to_image_features-5455a0516284ac036482417b56a57d49-6c1a3.png) 

We end up with 1536 eight by eight pixel images known as features. Although they are hard to understand for us, a neural network can extract the objects and position of the elements from these features.

##### Markup features

In the hello world version we used a one-hot encoding to represent the markup. In this version, we’ll use a word embedding for the input and keep the one-hot encoding for the output.

The way we structure each sentence stays the same, but how we map each token is changed. One-hot encoding treats each word as an isolated unit. Instead, we convert each word in the input data to lists of digits. These represent the relationship between the markup tags.

![](https://blog.floydhub.com/static/embedding-2146c151fd4dbf5dcce6257444931a79-6c1a3.png) 

The dimension of this word embedding is eight but often vary between 50 - 500 depending on the size of the vocabulary.

The eight digits for each word are weights similar to a vanilla neural network. They are tuned to map how the words relate to each other ([Mikolov alt el., 2013](https://arxiv.org/abs/1301.3781)).

This is how we start developing markup features. Features are what the neural network develop to link the input data with the output data. For now, don’t worry about what they are, we’ll dig deeper into this in the next section.

### The Encoder

We’ll take the word embeddings and run them through an LSTM and return a sequence of markup features. These are run through a Time distributed dense layer - think of it as a dense layer with multiple inputs and outputs.

![](https://blog.floydhub.com/static/encoder-78498407f393e83128abed5eec86dd4c-6c1a3.png) 

In parallel, the image features are first flattened. Regardless of how the digits where structured they are transformed into one large list of numbers. Then we apply a dense layer on this layer to form a high-level features. These image features are then concatenated to the markup features.

This can be hard to wrap your mind around - so let’s break it down.

##### Markup features

Here we run the word embeddings through the LSTM layer. In this graphic, all the sentences are padded to reach the maximum size of three tokens.

![](https://blog.floydhub.com/static/word_embedding_markup_feature-d4e76483527fefd10742c0ddc1cd3227-6c1a3.png) 

To mix signals and find higher-level patterns we apply a TimeDistributed dense layer to the markup features. TimeDistributed dense is the same as a dense layer but with multiple inputs and outputs.

##### Image features

In parallel, we prepare the images. We take all the mini image features and transform them into one long list. The information is not changed, just reorganized.

![](https://blog.floydhub.com/static/image_feature_to_image_feature-77a1cf39ed251d4243b90325e60fbdf5-6c1a3.png) 

Again, to mix signals and extract higher level notions, we apply a dense layer. Since we are only dealing with one input value, we can use a normal dense layer. To connect the image features to the markup features, we copy the image features.

In this case, we have three markup features. Thus, we end up with an equal amount of image features and markup features.

##### Concatenating the image and markup features

All the sentences are padded to create three markup features. Since we have prepared the image features, we can now add one image feature for each markup feature.

![](https://blog.floydhub.com/static/concatenate-747c07d8c62a2e026212d20860514188-6c1a3.png) 

After sticking one image feature to each markup feature, we end up with three image-markup features. This is the input we feed into the decoder.

### The Decoder

Here we use the combined image-markup features to predict the next tag.

![](https://blog.floydhub.com/static/decoder-1592aedab9a95e07a513234aa258d777-6c1a3.png) 

In the below example, we use three image-markup feature pairs and output one next tag feature.

Note that the LSTM layer has the sequence set to false. Instead of returning the length of the input sequence it only predicts one feature. In our case, it’s a feature for the next tag. It contains the information for the final prediction.

![](https://blog.floydhub.com/static/image-markup-feature_to_vocab-eb39368b3f466914c9383d532675a622-6c1a3.png) 

##### The final prediction

The dense layer works like a traditional feedforward neural network. It connects the 512 digits in the next tag feature with the 4 final predictions. Say we have 4 words in our vocabulary: start, hello, world, and end.

The vocabulary prediction could be [0.1, 0.1, 0.1, 0.7]. The softmax activation in the dense layer distributes a probability from 0 - 1, with the sum of all predictions equal to 1\. In this case, it predicts that the 4th word is the next tag. Then you translate the one-hot encoding [0, 0, 0, 1] into the mapped value, say “end”.

```
    # Load the images and preprocess them for inception-resnet
    images = []
    all_filenames = listdir('images/')
    all_filenames.sort()
    for filename in all_filenames:
        images.append(img_to_array(load_img('images/'+filename, target_size=(299, 299))))
    images = np.array(images, dtype=float)
    images = preprocess_input(images)

    # Run the images through inception-resnet and extract the features without the classification layer
    IR2 = InceptionResNetV2(weights='imagenet', include_top=False)
    features = IR2.predict(images)

    # We will cap each input sequence to 100 tokens
    max_caption_len = 100
    # Initialize the function that will create our vocabulary 
    tokenizer = Tokenizer(filters='', split=" ", lower=False)

    # Read a document and return a string
    def load_doc(filename):
        file = open(filename, 'r')
        text = file.read()
        file.close()
        return text

    # Load all the HTML files
    X = []
    all_filenames = listdir('html/')
    all_filenames.sort()
    for filename in all_filenames:
        X.append(load_doc('html/'+filename))

    # Create the vocabulary from the html files
    tokenizer.fit_on_texts(X)

    # Add +1 to leave space for empty words
    vocab_size = len(tokenizer.word_index) + 1
    # Translate each word in text file to the matching vocabulary index
    sequences = tokenizer.texts_to_sequences(X)
    # The longest HTML file
    max_length = max(len(s) for s in sequences)

    # Intialize our final input to the model
    X, y, image_data = list(), list(), list()
    for img_no, seq in enumerate(sequences):
        for i in range(1, len(seq)):
            # Add the entire sequence to the input and only keep the next word for the output
            in_seq, out_seq = seq[:i], seq[i]
            # If the sentence is shorter than max_length, fill it up with empty words
            in_seq = pad_sequences([in_seq], maxlen=max_length)[0]
            # Map the output to one-hot encoding
            out_seq = to_categorical([out_seq], num_classes=vocab_size)[0]
            # Add and image corresponding to the HTML file
            image_data.append(features[img_no])
            # Cut the input sentence to 100 tokens, and add it to the input data
            X.append(in_seq[-100:])
            y.append(out_seq)

    X, y, image_data = np.array(X), np.array(y), np.array(image_data)

    # Create the encoder
    image_features = Input(shape=(8, 8, 1536,))
    image_flat = Flatten()(image_features)
    image_flat = Dense(128, activation='relu')(image_flat)
    ir2_out = RepeatVector(max_caption_len)(image_flat)

    language_input = Input(shape=(max_caption_len,))
    language_model = Embedding(vocab_size, 200, input_length=max_caption_len)(language_input)
    language_model = LSTM(256, return_sequences=True)(language_model)
    language_model = LSTM(256, return_sequences=True)(language_model)
    language_model = TimeDistributed(Dense(128, activation='relu'))(language_model)

    # Create the decoder
    decoder = concatenate([ir2_out, language_model])
    decoder = LSTM(512, return_sequences=False)(decoder)
    decoder_output = Dense(vocab_size, activation='softmax')(decoder)

    # Compile the model
    model = Model(inputs=[image_features, language_input], outputs=decoder_output)
    model.compile(loss='categorical_crossentropy', optimizer='rmsprop')

    # Train the neural network
    model.fit([image_data, X], y, batch_size=64, shuffle=False, epochs=2)

    # map an integer to a word
    def word_for_id(integer, tokenizer):
        for word, index in tokenizer.word_index.items():
            if index == integer:
                return word
        return None

    # generate a description for an image
    def generate_desc(model, tokenizer, photo, max_length):
        # seed the generation process
        in_text = 'START'
        # iterate over the whole length of the sequence
        for i in range(900):
            # integer encode input sequence
            sequence = tokenizer.texts_to_sequences([in_text])[0][-100:]
            # pad input
            sequence = pad_sequences([sequence], maxlen=max_length)
            # predict next word
            yhat = model.predict([photo,sequence], verbose=0)
            # convert probability to integer
            yhat = np.argmax(yhat)
            # map integer to word
            word = word_for_id(yhat, tokenizer)
            # stop if we cannot map the word
            if word is None:
                break
            # append as input for generating the next word
            in_text += ' ' + word
            # Print the prediction
            print(' ' + word, end='')
            # stop if we predict the end of the sequence
            if word == 'END':
                break
        return

    # Load and image, preprocess it for IR2, extract features and generate the HTML
    test_image = img_to_array(load_img('images/87.jpg', target_size=(299, 299)))
    test_image = np.array(test_image, dtype=float)
    test_image = preprocess_input(test_image)
    test_features = IR2.predict(np.array([test_image]))
    generate_desc(model, tokenizer, np.array(test_features), 100)
```


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
