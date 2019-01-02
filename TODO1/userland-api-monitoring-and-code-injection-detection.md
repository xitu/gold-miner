> * 原文地址：[Userland API Monitoring and Code Injection Detection](https://0x00sec.org/t/userland-api-monitoring-and-code-injection-detection/5565)
> * 原文作者：[dtm](https://0x00sec.org/u/dtm)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/userland-api-monitoring-and-code-injection-detection.md](https://github.com/xitu/gold-miner/blob/master/TODO1/userland-api-monitoring-and-code-injection-detection.md)
> * 译者：[Xekin-FE](https://github.com/Xekin-FE)
> * 校对者：[Starrier](https://github.com/Starrier)，[sunhaokk](https://github.com/sunhaokk)

# 用户领域 API 监控和代码注入检测

## 文档简介

本文实属作者对恶意程式（或者病毒）是如何与 Windows 应用程序编程接口（WinAPI）进行交互的研究成果。当中详细赘述了恶意程式如何能够将 Payload [译注：Payload 指一种对设备造成伤害的程序]植入到其他进程中的基本概念，以及如何通过监控与 Windows 操作系统的通信来检测此类功能。并且通过**函数钩子**钩住某些函数的方式来介绍观察 API 调用的过程，而这些函数正被用来实现代码注入功能。

**阅前声明**：由于时间方面的原因，这是一个相对来说比较短促的项目。所以各位在阅读时如若发现了可能相关的错误信息，我先在此表示十分抱歉，还请尽快地通知我以便及时修正。除此之外，文章随附的代码部分在项目延展性上有一定的设计缺陷，也可能会因为版本落后而无法成功在当下执行。

## 目录

1.  [文档简介](#introduction)
2.  [第一章：基础概念](#section-i-fundamental-concepts)
    *   [内联挂钩 inline-hooking](#inline-hooking)
    *   [API 监控](#api-monitoring)
    *   [代码注入技术入门](#code-injection-primer)
        *   [DLL 注入技术](#dll-injection)
            *   [创建远程线程](#createremotethread)
            *   [SetWindowsHookEx 钩子函数](#setwindowshookex)
            *   [QueueUserAPC 接口](#queueuserapc)
        *   [傀儡进程技术](#process-hollowing)
        *   [Atom Bombing 技术](#atom-bombing)
3.  [第二章：UnRunPE 工具](#section-ii-unrunpe)
    *   [代码注入检测](#code-injection-detection)
    *   [代码注入转储](#code-injection-dumping)
    *   [UnRunPE 示例](#unrunpe-demonstration)
4.  [第三章：Dreadnought 工具](#section-iii-dreadnought)
    *   [检测代码注入的方法](#detecting-code-injection-method)
    *   [启发式逻辑检测](#heuristics)
    *   [Dreadnought 示例](#dreadnought-demonstration)
        *   [进程注入之傀儡进程技术](#process-injection-process-hollowing)
        *   [DLL 注入之 SetWindowsHookEx](#dll-injection-setwindowshookex)
        *   [DLL 注入之 QueueUserAPC](#dll-injection-queueuserapc)
        *   [代码注入之 Atom Bombing](#code-injection-atom-bombing)
5.  [总结](#conclusion)
    *   [文档中的缺陷](#limitations)
6.  [参考文献](#references)

## 序言

在当下，恶意软件是由网络罪犯开发并针对在网络上那些容易泄露信息的计算机，通过在这些计算机系统上执行恶意任务以谋取利益。在大多数恶意软件入侵事件中，这些恶意程式都生存于人们的视野之外，因为它们的行动必须保持隐蔽才能不让管理员发现同时阻止系统杀毒软件检测。因此，通过代码注入让自身“隐形”成为了常用的入侵手段。

* * *

# 第一章：基础概念

## 内联挂钩

内联挂钩是通过**热补丁修复**过程来绕过代码流的一种行为。热补丁修复被定义为一种可以通过在程式运行时修改二进制代码来改变应用行为的方法<sup>[1]</sup>。其主要的目的就是为了能够捕捉程序调用函数的时段，从而实现对程序进行监控和调用。下面是模拟内联挂钩在程序正常工作时的过程：

```
正常调用函数时的程序

+---------+                                                                       +----------+
| Program | ----------------------- calls function -----------------------------> | Function |  | execution
+---------+                                                                       |    .     |  | of
                                                                                  |    .     |  | function
                                                                                  |    .     |  |
                                                                                  |          |  v
                                                                                  +----------+

```

与执行了一个钩子函数后的程序相比：

```
程序中调用钩子函数

+---------+                       +--------------+                    + ------->  +----------+
| Program | -- calls function --> | Intermediate | | execution        |           | Function |  | execution
+---------+                       |   Function   | | of             calls         |    .     |  | of
                                  |       .      | | intermediate   normal        |    .     |  | function
                                  |       .      | | function      function       |    .     |  |
                                  |       .      | v                  |           |          |  v
                                  +--------------+  ------------------+           +----------+
```

此过程可以分成三个执行步骤。在这里我们可以以 WinAPI 方法 [MessageBox](https://msdn.microsoft.com/en-us/library/windows/desktop/ms645505(v=vs.85).aspx) 来演示整个过程。

1.  在函数中挂钩

如果我们要想在函数中挂钩，我们首先需要一个**必须**能复制目标函数参数的中间函数。 `MessageBox` 方法在微软开发者网络（MSDN）中是这样定义的：

```
int WINAPI MessageBox(
    _In_opt_ HWND    hWnd,
    _In_opt_ LPCTSTR lpText,
    _In_opt_ LPCTSTR lpCaption,
    _In_     UINT    uType
);
```

所以我们的中间函数也可以像这样：

```
int WINAPI HookedMessageBox(HWND hWnd, LPCTSTR lpText, LPCTSTR lpCaption, UINT uType) {
    // our code in here
}
```

一旦触发中间函数，代码执行流将被重定向至某个特定位置。要想在 `MessageBox` 方法中进行挂钩，我们可以补充代码的前几个字节（请记住，我们必须备份原本的字节，以便于在中间函数执行后恢复原始函数）。以下是在MsgBox方法中相应模块 `user32.dll` 中的原始编码指令：

```
; MessageBox
8B FF   mov edi, edi
55      push ebp
8B EC   mov ebp, esp
```

与挂钩后的函数相比：

```
; MessageBox
68 xx xx xx xx  push <HookedMessageBox> ; our intermediate function
C3              ret
```

基于以往的经验以及对隐蔽性可靠程度的考虑，这里我会选择使用 `push-ret` 指令组合而不是一个绝对的 `jmp` 语句。`xx xx xx xx` 表示 `HookedMessageBox` 中的低字节序顺序地址。

2.  捕获函数调用

当程序调用 `MessageBox` 方法时，它将会执行 `push-ret` 相关指令并马上插入 `HookedMessageBox` 函数中，如若执行成功，就可以调用该函数来完全控制程序参数和调用本身。例如如果要替换即将在消息对话框中显示的文本内容，可以在 `HookedMessageBox` 中声明以下内容：

```
int WINAPI HookedMessageBox(HWND hWnd, LPCTSTR lpText, LPCTSTR lpCaption, UINT uType) {
    TCHAR szMyText[] = TEXT("This function has been hooked!");
}
```

其中 `szMyText` 可以用来替换 `MessageBox` 中的 `LPCTSTR lpText` 参数。

3.  恢复正常执行

要想将替换后的参数转发，需要让代码执行流中的 `MessageBox` 方法回退到原始状态，才能让操作系统显示对话框。由于继续调用 `MessageBox` 方法只会导致无限递归，所以我们必须要恢复原始字节（正如前面所提到的）。

```
int WINAPI HookedMessageBox(HWND hWnd, LPCTSTR lpText, LPCTSTR lpCaption, UINT uType) {
    TCHAR szMyText[] = TEXT("This function has been hooked!");

    // 还原 MessageBox 中的原始字节
    // ...

    // 使用已替换参数的 MessageBox 方法，并将值返回给程序
    return MessageBox(hWnd, szMyText, lpCaption, uType);
}
```

如果需要拒绝调用 `MessageBox` 方法，那就跟返回一个值一样简单，最好这个值曾在文档中被定义过。例如要在一个“确认/取消”对话框中返回“取消”选项，在中间函数中就可以这样声明：

```
int WINAPI HookedMessageBox(HWND hWnd, LPCTSTR lpText, LPCTSTR lpCaption, UINT uType) {
    return IDNO;  // IDNO defined as 7
}
```

## API 监控

基于函数挂钩的方法机制，我们完全可以控制函数调用的过程，同时也可以控制程序里的所有参数，这也就是我们实现文档中标题里也提到过的 **API 监控**的概念原理。然而，这里仍有一个小问题，那就是由于不同的深层 API 实用性也不尽相同，导致这些 API 的调用将是独一无二的，只不过在浅层调用中它们可能都使用同一组 API，这被称为**函数嵌套**，被定义为**在子程序中调用次级子程序**。回到 `MessageBox` 的例子中，在方法里，我们声明了两个函数 `MessageBoxA` 和 `MessageBoxW`，前者用来包含 ASCII 字符的参数，后者用来包含宽字符的参数。在实际应用中，如果我们在 `MessageBox` 方法中挂钩，就需要对 `MessageBoxA` **和** `MessageBoxW` 的前几个字节都进行补充。而其实遇到这样的问题时，我们只需要在函数调用等级**最低**的**公共点**进行挂钩就可以了。

```
                                                      +---------+
                                                      | Program |
                                                      +---------+
                                                     /           \
                                                    |             |
                                            +------------+   +------------+
                                            | Function A |   | Function B |
                                            +------------+   +------------+
                                                    |             |
                                           +-------------------------------+
                                           | user32.dll, kernel32.dll, ... |
                                           +-------------------------------+
       +---------+       +-------- hook -----------------> |
       |   API   | <---- +              +-------------------------------------+
       | Monitor | <-----+              |              ntdll.dll              |
       +---------+       |              +-------------------------------------+
                         +-------- hook -----------------> |                           User mode
                                 -----------------------------------------------------
                                                                                       Kernel mode
```

下面是模拟调用 Message 方法的层级顺序：

在 `MessageBoxA` 中：

```
user32!MessageBoxA -> user32!MessageBoxExA -> user32!MessageBoxTimeoutA -> user32!MessageBoxTimeoutW
```

在 `MessageBoxW` 中：

```
user32!MessageBoxW -> user32!MessageBoxExW -> user32!MessageBoxTimeoutW
```

上面方法中的层层调用最后都会合并到 `MessageBoxTimeoutW` 函数中，这会是个合适的挂钩点。对于处在过深层次的函数，伴随着函数参数的复杂化，对在任何底层的点进行挂钩都只会带来没必要的麻烦。`MessageBoxTimeoutW` 是一个没有在 WinAPI 文档中说明的一个函数，它的定义如下：

```
int WINAPI MessageBoxTimeoutW(
    HWND hWnd, 
    LPCWSTR lpText, 
    LPCWSTR lpCaption, 
    UINT uType, 
    WORD wLanguageId, 
    DWORD dwMilliseconds
);
```

用法：

```
int WINAPI MessageBoxTimeoutW(HWND hWnd, LPCWSTR lpText, LPCWSTR lpCaption, UINT uType, WORD wLanguageId, DWORD dwMilliseconds) {
    std::wofstream logfile;     // declare wide stream because of wide parameters
    logfile.open(L"log.txt", std::ios::out | std::ios::app);

    logfile << L"Caption: " << lpCaption << L"\n";
    logfile << L"Text: " << lpText << L"\n";
    logfile << L"Type: " << uType << :"\n";

    logfile.close();

    // 恢复原始字节
    // ...

    // pass execution to the normal function and save the return value
    int ret = MessageBoxTimeoutW(hWnd, lpText, lpCaption, uType, wLanguageId, dwMilliseconds);

    // rehook the function for next calls
    // ...

    return ret;   // 返回原始函数的值
}
```

只要在 `MessageBoxTimeoutW` 挂钩成功，`MessageBoxA` 和 `MessageBoxW` 的行为就都可以被我们捕获了。

* * *

## 代码注入技术入门

就本文而言，我们将代码注入技术定义为一种嵌入行为，它可以将程序内部可执行代码在外部甚至是远程进行调用修改。在 WinAPI 本身就拥有一些可以让我们实现嵌入的功能。当其中某些函数方法被组合封装在一起时，就可能实现访问现有进程，篡改写入数据然后隐藏在代码流中远程执行。在本节中，作者将会介绍在研究中涉及到的代码注入的相关技术。

### DLL 注入技术

在计算机中，代码可以存在于多种形式的文件下，其中之一就是 **Dynamic Link Library** （动态链接库 DLL）。DLL 文件又被称为应用程序拓展库，顾名思义，它就是通过导出应用子程序后用来给其他程序进行拓展。本文其余部分将都以此 DLL 文件示例：

```
extern "C" void __declspec(dllexport) Demo() {
    ::MessageBox(nullptr, TEXT("This is a demo!"), TEXT("Demo"), MB_OK);
}

bool APIENTRY DllMain(HINSTANCE hInstDll, DWORD fdwReason, LPVOID lpvReserved) {
    if (fdwReason == DLL_PROCESS_ATTACH)
        ::CreateThread(nullptr, 0, (LPTHREAD_START_ROUTINE)Demo, nullptr, 0, nullptr);
    return true;
}
```

当一个 DLL 文件在程序中加载并初始化后，加载程序将会调用 `DllMain` 这个方法并判断 `fdwReason` 参数是否设置为 `DLL_PROCESS_ATTACH`。在这个例子中，当在进程中加载 DLL 文件时，它将通过 `Demo` 这个方法显示一个带有 `Demo` 标题和 `This is a demo!` 文本内容的消息框。要想正确地完成对 DLL 文件地初始化，消息框必须返回 `true` 值，否则文件就会被拒绝执行。

#### 创建远程线程

[CreateRemoteThread](https://msdn.microsoft.com/en-us/library/windows/desktop/ms682437(v=vs.85).aspx) 是实现 DLL 注入的方法之一，它可以被使用在某个进程的虚拟空间中执行远程线程。正如之前所提到过的，我们所做的一切都是为了通过注入 DLL 文件使其进程强制执行 `LoadLibrary` 函数。通过以下代码我们将实现这点：

```
void injectDll(const HANDLE hProcess, const std::string dllPath) {
    LPVOID lpBaseAddress = ::VirtualAllocEx(hProcess, nullptr, dllPath.length(), MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE);

    ::WriteProcessMemory(hProcess, lpBaseAddress, dllPath.c_str(), dllPath.length(), &dwWritten);

    HMODULE hModule = ::GetModuleHandle(TEXT("kernel32.dll"));

    LPVOID lpStartAddress = ::GetProcAddress(hModule, "LoadLibraryA");      // LoadLibraryA for ASCII string

    ::CreateRemoteThread(hProcess, nullptr, 0, (LPTHREAD_START_ROUTINE)lpStartAddress, lpBaseAddress, 0, nullptr);
}
```

MSDN 对 [LoadLibrary](https://msdn.microsoft.com/en-us/library/windows/desktop/ms684175(v=vs.85).aspx) 是这样定义的：

```
HMODULE WINAPI LoadLibrary(
    _In_ LPCTSTR lpFileName
);
```

使用上面这个函数时，我们需要传入一个参数那就是加载库的路径。而在 `LoadLibrary` 例程中声明的这个参数将会被传递给 `CreateRemoteThread` 方法中相匹配的路径参数。这种行为的目的是为了能在目标进程的虚拟地址空间中传递字符串参数，然后将 `CreateRemoteThread` 方法的自变量参数分配给空间地址以便调用 `LoadLibrary` 来加载 DLL。

1.  在目标进程中分配虚拟内存

使用 `VirtualAllocEx` 函数可以指定进程的虚拟空间保留或提交内存区域，执行完毕后函数将返回分配内存的首地址。

```
目标进程的虚拟地址空间：
                                              +--------------------+
                                              |                    |
                        VirtualAllocEx        +--------------------+
                        Allocated memory ---> |     Empty space    |
                                              +--------------------+
                                              |                    |
                                              +--------------------+
                                              |     Executable     |
                                              |       Image        |
                                              +--------------------+
                                              |                    |
                                              |                    |
                                              +--------------------+
                                              |    kernel32.dll    |
                                              +--------------------+
                                              |                    |
                                              +--------------------+
```

2.  在分配内存中写入 DLL 文件路径

只要内存初始化成功， DLL 的路径就可以被注入到 `VirtualAllocEx` 使用 `WriteProcessMemory` 返回的分配内存里。

```
目标进程的虚拟地址空间
                                              +--------------------+
                                              |                    |
                        WriteProcessMemory    +--------------------+
                        Inject DLL path ----> | "..\..\myDll.dll"  |
                                              +--------------------+
                                              |                    |
                                              +--------------------+
                                              |     Executable     |
                                              |       Image        |
                                              +--------------------+
                                              |                    |
                                              |                    |
                                              +--------------------+
                                              |    kernel32.dll    |
                                              +--------------------+
                                              |                    |
                                              +--------------------+
```

3.  找到 `LoadLibrary` 地址

由于所有的系统 DLL 文件都会被映射到所有进程的相同地址空间，所以 `LoadLibrary` 的地址不需要到目标进程中检索。只需调用 `GetModuleHandle(TEXT("kernel32.dll"))` 和 `GetProcAddress(hModule, "LoadLibraryA")` 就可以了。

4.  加载 DLL 文件

如果我们需要加载 DLL 文件，`LoadLibrary` 地址以及 DLL 文件路径是我们必须知道的两个主要参数。在使用 `CreateRemoteThread` 函数时，`LoadLibrary` 将会以 DLL 文件路径作为参数在目标进程的代码流中被执行。

```
目标进程的虚拟地址空间
                                              +--------------------+
                                              |                    |
                                              +--------------------+
                                   +--------- | "..\..\myDll.dll"  |
                                   |          +--------------------+
                                   |          |                    |
                                   |          +--------------------+ <---+
                                   |          |     myDll.dll      |     |
                                   |          +--------------------+     |
                                   |          |                    |     | LoadLibrary
                                   |          +--------------------+     | loads
                                   |          |     Executable     |     | and
                                   |          |       Image        |     | initialises
                                   |          +--------------------+     | myDll.dll
                                   |          |                    |     |
                                   |          |                    |     |
          CreateRemoteThread       v          +--------------------+     |
          LoadLibraryA("..\..\myDll.dll") --> |    kernel32.dll    | ----+
                                              +--------------------+
                                              |                    |
                                              +--------------------+
```

#### SetWindowsHookEx 钩子函数

[SetWindowsHookEx](https://msdn.microsoft.com/en-us/library/windows/desktop/ms644990(v=vs.85).aspx) 函数是 Windows 提供给程序开发人员的一个 API，通过对某一事件流程挂钩实现对消息拦截的功能，虽然这个函数经常被使用来监视键盘按键输入和记录，但其实也可以被用于 DLL 注入。以下代码将演示如何将 DLL 注入事件本身。 

```
int main() {
    HMODULE hMod = ::LoadLibrary(DLL_PATH);
    HOOKPROC lpfn = (HOOKPROC)::GetProcAddress(hMod, "Demo");
    HHOOK hHook = ::SetWindowsHookEx(WH_GETMESSAGE, lpfn, hMod, ::GetCurrentThreadId());
    ::PostThreadMessageW(::GetCurrentThreadId(), WM_RBUTTONDOWN, (WPARAM)0, (LPARAM)0);

    // 捕捉事件的消息队列
    MSG msg;
    while (::GetMessage(&msg, nullptr, 0, 0) > 0) {
        ::TranslateMessage(&msg);
        ::DispatchMessage(&msg);
    }

    return 0;
}
```

`SetWindowsHookEx` 在 MSDN 中是这样定义的：

```
HHOOK WINAPI SetWindowsHookEx(
    _In_ int       idHook,
    _In_ HOOKPROC  lpfn,
    _In_ HINSTANCE hMod,
    _In_ DWORD     dwThreadId
);
```

在上面的定义中， `HOOKPROC` 是由用户声明的钩子函数，当特定的挂钩事件被触发时它就会被执行。在我们的示例中，这一事件指的是 `WH_GETMESSAGE` 钩子，它主要负责处理进队消息的工作[译注：Windows 中消息分为进队消息和不进队消息]。这段代码是一个回调函数，它会先将 DLL 文件加载到它自己的虚拟进程空间中，再获得之前导出的 `Demo` 函数地址，最后在 `SetWindowsHookEx` 函数中声明并调用。要想强制执行这个钩子函数，我们只需调用 `PostThreadMessage` 函数并将消息赋值为 `WM_RBUTTONDOWN` 就可以触发 `WH_GETMESSAGE` 钩子之后就能显示之前所说的消息框了。

#### QueueUserAPC 接口

使用 [QueueUserAPC](https://msdn.microsoft.com/en-us/library/windows/desktop/ms684954(v=vs.85).aspx) 接口方法的 DLL 注入和 `CreateRemoteThread` 类似，都是在分配和注入 DLL 地址到目标进程的虚拟地址空间中后在代码流中强制调用 `LoadLibrary` 函数。

```
int injectDll(const std::string dllPath, const DWORD dwProcessId, const DWORD dwThreadId) {
    HANDLE hProcess = ::OpenProcess(PROCESS_ALL_ACCESS, false, dwProcessId);

    HANDLE hThread = ::OpenThread(THREAD_ALL_ACCESS, false, dwThreadId);

    LPVOID lpLoadLibraryParam = ::VirtualAllocEx(hProcess, nullptr, dllPath.length(), MEM_COMMIT, PAGE_READWRITE);

    ::WriteProcessMemory(hProcess, lpLoadLibraryParam, dllPath.data(), dllPath.length(), &dwWritten);

    ::QueueUserAPC((PAPCFUNC)::GetProcAddress(::GetModuleHandle(TEXT("kernel32.dll")), "LoadLibraryA"), hThread, (ULONG_PTR)lpLoadLibraryParam);

    return 0;
}
```

这个方法和 `CreateRemoteThread` 有一个主要区别，`QueueUserAPC` 是只能在**警告状态**下执行调用的。也就是说在 `QueueUserAPC` 队列中的异步程序只有在当在线程处于警告状态时才能调用 APC 函数。

### 傀儡进程技术（Prosess hollowing）

Process hollowing（傀儡进程），又称为 RunPE，这是一个常见的用于躲避反病毒检测的方法。它可以做到把整个可执行文件注入到目标进程中并在其代码流中执行。通常我们会在加密的应用程序中看到，存在 Payload 的磁盘上的某个文件会被选举为 host 并且被作为进程创建，而这个文件的主要执行模块都被**挖空**并且替换掉了。这样一个过程可以分解为四步来执行。

1.  创建主进程

为了将 Payload 注入，首先引导程序必须找到适合引导的主文件。如果 Payload 是一个 .NET 应用程序，那么主文件也必须是 .NET 应用程序。如果 Payload 是一个可以调用控制台子系统的本地可执行程序，则主文件也要具有与其相同的属性。不管是32位还是64位的程序都必须要满足这一条件。一旦主文件找到了之后，系统函数 `CreateProcess(PATH_TO_HOST_EXE, ..., CREATE_SUSPENDED, ...)` 便可创建一个挂起状态的进程。

```
主进程中的可执行映像
                                        +---  +--------------------+
                                        |     |         PE         |
                                        |     |       Headers      |
                                        |     +--------------------+
                                        |     |       .text        |
                                        |     +--------------------+
                          CreateProcess +     |       .data        |
                                        |     +--------------------+
                                        |     |         ...        |
                                        |     +--------------------+
                                        |     |         ...        |
                                        |     +--------------------+
                                        |     |         ...        |
                                        +---  +--------------------+
```

2.  将主进程挂起

为了使注入后的 Paylaod 正常工作，我们必须将其映射到与 PE 映像头的 [optional header](https://msdn.microsoft.com/en-us/library/windows/desktop/ms680339(v=vs.85).aspx) 的 `ImageBase` 值相同的虚拟地址空间。

```
typedef struct _IMAGE_OPTIONAL_HEADER {
  WORD                 Magic;
  BYTE                 MajorLinkerVersion;
  BYTE                 MinorLinkerVersion;
  DWORD                SizeOfCode;
  DWORD                SizeOfInitializedData;
  DWORD                SizeOfUninitializedData;
  DWORD                AddressOfEntryPoint;          // <---- this is required later
  DWORD                BaseOfCode;
  DWORD                BaseOfData;
  DWORD                ImageBase;                    // <---- 
  DWORD                SectionAlignment;
  DWORD                FileAlignment;
  WORD                 MajorOperatingSystemVersion;
  WORD                 MinorOperatingSystemVersion;
  WORD                 MajorImageVersion;
  WORD                 MinorImageVersion;
  WORD                 MajorSubsystemVersion;
  WORD                 MinorSubsystemVersion;
  DWORD                Win32VersionValue;
  DWORD                SizeOfImage;                  // <---- size of the PE file as an image
  DWORD                SizeOfHeaders;
  DWORD                CheckSum;
  WORD                 Subsystem;
  WORD                 DllCharacteristics;
  DWORD                SizeOfStackReserve;
  DWORD                SizeOfStackCommit;
  DWORD                SizeOfHeapReserve;
  DWORD                SizeOfHeapCommit;
  DWORD                LoaderFlags;
  DWORD                NumberOfRvaAndSizes;
  IMAGE_DATA_DIRECTORY DataDirectory[IMAGE_NUMBEROF_DIRECTORY_ENTRIES];
} IMAGE_OPTIONAL_HEADER, *PIMAGE_OPTIONAL_HEADER;
```

这一点非常重要，因为绝对地址很有可能会涉及完全依赖其内存位置的代码。为了安全地映射该可执行映像，必须从描述的 `ImageBase` 值开始的虚拟内存空间卸载映射。由于许多可执行文件共享通用的基地址（通常为 `0x400000`），因此主进程本身的可执行映像未映射的情况并不罕见。卸载这一操作可以通过 `NtUnmapViewOfSection(IMAGE_BASE, SIZE_OF_IMAGE)` 来完成。

```
主进程中的可执行映像
                                        +---  +--------------------+
                                        |     |                    |
                                        |     |                    |
                                        |     |                    |
                                        |     |                    |
                                        |     |                    |
                   NtUnmapViewOfSection +     |                    |
                                        |     |                    |
                                        |     |                    |
                                        |     |                    |
                                        |     |                    |
                                        |     |                    |
                                        |     |                    |
                                        +---  +--------------------+
```

3.  Payload 注入

要将 Payload 注入，我们必须手动去解析 PE 文件将其从磁盘格式转换为映像格式。在使用 `VirtualAllocEx` 分配完虚拟内存后，PE 映像头将直接被复制到基地址中。

```
主进程中的可执行映像
                                        +---  +--------------------+
                                        |     |         PE         |
                                        |     |       Headers      |
                                        +---  +--------------------+
                                        |     |                    |
                                        |     |                    |
                     WriteProcessMemory +     |                    |
                                              |                    |
                                              |                    |
                                              |                    |
                                              |                    |
                                              |                    |
                                              |                    |
                                              +--------------------+
```

而如果要将 PE 文件转换成映像，所有的区块（节）都必须从文件偏移量里逐个读取，然后通过使用 `WriteProcessMemory` 将其放置到正确的虚拟偏移量中。在这篇 MSDN 文档中每个章节的 [section header](https://msdn.microsoft.com/en-us/library/windows/desktop/ms680341(v=vs.85).aspx). 都有介绍。

```
typedef struct _IMAGE_SECTION_HEADER {
  BYTE  Name[IMAGE_SIZEOF_SHORT_NAME];
  union {
    DWORD PhysicalAddress;
    DWORD VirtualSize;
  } Misc;
  DWORD VirtualAddress;               // <---- 虚拟偏移量
  DWORD SizeOfRawData;
  DWORD PointerToRawData;             // <---- 文件偏移量
  DWORD PointerToRelocations;
  DWORD PointerToLinenumbers;
  WORD  NumberOfRelocations;
  WORD  NumberOfLinenumbers;
  DWORD Characteristics;
} IMAGE_SECTION_HEADER, *PIMAGE_SECTION_HEADER;
```

```
主进程中的可执行映像
                                              +--------------------+
                                              |         PE         |
                                              |       Headers      |
                                        +---  +--------------------+
                                        |     |       .text        |
                                        +---  +--------------------+
                     WriteProcessMemory +     |       .data        |
                                        +---  +--------------------+
                                        |     |         ...        |
                                        +---- +--------------------+
                                        |     |         ...        |
                                        +---- +--------------------+
                                        |     |         ...        |
                                        +---- +--------------------+
```

4.  执行 Payload 

最后一步就是将执行的首地址指向上面有提到过的（创建主进程）Payload 的 `AddressOfEntryPoint`。由于进程的主线程已经被挂起，所以可以使用 `GetThreadContext` 方法来检索相关信息。其代码结构可以如以下声明：

```
typedef struct _CONTEXT
{
     ULONG ContextFlags;
     ULONG Dr0;
     ULONG Dr1;
     ULONG Dr2;
     ULONG Dr3;
     ULONG Dr6;
     ULONG Dr7;
     FLOATING_SAVE_AREA FloatSave;
     ULONG SegGs;
     ULONG SegFs;
     ULONG SegEs;
     ULONG SegDs;
     ULONG Edi;
     ULONG Esi;
     ULONG Ebx;
     ULONG Edx;
     ULONG Ecx;
     ULONG Eax;                        // <----
     ULONG Ebp;
     ULONG Eip;
     ULONG SegCs;
     ULONG EFlags;
     ULONG Esp;
     ULONG SegSs;
     UCHAR ExtendedRegisters[512];
} CONTEXT, *PCONTEXT;
```

如果要修改首地址，我们必须将上面的 `Eax` 数据成员更改为 Payload 的 `AddressOfEntryPoint` 的**虚拟地址**。简单表示，`context.Eax = ImageBase + AddressOfEntryPoint`。调用 `SetThreadContext` 方法，并传入修改的 `CONTEXT` 结构，我们就可以更改应用到进程线程。之后现在我们只需调用 `ResumeThread`，Payload 应该就可以开始执行了。

### Atom Bombing 技术

Atom Bombing 是一种代码注入技术，它利用了 Windows 的**全局原子表**来实现全局数据存储。全局原子表中的数据可以跨所有进程进行访问，这也正是我们能实现代码注入的原因。表中的数据是以空字符结尾的 C-string 类型，用 16-bit 的整数表示，我们称之为**原子（Atom）**，它类似于 map 数据结构。在 MSDN 中提供了 [GlobalAddAtom](https://msdn.microsoft.com/en-us/library/windows/desktop/ms649060(v=vs.85).aspx) 方法用于向其添加数据，如下声明：

```
ATOM WINAPI GlobalAddAtom(
    _In_ LPCTSTR lpString
);
```

其中 `lpString` 是要存储的数据，当方法调用成功时将会返回一个 16-bit 的整数原子。我们可以通过 [GlobalGetAtomName](https://msdn.microsoft.com/en-us/library/windows/desktop/ms649063(v=vs.85).aspx) 来检索存储在全局原子表里面的数据，如下声明：

```
UINT WINAPI GlobalGetAtomName(
    _In_  ATOM   nAtom,
    _Out_ LPTSTR lpBuffer,
    _In_  int    nSize
);
```

通过 `GlobalAddAtom` 添加方法返回的标识原子将会被放入 `lpBuffer` 中并返回该字符串的长度（**不包含**空终止符）。

Atom bombing 是通过强制让目标进程加载并执行存储在全局原子表里的代码，这依赖于另一个关键函数，`NtQueueApcThread`，一个 `QueueUserAPC` 接口在用户领域的调用方法。之所以使用 `NtQueueApcThread` 而不是 `QueueUserAPC` 其他方法的原因，正如前面所看到的，`QueueUserAPC` 的 [APCProc](https://msdn.microsoft.com/en-us/library/windows/desktop/ms681947(v=vs.85).aspx) 方法只能接收一个参数，而 `GlobalGetAtomName` 需要三个参数<sup>[3]</sup>。

```
VOID CALLBACK APCProc(               UINT WINAPI GlobalGetAtomName(
                                         _In_  ATOM   nAtom,
    _In_ ULONG_PTR dwParam     ->        _Out_ LPTSTR lpBuffer,
                                         _In_  int    nSize
);                                   );
```

然而在 `NtQueueApcThread` 的底层会允许我们可以传入三个潜在的参数：

```
NTSTATUS NTAPI NtQueueApcThread(                      UINT WINAPI GlobalGetAtomName(
    _In_     HANDLE           ThreadHandle,               // target process's thread
    _In_     PIO_APC_ROUTINE  ApcRoutine,                 // APCProc (GlobalGetAtomName)
    _In_opt_ PVOID            ApcRoutineContext,  ->      _In_  ATOM   nAtom,
    _In_opt_ PIO_STATUS_BLOCK ApcStatusBlock,             _Out_ LPTSTR lpBuffer,
    _In_opt_ ULONG            ApcReserved                 _In_  int    nSize
);                                                    );
```

下面是我们用图形模拟代码注入的过程：

```
Atom bombing code injection
                                              +--------------------+
                                              |                    |
                                              +--------------------+
                                              |      lpBuffer      | <-+
                                              |                    |   |
                                              +--------------------+   |
     +---------+                              |                    |   | Calls
     |  Atom   |                              +--------------------+   | GlobalGetAtomName
     | Bombing |                              |     Executable     |   | specifying
     | Process |                              |       Image        |   | arbitrary
     +---------+                              +--------------------+   | address space
          |                                   |                    |   | and loads shellcode
          |                                   |                    |   |
          |           NtQueueApcThread        +--------------------+   |
          +---------- GlobalGetAtomName ----> |      ntdll.dll     | --+
                                              +--------------------+
                                              |                    |
                                              +--------------------+
```

这是 Atom bombing 的一种非常简化的概述，但对于本文的其余部分来说已经足够了。如果余姚了解更多关于 Atom bombing 的技术信息，请参阅 enSilo 的 [AtomBombing: Brand New Code Injection for Windows](https://blog.ensilo.com/atombombing-brand-new-code-injection-for-windows)。

* * *

# 第二章：UnRunPE 工具

UnRunPE 是一个概念验证（Proof of concept，简称 PoC）工具，是为了将 API 监控的理论概念应用到实际操作而编写的。该工具的目的是将选定的可执行文件作为进程创建并挂起，随后将带有钩子函数的 DLL 通过傀儡进程技术（process hollowing）注入到进程中。

## 代码注入检测

了解了相关的代码注入的基础知识之后，可以通过下面的 WinAPI 函数调用链来实现傀儡进程技术的注入手段：

1.  `CreateProcess`
2.  `NtUnmapViewOfSection`
3.  `VirtualAllocEx`
4.  `WriteProcessMemory`
5.  `GetThreadContext`
6.  `SetThreadContext`
7.  `ResumeThread`

其实当中有一些并不一定要按这样的顺序执行，例如，`GetThreadContext` 可以在 `VirtualAllocEx` 之前就调用。不过由于一些方法需要依赖前面调用的 API，例如 `SetThreadContext` **必须**要在 `GetThreadContext` 或者 `CreateProcess` 调用之前调用，否则就无法将 Payload 注入到目标进程。该工具将假定上述的调用顺序作为参考，尝试检测是否有潜在的傀儡进程。

遵循 API 监控的理论，我们最好是在函数调用等级最低的**公共**点进行挂钩，但当被恶意软件入侵时，我们最理想的应该是将其可访问的可能性降到最低。假定在最坏的情况下，入侵者可能会尝试绕过高层的 WinAPI 函数，而直接调用最低层的函数，这些函数通常在 `ntdll.dll` 模块中可以找到。下列是傀儡进程当中经常调用的达到上述要求的 WinAPI 函数：

1.  `NtCreateUserProcess`
2.  `NtUnmapViewOfSection`
3.  `NtAllocateVirtualMemory`
4.  `NtWriteVirtualMemory`
5.  `NtGetContextThread`
6.  `NtSetContextThread`
7.  `NtResumeThread`

## 代码注入转储

一旦我们在需要的函数中挂钩成功，目标进程就会被执行并且记录每个挂钩函数的参数，这样我们就能跟踪傀儡进程以及主进程的当前进度。最值得注意的是 `NtWriteVirtualMemory` 和 `NtResumeThread` 这两个钩子函数，因为前者参与应用了代码注入，而后者执行了它。除了记录参数以外，UnRunPE 还会尝试转储使用 `NtWriteVirtualMemory` 写入的字节并且当执行 `NtResumeThread` 时，它将尝试转储整个被注入到主进程的 Payload。要做到这点，函数将需要利用通过 `NtCreateUserProcess` 记录的进程和线程句柄参数以及通过 `NtUnmapViewOfSection` 记录的基地址及其大小。在这里，如果使用 `NtAllocateVirtualMemory` 的参数可能会更合适，但实际应用中出于某些不明原因，对函数进行挂钩的过程中会出现错误。当通过 `NtResumeThread` 将 Payload 成功转储后，它将终止目标进程及其宿主进程，同时也阻止了注入后的代码执行。

## UnRunPE 示例

为了演示这点，我选择了使用之前创建的二进制木马文件来做实验。文件中包含了 `PEview.exe` 以及 `PuTTY.exe` 作为隐藏的可执行文件。

[![](https://raw.githubusercontent.com/NtRaiseHardError/NtRaiseHardError.github.io/master/images/2018-02-21-Userland-API-Monitoring-and-Code-Injection-Detection/Screenshot%20from%202018-02-20%2018-35-29.png)](https://raw.githubusercontent.com/NtRaiseHardError/NtRaiseHardError.github.io/master/images/2018-02-21-Userland-API-Monitoring-and-Code-Injection-Detection/Screenshot%20from%202018-02-20%2018-35-29.png) 

* * *

# 第三章：Dreadnought 工具

Dreadnought 是基于 UnRunPE 构建的 PoC 工具，它提供了更多样的代码注入检测，也就是我们前面[代码注入入门](#code-injection-primer)的全部内容。为了让应用程序更全面的检测代码注入，强化工具功能也在所必然。

## 检测代码注入的方法

实现代码注入可以有很多种方法，所以我们必须要了解不同的技术之间的区别。第一种检测代码注入的方法就是通过识别调用 API 的“触发器”，也就是负责 Payload 远程执行的 API 调用者。通过识别我们可以确定代码注入的完成过程以及某种程度上确定了代码注入的类型。其**类型**共分为以下四种：

*   区块（节）：将代码注入到区块（节）中。
*   进程：将代码注入到进程中。
*   代码：通过代码注入或代码溢出（Shellcode）。
*   DLL：代码挂载在 DLL 中载入。

[![process-injection](https://4.bp.blogspot.com/-ixv5E0LMZCw/WWi5yRjL-_I/AAAAAAAAAnk/WO99S4Yrd8w6lfg6tITwUV02CGDFYAORACLcBGAs/s1600/Process%2BInjection%25281%2529.png)](https://4.bp.blogspot.com/-ixv5E0LMZCw/WWi5yRjL-_I/AAAAAAAAAnk/WO99S4Yrd8w6lfg6tITwUV02CGDFYAORACLcBGAs/s1600/Process%2BInjection%25281%2529.png "Process%2BInjection%25281%2529.png")

<sub>由 [Karsten Hahn](https://twitter.com/struppigel) 制作的代码注入图形化过程<sup>[4]</sup></sub>。

如上图所示（图片若加载失败请前往 Github 仓库查看原文），每一个 API 触发器都列在了 **Execute** 这一栏下，当其中任何一个触发器被执行，Dreadnought 工具会立即将代码转储，之后将识别代码并匹配在此前假定的注入类型，这种方式和 UnRunPE 工具中处理傀儡进程的方式类似，但仅有这点是不够的，因为每一个触发 API 的行为都可能混淆了各种底层调用方法，最后仍旧可以实现上图中箭头所指向的功能。

## 启发式逻辑检测

启发式的逻辑算法将能够使我们的 Dreadnought 工具更加精准地确定代码注入方法。因此在实际开发中，我们使用了一种非常简单的启发式逻辑。从我们的进程注入信息图表上看，每一次当任何一个 API 被挂钩时，该算法将会增加一个或者多个相关的代码注入类型的权重并存储在一个 map 数据结构里。在它跟踪每个 API 的调用链时，它会尝试偏向某一种注入类型。一旦 API 触发器被触发，它将会识别并把每一个有关联的注入类型的权重对比之后采取适应的措施。

## Dreadnought 示例

### 进程注入之傀儡进程（Process hollowing）

[![](https://raw.githubusercontent.com/NtRaiseHardError/NtRaiseHardError.github.io/master/images/2018-02-21-Userland-API-Monitoring-and-Code-Injection-Detection/Screenshot%20from%202018-02-21%2020-14-46.png)](https://raw.githubusercontent.com/NtRaiseHardError/NtRaiseHardError.github.io/master/images/2018-02-21-Userland-API-Monitoring-and-Code-Injection-Detection/Screenshot%20from%202018-02-21%2020-14-46.png) 

### DLL 注入之 SetWindowsHookEx

[![](https://raw.githubusercontent.com/NtRaiseHardError/NtRaiseHardError.github.io/master/images/2018-02-21-Userland-API-Monitoring-and-Code-Injection-Detection/Screenshot%20from%202018-02-21%2020-15-35.png)](https://raw.githubusercontent.com/NtRaiseHardError/NtRaiseHardError.github.io/master/images/2018-02-21-Userland-API-Monitoring-and-Code-Injection-Detection/Screenshot%20from%202018-02-21%2020-15-35.png) 

### DLL 注入之 QueueUserAPC

[![](https://raw.githubusercontent.com/NtRaiseHardError/NtRaiseHardError.github.io/master/images/2018-02-21-Userland-API-Monitoring-and-Code-Injection-Detection/Screenshot%20from%202018-02-21%2020-16-17.png)](https://raw.githubusercontent.com/NtRaiseHardError/NtRaiseHardError.github.io/master/images/2018-02-21-Userland-API-Monitoring-and-Code-Injection-Detection/Screenshot%20from%202018-02-21%2020-16-17.png) 

### 代码注入之 Atom Bombing

[![](https://raw.githubusercontent.com/NtRaiseHardError/NtRaiseHardError.github.io/master/images/2018-02-21-Userland-API-Monitoring-and-Code-Injection-Detection/Screenshot%20from%202018-02-21%2020-24-43.png)](https://raw.githubusercontent.com/NtRaiseHardError/NtRaiseHardError.github.io/master/images/2018-02-21-Userland-API-Monitoring-and-Code-Injection-Detection/Screenshot%20from%202018-02-21%2020-24-43.png)

[![](https://raw.githubusercontent.com/NtRaiseHardError/NtRaiseHardError.github.io/master/images/2018-02-21-Userland-API-Monitoring-and-Code-Injection-Detection/Screenshot%20from%202018-02-21%2020-25-09.png)](https://raw.githubusercontent.com/NtRaiseHardError/NtRaiseHardError.github.io/master/images/2018-02-21-Userland-API-Monitoring-and-Code-Injection-Detection/Screenshot%20from%202018-02-21%2020-25-09.png)

[![](https://raw.githubusercontent.com/NtRaiseHardError/NtRaiseHardError.github.io/master/images/2018-02-21-Userland-API-Monitoring-and-Code-Injection-Detection/Screenshot%20from%202018-02-21%2020-29-30.png)](https://raw.githubusercontent.com/NtRaiseHardError/NtRaiseHardError.github.io/master/images/2018-02-21-Userland-API-Monitoring-and-Code-Injection-Detection/Screenshot%20from%202018-02-21%2020-29-30.png) 

* * *

# 总结

本文旨在让读者对代码注入及其与 WinAPI 的交互具有一定程度的技术理解。此外，在用户领域监控 API 调用的概念也曾被恶意地利用来绕过反病毒检测。下面是本文中有关 Dreadnought 工具在实际的使用情况说明。

## 本文档在实际应用时的缺点

目前在理论上，Dreadnought 工具的这套检测设计方式和启发式算法确实足够让我们向读者演示并讲述相关的原理知识，但在实际开发中却不可能这么理想。因为在我们操作系统的常规操作中，有非常大的可能性存在那些被用来挂钩的 API 的替代品。而这些可以替代它们的行为或者调用，我们无法分辨其是否为恶意的，也就无法检测到它们是否参与了代码注入。

由此看来，Dreadnought 工具以及它为用户领域提供的相关操作，在对抗过于复杂的恶意程序时并不理想，特别是能直接侵入到系统内核并与其进行交互的又或者是具有能够避开一般钩子能力的恶意程序等等。

* * *

# PoC 代码仓库

*   [GitHub - UnRunPE](https://github.com/NtRaiseHardError/UnRunPE)
*   [GitHub - Dreadnought](https://github.com/NtRaiseHardError/Dreadnought)

* * *

# 参考文献

*   [1] [https://www.blackhat.com/presentations/bh-usa-06/BH-US-06-Sotirov.pdf](https://www.blackhat.com/presentations/bh-usa-06/BH-US-06-Sotirov.pdf)
*   [2] [https://www.codeproject.com/Articles/7914/MessageBoxTimeout-API](https://www.codeproject.com/Articles/7914/MessageBoxTimeout-API)
*   [3] [https://blog.ensilo.com/atombombing-brand-new-code-injection-for-windows](https://blog.ensilo.com/atombombing-brand-new-code-injection-for-windows)
*   [4] [http://struppigel.blogspot.com.au/2017/07/process-injection-info-graphic.html](http://struppigel.blogspot.com.au/2017/07/process-injection-info-graphic.html)
*   [ReactOs](https://www.reactos.org/)
*   [NTAPI Undocumented Functions](https://undocumented.ntinternals.net/)
*   [ntcoder](http://ntcoder.com/category/undocumented-winapi/)
*   [GitHub - Process Hacker](https://github.com/processhacker/processhacker)
*   [YouTube - MalwareAnalysisForHedgehogs](https://www.youtube.com/channel/UCVFXrUwuWxNlm6UNZtBLJ-A)
*   [YouTube - OALabs](https://www.youtube.com/channel/UC--DwaiMV-jtO-6EvmKOnqg)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
