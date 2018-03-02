> * 原文地址：[Turning Design Mockups Into Code With Deep Learning - Part 2](https://blog.floydhub.com/turning-design-mockups-into-code-with-deep-learning/)
> * 原文作者：[Emil Wallner](https://twitter.com/EmilWallner)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/turning-design-mockups-into-code-with-deep-learning-2.md](https://github.com/xitu/gold-miner/blob/master/TODO/turning-design-mockups-into-code-with-deep-learning-2.md)
> * 译者：
> * 校对者：

# Turning Design Mockups Into Code With Deep Learning - Part 2

- [Turning Design Mockups Into Code With Deep Learning - Part 1](https://github.com/xitu/gold-miner/blob/master/TODO/turning-design-mockups-into-code-with-deep-learning-1.md)
- [Turning Design Mockups Into Code With Deep Learning - Part 2](https://github.com/xitu/gold-miner/blob/master/TODO/turning-design-mockups-into-code-with-deep-learning-2.md)

### Output

![](https://blog.floydhub.com/static/html_output-ba7571455ed0209f2d98b2cd1f94b9df-6c1a3.png) 

#### Links to generated websites

* [250 epochs](https://emilwallner.github.io/html/250_epochs/)
* [350 epochs](https://emilwallner.github.io/html/350_epochs/)
* [450 epochs](https://emilwallner.github.io/html/450_epochs/)
* [550 epochs](https://emilwallner.github.io/html/550_epochs/)

If you can’t see anything when you click these links, you can right click and click on ‘View Page Source’. Here is the [original website](https://emilwallner.github.io/html/Original/) for reference.

### Mistakes I made:

* **LSTMs are a lot heavier for my cognition compared to CNNs**. When I unrolled all the LSTMs they became easier to understand. [Fast.ai’s video on RNNs](http://course.fast.ai/lessons/lesson6.html) was super useful. Also, focus on the input and output features before you try understanding how they work.
* **Building a vocabulary from the ground up is a lot easier than narrowing down a huge vocabulary.** This includes everything from fonts, div sizes, hex colors to variable names and normal words.
* **Most of the libraries are created to parse text documents and not code.** In documents, everything is separated by a space, but in code, you need custom parsing.
* **You can extract features with a model that’s trained on Imagenet.** This might seem counterintuitive since Imagenet has few web images. However, the loss is 30% higher compared to to a pix2code model, which is trained from scratch. I’d be interesting to use a pre-train inception-resnet type of model based on web screenshots.

## Bootstrap version

In our final version, we’ll use a dataset of generated bootstrap websites from the [pix2code paper.](https://arxiv.org/abs/1705.07962) By using Twitter’s [bootstrap](https://getbootstrap.com/), we can combine HTML and CSS and decrease the size of the vocabulary.

We’ll enable it to generate the markup for a screenshot it has not seen before. We’ll also dig into how it builds knowledge about the screenshot and markup.

Instead of training it on the bootstrap markup, we’ll use 17 simplified tokens that we then translate into HTML and CSS. [The dataset](https://github.com/tonybeltramelli/pix2code/tree/master/datasets) includes 1500 test screenshots and 250 validation images. For each screenshot there are on average 65 tokens, resulting in 96925 training examples.

By tweaking the model in the pix2code paper, the model can predict the web components with 97% accuracy (BLEU 4-ngram greedy search, more on this later).

![](/bootstrap_overview-99e7deb3c036ab6d5def0ab33f2e4d69.gif)

#### An end-to-end approach

Extracting features from pre-trained models works well in image captioning models. But after a few experiments, I realized that pix2code’s end-to-end approach works better for this problem. The pre-trained models have not been trained on web data and are customized for classification.

In this model, we replace the pre-trained image features with a light convolutional neural network. Instead of using max-pooling to increase information density, we increase the strides. This maintains the position and the color of the front-end elements.

![](https://blog.floydhub.com/static/model_more_detail_alone-bfbf97a5ec65ff255f35a8e3cd2069e0-6c1a3.png) 

There are two core models that enable this: convolutional neural networks (CNN) and recurrent neural networks (RNN). The most common recurrent neural network is long-short term memory (LSTM), so that’s what I’ll refer to.

There are plenty of great CNN tutorials and I covered them in [my previous article](https://blog.floydhub.com/colorizing-b&w-photos-with-neural-networks/). Here, I’ll focus on the LSTMs.

#### Understanding timesteps in LSTMs

One of the harder things to grasp about LSTMs is timesteps. A vanilla neural network can be thought of as two timesteps. If you give it “Hello”, it predicts “World”. But it would struggle to predict more timesteps. In the below example, the input has four timesteps, one for each word.

LSTMs are made for input with timesteps. It’s a neural network customized for information in order. If you unroll our model it looks like this. For each downward step, you keep the same weights. You apply one set of weights to the previous output and another set to the new input.

![](https://blog.floydhub.com/static/lstm_timesteps-51b6eece9c5e6abe2cc16b0dcac6eb53-6c1a3.png) 

The weighted input and output are concatenated and added together with an activation. This is the output for that timestep. Since we reuse the weights, they draw information from several inputs and build knowledge of the sequence.

Here is a simplified version of the process for each timestep in an LSTM.

![](https://blog.floydhub.com/static/rnn_example-385ca1843bf3d88e93eec3294fcbb13c-6c1a3.png) 

To get a feel for this logic, I’d recommend building an RNN from scratch with Andrew Trask’s [brilliant tutorial](https://iamtrask.github.io/2015/11/15/anyone-can-code-lstm/).

#### Understanding the units in LSTM layers

The amount of units in each LSTM layer determines it’s ability to memorize. This also corresponds to the size of each output feature. Again, a feature is a long list of numbers used to transfer information between layers.

Each unit in the LSTM layer learns to keep track of different aspects of the syntax. Below is a visualization of a unit that keeps tracks of the information in the row div. This is the simplified markup we are using to train the bootstrap model.

![](https://blog.floydhub.com/static/lstm_cell_activation-1a1842b595ea638407a7389e26aa699b-6c1a3.png) 

Each LSTM unit maintains a cell state. Think of the cell state as the memory. The weights and activations are used to modify the state in different ways. This enables the LSTM layers to fine tune which information to keep and discard for each input.

In addition to passing through an output feature for each input it also forwards the cell states, one value for each unit in the LSTM. To get a feel for how the components within the LSTM interacts, I recommend [Colah’s tutorial](https://colah.github.io/posts/2015-08-Understanding-LSTMs/), Jayasiri’s [Numpy implementation](http://blog.varunajayasiri.com/numpy_lstm.html), and [Karphay’s lecture](https://www.youtube.com/watch?v=yCC09vCHzF8) and [write-up.](https://karpathy.github.io/2015/05/21/rnn-effectiveness/)

```
    dir_name = 'resources/eval_light/'

    # Read a file and return a string
    def load_doc(filename):
        file = open(filename, 'r')
        text = file.read()
        file.close()
        return text

    def load_data(data_dir):
        text = []
        images = []
        # Load all the files and order them
        all_filenames = listdir(data_dir)
        all_filenames.sort()
        for filename in (all_filenames):
            if filename[-3:] == "npz":
                # Load the images already prepared in arrays
                image = np.load(data_dir+filename)
                images.append(image['features'])
            else:
                # Load the boostrap tokens and rap them in a start and end tag
                syntax = '<START> ' + load_doc(data_dir+filename) + ' <END>'
                # Seperate all the words with a single space
                syntax = ' '.join(syntax.split())
                # Add a space after each comma
                syntax = syntax.replace(',', ' ,')
                text.append(syntax)
        images = np.array(images, dtype=float)
        return images, text

    train_features, texts = load_data(dir_name)

    # Initialize the function to create the vocabulary 
    tokenizer = Tokenizer(filters='', split=" ", lower=False)
    # Create the vocabulary 
    tokenizer.fit_on_texts([load_doc('bootstrap.vocab')])

    # Add one spot for the empty word in the vocabulary 
    vocab_size = len(tokenizer.word_index) + 1
    # Map the input sentences into the vocabulary indexes
    train_sequences = tokenizer.texts_to_sequences(texts)
    # The longest set of boostrap tokens
    max_sequence = max(len(s) for s in train_sequences)
    # Specify how many tokens to have in each input sentence
    max_length = 48

    def preprocess_data(sequences, features):
        X, y, image_data = list(), list(), list()
        for img_no, seq in enumerate(sequences):
            for i in range(1, len(seq)):
                # Add the sentence until the current count(i) and add the current count to the output
                in_seq, out_seq = seq[:i], seq[i]
                # Pad all the input token sentences to max_sequence
                in_seq = pad_sequences([in_seq], maxlen=max_sequence)[0]
                # Turn the output into one-hot encoding
                out_seq = to_categorical([out_seq], num_classes=vocab_size)[0]
                # Add the corresponding image to the boostrap token file
                image_data.append(features[img_no])
                # Cap the input sentence to 48 tokens and add it
                X.append(in_seq[-48:])
                y.append(out_seq)
        return np.array(X), np.array(y), np.array(image_data)

    X, y, image_data = preprocess_data(train_sequences, train_features)

    #Create the encoder
    image_model = Sequential()
    image_model.add(Conv2D(16, (3, 3), padding='valid', activation='relu', input_shape=(256, 256, 3,)))
    image_model.add(Conv2D(16, (3,3), activation='relu', padding='same', strides=2))
    image_model.add(Conv2D(32, (3,3), activation='relu', padding='same'))
    image_model.add(Conv2D(32, (3,3), activation='relu', padding='same', strides=2))
    image_model.add(Conv2D(64, (3,3), activation='relu', padding='same'))
    image_model.add(Conv2D(64, (3,3), activation='relu', padding='same', strides=2))
    image_model.add(Conv2D(128, (3,3), activation='relu', padding='same'))

    image_model.add(Flatten())
    image_model.add(Dense(1024, activation='relu'))
    image_model.add(Dropout(0.3))
    image_model.add(Dense(1024, activation='relu'))
    image_model.add(Dropout(0.3))

    image_model.add(RepeatVector(max_length))

    visual_input = Input(shape=(256, 256, 3,))
    encoded_image = image_model(visual_input)

    language_input = Input(shape=(max_length,))
    language_model = Embedding(vocab_size, 50, input_length=max_length, mask_zero=True)(language_input)
    language_model = LSTM(128, return_sequences=True)(language_model)
    language_model = LSTM(128, return_sequences=True)(language_model)

    #Create the decoder
    decoder = concatenate([encoded_image, language_model])
    decoder = LSTM(512, return_sequences=True)(decoder)
    decoder = LSTM(512, return_sequences=False)(decoder)
    decoder = Dense(vocab_size, activation='softmax')(decoder)

    # Compile the model
    model = Model(inputs=[visual_input, language_input], outputs=decoder)
    optimizer = RMSprop(lr=0.0001, clipvalue=1.0)
    model.compile(loss='categorical_crossentropy', optimizer=optimizer)

    #Save the model for every 2nd epoch
    filepath="org-weights-epoch-{epoch:04d}--val_loss-{val_loss:.4f}--loss-{loss:.4f}.hdf5"
    checkpoint = ModelCheckpoint(filepath, monitor='val_loss', verbose=1, save_weights_only=True, period=2)
    callbacks_list = [checkpoint]

    # Train the model
    model.fit([image_data, X], y, batch_size=64, shuffle=False, validation_split=0.1, callbacks=callbacks_list, verbose=1, epochs=50)
```

### Test accuracy

It’s tricky to find a fair way to measure the accuracy. Say you compare word by word. If your prediction is one word out of sync, you might have 0% accuracy. If you remove one word which syncs the prediction, you might end up with 99/100.

I used the BLEU score, best practice in machine translating and image captioning models. It breaks the sentence into four n-grams, from 1-4 word sequences. In the below prediction “cat” is supposed to be “code”.

![](https://blog.floydhub.com/static/bleu_score-741cd6ede6d32df1de54a6d8dd41c530-6c1a3.png) 

To get the final score you multiply each score with 25%, (4/5) * 0.25 + (2/4) * 0.25 + (1/3) * 0.25 + (0/2) * 0.25 = 0.2 + 0.125 + 0.083 + 0 = 0.408 . The sum is then multiplied with a sentence length penalty. Since the length is correct in our example, it becomes our final score.

You could increase the number of n-grams to make it harder. A four n-gram model is the model that best corresponds to human translations. I’d recommend running a few examples with the below code and reading the [wiki page.](https://en.wikipedia.org/wiki/BLEU)

```
    #Create a function to read a file and return its content
    def load_doc(filename):
        file = open(filename, 'r')
        text = file.read()
        file.close()
        return text

    def load_data(data_dir):
        text = []
        images = []
        files_in_folder = os.listdir(data_dir)
        files_in_folder.sort()
        for filename in tqdm(files_in_folder):
            #Add an image
            if filename[-3:] == "npz":
                image = np.load(data_dir+filename)
                images.append(image['features'])
            else:
            # Add text and wrap it in a start and end tag
                syntax = '<START> ' + load_doc(data_dir+filename) + ' <END>'
                #Seperate each word with a space
                syntax = ' '.join(syntax.split())
                #Add a space between each comma
                syntax = syntax.replace(',', ' ,')
                text.append(syntax)
        images = np.array(images, dtype=float)
        return images, text

    #Intialize the function to create the vocabulary
    tokenizer = Tokenizer(filters='', split=" ", lower=False)
    #Create the vocabulary in a specific order
    tokenizer.fit_on_texts([load_doc('bootstrap.vocab')])

    dir_name = '../../../../eval/'
    train_features, texts = load_data(dir_name)

    #load model and weights 
    json_file = open('../../../../model.json', 'r')
    loaded_model_json = json_file.read()
    json_file.close()
    loaded_model = model_from_json(loaded_model_json)
    # load weights into new model
    loaded_model.load_weights("../../../../weights.hdf5")
    print("Loaded model from disk")

    # map an integer to a word
    def word_for_id(integer, tokenizer):
        for word, index in tokenizer.word_index.items():
            if index == integer:
                return word
        return None
    print(word_for_id(17, tokenizer))

    # generate a description for an image
    def generate_desc(model, tokenizer, photo, max_length):
        photo = np.array([photo])
        # seed the generation process
        in_text = '<START> '
        # iterate over the whole length of the sequence
        print('\nPrediction---->\n\n<START> ', end='')
        for i in range(150):
            # integer encode input sequence
            sequence = tokenizer.texts_to_sequences([in_text])[0]
            # pad input
            sequence = pad_sequences([sequence], maxlen=max_length)
            # predict next word
            yhat = loaded_model.predict([photo, sequence], verbose=0)
            # convert probability to integer
            yhat = argmax(yhat)
            # map integer to word
            word = word_for_id(yhat, tokenizer)
            # stop if we cannot map the word
            if word is None:
                break
            # append as input for generating the next word
            in_text += word + ' '
            # stop if we predict the end of the sequence
            print(word + ' ', end='')
            if word == '<END>':
                break
        return in_text

    max_length = 48 

    # evaluate the skill of the model
    def evaluate_model(model, descriptions, photos, tokenizer, max_length):
        actual, predicted = list(), list()
        # step over the whole set
        for i in range(len(texts)):
            yhat = generate_desc(model, tokenizer, photos[i], max_length)
            # store actual and predicted
            print('\n\nReal---->\n\n' + texts[i])
            actual.append([texts[i].split()])
            predicted.append(yhat.split())
        # calculate BLEU score
        bleu = corpus_bleu(actual, predicted)
        return bleu, actual, predicted

    bleu, actual, predicted = evaluate_model(loaded_model, texts, train_features, tokenizer, max_length)

    #Compile the tokens into HTML and css
    dsl_path = "compiler/assets/web-dsl-mapping.json"
    compiler = Compiler(dsl_path)
    compiled_website = compiler.compile(predicted[0], 'index.html')

    print(compiled_website )
    print(bleu)
```

### Output

![](https://blog.floydhub.com/static/bootstrap_output-8a1b036ddc436e20453b7c2962b0fa85-6c1a3.png) 

##### Links to sample output

* [Generated website 1](https://emilwallner.github.io/bootstrap/pred_1/) - [Original 1](https://emilwallner.github.io/bootstrap/real_1/)
* [Generated website 2](https://emilwallner.github.io/bootstrap/pred_2/) - [Original 2](https://emilwallner.github.io/bootstrap/real_2/)
* [Generated website 3](https://emilwallner.github.io/bootstrap/pred_3/) - [Original 3](https://emilwallner.github.io/bootstrap/real_3/)
* [Generated website 4](https://emilwallner.github.io/bootstrap/pred_4/) - [Original 4](https://emilwallner.github.io/bootstrap/real_4/)
* [Generated website 5](https://emilwallner.github.io/bootstrap/pred_5/) - [Original 5](https://emilwallner.github.io/bootstrap/real_5/)

### Mistakes I made:

* **Understand the weakness of the models instead of testing random models.** First I applied random things such as batch normalization, bidirectional networks and tried implementing attention. After looking at the test data and seeing that it could not predict color and position with high accuracy I realized there was a weakness in the CNN. This lead me to replace maxpooling with increased strides. The validation loss went from 0.12 to 0.02 and increased the BLEU score from 85% to 97%.
* **Only use pre-trained models if they are relevant.** Given the small dataset I thought that a pre-trained image model would improve the performance. From my experiments, and end-to-end model is slower to train and requires more memory, but is 30% more accurate.
* **Plan for slight variance when you run your model on a remote server.** On my mac, it read the files in alphabetic order. However, on the server, it was randomly located. This created a mismatch between the screenshots and the code. It still converged, but was the validation data was 50% worse than when I fixed it.
* **Make sure you understand library functions.** Include space for the empty token in your vocabulary. When I didn’t add it, it did not include one of the tokens. I only noticed it after looking at the final output several times and noticing that it never predicted a “single” token. After a quick check, I realized it wasn’t even in the vocabulary. Also, use the same order in the vocabulary for training and testing.
* **Use lighter models when experimenting.** Using GRUs instead of LSTMs reduced each epoch cycle by 30%, and did not have a large effect on the performance.

## Next steps

Front-end development is an ideal space to apply deep learning. It’s easy to generate data and the current deep learning algorithms can map most of the logic.

One of the most exciting areas is [applying attention to LSTMs](https://arxiv.org/pdf/1502.03044.pdf). This will not just improve the accuracy, but enable us to visualize where the CNN puts its focus as it generates the markup.

Attention is also key for communicating between markup, stylesheets, scripts and eventually the backend. Attention layers can keep track of variables, enabling the network to communicate between programming languages.

But in the near feature, the biggest impact will come from building a scalable way to synthesize data. Then you can add fonts, colors, words, and animations step-by-step.

So far, most progress is happening in taking sketches and turning them into template apps. In less then two years, we’ll be able to draw an app on paper and have the corresponding front-end in less than a second. There are already two working prototypes built by [Airbnb’s design team](https://airbnb.design/sketching-interfaces/) and [Uizard](https://www.uizard.io/).

Here are some experiments to get started.

## Experiments

##### Getting started

* Run all the models
* Try different hyper parameters
* Test a different CNN architecture
* Add Bidirectional LSTM models
* Implement the model with a [different dataset](http://lstm.seas.harvard.edu/latex/). (You can easily mount this dataset in your FloydHub jobs with this flag `--data emilwallner/datasets/100k-html:data`)

##### Further experiments

* Creating a solid random app/web generator with the corresponding syntax.
* Data for a sketch to app model. Auto-convert the app/web screenshots into sketches and use a GAN to create variety.
* Apply an attention layer to visualize the focus on the image for each prediction, [similar to this model](https://arxiv.org/abs/1502.03044).
* Create a framework for a modular approach. Say, having encoder models for fonts, one for color, another for layout and combine them with one decoder. A good start could be solid image features.
* Feed the network simple HTML components and teach it to generate animations using CSS. It would be fascinating to have an attention approach and visualize the focus on both input sources.

**Huge thanks to** Tony Beltramelli and Jon Gold for answering questions, their research, and all their ideas. Thanks to Jason Brownlee for his stellar Keras tutorials, I included a few snippets from his tutorial in the core Keras implementation, and Beltramelli for providing the data. Also thanks to Qingping Hou, Charlie Harrington, Sai Soundararaj, Jannes Klaas, Claudio Cabral, Alain Demenet and Dylan Djian for reading drafts of this.

* * *

## About Emil Wallner

This the fourth part of a multi-part blog series from Emil as he learns deep learning. Emil has spent a decade exploring human learning. He's worked for Oxford's business school, invested in education startups, and built an education technology business. Last year, he enrolled at [Ecole 42](https://twitter.com/paulg/status/847844863727087616) to apply his knowledge of human learning to machine learning.

You can follow along with Emil on [Twitter](https://twitter.com/EmilWallner) and [Medium](https://medium.com/@emilwallner).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
