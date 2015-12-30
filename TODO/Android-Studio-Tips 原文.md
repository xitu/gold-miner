Welcome to the Android-Studio-Tips-by-Phillipe-Breault wiki!

Ι am creating this Repository because i think every Android Studio Tip that Phillipe Breault is posting **NEEDS** to be recorded :) 

I will keep updating this repository with every new Tip.

Stay tuned !!

Credits to: [Philippe Breault](https://plus.google.com/u/0/+PhilippeBreault)

# Analyze Data flow to Here

This will take the current variable, parameter or field and show you the path it has taken to get here!

This is very useful when you are entering an unfamiliar place in the code base and you want to understand how this parameter got there.

Additional Tip:
 - There is also the reverse operation "Analyze Data Flow from Here" that will show you where your variable, field or return type will end up.

Shortcut : There is no shortcut for this...
 - Menu: **Analyze → Analyze Data Flow to Here**
 - Find action: **Analyze Data Flow to Here﻿**

![](https://lh4.googleusercontent.com/-Fv4MxHWIdHw/VCFWY4Ykv0I/AAAAAAAANoQ/YVe2hmnkAPE/w667-h348-no/31-analyzedataflow.gif)

# Analyze Stacktrace

This will take a stacktrace and make it clickable just as if it had been shown in logcat. 
This is particularly useful when copying a stacktrace from a bug report or from a terminal.

Additional tip:
 - You can also analyze a proguarded stack trace using the "ProGuard Unscramble Plugin"

Shortcut : There is no shortcut for this...
 - Menu: **Analyze → Analyze Stacktrace**
 - Find action: **analyze stacktrace﻿**

![](https://lh3.googleusercontent.com/-ud2l1QdHTow/VCAEACCK1bI/AAAAAAAANmY/5a3od9nIm2E/w676-h392/30-analyzestacktrace.gif)


# Attach Debugger

Start debugger even if you didn't start the app in debug mode.
This is very useful since you don't have to redeploy the app to start debugging.
It is pretty useful also when somebody is testing the app, encounters a bug and gives you his device. 

Shortcut: 
  - Mouse: **click on its icon or select the menu item Build → Attach to Android Process**
  - There is no keyboard shortcut but you should create one!﻿

![](https://lh3.googleusercontent.com/-yOySWA1dWPU/VBgiH8KnkGI/AAAAAAAANfU/0E6-y0u5sic/w378-h236-no/26-attachdebugger.gif)


# Bookmarks

Surprise! This lets you mark a spot so that you can come back to it later!

Toggle Bookmark: **f3(mac)** or **f11(windows/linux)**

Toggle Bookmark with mnemonic: **alt+f3(mac)** or **ctrl+f11(windows/linux)**

Show Bookmark: **cmd+f3(mac)** or **shift+f11(windows/linux)**

Do you have another keymap? Look up the shortcuts to the right of this menu: **Navigate → Bookmarks**

Additional tips:
 - If you use **Navigate → Bookmarks → Toggle Bookmark** with Mnemonic and assign it a <number>, you can go back to the bookmark using this shortcut: **ctrl+<number>**
 - You can get a list of your current bookmarks in **Navigate → Bookmarks → Show Bookmarks**. This list is searchable.﻿

![](https://lh4.googleusercontent.com/-Srf301d5soU/U_M7Y6YtTpI/AAAAAAAAM2w/o5cIvPjGwNo/w848-h371-no/07-bookmarks.gif)


# Collapse Expand Code Block

Menu: **Code → Folding → Expand/Collapse**

The goal of this feature is to let you hide things you don't care about at the moment.
In its simplest form, it will hide a whole code block (e.g. ignoring the import list when you open a new file). A more interesting use is that it will hide the boilerplate around simple anonymous inner classes and make it look like a lambda expression.

Additional tip:
 - You can setup the default folding behaviour in the preferences at Editor → Code Folding﻿

Shortcut: **cmd+plus/minus(mac)** or **ctrl+shift+plus/minus(windows/linux)**

![](https://lh4.googleusercontent.com/-sx5EajIBZsY/U_HpxtCFalI/AAAAAAAAM1Q/T-8P33ntdlE/w268-h147-no/06-codefolding.gif)


# Column Selection

Enable column selections, also known as block selection.
Basically, if you select down, it will go down and not bother wrapping to the end of the line.

This will also put a cursor after each line of the block selection from where you can type.

Shortcut : 
 - Mouse: **Alt+MouseDrag**
 - Mac : **Cmd+Shift+8**
 - Windows/Linux: **Shift+Alt+Insert﻿**

![](https://lh5.googleusercontent.com/-sw7u-9Usecg/VCP-tea3SEI/AAAAAAAANr4/Cyla2sVqsUI/w497-h137-no/33-columnselection.gif)


# Compare With Branch(Git)

Assuming that your project is under Git, you can compare the current file or folder with another branch.

Pretty useful to get an idea of how much you have diverged from your main branch.


Shortcut :
  - Menu : **VCS -> Git -> Compare With Branch** 
  - Find Actions: **Compare With Branch﻿**

![](https://lh6.googleusercontent.com/-xW1J3BBZHZc/VC6FVCMexWI/AAAAAAAAN8M/GEJqszoqzXk/w570-h328-no/38-comparewithbranch.gif)


# Compare With Clipboard

This will take the current selection and do a diff with the content of your clipboard.

Shortcut:
- Mouse: **right-click** the selection and select **Compare With Clipboard**
- Find action: **compare with clipboard﻿**

![](https://lh6.googleusercontent.com/-6rDn8kL7Pgw/VClEM13oYKI/AAAAAAAAN0o/JWiduW1pWsU/w519-h265-no/34-comparewithclipboard.gif)


# Complete Statement

This will generate the missing code to complete a statement
The usual use cases are:
  - Add a semicolon at the end of the line, even if you are not at the end of the line
  - Add the parentheses and curly braces after an if, while or for
  - Add the curly braces after a method declaration

Additional Tip:
 - If a statement is already completed, it will go to the next line even if you are not at the last character of the current line.

Shortcut: 
 - Mac: **Cmd+Shift+Enter**
 - Windows/Linux: **Ctrl-Shift-Enter﻿**

![](https://lh6.googleusercontent.com/-oZeWSimrvoU/VAWr5QoA-oI/AAAAAAAANQE/0LxL0LkN8Jw/w281-h124-no/16-completestatement.gif)


# Conditional Breakpoints

In a nutshell, only do break when a certain condition is met. You can enter any java expression that returns a boolean based on the current scope. 
And do enjoy the fact that the condition textbox supports code completion!

Shortcut: 
  - **Right click on a breakpoint and enter a condition**.﻿

![](https://lh6.googleusercontent.com/-p9k6JiNLQmY/VBAweflrkYI/AAAAAAAANX8/gCaufjGbd1c/w514-h264-no/22-conditionalbreakpoint.gif)


# Context Info


So this will show you where you are when your scope definition is out of the scrolling area. Usually, this will be the name of the class or inner class  but it might also be the current method name.

Its better use, IMHO, is to get a quick look at what the current class extends or implements.

It also works in xml files.

Shortcut: **Alt+Q**

![](https://lh4.googleusercontent.com/-FNg2h15F4c0/VD-rJupXgkI/AAAAAAAAOL4/lfaQmbjwpaw/w574-h174-no/47-contextinfo.gif)


# Delete Line

It deletes the current line without having to select it.
If a block is already selected, it will delete every line in the selection.

Shortcut: **cmd+backspace(mac)** or **ctrl+y(windows/linux)﻿**

![](https://lh3.googleusercontent.com/-bP5WOVMfp7A/U_cpQi0bvhI/AAAAAAAAM9c/dcvvJu1US40/w265-h103-no/10-deleteline.gif)


# Disable Breakpoints

This will disable the breakpoint. Particularly useful when you have some complicated conditional or logging breakpoint that you don't need right now but don't want to recreate next time.

Shortcut: 
  - Mouse: **Alt+LeftClick** on an existing breakpoint in the left gutter
  - There is no keyboard shortcut but you can create one if you use it often enough.﻿

![](https://lh3.googleusercontent.com/-hNk0kuL1WBM/VBbQXamG8-I/AAAAAAAANeM/ynfSJ5hqCvA/w365-h235-no/25-diablebreakpoint.gif)


# Duplicate Line

Just as it says: it will copy the current line and paste it below without interfering with your clipboard. It can be pretty useful when it's used with the move line shortcut!

Shortcut: **cmd+d(mac)** or **ctrl+d(windows/linux)﻿**

![](https://lh6.googleusercontent.com/-1dno1jn2Pcg/U_sfhOxXTkI/AAAAAAAANC8/8sl3TVz1dAo/w265-h103-no/11-duplicate_lines.gif)


# Edit Regex

Editing a regex in Java is a bit difficult for a couple of reasons
1) You have to escape the backslashes
2) Let's face it, regex are hard!
3) See point #2

So what can the IDE do to help us? Give us a nice interface to code and test regexes of course!

Shortcut: **Alt+Enter → check regexp**

![](https://lh4.googleusercontent.com/-zinVQioQi0c/VGX3txYe0iI/AAAAAAAAO5c/D5nhpSSyImk/w419-h170-no/68-checkregexp.gif)


# Enter vs Tab for Code Completion

There is an interesting difference whether you use code completion with tab or with enter. 

Using enter will complete the statement as you would expect.
Using tab will complete the statement and delete everything forward until the next dot, parentheses, semicolon or space.

Shortcut (during code completion): **enter or tab**

![](https://lh3.googleusercontent.com/-zkDYRijGp4A/VD0KtdkrqFI/AAAAAAAAOJE/wEr134jmFxE/w252-h123-no/45-codecompletionentertab.gif)


# Evaluate Expression

This is used to inspect a variable's content and evaluate pretty much any valid java expression right there, right now.
Just be aware that if you are mutating state, it will stay that way when you resume the execution of the program.

Shortcut: **Alt+F8﻿**


![](https://lh5.googleusercontent.com/-yVa3T6tUVJE/VBls7HooneI/AAAAAAAANg0/MtJpIKCVEws/w739-h215-no/27-evaluateexpression.gif)


# Extract Method

Following in my streak of extract refactoring, here is the one to extract a code block in a new method.

This thing is extremely useful. Whenever you encounter a method that is starting to become a bit complex, you can use this to safely extract a portion in another method. I say safely because the IDE won't make a silly copy-paste mistake like we might do.

Additional tip:
  - Once you are in the extracting dialog, you can change the visibility of the method and the parameter names.

Shortcut (Menu):
 - Mac: **Cmd+Alt+M**
 - Windows/Linux: **Ctrl+Alt+M**
![](https://lh3.googleusercontent.com/-9QE0n8if48M/VEpNnAADJvI/AAAAAAAAOaA/hdn-oMyW-VA/w584-h458-no/53-extractmethod.gif)


# Extract Parameter

This is a shortcut to extract a parameter without going through the refactoring menu.

This thing is useful when you realize that a method could be generified by extracting one part as a parameter. The way it works is that it will take the current value, make it a parameter and copy the old value as the parameter for each caller.

Additional tip:
  - You can also keep the original method and have it delegate to the new one by ticking the "delegate" box.

Shortcut (Menu):
 - Mac: **Cmd+Alt+P**
 - Windows/Linux: **Ctrl+Alt+P**

![](https://lh6.googleusercontent.com/-056PKjDxw7U/VEjoRXblk9I/AAAAAAAAOXo/DWOEUMikWMU/w474-h263-no/52-extractparam.gif)


# Extract Variable

This is a shortcut to extract a variable without going through the refactoring menu.

This is very useful when you are generating code on the fly as you can avoid typing the variable declaration and go straight to the value. The IDE will then generate the declaration and it will come up with some suggestions on how to name the variable.

Additional tip:
  - If you want to change the declaration type to something more generic (e.g. List instead of ArrayList), you can press Shift+Tab and it will give you a list of valid types.

Shortcut (Menu):
 - Mac: **Cmd+Alt+V**
 - Windows/Linux: **Ctrl+Alt+V**

![](https://lh3.googleusercontent.com/-76GH8fwlP8w/VEeXW1x5qcI/AAAAAAAAOV0/Y_DTUoO5V-c/w368-h269-no/51-extractvariable.gif)


# Find Actions

You can invoke any menu or action known to Android Studio by its name! This is pretty useful for commands that you use once in a while but don't have a shortcut for.

Additional tip:
 - If there is a shortcut associated to the action, it will be shown by its side﻿

Shortcut: **cmd+shift+a(mac)** or **ctrl+shift+a(windows/linux)**

![](https://lh3.googleusercontent.com/-1R5g6c953Pc/U_SJUUK_zZI/AAAAAAAAM4A/78kPgI_U5X4/w500-h233-no/08-findaction.gif)


# Find Complection

When you do a find in files, invoking the autocomplete shortcut will suggest words that are in the current file.

Shortcut: 
  Mac: **Cmd+F** , type something and autocomplete
  Windows/Linux: **Ctrl+F**, type something and autocomplete

![](https://lh4.googleusercontent.com/-8HBauw90IYU/VFoSq77EbfI/AAAAAAAAOss/_8BMNjgAst4/w418-h268-no/61-findcompletion.gif)


# Hide All Panels

Puts the editor in some sort of full screen mode.
Invoking the shortcut a second time returns all panels to their previous state.

Shortcut :
  - Mac: **Cmd+Shift+F12**
  - windows/linux: **Ctrl+Shift+F12**

![](https://lh5.googleusercontent.com/-I5KEtqjL6cc/VDZuyxdTi7I/AAAAAAAAOB8/jrMR5xhtmEI/w566-h387-no/42-hideallwindows.gif)


# Hightlight All the Things

Look up the shortcut to the right of this menu: **Edit → Find → Highlight Usages in File**

This will highlight every occurrence of a symbol in the current file. This is more than some simple pattern matching, it will actually understand the current scope and  only highlight what is relevant.

You can then navigate up or down using the shortcuts from **Edit → Find → Find Next/Previous**

Additional tips:
 - Highlighting a "return" or a "throw" statement in a method will also highlight all the exit points of the method.
 - Highlighting the "extends" or the "implements" portion of the class definion will also highlight the methods that are overriden/implemented.
 - Highlighting an import will also highlight where it is used.
 - You can cancel the highlighting by pressing Escape﻿

![](https://lh4.googleusercontent.com/-PHQFYqcYi58/U-tQtazuCbI/AAAAAAAAMrE/SGNBmtGwMAk/w198-h184-no/01-highlight.gif)


# Inline

So you have gone a bit crazy with extraction and now you have too much stuff? You can do the reverse operation, which is called "inline".

This will work with methods, fields, parameters and variables.

Shortcut:
 - Mac: **Cmd+Alt+N**
 - Windows/Linux: **Ctrl+Alt+M﻿**

![](https://lh6.googleusercontent.com/-OgvCsxlSlhk/VE4ztIVmEgI/AAAAAAAAOc4/TJdTcGGzeZc/w495-h232-no/54-inline.gif)


# Inspect Variable

This evaluates an expression without opening the Evaluate Expression dialog

Shortcut: **Alt+LeftClick** on an expression﻿

![](https://lh3.googleusercontent.com/-e8FaMIQ-o4g/VBq_YKo27NI/AAAAAAAANiQ/RLl4c4nQCMQ/w783-h250-no/28-mouse_evaluate_expression.gif)


# Join Lines and Literals

This is doing more than simulating the delete key at the end of the line!
It will preserve formatting rules and it will also:
  - Merge two comment lines and remove the unused //
  - Merge multiline strings, removing the + signs and the double-quotes
  - Join fields and assignments

Additional Tip:
  - If you select a string that spans multiple lines, it will merge it on a single one.

Shortcut: **Ctrl+Shift+J﻿**

![](https://lh3.googleusercontent.com/-B18BYlHuIe0/VAhGAtACHPI/AAAAAAAANSc/GzYIuGENiXU/w365-h303-no/18-joinlines.gif)


# Jump to Last Tool Window

Sometimes, you return to the editor from a panel but find yourself having to go back to this panel.
e.g. browsing find usages.
With this, you can go back to the previous panel without your mouse.

Shortcut: **F12**  (might interfere with the OS's default keybindings)﻿

![](https://lh5.googleusercontent.com/-1i-62oPE1_c/VDUgjA0EglI/AAAAAAAAOAc/zHw0D-zDW8c/w495-h176-no/41-lasttoolwindow.gif)


# Last Edit Location

This will make you navigate through the last changes you made. 
This is different from clicking the back arrow in the toolbar in that it makes you travel within your edition history and not your navigation history.

Shortcut: 
 - Mac: **Cmd+Shift+Backspace**
 - Windows/Linux: **Ctrl-Shift-Backspace﻿**

![](https://lh3.googleusercontent.com/-I7EB361tSvQ/VAcAhKjmftI/AAAAAAAANQw/WJ12zWckTx0/w339-h100-no/17-navigate-previous-changes.gif)


# Live Templates

The live template is a way to quickly insert a snippet of code. The interesting thing with live templates is that they can be parameterized with sensible defaults and guide you through the parameters when you insert it.

Additional Tip:
  - You don't need to invoke the shortcut if you know the abbreviation. You only need to type it and complete using the Tab key.

Shortcut: 
 - Mac: **Cmd+J**
 - Windows/Linux: **Ctrl+J﻿**

![](https://lh5.googleusercontent.com/-uDazeA2SuDU/VABeDd244gI/AAAAAAAANL0/LvID7zv5dbA/w456-h258-no/15-live_templates.gif)

## Logging Breakpoints

This is a breakpoint that logs stuff instead of breaking.
This can be useful when you want to log some stuff right now but cannot or don't want to redeploy with logging code added.

Shortcut: 
  - **Right click on a breakpoint, uncheck Suspend and type your message in "Log evaluated Expression"﻿**

![](https://lh6.googleusercontent.com/-HCtmbS0lEX4/VBGLfCszvyI/AAAAAAAANZg/pnjHOIPJP4U/w601-h470-no/23-loggingbreakpoints.gif)


# Mark Object

During a debugging session, this will let you add a label to a particular object so that you can identify it later.
Very useful in those debugging sessions where you have a bunch of similar object and you want to know if it is the same one as before.

Shortcut (from the variables or watch panel):
 - Mouse: **right-click** and select **"Mark Object"**
 - OSX : **F3** with the object selected 
 - Windows/Linux: **F11** with the object selected

![](https://lh5.googleusercontent.com/-YucV0sOVgXE/VBwUt3L0gWI/AAAAAAAANjk/24G70gPtFv0/w607-h301-no/29-markobject.gif)﻿


# Move Line Up Down

Yeah. This will move lines up or down without copy-pasting. Not much more to say. Enjoy!

Shortcut: **Alt+Shift+Up/Down﻿**

![](https://lh5.googleusercontent.com/-vkDNFuL049E/U_XXi3NMx9I/AAAAAAAAM58/dwQ6qz2vCWY/w279-h122-no/09-movelines.gif)


# Move Between Methods and Inner Classes

Look up the shortcut to the right of these menus: **Navigate → Next Method and Navigate → Previous Method**
Chances are that it will be **ctrl+up/down** on a Mac and **alt+up/down** on Windows and Linux.

This wil move your cursor to the name of the next method or class in the current file.

Additional tip:
 - If you are in the body of a method, going up will put the cursor on its name. This can be very useful because it puts you at the right place to refactor or find the usages of this method.﻿

![](https://lh4.googleusercontent.com/-FXLgOWtteIo/U-ygY2U1y1I/AAAAAAAAMsQ/hxJUIs_kgvw/w425-h414-no/02-move_between_methods.gif)


# Move Methods

This is like the Move Line shortcut but applied to whole methods.
It allows you to move a method below or above another one without copy-pasting.

The real name of this action is Move Statement. Meaning that it moves any kind of statement. E.g. you can reorder fields and inner classes. However, I found that moving method is pretty much its only day-to-day use

Shortcut:
- Mac: **Cmd+Alt+Up / Cmd+Alt+Down**
- Windows/Linux: **Ctrl-Shift-Up / Ctrl-Shift-Down**

![](https://lh6.googleusercontent.com/-mZG5Fj_QM_Q/VARxn8TXmkI/AAAAAAAANOk/ASUpXpD-NLg/w264-h266-no/15-movemethods.gif)


# Navigate to Nested File

Sometimes you have a couple of files that have the exact same name but are in different directory. E.g. many AndroidManifest.xml in different modules.
So when you try to navigate to a file, you get a bunch of results and have to think which one you need.

By prefixing a portion of the path and adding a slash to your search query, you can get the right one on the first try.

Shortcut: 
  Mac: **Cmd+O**, then type it!
  Windows/Linux: **Ctrl+N**, then type it!

![](https://lh6.googleusercontent.com/-23C2Q2S0c2E/VFzEI5iu0GI/AAAAAAAAOwM/Os1jGMHGVIA/w418-h268-no/63-nestednavigation.gif)


# Navigate to Parent

If you are in a method that is overriding a parent class (e.g. Activity#onCreate()), it will navigate to the parent implementation.

If you are on the class name, it will navigate to the parent class.

Shortcut :
  - Mac: **Cmd+U**
  - Windows/Linux: **Ctrl+U**

![](https://lh3.googleusercontent.com/-HCX5cbjkiuo/VDJ-dJa7wUI/AAAAAAAAN-M/dW0h7cQ9l0Y/w416-h290/39-navigatetoparent.gif)


# Negation Completion

Sometimes you autocomplete a boolean and then you go back to the beginning to add a "!" in front of it to negate it. 
Turns out that that you can skip that part **by pressing the "!" key** instead of the enter key to auto-complete it. 

Shortcut (during code completion on a boolean): **!**

![](https://lh5.googleusercontent.com/-L971XD2Nezg/VFN0qljSJQI/AAAAAAAAOj8/5k9fkjOwjIQ/w466-h254-no/58-negatecompletion.gif)


# Open a Panel by Its Number

You might have noticed that some of the panels have a number to the left of their name.
That's a shortcut to open them!

Just in case you don't see the panel names, click the box thing in the lower left corner of the IDE.

Shortcut :
  - Mac: **Cmd+Number**
  - Windows/Linux: **Alt+Number**

![](https://lh3.googleusercontent.com/-9qiNX0P0KSk/VDfBFEAKW8I/AAAAAAAAOD4/HytPoJV07BA/w567-h387-no/42-openpanelbynumber.gif)


# Open File Externally

With this shortcut, you can open your file navigator to the current file or any of its parent folder simply by clicking on its tab.

Shortcut (on a file tab): 
  Mac: **Cmd+Click**
  Windows/Linux: **Ctrl+Alt+F12**

![](https://lh5.googleusercontent.com/-EAoir3ZP1bM/VFtyO5OaU_I/AAAAAAAAOug/b6jeKDVT-BM/w418-h268-no/62-openfinder.gif)


# Open File Externally

With this shortcut, you can open your file navigator to the current file or any of its parent folder simply by clicking on its tab.

Shortcut (on a file tab): 
  Mac: **Cmd+Click**
  Windows/Linux: **Ctrl+Alt+F12**

![](https://lh5.googleusercontent.com/-EAoir3ZP1bM/VFtyO5OaU_I/AAAAAAAAOug/b6jeKDVT-BM/w418-h268-no/62-openfinder.gif)


# Parameter Info

This is the same list of parameter names as the one that appears when you are writing a method call. It is useful when you want to see an existing method's params.

The Parameter under your cursor will be in yellow.
If nothing is in yellow, that means that the method call is not valid, probably something that is not casted right (e.g. a float in an int param).

When you are writing a method call and you dismiss it by accident, like I usually do, you can also type a comma (,) to trigger the parameter info. 

Shortcut :
  - Mac: **Cmd+P**
  - windows/linux: **Ctrl+P**

![](https://lh4.googleusercontent.com/-npufWa5yynk/VDvJpJ717BI/AAAAAAAAOHs/Sx3OHdapfRk/w472-h195-no/44-parameterinfo.gif)


# Postfix Completion

You can think of it as a code completion that will generate code before the dot instead of after it. In fact, you invoke it just like a regular code completion: you type a dot after an expression.

E.g. to iterate a list, you could go "myList.for", press tab and it would generate the for loop for you.

You can get a list of what you can type by typing a dot after a statement and looking at the postfix keywords that come right after the regular code completion keywords. There is also a list of all available keywords in Editor → Postfix Completion

Some of my personal favorites:
- **.for** (for a foreach)
- **.format** (wraps a string in String.format())
- **.cast** (wraps an expression in a type cast)﻿

![](https://lh5.googleusercontent.com/-rLMdeb9cbBM/VCVUw0Y656I/AAAAAAAANt8/J2KiRPMjRzs/w474-h136-no/33-postfixcompletion.gif)


# Quick Definition Lookup

Ever wondered whats the implementation of a method or class but don't want to lose your current context?
Use this shortcut to look it up in place.﻿

Shortcut: **alt+space(cmd+Y)(mac)** or **ctrl+shift+i(windows/linux)**

![](https://lh4.googleusercontent.com/-m6b46h-k1ac/U_Ca197xNxI/AAAAAAAAMyQ/6W2kUyV6Ru0/w584-h191-no/05-quickdefinition.gif)


# Recently Changed Files

This is a variation of the "Recents" popup that lists files that were recently modified locally.
It is sorted in order of modification (most recently edited on top).
A nice bonus is that you can type to filter the list.

Shortcut (Menu):
 - Mac: **Cmd+Shift+E**
 - Windows/Linux: **Ctrl+Shift+E**

![](https://lh4.googleusercontent.com/-_WNvGPZ3az0/VET1ysjYmEI/AAAAAAAAOSA/bpAbyKszjtU/w411-h365-no/49-recentlyedited.gif)


# Recents

Using this, you get a searchable list of the most recently consulted files!

Shortcut: 
 - Mac: **Cmd+E**
 - Windows/Linux: **Ctrl+E﻿**

![](https://lh3.googleusercontent.com/-EPVBvnrdPgM/U_8OI4fcZfI/AAAAAAAANKE/FjVm2bKiJzA/w480-h300-no/14-recents.gif)


# Refactor This

It helps you navigate between your layout and your activity/fragment with ease.
There is also a shortcut in the gutter next to the class name and one at the top of the layout file.

Shortcut (Menu):
 - Mac: **Ctrl+Cmd+Up**
 - Windows/Linux: **Ctrl+Alt+Home**

![](https://lh5.googleusercontent.com/-S_zwUzYS4gk/VEZBrBGH0lI/AAAAAAAAOUw/n7QoGhegtZQ/w480-h206-no/50-relatedfile.gif)


# Related File

It helps you navigate between your layout and your activity/fragment with ease.
There is also a shortcut in the gutter next to the class name and one at the top of the layout file.

Shortcut (Menu):
 - Mac: **Ctrl+Cmd+Up**
 - Windows/Linux: **Ctrl+Alt+Home**

![](https://lh5.googleusercontent.com/-S_zwUzYS4gk/VEZBrBGH0lI/AAAAAAAAOUw/n7QoGhegtZQ/w480-h206-no/50-relatedfile.gif)


# Rename

With this, you can rename a variable, field, method, class and event package.
This will, of course, make sure that the renaming makes sense in the context of your app, it won't simply do a find and replace in all files!

Additional Tip:
  - If you can't remember this shortcut, you can always invoke the quick fix shortcut and it will always include the rename refactoring.

Shortcut: **Shift+F6**

![](https://lh4.googleusercontent.com/-ARaBtgwf8cc/VE97brZNoII/AAAAAAAAOeE/0JlFDxsxH5g/w332-h177-no/55-rename.gif)


# Return to the Editor

A bunch of shortcuts will take you away from the editor (type hierarchy, find usages, etc.)
If you want to return to the editor, your options are:
  - Escape: This will simply return the cursor to the editor.
  - Shift+Escape: This will close the current panel and then return your cursor to the editor.

Shortcut :
  - Return and keep panel open: **Escape**
  - Close panel and Return: **Shift+Escape**

![](https://lh6.googleusercontent.com/-q4dM4dIngCI/VDPLU9ZaohI/AAAAAAAAN_g/5IEsckp4usI/w550-h299-no/40-returntoeditor.gif)


# Select In

Takes the current file and asks you where to select it.
The most useful shortcuts IMHO are to open in the project structure or in your file explorer.

Note that each action is prefixed by a number or a letter, this is the shortcut to invoke it quickly.

Usually, I'll go **Alt+F1** then **Enter** to open in the project view and **Alt+F1+** to reveal the file in Finder on the Mac.

You can invoke this from a file or directly from the project view.

Shortcut: **Alt+F1﻿**

![](https://lh5.googleusercontent.com/-MFV8-JsmzSU/VAmquOrEs8I/AAAAAAAANT0/_2TV_0RGtgg/w449-h337-no/19-select-in.gif)


# Semicolon Dot Completion

Code completion is great and we are probably already familiar with the usual case: start typing something, we get some suggestions from the IDE and we accept the one we like with enter or tab. 

Turns out that there is still another way to accept a completion: we can type a dot or a semicolon. This will result in the completion taking place and have that character added. This is useful to finish a statement with the completion or quickly chaining method calls.

One caveat to this method: if you are completing to a method that requires parameters, they will be skipped.

Shortcut: **Autocomplete + "." or ";"**

![](https://lh4.googleusercontent.com/-rkL6r3uJeeI/VGnwEJ9ULYI/AAAAAAAAO90/biElGOpX60I/w352-h177-no/69-semicolondotcompletion.gif)


# Show Execution Point

This will put the cursor back to where you are debugging right now.

The usual case is:
1) You break somewhere
2) You start looking around in this file and then a bunch of other files
3) You invoke this shortcut to return exactly to where you were in your step-by-step debugging session

Shortcut (when debugging) : **Alt+F10**﻿

![](https://lh3.googleusercontent.com/-sXEoJvHd_QQ/VCvo5CMmOuI/AAAAAAAAN5c/zq_9YB05-3U/w443-h287-no/36-executionpoint.gif)


# Shrink Selection

This will contextually expand the current selection.
E.g. it will select the current variable, then the statement, then the method, etc. 

Shortcut: 
 - Mac: **Alt+Up/Down**
 - Windows/Linux: **Ctrl+W / Ctrl+Shift+W﻿**

![](https://lh6.googleusercontent.com/-7KdcfTVc-is/U_xh2BbGyzI/AAAAAAAANFE/joWJV9qWBB4/w357-h212-no/12-expand_shrink_selection.gif)


# Stop Process

This will stop the currently running task or show a list of possible tasks to stop if there is more than one.

Pretty useful to stop debugging or abort a build.

Shortcut : 
 - Mac : **Cmd+F2**
 - Windows/Linux: **Ctrl+F2﻿**

![](https://lh4.googleusercontent.com/-6i3EY9IZJBg/VCqVy_ab3EI/AAAAAAAAN4U/ebD7lM9J68Q/w451-h265-no/35-stoprocess.gif)


# Sublime Text Multi Selection

This one is particularly nice!
It will take the current selection, select the next occurrence and add a cursor there.
This means that you can have multiple cursors in the same file! 
Everything you type will be written at each cursor.

Shortcut : 
 - Mac : **Ctrl+G**
 - Windows/Linux: **Alt+J﻿**

![](https://lh6.googleusercontent.com/-WnxHwPuakFo/VCKmDdkETtI/AAAAAAAANqM/ZHrNT4clOZ0/w228-h146-no/32-multiselection.gif)


# Surround with

This can be used to wrap a block of code in some structure. Usually an if statement, a loop, a try-catch or a runnable.

If you have nothing selected, it will wrap the current line.

Shortcut: 
 - Mac: **Cmd+Alt+T**
 - Windows/Linux: **Ctrl+Alt+T﻿**

![](https://lh3.googleusercontent.com/-WNvPYepdWXY/U_268lLrzWI/AAAAAAAANHc/CgirqvEZTbw/w299-h167-no/13-surround_with.gif)


# Temporary Breakpoints

This is a way to add a breakpoint that will be removed automatically the first time you hit it.

Shortcut: 
  - Mouse: **Alt+LeftClick** in the left gutter
  - Mac: **Cmd+Alt+Shift+F8**
  - Windows/Linux: **Ctrl+Alt+Shift+F8﻿**

![](https://lh6.googleusercontent.com/-v8cbsJxsip0/VBLWIO7o0FI/AAAAAAAANbo/XNNiE_ZDCg0/w487-h212-no/24-temporarybreakpoints.gif)


# The Call Hierarchy Popup

This will show you the possible paths between a method's declaration and its invocations!﻿

Shortcut: **Ctrl+Alt+H**

![](https://lh6.googleusercontent.com/-Edb4Dy_berY/U-9E-x1D78I/AAAAAAAAMwg/Mq7X_Xvj-qg/w451-h384-no/04-callinghierarchy.gif)


# The File Struture Popup

The idea here is to show an outline of the current class and navigate in it. The best thing about it is that you can filter using your keyboard. This is a very efficient way to go to a method you know by name.

Additional tips:
 - You can use camel-case matching when typing to filter the list. Example: typing "oCr" would find "onCreate"
 - You can toggle a checkbox to also show anonymous classes. It could be useful in some cases like if you want to go directly to the onClick method in an OnClickListener.﻿

OSX: **cmd+f12**
Windows/Linux: **ctrl+f12 **
Other Keymap: Look up the shortcut to the right of this menu: **Navigate → File Structure**

![](https://lh6.googleusercontent.com/-oU5M7gpIox0/U-38k3PKTbI/AAAAAAAAMvY/FtzUQhfhvIc/w326-h297-no/03-filestructure.gif)


# The Switcher

So this thing is pretty much the alt+tab / cmd+tab of the IDE. It allows you to navigate to a tab or a panel.

Once it is opened, as long as you hold the ctrl key, you can navigate quickly by using the number or letter shortcut. You can also close a tab or a panel by pressing backspace when it is selected.

Shortcut: **Ctrl+Tab**

![](https://lh5.googleusercontent.com/-AUk6sHCcJVo/VD5Xhfy0uHI/AAAAAAAAOKg/O9z7RomZZ3I/w532-h349-no/46-switcher.gif)


# Unwrap Remove

This will remove the surrounding code. It could be to remove an if statement, a while, a try/catch or even a runnable.

This is exactly the opposite of the Surround With shortcut.

Shortcut: 
 - Mac: **Cmd+Shift+Delete**
 - Windows/Linux: **Ctrl+Shift+Delete﻿**

![](https://lh6.googleusercontent.com/-0k_qemxahqE/VA2Qvc28GWI/AAAAAAAANVc/haz3hyVg-nM/w546-h237-no/20-unwrap.gif)


# VCS Operations Popup

This will show you the most frequent version control operations.
If your project is not under git or another sytem, it will at least give you a local history maintained by the IDE.

Shortcut : 
  - Mac: **Ctrl+V**
  - Windows/Linux: **Alt+`**

![](https://lh4.googleusercontent.com/-ECCa5aqBxCk/VC02T6rz1gI/AAAAAAAAN7E/dtD24CNJbdg/w450-h329-no/37-vcspopup.gif)