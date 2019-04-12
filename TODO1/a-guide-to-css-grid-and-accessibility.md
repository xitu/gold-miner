# How to Keep Your CSS Grid Layouts Accessible

CSS Grid makes it possible to create two-dimensional layouts by arranging elements into rows and columns. It allows you to define any aspect of your grid, from the width and height of grid tracks, to grid areas, to the size of gaps. However, CSS Grid can also lead to accessibility issues, mainly for screen reader and keyboard-only users. This guide will help you avoid those issues.

## Source Order Independence

"Source order independence" is one of the biggest advantages of CSS Grid. It means you don't have to define the layout structure in HTML anymore, which has always been the case with floats and table-based layouts. You can change the visual presentation of your HTML file using CSS Grid's ordering and grid placement properties. 

The [Reordering and Accessibility](https://www.w3.org/TR/css-grid-1/#source-independence) section of W3C's CSS Grid docs defines source order independence as follows:

> "By combining grid layout with media queries, the author is able to use the same semantic markup, but rearrange the layout of elements independent of their source order, to achieve the desired layout in both orientations."

With CSS Grid, you can decouple logical and visual order. Source order independence can be quite useful in many cases, however it can also seriously damage accessibility. Screen reader and keyboard users only encounter the logical order of your HTML document and don't "see" the visual order you created with CSS Grid. 

If you have a simple document this usually isn't a problem, as the logical and visual order will most likely be the same. However, more complicated, asymmetrical, broken, or other creative layouts frequently cause problems for screen reader and keyboard-only users.

### Properties That Change Visual Order

CSS Grid has a number of properties that change the visual order of a document:

-   `[order](https://developer.mozilla.org/en-US/docs/Web/CSS/order)` - works with both [flexbox](https://webdesign.tutsplus.com/tutorials/a-comprehensive-guide-to-flexbox-ordering-reordering--cms-31564) and CSS Grid. It changes the default order of items inside a flex or grid container.
-   grid placement properties - `[grid-row-start](https://developer.mozilla.org/en-US/docs/Web/CSS/grid-row-start)`, `[grid-row-end](https://developer.mozilla.org/en-US/docs/Web/CSS/grid-row-end)`, `[grid-column-start](https://developer.mozilla.org/en-US/docs/Web/CSS/grid-column-start)`, [`grid-column-end`](https://developer.mozilla.org/en-US/docs/Web/CSS/grid-column-end).
-   shorthands for the aforementioned grid placement properties - `[grid-row](https://developer.mozilla.org/en-US/docs/Web/CSS/grid-row)`, `[grid-column](https://developer.mozilla.org/en-US/docs/Web/CSS/grid-column)`, and `[grid-area](https://developer.mozilla.org/en-US/docs/Web/CSS/grid-area)` (shorthand for `grid-row` and `grid-column`).
-   `[grid-template-areas](https://developer.mozilla.org/en-US/docs/Web/CSS/grid-template-areas)` - specifies the placement of named grid areas.

If you want to read more about how to use grid placement properties, have a look at our previous article on [grid areas](https://webdesign.tutsplus.com/tutorials/css-grid-layout-using-grid-areas--cms-27264). Now, let's see how things can go wrong with visual reordering. 

-   [![](https://cms-assets.tutsplus.com/uploads/users/30/posts/27264/preview_image/grid-pre-3.png)

    CSS GRID LAYOUT

    CSS Grid Layout: Using Grid Areas

    Ian Yates

    ](https://webdesign.tutsplus.com/tutorials/css-grid-layout-using-grid-areas--cms-27264)

## Visual vs. Logical Reordering

Here is a simple Grid with a couple of links so that you can test the code for keyboard accessibility:

```html
<div class="container">
    <div class="item-1"><a href="#">Link 1</a></div>
    <div class="item-2"><a href="#">Link 2</a></div>
    <div class="item-3"><a href="#">Link 3</a></div>
    <div class="item-4"><a href="#">Link 4</a></div>
    <div class="item-5"><a href="#">Link 5</a></div>
    <div class="item-6"><a href="#">Link 6</a></div>
</div>
```

Now let's add some styles. The following CSS arranges grid items in three equal columns. Then the first item is moved to the beginning of the second row with the `grid-row` property:

```css
.container {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  grid-gap: 0.625rem;
}
 
.item-1 {
  grid-row: 2;
}
```

Below, you can see how it looks like with some additional styling for clarity. While regular users will see **Link 2** first, screen readers will start with **Link 1**, as they follow the source order defined in the HTML code. 

It will also be difficult for keyboard users to tab through the page, as tabbing will also start with **Link 1**, at the bottom left corner of the page (try it yourself).

### The Solution

The solution is simple and elegant. Instead of changing the visual order, you need to move Link 1 down in the HTML. This way, the logical and visual order of the document will be the same.

```html
<div class="container">
  <div class="item-2"><a href="#">Link 2</a></div>
  <div class="item-3"><a href="#">Link 3</a></div>
  <div class="item-4"><a href="#">Link 4</a></div>
  <div class="item-1"><a href="#">Link 1</a></div>
  <div class="item-5"><a href="#">Link 5</a></div>
  <div class="item-6"><a href="#">Link 6</a></div>
</div>
```

You won't need to add any Grid-related properties to `.item-1` in the CSS. As you don't want to change the default source order, you only need to define the properties of the grid container.

```css
.container {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  grid-gap: 0.625rem;
}
```

Take a look. Although the demo below looks the same as before, it's now accessible. Both tabbing and screen reading will start with Link 2 and logically follow the source order.

## How to Make Layouts Accessible

There are a couple of common layout patterns you can make more accessible using CSS Grid's reordering properties. For instance, the "Holy Grail Layout" is just such a pattern. It consists of a header, a main content area, a footer, and two fixed-width sidebars: one on the left and one on the right. 

Left-sidebar layouts might cause issues for screen reader users. As the left sidebar precedes the main content area in the source order, that's what screen readers read aloud first. However, in most cases, it would be better if screen reader users could start right with the main content. This is especially true if the left sidebar contains mainly ads, blogrolls, tag clouds, or other less relevant content.

CSS Grid allows you to change the source order of your HTML document and place the main content area *before* the two sidebars:

```html
<div class="container">
    <header>Header</header>
    <main>Main content</main>
    <aside class="left-sidebar">Left sidebar</aside>
    <aside class="right-sidebar">Right sidebar</aside>
    <footer>Footer</footer>
</div>
```

There are different solutions you can use to define the modified visual order with CSS Grid. Most tutorials make use of named grid areas and rearrange them with the `grid-template-areas` property.

The code below is the simplest solution, as it only adds extra rules to elements where the visual order is different from the source order. CSS Grid has an excellent auto-placement feature that takes care of the rest of grid items.

```css
.container {
  display: grid;
  grid-template-columns: 9.375rem 1fr 9.375rem;
  grid-gap: 0.625rem;
}
header, 
footer {
  grid-column: 1 / span 3;
}
.left-sidebar {
  grid-area: 2 / 1;
}
```

So, `grid-column` makes `<header>` and `<footer>` span across the whole screen (3 columns) and `grid-area` (shorthand for `grid-row` and `grid-column`) fixes the place of the left sidebar. Here's how it looks like with some extra styling:

Although the Holy Grail Layout is a fairly simple layout, you can use the same logic with more complicated layouts, too. Always think about which is the most important part of your page that screen reader users might want to access first, before the rest of your content.

## When Semantics is Lost

In some cases, CSS Grid can also harm semantics; another important aspect of accessibility. As the `display: grid;` layout is only inherited by the direct children of an element, children of grid items won't be part of the grid. To save work, developers might find it a good solution to flatten layouts so that every item they want to include in the grid layout will be a direct child of the grid container. However, when a layout is artificially flattened, the semantic meaning of the document is frequently lost.

Say you want to create a gallery of items (e.g. images) in which the elements are displayed as a grid and encompassed by a header and a footer. Here's how the semantic markup would look:  

```html
<section class="container">
    <header>Header</header>
    <ul>
        <li>Item 1</li>
        <li>Item 2</li>
        <li>Item 3</li>
        <li>Item 4</li>
        <li>Item 5</li>
        <li>Item 6</li>
    </ul>
    <footer>Footer</footer>
</section>
```

If you wanted to use CSS Grid, `<section>` would be the grid container and `<h1>`, `<h2>`, and `<ul>` would be the grid items. However, list items would be excluded from the grid, as they would be only the *grandchildren* of the grid container. 

So, if you want to do the job quickly, it might seem a good idea to flatten the layout structure by making all items the direct children of the grid container:

```html
<section class="container">
    <header>Header</header>
    <div class="item">Item 1</div>
    <div class="item">Item 2</div>
    <div class="item">Item 3</div>
    <div class="item">Item 4</div>
    <div class="item">Item 5</div>
    <div class="item">Item 6</div>
    <footer>Footer</footer>
</section>
```

Now, you can easily create the layout you want with CSS Grid:

```css
.container {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    grid-gap: 0.625rem;
}
header,
footer {
    grid-column: 1 / span 3;
}
```

Everything *looks* nice, however the document has lost its semantic meaning, so:

-   screen reader users won't know that your items are related to each other and part of the same list (most screen readers notify users about the number of list items); 
-   broken semantics will make it harder for search engines to understand your content;
-   people accessing your content with disabled CSS (for instance, in low connectivity areas) might have issues with skimming through your page, as they'll see only unrelated divs.

As a rule of thumb, you should never compromise semantics for aesthetics. 

### The Solution

The current solution is to create a nested grid by adding the following CSS rules to the unordered list:

```css
.container {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    grid-gap: 0.625rem;
}
.container > * {
    grid-column: 1 / span 3;
}
ul {
    display: inherit;
    grid-template-columns: inherit;
    grid-gap: inherit;
}
```

In the demo below, you can see how the nested grid relates to the parent grid. The items are laid out as expected, however, the document still retains its semantic meaning.

## Conclusion

Simple implementations of the CSS Grid layout aren't likely to lead to accessibility issues. Problems occur when you want to change the visual order or create multi-level grids. The solution usually doesn't take much work, so it's always worth fixing a11y issues as you can make it much easier for assistive technology users to properly access your content.
