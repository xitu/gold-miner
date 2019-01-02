
> * 原文地址：[Qt versus Wx: How do two of the most popular Python frameworks compare?](https://opensource.com/article/17/4/pyqt-versus-wxpython)
> * 原文作者：[Seth Kenlon](https://opensource.com/users/seth)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/pyqt-versus-wxpython.md](https://github.com/xitu/gold-miner/blob/master/TODO/pyqt-versus-wxpython.md)
> * 译者：
> * 校对者：

# Qt versus Wx: How do two of the most popular Python frameworks compare?

## Which Python GUI should you choose for your project?

![Qt versus Wx: How do two of the most popular Python frameworks compare?](https://opensource.com/sites/default/files/styles/image-full-size/public/images/life/code_computer_development_programming.png?itok=wMspQJcO)

Image by :opensource.com

Python is a popular language capable of scripting as well as object-oriented programming. Several frameworks provide a GUI (graphical user interface) for Python, and most of them are good at something, whether it's simplicity, efficiency, or flexibility. Two of the most popular are [wxPython](http://docs.wxwidgets.org/trunk/overview_python.html) and [PyQt](http://pyqt.sourceforge.net/Docs/PyQt5/), but how do they compare? More importantly, which should you choose for your project?

## Look and feel

Let's tackle what most users notice first and foremost—what an application looks like.

One of wxPython's unique feature is that its core libraries, written in C++, are wrappers around the native widgets of its host system. When you write code for a button widget in your GUI, you don't get something that looks like it belongs on another operating system, nor do you get a mere approximation. Rather, you get the same object as you do if you had coded with native tools.

![Thunar and WxPython on Linux](https://opensource.com/sites/default/files/wxbutton.png)

Thunar and WxPython on Linux

This is different from PyQt, which is based on the famous [Qt](https://www.qt.io/) toolkit. PyQt also is written in C++, but it does not use native widgets, and instead creates approximations of widgets depending on what OS it detects. It makes good approximations, and I've never had a user—even at an art school where users tend to be infamously pedantic about appearance—complain that an application didn't look and feel native.

If you're using KDE, you have additional [PyKDE](https://wiki.python.org/moin/PyKDE) libraries available to you to bridge the gap between raw PyQt and the appearance of your Plasma desktop on Linux and BSD, but that adds new dependencies.

![KDE and Qt on Linux](https://opensource.com/sites/default/files/qtbutton.png)

KDE and Qt on Linux

## Cross-platform

Both wxPython and PyQt support Linux, Windows, and Mac, so they're perfect for the famously cross-platform Python; however, don't let the term "cross-platform" fool you—you still must make platform-specific adjustments in your Python code. Your GUI toolkit can't adjust path formats to data directories, so you still have to exercise best practices within Python, using **os.path.join** and a few different **exit** methods, and so on. Your choice of GUI toolkit will not magically abstract from platform to platform.

PyQt works hard to shield you from cross-platform differences. Allowing for the common adjustments that Python itself requires, PyQt insulates you from most cross-platform concerns so that your GUI code stays the same regardless of OS. There are always exceptions, but PyQt handles it remarkably well. This is a luxury you'll come to appreciate and admire.

In wxPython, you may need to make a few platform-specific changes to your GUI code, depending on what you're programming. For instance, to prevent flickering of some elements on Microsoft Windows, the **USE_BUFFERED_DC** attribute must be set to **True** to double buffer the graphics. This isn't a default, even though it can be done unconditionally for all platforms, so it may have drawbacks in some use cases, but it's a good example of the allowances you must make for wxPython.

## Install

As a developer, you probably don't mind the install steps required to get the libraries you need for your application; however, if you plan to distribute your application, then you need to consider the install process that your users must go through to get your application running.

Installing Qt on any platform is as simple as installing any other application:. Give your users a link to download, tell them to install the downloaded package, and they're using your application in no time. This is true on all supported platforms.

What's also true for all platforms, however, is that PyQt depends on the C++ code of Qt itself. That means that users not only have to install PyQt, but all of Qt. That's not a small package, and it's a lot of clicking and, potentially, stepping through install wizards. The Qt and PyQt teams make the installs as easy as they possibly can be, however, so although it might seem like a lot to ask a user, as long as you provide direct links, any user who can install a web browser or a game should be able to contend with a Qt install. If you're very dedicated, you could even script the installation as part of your own installer.

On Linux, BSD, and the Ilumos family, the installs usuallyare already scripted for you by a distribution's package manager.

The install process for wxPython is as simple on Linux and Windows, but it's problematic on the Mac OS. The downloadable packages are severely out of date, another victim of Apple's disinterest in backward compatibility. A [bug ticket](http://trac.wxwidgets.org/ticket/17203) exists with a fix, but the packages haven't been updated, so chances are low that average users are going to find and implement the patch themselves. The solution right now is to package wxPython and distribute it to your Mac OS users yourself, or rely on an external package manager, (although when I last tested wxPython for Mac, even those install scripts failed).

## Widgets and features

Both PyQt and wxPython have all the usual widgets you expect from a GUI toolkit, including buttons, check boxes, drop-down menus, and more. Both support drag-and-drop actions, tabbed interfaces, dialog boxes, and the creation of custom widgets.

PyQt has the advantage of flexibility. You can rearrange, float, close, and restore Qt panels at runtime, giving every application a highly configurable usability-centric interface.

![Moving Qt panels](https://opensource.com/sites/default/files/panelmove.png)

Moving Qt panels

Those features come built in as long as you're using the right widgets, and you don't have to reinvent fancy tricks to provide friendly features for your power users.

WxPython has lots of great features, but it doesn't compare to PyQt in terms of flexibility and user control. On one hand, that means design and layout is easier on you as the developer. It doesn't take long, when developing on Qt, before you get requests from users for ways to keep track of custom layouts, or how to find a lost panel that got  closed accidentally, and so on. For the same reason, wxPython is simpler for your users, since losing track of a panel that got accidentally closed is a lot harder when panels can't be closed in the first place.

Ultimately, wxPython is, after all, just a front end for wxWidgets, so if you really needed a feature, you might be able to implement it in C++ and then utilize it in wxPython. Compared to PyQt, however, that's a tall order.

## Gears and pulleys

A GUI application is made up of many smaller visual elements, usually called "widgets." For a GUI application to function smoothly, widgets must communicate with one another so that, for example, a pane that's meant to display an image knows which thumbnail the user has selected.

Most GUI toolkits, wxPython included, deal with internal communications with "callbacks." A callback is a pointer to some piece of code (a "function"). If you want to make something happen when, for example, a button widget is clicked, you write a function for the action you want to occur. Then, when the button is clicked, you call the function in your code and the action occurs.

It works well enough, and as long as you couple it with lambdas, it's a pretty flexible solution. Sometimes, depending on how elaborate you want the communication to be, you do end up with a lot more code than you had expected, but it does work.

Qt, on the other hand, is famous for its "signals and slots" mechanism. If you imagine wxPython's internal communications network as an old-style telephone switchboard, then imagine PyQt's communication as a mesh network.

![Qt diagram](https://opensource.com/sites/default/files/abstract-connections.png)

Signals and Slots in Qt ([Qt diagram](https://doc.qt.io/qt-4.8/signalsandslots.html) GFDL license)

With signals and slots, everything gets a signature. A widget that emits a signal doesn't need to know what slot its message is destined for or even whether it's destined for any slot at all. As long as you connect a signal to a slot, the slot gets called with the signal's parameters when the signal is broadcast.

Slots can be set to listen for any number of signals, and signals can be set to broadcast to any number of slots. You can even connect a signal to another signal to create a chain reaction of signals. You don't ever have to go back into your code to "wire" things together manually.

Signals and slots can take any number of arguments of any type. You don't have to write the code to filter out the things you do or do not want under certain conditions.

Better still, slots aren't just listeners; they're normal functions that can do useful things with or without a signal. Just as an object doesn't know whether anything is listening for its signal, a slot doesn't know whether it's listening for a signal. No block of code is ever reliant upon a connection existing; it just gets triggered at different times if there is a connection.

Whether or not you understand signals and slots, once you use them and then try going back to traditional callbacks, you'll be hooked.

## Layout

When you program a GUI app, you have to design its layout so that all the widgets know where to appear in your application window. Like a web page, you might choose to design your application to be resized, or you might constrain it to a fixed size. In some ways, this is the GUI-est part of GUI programming.

In Qt, everything is pretty logical. Widgets are sensibly named (**QPushButton**, **QDial**, **QCheckbox**, **QLabel**, and even **QCalendarWidget**) and are easy to invoke. The documentation is excellent, as long as you refer back to it frequently, and discovering cool features in it is easy.

There are potential points of confusion, mostly in the base-level GUI elements. For instance, if you're writing an application, do you start with a **QMainWindow** or **QWidget** to form your parent window? Both can serve as a window for your application, so the answer is, as it so often is in computing: It depends.

**QWidget** is a raw, empty container. It gets used by all other widgets, but that means it can also be used as-is to form the parent window into which you place more widgets. **QMainWindow**, like all other widgets, uses **QWidget**, but it adds lots of convenience features that most applications need, like a toolbar along the top, a status bar at the bottom, etc.

![QMainwindow](https://opensource.com/sites/default/files/qmainwindow.png)

QMainwindow

A small text editor using **QMainWindow** in just over 100 lines of Python code:



    #!/usr/bin/env python
    # a minimal text editor to demo PyQt5

    # GNU All-Permissive License
    # Copying and distribution of this file, with or without modification,
    # are permitted in any medium without royalty provided the copyright
    # notice and this notice are preserved.  This file is offered as-is,
    # without any warranty.

    importsys
    importos
    importpickle
    from PyQt5 import *
    from PyQt5.QtWidgetsimport *
    from PyQt5.QtCoreimport *
    from PyQt5.QtGuiimport *

    class TextEdit(QMainWindow):
    def__init__(self):

        super(TextEdit,self).__init__()

        #font = QFont("Courier", 11)

        #self.setFont(font)

        self.filename=False

        self.Ui()

    def Ui(self):

        quitApp = QAction(QIcon('/usr/share/icons/breeze-dark/actions/32/application-exit.svg'),'Quit',self)

        saveFile = QAction(QIcon('/usr/share/icons/breeze-dark/actions/32/document-save.svg'),'Save',self)

        newFile = QAction('New',self)

        openFile = QAction('Open',self)

        copyText = QAction('Copy',self)

        pasteText = QAction('Yank',self)

        newFile.setShortcut('Ctrl+N')

        newFile.triggered.connect(self.newFile)

        openFile.setShortcut('Ctrl+O')

        openFile.triggered.connect(self.openFile)

        saveFile.setShortcut('Ctrl+S')

        saveFile.triggered.connect(self.saveFile)

        quitApp.setShortcut('Ctrl+Q')

        quitApp.triggered.connect(self.close)

        copyText.setShortcut('Ctrl+K')

        copyText.triggered.connect(self.copyFunc)

        pasteText.setShortcut('Ctrl+Y')

        pasteText.triggered.connect(self.pasteFunc)

        menubar =self.menuBar()

        menubar.setNativeMenuBar(True)

        menuFile = menubar.addMenu('&File')

        menuFile.addAction(newFile)

        menuFile.addAction(openFile)

        menuFile.addAction(saveFile)

        menuFile.addAction(quitApp)

        menuEdit = menubar.addMenu('&Edit')

        menuEdit.addAction(copyText)

        menuEdit.addAction(pasteText)

        toolbar =self.addToolBar('Toolbar')

        toolbar.addAction(quitApp)

        toolbar.addAction(saveFile)

        self.text= QTextEdit(self)

        self.setCentralWidget(self.text)

        self.setMenuWidget(menubar)

        self.setMenuBar(menubar)

        self.setGeometry(200,200,480,320)

        self.setWindowTitle('TextEdit')

        self.show()

    def copyFunc(self):

        self.text.copy()

    def pasteFunc(self):

        self.text.paste()

    def unSaved(self):

        destroy =self.text.document().isModified()

        print(destroy)


        if destroy ==False:

            returnFalse

        else:

            detour = QMessageBox.question(self,

                            "Hold your horses.",

                            "File has unsaved changes. Save now?",

                            QMessageBox.Yes|QMessageBox.No|

                            QMessageBox.Cancel)

            if detour == QMessageBox.Cancel:

                returnTrue

            elif detour == QMessageBox.No:

                returnFalse

            elif detour == QMessageBox.Yes:

                returnself.saveFile()


        returnTrue

    def saveFile(self):

        self.filename= QFileDialog.getSaveFileName(self,'Save File',os.path.expanduser('~'))

        f =self.filename[0]

        withopen(f,"w")as CurrentFile:

            CurrentFile.write(self.text.toPlainText())

        CurrentFile.close()

    def newFile(self):

        ifnotself.unSaved():

            self.text.clear()

    def openFile(self):

        filename, _ = QFileDialog.getOpenFileName(self,"Open File",'',"All Files (*)")

        try:

            self.text.setText(open(filename).read())

        except:

            True

    def closeEvent(self, event):

        ifself.unSaved():

            event.ignore()

        else:

            exit

    def main():

    app = QApplication(sys.argv)

    editor = TextEdit()
    sys.exit(app.exec_())

    if __name__ =='__main__':

    main()



The foundational widget in wxPython is the **wx.Window**. Everything in wxPython, whether it's an actual window or just a button, checkbox, or text label, is based upon the **wx.Window** class. If there were awards for the most erroneously named class, **wx.Window** would be overlooked because it's *so* badly named that no one would suspect it of being wrong. I've been told getting used to **wx.Window** not being a window takes years, and that must be true, because I make that mistake every time I use it.

The **wx.Frame** class plays the traditional role of what you and I think of as a window on a desktop. To use **wx.Frame** to create an empty window:


    #!/usr/bin/env python
    # -*- coding: utf-8 -*-

    import wx

    class Myframe(wx.Frame):

    def__init__(self, parent, title):

        super(Myframe,self).__init__(parent, title=title,

                                      size=(520,340))

        self.Centre()

        self.Show()

    if __name__ =='__main__':

    app = wx.App()

    Myframe(None, title='Just an empty frame')

            app.MainLoop()



Place other widgets inside of a **wx.Frame** window, and then you're building a GUI application. For example, the **wx.Panel** widget is similar to a **div** in HTML with absolute size constraints, so you would use it to create panels within your main window (except it's not a window, it's a **wx.Frame**).

WxPython has fewer convenience functions when compared to PyQt. For instance, copy and paste functionality is built right into PyQt, while it has to be coded by hand in wxPython (and is still partially subject to the platform it runs on). Some of these are handled graciously by a good desktop with built-in features, but for feature parity with a PyQt app, wxPython requires a little more manual work.

![wx.Frame](https://opensource.com/sites/default/files/wxframe.png)

wx.Frame

A simple text editor in wxPython:



    #!/usr/bin/env python
    # a minimal text editor to demo wxPython

    # GNU All-Permissive License
    # Copying and distribution of this file, with or without modification,
    # are permitted in any medium without royalty provided the copyright
    # notice and this notice are preserved.  This file is offered as-is,
    # without any warranty.

    import wx
    importos

    class TextEdit(wx.Frame):
    def__init__(self,parent,title):

        wx.Frame.__init__(self,parent,wx.ID_ANY, title, size=(520,340))

        menuBar  = wx.MenuBar()

        menuFile = wx.Menu()

        menuBar.Append(menuFile,"&File")

        menuFile.Append(1,"&Open")

        menuFile.Append(2,"&Save")

        menuFile.Append(3,"&Quit")

        self.SetMenuBar(menuBar)

        wx.EVT_MENU(self,1,self.openAction)

        wx.EVT_MENU(self,2,self.saveAction)

        wx.EVT_MENU(self,3,self.quitAction)

        self.p1= wx.Panel(self)

        self.initUI()

    def initUI(self):

        self.text= wx.TextCtrl(self.p1,style=wx.TE_MULTILINE)

        vbox = wx.BoxSizer(wx.VERTICAL)

        vbox.Add(self.p1,1, wx.EXPAND | wx.ALIGN_CENTER)

        self.SetSizer(vbox)

        self.Bind(wx.EVT_SIZE,self._onSize)

        self.Show()

    def _onSize(self, e):

        e.Skip()

        self.text.SetSize(self.GetClientSizeTuple())

    def quitAction(self,e):

        ifself.text.IsModified():

            dlg = wx.MessageDialog(self,"Quit? All changes will be lost.","",wx.YES_NO)

            if dlg.ShowModal()== wx.ID_YES:

                self.Close(True)

            else:

                self.saveAction(self)

        else:

            exit()

    def openAction(self,e):

        dlg = wx.FileDialog(self,"File chooser",os.path.expanduser('~'),"","*.*", wx.OPEN)

        if dlg.ShowModal()== wx.ID_OK:

            filename = dlg.GetFilename()

            dir= dlg.GetDirectory()

            f =open(os.path.join(dir, filename),'r')

            self.text.SetValue(f.read())

            f.close()

        dlg.Destroy()

    def saveAction(self,e):

        dlg = wx.FileDialog(self,"Save as",os.path.expanduser('~'),"","*.*", wx.SAVE | wx.OVERWRITE_PROMPT)

        if dlg.ShowModal()== wx.ID_OK:

            filedata =self.text.GetValue()

            filename = dlg.GetFilename()

            dir= dlg.GetDirectory()

            f =open(os.path.join(dir, filename),'w')

            f.write(filedata)

            f.close()

        dlg.Destroy()

    def main():

    app = wx.App(False)

    view = TextEdit(None,"TextEdit")

    app.MainLoop()

    if __name__ =='__main__':

    main()



## Which one should you use?

Both the PyQt and wxPython GUI toolkits have their strengths.

WxPython is mostly simple, and when it's not simple, it's intuitive to a Python programmer who's not afraid to hack a solution together. You don't find many instances of a "wxWidget way" into which you have to be indoctrinated. It's a toolkit with bits and bobs that you can use to throw together a GUI. If you're targeting a user space that you know already has GTK installed, then wxPython taps into that with minimal dependencies.

As a bonus, it uses native widgets, so your applications ought to look no different than the applications that come preinstalled on your target computers.

Don't take wxPython's claim of being cross-platform too much to heart, though. It sometimes has install issues on some platforms, and it hasn't got that many layers of abstraction to shield you from differences between platforms.

PyQt is big, and will almost always require some installation of several dependencies (especially on non-Linux and non-BSD targets). Along with all that hefty code comes a lot of convenience. Qt does its best to shield you from differences in platforms; it provides you with a staggering number of prebuilt functions and widgets and abstractions. It's well supported, with plenty of companies relying on it as their foundational framework, and some of the most significant open source projects use and contribute to it.

If you're just starting out, you should try a little of each to see which one appeals to you. If you're an experienced programmer, try one you haven't used yet, and see what you think. Both are open source, so you don't have to choose just one. The important thing to know is when to use which solution.

Happy hacking.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
