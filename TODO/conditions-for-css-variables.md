> * 原文地址：[Conditions for CSS Variables](http://kizu.ru/en/fun/conditions-for-css-variables/)
* 原文作者：[Roman Komarov](https://twitter.com/kizmarh)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[rottenpen](https://github.com/rottenpen)
* 校对者：[cyseria](https://github.com/cyseria) [Tina92](https://github.com/Tina92)

# CSS 变量的条件

我将从这里开始：[不是这](#not-those)（这是一个名为“[ CSS 的条件规则](https://www.w3.org/TR/css3-conditional/)模块”，但不要期望着它能包含 CSS 的变量 —— 它涵盖了一些 @规则（at-rules）。甚至有一个关于 `@when`/`@else` @规则的[提议](https://tabatkins.github.io/specs/css-when-else/)，再次，与变量没有什么共同点。）[](#x) 规范使用 [ CSS 变量](https://www.w3.org/TR/css-variables-1/) 的条件。我认为这是在规范里的一个重大缺陷。因为变量已经提供了许多以前无法实现的东西。没有条件是真的令人沮丧，因为它们可能有很多用途。

但如果我们现在需要那些虚构的条件语句用在 CSS 变量上呢？好，正如一些其他的 CSS 参考手册，我们可以在相同情况下进行 hack 。

## [](#the-problem-39-s-definition)问题的定义

因此，我们需要的是一种简单的 CSS 变量使用方法，为不同的值设定不同的 CSS 特征。但这种方法并不能直接源于变量（就是说——它们的值不能通过我们的变量计算出来）。这时候我们需要规定**条件**。

## [](#using-calculations-for-binary-conditions)使用二元条件的计算

长话短说，我马上就介绍解决方法给你，稍后还有它的解释：

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

在这个例子中，我们将所有的 `.block` 元素设定 padding 为 `10px` ， border 设定为 `1px` ，一旦这些元素的 `--is-big` 变量值等于`1`，它们的值会分别变为 `25px` 和 `3px`。

想跳过这个机制相当简单：我们可以在使用到 'calc()' 的计算中，基于变量的值选择保留其中一个有可能的值并且废除另一个值，该值可以是 '1' 或 '0'。换句话说，我们会在一个案例中遇到 `25px * 1 + 10px * 0` ，而在另外一个案例中遇到 `25px * 0 + 10px * 1`。

## [](#more-complex-conditions)更复杂的条件

我们使用此方法不仅可以从 2 个有可能的值中选择，而且可以从 3 个或更多个值中进行选择。然而，每添加一个新的可能值，都会使计算更加复杂。为了在 3 个可能值之间进行选择，它将看起来像这样：

    .block {
        padding: calc(
            100px * (1 - var(--foo)) * (2 - var(--foo)) * 0.5 +
             20px * var(--foo) * (2 - var(--foo)) +
              3px * var(--foo) * (1 - var(--foo)) * -0.5
        );
    }

这里变量 `-foo` 可以接受 `0` ， `1` 和 `2` ，并且相应的将元素的 padding 设为 `100px`，`20px`或`3px`。

原理是一样的：我们只需要将每个可能的值乘以一个表达式，当这个值的条件是我们需要的值时，该值等于`1`，在其他情况下为`0`。并且这个表达式可以很容易地组成：我们只需要使我们的条件变量的每个其他可能的值无效而已。 这样做后，我们需要在那里添加触发值，看看是否需要调整结果，使其等于 1\。就是这样。

### [](#a-possible-trap-in-the-specs)在规格中可能的陷阱

随着这种计算复杂性的增加，在某个点，它们有可能失效。为什么？这个笔记在[规范中](https://drafts.csswg.org/css-values-3/#calc-syntax):

> 用户代理必须支持至少20个术语的 calc（） 表达式，其中每个数字，尺寸描述或百分比都是是一个术语。如果 calc（） 表达式中包含的术语超过了这个范围，则必须视其无效。

当然，我测试过这一点，在我测试的浏览器中没找到这样的限制。但在你写一些真正复杂的代码时候，或者未来一些浏览器引入这个限制的时候可能，就有机会达到这个限制了，所以在使用真正复杂的计算时你要小心了。

## [](#conditions-for-colors)颜色的条件

你可以看到，这些数值只能用于你可以 **计算** 的东西，所以我们没有办法使用它来切换 `display` 属性或任何其他非数字的值。但是颜色怎么样？实际上，我们可以计算颜色的各个组成部分。可悲的是，现在它只能在 Webkits 和 Blinks 中工作，例如 [ Firefox 还不支持](https://bugzilla.mozilla.org/show_bug.cgi?id=984021 "Bugzilla ticket") 在 `rgba()` 里使用 `calc()` 和其他数学函数。

不过当支持将在哪里（或者如果你想在浏览器中使用现有的支持进行实验时），我们可以做这样的事情：

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

这里我们默认使用灰色，如果 `--is-red` 被设置为 `1` ，则为红色（请注意，该组件可以是零，我们可以忽略它，使制作出来的代码更紧凑，这里我保留了那些关于清晰度的算法）。

正如你可以在任何组件进行这些计算，你完全可以为任何颜色创建这些条件（甚至可以是渐变色，你应该尝试！）。

### [](#another-trap-in-the-specs)规范中的另一个陷阱

当我测试颜色的条件如何工作，我发现了一个**真正**[规格中的奇怪限制](#issue-resolved) (Tab Atkins 的这个[问题](https://github.com/kizu/kizu.github.com/issues/186) 与颜色组件是固定的规格（但浏览器尚未支持）。好极了！另外他说，作为另一个解决方案，我们可以使用 `rgba` 里面的百分比，我完全忘了这个功能，哈哈。)[](#x). 这叫做 [“Type Checking”](https://twitter.com/kizmarh/status/788504161864261632)。我现在正式地讨厌它了。这意味着如果属性只接受 `<integer>` 作为值，或者你在 `calc()` 里面有任何分割或非整数，哪怕结果是整数, “resolved type” 都不会是 `<integer>` ，它将是 `<integer>` ，这意味着这些属性不会接受这样的值。当我们计算涉及两个以上的可能值时，我们需要一个非整数修饰符。这将使我们的计算对于使用颜色或其他只有整数的属性（如 `z-index` ）无效。

如下所示:

    calc(255 * (1 - var(--bar)) * (var(--bar) - 2) * -0.5)

这在 `rgba（）` 里面是无效的。 最初我认为这种行为是一个错误，特别是知道颜色函数实际接受的值是怎样超出可能范围的值（你可以做 `rgba（9001，+9001，-9001，42）` ，并得到一个有效的黄色），但这类东西似乎太难以让浏览器来处理。

#### [](#solutions-)解决方案？

有一个不怎么完美的解决方案。在我们的例子中，我们知道期望的值和有问题的修饰符，我们可以预先计算它们，然后四舍五入。是的，这意味着结果值可能不完全相同，因为我们将失去一些精度在某些情况下。但它比没有什么好，对吧？

但是有另一个解决方案可以用于颜色 —— 我们可以使用 `hsla` 取代 `rgba` ，因为它不接受整数，而是数字和百分比，因此类型解析中不会有冲突。但是对于其他属性，如 `z-index` ，解决方案将不工作。但即使使用这种方法，如果你要将 `rgb` 转换为 `hsl` ，仍然会有一些精度的损失。但是应该比以前的解决方案少。

## [](#preprocessing)预处理
当条件是二进制时，你仍然可以用手写。但是当我们开始使用更复杂的条件时，或者当我们得到颜色时，我们最好有一些工具，使写入更容易。幸运的是，我们有预处理器。


这里是我设法做的 [Stylus](#pen) (你可以看看 [ CodePen 里的这个代码](http://codepen.io/kizu/pen/zKmyvG) )[](#x)：

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


是的，这有很多代码，但是这个 mixin 可以生成包括数字和颜色在内的多种有可能的条件。

它的的使用方法很简单:

    border-width: conditional(var(--foo), 10px, 20px)


第一个参数是我们的变量，第二个参数当变量等于 `0` 时应用的值，第三个是当它等于`1`时......

这个调用会产生正确的条件：

    border-width: calc(10px * (1 - var(--foo)) + 20px * var(--foo));

这里是一个更加复杂的颜色条件例子：

    color: conditional(var(--bar), red, lime, rebeccapurple, orange)

这还会产生一些你肯定不想手写的东西：

    color: hsla(calc(120 * var(--bar) * (var(--bar) - 2) * (var(--bar) - 3) * 0.5 + 270 * var(--bar) * (1 - var(--bar)) * (var(--bar) - 3) * 0.5 + 38.82352941176471 * var(--bar) * (1 - var(--bar)) * (var(--bar) - 2) * -0.16666666666666666), calc(100% * (1 - var(--bar)) * (var(--bar) - 2) * (var(--bar) - 3) * 0.16666666666666666 + 100% * var(--bar) * (var(--bar) - 2) * (var(--bar) - 3) * 0.5 + 49.99999999999999% * var(--bar) * (1 - var(--bar)) * (var(--bar) - 3) * 0.5 + 100% * var(--bar) * (1 - var(--bar)) * (var(--bar) - 2) * -0.16666666666666666), calc(50% * (1 - var(--bar)) * (var(--bar) - 2) * (var(--bar) - 3) * 0.16666666666666666 + 50% * var(--bar) * (var(--bar) - 2) * (var(--bar) - 3) * 0.5 + 40% * var(--bar) * (1 - var(--bar)) * (var(--bar) - 3) * 0.5 + 50% * var(--bar) * (1 - var(--bar)) * (var(--bar) - 2) * -0.16666666666666666), 1);

注意，没有检测 `<integer>` 接受属性，所以它不能用于 `z-index` 等，但是它已经将颜色转换为 `hsla（）` ，使它们可控（即使技术可以增强，这种转换仍将发生，只有当它将需要）。另一件事我没有实现在这个 mixin（还没？）是使用 CSS 变量的值的能力。 这对于非整数是可能的，因为那些值将如条件计算中那样插入。也许，当我找到时间时，我将修复 mixin ，使它不仅接受数字或颜色，而且接受变量。目前仍然可以使用本文中解释的算法。

## [](#fallbacks)后退

当然，如果你计划实际使用这个，你需要有一个方法来设置回退。对于不支持变量的浏览器，很简单：只需在条件声明之前声明 fallback 值：

    .block {
        padding: 100px; /* fallback */
        padding: calc(
            100px * ((1 - var(--foo)) * (2 - var(--foo)) / 2) +
             20px * (var(--foo) * (2 - var(--foo))) +
              3px * (var(--foo) * (1 - var(--foo)) / -2)
        );
    }

但是当涉及到颜色我们有一个问题：当有一个支持变量，事实上（这是规范里的另一个很奇怪的地方），**所有**包含该变量的声明将被认为是有效的。这意味着在CSS中不可能对包含变量的东西做出回退：

    background: blue;
    background: I 💩 CSS VAR(--I)ABLES;

是有效的CSS和规范，这背景将得到一个“初始”值，而不是一个后备提供的值（即使其他部分的值明显错误）。

所以，我们在这些情况下需要提供一个回调 - 添加 `@ support` 测试被支持的部分来**排除**变量。

在我们的例子中，我们需要为我们 Firefox 的条件颜色包装，像这样：

    .block {
        color: #f00;
    }
    @supports (color: rgb(0, calc(0), 0)) {
        .block {
            color: rgba(calc(255 * (1 - var(--foo))), calc(255 * var(--foo)), 0, 1);
      }
    }

这里我们测试一个关于颜色算法的支持，并仅在这种情况下应用条件颜色。

也可以自动创建这样的备份，但是我不建议您为它们使用预处理器，因为创建这样的东西的复杂性远不止预处理器提供的功能。

## [](#use-cases)使用实例

我真的不觉得有必要为如此显而易见的东西提供使用实例。所以我会很简短。同时我将不仅描述变量的条件，而且描述一般条件，例如 `calc（）` 的结果。

*   CSS 变量的条件对于区分块是完美的。这样，你可以有一些编号的主题，然后将它们应用到块（和嵌套的！）只使用一个像 `--block-variant：1` 的 CSS 变量。这是不是就可以通过不同的条件取代变量，当你想要不同的主体，不同的道具，不同的值，如果没有条件，你将需要有很多的变量并应用与他们每一个案例中去。

*   排版。如果有可能使用  `<` ,  `<=` ,  `>`  和  `>=` 为变量的情况下，有可能有不同字体大小的一些“规则”，因此您可以根据给定的字体大小设置不同的行高，字体粗细和其他属性。现在这是可能的，但现在，你需要那些值有一些“停顿”，而不仅仅是靠 `em` 获得值。

*   响应设计。好吧，如果有计算的条件，那么它几乎与那些难以捉摸的“元素查询”相同 —— 你可以检查 `vw` 或父元素的宽度百分比，并决定在不同的情况下应用什么。

如果你找到其他使用案例，请告诉我。我相信还有很多这样的案例，但我没有那么好的记忆力把它们全部记下来。我曾经想用 CSS 把它做出来。因为这是它的一切。 

## [](#future)未来

我真的想看到CSS规范中描述的条件，所以我们不会依赖 calc hacks ，并且可以为非计算值使用适当的条件。现在也不可能有除了严格相等的条件，所以没有“当变量超过 X ”和其他类似的东西。我没有看到任何理由为什么我们不能在 CSS 中有适当的条件，所以如果你知道一个规范开发人员，提示他们这个问题。我唯一的希望是，他们不会告诉我们“只是使用 JS ”或找出原因，为什么是不可能的。在这里，现在已经可以使用 hacks，不能有任何借口。

发表在 10 月 21 日， 于[实验](../)中.



如果你发现什么编写错误或者小漏洞又或者你想添加点什么，你可以 [写在这](https://github.com/kizu/kizu.github.com/issues/new?title=Feedback%20for%20%E2%80%9CConditions%20for%20CSS%20Variables%E2%80%9D) 或者 [在 Github 编写这篇文章](https://github.com/kizu/kizu.github.com/blob/source/src/documents/posts/2016-10-21-(fun)-conditions-for-css-variables/index.en.md).



