> * 原文地址：[Android Data Binding: RecyclerView](https://medium.com/google-developers/android-data-binding-recyclerview-db7c40d9f0e4#.8vfxpl4zj)
* 原文作者：[George Mount](https://medium.com/@georgemount007?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*NShiWWuJvGcsbywB-O7-Ng.jpeg">

# Android Data Binding: RecyclerView #

## Reduce, Reuse, Rebind ##

While sometimes I like to think so, *Data Binding* as a term doesn’t always mean Android Data Binding. RecyclerView has its own way of binding data to the UI. RecyclerView has an [Adapter](https://developer.android.com/reference/android/support/v7/widget/RecyclerView.Adapter.html) with two very important methods that we implement to bind data:

```
RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent,
**int **viewType);

**void **onBindViewHolder(RecyclerView.ViewHolder holder, **int **position);
```

RecyclerView exposes the common [ViewHolder pattern](https://developer.android.com/training/improving-layouts/smooth-scrolling.html)  as a first class citizen in its API. In onCreateViewHolder(), the Views are created and the ViewHolder contains references to them so that the data can be set quickly. Then in onBindView(), the specific data is assigned to the Views.

#### Android Data Binding in RecyclerView ####

[As discussed in a previous article](https://medium.com/google-developers/android-data-binding-adding-some-variability-1fe001b3abcc#.1o06zcbx5) , Android Data Binding can be treated like the ViewHolder pattern. Ideally, we’d just return the generated Binding class from our onCreateViewHolder(), but it doesn’t extend RecyclerView.ViewHolder. So, the binding class will have to be *contained* by the ViewHolder instead.

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

Now, my adapter can create and bind using Android Data Binding:

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

If you were looking closely, you saw the executePendingBindings() at the end of MyViewHolder.bind(). This forces the bindings to run immediately instead of delaying them until the next frame. RecyclerView will measure the view immediately after onBindViewHolder. If the wrong data is in the views because the binding is waiting until the next frame, it will be measured improperly. The executePendingBindings() is important!

#### Reusing the ViewHolder ####

If you’ve ever used a RecyclerView’s ViewHolder before, you can see that we’ve saved a bunch of boilerplate code in which the data is set into the Views. Unfortunately, we still have to write a bunch of ViewHolders for different RecyclerViews. It also isn’t clear how you’d extend this should you have multiple view types. We can fix these problems.

It is common to have only one data object passed into a data binding class, like *item* above. When you have this pattern, you can use naming convention to make a single ViewHolder for all RecyclerViews and all view types. The convention we’ll use is to name the one view model object “obj.” You may prefer “item” or “data,” but if I use “obj,” it is easier to pick out in the example.

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

In MyViewHolder, I am using ViewDataBinding, the base class for all generated bindings, instead of the specific ItemBinding. This way, I can support any layout in my ViewHolder. I’m also using setVariable() instead of the type-safe, but class-specific, setObj() method so that I can assign whatever view model object type that I need. The important part is that the variable must be named “obj” because I use BR.obj as the key in setVariable(). That means you must have a variable tag in your layout file like this:

```
<variable name="obj" type="Item"/>
```

Of course, your variable will have whatever type your data bound layout requires instead of “Item.”

I can then create a base class that can be used for all of my RecyclerView Adapters.

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



In this Adapter, the layout ID is being used as the view type so that it is easier to inflate the right binding. This lets the Adapter handle any number of layouts, but the most common usage is to have a RecyclerView with a single layout, so we can make a base class for that:

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

#### What’s Left? ####

All the boilerplate from the RecyclerView is now handled and all you have left to do is the hard part: loading data off the UI thread, notifying the adapter when there is a data change, etc. Android Data Binding only reduces the boring part.

You can also extend this technique to support multiple variables. It is common to supply an event handler object to handle things like click events and you may want to pass that along with a view model class. If you always pass in the Activity or Fragment, you could add those variables. As long as you use consistent naming, you can use this technique with all of your RecyclerViews.

Using Android Data Binding with RecyclerViews is easy and significantly reduces boilerplate code. Maybe your application will only need one ViewHolder and you’ll never need to write onCreateViewHolder() or onBindViewHolder() again!
