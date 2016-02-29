> * 原文链接: [Faster Photos in Facebook for iOS](https://code.facebook.com/posts/857662304298232/faster-photos-in-facebook-for-ios/)
* 原文作者 : [Tomer Bar](https://www.facebook.com/bar)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者: 
* 状态 :  待定

Your Facebook News Feed is filled with photos of your friends, family, and loved ones — photos you may want to view on your phone. We are always looking for ways to make things better and faster for mobile. So, our team took a look at how we can make photos faster on iOS and we found a way to reduce the data used by Facebook for iOS by about 10% and show a good image 15% faster than before. Here's how we did it.

## How photos used to work

Up until now, Facebook for iOS app has loaded your photos in News Feed as follows:

*   Photo URLs were downloaded first, and then are used to download the actual photo data in JPEG format.
*   At least two versions of the image were fetched in parallel, a small one and a full-size one. As soon as we have the smaller one, we show it until the larger, more detailed one is available.
*   Sometimes we download the same photos multiple times in different sizes. The sizes depend on the type of device being used or where in the app it appears (e.g. News Feed or the fullscreen photo viewer).
*   Every image we download is cached to disk. Since we downloaded multiple image sizes for each photo, multiple sizes of the same image were often stored on disk.

## Progressive JPEG

Progressive JPEG (PJPEG) is an image format that stores multiple, individual “scans” of a photo, each with an increasing level of detail. When put together, the scans create a full-quality image. The first scan gives a very low-quality representation of the image, and each following scan further increases the level of detail and quality. When images are downloaded using PJPEG, we can render the image as soon as we have the the first scan. As later scans come through, we update the image and re-render it at higher and higher quality.

Support for PJPEG became popular in browsers in 2010, and we've been serving photos as PJPEGs for a while now. However, mobile apps haven't really caught up yet. For example, there is currently no out-of-the-box support on iOS for rendering images progressively, so we had to build our own for the Facebook app.

## Using PJPEG in Facebook for iOS

Rendering images progressively in the Facebook app has some advantages:

1.  Data consumption: PJPEG allows us to skip downloading smaller versions of an image.
2.  Network connections: Since we don't download smaller versions of an image anymore, we now use only one connection per image instead of many.
3.  Disk storage: Storing fewer photos on disk decreases the amount of disk space used by the app.
4.  One URL: Since we no longer need to download multiple images at different sizes, we can simply use one URL.

There is a downside to PJPEG: Decoding and rendering the image multiple times at varying scan levels uses more CPU. Decoding images can be moved to background threads, but the process is still heavy on CPU. The real challenge for us was to find the right balance between data usage, network latency, and CPU utilization. For instance, we considered using [WebP](http://l.facebook.com/l.php?u=http%3A%2F%2Fen.wikipedia.org%2Fwiki%2FWebP&h=5AQEbNxXm&s=1) since it is more optimal in file size than JPEG in some cases, but the format does not support progressive rendering.

## Waiting for images

The following diagram shows how we used to download photos in Facebook for iOS. Each bar indicates an image download, and “Wait Time” is the period of time between viewing a photo placeholder to viewing a photo that is clear enough to enjoy. Even when the smaller image appeared, many people ended up waiting for the full image:

![](https://fbcdn-dragon-a.akamaihd.net/hphotos-ak-xaf1/t39.2365-6/10540969_770021873088131_38326442_n.jpeg)

Throwing PJPEG into the mix changes the picture:

![](https://fbcdn-dragon-a.akamaihd.net/hphotos-ak-xap1/t39.2365-6/10935998_1623200524568459_2147345899_n.jpeg)

We render three different scans of each photo:

1.  First we render a preview scan: this is pixelated.
2.  Then we render a scan that looks good to the naked eye. In fact, it looks almost perfect to the naked eye.
3.  Finally we render at full-quality: the best resolution possible.

The result is that people see a good photo sooner!

![](https://fbcdn-dragon-a.akamaihd.net/hphotos-ak-xft1/t39.2365-6/10935975_819617794775832_888993011_n.png)

## Finding the right scan level

To determine what “good” means, we tried several different scan-levels and found the levels at which people interacted with photos the most. We also looked at the relative similarity between each of the scans and the final image. Our comparison function takes two images and returns a number between 0 and 1\. A score of 0 means completely different, while 1 means exactly the same. Here are the results:

![](https://fbcdn-dragon-a.akamaihd.net/hphotos-ak-xpf1/t39.2365-6/10956903_771333189588155_1044601403_n.png)

To measure the impact of choosing different scan levels, we ran an [A/B test](https://code.facebook.com/posts/520580318041111/airlock-facebook-s-mobile-a-b-testing-framework/) and then examined the data.

## The Wins

1.  Adopting PJPEG reduced the data used by Facebook for iOS by about 10%.
2.  Using PJPEG, we can show a good image 15% faster than before. This image is barely discernible from the full-quality version.
3.  Adopting PJPEG helps us improve a different metric: “perceived wait-time”. The CPU is doing a little more work by showing earlier scans while the image continues to download, but we reduce how long it *appears* to take for images to download.

At Facebook, we continually work hard to reduce the amount of time you spend waiting, and this is just one of our many efforts. While PJPEG has helped make photos load faster, we know there is always room for improvement.

Many people worked on this effort; credit should go to Linji Yang, Miguel Cohnen, Kun Chen, Kirill Pugin, Edward Kandrot, Marty Greenia, Brian Cabral and Tomer Bar.
