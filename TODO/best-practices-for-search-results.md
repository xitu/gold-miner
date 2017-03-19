* 原文地址：[Best Practices for Search Results](https://uxplanet.org/best-practices-for-search-results-1bbed9d7a311#.8pysknjlm)
* 原文作者：[Nick Babich](https://uxplanet.org/@101?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：
<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*HgoOq5VKfmNfswUF8GM7pg.jpeg">

# Best Practices for Search Results #

Search is like a conversation between the user and system: the user expresses their information need as a query, and the system expresses its response as a set of results. The results page is a crucial piece of the search experience: it presents an opportunity to engage a dialogue that guides users’ information needs.

In this article I would like to share 10 practices that will help you improve the search results UX.

### 1. Don’t erase users’ query after they hit Search button ###

*Keep the original text.* Query reformulation is a critical step in many information journeys. If users don’t find what they’re looking for then they might want to search again using a slightly modified query. To make it easier for them, leave the initial search term in the search box so they don’t have to re-type the entire query again.

### 2. Provide accurate and relevant results ###

*First results page is golden.* The search results page is the prime focus of the search experience, and can make or break a site’s conversion rates. Users typically make very quick judgments about a website’s value based on the quality of one or two sets of search results.

It’s clearly important to return accurate results to users, otherwise they won’t trust the search tool. It is thus essential that your search prioritize results in a useful way and that all the most important hits appear on the first page.

### 3. Use effective autosuggest ###

Ineffective autosuggestions deliver a poor search experience. Ensure that autosuggest is useful. Some helpful functions include recognition of root words, predictive text and suggestions while the user enters text. They help speed up the search process and keep users on-task toward conversion.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*AQFWWqXrznprydFeOL-axg.png">

Image credits: ThinkWithGoogle

### 4. Correct typos ###

*Typing is error prone.* If a user mistypes a search term and you’re able to detect this, you could show them results for the guessed and ‘corrected’ search term instead. This avoids the frustration that could be caused by returning no results and forcing the user to enter the search term again.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*U3xATz5_lkAgYsjJXNlH7g.png">

*There’s no support for query reformulation on the Apple store zero results page*

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*i0oGvymAq0dl7rhLjdLvug.png">

Asos does a good job of displaying alternative results when a typo occurs without offending the user. It has a subtle messaging like ‘we also searched for Overcoats’ with the original search term of ‘Overcoatt’

### 5. Show the number of search results ###

Show the number of search items available, so that users can make a decision on how long they want to spend looking through results.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*WC83Jp1xpJtLdMbuc5hhiQ.png">

The number of matching results helps the user make more informed query reformulations.

### 6. Keep recent user’s search queries ###

Even when users are familiar with the search feature, search requires them to recallinformation from their memory. To come up with a meaningful query, a user needs to think about attributes that are relevant for his goal and incorporate them in the query. When designing a search experience you should keep in mind a basic usability rule:

> Respect the users effort

You *site should store all recent searches*, in order to provide this data to the user the next time they conduct a search.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*F5VdrzysdFsaIBLQqxJvdw.png">

Recent searches benefit the user in saving them time and effort in searching for the same item again.

**Tip:** Present less than 10 items (and without a scroll bar) so the information doesn’t become overwhelming.

### 7. Choose proper page layout ###

One of the challenges of displaying search results is that different types of content require different layouts. Two basic layouts for content presentation are list view and grid view. A rule of thumb:

> Details in lists, pictures in grids

Let’s examine this rule in cotext of product page. Product’s specifics is very important moment. For products like appliances where *details* like model numbers, ratings and dimensions *are major factors in the selection process* — the list view makes most sense.

![](https://cdn-images-1.medium.com/max/800/1*K7ITLIzXP57remQneOi9nw.png) 

List view is better suited to a detail-oriented layout

A *grid view* is a good option for apps with products *that require less product information* or *for similar products.* Products like apparel, where less text-based product information needs to be considered when choosing between items and you make your decision *by the appearance* of the product. For this type of products users care about the visual distinctions between items, and would rather scroll through a single long page than repeatedly switch between the list page and product-detail pages.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*HplfdblSUuoURLFBCEWDfg.png">

Grid view is better suited to a visually-oriented layout

**Tips:**

- Allow users to choose ‘list-view’ or ‘grid-view’ for search results. This gives your users the ability to choose how they view their results in a way preferable to them.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*ebjnL_m2ojhNM9duJac9qg.png">

Allow users to change the layout by offering a range of views.

- When designing grid layout, pick the right size of images so that they are large enough to be recognizable, yet small enough to allow more products to be seen at a time.

### 8. Show search progress ###

Ideally search results should be displayed *immediately*, but if it’s not possible — a progress indicator should be used as system feedback for user. You should give your users a clear indication of how long they need to wait.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*SXF1nALfezQeQyYOSu1l-A.gif">

Aviasales website *notify users that search will take some time.*

**Tip:** If search takes too long you can use animation. Good animation can distract your visitors and make them ignore long searching times.

### 9. Provide sort and filter options ###

Users become overwhelmed when their search terms result in seemingly irrelevant and/or too many results. You should provide the user with filtering options that are *relevant* for their search, and enable them to select multiple options each time they apply to filter results.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*sKSFUtpTpH1KH6rKtJrDYQ.png">

Filter options can help users narrow and organize their results, which otherwise requires extensive (and excessive) scrolling or pagination.

**Tips:**

- It’s important not to overwhelm users with too many options. If your search requires a lot of filters, then collapse some by default.
- Do not hide the sort feature within the filtering feature — they are distinct tasks.
- When the user chooses a narrow search scope, explicitly state the scope at the top of the results page.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*ScC1SnfDGtI6fZ6UUpvNPg.png">

### 10. Don’t return ‘no results’ ###

Dropping someone on a page with no results can be frustrating. Especially if they have tried the search a couple of times. *You should avoid giving users dead-ends* in their experience when their search produces no matching results. Provide *valuable for user* alternatives when there are no matching search results (e.g. online shop can suggest alternative products from the similar category).

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*vWXgR6cGUC7oMrjGw1xwMg.png">

A “no results” page as seen at HP example is essentially a dead-end for the user. It stands in sharp contrast to the page that had contextual category or search query suggestions at the no-results page, as seen in the Amazon example.

### Conclusion ###

Search is a critical element of building a profitable site. Users expect smooth experiences when finding and learning about things and they typically make very quick judgments about site’s value based on the quality of one or two sets of search results. An excellent search facility should help users find what they want quickly and easily.

Thank you!
