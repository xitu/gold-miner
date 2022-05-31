> * 原文地址：[Two-way binding will make your React code better](https://medium.com/front-end-weekly/two-way-binding-will-make-your-react-code-better-f58865923538)
> * 原文作者：[Mikhail Boutylin](https://medium.com/@lahmataja-pa4vara)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/.md](https://github.com/xitu/gold-miner/blob/master/article/2022/two-way-binding-will-make-your-react-code-better.md)
> * 译者：[tong-h](https://github.com/Tong-H)
> * 校对者：[nia3y](https://github.com/nia3y)

# 双向绑定会使你的 React 代码更棒

![](https://miro.medium.com/max/1400/1*qAhyHG_kc614Tm-dkgVbZg.jpeg)

双向绑定可以让两个实体间保持同步，比如：应用程序的数据层和视图层。React 提供了开箱即用的单向绑定的 api，开箱即用。当我们想要修改 state 时，我们需要显式的调用更新回调：

``` js
const UserName = ({ name, onChange }) => {
	return <input onChange={onChange} value={name} />
}
const App = () => {
	const [user, setUser] = useState({ name: "" })
	return <UserName name={user.name} onChange={(e) => setUser({ name: e.target.value })} />
}
```

这为子元素的更新提供了渠道。当根节点的 state 更新后，变更会传播给子元素。这使得应用数据流变得明确清晰且可预测，但增加了代码量。
为了使双向绑定与 React 的更新哲学相匹配，我创建了 `mlyn` 库 。主要的范式在于每一部分 state 都是可读写的。当你写入 state 时，这个修改将会冒泡上升至根 state，并导致其更新：

``` js
// 末尾符号 $ 代表该值是可监控的
const UserName = ({ name$ }) => {
	return <Mlyn.Input bindValue={name$} />
}
const App = () => {
	const user$ = useSubject({ name: "" })
	return <UserName name$={user$.name} />
}
```

就这样，引擎会用与上述普通 React 示例一样的方法去更新 state。

![](https://miro.medium.com/max/1400/1*SMBgiqvVPFNu42bMUDUJ6w.png)

双向绑定并不局限于与 UI 交互，你可以轻松地将你的值与 localStorage 绑定。你有一个 hook，可以接收 mlyn state 的 一部分，以及目标 localStorage 的 key：

``` js
const useSyncronize = (subject$, key) => {
	useEffect(() => {
		// 如果 state 存在，即为其写入
		if (localStorage[key]) {
			subject$(JSON.parse(localstorage[key]))
		}
	}, [])
	useMlynEffect(() => {
		// state 更新，即更新 localStorage
		localStorage[key] = JSoN.stringify(subject$())
	})
}
```

现在你可以轻松地绑定用户名称到 localStorage：

``` js
useSyncronize(user$.name, "userName");
```

注意，你不需要创建或传递任何回调函数用于更新值，它就会生效。
另一个使用案例是当你想要使 state 的修改可撤销或可重写时，你只需要将该 state 再一次传递给正确的历史管理 hook。

``` js
const history = useHistory(state$.name);
```

`history` 对象包含一个 api `jumpTo` 可以跳转至 state 的任何阶段，但这是一个带有一点自定义的双向绑定。只要 state 被更新，新的快照就会被推入到 history 中：

![](https://miro.medium.com/max/1400/1*GhiJOFZ096s0132YjIIm_A.jpeg)

当你选中一个历史状态，该状态将会重写回 state：

![](https://miro.medium.com/max/1400/1*6TQ_Iwan_oX8Zdqcm9QOuA.jpeg)

再次注意，我们没有因为 state 的更新而去写一个自定义样板，只是把历史快照串联起来而已。看看这个 TodoMVC 应用的历史记录管理 [code sandbox](https://codesandbox.io/s/react-mlyn-todo-mvc-with-history-lr34k?file=/src/App.js:1514-1555)：

![](https://miro.medium.com/freeze/max/60/1*kkac5rgo0BbEfB-8VfFDrg.gif?q=20)

![](https://miro.medium.com/max/1400/1*kkac5rgo0BbEfB-8VfFDrg.gif)

关于更多双向绑定以及 `mlyn` 的例子，请访问 [react-mlyn](https://github.com/vaukalak/react-mlyn)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
