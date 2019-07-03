> * 原文地址：[Six Principles for Designing Any Chart](https://medium.com/google-design/redefining-data-visualization-at-google-9bdcf2e447c6)
> * 原文作者：[Manuel Lima](https://medium.com/@mslima)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/redefining-data-visualization-at-google.md](https://github.com/xitu/gold-miner/blob/master/TODO1/redefining-data-visualization-at-google.md)
> * 译者：
> * 校对者：

# Six Principles for Designing Any Chart

> An introduction to Google’s new data visualization guidelines

![](https://cdn-images-1.medium.com/max/2748/1*mXIcH44FAZKCRjX5g_lYmw.png)

---

In August 2017, a group of passionate designers, researchers, and engineers at Google came together to create a comprehensive set of data visualization guidelines — covering everything from color, shape, typography, iconography, interaction, and motion. The success of this collaboration sparked the formation of Google’s first fully dedicated Data Visualization team, which kicked off in May 2018.

Over the last year, we’ve continued to work on understanding the needs, requirements, and desires shaping how people visualize and interact with information. Now, we want to share our insights with creators everywhere. We’ve launched detailed public guidelines for [creating your own data visualizations](https://goo.gle/2ITQoTY), and distilled our top principles and considerations. Below, six strategies for designing any chart.

---

## Be honest

#### Data accuracy and integrity come first. Don’t distort or confuse the information for embellishment or partiality. Emphasize clarity and transparency.

![](https://cdn-images-1.medium.com/max/2760/1*ydrVMlmFanX1LsuN6CzTqA.png)

Provide users with the contextual elements they need to understand a given visualization. Maximize the integrity of the graphic by using clear labels, accurate axes and baselines, and supporting tooltips and legends. Motion can help reinforce relationships, but must not distort the data. Be transparent about the employed dataset, where it came from, and how it was collected and treated.

---

## Lend a helping hand

#### Provide context and help users navigate the data. Build affordances that prioritize data exploration and comparison.

![](https://cdn-images-1.medium.com/max/2760/1*60a7CCF8W4EytCv7idmllw.png)

Design with users’ existing mental models — which may be shaped by widely used tools — in mind. Create a warm onboarding experience that makes it easy to learn how to read the chart and its information. Select visual and interactive affordances that support discoverability of core features, such as selecting, zooming, panning, and filtering. Motion and interaction should support analytical reasoning and user comprehension by revealing context, insights, associations, and causality. Leverage empty states as moments of revelation.

---

## Delight users

#### Always exceed expectations. Consider performance, polish, surprise, and innovation. Embrace dynamic, fast, and clever experiences.

![](https://cdn-images-1.medium.com/max/2760/1*IpHoJvLE_87IDvRG8dQ3MQ.png)

Create great visualization experiences, then improve upon them in unexpected ways. When appropriate, employ signature features and small moments of delight that guide users to what they need. Speed is as rewarding as graphical excellence. Consider motion and timing in the choreography of state transitions to aid perception of a fast and responsive system.

---

## Give clarity of focus

#### Reduce cognitive load and focus on what matters. Every action, color, and visual element should support data insights and understanding.

![](https://cdn-images-1.medium.com/max/2760/1*VwVvqEaH-Y3Z_5Ryt481gw.png)

Focus on the user’s task and all else should follow. Direct users to the essential information as quickly as possible. Maximize the data-ink ratio and avoid extraneous graphic elements. Apply color in meaningful ways to contribute to graph comprehension: label, group, highlight, or measure. Use motion sparingly–limit to subtle transitions and cues that help users understand hierarchy, data orientation, and relationships.

---

## Embrace scale

#### Allow the system to extend and adapt to any context. Respect different user needs on data depth, complexity, and modality.

![](https://cdn-images-1.medium.com/max/2760/1*DF5pg4i7OlWo9fAfbi-liQ.png)

Every chart should aim to be as accessible as possible. Consider how chart elements (color palettes, filter configuration, axes, panels, interactive mechanisms) might scale to accommodate a variety of users’ needs, screen sizes, and data types (from a single data point to large multivariate datasets). Think about a spectrum of possibilities rather than an immutable configuration. Apply interactive approaches to minimize complexity, such as providing details gradually (progressive disclosure), letting users change perspective, and linking different views to enable deeper insights.

---

## Provide structure

#### Use visual attributes to convey hierarchy, provide structure, and improve consistency. Experiences should be intuitive and easy to use.

![](https://cdn-images-1.medium.com/max/2760/1*XJqqL_vhSWVNRpjbi_zn1g.png)

Consistency drives familiarity. Develop uniformity in graphical treatments (shape, color, iconography, typography) and interaction patterns (selection, filtering, hover states, expansion). Motion should feel controlled, giving the user a sense of stability and continuity while remaining responsive. Consider entrance and exit motion to help the user understand the visual hierarchy of elements, orientation of axes, and the data displayed. Maintain strong contextual cues, so no matter where the user navigates in the chart, they know how to get back.

**For more insights and strategies, read our full [Data Visualization guidelines](https://goo.gle/2ITQoTY).**

---

#### Acknowledgments

This work could not have been done without the talent and dedication of countless individuals at Google. Thank you: Shuo Yang, Kent Eisenhuth, Sharona Oshana, Katherine Meizner, Hael Fisher, Ross Popoff-Walker, Ian Johnson, Joe Nagle, Ryan Vernon, Nick Bearman, Luca Paulina, Gerard Rocha, JT DiMartile, Lorena Zalles, Tom Gebauer, Hilal Koyuncu, Bethany Fong, Ann Chou, Barbara Eldredge, and Anja Laubscher.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
