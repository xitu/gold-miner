> * 原文地址：[Android Data Binding: RecyclerView](https://medium.com/google-developers/android-data-binding-recyclerview-db7c40d9f0e4#.8vfxpl4zj)
* 原文作者：[George Mount](https://medium.com/@georgemount007?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Jamweak](https://github.com/jamweak)
* 校对者：[Zhiwei Yu](https://github.com/Zhiw)，[tanglie](https://github.com/tanglie1993)

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*NShiWWuJvGcsbywB-O7-Ng.jpeg">

# Android 数据绑定之: RecyclerView #

## 简化, 复用, 重新绑定 ##

有时我会想，“数据绑定”这个名词并不一定特指 Android 中的数据绑定。RecyclerView 就有它独特的方法将其数据绑定到 UI 控件上。它有一个 [Adapter](https://developer.android.com/reference/android/support/v7/widget/RecyclerView.Adapter.html)，其中需要我们实现两个非常重要的方法来进行数据绑定：

```
RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent,
int viewType);

void onBindViewHolder(RecyclerView.ViewHolder holder, int position);
```

RecyclerView 对外暴露出了常见的 [ViewHolder 模式](https://developer.android.com/training/improving-layouts/smooth-scrolling.html) 作为其 API 中的第一类公民。在 onCreateViewHolder() 方法中，View 被创建之后，其引用就被包含在 ViewHolder 中以便能被快速配置数据。然后在 onBindView() 方法中，特定的数据即和 View 关联起来。

#### RecyclerView 中的 Android 数据绑定####

[前篇文章中](https://medium.com/google-developers/android-data-binding-adding-some-variability-1fe001b3abcc#.1o06zcbx5)指出 , 
Android 数据绑定可以被看作 ViewHolder 模式。理论上，我们只需在 onCreateViewHolder() 方法中返回生成的绑定类，但是这个类并没有继承 RecyclerView.ViewHolder 类。因此，这个绑定类必须被 ViewHolder ”**包含**“进去。

```
public class MyViewHolder extends RecyclerView.ViewHolder {
    private final ItemBinding binding;

    public MyViewHolder(ItemBinding binding) {
        super(binding.getRoot());
        this.binding = binding;
    }

    public void bind(Item item) {
        binding.setItem(item);
        binding.executePendingBindings();
    }
}
```
现在，我们的适配器可以使用 Android 数据绑定的方法来创建并绑定数据：

```
public MyViewHolder onCreateViewHolder(ViewGroup parent,
                                       int viewType) {
    LayoutInflater layoutInflater =
        LayoutInflater.from(parent.getContext());
    ItemBinding itemBinding = 
        ItemBinding.inflate(layoutInflater, parent, false);
    return new MyViewHolder(itemBinding);
}

public void onBindViewHolder(MyViewHolder holder, int position) {
    Item item = getItemForPosition(position);
    holder.bind(item);
}
```

如果你看得够仔细的话，你可能会看到 MyViewHolder.bind() 方法最后有一个 executePendingBindings() 方法。这会强制绑定操作马上执行，而不是推迟到下一帧刷新时。RecyclerView 会在 onBindViewHolder 之后立即测量 View。如果因为绑定推迟到下一帧绘制时导致错误的数据被绑定到 View 中, View 会被不正确地测量，因此这个 executePendingBindings() 方法非常重要！

#### 复用 ViewHolder ####

如果你之前曾经使用过 RecyclerView 的 ViewHolder，你会知道我们已经减少了一大堆关于将数据设置到 View 中的代码。但不幸的是，我们仍不得不为不同的 RecyclerView 写一大堆 ViewHolder。另外，如果你有多种 View 类型，你也不清楚如何拓展它。我们可以修复此问题。

通常来说，只有一个数据被传入到绑定类中，例如上文中的 "Item"。当你使用这种模式时，你可以使用类型转换来为各种 RecyclerView 以及各种 View 类型都使用唯一的 ViewHolder。按照惯例我们将单一视图模型对象命名成 "obj"。你也许会命名为 "item" 或者 "data"，但如果我使用 "obj"，将很容易在例子中辨别。

```
public class MyViewHolder extends RecyclerView.ViewHolder {
    private final ViewDataBinding binding;

    public MyViewHolder(ViewDataBinding binding) {
        super(binding.getRoot());
        this.binding = binding;
    }

    public void bind(Object obj) {
        binding.setVariable(BR.obj, obj);
        binding.executePendingBindings();
    }
}
```

在 MyViewHolder 中，我使用了 ViewDataBinding，它是所有生成的绑定类的基类，代替了特定的 ItemBinding 类。这样之后，我就能在 ViewHolder 中支持各种各样的布局。我还使用了 setVariable() 方法来取代之前的类型安全，但需要指定特定类型的 setObj() 方式，这样我就能随意指定任何我需要的数据类型了。关键的一点是变量必须命名成 "obj" 因为我使用 BR.obj 作为 setVariable() 的键值。这意味着你必须在你的布局文件中有一个像这样的变量标签：

```
<variable name="obj" type="Item"/>
```

当然，你的变量相比于 "Item" ，能使用任何在布局中想要绑定的类型
 
之后我就能创建一个通用的 RecyclerView 适配器了。

```
public abstract class MyBaseAdapter
                extends RecyclerView.Adapter<MyViewHolder> {
    public MyViewHolder onCreateViewHolder(ViewGroup parent,
                                           int viewType) {
        LayoutInflater layoutInflater =
                LayoutInflater.from(parent.getContext());
        ViewDataBinding binding = DataBindingUtil.inflate(
                layoutInflater, viewType, parent, false);
        return new MyViewHolder(binding);
    }

    public void onBindViewHolder(MyViewHolder holder,
                                 int position) {
        Object obj = getObjForPosition(position);
        holder.bind(obj);
    }
    
    @Override
    public int getItemViewType(int position) {
        return getLayoutIdForPosition(position);
    }

    protected abstract Object getObjForPosition(int position);

    protected abstract int getLayoutIdForPosition(int position);
}
```
在这个适配器中，布局的 ID 被用作 view 类型，这样能更方便得来获取正确的绑定类，同时也能让适配器处理任意数量的布局。但最通用的做法是 RecyclerView 只有一个布局，因此我们可以写这样一个基类：

```
public abstract class SingleLayoutAdapter extends MyBaseAdapter {
    private final int layoutId;
    
    public SingleLayoutAdapter(int layoutId) {
        this.layoutId = layoutId;
    }
    
    @Override
    protected int getLayoutIdForPosition(int position) {
        return layoutId;
    }
}
```

#### 还剩下什么? ####

所有 RecyclerView 中的模板现在都被处理完了，留给你做的是最困难的部分：在非 UI 线程加载数据，当数据更新时通知适配器等等。Android 数据绑定仅简化了无聊的部分。 

你也可以扩展这个技术来支持多个变量。通常来说需要支持一个事件处理对象来处理例如点击事件等，你也许会想将其传入到视图模型类中。如果你经常在 Activity 或 Fragment 中传值，你可以添加这些变量。只要你使用连贯的命名，你就可以在所有 RecyclerView  中使用这项技术。

使用 Android 数据绑定结合  RecyclerView 是简便的，能显著减少冗长的代码。也许你的应用只需要一个 ViewHolder 并且你再也不需要重写 onCreateViewHolder() 方法和 onBindViewHolder() 了！
