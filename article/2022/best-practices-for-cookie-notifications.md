> * 原文地址：[Best Practices for Cookie Notifications](https://blog.bitsrc.io/best-practices-for-cookie-notifications-956aa9ded8d5)
> * 原文作者：[Ravidu Perera](https://raviduperera.medium.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/best-practices-for-cookie-notifications.md](https://github.com/xitu/gold-miner/blob/master/article/2022/best-practices-for-cookie-notifications.md)
> * 译者：
> * 校对者：

# Best Practices for Cookie Notifications

![](https://miro.medium.com/max/1400/1*F3LnyRex1n6ymjO0kAK8uQ.jpeg)

Cookies are small text strings primarily used for authentication to establish a user session. Lately, they have been used primarily for tracking unique details about users such as settings and preferences on their browsers to enhance the UX of a website.

With the legislation of the [General Data Protection Regulation (GDPR)](https://gdpr.eu/), all websites must notify the users about the data they are tracking in cookies.

This article will discuss some best practices to follow when implementing these cookie notifications to have a minimum impact on the UX and UI.

## Can Cookie Notifications Disrupt UX?

Even though it's essential to inform the user about the data tracked using cookies, they can affect UX if not implemented correctly.

Here are some scenarios where cookie notifications are hindering the UX.

### 1. Intrusive cookie notifications on mobiles

![](https://miro.medium.com/max/648/1*fIM25m26dEOvn9AXxg6Cyw.jpeg)

Screenshot from mobile of an intrusive cookie notification

Notifications similar to the above, blocking a large portion of the screen, prevent the user from accessing the content on the page. Such notifications obstruct the usability of the website.

### 2. Cookie notifications with the illusion of choice

![](https://miro.medium.com/max/1400/1*VrClO6qQqkadtc-IglOJyA.gif)

Cookie notifications without an option to reject

Cookie notifications without a proper description of the usage and options to change the cookie preferences or refuse cookies, as shown above, can mislead the users and ultimately force them to accept the cookies.

![](https://miro.medium.com/max/1400/1*RvjGTBhLkxPwXVhQQer9mQ.jpeg)

Cookie notification forcefully asking to accept

## Best Practices for Building Cookie Notifications

Let's go through some best practices to implement cookie notifications with the options to accept, reject or quickly change the settings of cookies.

### 1. Proper placement

Cookie notifications are commonly placed in the header, footer, or corner of the page where the notice won't hinder the main content.

![](https://miro.medium.com/max/1400/1*ZJGlv46qCAV3vJMZD4qHcA.jpeg)

Cookie notification placed in the corner of the page

It's best to put the notice in the footer, where the main content is still displayed as intended, and the notice is less intrusive.

![](https://miro.medium.com/max/1400/1*j-YvaPBrmDfOi7DLlpYU9w.jpeg)

Recommended placement for cookie notifications

Regardless of where it's placed, it is crucial to ensure that the notification occupies minimum space.

Cookie notices are also displayed in modals. However, this draws the user's attention away from the content. Thus, it should be used with caution. Unfortunately, this is the strategy adopted by most websites that require cookie consent.

![](https://miro.medium.com/max/1400/1*WqUQXE96jIhEzT-i2osw9Q.jpeg)

A cookie notification occupies an unnecessary amount of space. Source: [awin.com](https://www.awin.com/gb)

### 2. Mobile responsiveness

When viewed on a mobile device, even a footer or header can occupy a lot of space on the page.

Therefore, it is essential to ensure that the notification is mobile responsive and covers a minimum area of the mobile screen.

![](https://miro.medium.com/max/1400/1*-ytctuRnGgmqsAJ_H_rWVg.png)

Comparison of the size of the notification on mobile devices

The above example shows that a cookie notification occupying less space on a mobile device (Image 2) is much more comfortable and less disruptive.

### 3. Proper, descriptive call-to-action buttons

Provide the user a short description of the usage of cookies and options to allow, reject or change settings of the cookies according to their preference.

![](https://miro.medium.com/max/1204/1*WWWk7cHB5d1gi7y04qaSgg.png)

Descriptive cookie notification

![](https://miro.medium.com/max/1400/1*Erxgrbp_Oe81dKbetM_YeA.jpeg)

Cookie notification with options to customize and descriptive buttons

### 4. Provide flexible customization

Providing the users an option to customize their cookie preferences will give users control over the data tracked by the website.

Some of the features that can offer to the users are:

- Change cookie preferences from the default ones
- Ability to turn on non-essential cookies that can aid in enhancing the UX
- An overview of the functionalities of different groups of cookies with an indication for recommended categories

![](https://miro.medium.com/max/1400/1*aEoLyNmfTCbcybVjiM801g.gif)

Cookie notification with an option to customize the settings

In the cookie settings, it's essential to group the options by purpose so that users can quickly identify and select the necessary categories rather than select or deselect each child option manually.

Regular cookies are simple to delete, but they may make specific websites more challenging to navigate. In addition, users may have to re-enter their data for each visit if cookies are not used. Cookies are stored in various locations by different browsers.

![](https://miro.medium.com/max/612/1*OsxtTBCotBzRNnPPNNQR6g.png)

Example for categorized cookie settings

Adding a short description of each category of cookies can help the users identify which categories to choose for better functionality.

![](https://miro.medium.com/max/946/1*G2CCo0IbJ1VKnxxeQCwnvw.jpeg)

Provide descriptions of cookie categories in the settings for better guidance for the user

### 5. Turn off non-essential cookies by default

By default, enable the essential cookies to run the website and allow users to proceed or toggle the non-essential cookies from settings.

![](https://miro.medium.com/max/1400/1*FjvcIYXsa0dthqNKalbc5A.jpeg)

The website [StackExchange](https://stackexchange.com/) has non-essential cookies disabled and essential cookies enabled by default.

*Note:** If the website only collects anonymous data that doesn't violate GDPR, you can avoid the usage of cookie notifications.*

The majority of cookies exist solely for persistence. Cookies allow you to stay logged in until you log out of a website like Facebook or Twitter. This means that you will be logged in every time you visit that site, saving you the time and effort of having to re-enter your password. You will be logged out if you erase your cookies.

You should also be aware that some websites may utilize third-party cookies that aren't harmful to your privacy. However, disabling these cookies may result in issues.

### 6. Improve the performance of cookie notifications

Websites frequently utilize third-party scripts or services that leverage cookies to manage cookie notices.

Ensure that these scripts do not obstruct the loading of the website's actual scripts by loading the cookie scripts asynchronously.

Asynchronous loading of third-party scripts

However, asynchronously loading could generate a "flicker" on the page, where the original page loads first, followed by the variation page shortly after.

Tools such as a `[Cookie script generator](https://cookie-script.com/)` can be used to check the performance and usage of cookies and enhance the performance of the cookies.

![](https://miro.medium.com/max/1120/1*-WPvGdDywd4kCxvLKLzPCA.png)

Cookie report for the author's medium page

# Conclusion

Cookies are essential to maintain the dynamic nature of a website. Therefore, it is necessary to inform the user about the personal data stored on a website and get consent via cookie notifications.

It's the responsibility of developers to implement these essential notifications in a user-friendly manner, with minimum damages to the UI/UX of the website.

We hope that the best practices discussed in this article will help you build cookie notifications with the UI/UX in mind.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
