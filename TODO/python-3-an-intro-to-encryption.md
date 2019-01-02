>* 原文链接 : [Python 3: An Intro to Encryption](http://www.blog.pythonlibrary.org/2016/05/18/python-3-an-intro-to-encryption/)
* 原文作者 : [Mike](http://www.blog.pythonlibrary.org/author/mld/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Yushneng](https://github.com/rainyear)
* 校对者: [Zheaoli](https://github.com/Zheaoli), [iThreeKing](https://github.com/iThreeKing)

# 探索 Python 3 加密技术

Python 3 没有太多用于处理加密的标准库，通常以哈希库作为替代。在本章节中我们将简单了解一下 `hashlib`，但重点还是集中在两个第三方库：PyCrypto 和 cryptography。我们将会学习如何使用这些库对字符串进行加密和解密。

### 哈希法

如果你需要安全哈希或密文信息的算法，那么可以使用 **`hashlib`** 模块所提供的 Python 标准库，它提供 SHA1，SHA224，SHA256，SHA384，SHA512 等 FIPS 安全哈希算法以及 RSA MD5 算法。Python 也支持 adler32 和 crc32 哈希函数，不过它们由 **`zlib`** 模块提供。

哈希算法最常用于对密码进行加密，从而保存密码的哈希值而非明文密码。当然，哈希算法必须足够好否则就会被破译。哈希算法的另一用途是获取文件的哈希值并将其与文件分开传递，接收者就可以据此判断收到的文件与哈希值是否匹配，如果匹配这说明在传递过程中文件没有被人篡改。

让我们试着生成一个 md5 哈希值：

    >>> import hashlib
    >>> md5 = hashlib.md5()
    >>> md5.update('Python rocks!')
    Traceback (most recent call last):
      File "<pyshell#5>"</pyshell#5>, line 1, in <module>
        md5.update('Python rocks!')
    TypeError: Unicode-objects must be encoded before hashing
    >>> md5.update(b'Python rocks!')
    >>> md5.digest()
    b'\x14\x82\xec\x1b#d\xf6N}\x16*+[\x16\xf4w'

让我们花点时间分解一下这个过程。首先，我们引入了 **`hashlib`** 模块并创建了一个 md5 HASH 对象。接下来我们向这个对象添加了一些文本字符，但是却得到错误信息。要使用 md5 哈希算法，你必须传递字节串而不是普通的字符串。于是我们改用字节串并调用 **`digest`** 方法获取我们想要的哈希值。如果你想要十六进制的密文，我们也可以做到：

    >>> md5.hexdigest()
    '1482ec1b2364f64e7d162a2b5b16f477'

实际上有更便捷的方法产生哈希值，在创建 sha512 哈希值的时候我们可以这样做：

    >>> sha = hashlib.sha1(b'Hello Python').hexdigest()
    >>> sha
    '422fbfbc67fe17c86642c5eaaa48f8b670cbed1b'

正如你所见，我们可以在创建哈希对象实例的同时调用密文算法，然后将其结果打印出来。我选择 sha1 哈希算法是因为它的结果更短能够更好地适应页面。但同样也更不安全，你也可以随便尝试一下上面列举的其它算法。

### 密钥派生

Python 内置标准库对密钥派生的支持非常有限。实际上 `hashlib` 提供的唯一方法是 **`pbkdf2_hmac`**，实现的是 PKCS#5 基于密码的密钥派生函数2（PBKDF2 译者注：这里作者原意是pbkdf2_hmac是基于PBKDF2的实现，详细细节可以参看PKCS#5标准，即RFC6070标准 ），它利用 HMAC 作为伪随机函数。你也可以用自己的算法来完成对密码的哈希加密，只要支持 `salt` 和迭代。例如，如果你用 SHA-256 你可能需要一个长度至少为16个字节的 `salt` 和至少 100,000 次迭代。

简单解释一下，`salt` 是一个随机数据，用来和密码加到一起进行哈希加密，从而使得更难从哈希值“解哈希”得到密码。基本上可以保护你的密码不受字典攻击和预计算彩虹表攻击（译者注:彩虹表是通过实现计算一系列字符集的hash值的数据，然后通过hash后的数据，反查原文的攻击方式）。

让我们来看一个简单的例子：

    >>> import binascii
    >>> dk = hashlib.pbkdf2_hmac(hash_name='sha256',
            password=b'bad_password34',
            salt=b'bad_salt',
            iterations=100000)
    >>> binascii.hexlify(dk)
    b'6e97bad21f6200f9087036a71e7ca9fa01a59e1d697f7e0284cd7f9b897d7c02'

这里我们使用一个简单的 salt 数据，但经过 100,000 次迭代来对密码创建一个 SHA256 哈希对象。。当然，实际上并不推荐 SHA 作为密码的密钥派生算法，而是应该使用 **`scrypt`** 之类的方法。另外一个很好的选择是使用第三方包：`bcrypt`，它的设计初衷就是为了专门应对密码哈希加密的。

### PyCryptodome

`PyCryto` 可能是 Python 最著名的第三方加密包。可惜的是 `PyCryto` 的开发在 2012 年就停止了。但其他人在不停地发布新版本的 `PyCryto` 让你可以在 Python 3.5 中使用，如果你不介意使用第三方库作为加密方法的话。例如，我发现了 Github 上一个 Python 3.5 版本的二进制安装包（https://github.com/sfbahr/PyCrypto-Wheels）。

幸运的是有一个名为 `PyCrytodome` 的 fork 项目可以替代 `PyCrypto`。在 Linux 上可以用 `pip` 命令安装：

`pip install pycryptodome`

Windows 系统上有点不同：

`pip install pycryptodomex`

如果安装过程中遇到问题，可能是因为你没有安装正确的依赖包或者你需要 Windows 系统下面的编译器，可以查看 `PyCryptodome` [网站](http://pycryptodome.readthedocs.io/en/latest/) 寻找更多安装的帮助或联系支持。

另外值得一提的是 `PyCryptodome` 有许多针对最后一版 `PyCryto` 的增强版本，值得你花时间去访问它的首页查看一下有哪些新的特性。

#### 加密字符串

看完他们的首页之后，我们可以继续看几个例子。首先我们用 DES 来加密一个字符串：

    >>> from Crypto.Cipher import DES
    >>> key = 'abcdefgh'
    >>> def pad(text):
            while len(text) % 8 != 0:
                text += ' '
            return text
    >>> des = DES.new(key, DES.MODE_ECB)
    >>> text = 'Python rocks!'
    >>> padded_text = pad(text)
    >>> encrypted_text = des.encrypt(text)
    Traceback (most recent call last):
      File "<pyshell#35>"</pyshell#35>, line 1, in <module>
        encrypted_text = des.encrypt(text)
      File "C:\Programs\Python\Python35-32\lib\site-packages\Crypto\Cipher\blockalgo.py", line 244, in encrypt
        return self._cipher.encrypt(plaintext)
    ValueError: Input strings must be a multiple of 8 in length
    >>> encrypted_text = des.encrypt(padded_text)
    >>> encrypted_text
    b'>\xfc\x1f\x16x\x87\xb2\x93\x0e\xfcH\x02\xd59VQ'

这段代码看起来可能有点绕，我们花点时间了将它分解一下。首先，需要注意 DES 加密所需要的密钥长度应为8字节，因此我们设定变量 `key` 为这一长度的字符串。被加密的字符串长度必须是 8 的倍数，因此我们创建一个 **`pad`** 方法来将字符串用空格填充直至长度为8的倍数。接下来我们创建一个 DES 实例和一个填充过的字符串。我们试一下对原始字符串进行加密结果会导致 **`ValueError`** ，我们已经知道将填充过的字符串传递给加密算法，正如你所见，我们可以对字符串进行加密了！


当然这个例子还没结束，我们需要知道如何解密：

    >>> des.decrypt(encrypted_text)
    b'Python rocks!   '

幸运的是，解密方法非常简单，我们只需要调用 `des` 对象的 **`decrypt`** 方法就可以得到原始的字节串。我们接下来的任务是学习如何利用 `PyCrypto` 的 RSA 算法对文件进行加密和解密，首先我们需要生成 RSA 密钥！

#### 生成一个 RSA 密钥

如果你想要通过 RSA 算法加密你的数据，那么你将需要一对 RSA 公/私钥组合或者自己生成一对。在这个例子中，我们将会自己生成一对。由于非常简单，我们直接在 Python 解释器中完成：

    >>> from Crypto.PublicKey import RSA
    >>> code = 'nooneknows'
    >>> key = RSA.generate(2048)
    >>> encrypted_key = key.exportKey(passphrase=code, pkcs=8,
            protection="scryptAndAES128-CBC")
    >>> with open('/path_to_private_key/my_private_rsa_key.bin', 'wb') as f:
            f.write(encrypted_key)
    >>> with open('/path_to_public_key/my_rsa_public.pem', 'wb') as f:
            f.write(key.publickey().exportKey())

首先我们引入 从 **`Crypto.PublicKey`** 引入 **RSA** ，然后创建一个密码。接下来我们生成一个 2048 位的 RSA 对象的实例。为了生成私钥，我们需要调用 RSA 实例的 **`exportKey`** 方法并传递给它刚刚创建的密码，PKCS 标准算法将会用它保护我们的私钥。接下来我们将生成的私钥写入文件。

下一步我们通过 RSA 实例的 **`publickey`** 方法生成公钥，我们在这段代码中用了简写的方式将 **`publickey`** 和 **`exportKey`** 方法串接起来，最后也将结果写入文件。

#### 对文件进行加密

现在我们有了一对私钥和公钥，我们可以对我们的数据进行加密并写入文件。下面是一个非常标准的例子：

    from Crypto.PublicKey import RSA
    from Crypto.Random import get_random_bytes
    from Crypto.Cipher import AES, PKCS1_OAEP

    with open('/path/to/encrypted_data.bin', 'wb') as out_file:
        recipient_key = RSA.import_key(
            open('/path_to_public_key/my_rsa_public.pem').read())
        session_key = get_random_bytes(16)

        cipher_rsa = PKCS1_OAEP.new(recipient_key)
        out_file.write(cipher_rsa.encrypt(session_key))

        cipher_aes = AES.new(session_key, AES.MODE_EAX)
        data = b'blah blah blah Python blah blah'
        ciphertext, tag = cipher_aes.encrypt_and_digest(data)

        out_file.write(cipher_aes.nonce)
        out_file.write(tag)
        out_file.write(ciphertext)

前三行完成对 `PyCryptodome` 的引入，接下来打开将要写入的文件。然后我们将公钥读入变量并创建一个16字节长的 session key。在这个例子中我们用了混合加密方法，因此我们使用最优非对称加密填充的 PKCS#1 OAEP。这让我们可以将任意长度的数据写入文件。接下来我们创建 AES 密文，创建一些数据并进行加密，这一方法会返回加密后的文本和 MAC 值。最终我们将 `nonce`，`MAC`(或`tag`)以及加密后的文本写入文件。

说明一下，`nonce` 是一个任意数字，仅用于密文通信。它们通常是随机或伪随机数。对于 AES 来说，它的长度至少要是16位。你可以用你的文本编辑器打开加密后的文件看一下，只能看到一堆乱码。

现在让我们学一下如何解密数据：

    from Crypto.PublicKey import RSA
    from Crypto.Cipher import AES, PKCS1_OAEP

    code = 'nooneknows'

    with open('/path/to/encrypted_data.bin', 'rb') as fobj:
        private_key = RSA.import_key(
            open('/path_to_private_key/my_rsa_key.pem').read(),
            passphrase=code)

        enc_session_key, nonce, tag, ciphertext = [ fobj.read(x)
                                                    for x in (private_key.size_in_bytes(),
                                                    16, 16, -1) ]

        cipher_rsa = PKCS1_OAEP.new(private_key)
        session_key = cipher_rsa.decrypt(enc_session_key)

        cipher_aes = AES.new(session_key, AES.MODE_EAX, nonce)
        data = cipher_aes.decrypt_and_verify(ciphertext, tag)

    print(data)

如果前面的例子你都跟上了，那这段代码应该很容易读懂了。在这个例子中，我们以二进制模式打开加密文件，然后导入私钥。要注意在导入私钥的时候，必须给出你的密码，否则将会出错。接下来我们读取加密文件，需要注意的是先读取私钥，然后是16位长的 `nonce`，接下来是另外 16 位长的标签，最后剩下的才是我们的数据。

接下来我们需要解密 `session key`，重新生成 AES key 并解密数据。

你可以用 `PyCryptodome` 来做更多的事，但是在这里我们需要继续看看 Python 中解决加密问题还有别的什么方法可用。

### `cryptography` 包

**`cryptography`** 包的目的是”给人类使用的加密工具”，就像**`requests`**是“给人类使用的HTTP”工具包一样。其理念是让你可以用简单的方法创建安全、易用的加密方案。如果你需要，你也可以深入到底层加密原理，这就要求你必须知道你在做什么，而且很有可能最终得到一些并不那么安全的结果。

如果你正在用 Python 3.5，你可以像这样使用 `pip` 安装：

`pip install cryptography`

你会发现 `cryptography` 自己安装了几个依赖包。假设这些都成功安装完成，我们可以试着来加密一些文本。让我们用一下 **`Fernet`** 对称加密算法。Fernet 算法保证你加密的任何消息除非有你自己定义的密钥都无法修改或读取。Fernet 同时也支持通过 **`MultiFernet`** 方法对密钥进行旋转。让我们来看一个简单的例子：

    >>> from cryptography.fernet import Fernet
    >>> cipher_key = Fernet.generate_key()
    >>> cipher_key
    b'APM1JDVgT8WDGOWBgQv6EIhvxl4vDYvUnVdg-Vjdt0o='
    >>> cipher = Fernet(cipher_key)
    >>> text = b'My super secret message'
    >>> encrypted_text = cipher.encrypt(text)
    >>> encrypted_text
    (b'gAAAAABXOnV86aeUGADA6mTe9xEL92y_m0_TlC9vcqaF6NzHqRKkjEqh4d21PInEP3C9HuiUkS9f'
     b'6bdHsSlRiCNWbSkPuRd_62zfEv3eaZjJvLAm3omnya8=')
    >>> decrypted_text = cipher.decrypt(encrypted_text)
    >>> decrypted_text
    b'My super secret message'

首先我们需要引入 Fernet，然后生成一个密钥。这里将密钥打印出来看看它是什么。如你所见，它是一个随机的字节串。你也可以多运行几次 **`generate_key`** 方法，每次的结果应该都不相同。接下来我们基于这一密钥创建 Fernet 密文实例。

有了密文之后我们可以用来加密和解密我们的消息，可以用**`encrypt`**方法实现对必要消息的加密。接下来我讲加密后的结果打印出来可以看出来已经无法正常阅读了。调用 **`decrypt`** 方法可以对消息进行解密，结果可以得到最初的原始消息。

### 总结

本章只简单介绍了 `PyCryptodome` 和 `cryptography` 包最基本的用法，可以让你对如何通过 Python 对字符和文件进行加密、解密有整体的了解。请一定要阅读文档并亲自实验尝试！

### 相关阅读

*   PyCrypto Wheels for Python 3 on [github](https://github.com/sfbahr/PyCrypto-Wheels)
*   PyCryptodome [documentation](http://pycryptodome.readthedocs.io/en/latest/src/introduction.html)
*   Python’s Cryptographic [Services](https://docs.python.org/3/library/crypto.html)
*   The cryptography package’s [website](https://cryptography.io/en/latest/)
