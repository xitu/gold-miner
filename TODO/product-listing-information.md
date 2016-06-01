>* 原文链接 : [E-Commerce UX: What Information to Display in Product Listings (46% Get it Wrong)](http://baymard.com/blog/product-listing-information)
* 原文作者 : [Jamie](http://baymard.com/blog)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:

![](http://assets.baymard.com/research/media_files/attachments/17301/original/research-media-file-f6c7249aa471651b567e784d21ca6238.jpg)</div>

_“I miss a way to compare, so I don’t have to click one, then click back, click another, then click back, click..”_ a subject explained when looking for a sleeve for his laptop, _“Here I don’t really get any information besides the price and the name.”_ Note how half of the laptop case list items at Zappos either had none or only vague size descriptions available, such as “large”.

Users select and reject products based upon the **information available** about those items in the product list. It therefore isn’t all that surprising that during our large scale usability study of [Product Lists & Filtering](http://baymard.com/research/ecommerce-product-lists) we found poorly selected list item information to be one of the most severe usability issues related to product list navigation.

During testing we observe that too little or low-relevance list item information is highly problematic because users are **unable to adequately assess** the listed products when they lack essential information about those items. This led the test subjects to dismiss perfectly relevant products and forced them into unnecessary pogo-sticking between product list and product page – where they had to go back and forth, opening the product page of every single product listing just to learn the very most basic and core attributes of that product; a tiresome exercise that often resulted in the subjects abandoning the site as the friction in locating relevant products simply became too high. Clearly, displaying the right amount and the right kind of information in each list item is paramount to improving the user’s product finding experience.

Alas, identifying how much and what type of information to display in product list items is a major issue “out in the wild”, as our [Product List benchmark](http://baymard.com/ecommerce-product-lists/benchmark/site-reviews) of 50 top US e-commerce websites reveal that 46% of those sites suffer from displaying too little or poorly chosen content. (A minor subset of the sites have gone too far in the opposite direction and display too much information in their list items!)

![](http://assets.baymard.com/research/media_files/attachments/17287/original/research-media-file-0f8ef662d7a97428d80c08682f3f36ca.jpg)</div>

During testing [Gilt](http://baymard.com/ecommerce-product-lists/benchmark/site-reviews/228-gilt) failed to display a crucial piece of list information: alternative product variations! This caused multiple test subjects to reject products because they thought the item was only available in the displayed color, when in fact it was available in multiple color variations.

![](http://assets.baymard.com/research/media_files/attachments/17288/original/research-media-file-61b54f07f843f261b3958b95261848b5.jpg)</div>

In addition to all common “universal” attributes, [Crutchfield](http://baymard.com/ecommerce-product-lists/benchmark/site-reviews/254-crutchfield) also included three bullets with category-specific attributes – that is, information that is uniquely relevant to the product type. For instance, the ‘X-watts-RMS’ and ‘filter pass’ attributes are only relevant to car amplifiers and are therefore only displayed for these items. Meanwhile, elsewhere on the site products in other categories display attributes uniquely relevant to their particular verticals.

Achieving an good **signal-to-noise ratio** in the list item information is key to improving the user’s ability to find the products they are looking for – yet it clearly isn’t easy to achieve. It requires considered curation of the product attributes displayed. In this article we’ll present test findings from our [Product Lists & Filtering](http://baymard.com/research/ecommerce-product-lists) study on how to identify exactly how much and what type of information to include in your product listings.

_(Note that the following findings were also observed for – and thus apply equally to – both category listings and search results.)_

## List Item Information: A Balancing Act

Whatever information that’s displayed in the product list is the basis on which the user assesses and judges the suitability of those products. Product list real estate therefore shouldn’t be squandered. Each and every element in the list item should be **carefully chosen** and presented to give users the best possible conditions for finding and choosing the products that are just right for them. A successful product list design must fulfill two requirements:

*   Present the user with **sufficient product information** to adequately assess a product’s suitability (to their unique needs and desires),
*   Enable the user to get an **overview of the product list** as a whole (i.e. the options available to them), and compare products of interest to one another.

The first requires sufficient product information to be shown for each product while the latter requires a sufficient amount of products being displayed on the user’s screen. This creates a **dilemma**, as having too much product information will take up real estate resulting in less products per page, which was found to discourage product list exploration during testing. Yet having too many products will make it difficult to display adequate information in each list item, resulting in extensive pogo-sticking.

![](http://assets.baymard.com/research/media_files/attachments/17289/original/research-media-file-6debb0c41567623c2fbccb372f972d1c.jpg)</div>

As is evident from our large-scale eye-tracking study, users tend to focus intensely on product thumbnails when scanning products in visually-driven product verticals. (Here seen at [REI](http://baymard.com/ecommerce-product-lists/benchmark/site-reviews/247-rei), heat-map of 32 subjects, accumulate count, total duration)

Product list design therefore isn’t so much a matter of “less is more” as it is one of “just enough is more.” Figuring out which product attributes should be present in the list item and which shouldn’t is naturally highly site-specific and, as such, there are no hard-set rules. A good list item helps the user with just enough information to **accurately evaluate** which of the items in the list are of relevance to them, and – just as importantly – which items can be skipped. The list item information should furthermore enable the user to compare the relevant items to one another. It’s essentially an exercise in maximizing information scent and product comparability without bloating the product list.

Now, from our research studies we have found that there are **two general groups** of attributes that should be included in list items: Universal Attributes and Category-Specific Attributes. Universal Attributes are essential to virtually all products throughout the site and include things like price and product title (or type). Category-Specific Attributes meanwhile are unique to each product vertical and can therefore vary from product to product. In the following we’ll cover each in detail.

## Universal Attributes

There are a few Universal Attributes that should almost **always be displayed** in any given list item regardless of the products sold or the site context. For example, the product price is a fundamental product attribute that ought to be included under all circumstances (and in the few cases where it can’t, some indication of why is typically warranted).

Besides the fairly obvious price, the other key Universal Attributes are: product title or type, thumbnail, user ratings, and variations. For lists of search results, [contextual search snippets](http://baymard.com/blog/search-snippets) would fall in this category too. The following paragraphs will summarize the most crucial aspects of these Universal Attributes.

![](http://assets.baymard.com/research/media_files/attachments/17290/original/research-media-file-beb2f73890ac1b9795830c9a1ce304d8.jpg)</div>

At IKEA, a subject sorted the sofas by price (low to high) – unfortunately this resulted in a list of sofa accessories, mattresses and slipcovers, rather than a list of sofas going from cheap to expensive. Further adding to the confusion, the slipcovers were displayed on actual sofas, making it difficult to determine whether a product was a sofa or a slipcover when quickly glancing over the product list.

**The price** of each product is obviously critical to the user, both in terms of evaluating each product on its own as well as comparing products to one another. It is therefore essential that the price is permanently visible at all times. Our [product lists and filtering benchmark](http://baymard.com/ecommerce-product-lists/benchmark/site-reviews) shows that virtually all sites get this right.

However, some common issues related to the inclusion and presentation of the product price were observed during testing. For instance, in some cases it wasn’t obvious what was included in the price (this typically happened when several objects were displayed in the product thumbnail, e.g. for [compatibility products](http://baymard.com/blog/ecommerce-compatibility-databases) or bundle sales). It is therefore advisable to make it self-evident what’s included in the list item price. Similarly, displaying “price per unit” for multi-quantity items can be a great help to the user so they don’t have to calculate this for each and every list item just to figure out which ones offer the most value for money – alas 98% of sites selling multi quantity items fail to display unit costs (see all our test findings on [Price Per Unit](http://baymard.com/blog/price-per-unit)).

![](http://assets.baymard.com/research/media_files/attachments/17291/original/research-media-file-b9db9eecf9fc4873a76746a11d479ed3.jpg)</div>

_“I saw there was something, but there is no image, so I wouldn’t click it,”_ a subject explained at Best Buy, referring to the third item in the list. It turns out this was exactly the adapter she needed, but due to the missing thumbnail, this subject – like many others – simply skipped the product.

**Product thumbnails** proved to be one of the most important attributes for the test subjects, who would afford a disproportionately large amount of attention to it. List items without thumbnails were often completely ignored, as most of the subjects perceived these products as “incomplete.” Good product thumbnails thus tend to play a key role in the user’s search and selection of products. Hence it is crucial to provide the user with adequate visual product information.

In practice this means always having thumbnails for all list items and making sure the thumbnail size reflects the user’s need for visual product information (Product Lists report owners: see guidelines #25, #28, #29, #34 and #39). It is furthermore advisable to have a [secondary hover image](http://baymard.com/blog/secondary-hover-information) ( allowing for additional visual product information) and considering both [“use context” and “cut out” thumbnails](http://baymard.com/blog/ux-product-image-categories) (allowing both an isolated view of the product along with a more aspirational presentation).

![](http://assets.baymard.com/research/media_files/attachments/17292/original/research-media-file-c77036a8531f2c8700f545ec63d6f399.jpg)</div>

IKEA includes both product (series) title and type, as the names alone would be of little value to the user. Titles such as “Söderhamn” and “Poäng” are only meaningful to the user as a unique identifier of a product series. Furthermore, on hover a variation gallery is displayed, which is great, although there should ideally be some indication in the list item’s default state that multiple variations are available.

**Product title or type** also proved important to the subjects when scanning product lists (especially search results) and in some cases when wanting to verify the product type in case the thumbnail was difficult to decipher at a first glance. While descriptive product names can generally stand on their own as the product title, there are a few industries where the product type may actually make more sense to the user than the product title – especially if the titles are non-descriptive in nature. In those cases, product type may be displayed instead or in combination with the title.

For large or mixed-product catalogs, it might be too resource intensive to manually determine if each product title is descriptive or not, in which case it is recommended to include both. A better but more advanced alternative would be to dynamically scan each product title to determine if it includes product-type keywords and, based on this, include the product type for any products with non-descriptive titles. For either small or well-aligned product catalogs (e.g., a manufacturer e-commerce site such as IKEA), you might be able to determine the product title’s descriptiveness across the entire catalog based on company-wide product-naming policies.

![](http://assets.baymard.com/research/media_files/attachments/17293/original/research-media-file-0206f416589dd88e1ef3d8b03263694f.jpg)</div>

Without an indication that some of these pans exist in multiple sizes, users will have to visit each product page at [Williams-Sonoma](http://baymard.com/ecommerce-product-lists/benchmark/site-reviews/219-williams-sonoma) to learn about the available variations. While the user can infer that multiple variations exist based on the listed price range, it’s needlessly cumbersome to have to infer this for each result in a list with tens or even hundreds of results. More importantly, a price range doesn’t indicate what the product variation is – do the pans vary in size, material, or color?

![](http://assets.baymard.com/research/media_files/attachments/17294/original/research-media-file-c0d845fab21bb7d9f179f057c087c4cb.jpg)</div>

In comparison, notice how users at [American Eagle Outfitters](http://baymard.com/homepage-and-category-usability/benchmark/site-reviews/145-american-eagle-outfitters) can just glance at the list to determine which shirts exists in multiple variations (indicated with a collection of color and pattern swatches) and which are only available in the specific style shown in the list item thumbnail.

**Product variations**, such as different colors, sizes, materials, looks, etc., is another essential attribute to indicate directly in the list item. Without them, the subjects often rejected products that actually matched what they were looking for simply because they couldn’t see that multiple variations of the item were available and therefore only judged the product on the default variation displayed, without ever realizing that multiple (highly relevant) product variations existed and would be available from the product page.

It’s not all product variations that should be displayed, however. For example, a desk available in different sizes would typically need an indication in the list item explaining that multiple sizes exist, whereas it’s probably less relevant for a shoe list item to indicate that multiple sizes exist as users will assume so due to the nature of the product.

![](http://assets.baymard.com/research/media_files/attachments/17295/original/research-media-file-a5a883ffb835cedef8d909f995655728.jpg)</div>

Here a test subject – not really sure about the meaning of the different product specs – used the ratings at Tesco to decide which camera she should buy. User ratings often act as guidance for users who are undecided or have little knowledge about the product domain.

**User ratings** will for most industries and site types also be a Universal Attribute to include in all list items. Throughout testing, whenever the subjects had little knowledge about a particular domain, they would rely on the user ratings to gauge which results were relevant to explore further – viewing these highly rated items as a “safe choice” vetted by other users.

Many users effectively rely on ratings as a proxy for “good quality / value for money” when they don’t feel comfortable making that evaluation themselves. Thus, if a significant number of your user base aren’t experts in the product type(s) being sold at the site, a ratings summary should be included directly in the product list items. When including user ratings in the product list, note that it is essential to include _both_ the user rating average _and_ the number of ratings the average is based on – as we’ve time and again observed that users find the rating average useless without the number of rating (see [Users’ Perception of Product Ratings](http://baymard.com/blog/user-perception-of-product-ratings) and [Don’t Base ‘Customer Ratings’ Sorting on Averages Only](http://baymard.com/blog/sort-by-customer-ratings)).

## Category-Specific Attributes

Many product verticals will have one or a few attributes that are so important to the products in that category that they should be included directly in the list item overview in order for users to make an **informed decision** about which products to open and which to skip.

These attributes will naturally vary greatly from category to category and must be **chosen uniquely** for each vertical. What follows are a few examples of different Category-Specific Attributes to use as a source of inspiration when trying to determine if and which product attributes may be uniquely important for a given category (and thus qualify as a Category-Specific Attribute).

![](http://assets.baymard.com/research/media_files/attachments/17296/original/research-media-file-88602817b6d0a836c6ee58b1e7f79984.jpg)</div>

[Newegg](http://baymard.com/ecommerce-product-lists/benchmark/site-reviews/244-newegg) only includes compatibility information for some of their laptop power adapters. For the subjects who would have preferred to buy a cheaper power adapter than the $116 adapter that included compatibility information, this annoyed them to no end.

The relevance of products in certain technical categories will be determined almost entirely by the product’s **compatibility** with another product. This “compatibility information” should therefore be included in the list items so users can identify the products that are relevant to them without having to open the product page of every single item in the list. Taking things a step further, if the user already has the compatibility-dependent product in their cart, the product list items should ideally state whether they are compatible with the item in the user’s cart (also see [6 Use Cases for Compatibility Databases on E-Commerce Sites](http://baymard.com/blog/ecommerce-compatibility-databases) and [Highlight Items Already in the User’s Cart](http://baymard.com/blog/highlight-products-if-in-users-cart)).

![](http://assets.baymard.com/research/media_files/attachments/17297/original/research-media-file-d408ce075d520f2eaae6b50eb46d843d.jpg)</div>

Without the dimensions or sizes of the camera cases in the list items, the test subjects at Tesco had to open each case and hunt down the product specifications on the product page to determine whether it would fit their camera. A “use context” image can also help in communicating the approximate size (e.g. showing the case with a camera partially inside), but will obviously be much less accurate than listing the actual dimensions.

Another kind of compatibility information is **dimensions**. For example, any kind of case or bag that has to contain, carry, store, or otherwise hold another product will often need to have its inner dimensions listed so users can determine whether their product(s) will fit in it. That said, it is still less restrictive than the dependencies between technical products (which simply won’t work together) since a user may choose to buy a “container” that has room to spare after filling it with the product(s) to be stored.

![](http://assets.baymard.com/research/media_files/attachments/17298/original/research-media-file-1fa562b7dfeb88a0ee73f22e5825165b.jpg)</div>

Here, a test subject relied on the product thumbnail and recommended age span to find products suitable for her niece. The Entertainer understands that most of their customers aren’t the end-user and wisely includes a recommended age for their toys to help users identify age-appropriate products.

Attributes conveying appropriateness for a **recommended usage**, occasion, or audience, can be important in industries where the customer often won’t be the end-user. In fact, such attributes can almost function as an integrated help guide, directing the customer to products that will be suitable to their recipient or occasion, such as the type of flowers to buy for Mother’s Day.

![](http://assets.baymard.com/research/media_files/attachments/17299/original/research-media-file-dc720599f835747ad6f7f995f879dad8.jpg)</div>

Go Outdoors doesn’t include the temperature rating for all their sleeping bags; only a few of them had it stamped onto the product thumbnail. Understandably, the test subjects found it frustrating that they had to open all the remaining products to determine if they were suitable for cold weather.

Another typical example of Category-Specific Attributes is any product that must work under **special conditions**. These include safety gear, outdoors products, underwater equipment, and any type of product that has to perform in a special context.

The examples of Category-Specific Attributes are of course endless – the above paragraphs illustrate just a few instances of product types that have one or two attributes that a uniquely relevant to their vertical. The list naturally goes on and on. You might for instance want to include the resolution of a camera, the mileage or power of a car, the production method of foods, etc.

Category-Specific Attributes are just as important Universal Attributes but they aren’t shared across product verticals – e.g. while an “age rating” is highly relevant to toys, it doesn’t make much sense to a collection of cameras – and vice versa, a “megapixel resolution” makes sense to the cameras but not the toys! Identifying Category-Specific Attributes therefore takes some work as it requires going over each and every category to determine if there are 1-3 attributes that are absolutely vital for the user to be able to determine the relevance of a product in the vertical, and then dynamically including that set of curated attributes in the product’s list item.

## Presenting List Item Information

By including all Universal Product Attributes (price, thumbnail, product title or type, variations, and user ratings) along with any pertinent Category-Specific Attributes in each list item, the user is provided with **optimal conditions** for evaluating each item in the product list and selecting which products to explore further (i.e. which product pages to open).

Universal Attributes must be included because they are essential to any product, and users therefore can’t accurately determine the relevancy of an item without these attributes. Category-specific attributes are a smart way to provide 1-3 extra pieces of product information that is **uniquely relevant** to that product’s vertical and thus uniquely helpful to the user in determining whether the item is of relevance to them or not.

With all Universal Attributes and 1-3 Category-Specific Attributes listed for each product list item, the user is provided with just enough information to accurately evaluate and compare the listed products. There’s not too little information (the most common problem) nor is there so much list item information that users lose overview (a less common but equally problematic design). In short: it strikes an **ideal balance** between providing sufficient information scent about each product without inducing information overload.

Achieving an optimal balance for the list item information results in a high signal-to-noise ratio in the product list, which is critical to the **user’s ability** to find the products they are looking for, as a good ratio enables users to easily ascertain which products to pursue and which are safe to ignore. Yet, don’t be fooled by the seeming simplicity of this advice – a whopping 46% of e-commerce sites fail on one or more of these parameters, forcing their users into an excessive back- and forth pogo-sticking exercise – often creating so much friction in their users’ product exploration process that it ends up being the direct cause for site abandonments.

