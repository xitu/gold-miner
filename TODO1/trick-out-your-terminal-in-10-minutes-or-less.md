> * 原文地址：[Trick Out Your Terminal in 10 Minutes or Less](https://towardsdatascience.com/trick-out-your-terminal-in-10-minutes-or-less-ba1e0177b7df)
> * 原文作者：[Anne Bonner](https://medium.com/@annebonner)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/trick-out-your-terminal-in-10-minutes-or-less.md](https://github.com/xitu/gold-miner/blob/master/TODO1/trick-out-your-terminal-in-10-minutes-or-less.md)
> * 译者：
> * 校对者：

# Trick Out Your Terminal in 10 Minutes or Less

> How to make a better, faster, stronger, and sexier terminal in mere minutes

![Image by [khamkhor](https://pixabay.com/users/khamkhor-3614842/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=3510850) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=3510850)](https://cdn-images-1.medium.com/max/3840/1*13Yt-tL66o7n-jwSTiLefA.jpeg)

**The time you spend staring at your terminal doesn’t have to be painful.**

Practically without time or effort, you can transform your terminal from a frustrating white block of pain into a beautiful, fast, fun, easy-to-use seat of power.

The terminal is an incredible tool. It’s the magical box from which you can run your world. Why waste any more time using something that makes you less than thrilled?

When you first start your journey into coding, you’re quickly going to realize that you’ll be spending a LOT of time looking at the terminal. You might want to work as a programmer or developer, or you might be interested in artificial intelligence, machine learning, data science, or any number of other careers. No matter which of these paths you take, it’s a good idea to take a few minutes, get comfortable, and make your terminal a happy place.

> If you’re using a Mac, new to programming, and completely resenting that blank white space, this one’s for you.

![Photo by [Nicola Gypsicola](https://unsplash.com/@nicolagypsicola?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/9792/0*xky7cW4UjPinIF1S)

#### The preinstalled Mac terminal

If you have a Mac, you have a terminal window. Hooray! But even with some basic customization, this is probably not what you want to be staring at for large chunks of your day:

![](https://cdn-images-1.medium.com/max/2952/1*IWG_NGwb9448sTZ4hd_idA.png)

It’s there, it works, and that’s great. But with almost no effort at all, you can turn your terminal into something that you’ll be excited to play with. Something that will make your life so much easier.

#### Terminal vs. iTerm

You don’t have to use Terminal! There’s a hugely improved terminal called [iTerm](https://www.iterm2.com/downloads.html) that’s much more customizable and has lots of cool features. You can search. You can split your panes. You have options for all kinds of things that you probably didn’t even consider doing.

Plus you can make it seriously sexy and much easier to work with hardly any effort at all!

![](https://cdn-images-1.medium.com/max/3078/1*T35YHM5YVwRY26Y7voJubQ.png)

Just head on over to [the official site](https://www.iterm2.com) and then click the big button that says “Download.” After it downloads, open it up and install it just like you would anything else. (If you’re interested, you can find the download link for iTerm3 [here](https://www.iterm2.com/version3.html).)

![](https://cdn-images-1.medium.com/max/4776/1*S6ZiopaexKNCNaSGvTU3Hw.png)

You’ll start with a terminal window that looks like this:

![](https://cdn-images-1.medium.com/max/5564/1*dqIkqInvfJE17smbf6uoxg.png)

> We’re just getting started.

#### Hush that login

You’re probably not totally loving the “last login” message that pops up when you open your terminal. Get rid of it by running this simple command in your terminal:

```
touch ~/.hushlogin
```

#### Grab some sweet downloads

> It’s important to be aware that before your changes take effect, you’ll probably need to close and reopen your terminal.
>
> If you aren’t seeing your modifications, close your terminal window and open a new one.

#### Homebrew

[Homebrew](https://brew.sh/) is a great thing to have in your arsenal. They call themselves “the missing package manager for macOS” and they aren’t kidding. They install the stuff that you need that Apple didn’t install for you.

You can install Homebrew by running

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

It will pause and tell you what it’s up to while it’s installing. This thing is beyond useful and I can’t recommend it enough. Homebrew is a lifesaver.

#### Zsh

The default shell is bash, and that’s great if you want to keep it. But [Zsh](http://zsh.org/) is more customizable and has a reputation for being faster. One of the coolest things that [Zsh](http://zsh.org/) does is autocompletion. Any time you want, you can type something like “git c” and then press the tab key, and you’ll get a sweet little help window with autocomplete suggestions.

![](https://cdn-images-1.medium.com/max/2304/1*cMHcc4NBWhuakaGW526wyw.png)

Also, Zsh has some seriously nice plugins that you really don’t want to miss. It comes preinstalled on a Mac, but the version seems to consistently be outdated, so you’ll want to run:

```
brew install zsh
```

#### Oh-My-Zsh

Do you like Zsh? You need to get [Oh-My-Zsh](https://github.com/robbyrussell/oh-my-zsh)! It’s an open source framework for managing your Zsh configuration that has thousands of awesome helpers and functions, plugins and themes. You can download it by running

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

#### Plugins

You can find a [full list of official plugins here.](https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins) They’re ready to go whenever you want. You’ll just need to enable them by adding them to your ~/.zshrc file. (Stay with me here. It’s easier than it sounds!)

To see what’s immediately available to you, head over to the [plugins site](https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins). Scroll down and take a look at all of the plugins that you can install with practically no effort. You might want to add Git, GitHub, Python, Sublime, VSCode, or anything else that looks like it will make your life easier.

You definitely want Z.

It’s ridiculously easy to add plugins, but the directions might not make sense if you’re new to the terminal. When you want to make changes like this, you’ll need to edit your ~/.zshrc file. That sounds complicated, but it really isn’t! To open the file, run

```
open ~/.zshrc
```

![](https://cdn-images-1.medium.com/max/5764/1*t6dR5kpaYvhUqUBfMZlQOQ.png)

That will open the text file that you need to make changes. **Make sure you treat this file with respect.** Changing something in here can and will make a big difference in how (and if) things work.

When you scroll through this file, you’ll see some things you can uncomment if you want to change them. You’ll also see spaces where you can add your own modifications.

Want to add or delete plugins? Scroll down to this part:

```
# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)
```

> It’s like they want this to be easy!

Now add any plugins you want to use. For example, you might want to change that last line to

```
plugins=(git z github history osx pip pyenv pylint python sublime vscode)
```

Save it and you’re good to go!

#### Syntax Highlighting

You want Zsh syntax highlighting. It will tell you if your command is valid even before you run it. It’s handy.

To enable syntax highlighting, run

```
cd ~/.oh-my-zsh && git clone git://github.com/zsh-users/zsh-syntax-highlighting.git

echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
```

and then enable it by running

```
source ~/.oh-my-zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
```

Restart your terminal for your changes to take effect.

#### Z

Love Z. Love, love, love Z! Z takes it to the next level. It makes terminal life so much faster! To install it, run

```
brew install z
```

(Hopefully, you included Z in your plugins.)

Z is awesome. Z is smart. If you’re constantly typing something like:

```
cd this/is/the/path/to/the_file/ThisOne
```

now you’ll be able to type:

```
z thisone
```

and you’re there! You’ll need to do your normal thing for a bit while Z figures out what you like to do and then you’re off to the races.

Let’s say you’re always going to your “Repos” folder. Typing `cd repos` from just anywhere will never work.

![](https://cdn-images-1.medium.com/max/2592/1*PZy0iqA2A9Q6UIHiY1DYvg.png)

But now you can just type `z repos` and jump right to it from anywhere!

![](https://cdn-images-1.medium.com/max/2592/1*iZzK-Xm6XePLpSUadeC8cw.png)

#### Sublime Text

If you use [Sublime Text](https://www.sublimetext.com/) as your primary text editor, you can make your life incredibly simple by setting up a Sublime shortcut. This way, any time you want to open a file with Sublime (or create a new file and open it with Sublime), you can use the command `subl`.

If you want to create and open a new file called “test.txt” in Sublime, you’ll type

```
subl test.txt
```

That will open Sublime and create a brand new text file called “test.txt.”

![](https://cdn-images-1.medium.com/max/2592/1*EPVtMSki6OGGUG7xQ67SoQ.png)

[Here’s where I found the easiest way to get this working](https://gist.github.com/barnes7td/3804534) on a Mac with Zsh. First **make sure you have Sublime Text installed and in your applications folder**. To get it up and running, create a directory at ~/bin by running

```
mkdir ~/bin
```

Then run this:

```
ln -s "/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl" ~/bin/subl
```

Now run this command to add a line to your ~/.zshrc file

```
echo 'export PATH=$PATH:$HOME/bin' >> ~/.zshrc
```

Then set Sublime as your default editor with this line:

```
echo "export EDITOR='subl' -w" >> ~/.zshrc
```

After you restart your terminal, you can test it with this:

```
subl .
```

That should open Sublime right up for you!

#### Let’s make it pretty

While there are a ton of themes you can use to modify the appearance of your terminal window, you might want to start simply.

Open iTerm and drop down the iTerm menu to “Preferences.” A window will pop up with lots of choices. You can pick the colors you like or use one of the options from the “Color Presets” dropdown menu in the “Colors” tab. You might want to choose a dark theme or make some other simple color choices. It’s easy to change the font and the font size under the tab that says “Text.”

You can also import a different theme any time you want. I’m using **Atom** for the color scheme, but you have a ton of choices. Take a look through [this GitHub repository](https://github.com/robbyrussell/oh-my-zsh/wiki/Themes) for examples.

If you want to install a custom iTerm theme, that’s simple. Just go to [this GitHub repo](https://github.com/mbadolato/iTerm2-Color-Schemes) and then hit either of the icons up at the top to download themes. (I went with the zip file. Once you download that file, click it to unzip it.)

![](https://cdn-images-1.medium.com/max/4750/1*aOffDydw0Gr-qO4M6BZ39w.png)

Next, go to “Preferences,” click on the “Colors” tab, and click “Import” in the “Color Presets” dropdown menu. That lets you choose the color scheme you want. It will open up a finder window. Go into the “schemes” folder within the folder you downloaded and choose “Atom.itermcolors” if you want to use the Atom theme and click “Open.”

![](https://cdn-images-1.medium.com/max/2880/1*NB6Xu0uTYkh1ATEHK6E_KA.png)

Now you can choose “Atom” from that dropdown menu!

![](https://cdn-images-1.medium.com/max/NaN/1*Y3Xak-agj0Nr1NaOG6_iPw.png)

If you want to change your font or font size, go to the tab that says “Text.” Then click the “Change Font” button to make your changes.

![](https://cdn-images-1.medium.com/max/4752/1*VQUAxh01edXPx-r9N-kv0g.png)

14 point Monaco just looks happy.

You can also easily adjust the transparency of your window. You might want to keep an eye on something that’s running behind your window. You might be new to programming and need to make sure you’re carefully following the tutorial you’re working through. It can be pretty helpful!

Just go to the “Window” tab, and adjust the slider under “Transparency:” until you’re happy.

![](https://cdn-images-1.medium.com/max/NaN/1*boCIYhyPwYZcnCKr69YQNw.png)

#### Do what you wanna do.

Never forget: **your playground, your rules.** Make your space awesome! This just cracks the surface of what you can do. There are practically unlimited ways that you can customize your terminal.

Have some fun!

If you come up with a terminal configuration that makes your heart sing, let everyone know about it in the responses below! As always, reach out any time on LinkedIn [@annebonnerdata](https://www.linkedin.com/in/annebonnerdata/).

Thanks for reading!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
