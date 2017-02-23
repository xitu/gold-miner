> * 原文地址：[Building React Components for Multiple Brands and Applications](https://medium.com/walmartlabs/building-react-components-for-multiple-brands-and-applications-7e9157a39db4#.7tbsp6vsz)
* 原文作者：[Alex Grigoryan](https://medium.com/@lexgrigoryan)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： 
* 校对者：

---

# Building React Components for Multiple Brands and Applications

![](https://cdn-images-1.medium.com/max/1600/1*7bG_2QAIOzbKNeesEkkTzg.png)

There are several distinct brands that make up the Walmart family, including [Sam’s Club](https://www.samsclub.com/), [Asda](http://www.asda.com/), and regional branches like [Walmart Canada](http://www.walmart.ca/en). E-commerce applications use tons of functionally similar capabilities, such as; credit card components, login forms, onboarding, carousels, navigation, and more. Developing e-commerce applications for each of these brands in isolation would reduce opportunities for code reuse, resulting in countless hours of duplicated work of these functionally similar components. At @WalmartLabs, [code reusability is important to us](https://medium.com/walmartlabs/how-to-achieve-reusability-with-react-components-81edeb7fb0e0#.arwumefxh). That’s why our application architecture is centered around multi-tenancy/multi-branding — which is the act of building a component for one brand and then adopting it for other brands with different visuals or content. Below, you’ll find our multi brand strategy for react components.

For context, most of our services are built around different types of multi tenancy. When you make a call to the service, you would usually pass the tenant in the header or in the payload, and the service provides data for that specific tenant. The service might pull different item data for example for samsclub.com versus walmart.com.

We then tried to extend that idea to the front end applications as well. Because we’re using React with Redux, the visual components are already separated from application state, actions, and reducers. This meant we could abstract the React components into one GitHub organization and Redux actions, reducers, and connected components into another. By publishing all of these in a private npm registry, we make it easy for developers to install, try out, and upgrade not only the shared UI elements, but also the actions and reducers that implement our business logic and API calls. [You can read more about how we reuse here.](https://medium.com/walmartlabs/how-to-achieve-reusability-with-react-components-81edeb7fb0e0#.arwumefxh)

Of course, if that were the end of the story, all of our applications would look and act the same. In reality, each brand has different requirements in regards to visual guidelines, business requirements, or content, and those requirements must be accounted for.

### Visual Differences

Purely visual differences can be handled through styling. The majority of our styling is at the component level. We have a “styles” folder and within that folder are tenant folders, and within those tenant folders are tenant specific styles.

Looks kind of like this:

    Component
    - src
    - styles
      - walmart
      - samsclub
      - grocery

A problem that occurs when managing styles at the component layer is your css clashes across components. I’m particularly not very creative in naming and definitely would have conflicts. We are moving towards using [CSS modules](https://github.com/css-modules/css-modules) (who have a really brilliant logo) which help remove the problem of accidental clashing (already supported in our archetype).

On the topic of icons, we abstract common icons into a separate GitHub organization and import them into components as required.

These tenant-specific CSS files and icons are bundled using Webpack at build time.

### Content Differences

Different brands also have different content requirements based on the region they are serving. A super simple example is, walmart.com and walmart.ca say “add to cart”, but asda.com just says “add”, while our George clothing brand says “add to basket”, and our grocery.walmart.com has an icon.

![](https://cdn-images-1.medium.com/max/1600/1*a-3DlvR6-xabNhFenEcRkg.png)

We use [React-Intl](https://github.com/yahoo/react-intl) for the heavy lifting of content management. Content is managed at a component level, very similar to styling and each tenant has their own content file. You would specify content that is specific to your tenant/brand in your tenant content folder (just like CSS), but the unique part about content is that for unspecified keys, we default to walmart.com content. During build time of the component, based on your tenant build parameter, our webpack build will only keep your tenant content plus the default unspecified keys from walmart.com content.

### Larger Differences

Even larger differences between tenants, such as DOM variations within shared components we have two different strategies. For minor DOM variations, we use component props to enable, disable, and manipulate child components. An example of this is our login form; Sam’s Club likes to have a little “SHOW PASSWORD” button inside the password form while Walmart does not. I would make a prop called “displayShowPassword” which would manage this tenant specific feature.

One thing to note, if you heavily rely on using props to manage different tenant features, it can make your components larger in size, making it more unwieldy to manage in development as well as have a bigger file footprint. This is especially true if you have code paths that are mutually exclusive to tenants. We are working on solutions to manage that.

For larger changes, we use higher-order components and composed components. Of course, this requires that each shared component be built with this sort of configurability in mind from day one, which involves forethought when initially developing. In the long run, however, we find the reusability payoff to be worth the extra up-front thinking.

### Example of Large Difference

We will take the “Login use case” for 2 different tenants. Consider the picture below, where on the left hand side of the image expects an email, password and also shows Forgot password link and Sign In Button. On the right hand side, we take an email and password along with a ***header*** with ***few additional more links*** along with the sign In Button. We can clearly see that there are elements in the UI that are shareable between the tenants (for example both the tenants expect an email address/password and allows the user to sign in) but there are tenant specific functional variations as well (for eg the tenant on the right needs additional links and header).

Now, before we dive into the how, I want to address the question of “these seem like really different pieces of UI, why are we trying to make it multi brand instead of building a new one?” While the components look quite different, the amount of effort it would take to extend an existing component is smaller than making a new one in the long term (and usually in the short term as well). For example, in login, you might have special security or privacy requirements that must be taken care of which are not visible off the bat, then ensure you have ADA compliance, then you support all the browsers and mweb, handle errors cases, write automation for the forms (oh yeah, we share automation too), make the API calls and other data business (remember, we share our redux too). You get all of this out of the box with the initial component that would all have to be duplicated. In the future, there is also the fact that samsclub might want “show password” if it converts better or maybe walmart wants a create account section. In essence, as one team does bug fixes or a/b tests and has improvements to the forms, these increases are shared across all the tenants/brands.

Okay, sorry for the side tracking on the why, let’s talk about how do we solve the problem of code sharing and at the same time provide customization/extensibility?

Well, we will apply 2 of the points discussed above, **Composition** and use **props** to control features within a component,

![](https://cdn-images-1.medium.com/max/1600/1*3w8MYZu8-HuChhbQPSrlSg.gif)


![](https://cdn-images-1.medium.com/max/1600/0*X8Kmo4nhFo0ZvJea.)

We will take a different example solving a problem from Aspect oriented programming world. **Aspect-oriented programming** (**AOP**) is a programming paradigm that aims to increase modularity by allowing the separation of cross-cutting concerns. In this example we will try to do **“analytics tracking”** for React components, which is a cross cutting concern.How do we solve this problem?

Well, we will apply the concept of “Higher Order Components” mentioned above.

![](https://cdn-images-1.medium.com/max/1600/0*7Dfmiy7JH4clBEnW.)

If the tenants have different ways in which they do tracking, then we will have different HOC specific for each tenant.

On top of the above mentioned strategies, make sure components are coded by adhering to basic software development principles like ***Single Responsibility Principle,*** ***Dont Repeat Yourself(DRY)*** etc., which aides in code sharing between different tenants.

These are the basic elements of our multi-tenancy strategy at @WalmartLabs. We’ve found this to be a great foundation for developing robust, maintainable applications that share a common backend without sacrificing localization and branding.