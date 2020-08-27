> * 原文地址：[Why Color Is Key for Data Visualization and How to Use It](https://towardsdatascience.com/why-color-is-key-for-data-visualization-and-how-to-use-it-b24627116b71)
> * 原文作者：[Aseem Kashyap](https://medium.com/@aseem.kash)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/why-color-is-key-for-data-visualization-and-how-to-use-it.md](https://github.com/xitu/gold-miner/blob/master/article/2020/why-color-is-key-for-data-visualization-and-how-to-use-it.md)
> * 译者：
> * 校对者：

# Why Color Is Key for Data Visualization and How to Use It - Data Analysis & Applied Color Theory

![image](https://user-images.githubusercontent.com/5164225/91420085-bea57e80-e886-11ea-9bd5-f291b8da6711.png)

#### An illustrated guide to optimal color utilization

**The objective of data visualization is to communicate hidden patterns uncovered during analysis. And while a visualization must look aesthetically appealing, its primary objective is not to ‘look pretty’.**

---

> Use of color in visualisation should be to help disseminate key findings and not to chase some artistic endeavor

#### More is not better when it comes to color

Use of color must be carefully strategized to communicate key findings and this decision, therefore, cannot be left for automated algorithms to make. **Most data should be in neutral colors like grey with bright colors reserved for directing attention to significant or atypical data points.**

![](https://cdn-images-1.medium.com/max/2000/1*k67hW4R2Pb6NWdFgXJ5wFg.png)

Fig: Sales in million USD from 1991–1996. Red colour is used to draw attention to unusually low sales in 1995. Nearly uniform sales in other years are all rendered in grey. \[made by author\]

#### Colour can help to group related data points

Color can be used to group data points of similar value and to render the extent of this similarity using the following two color palettes :

![[made by author]](https://cdn-images-1.medium.com/max/2000/1*dhyh0FhGdRKBtQYuNXYFig.png)

A **sequential color palettes** is composed of varying intensities of a single hue of color at uniform saturation. Variability in luminance of adjacent colors corresponds to the variation in data values that they are used to render.

![[made by author]](https://cdn-images-1.medium.com/max/2000/1*Rps6Rqc2LbFZyhW1YIyHLw.png)

A **divergent color palettes** is made of two sequential color palettes (each of a different hue) stacked next to each other with an inflection point in the middle. These become helpful when visualizing data with variations in two different directions.

The chart below on the left uses a sequential color palette made of a single hue **(green)** for values ranging from -0.25 to +0.25 while chart on the right uses a divergent color scheme with different hues for positive **(blue)** and negative **(red)** values.

![](https://cdn-images-1.medium.com/max/2620/1*ypk58BjbbjxuB0VUslVyKw.png)

Fig: Percentage change in population in the USA from 2010–2019. The divergent color scheme made of two hues (red and blue) with an inflection point at zero is more suitable than a sequential color scheme. \[made by author\]. [Source of data](https://www.census.gov/data/datasets/time-series/demo/popest/2010s-counties-total.html).

In the map on the right, positive and negative values can be identified immediately based on color alone. We can immediately conclude that the population of mid-western and southern towns had declined and that in the east and west coast has increased. **This key insight into the data is not immediately obvious in the chart on the left where not color itself, but the intensity of color green must be used to read the map.**

#### Categorical colors can be used for completely unrelated data

![[made by author]](https://cdn-images-1.medium.com/max/2000/1*16lnKOqQDF2nWfRhEzLkhg.png)

**Categorical color palettes** are derived from colors of different hues but uniform saturation and intensity and can be used to visualize unrelated data points of completely dissimilar origin or unrelated values. Check out [this](http://archive.nytimes.com/www.nytimes.com/interactive/2011/01/23/nyregion/20110123-nyc-ethnic-neighborhoods-map.html?_r=0) visualisation of different ethnicities in New York City. There is no correlation between the data for different ethnicities and a categorical palette is therefore used here.

> Sequential and divergent color palettes should be used to render changes in magnitude by encoding qualitative values while categorical color palettes should be used to render unrelated data categories by encoding quantative values.

#### Categorical colors have only a few easily discernible bins

While the use of different colors can help distinguish between different data points, a chart should at most comprise of 6–8 distinct color categories for each of those to be readily distinguishable.

![](https://cdn-images-1.medium.com/max/2482/1*WTKqzvNWimO5Hxe-HZJiZw.png)

Fig: Number of satellites in service of top 15 nations. \[made by author\]. [Source of data](https://www.n2yo.com/satellites/?c=&t=country)

Use of a separate colour for each of the 15 countries makes the chart on the left difficult to read, especially for countries with fewer satellites. The one on the right is much more readable at the cost of losing information on countries with fewer satellites, all of which is grouped in the “others” bin.

Note that we have used a categorical color scheme here as the data for each country is completely uncorrelated. The number of India satellites, for instance, is completely independent of those of say France.

#### Change in chart type can often reduce the need for colors

A pie chart probably is not the best option in the previous example. The resulting loss of categories may not always be acceptable. Plotting a bar chart instead, we can use a single color and retain all 15 data categories.

![](https://cdn-images-1.medium.com/max/2000/1*3dvxxps_iDNeTuZICwyd4g.png)

Fig: Number of satellites in service of top 15 nations. \[made by author\]. [Source of data](https://www.n2yo.com/satellites/?c=&t=country)

> If there is a need for more than 6–8 different colours (hues) in a visualization, either merge some of the categories or explore other charts types

#### When not to use sequential color scheme

For the subtle difference in color of a sequential palette to be readily apparent, these colors must be places right next to each other like in the chart on the left below. When place away from each other like in a scatter plot, the subtle differences become difficult to grasp.

![Sequential color schemes are difficult to interpret when the data points are not located immediately next to each other as in the scatter plot on the right. These colors may only be used to visualize relative values as in the chart on the left. [made by author]](https://cdn-images-1.medium.com/max/2000/1*HqwJC1UmrFRhlvrbss7JnQ.png)

> Best use of a sequential color scheme is to render relative difference in values. It is not suitable for plotting absolute values which are best rendered with a categorical color scheme.

#### Choose appropriate background

Check out [this animation](https://twitter.com/i/status/1028473566193315841) by Akiyoshi Kitaoka that demonstrates how our perception of color of the moving square changes with changes in its background. **The human perception of colors is not absolute. It is made relative to the surroundings.**

Perceived colour of an object is dependent not only on the colour of the object itself but also of its background. This leads us to conclude the following with respect to use of background colors in charts:

> Different objects grouped by same colour should also have same background. This in general means that variations in the background colour must be minimised.

#### Not everyone can see all colors

Roughly 10% of the world population is colour blind and to make coloured infographics accessible to everyone, avoid use of combinations of red and green.

![](https://cdn-images-1.medium.com/max/2000/1*a411ds64pbdeuwK7R5yu3w.png)

Fig: How colour blindness affects perception of colours. \[made by author\]

#### Conclusion

> The impetus of visualisation is to tell the story behind data. Only a thoughtful use of colour can help strengthen key arguments in this story.

Summarised below are some resources that I have found helpful in my work on the use of colours in data analysis and visualization.

## Tools for selecting colour combinations.

1. Colour brewer [Link](https://colorbrewer2.org/#type=qualitative&scheme=Set3&n=6)
2. d3-interpolate [Link](https://github.com/d3/d3-interpolate)
3. Colourco [Link](https://colourco.de)
4. Color Palette Helper [Link](https://vis4.net/palettes/#/9|d|00429d,96ffea,ffffe0|ffffe0,ff005e,93003a|1|1)
5. I want hue [Link](https://medialab.github.io/iwanthue/)
6. Adobe Colour [Link](https://color.adobe.com/create/color-wheel)

## Applied colour theory: A reading list

1. Practical Rules for Using Color in Charts by **Stephen Few**. [Link](https://nbisweden.github.io/Rcourse/files/rules_for_using_color.pdf)
2. The Importance Of Colour In Data Visualisations by **Eva Murray**. [Link](https://www.forbes.com/sites/evamurray/2019/03/22/the-importance-of-color-in-data-visualizations/#451901e057ec)
3. 100 Colour combinations and how to apply them. [Link](https://www.canva.com/learn/100-color-combinations/)
4. How to Pick the Perfect Color Combination for Your Data Visualization by **Bethany Cartwright**. [Link](https://blog.hubspot.com/marketing/color-combination-data-visualization)
5. The Power of The Palette: Why Color is Key in Data Visualization and How to Use It by **Alan Wilson**[ Link](https://theblog.adobe.com/the-power-of-the-palette-why-color-is-key-in-data-visualization-and-how-to-use-it/)
6. What to Consider When Choosing Colours for Data Visualisation [Link](https://www.dataquest.io/blog/what-to-consider-when-choosing-colors-for-data-visualization/)
7. Use of Color in Data Visualization by **Robert Simmon**[ Link](https://earthobservatory.nasa.gov/resources/blogs/intro_to_color_for_visualization.pdf)
8. The use of color in maps [Link](https://morphocode.com/the-use-of-color-in-maps/)

Please do leave a comment or write to me at aseem.kash@gmail.com with suggestions. Thanks for reading.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
