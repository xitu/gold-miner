> * 原文地址：[How to Generate Random Text CAPTCHAs Using Python](https://medium.com/better-programming/how-to-generate-random-text-captchas-using-python-e734dd2d7a51)
> * 原文作者：[Siddhant Sadangi](https://medium.com/@siddhant.sadangi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-generate-random-text-captchas-using-python.md](https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-generate-random-text-captchas-using-python.md)
> * 译者：
> * 校对者：

# How to Generate Random Text CAPTCHAs Using Python

![Photo by [Massimo Virgilio](https://unsplash.com/@massimovirgilio?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral).](https://cdn-images-1.medium.com/max/10944/0*QNr379hDEZHrJX3q)

You have surely come across [CAPTCHAs](https://en.wikipedia.org/wiki/CAPTCHA) on websites to validate if you are a human or a robot. What started as a collaboration platform for the [digitization of illegible books](https://www.wikiwand.com/en/ReCAPTCHA#/Origin) has now evolved to a crowd-funded image tagging (and in some cases, audio recognition) project where you don’t even know that you are the service provider — not the customer.

In this article, we will explore how to generate our own very rudimentary text CAPTCHAs using Python’s [OpenCV](https://opencv.org/) and [PIL](https://pillow.readthedocs.io/) libraries.

Let’s get started!

## Creating the Canvas

First, we need to import the `ImageFont`, `ImageDraw`, and `Image` modules from PIL:

```py
from PIL import ImageFont, ImageDraw, Image
```

Now, we have to create a blank image object. For this, we first need to create a three-dimensional (for the three color channels) numpy zeros array:

```py
import numpy as np
img = np.zeros(shape=(25, 60, 3), dtype=np.uint8)
```

This gives us an array where each element represents a pixel of the image, the size of the image being 60x25 pixels:

```Python
array([[[0, 0, 0],
        [0, 0, 0],
        [0, 0, 0],
        ...,
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]]], dtype=uint8)
```

To create an image from this array, we call `Image`’s `fromarray()` method:

![](https://cdn-images-1.medium.com/max/2522/1*BBJv6KGRzyBfy8ITO3nD-A.png)

The image is black because each pixel has a value of `(0, 0, 0)`, which corresponds to the brightness of the red, green, and blue pixels. Brightness has a value between 0 (darkest) and 255 (brightest). To get a white image, just add `255` to the image array:

![](https://cdn-images-1.medium.com/max/2520/1*lt5j7n4jaY5nKecD-cTLxw.png)

Since we need a white background, we’ll use the last canvas.

## Adding Text

Now, we need to draw text over our canvas. For this, we first create a drawing interface using `ImageDraw`'s `Draw()` function on our canvas:

```py
draw = ImageDraw.Draw(img_pil)
```

Then, we can use `Draw`’s `text()` method to write text over the canvas. The `draw` method takes the following arguments:

* `xy`: Starting coordinates for the text as a tuple (`x`, `y`).
* `text`: The text to be drawn.
* `font`: The font to be used. This is a `FreeType` or `OpenType` font used by PIL, and this is where `ImageFont` comes into play.
* `fill`: The fill color for the text, expressed as `(R, G, B)`.

We need to have our font object ready for this. We will use `ImageDraw`'s `truetype()` function:

```py
font = ImageFont.truetype(font = ‘arial’, size=12)
```

We have used the font name, but `truetype` can also take the font path on the system. We’ll get to this later.

Now that we have the font, let us add the text and see what the CAPTCHA looks like:

![](https://cdn-images-1.medium.com/max/2522/1*im3MnJMkuE183-Ny8_0Stg.png)

We can also add lines to the image to confuse any robot trying to break into a human-only system!

![](https://cdn-images-1.medium.com/max/2520/1*PipwRd3C_oF06fTID9qGzA.png)

The tuples indicate the starting and ending pixels of the lines. The first line starts at `(0, 0)` and ends at `(60, 25)`.

A better way to see this is to use OpenCV’s `imshow()` method, which renders an image from an array:

```py
import cv2
cv2.imshow(‘OpenCV’,np.array(img_pil))
cv2.waitKey() #Displays the image till a key is pressed
cv2.destroyAllWindows()
```

![](https://cdn-images-1.medium.com/max/2000/1*peKZgKeIKeRgFEbyY6yatA.png)

## Adding Noise

Our basic CAPTCHA is now ready, but it looks very clean and readable compared to CAPTCHAs you see online. Let’s add some noise!

The easiest way to do this is by randomly adding white and black pixels to the image. This is called salt and pepper noise.

First, we have to create an array from our image:

```py
img = np.array(img_pil)
```

Then, we define a threshold of pixels to be altered. We will keep it at 0.05 (5%). The code to add noise is a simple nested for-loop with a randomly generated number (between 0-1) to determine if noise will be added to the specific pixel:

```Python
import random
thresh = 0.05

for i in range(img.shape[0]):
    for j in range(img.shape[1]):
        rdn = random.random()
        if rdn < thresh:
            img[i][j] = 0
        elif rdn > 1-thresh:
            img[i][j] = 255
```

Here, if the random number is lower than the threshold (0.05), we make it white. If it’s greater than 0.95, we make it black. Otherwise, we let it remain as is. The output after adding noise looks like this:

![Adding salt and pepper noise](https://cdn-images-1.medium.com/max/2000/1*VJ_nzR4t4aghKNSgc2r0dA.png)

The pepper noise (black pixels) is pretty evident, but a few pixels on the text that were black earlier are now white (notice the breaks in the lines).

We can add more noise by blurring the image, which will make the noise a bit more spread out. With cv2, this is just a one-liner!

```py
img_blurred = cv2.blur(img,(2,2))
```

Here, `(2,2)` is the size of the kernel used to smoothen the image. Read more about it in OpenCV’s [documentation](https://opencv-python-tutroals.readthedocs.io/en/latest/py_tutorials/py_imgproc/py_filtering/py_filtering.html#averaging).

![Blurred image](https://cdn-images-1.medium.com/max/2000/1*pYqGijJa9-nMelu28gGboA.png)

## Randomizing Everything!

Our basic code is ready… but the “Random” in the “Random Text CAPTCHAs” is missing. Let us randomize most of the things so that each CAPTCHA is truly unique!

So, what can be randomized? Well, everything, but we will concentrate on the image size, the text (string, font, font size, color), line color, noise threshold, and noise intensity.

The image size will depend on the length of the text and the font size. So we first make a font-size variable and the length of the string:

```py
size = random.randint(10,16)
length = random.randint(4,8)
```

After a lot of experimentation on the relation between the font size, string length, and canvas size, I reached the following for the size of the canvas:

```py
img = np.zeros(((size*2)+5, length*size, 3), np.uint8)
```

Now, to randomize the fonts, we can pick some from the system fonts path using the [glob](https://docs.python.org/2/library/glob.html) library. I am using only variations of the Arial font.

![](https://cdn-images-1.medium.com/max/2524/1*iflloHcYn-69srcyx0nH9g.png)

Then we can choose a random font by using randint:

```py
fonts[random.randint(0, len(fonts)-1)]
```

Now to the text. We generate a random sequence of ASCII alphanumeric characters given the length of the string:

```py
text = ''.join(
        random.choice(string.ascii_uppercase + string.digits + string.ascii_lowercase) 
                   for _ in range(length))
```

Since the length is already random, we just call this function by passing `length`:

![](https://cdn-images-1.medium.com/max/2520/1*Tv1zX8_YECcHlI2MtxosWQ.png)

For the text and line colors, earlier we were using just black (`0, 0, 0`). This can be randomized to (random.randint(0,255), random.randint(0,255), random.randint(0,255)):

```Python
draw.text((5, 10), text, font=font, 
          fill=(random.randint(0,255), random.randint(0,255), random.randint(0,255)))
draw.line([(0, 0),(length*size,(size*2)+5)], width=1, 
          fill=(random.randint(0,255), random.randint(0,255), random.randint(0,255)))
```

For the noise threshold, we can set it to any random value between 1% and 5%:

```py
thresh = random.randint(1,5)/100
```

Finally, for noise intensity, instead of using absolute white and black for salt and pepper pixels, respectively, we can set them to random bright and dark shades:

```Python
for i in range(img.shape[0]):
    for j in range(img.shape[1]):
        rdn = random.random()
        if rdn < thresh:
            img[i][j] = random.randint(0,123) #dark pixels
        elif rdn > 1-thresh:
            img[i][j] = random.randint(123,255) #bright pixels
```

## Putting It All Together

```Python
# Setting up the canvas
size = random.randint(10,16)
length = random.randint(4,8)
img = np.zeros(((size*2)+5, length*size, 3), np.uint8)
img_pil = Image.fromarray(img+255)

# Drawing text and lines
font = ImageFont.truetype(fonts[random.randint(0, len(fonts)-1)], size)
draw = ImageDraw.Draw(img_pil)
text = ''.join(random.choice(string.ascii_uppercase + string.digits + string.ascii_lowercase) 
               for _ in range(length))
draw.text((5, 10), text, font=font, 
          fill=(random.randint(0,255), random.randint(0,255), random.randint(0,255)))
draw.line([(0, 0),(length*size,(size*2)+5)], width=1, 
          fill=(random.randint(0,255), random.randint(0,255), random.randint(0,255)))

# Adding noise and blur
img = np.array(img_pil)
thresh = random.randint(1,5)/100
for i in range(img.shape[0]):
    for j in range(img.shape[1]):
        rdn = random.random()
        if rdn < thresh:
            img[i][j] = random.randint(0,123)
        elif rdn > 1-thresh:
            img[i][j] = random.randint(123,255)
img = cv2.blur(img,(int(size/5),int(size/5)))

#Displaying image
cv2.imshow(f"{text}", img)
cv2.waitKey()
cv2.destroyAllWindows()
```

![cZRaOxb](https://cdn-images-1.medium.com/max/2000/1*2uG3N9uCArPw-QHrgwvn_Q.png)

## Applications?

This can be used to generate CAPTCHAs. You can save the images with the text as the filename to be matched. Another novel application can be to generate a large number of labeled images to train your OCR models. Put the code above in a loop, and you’ll get as many images as you want!

Let me know if you can think of any more applications.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
