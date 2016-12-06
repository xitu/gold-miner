

# How to create a FRONT END FRAMEWORK with Sketch

![](https://cdn-images-1.medium.com/max/800/1*5XO0vb0mmbRoCLvB1Laxww.png)

Front End Framework
**Some aspects to consider:**

When we work with a big team of designers at the same time in the same project it is difficult to be aligned, and even more so when the project is an ecosystem of applications that must follow an aesthetic line and comply with certain guidelines that specify behaviors and interactions.

One of the ways that we can take to generate a “normalization” in the interface is to define a styleguide (thought from a 100% visual perspective) that helps the whole design team to avoid future changes, unnecessary work hours and increase productivity, allowing us to have a better focus on the behavior of components and interactions within the application.

A good style guide must be adopted by all the team members, such as developers, product owners, project managers and even the client, which will generate better communication and greater collaboration between them. To this “evolved” style guide, we call the **Front End Framework (FEF).**

Before starting with the creation process of the *FEF*, it is important to keep some aspects in mind:

> **It must be usable** andit must be easy to integrate into the different work processes.

> **It must be educational** andmust contain examples to help us create new components and interactions.

> **It must be visual** andclear in its specifications.

> **Must be collaborative**, so each member has the possibility to make changes and add new information.

> **Must be updated**, and therefore it should always be stored in a specific repository and whoever makes changes should update the file.

### Let’s start implementing FEF

#### **Step 1, Defining the IA:**

*The first step is to define the content (based on our project we divide it as follows):*

1. **Styling:** color palette, font-family, typography, Icons.
2. **Layouts & page patterns:** different compositions, grids and main navigation.
3. **Navigation elements:** links, tabs and pagination.
4. **Modal windows:** popovers, tooltips, dropdowns, message dialogs.
5. **Entering text:** forms.
6. **Components**

#### **Step 2, creating the FEF content:**

*Styling *— The first thing is to create a primary, secondary color palette and complementary colors, specifying #HEX and where it should be applied.

![](https://cdn-images-1.medium.com/max/800/1*0680BvMRMDvOqv4MRA4VQg.png)

Color Palette
Then create the styles in sketch to be able to optimize the workflow in future designs.

![](https://cdn-images-1.medium.com/max/800/1*21VbE5DSGT7keM78gPgmwQ.png)

Create new shared style
The better the nomenclature of the components in FEF the more organized the style table in sketch.

![](https://cdn-images-1.medium.com/max/800/1*HF9eeJVg8B9SPtTZaILG8g.png)

In this way, if we want to change the color of a component quickly, we can do it from the styles window and we make sure not to add any other color.

![](https://cdn-images-1.medium.com/max/800/1*BECrGby5mDvj2CvH0PD7Tw.gif)

We repeat the **same process** for typographic styles:

![](https://cdn-images-1.medium.com/max/800/1*7Y7b4PgKIfW0ZjfQRVdeYw.png)

1. We detail the fonts that will be used in the designs, primary and secondary.

2. We create styles in Sketch as well as colors

![](https://cdn-images-1.medium.com/max/800/1*r5kXboT_OU3FuvYW-JTdDA.png)

After creating the styles for typographies and colors, add the family of icons that will be use and convert each of them into symbols. So, if someone modifys it, the same change will be repeated in all the places where it is used.

![](https://cdn-images-1.medium.com/max/800/1*zY38WGccGulaGcDx9mN_pQ.png)

**Tip**: Create the same icon in different states and name them in the following way **ComponentName / state / sub-state**, we will be able to access all the states from the main menu easily without having to modify the original icon.

![](https://cdn-images-1.medium.com/max/800/1*Plvt7vP2xWMqdNddWTpAEg.png)

The same process could be applied to those components that have more states, such as checkboxes. In this case the nomenclature would be:

![](https://cdn-images-1.medium.com/max/600/1*x7SSpMS1HYyksCeGDlf0ew.png)

1. *checkbox/normal*
2. *checkbox/hover*
3. *checkbox/focus/minus*
4. *checkbox/focus/check*
5. *checkbox/pressed*
6. *checkbox/disabled/check*
7. *checkbox/disabled*

The following will be display inside the **insert** dropdown in the top bar:

![](https://cdn-images-1.medium.com/max/800/1*kBtWUmlgfvJ9eTjD4B3srg.png)

In this way changing from one state to another is much easier, accesible and avoids disorder in the design.

![](https://cdn-images-1.medium.com/max/800/1*O5oibWdHf0nAw2F_H2o3eQ.gif)

### **Step 3, creating components:**

After defining the general styling and having set the styles in sketch, start working on the components that will be repeated throughout the applications ecosystem. (Such as main navigation, drop-downs, popovers, data-grids, etc.). The main reason for this is to be aligned among the team’s designers when creating a new interface.

Here are some of the components that I like to show as an example:

![](https://cdn-images-1.medium.com/max/600/1*RsguKlz0WVVfrxnby2cGGg.png)

Tooltips, in case a designer wants to change the background color, it’s as easy as going to the styles window and selecting the corresponding color.

---

![](https://cdn-images-1.medium.com/max/600/1*rmoiLTbljAL_Iv_jREEfqw.gif)

*Forms — ****Tip****: By creating text fields as a symbol, sketch gives the possibility to modify the content without having to access to the symbol itself.*

**Each component must be accompanied by an explanatory text (when to use it and what behavior must it have).** If necessary you can add a section on the right specifying sizes, margins and styles.

![](https://cdn-images-1.medium.com/max/1000/1*XTVyLYKhaCv1sbPbk36HQQ.png)

![](https://cdn-images-1.medium.com/max/600/1*2czyxGfUjQTlZlVcnYSHvQ.png)

The specifications are focused on providing information to the development team, so they can be added in the same document or use Zeplin as a communication tool. In it you can get the css values and download components.

---

![](https://cdn-images-1.medium.com/max/800/1*jkfloUVJ4GNoYqjxhMkPmg.png)

### **Step 4, behaviors:**

There are components that suffer modifications in their sizes (width and height) depending on the grid we are using, such as data-lists or data-grids. For this type of components sketch provides a series of options that allows predefining the positions of each element and work on what would be a responsive table.

![](https://cdn-images-1.medium.com/freeze/max/30/1*GmMBqaF-_o8DSW15ofCA1Q.gif?q=20)

![](https://cdn-images-1.medium.com/max/800/1*lsv9CluG3SLG1IiUtHrsoQ.gif)

How to achieve this responsive behavior? In the version 39 of sketch, a new window was added with 4 options that allow to achieve it.

![](https://cdn-images-1.medium.com/max/600/1*2fdvGW7BjPqQJux63bv9BQ.png)

The options are:

**Stretch** (default) — Will float and resize the layer when group is resized (this option should be applied for dividing lines, and the rectangles of each row).

**Pin to corner** — Automatically pins the new layer to the nearest corner. Does not resize when group is resized. (The icons on the top right and checkboxes should have this option.)

**Resize object** — Resizes the layer and maintains the layer’s original position when group is resized. (Text fields must have this option to maintain their margin with the dividing line to their left.)

**Float in place** — Layer does not resize, but its position’s percentage is maintained when group is resized. (This option should be applied to icons that must be centered within their column.)

For more information on how to create these tables I recommend the following article: [https://medium.com/sketch-app-sources/https-medium-com-megaroeny-resizing-tables-withsketch-3-9-2e02e6382d3d#.fsx0udd9v](https://medium.com/sketch-app-sources/https-medium-com-megaroeny-resizing-tables-with-sketch-3-9-2e02e6382d3d#.fsx0udd9v)

### **Step 5, References**

Finally, beyond maintaining a design language across all applications, the structure of each element may vary per the requirements and needs of the product.

For this reason, it is recommended to create a last section that shows how the same component is used based on functional needs, so that the designer can analyze and learn how to replicate styles with a different architecture.

![](https://cdn-images-1.medium.com/max/1000/1*7dwpsMQbPutwLDEz8cCzfg.png)

Components

### **A common future**

Working side by side among all team members in a complex project based on a style guide can improve the quality of the work, and collaboration can avoid questions such as “What would be the behavior of “x”component in smaller resolutions?

Many times, we can be focused on launching a first version of the product as fast as possible, therefore problems arise when the product is already live. In such cases, FEF could make a difference and avoid headaches.

Feel free to download the sketch file [https://www.dropbox.com/s/kknipcg3u0e69ds/FEF.sketch?dl=0](https://www.dropbox.com/s/kknipcg3u0e69ds/FEF.sketch?dl=0)
