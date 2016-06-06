>* 原文链接 : [Python 3: An Intro to Encryption](http://www.blog.pythonlibrary.org/2016/05/18/python-3-an-intro-to-encryption/)
* 原文作者 : [Mike](http://www.blog.pythonlibrary.org/author/mld/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


Python 3 doesn’t have very much in its standard library that deals with encryption. Instead, you get hashing libraries. We’ll take a brief look at those in the chapter, but the primary focus will be on the following 3rd party packages: PyCrypto and cryptography. We will learn how to encrypt and decrypt strings with both of these libraries.

### Hashing

If you need secure hashes or message digest algorithms, then Python’s standard library has you covered in the **hashlib** module. It includes the FIPS secure hash algorithms SHA1, SHA224, SHA256, SHA384, and SHA512 as well as RSA’s MD5 algorithm. Python also supports the adler32 and crc32 hash functions, but those are in the **zlib** module.

One of the most popular uses of hashes is storing the hash of a password instead of the password itself. Of course, the hash has to be a good one or it can be decrypted. Another popular use case for hashes is to hash a file and then send the file and its hash separately. Then the person receiving the file can run a hash on the file to see if it matches the hash that was sent. If it does, then that means no one has changed the file in transit.

Let’s try creating an md5 hash:

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

Let’s take a moment to break this down a bit. First off, we import **hashlib** and then we create an instance of an md5 HASH object. Next we add some text to the hash object and we get a traceback. It turns out that to use the md5 hash, you have to pass it a byte string instead of a regular string. So we try that and then call it’s **digest** method to get our hash. If you prefer the hex digest, we can do that too:

    >>> md5.hexdigest()
    '1482ec1b2364f64e7d162a2b5b16f477'

There’s actually a shortcut method of creating a hash, so we’ll look at that next when we create our sha512 hash:

    >>> sha = hashlib.sha1(b'Hello Python').hexdigest()
    >>> sha
    '422fbfbc67fe17c86642c5eaaa48f8b670cbed1b'

As you can see, we can create our hash instance and call its digest method at the same time. Then we print out the hash to see what it is. I chose to use the sha1 hash as it has a nice short hash that will fit the page better. But it’s also less secure, so feel free to try one of the others.

### Key Derivation

Python has pretty limited support for key derivation built into the standard library. In fact, the only method that hashlib provides is the **pbkdf2_hmac** method, which is the PKCS#5 password-based key derivation function 2\. It uses HMAC as its psuedorandom function. You might use something like this for hashing your password as it supports a salt and iterations. For example, if you were to use SHA-256 you would need a salt of at least 16 bytes and a minimum of 100,000 iterations.

As a quick aside, a salt is just random data that you use as additional input into your hash to make it harder to “unhash” your password. Basically it protects your password from dictionary attacks and pre-computed rainbow tables.

Let’s look at a simple example:

    >>> import binascii
    >>> dk = hashlib.pbkdf2_hmac(hash_name='sha256',
            password=b'bad_password34', 
            salt=b'bad_salt', 
            iterations=100000)
    >>> binascii.hexlify(dk)
    b'6e97bad21f6200f9087036a71e7ca9fa01a59e1d697f7e0284cd7f9b897d7c02'

Here we create a SHA256 hash on a password using a lousy salt but with 100,000 iterations. Of course, SHA is not actually recommended for creating keys of passwords. Instead you should use something like **scrypt** instead. Another good option would be the 3rd party package, bcrypt. It is designed specifically with password hashing in mind.

### PyCryptodome

The PyCrypto package is probably the most well known 3rd party cryptography package for Python. Sadly PyCrypto’s development stopping in 2012\. Others have continued to release the latest version of PyCryto so you can still get it for Python 3.5 if you don’t mind using a 3rd party’s binary. For example, I found some binary Python 3.5 wheels for PyCrypto on Github (https://github.com/sfbahr/PyCrypto-Wheels).

Fortunately there is a fork of the project called PyCrytodome that is a drop-in replacement for PyCrypto. To install it for Linux, you can use the following pip command:

`pip install pycryptodome`

Windows is a bit different:

`pip install pycryptodomex`

If you run into issues, it’s probably because you don’t have the right dependencies installed or you need a compiler for Windows. Check out the PyCryptodome [website](http://pycryptodome.readthedocs.io/en/latest/) for additional installation help or to contact support.

Also worth noting is that PyCryptodome has many enhancements over the last version of PyCrypto. It is well worth your time to visit their home page and see what new features exist.

#### Encrypting a String

Once you’re done checking their website out, we can move on to some examples. For our first trick, we’ll use DES to encrypt a string:

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

This code is a little confusing, so let’s spend some time breaking it down. First off, it should be noted that the key size for DES encryption is 8 bytes, which is why we set our key variable to a size letter string. The string that we will be encrypting must be a multiple of 8 in length, so we create a function called **pad** that can pad any string out with spaces until it’s a multiple of 8\. Next we create an instance of DES and some text that we want to encrypt. We also create a padded version of the text. Just for fun, we attempt to encrypt the original unpadded variant of the string which raises a **ValueError**. Here we learn that we need that padded string after all, so we pass that one in instead. As you can see, we now have an encrypted string!

Of course the example wouldn’t be complete if we didn’t know how to decrypt our string:

    >>> des.decrypt(encrypted_text)
    b'Python rocks!   '

Fortunately, that is very easy to accomplish as all we need to do is call the **decrypt** method on our des object to get our decrypted byte string back. Our next task is to learn how to encrypt and decrypt a file with PyCrypto using RSA. But first we need to create some RSA keys!

#### Create an RSA Key

If you want to encrypt your data with RSA, then you’ll need to either have access to a public / private RSA key pair or you will need to generate your own. For this example, we will just generate our own. Since it’s fairly easy to do, we will do it in Python’s interpreter:

    >>> from Crypto.PublicKey import RSA
    >>> code = 'nooneknows'
    >>> key = RSA.generate(2048)
    >>> encrypted_key = key.exportKey(passphrase=code, pkcs=8, 
            protection="scryptAndAES128-CBC")
    >>> with open('/path_to_private_key/my_private_rsa_key.bin', 'wb') as f:
            f.write(encrypted_key)
    >>> with open('/path_to_public_key/my_rsa_public.pem', 'wb') as f:
            f.write(key.publickey().exportKey())

First we import **RSA** from **Crypto.PublicKey**. Then we create a silly passcode. Next we generate an RSA key of 2048 bits. Now we get to the good stuff. To generate a private key, we need to call our RSA key instance’s **exportKey** method and give it our passcode, which PKCS standard to use and which encryption scheme to use to protect our private key. Then we write the file out to disk.

Next we create our public key via our RSA key instance’s **publickey** method. We used a shortcut in this piece of code by just chaining the call to **exportKey** with the publickey method call to write it to disk as well.

#### Encrypting a File

Now that we have both a private and a public key, we can encrypt some data and write it to a file. Here’s a pretty standard example:

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

The first three lines cover our imports from PyCryptodome. Next we open up a file to write to. Then we import our public key into a variable and create a 16-byte session key. For this example we are going to be using a hybrid encryption method, so we use PKCS#1 OAEP, which is Optimal asymmetric encryption padding. This allows us to write a data of an arbitrary length to the file. Then we create our AES cipher, create some data and encrypt the data. This will return the encrypted text and the MAC. Finally we write out the nonce, MAC (or tag) and the encrypted text.

As an aside, a nonce is an arbitrary number that is only used for crytographic communication. They are usually random or pseudorandom numbers. For AES, it must be at least 16 bytes in length. Feel free to try opening the encrypted file in your favorite text editor. You should just see gibberish.

Now let’s learn how to decrypt our data:

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

If you followed the previous example, this code should be pretty easy to parse. In this case, we are opening our encrypted file for reading in binary mode. Then we import our private key. Note that when you import the private key, you must give it your passcode. Otherwise you will get an error. Next we read in our file. You will note that we read in the private key first, then the next 16 bytes for the nonce, which is followed by the next 16 bytes which is the tag and finally the rest of the file, which is our data.

Then we need to decrypt our session key, recreate our AES key and decrypt the data.

You can use PyCryptodome to do much, much more. However we need to move on and see what else we can use for our cryptographic needs in Python.

### The cryptography package

The **cryptography** package aims to be “cryptography for humans” much like the **requests** library is “HTTP for Humans”. The idea is that you will be able to create simple cryptographic recipes that are safe and easy-to-use. If you need to, you can drop down to low=level cryptographic primitives, which require you to know what you’re doing or you might end up creating something that’s not very secure.

If you are using Python 3.5, you can install it with pip, like so:

`pip install cryptography`

You will see that cryptography installs a few dependencies along with itself. Assuming that they all completed successfully, we can try encrypting some text. Let’s give the **Fernet** symmetric encryption algorithm. The Fernet algorithm guarantees that any message you encrypt with it cannot be manipulated or read without the key you define. Fernet also support key rotation via **MultiFernet**. Let’s take a look at a simple example:

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

First off we need to import Fernet. Next we generate a key. We print out the key to see what it looks like. As you can see, it’s a random byte string. If you want, you can try running the **generate_key** method a few times. The result will always be different. Next we create our Fernet cipher instance using our key.

Now we have a cipher we can use to encrypt and decrypt our message. The next step is to create a message worth encrypting and then encrypt it using the **encrypt** method. I went ahead and printed our the encrypted text so you can see that you can no longer read the text. To decrypt our super secret message, we just call **decrypt** on our cipher and pass it the encrypted text. The result is we get a plain text byte string of our message.

### Wrapping Up

This chapter barely scratched the surface of what you can do with PyCryptodome and the cryptography packages. However it does give you a decent overview of what can be done with Python in regards to encrypting and decrypting strings and files. Be sure to read the documentation and start experimenting to see what else you can do!

### Related Reading

*   PyCrypto Wheels for Python 3 on [github](https://github.com/sfbahr/PyCrypto-Wheels)
*   PyCryptodome [documentation](http://pycryptodome.readthedocs.io/en/latest/src/introduction.html)
*   Python’s Cryptographic [Services](https://docs.python.org/3/library/crypto.html)
*   The cryptography package’s [website](https://cryptography.io/en/latest/)

