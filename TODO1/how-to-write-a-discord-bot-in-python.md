> * 原文地址：[How to write a Discord bot in Python](https://boostlog.io/@junp1234/how-to-write-a-discord-bot-in-python-5a8e73aca7e5b7008ae1da8b)
> * 原文作者：[Junpei Shimotsu](https://boostlog.io/@junp1234)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-write-a-discord-bot-in-python.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-write-a-discord-bot-in-python.md)
> * 译者：
> * 校对者：

# How to write a Discord bot in Python

In this tutorial, you'll learn to create a simple [Discord](https://discordapp.com/) bot with Python.
In case you don't know what Discord is, it is a Slack-like service aimed at gamers essentially.

In Discord, you can join multiple servers, and you must have noticed that these servers have many bots.
These bots can do a lot of things, from playing music for you to simple chat moderations.
I was really fascinated by these bots, so I decided to write one of my own using Python.
So, let's jump right in!

## SET UP

Let's first create out bot's account.
Head over to https://discordapp.com/developers/applications/me and create a new app.
Give your bot a fancy name and give it a profile picture.

![](https://i.imgur.com/GoPlxEk.pngg)

Scroll down and click on "Create Bot User".
Once done, you can get the secret bot token.

![](https://i.imgur.com/nLNeWTa.png)

And now you can click to reveal bot toke.

![](https://i.imgur.com/uljjk0q.png)

NEVER share this token with anyone, because with they can hijack your bot.
Soon after writing this I will change the token.

## CODE

Now the fun begins.

### Prerequisites

- [Python 3](https://www.python.org/downloads/)
- [pip](https://pypi.python.org/pypi/pip)

### Discord.py (rewrite)

Now we're going to install the rewrite version of the discord.py library.
The discord.py on pip is not actively maintained, so install the rewrite version of the library.

```
$ python3 -m pip install -U https://github.com/Rapptz/discord.py/archive/rewrite.zip
```

To check what version of discord.py you're using,

```
>>> import discord
>>> discord.__version__
'1.0.0a'
```

Now that we are set, let's down to writing the bot.

```
import discord
from discord.ext import commands
```

If this gives `ModuleNotFoundError` or `ImportError` then there's something wrong with your discord.py installation.

```
bot = commands.Bot(command_prefix='$', description='A bot that greets the user back.')
```

The command prefix is what the message content must contain initially to have a command invoked.

```
@bot.event
async def on_ready():
    print('Logged in as')
    print(bot.user.name)
    print(bot.user.id)
    print('------')
```

`on_ready()` called when the client is done preparing the data received from Discord.
Usually after bot's login is successful.

Now let's add some functions to our bot.

```
@bot.command()
async def add(ctx, a: int, b: int):
    await ctx.send(a+b)

@bot.command()
async def multiply(ctx, a: int, b: int):
    await ctx.send(a*b)

@bot.command()
async def greet(ctx):
    await ctx.send(":smiley: :wave: Hello, there!")

@bot.cmmands()
async def cat(ctx):
    await ctx.send("https://media.giphy.com/media/JIX9t2j0ZTN9S/giphy.gif")
```

Before running it, the bot must be invited to your server.
This OAuth2 url can be generated from your bot's settigns page.
Head over to https://discordapp.com/developers and click on your bot's profile and generate the oAuth2 url.

![](https://i.imgur.com/PZEjaVD.png)

This is where you'll decide what permissions to give tothe bot.
For our usage right now, we will just need permission to send messages.

Now run the bot by running this in command-line.

```
$ python bot.py
```

![](https://i.imgur.com/pG00LmA.png)

Now, let's test out bot.

![](https://i.imgur.com/EZM6XUq.png)

![](https://i.imgur.com/wsf0Hyp.png)

There's a list of good practices that should be followed while making a Discord bot.
I suggest you read the entire document here https://github.com/meew0/discord-bot-best-practices

> Have an info command.
> It should provide information about the bot such as what framework it is using and the used version, help command and, most importantly, who made it.

```
@bot.command()
async def info(ctx):
    embed = discord.Embed(title="nice bot", description="Nicest bot there is ever.", color=0xeee657)
    
    # give info about you here
    embed.add_field(name="Author", value="<YOUR-USERNAME>")
    
    # Shows the number of servers the bot is member of.
    embed.add_field(name="Server count", value=f"{len(bot.guilds)}")

    # give users a link to invite thsi bot to their server
    embed.add_field(name="Invite", value="[Invite link](<insert your OAuth invitation link here>)")

    await ctx.send(embed=embed)
```

![](https://i.imgur.com/f2QJ9fn.png)

The discord.py generates an `help` command automatically.
So, to write our own, we would first have to remove the one given by it.

```
bot.remove_command('help')
```

Now we can write our own `help` command. Here you decribe usage of your bot.

```
@bot.command()
async def help(ctx):
    embed = discord.Embed(title="nice bot", description="A Very Nice bot. List of commands are:", color=0xeee657)

    embed.add_field(name="$add X Y", value="Gives the addition of **X** and **Y**", inline=False)
    embed.add_field(name="$multiply X Y", value="Gives the multiplication of **X** and **Y**", inline=False)
    embed.add_field(name="$greet", value="Gives a nice greet message", inline=False)
    embed.add_field(name="$cat", value="Gives a cute cat gif to lighten up the mood.", inline=False)
    embed.add_field(name="$info", value="Gives a little info about the bot", inline=False)
    embed.add_field(name="$help", value="Gives this message", inline=False)

    await ctx.send(embed=embed)
```

![](https://i.imgur.com/JfnOhW9.png)

CONGRATULATIONS! You've just created a Discord bot written in Python.

## HOSTING

For now, the bot will only be online till you're running the script.
So, in case you want your bot to run all the time, you have to host it online or you can also host it locally, for example on a RaspberryPi.
Hosting services range widely from Free(Heroku's free tier) to Paid(Digital Ocean).
I run my bot on Heroku's free tier, and haven't faced any issue so far.

## Source code

```
import discord
from discord.ext import commands

bot = commands.Bot(command_prefix='$')

@bot.event
async def on_ready():
    print('Logged in as')
    print(bot.user.name)
    print(bot.user.id)
    print('------')

@bot.command()
async def add(ctx, a: int, b: int):
    await ctx.send(a+b)

@bot.command()
async def multiply(ctx, a: int, b: int):
    await ctx.send(a*b)

@bot.command()
async def greet(ctx):
    await ctx.send(":smiley: :wave: Hello, there!")

@bot.command()
async def cat(ctx):
    await ctx.send("https://media.giphy.com/media/JIX9t2j0ZTN9S/giphy.gif")

@bot.command()
async def info(ctx):
    embed = discord.Embed(title="nice bot", description="Nicest bot there is ever.", color=0xeee657)
    
    # give info about you here
    embed.add_field(name="Author", value="<YOUR-USERNAME>")
    
    # Shows the number of servers the bot is member of.
    embed.add_field(name="Server count", value=f"{len(bot.guilds)}")

    # give users a link to invite thsi bot to their server
    embed.add_field(name="Invite", value="[Invite link](<insert your OAuth invitation link here>)")

    await ctx.send(embed=embed)

bot.remove_command('help')

@bot.command()
async def help(ctx):
    embed = discord.Embed(title="nice bot", description="A Very Nice bot. List of commands are:", color=0xeee657)

    embed.add_field(name="$add X Y", value="Gives the addition of **X** and **Y**", inline=False)
    embed.add_field(name="$multiply X Y", value="Gives the multiplication of **X** and **Y**", inline=False)
    embed.add_field(name="$greet", value="Gives a nice greet message", inline=False)
    embed.add_field(name="$cat", value="Gives a cute cat gif to lighten up the mood.", inline=False)
    embed.add_field(name="$info", value="Gives a little info about the bot", inline=False)
    embed.add_field(name="$help", value="Gives this message", inline=False)

    await ctx.send(embed=embed)

bot.run('NDE0MzIyMDQ1MzA0OTYzMDcy.DWl2qw.nTxSDf9wIcf42te4uSCMuk2VDa0')
```


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
