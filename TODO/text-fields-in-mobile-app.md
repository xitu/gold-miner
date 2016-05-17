>* 原文链接 : [Text Fields in Mobile App](https://uxplanet.org/text-fields-in-mobile-app-11d41f13e31#.pjomtd59r)
* 原文作者 : [Nick Babich](http://babich.biz/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:

![](https://cdn-images-1.medium.com/max/800/1*Mv1Jk8roDxeLZ8j1DoYNfQ.png)

<figcaption>Image credit: Material Design</figcaption>

Mobile devices have many challenges when it comes to UX design. One of the most obvious design challenge is dealing with the limited screen real estate during tap input. It is critical that product designers, developer and product managers understand the best ways to make this process really simple for users.

This article highlights three key factors that improve data input, which are _speed up input_, _providing help and assistance for users_ and _indicating problems directly related to the user’s input_.

### Input

#### Match the Keyboard With the Required Text Inputs

App users appreciate apps that provide an appropriate keyboard for text entry. Unlike physical keyboards, touch keyboards can be optimized for each form field the user has to fill out and the type of text field determines what kind of characters are allowed inside the field. Common input types for which you should optimize include:

*   _Number_: phone number, credit card number, PIN
*   _Text_: proper name, username
*   _Mixed format_: email address, street address, search query

Ensure that this matching is implemented **consistently** throughout the app rather than only for certain tasks but not others.

![](https://cdn-images-1.medium.com/max/800/1*kxiM7U6cuaB-NQUpn-Nr8g.png)

<figcaption>Image credit: Google</figcaption>

#### Configure Auto-Capitalization Appropriately

Configuring auto-capitalization settings appropriately is important to _mobile form field usability._ The first letter in each text field should be capitalized if required by the locale, as well as the first letter of each sentence. For example, this is especially relevant for input fields that:

*   Ask to name something, such as a user‘s first or last name
*   Contain sentence-like messages, such as text messages

However, you should disable auto-capitalization in email field, because when it’s turned on users might go back and delete the first capital letters as they fear e-mail delivery issues.

![](https://cdn-images-1.medium.com/max/800/1*f64JtWvrYIPddHciDaOC0Q.png)

<figcaption>Image credit: Baymard</figcaption>

#### Disable Auto-Correct When the Dictionary is Weak

_Poor auto-correction is frustrating when users notice it, and can be downright harmful when they don’t._ Auto-correct often works very poorly for things like abbreviations, street names, emails, person names, and other words that aren’t in the dictionary.

Old version of the Amazon’s mobile app had auto-correct mode turned-on for the address field, which caused valid entries to be overwritten by auto-correct.

![](https://cdn-images-1.medium.com/max/800/1*OWDLp1jvxj2PyFy08Bxc4g.png)

<figcaption>Image credit: Baymard</figcaption>

This usually happens because _users generally focus on what they are typing instead of what they had typed_. In case of address information, this lead to valid addresses being auto-corrected into invalid ones, and thereafter submitted because the user failed to notice an auto-correction had taken place.

#### **Fixed Input Format**

_Don’t use fixed input format._ The most common reason for forcing a fixed format is validation script limitation (your back-end can’t determine the format it needs). In most cases it’s a problem of development, not user. Rather than forcing the format of something like a phone number during user input, you should make it possible to transform whatever the user entered into the format you want to display or store.

![](https://cdn-images-1.medium.com/max/800/1*9Khj17wpCJc2RntjrNbsWQ.png)

<figcaption>Image credits: Google</figcaption>

#### Default Values and Autocomplete

You should anticipate frequently selected items and make data entry easier for the user by providing fields with pre-populated _smart_ _default values_ or prompts based on previously entered data. For example, you can pre-select the user’s country based on their geo location data.

This solution can be paired with autocomplete functionality, which significantly speeds up the user’s actions. Autocomplete presents real-time suggestions or completions in dropdowns, so users can enter information more accurately and efficiently. It’s especially valuable for users with limited text literacy or who have difficulty with spelling, especially if they are using a non-native language.

![](https://cdn-images-1.medium.com/max/800/1*eItk9M2fg9Li6ZEh9xziEg.png)

<figcaption>Text field with suggestions. Image credit: Material Design</figcaption>

### Labels and Helpful Information

The user wants to know what kind of data to enter in an input field and clear label text is one of the primary ways to make your UI more accessible. _Labels_ tell the user the purpose of the text field, maintain their usefulness when focus is placed inside of the field and should remain even after completing the field.

You can also provide _helpful information_ in context of the input field. Have relevant, in-context information ready to assist users to move through the process easily.

#### Limited Number of Words

_Labels_ _aren’t help texts_. You should use succinct, short and descriptive labels (a word or two) so users can quickly scan your text fields.

![](https://cdn-images-1.medium.com/max/800/1*8qJ_57advUKzVHH73yQ_Pg.png)

<figcaption>‘Phone’, ‘Check in’, ‘Check out’ are labels for input fields</figcaption>

If you need more information about fields, helpful information can be a great way of eliminating confusion and possible errors that the user might face when dealing with them.

![](https://cdn-images-1.medium.com/max/800/1*3fHQN7BHQUaBFK31Zr1hbg.png)

<figcaption>Information below ‘Phone’ field is help text. Image credit: Google</figcaption>

#### Simple Language

_Speak the same language as your users._ Unknown terms or phrases will increase cognitive load for the user. Clear communication and functionality should always take precedence over professional jargon and brand messaging.

![](https://cdn-images-1.medium.com/max/800/1*P3dJ7JrBTBNKKqvC3eSVsA.png)

<figcaption>Left: Unconventional terminology can confuse users. Right: Terminology is clear and good for comprehension</figcaption>

#### Inline Labels

Inline labels (or placeholder text) work great for simple fields like username or password.

![](https://cdn-images-1.medium.com/max/800/1*knRzBR03ppWJJ1Ka5BYkRg.gif)

<figcaption>Image credit: [snapwi](https://www.snapwi.re/)</figcaption>

But it’s a _poor replacement_ for separate text labels when there is more than 2 text fields on the screen. Yes they are very popular, and yes they do look nice, but they have two serious problems:

*   Once the user clicks on the text field, the label disappears and thus the user cannot double check that what he/she has written is indeed what was meant to be written.
*   When users see something written inside a text box, they may assume that it has already been prefilled in and may hence ignore it.

Good solution for the placeholder text is a _floating label —_ when the user engages with the text input field, the floating inline labels move to float above the field.

![](https://cdn-images-1.medium.com/max/800/1*5bTgQotfDCuGQDN2aT1lbA.gif)

<figcaption>Floating inline labels. Source: [Dribbble](https://dribbble.com/shots/1254439--GIF-Float-Label-Form-Interaction)</figcaption>

**Takeaway:** Don’t just rely on placeholders, include a label as well. As once a field has been filled out, the placeholder is no longer visible. You can use floating label which ensure users that they filled out the correct field.

#### Label Color

The label’s color should reflect your app’s color palette, while also meeting appropriate contrast ratios (shouldn’t be too bright or too dark).

![](https://cdn-images-1.medium.com/max/800/1*q7wWnvpes3AzaGdI4H7M6g.png)

<figcaption>Image credit: Material Design</figcaption>

### Validation

Field validations is meant to have _conversations with users_ and _guide them_ through the difficult times of errors and uncertainty. The output of this process is _emotional_ rather than technical. One of the most important, and often unloved parts of data processing, _is error handling_. It’s human nature to make mistakes though, and your input field probably isn’t exempt to human error. When done right, validation can turn an ambiguous interaction into a clear one.

#### _Real-time Validation_

Users dislike when they go through the process of data input only to find out at submission, that they’ve made an error. _The right time_ to inform about the success/failure of provided data is right after the user has submitted the information.

_Real-time inline validation_ immediately informs users about the correctness of provided data. This approach allows users to correct the errors they make faster without having to wait until they press the submit button to see the errors. Use a contrasting color for error states, such as a warmer hue like red or orange.

![](https://cdn-images-1.medium.com/max/800/1*hwtem6mCBFr-ebuwD7mjGw.png)

<figcaption>Validation at submission vs. real-time validation. Image credit: Google</figcaption>

The validation shouldn’t only tell users what they did wrong, but it should alsotell _them what they’re doing right_. This gives users more confidence to move through the input process.

![](https://cdn-images-1.medium.com/max/800/1*kuLnXBjp_4KZx9KRktKnSQ.gif)

<figcaption>Image credits: [Dribbble](https://dribbble.com/shots/1059244-OnSite-Form-Validation-GIF)</figcaption>

#### Clear Message

It should give a direct answer on following user question “What just happened and why?” Your validation message should clearly state:

*   Whatwent wrong and possibly why_._
*   What’s the next step the user should take to fix the error.

Again, it should _avoid using technical jargon_. The rules are simple, but somehow they are very easy to ignore.

#### Right Color

_Color is one of the best tools to use when designing validation._ It works on an instinctual level, adding red to error messages, yellow to warning messages, and green to success messages is incredibly powerful. Below is a good example of validation for the password text field:

![](https://cdn-images-1.medium.com/max/800/1*9x2dm9CC2TFSVXLx5IrB7A.png)

<figcaption>Warning state for password field</figcaption>

Another good example with using color is a character restriction for the input text field. Character counter with a red line showing that the restriction has been exceeded.

![](https://cdn-images-1.medium.com/max/800/1*88yUJWX9w2VH1TxLvDeqGw.png)

<figcaption>Image credit: Material Design</figcaption>

But don’t rely on color alone for validation messages! [Make sure that interface is accessible for your users](https://uxplanet.org/accessible-interface-design-3c59ee3ec730#.budh6j6jf), it’s a really important aspect of a well executed visual design.

### Conclusion

You should make the process of data enter as easy as it possible. Even minor changes such as auto-capitalization or indicating what information goes in each field can significantly increase input field usability together with overall UX. Think deeply about how the user is actually using your mobile app when they’re able to give inputs and make sure you’re not missing something obvious when designing your app.

