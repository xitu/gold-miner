> * 原文地址：[Better Component Composition in VueJS](https://itnext.io/better-composition-in-vue-fd35b9fe9c79)
> * 原文作者：[Francesco Vitullo](https://medium.com/@francisvitullo)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/better-composition-in-vue.md](https://github.com/xitu/gold-miner/blob/master/article/2020/better-composition-in-vue.md)
> * 译者：[tonylua](https://github.com/tonylua)
> * 校对者：[Gesj\-yean](https://github.com/Gesj-yean), [dupanpan](https://github.com/dupanpan)

# VueJS 中更好的组件组合方式

![照片由 [uniqsurface](https://unsplash.com/@uniqsurface?utm_source=medium&utm_medium=referral) 拍摄并发表在 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral) 上](https://cdn-images-1.medium.com/max/7000/0*janl0y40OKFy4aID)

**VueJS** 中有一些组合组件并复用逻辑的方法。在本文中，我将展示一种在 Vuejs (2.* 及 3.*) 中改进组合方式的方法。

我的确欣赏最近的 **Composition API** 提案，但我认为视野还可以更开阔。

下面，你可以看到一个实现了一种常规用例（从远端获取一个简单的数据并将其搭配不同的转场效果显示出来）的组件，尽管大部分逻辑及其相关的模版、数据和其它变量等与出现在其它地方或组件中的相同逻辑并无不同，它们还是出现在了该组件中。

```Vue
<template>
<div>
    <div v-if="loading"> Loading... </div>
    <div v-if="error"> An Error occured, please try again</div>
    <div v-if="hasData"> {{ data }} </div>
</div>
</template>

</template>

<script>
    export default {
        data() {
            return {
                loading: false,
                error: false,
                data: {}
            }
        },
        methods: {
            fetchData() {
                this.loading = true;
                setTimeout(() => {
                    this.data = { text: 'example' };
                    this.loading = false;
                }, 4000);
            }
        },
        computed: {
            hasData() {
                return this.data && !!this.data.text;
            }
        },
        mounted() {
            this.fetchData();
        }
    }
</script>

```

该如何重构并改善这个组件呢？让我们一步步地让其更易读且更容易复用。

#### Vue Composition API

感谢新的 Vue Composition API，使得我们可以在不丢失由 Vue 组件提供的响应性或其它特性的前提下，抽出一些逻辑以来复用它。 

这种方式有助于组织代码、让组件更易读，并有助于降低总体复杂度。作为一种建议，我相信这些应该是重构巨大、复杂和混乱的组件时的首要之事。

我们将抽取与获取数据有关的部分及相关的变量（**loading、error** 等……），但我并不想谈论什么是 Composition API 以及其特性、优点和缺点。

让我们来创建一个提供了获取数据必要功能及若干响应式变量的简单函数：

```TypeScript
import { reactive, toRefs, computed, Ref, ComputedRef } from '@vue/composition-api';

interface ReceivedData {
    text?: string
}

interface FetchState {
    loading: boolean,
    error: boolean,
    data: ReceivedData
}

interface FetchDataVars {
    loading: Ref<boolean>;
    error: Ref<boolean>;
    data: Ref<object>;
    fetchData: Function;
    hasData: ComputedRef<boolean>
}

export default (): FetchDataVars => {
    const state = reactive<FetchState>({
        loading: true,
        error: false,
        data: {}
    });

    const fetchData = async () => {
        state.loading = true;
        setTimeout(() => {
            state.data = { text: 'example' };
            state.loading = false;
        }, 4000);
    }

    const hasData = computed(() => state.data && !!state.data.text)
    
    return {
        ...toRefs(state),
        fetchData,
        hasData
    }
}
```

新创建的函数现在返回了可被用于组件的一组响应式变量 (**loading、error、data**，及 **hasData**) 及一个用来执行数据获取任务的异步函数 (**fetchData**，将会改变上述响应式变量) 。

而后，来使用 Composition API 重构组件：

```Vue
<template>
<div>
    <div v-if="loading"> Loading... </div>
    <div v-if="error"> An Error occured, please try again</div>
    <div v-if="hasData"> {{ data }} </div>
</div>
</template>

</template>

<script lang="ts">
    import useFetchData from '../composables/use-fetch-data';
    import { defineComponent } from '@vue/composition-api';

    export default defineComponent({
        setup() {
            const { loading, error, data, fetchData, hasData } = useFetchData();
            return {
                loading,
                error,
                data, fetchData,
                hasData
            }
        },
        mounted() {
            this.fetchData();
        }
    });
</script>


```

正如你所注意到的，我们的组件还包含了 setup 方法，由其调用 **useFetchData** 函数，同时解构返回的变量和函数并将它们返回给组件实例。

在这个例子中，我在 mounted 生命周期钩子中使用了 **fetchData** 函数，但其实你可以在期望的任意位置调用它。无论何时，被该函数求值或改变的结果都会反映在组件中，因为它们都是响应式属性。

#### JSX 和 TSX

现在假设我们想要将获取的数据传递到一个内部组件中。借助 VueJS 有多种实现的方法，但我却想使用  **TSX** (你若更喜欢 **JSX** 也行) 来重构代码：

```Vue
<script lang="tsx">
    import useFetchData from '../composables/use-fetch-data';
    import { defineComponent } from '@vue/composition-api';

    export default defineComponent({
        setup() {
            const { loading, error, data, fetchData, hasData } = useFetchData();
            return {
                loading,
                error,
                data, fetchData,
                hasData
            }
        },
        mounted() {
            this.fetchData();
        },
        render() {
            return (
                <div>
                    { this.loading && <div> Loading ... </div> }
                    { this.error && <div> An Error occured, please try again </div> }
                    { <div> { this.data } </div> }
                </div>
            )
        }
    });
</script>
```

我知道这看起来很像 React，但我相信这开启了以更好的方法优化组合方式的许多可能之门。

这其实很易懂，它完成了和模板同样的事情，但我们将 HTML 部分移入了 render 函数中。

我们尚未完成将数据传递进内部组件的任务，实际上我们像下面这样改进一点代码就行，也就是将所有东西导出成一个我们可复用的函数：

```TSX
import useFetchData from '../composables/use-fetch-data';
import { defineComponent } from '@vue/composition-api';

export default () => defineComponent({
    setup() {
        const { loading, error, data, fetchData, hasData } = useFetchData();
        return {
            loading,
            error,
            data, fetchData,
            hasData
        }
    },
    mounted() {
        this.fetchData();
    },
    render() {
        return (
            <div>
                { this.loading && <div> Loading ... </div> }
                { this.error && <div> An Error occured, please try again </div> }
                { <div> { this.data } </div> }
            </div>
        )
    }
});
```

现在我们已经更上一层楼了，摆脱 **SFC** (单文件组件 -- Single File Component 文件) 后我们就可以真正的改进组织方式了。

在此阶段，我们使用 defineComponent 创建了一个使用 Composition API 的组件并依托 JSX/TSX 消除了模板部分。这种方式的妙处在于可以将一个组件视为一个函数并自如运用函数式编程范式（如一级函数、纯函数等等……）了。

举例来说，render 函数也包含了一个显示数据的 div，但想象下若将一个组件作为刚才所导出函数的一个参数，并在返回的 JSX/TSX 中使用它（将响应/数据作为属性传递给组件）是如何的呢。

看起来可能会是这样的：

```TSX
import useFetchData from '../composables/use-fetch-data';
import { defineComponent } from '@vue/composition-api';
import { Component } from 'vue';

export default (component: Component) => defineComponent({
    setup() {
        const { loading, error, data, fetchData, hasData } = useFetchData();
        return {
            loading,
            error,
            data, fetchData,
            hasData
        }
    },
    mounted() {
        this.fetchData();
    },
    render() {
        const injectedComponentProps = {
            data: this.data
        }
        return (
            <div>
                { this.loading && <div> Loading ... </div> }
                { this.error && <div> An Error occured, please try again </div> }
                <component props={ injectedComponentProps } />
            </div>
        )
    }
});
```

现在我们正期待着将一个组件作为参数并在 render 函数中使用它。

还可以做得更多。
 
实际上，我们也可以期待将 **useFetchData** 函数作为所导出函数的一个参数。

```TSX
import useFetchData from '../composables/use-fetch-data';
import { defineComponent, ComputedRef, Ref } from '@vue/composition-api';
import { Component } from 'vue';

interface FetchDataVars {
    loading: Ref<boolean>;
    error: Ref<boolean>;
    data: Ref<object>;
    fetchData: Function;
    hasData: ComputedRef<boolean>
}

type FetchData = () => FetchDataVars ;

export default (component: Component, factoryFetchData: FetchData) => defineComponent({
    setup() {
        const { loading, error, data, fetchData, hasData } = factoryFetchData();
        return {
            loading,
            error,
            data, fetchData,
            hasData
        }
    },
    mounted() {
        this.fetchData();
    },
    render() {
        const injectedComponentProps = {
            data: this.data
        }
        return (
            <div>
                { this.loading && <div> Loading ... </div> }
                { this.error && <div> An Error occured, please try again </div> }
                <component data={ injectedComponentProps } />
            </div>
        )
    }
});
```

借助这些改变，在组件之上，接受一个类型为 **FetchData** 并返回一组符合预期的变量/函数/计算值的 **函数** 作为参数，就可以使用包装过的新组件。

这是一种依托函数式途径达成的相当有用的替代继承/扩展的方法。所以，不同于扩展已有的组件并覆写组件的函数的是，我们可以真正传入期望的组件和函数了。Typescript 在此仅有助于强类型化和类型推断，所以只用 Javascript 也是足够的。

例如，如果我们想要使用它，看起来会是这样的：

```TypeScript
import withLoaderAndFetcher from './components/withLoaderAndFetcher';


import useFetchDataForEndpointOne from './composables/useFetchDataForEndpointOne'
import useFetchDataForEndpointTwo from './composables/useFetchDataForEndpointTwo'
import useFetchDataForEndpointThree from './composables/useFetchDataForEndpointThree'


import ComponentA from './components/ComponentA.vue';
import ComponentB from './components/ComponentB.vue';
import ComponentC from './components/ComponentC.vue';


const composedA = withLoaderAndFetcher(ComponentA, useFetchDataForEndpointOne);
const composedB = withLoaderAndFetcher(ComponentB, useFetchDataForEndpointTwo);
const composedC = withLoaderAndFetcher(ComponentC, useFetchDataForEndpointThree);
```

我们将上例导出的函数称为 **withLoaderAndFetcher** 并使用其组合了 3 个不同的组件和 3 个不同的函数（装饰者模式）。

这项工作还能推进得更远，但我想展示的是达到这种状态的可能性并增加趋向函数式组合方式的方法数量。这只是示例代码，也可能不会工作得很好，但这种想法和概念才是要义。

干杯 :)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
