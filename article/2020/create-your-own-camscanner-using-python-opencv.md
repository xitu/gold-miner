> * 原文地址：[Create your own ‘CamScanner’ using Python & OpenCV](https://levelup.gitconnected.com/create-your-own-camscanner-using-python-opencv-66251212270)
> * 原文作者：[Shirish Gupta](https://medium.com/@shirishgupta)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/create-your-own-camscanner-using-python-opencv.md](https://github.com/xitu/gold-miner/blob/master/article/2020/create-your-own-camscanner-using-python-opencv.md)
> * 译者：
> * 校对者：

# Create your own ‘CamScanner’ using Python & OpenCV

![Photo by [Annie Spratt](https://unsplash.com/@anniespratt?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/15904/0*yUJT2q2_mrzBObA8)

Have you ever wondered how a ‘CamScanner’ converts your mobile camera’s fuzzy document picture into a defined, properly lit and scanned image? I have and until recently I thought it was a very difficult task. But it’s not and we can make our own ‘CamScanner’ with relatively few lines of code (compared to what we have in mind). Thanks to Soham Mhatre for contributing significantly towards this article.

## Computer Vision and why the buzz?

Computer vision is an interdisciplinary scientific field that deals with how computers can gain high-level understanding from digital images or videos. From the perspective of engineering, it seeks to understand and automate tasks that the human visual system can do. **Basically**, it’s a scientific field to make the computers understand a photo/video similar to how it will be interpreted by a human being.

#### So why the buzz

Advancement in AI and Machine Learning has accelerated the developments in computer vision. Earlier these were two separate fields and there were different techniques, coding languages & academic researchers in both of them. But now, the gap has reduced significantly and more and more data scientists are working in the field of computer vision and vice-a-versa. The reason is the simple common denominator in both the fields— Data.

At the end of the day, a computer will learn by consuming data. And AI helps the computers to not only process, but also improve it’s **Understanding/Interpretation** by trial-and-error. So now, if we can combine the data from images and run complex machine learning algorithms on it, what we get is an actual AI.

> One modern company who has pioneered the technology of Computer Vision is Tesla Motors

> Tesla Motors is known for pioneering the self-driving vehicle revolution in the world. They are also known for achieving high reliability in autonomous vehicles. Tesla cars depend entirely upon computer vision.

## What are we gonna achieve today?

For this article we will concentrate only on Computer Vision and leave Machine Learning for some later time. Also we will just use just one library **OpenCV** to create the whole thing.

## Index

1. What is OpenCV?
2. Preprocess the image using different concepts such as blurring, thresholding, denoising (Non-Local Means).
3. Canny Edge detection & Extraction of biggest contour
4. Finally — Sharpening & Brightness correction

## What is OpenCV

OpenCV is a library of programming functions mainly aimed at real-time computer vision. Originally developed by Intel, it was later supported by Willow Garage and then Itseez. The library is cross-platform and free for use under the open-source BSD license. It was initially developed in C++ but now it’s available across multiple languages such Python, Java, etc.

## Start with Preprocessing

#### BLURRING

The goal of blurring is to reduce the noise in the image. It removes high frequency content (e.g: noise, edges) from the image — resulting in blurred edges. There are multiple blurring techniques (filters) in OpenCV, and the most common are:

**Averaging** — It simply takes the average of all the pixels under kernel area and replaces the central element with this average

**Gaussian Filter** — Instead of a box filter consisting of equal filter coefficients, a Gaussian kernel is used

**Median Filter** — Computes the median of all the pixels under the kernel window and the central pixel is replaced with this median value

**Bilateral Filter** — Advanced version of Gaussian blurring. Not only does it removes noise, but also smoothens edges.


Original photo:

![](https://cdn-images-1.medium.com/max/2000/1*M-bea60NgKRxn1nO5IuCug.jpeg)

Gaussian Blurred photo:

![](https://cdn-images-1.medium.com/max/2000/1*vWSnV0jCZVoZRvN6jEkzjw.jpeg)

#### THRESHOLDING

In image processing, thresholding is the simplest method of segmenting images. From a grayscale image, thresholding can be used to create binary images. This is generally done so as to clearly differentiate between different shades of pixel intensities. Most common thresholding techniques in OpenCV are:

**Simple Thresholding** — If pixel value is greater than a threshold value, it is assigned one value (may be white), else it is assigned another value (may be black)

**Adaptive Thresholding** — Algorithm calculates the threshold for a small regions of the image. So we get different thresholds for different regions of the same image and it gives us better results for images with varying illumination.

> Note:Remember to convert the images to grayscale before thresholding.

GreyScaled on Original Vs Adaptive Gaussian:

![](https://cdn-images-1.medium.com/max/2800/1*L09YTPI5Azq9pd12n_kVQQ.jpeg)

#### DENOISING

There is another kind of de-noising that we conduct —**Non-Local Means Denoising.** The principle of the initial denoising methods were to replace the colour of a pixel with an average of the colours of nearby pixels. The variance law in probability theory ensures that if nine pixels are averaged, the noise standard deviation of the average is divided by three. Hence giving us a denoised picture.

But what if there is **edge** or **elongated** pattern where denoising by averaging wont work. Therefore, we need to scan a vast portion of the image in search of all the pixels that really resemble the pixel we want to denoise. Denoising is then done by computing the average colour of these most resembling pixels. This is called — **Non-Local Means Denoising.**

Use `cv2.fastNlMeansDenoising` for the same.

Original photo:

![](https://cdn-images-1.medium.com/max/2000/1*M-bea60NgKRxn1nO5IuCug.jpeg)

Gaussian Blurred photo:

![](https://cdn-images-1.medium.com/max/2000/1*vWSnV0jCZVoZRvN6jEkzjw.jpeg)

Non-Local Means Denoised photo:

![](https://cdn-images-1.medium.com/max/2000/1*M6wLOv72dSroNnaByPJscg.jpeg)

## Canny Edge detection & Extraction of biggest contour

After image blurring & thresholding, the next step is to find the biggest contour (biggest bounding box) and crop out the image. This is done by using Canny Edge Detection followed by extraction of biggest contour using four-point transformation.

#### CANNY EDGE

Canny edge detection is a multi-step algorithm that can detect edges. We should send a de-noised image to this algorithm so that it is able to detect relevant edges only.

#### FIND CONTOURS

After finding the edges, pass the image through `cv2.findcontours()`. It joins all the continuous points (along the edges), having same colour or intensity. After this we will get all contours — rectangles, spheres, etc

Use `cv2.convexHull()` and `cv2.approxPolyDP` to find the biggest rectangular contour(approx) in the photo.

Original photo:

![](https://cdn-images-1.medium.com/max/2000/1*f6D514542_eM6LQL75bIhA.jpeg)

Original with biggest bounding box photo:

![](https://cdn-images-1.medium.com/max/2000/1*QSsfzQ-XD0mebbaRs5Bsow.jpeg)

#### EXTRACTING THE BIGGEST CONTOUR

Although we have found the biggest contour which looks like a rectangle, we still need to find the **corners** so as to find the exact co-ordinates to crop the image.

For this first you pass the co-ordinates of the approx rectangle(biggest contour) and apply an **order points** transformation on the same. The resultant is an exact (x,y) coordinates of the biggest contour.

**Four Point Transformation** — Using the above (x,y) coordinates, calculate the width and height of the contour. Pass it through the `cv2.warpPerspective()`to crop the contour. Voila — you have the successfully cropped out the **relevant** data from the input image

Original photo:

![](https://cdn-images-1.medium.com/max/2000/1*f6D514542_eM6LQL75bIhA.jpeg)

Cropped Image:

![](https://cdn-images-1.medium.com/max/2000/1*ypj-VH1ZaG5ABclgJHF-JA.jpeg)

> Notice — How well the image is cropped out even though its a poorly lit and clicked image

## Finally — Sharpening & Brightness correction

Now that we have cropped out the relevant info (biggest contour) from the image, the last step is to sharpen the picture so that we get well illuminated and readable document.

— For this we use **hue, saturation, value (h,s,v)** concept where **value** represents the **brightness**. Can play around with this value to increase the brightness of the documents

— **Kernel Sharpening** - A **kernel**, **convolution matrix**, or **mask** is a small matrix. It is used for blurring, sharpening, embossing, edge detection, and more. This is accomplished by doing a convolution between a kernel and an image.

#### Resultant

Original photo:

![](https://cdn-images-1.medium.com/max/2000/1*f6D514542_eM6LQL75bIhA.jpeg)

Final Resultant (Cropped, Brightened & Sharpened) example:

![](https://cdn-images-1.medium.com/max/2000/1*_LcK7kSdZUQ_YCRvtu58CQ.jpeg)

## Complete Code

Here is the final code

```Python

import numpy as np
import cv2
import re
from matplotlib import pyplot as plt


path = "/Users/shirishgupta/Desktop/ComputerVision/"
image = cv2.imread("/Users/shirishgupta/Desktop/ComputerVision/sample_image2.jpeg")


# ## **Use Gaussian Blurring combined with Adaptive Threshold** 

def blur_and_threshold(gray):
    gray = cv2.GaussianBlur(gray,(3,3),2)
    threshold = cv2.adaptiveThreshold(gray,255,cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY,11,2)
    threshold = cv2.fastNlMeansDenoising(threshold, 11, 31, 9)
    return threshold


# ## **Find the Biggest Contour** 

# **Note: We made sure the minimum contour is bigger than 1/10 size of the whole picture. This helps in removing very small contours (noise) from our dataset**


def biggest_contour(contours,min_area):
    biggest = None
    max_area = 0
    biggest_n=0
    approx_contour=None
    for n,i in enumerate(contours):
            area = cv2.contourArea(i)
         
            
            if area > min_area/10:
                    peri = cv2.arcLength(i,True)
                    approx = cv2.approxPolyDP(i,0.02*peri,True)
                    if area > max_area and len(approx)==4:
                            biggest = approx
                            max_area = area
                            biggest_n=n
                            approx_contour=approx
                            
                                                   
    return biggest_n,approx_contour


def order_points(pts):
    # initialzie a list of coordinates that will be ordered
    # such that the first entry in the list is the top-left,
    # the second entry is the top-right, the third is the
    # bottom-right, and the fourth is the bottom-left
    pts=pts.reshape(4,2)
    rect = np.zeros((4, 2), dtype = "float32")

    # the top-left point will have the smallest sum, whereas
    # the bottom-right point will have the largest sum
    s = pts.sum(axis = 1)
    rect[0] = pts[np.argmin(s)]
    rect[2] = pts[np.argmax(s)]

    # now, compute the difference between the points, the
    # top-right point will have the smallest difference,
    # whereas the bottom-left will have the largest difference
    diff = np.diff(pts, axis = 1)
    rect[1] = pts[np.argmin(diff)]
    rect[3] = pts[np.argmax(diff)]

    # return the ordered coordinates
    return rect


# ## Find the exact (x,y) coordinates of the biggest contour and crop it out


def four_point_transform(image, pts):
    # obtain a consistent order of the points and unpack them
    # individually
    rect = order_points(pts)
    (tl, tr, br, bl) = rect

    # compute the width of the new image, which will be the
    # maximum distance between bottom-right and bottom-left
    # x-coordiates or the top-right and top-left x-coordinates
    widthA = np.sqrt(((br[0] - bl[0]) ** 2) + ((br[1] - bl[1]) ** 2))
    widthB = np.sqrt(((tr[0] - tl[0]) ** 2) + ((tr[1] - tl[1]) ** 2))
    maxWidth = max(int(widthA), int(widthB))
   

    # compute the height of the new image, which will be the
    # maximum distance between the top-right and bottom-right
    # y-coordinates or the top-left and bottom-left y-coordinates
    heightA = np.sqrt(((tr[0] - br[0]) ** 2) + ((tr[1] - br[1]) ** 2))
    heightB = np.sqrt(((tl[0] - bl[0]) ** 2) + ((tl[1] - bl[1]) ** 2))
    maxHeight = max(int(heightA), int(heightB))

    # now that we have the dimensions of the new image, construct
    # the set of destination points to obtain a "birds eye view",
    # (i.e. top-down view) of the image, again specifying points
    # in the top-left, top-right, bottom-right, and bottom-left
    # order
    dst = np.array([
        [0, 0],
        [maxWidth - 1, 0],
        [maxWidth - 1, maxHeight - 1],
        [0, maxHeight - 1]], dtype = "float32")

    # compute the perspective transform matrix and then apply it
    M = cv2.getPerspectiveTransform(rect, dst)
    warped = cv2.warpPerspective(image, M, (maxWidth, maxHeight))

    # return the warped image
    return warped


# # Transformation the image

# **1. Convert the image to grayscale**

# **2. Remove noise and smoothen out the image by applying blurring and thresholding techniques**

# **3. Use Canny Edge Detection to find the edges**

# **4. Find the biggest contour and crop it out**


def transformation(image):
  image=image.copy()  
  height, width, channels = image.shape
  gray=cv2.cvtColor(image,cv2.COLOR_BGR2GRAY)
  image_size=gray.size
  
  threshold=blur_and_threshold(gray)
  # We need two threshold values, minVal and maxVal. Any edges with intensity gradient more than maxVal 
  # are sure to be edges and those below minVal are sure to be non-edges, so discarded. 
  #  Those who lie between these two thresholds are classified edges or non-edges based on their connectivity.
  # If they are connected to "sure-edge" pixels, they are considered to be part of edges. 
  #  Otherwise, they are also discarded
  edges = cv2.Canny(threshold,50,150,apertureSize = 7)
  contours, hierarchy = cv2.findContours(edges, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
  simplified_contours = []


  for cnt in contours:
      hull = cv2.convexHull(cnt)
      simplified_contours.append(cv2.approxPolyDP(hull,
                                0.001*cv2.arcLength(hull,True),True))
  simplified_contours = np.array(simplified_contours)
  biggest_n,approx_contour = biggest_contour(simplified_contours,image_size)

  threshold = cv2.drawContours(image, simplified_contours ,biggest_n, (0,255,0), 1)

  dst = 0
  if approx_contour is not None and len(approx_contour)==4:
      approx_contour=np.float32(approx_contour)
      dst=four_point_transform(threshold,approx_contour)
  croppedImage = dst
  return croppedImage


# **Increase the brightness of the image by playing with the "V" value (from HSV)**

def increase_brightness(img, value=30):
    hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
    h, s, v = cv2.split(hsv)
    lim = 255 - value
    v[v > lim] = 255
    v[v <= lim] += value
    final_hsv = cv2.merge((h, s, v))
    img = cv2.cvtColor(final_hsv, cv2.COLOR_HSV2BGR)
    return img  


# **Sharpen the image using Kernel Sharpening Technique**


def final_image(rotated):
  # Create our shapening kernel, it must equal to one eventually
  kernel_sharpening = np.array([[0,-1,0], 
                                [-1, 5,-1],
                                [0,-1,0]])
  # applying the sharpening kernel to the input image & displaying it.
  sharpened = cv2.filter2D(rotated, -1, kernel_sharpening)
  sharpened=increase_brightness(sharpened,30)  
  return sharpened


# ## 1. Pass the image through the transformation function to crop out the biggest contour

# ## 2. Brighten & Sharpen the image to get a final cleaned image

blurred_threshold = transformation(image)
cleaned_image = final_image(blurred_threshold)
cv2.imwrite(path + "Final_Image2.jpg", cleaned_image)
```

---

The end for now. Have any ideas to improve this or want me to try any new ideas? Please give your suggestions in the comments. Adios.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
