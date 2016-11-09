> * 原文地址：[Conditions for CSS Variables](http://kizu.ru/en/fun/conditions-for-css-variables/)
* 原文作者：[Roman Komarov](https://twitter.com/kizmarh)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Conditions for CSS Variables


I'll start from this: [there are no](#not-those) (There is a module named “[CSS Conditional Rules](https://www.w3.org/TR/css3-conditional/)”, but don't expect it to cover the CSS variables — it covers some at-rules stuff. There is even a [proposal](https://tabatkins.github.io/specs/css-when-else/) for `@when`/`@else` at-rules, which, again, do not anything in common with variables.)[](#x) conditions in specs to use with [CSS variables](https://www.w3.org/TR/css-variables-1/). I think that this is a really big flaw in specs, as while variables already provide a lot of things that were not possible in any other way before, the absence of conditions is really frustrating, as there could be a lot of uses for them.

But what if we'd need those imaginary conditional statements for our CSS variables _now_? Well, as with a lot of other CSS stuff, we can hack our way around for same cases.

## [](#the-problem-39-s-definition)The Problem's Definition

So, what we need is a way to use a single CSS variable for setting different CSS properties to _different_ values, but not based directly on this variable (that is — those values shouldn't be _calculated_ from our variable). We need **conditions**.

## [](#using-calculations-for-binary-conditions)Using Calculations for Binary Conditions

Long story short, I'll just present the solution to you right now and would explain it later:

    :root {
        --is-big: 0;
    }

    .is-big {
        --is-big: 1;
    }

    .block {
        padding: calc(
            25px * var(--is-big) +
            10px * (1 - var(--is-big))
        );
        border-width: calc(
            3px * var(--is-big) +
            1px * (1 - var(--is-big))
        );
    }

In this example, we're making all our elements with `.block` to have paddings equal to `10px` and border widths to `1px` unless the `--is-big` variable on those elements won't be `1`, in which case they would become `25px` and `3px` respectively.

The mechanism beyond this is rather simple: we use both our possible values in a single calculation using `calc()`, where we nullify one and keep another value based on the variable's value which can be either `1` or `0`. In other words, we'll have `25px * 1 + 10px * 0` in one case and `25px * 0 + 10px * 1` in another.

## [](#more-complex-conditions)More Complex Conditions

We can use this method to choose not only from 2 possible values but for choosing from 3 or more values. However, for each new added possible value the calculation becomes more complex. For choosing between 3 possible values it would already look like this:

    .block {
        padding: calc(
            100px * (1 - var(--foo)) * (2 - var(--foo)) * 0.5 +
             20px * var(--foo) * (2 - var(--foo)) +
              3px * var(--foo) * (1 - var(--foo)) * -0.5
        );
    }

This could accept `0`, `1` and `2` values for `--foo` variable and calculate the padding to `100px`, `20px` or `3px` correspondingly.

The principle is the same: we just need to multiply each possible value to an expression that would be equal to `1` when the condition for this value is the one we need and to `0` in other cases. And this expression can be composed rather easily: we just need to nullify each other possible value of our conditional variable. After doing this we'd need to add our triggering value there to see if we'd need to adjust the result so it would be equal to 1\. And that's it.

### [](#a-possible-trap-in-the-specs)A Possible Trap in the Specs

With the increasing complexity of such calculations, there is a chance at one point they would stop from working. Why? There is this note in [specs](https://drafts.csswg.org/css-values-3/#calc-syntax):

> UAs must support calc() expressions of at least 20 terms, where each NUMBER, DIMENSION, or PERCENTAGE is a term. If a calc() expression contains more than the supported number of terms, it must be treated as if it were invalid.

Of course, I tested this a bit and couldn't found such limitations in the browsers I tested, but there is still a chance either you would write some really complex code that would meet the possible existing limit, or some of the browsers could introduce this limit in the future, so be careful when using really complex calculations.

## [](#conditions-for-colors)Conditions for Colors

As you can see, those calculations could be used only for things that you can _calculate_, so there is no chance we could use it for switching the values of `display` property or any other non-numeric ones. But what about colors? Actually, we can calculate the individual components of the colors. Sadly, right now it would work only in Webkits and Blinks, as [Firefox don't yet support](https://bugzilla.mozilla.org/show_bug.cgi?id=984021 "Bugzilla ticket") `calc()` inside `rgba()` and other color functions.

But when the support would be there (or if you'd like to experiment on this in browsers with an existing support), we could do things like that:

    :root {
        --is-red: 0;
    }

    .block {
        background: rgba(
            calc(
                255*var(--is-red) +
                0*(1 - var(--is-red))
                ),
            calc(
                0*var(--is-red) +
                255*(1 - var(--is-red))
                ),
            0, 1);
    }

Here we'd have lime color by default and red if the `--is-red` would be set to `1` (note that when the component could be zero we could just omit it at all, making out code more compact, here I kept those for clarity of an algorithm).

As you could do those calculations with any components, it is possible to create those conditions for any colors (and maybe even for gradients? You should try it!).

### [](#another-trap-in-the-specs)Another Trap in the Specs

When I was testing how the conditions work for colors, I found out a really, _really_ [weird limitation in Specs](#issue-resolved) (Tab Atkins [commented](https://github.com/kizu/kizu.github.com/issues/186) that this issue with color components was fixed in the specs (but is not yet supported by browsers). Yay! Also he said that as another solution we could just use percentages inside `rgba`, I totally forgot about this feature, haha.)[](#x). It is called [“Type Checking”](https://twitter.com/kizmarh/status/788504161864261632). I now officially hate it. What this means is that if the property accepts only `&lt;integer&gt;` as a value, if you'd have any divisions or non-integers inside the `calc()` for it, even if the result would be integer, the “resolved type” wouldn't be `&lt;integer&gt;`, it would be `&lt;number&gt;`, and that means that those properties won't accept such values. And when we'd have calculations involving more than two possible values, we'd need to have a non-integer modifiers. And that would make our calculation invalid for using with colors or other integer-only properties (like `z-index`).

That is:

    calc(255 * (1 - var(--bar)) * (var(--bar) - 2) * -0.5)

Would be invalid when inside of the `rgba()`. Initially I thought that this behaviour is a bug, especially knowing how the color functions can actually accept the values that go beyond the possible ranges (you can do `rgba(9001, +9001, -9001, 42)` and get a valid yellow color), but this typing thing seems to be too hard for browsers to handle.

#### [](#solutions-)Solutions?

There is one far from perfect solution. As in our case we know both the desired value and the problematic modifier, we can pre-calculate them and then round it up. Yep, that means that the resulting value could be not exactly the same, as we would lose some precision in some cases. But it is better than nothing, right?

But there is another solution that would work for colors — we can use `hsla` instead of `rgba`, as it accepts not integers, but numbers and percentages, so there won't be a conflict in type resolving. But for other properties like `z-index` that solution won't work. But even with this method there still could be some losses in precision if you're going to convert `rgb` to `hsl`. But those should be less than in previous solution.

## [](#preprocessing)Preprocessing

When the conditions are binary it is still possible to write them by hand. But when we're starting to use more complex conditions, or when we're getting to the colors, we'd better have tools that could make it easier to write. Luckily, we have preprocessors for this purpose.

Here is how I managed to quickly do it in [Stylus](#pen) (You can look at [CodePen with this code](http://codepen.io/kizu/pen/zKmyvG) in action.)[](#x):

    conditional($var, $values...)
      $result = ''

      // If there is only an array passed, use its contents
      if length($values) == 1
        $values = $values[0]

      // Validating the values and check if we need to do anything at all
      $type = null
      $equal = true

      for $value, $i in $values
        if $i > 0 and $value != $values[0]
          $equal = false

        $value_type = typeof($value)
        $type = $type || $value_type
        if !($type == 'unit' or $type == 'rgba')
          error('Conditional function can accept only numbers or colors')

        if $type != $value_type
          error('Conditional function can accept only same type values')

      // If all the values are equal, just return one of them
      if $equal
        return $values[0]

      // Handling numbers
      if $type == 'unit'
        $result = 'calc('
        $i_count = 0
        for $value, $i in $values
          $multiplier = ''
          $modifier = 1
          $j_count = 0
          for $j in 0..(length($values) - 1)
            if $j != $i
              $j_count = $j_count + 1
              // We could use just the general multiplier,
              // but for 0 and 1 we can simplify it a bit.
              if $j == 0
                $modifier = $modifier * $i
                $multiplier = $multiplier + $var
              else if $j == 1
                $modifier = $modifier * ($j - $i)
                $multiplier = $multiplier + '(1 - ' + $var + ')'
              else
                $modifier = $modifier * ($i - $j)
                $multiplier = $multiplier + '(' + $var + ' - ' + $j + ')'

              if $j_count  0 ? ' + ' : '') + $value + ' * ' + $multiplier
            $i_count = $i_count + 1

        $result = $result + ')'

      // Handling colors
      if $type == 'rgba'
        $hues = ()
        $saturations = ()
        $lightnesses = ()
        $alphas = ()

        for $value in $values
          push($hues, unit(hue($value), ''))
          push($saturations, saturation($value))
          push($lightnesses, lightness($value))
          push($alphas, alpha($value))

        $result = 'hsla(' + conditional($var, $hues) + ', ' + conditional($var, $saturations) + ', ' + conditional($var, $lightnesses) + ', ' + conditional($var, $alphas) +  ')'

      return unquote($result)

Yep, there is a lot of code, but this mixin can generate conditionals both for numbers and colors, and not only for two possible conditions but for many more.

The usage is really easy:

    border-width: conditional(var(--foo), 10px, 20px)

The first argument is our variable, the second one is the value that should be applied when the variable would be equal to `0`, the third — when it would be equal to `1`, etc.

This above call would generate proper conditional:

    border-width: calc(10px * (1 - var(--foo)) + 20px * var(--foo));

And here is a more complex example for the color conditionals:

    color: conditional(var(--bar), red, lime, rebeccapurple, orange)

Would generate something that you surely wouldn't want to write by hand:

    color: hsla(calc(120 * var(--bar) * (var(--bar) - 2) * (var(--bar) - 3) * 0.5 + 270 * var(--bar) * (1 - var(--bar)) * (var(--bar) - 3) * 0.5 + 38.82352941176471 * var(--bar) * (1 - var(--bar)) * (var(--bar) - 2) * -0.16666666666666666), calc(100% * (1 - var(--bar)) * (var(--bar) - 2) * (var(--bar) - 3) * 0.16666666666666666 + 100% * var(--bar) * (var(--bar) - 2) * (var(--bar) - 3) * 0.5 + 49.99999999999999% * var(--bar) * (1 - var(--bar)) * (var(--bar) - 3) * 0.5 + 100% * var(--bar) * (1 - var(--bar)) * (var(--bar) - 2) * -0.16666666666666666), calc(50% * (1 - var(--bar)) * (var(--bar) - 2) * (var(--bar) - 3) * 0.16666666666666666 + 50% * var(--bar) * (var(--bar) - 2) * (var(--bar) - 3) * 0.5 + 40% * var(--bar) * (1 - var(--bar)) * (var(--bar) - 3) * 0.5 + 50% * var(--bar) * (1 - var(--bar)) * (var(--bar) - 2) * -0.16666666666666666), 1);

Note that there is no detection of `&lt;integer&gt;`-accepting properties, so that won't work for `z-index` and such, but it already converts colors to `hsla()` to make them manageble (though even this could be enhanced so this convertation would happen only when it would be needed). Another thing I didn't implement in this mixin (yet?) is the ability to use CSS variables for the values. This would be possible for non-integer numbers as those values would be inserted as is in the conditional calculations. Maybe, when I'll find time, I'll fix the mixin to accept not only numbers or colors but also variables. For the time being it is still possible to do using the algorithm explained in this article.

## [](#fallbacks)Fallbacks

Of course, if you're planning to actually use this, you'll need to have a way to set fallbacks. They're easy for browsers that just don't support variables: you just declare the fallback value before the conditional declaration:

    .block {
        padding: 100px; /* fallback */
        padding: calc(
            100px * ((1 - var(--foo)) * (2 - var(--foo)) / 2) +
             20px * (var(--foo) * (2 - var(--foo))) +
              3px * (var(--foo) * (1 - var(--foo)) / -2)
        );
    }

But when it comes to colors we have a problem: when there is a support for variables, in fact (and that's another really weird place in specs), _just any_ declaration containing variables would be considered valid. And this means that it is not possible in CSS to make a fallback for something containing variables:

    background: blue;
    background: I 💩 CSS VAR(--I)ABLES;

Is valid CSS and per specs, the background would get an `initial` value, not the one provided in a fallback (even though it is obvious that the other parts of the value are incorrect).

So, what we need in order to provide a fallback in those cases — add `@support` wrapper that would test the support for everything **except** for the variables.

In our case, we need to wrap our conditional colors for Firefox in something like this:

    .block {
        color: #f00;
    }
    @supports (color: rgb(0, calc(0), 0)) {
        .block {
            color: rgba(calc(255 * (1 - var(--foo))), calc(255 * var(--foo)), 0, 1);
      }
    }

Here we're testing a support for calculations inside color functions and applying the conditional color only in that case.

It is also possible to create such fallbacks automatically, but I won't recommend you to use preprocessors for them as the complexity of creating such stuff is much more than the capabilities preprocessors provide.

## [](#use-cases)Use Cases

I really don't like to provide use cases for the things the need for which is obvious. So I'll be brief. And I'll state not only the conditions for variables, but also the general conditions, like for the result of `calc()`.

*   The conditions for CSS variables would be perfect for themifying blocks. This way you could have a number of numbered themes and then apply them to blocks (and nested ones!) using just one CSS variable like `--block-variant: 1`. This is not something that is possible through any other means other than variables and when you'd want to have different values for different props in different themes, without the conditionals you'd need to have many different variables and apply all of them in every case.

*   Typography. If it was possible to use the `&lt;`, `&lt;=`, `&gt;` and `&gt;=` in conditions for variables, it would be possible to have a number of “rules” for different font sizes, so you could set different line heights, font weights and other properties based on the given font-size. This is possible now, but now when you need to have some “stops” for those valuea and not just the values derived from `em`s.

*   Responsive design. Well, if there were the conditions for calculations, then it would be almost the same as those elusive “element queries” — you could check the `vw` or the parent's widths in percents and decide what to apply in different cases.

There can be other use cases, tell me if you'd find one! I'm sure I had more of them myself, but I don't have that good of a memory to remember all the things I ever wanted to do with CSS. Because its all the things.

## [](#future)Future

I would really like to see conditions described in CSS specs, so we would not rely on calc hacks and could use proper conditions for non-calculatable values too. It is also impossible right now to have conditions other than strict equality, so no “when the variable is more than X” and other stuff like that. I don't see any reasons why we can't have proper conditions in CSS, so if you know a fellow spec developer, hint them about this issue. My only hope is that they won't tell us to “just use JS” or find out excuses of why that wouldn't ever be possible. Here, it is already possible now using the hacks, there can't be any excuses.

Published on October 21, in [Experiments](../).



If you've spotted a typo or a mistake, or wish to add something on, you could either [write me about this](https://github.com/kizu/kizu.github.com/issues/new?title=Feedback%20for%20%E2%80%9CConditions%20for%20CSS%20Variables%E2%80%9D) or [edit this article on Github](https://github.com/kizu/kizu.github.com/blob/source/src/documents/posts/2016-10-21-(fun)-conditions-for-css-variables/index.en.md).



