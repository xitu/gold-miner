> * 原文地址：[Better Component Composition in VueJS](https://itnext.io/better-composition-in-vue-fd35b9fe9c79)
> * 原文作者：[Francesco Vitullo](https://medium.com/@francisvitullo)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/better-composition-in-vue.md](https://github.com/xitu/gold-miner/blob/master/article/2020/better-composition-in-vue.md)
> * 译者：
> * 校对者：

# Better Component Composition in VueJS

![Photo by [uniqsurface](https://unsplash.com/@uniqsurface?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/7000/0*janl0y40OKFy4aID)

In **VueJS** there are few ways to compose components and reuse logic. In this article, I would like to demonstrate a way to boost composition in Vuejs (2.* and 3.*).

I really like the recent proposals regarding the **Composition API**, but I think that can be part of a broader view.

Below, you can find a component implementing a general use case (a simple data fetching from a remote endpoint and displaying the different transitions and data), though most of the logic is always duplicated along with the template, data, and other variables when the same logic is applied to other places or components.

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

How do we refactor this component and improve it? Let’s go step-by-step and make this component more readable and reusable.

#### Vue Composition API

Thanks to the new Vue Composition API, we can pull out some logic in order to re-use it, without losing reactivity or features provided by Vue components.

This approach helps in organizing the code, makes components more readable and it helps to lower the overall complexity. As a recommendation, I believe this should be the very first thing to do when refactoring huge, complex, and tangled components.

We are going to extract the part related to the data fetching and related variables (**loading, error**, etc…), but I don’t want to discuss what Composition API is and what are the features, pros, and cons.

Let’s create a simple function which provides the necessary stuff for fetching along with the reactive variables:

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

The created functions now return a set of reactive variables (**loading, error, data**, and **hasData**) that can be used by our component and an async function in order to execute the data fetching (**fetchData**, which will mutate the reactive variables returned).

And, let’s refactor our component to use the Composition API instead:

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

As you noticed, our component is containing the setup method as well, which invokes the **useFetchData** function while destructuring returned variables/functions and returning them to the component instance.

In this example, I am using the **fetchData** function in the mounted lifecycle hook but it could be invoked wherever you desire. Whenever something is evaluated/changed by that invoked function, the result will be reflected in our component since they are reactive properties.

#### JSX and TSX

Now let’s suppose we want to pass the data to an inner component. There are multiple ways to do so with VueJS but I would like to refactor this to use **TSX** (or **JSX** if you prefer) instead:

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

I know that this might look very similar to React but I believe this opens a lot of doors to composition in a better way.

It’s actually quite simple to understand, it’s the same thing as the template, but we moved the HTML part to the Render function.

We are not done yet with the quest to pass it to an inner component and we could actually improve it as the following piece of code, which exports the whole thing as a function we can re-use:

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

Now that we brought it to the next level, get rid of the **SFC** (Single File Component file) we can actually boost composition.

At this stage, we are using defineComponent to create a component using the Composition API and relying on JSX/TSX in order to avoid the template section. The beauty of this approach is that we can treat a component as a function and rely on the principles of the Functional Programming Paradigm (e.g. first-class functions, pure functions, etc…)

For instance, the Render function is also containing a div containing the data, but imagine passing a component as a parameter of the exported function and use it in the returned JSX/TSX (passing the response/data as props to the requested component).

It might look like this:

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

Now we are expecting a component as a parameter and using it in the returned value of the Render function.

We can do more.

Actually, we could expect also the **useFetchData** function as a parameter in the exported function.

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

With these changes, on top of the component, as an accepted parameter, we are expecting a **Function** with the type **FetchData** which is returning a set of expected variables/functions/computed in order to use in our component.

This is really useful in order to replace Inheritance/Extension and rely on a more functional approach. So, instead of extending already existing components and overriding component’s functions, we could actually pass in the desired component and function. Typescript is only helping here with typings and inference, so Javascript would be enough too.

For instance, if we would like to use this, it might look like the following:

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

We have called the last example above as **withLoaderAndFetcher** and we are using it passing 3 different components with 3 different functions (expected to achieve the desired thing the in decorator).

This can be even pushed further, but I wanted to show how it is possible to achieve this state and increase the number of solutions towards the functional composition. This is example code and might not work perfectly, but the idea and concept is the most important thing to catch.

Cheers :)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
