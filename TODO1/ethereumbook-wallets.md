> * 原文地址：[ethereumbook-wallets](https://github.com/ethereumbook/ethereumbook/blob/develop/wallets.asciidoc)
> * 原文作者：[ethereumbook](https://github.com/ethereumbook)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/.md](https://github.com/xitu/gold-miner/blob/master/TODO1/.md)
> * 译者：
> * 校对者：

## Wallets
=======

walletsdefined definedThe word "wallet" is used to describe a few
different things in Ethereum.

At a high level, a wallet is an application that serves as the primary
user interface. The wallet controls access to a user’s money, managing
keys and addresses, tracking the balance, and creating and signing
transactions. In addition, some Ethereum wallets can also interact with
contracts, such as tokens.

More narrowly, from a programmer’s perspective, the word "wallet" refers
to the system used to store and manage a user’s keys. Every "wallet" has
a key management component. For some wallets, that’s all there is. Other
wallets are part of a much broader category, that of "browsers," which
are interfaces to Ethereum-based decentralized applications or "DApps".
There are no clear lines of distinction between the various categories
that are conflated under the term "wallet".

In this section we will look at wallets as containers for private keys,
and as systems for managing keys.

### Wallet Technology Overview

In this section we summarize the various technologies used to construct
user-friendly, secure, and flexible Ethereum wallets.

walletscontents of contents ofA common misconception about Ethereum is
that Ethereum wallets contain ether or tokens. In fact, the wallet
contains only keys. The ether or other tokens are recorded in the
Ethereum blockchain. Users control the tokens on the network by signing
transactions with the keys in their wallets. keychainsIn a sense, an
Ethereum wallet is a *keychain*.

> **Tip**
>
> Ethereum wallets contain keys, not ether or tokens. Each user has a
> wallet containing keys. Wallets are really keychains containing pairs
> of private/public keys (see [private\_public\_keys]). Users sign
> transactions with the keys, thereby proving they own the ether. The
> ether is stored on the blockchain.

walletstypes ofprimary distinctions types ofprimary distinctions primary
distinctionsThere are two primary types of wallets, distinguished by
whether the keys they contain are related to each other or not.

JBOK walletsseealso=wallets seealso=walletswalletstypes ofJBOK wallets
types ofJBOK wallets JBOK walletsnondeterministic walletsseealso=wallets
seealso=walletsThe first type is a *nondeterministic wallet*, where each
key is independently generated from a random number. The keys are not
related to each other. This type of wallet is also known as a JBOK
wallet from the phrase "Just a Bunch Of Keys."

deterministic walletsseealso=wallets seealso=walletsThe second type of
wallet is a *deterministic wallet*, where all the keys are derived from
a single master key, known as the *seed*. All the keys in this type of
wallet are related to each other and can be generated again if one has
the original seed. key derivation methodsThere are a number of different
*key derivation* methods used in deterministic wallets. hierarchical
deterministic (HD) walletsseealso=wallets seealso=walletsThe most
commonly used derivation method uses a tree-like structure and is known
as a *hierarchical deterministic* or *HD* wallet.

mnemonic code wordsDeterministic wallets are initialized from a seed. To
make these easier to use, seeds are encoded as English words (or words
in other languages), also known as *mnemonic code words*.

The next few sections introduce each of these technologies at a high
level.

### Nondeterministic (Random) Wallets

walletstypes ofnondeterministic (random) wallets types
ofnondeterministic (random) wallets nondeterministic (random) walletsIn
the first Ethereum wallet (produced by the Ethereum pre-sale), wallet
files stored a single randomly generated private key. Such wallets are
being replaced with deterministic wallets because they are cumbersome to
manage, back up, and import. The disadvantage of random keys is that if
you generate many of them you must keep copies of all of them. Each key
must be backed up, or the funds it controls are irrevocably lost if the
wallet becomes inaccessible. Furthermore, Ethereum address reuse reduces
privacy by associating multiple transactions and addresses with each
other. A Type-0 nondeterministic wallet is a poor choice of wallet,
especially if you want to avoid address reuse because it means managing
many keys, which creates the need for frequent backups.

Many Ethereum clients (including go-ethereum or geth) use a *keystore*
file, which is a JSON-encoded file that contains a single (randomly
generated) private key, encrypted by a passphrase for extra security.
The JSON file contents look like this:

    {
        "address": "001d3f1ef827552ae1114027bd3ecf1f086ba0f9",
        "crypto": {
            "cipher": "aes-128-ctr",
            "ciphertext": "233a9f4d236ed0c13394b504b6da5df02587c8bf1ad8946f6f2b58f055507ece",
            "cipherparams": {
                "iv": "d10c6ec5bae81b6cb9144de81037fa15"
            },
            "kdf": "scrypt",
            "kdfparams": {
                "dklen": 32,
                "n": 262144,
                "p": 1,
                "r": 8,
                "salt": "99d37a47c7c9429c66976f643f386a61b78b97f3246adca89abe4245d2788407"
            },
            "mac": "594c8df1c8ee0ded8255a50caf07e8c12061fd859f4b7c76ab704b17c957e842"
        },
        "id": "4fcb2ba4-ccdb-424f-89d5-26cce304bf9c",
        "version": 3
    }

The keystore format uses a *Key Derivation Function (KDF)* also known as
a password stretching algorithm, which protects against brute-force,
dictionary, or rainbow table attacks against the passphrase encryption.
In simple terms, the private key is not encrypted by the passphrase
directly. Instead, the passphrase is *stretched*, by repeatedly hashing
it. The hashing function is repeated for 262144 rounds, which can be
seen in the keystore JSON as parameter crypto.kdfparams.n. An attacker
trying to brute-force the passphrase would have to apply 262144 rounds
of hashing for every attempted passphrase, which slows down the attack
sufficiently as to make it infeasible for passphrases of sufficient
complexity and length.

There are a number of software libraries that can read and write the
keystore format, such as the JavaScript library keythereum:

<https://github.com/ethereumjs/keythereum>

> **Tip**
>
> The use of nondeterministic wallets is discouraged for anything other
> than simple tests. They are simply too cumbersome to back up and use.
> Instead, use an industry-standard–based *HD wallet* with a *mnemonic*
> seed for backup.

### Deterministic (Seeded) Wallets

walletstypes ofdeterministic (seeded) wallets types ofdeterministic
(seeded) wallets deterministic (seeded) walletsDeterministic, or
"seeded," wallets are wallets that contain private keys that are all
derived from a common seed, through the use of a one-way hash function.
The seed is a randomly generated number that is combined with other
data, such as an index number or "chain code" (see
[section\_title](#hd_wallets)) to derive the private keys. In a
deterministic wallet, the seed is sufficient to recover all the derived
keys, and therefore a single backup, at creation time, is sufficient.
The seed is also sufficient for a wallet export or import, allowing for
easy migration of all the user’s keys between different wallet
implementations.

### HD Wallets (BIP-32/BIP-44)

walletstypes ofhierarchical deterministic (HD) wallets types
ofhierarchical deterministic (HD) wallets hierarchical deterministic
(HD) walletshierarchical deterministic (HD) walletsBitcoin improvement
proposalsHierarchical Deterministic Wallets (BIP-32/BIP-44) Hierarchical
Deterministic Wallets (BIP-32/BIP-44)Deterministic wallets were
developed to make it easy to derive many keys from a single "seed." The
most advanced form of deterministic wallets is the HD wallet defined by
Bitcoin’s BIP-32 standard. HD wallets contain keys derived in a tree
structure, such that a parent key can derive a sequence of children
keys, each of which can derive a sequence of grandchildren keys, and so
on, to an infinite depth. This tree structure is illustrated in
[hd\_wallet].

![HD wallet: a tree of keys generated from a single
seed](https://raw.githubusercontent.com/ethereumbook/ethereumbook/develop/images/hd_wallet.png)

HD wallets offer two major advantages over random (nondeterministic)
keys. First, the tree structure can be used to express additional
organizational meaning, such as when a specific branch of subkeys is
used to receive incoming payments and a different branch is used to
receive change from outgoing payments. Branches of keys can also be used
in corporate settings, allocating different branches to departments,
subsidiaries, specific functions, or accounting categories.

The second advantage of HD wallets is that users can create a sequence
of public keys without having access to the corresponding private keys.
This allows HD wallets to be used on an insecure server or in a
watch-only or receive-only capacity, where the wallet doesn’t have the
private keys that can spend the funds.

### Seeds and Mnemonic Codes (BIP-39)

walletstechnology ofseeds and mnemonic codes technology ofseeds and
mnemonic codes seeds and mnemonic codesmnemonic code wordsBitcoin
improvement proposalsMnemonic Code Words (BIP-39) Mnemonic Code Words
(BIP-39)HD wallets are a very powerful mechanism for managing many keys
and addresses. They are even more useful if they are combined with a
standardized way of creating seeds from a sequence of English words (or
words in another language) that are easy to transcribe, export, and
import across wallets. This is known as a *mnemonic* and the standard is
defined by BIP-39. Today, many Ethereum wallets (as well as wallets for
other cryptocurrencies) use this standard and can import and export
seeds for backup and recovery using interoperable mnemonics.

Let’s look at this from a practical perspective. Which of the following
seeds is easier to transcribe, record on paper, read without error,
export, and import into another wallet?

**A seed for a deterministic wallet, in hex.**

    FCCF1AB3329FD5DA3DA9577511F8F137

**A seed for a deterministic wallet, from a 12-word mnemonic.**

    wolf juice proud gown wool unfair
    wall cliff insect more detail hub

### Wallet Best Practices

walletsbest practices for best practices forBitcoin improvement
proposalsMultipurpose HD Wallet Structure (BIP-43) Multipurpose HD
Wallet Structure (BIP-43)As cryptocurrency wallet technology has
matured, certain common industry standards have emerged that make
wallets broadly interoperable, easy to use, secure, and flexible. These
standards also allow wallets to derive keys for multiple different
cryptocurrencies, all from a single mnemonic. These common standards
are:

-   Mnemonic code words, based on BIP-39

-   HD wallets, based on BIP-32

-   Multipurpose HD wallet structure, based on BIP-43

-   Multicurrency and multiaccount wallets, based on BIP-44

These standards may change or may become obsolete by future
developments, but for now they form a set of interlocking technologies
that have become the de-facto wallet standard for most cryptocurrencies.

The standards have been adopted by a broad range of software and
hardware wallets, making all these wallets interoperable. A user can
export a mnemonic generated on one of these wallets and import it in
another wallet, recovering all transactions, keys, and addresses.

Some example of software wallets supporting these standards include
(listed alphabetically) Jaxx, MetaMask, MyEtherWallet (MEW). hardware
walletshardware walletssee=also wallets see=also walletsExamples of
hardware wallets supporting these standards include (listed
alphabetically) Keepkey, Ledger, and Trezor.

The following sections examine each of these technologies in detail.

> **Tip**
>
> If you are implementing an Ethereum wallet, it should be built as a HD
> wallet, with a seed encoded as mnemonic code for backup, following the
> BIP-32, BIP-39, BIP-43, and BIP-44 standards, as described in the
> following sections.

### Mnemonic Code Words (BIP-39)

walletstechnology ofmnemonic code words technology ofmnemonic code words
mnemonic code wordsmnemonic code wordsid=mnemonic05 id=mnemonic05bitcoin
improvement proposalsMnemonic Code Words (BIP-39)id=BIP3905 Mnemonic
Code Words (BIP-39)id=BIP3905 id=BIP3905Mnemonic code words are word
sequences that represent (encode) a random number used as a seed to
derive a deterministic wallet. The sequence of words is sufficient to
re-create the seed and from there re-create the wallet and all the
derived keys. A wallet application that implements deterministic wallets
with mnemonic words will show the user a sequence of 12 to 24 words when
first creating a wallet. That sequence of words is the wallet backup and
can be used to recover and re-create all the keys in the same or any
compatible wallet application. Mnemonic words make it easier for users
to back up wallets because they are easy to read and correctly
transcribe, as compared to a random sequence of numbers.

> **Tip**
>
> brainwalletsMnemonic words are often confused with "brainwallets."
> They are not the same. The primary difference is that a brainwallet
> consists of words chosen by the user, whereas mnemonic words are
> created randomly by the wallet and presented to the user. This
> important difference makes mnemonic words much more secure, because
> humans are very poor sources of randomness.

Mnemonic codes are defined in BIP-39. Note that BIP-39 is one
implementation of a mnemonic code standard. There is a different
standard, *with a different set of words*, used by the Electrum bitcoin
wallet and predating BIP-39. BIP-39 was proposed by the company behind
the Trezor hardware wallet and is incompatible with Electrum’s
implementation. However, BIP-39 has now achieved broad industry support
across dozens of interoperable implementations and should be considered
the de-facto industry standard. Furthermore, BIP-39 can be used to
produce multicurrency wallets supporting Ethereum, whereas Electrum
seeds cannot.

BIP-39 defines the creation of a mnemonic code and seed, which we
describe here in nine steps. For clarity, the process is split into two
parts: steps 1 through 6 are shown in
[section\_title](#generating_mnemonic_words) and steps 7 through 9 are
shown in [section\_title](#mnemonic_to_seed).

#### Generating mnemonic words

Mnemonic words are generated automatically by the wallet using the
standardized process defined in BIP-39. The wallet starts from a source
of entropy, adds a checksum, and then maps the entropy to a word list:

1.  Create a random sequence (entropy) of 128 to 256 bits.

2.  Create a checksum of the random sequence by taking the
    first (entropy-length/32) bits of its SHA256 hash.

3.  Add the checksum to the end of the random sequence.

4.  Divide the sequence into sections of 11 bits.

5.  Map each 11-bit value to a word from the predefined dictionary of
    2048 words.

6.  The mnemonic code is the sequence of words.

[figure\_title](#generating_entropy_and_encoding) shows how entropy is
used to generate mnemonic words.

![Generating entropy and encoding as mnemonic
words](https://raw.githubusercontent.com/ethereumbook/ethereumbook/develop/images/bip39-part1.png)

[table\_title](#table_bip39_entropy) shows the relationship between the
size of the entropy data and the length of mnemonic codes in words.

<table>
<caption>Mnemonic codes: entropy and word length</caption>
<colgroup>
<col width="25%" />
<col width="25%" />
<col width="25%" />
<col width="25%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">Entropy (bits)</th>
<th align="left">Checksum (bits)</th>
<th align="left">Entropy <strong>+</strong> checksum (bits)</th>
<th align="left">Mnemonic length (words)</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>128</p></td>
<td align="left"><p>4</p></td>
<td align="left"><p>132</p></td>
<td align="left"><p>12</p></td>
</tr>
<tr class="even">
<td align="left"><p>160</p></td>
<td align="left"><p>5</p></td>
<td align="left"><p>165</p></td>
<td align="left"><p>15</p></td>
</tr>
<tr class="odd">
<td align="left"><p>192</p></td>
<td align="left"><p>6</p></td>
<td align="left"><p>198</p></td>
<td align="left"><p>18</p></td>
</tr>
<tr class="even">
<td align="left"><p>224</p></td>
<td align="left"><p>7</p></td>
<td align="left"><p>231</p></td>
<td align="left"><p>21</p></td>
</tr>
<tr class="odd">
<td align="left"><p>256</p></td>
<td align="left"><p>8</p></td>
<td align="left"><p>264</p></td>
<td align="left"><p>24</p></td>
</tr>
</tbody>
</table>

#### From mnemonic to seed

key-stretching functionPBKDF2 functionThe mnemonic words represent
entropy with a length of 128 to 256 bits. The entropy is then used to
derive a longer (512-bit) seed through the use of the key-stretching
function PBKDF2. The seed produced is then used to build a deterministic
wallet and derive its keys.

saltspassphrasesThe key-stretching function takes two parameters: the
mnemonic and a *salt*. The purpose of a salt in a key-stretching
function is to make it difficult to build a lookup table enabling a
brute-force attack. In the BIP-39 standard, the salt has another
purpose—it allows the introduction of a passphrase that serves as an
additional security factor protecting the seed, as we will describe in
more detail in [section\_title](#mnemonic_passphrase).

The process described in steps 7 through 9 continues from the process
described previously in [section\_title](#generating_mnemonic_words):

The first parameter to the PBKDF2 key-stretching function is the
mnemonic
produced from step 6.
The second parameter to the PBKDF2 key-stretching function is a
salt
. The salt is composed of the string constant "
mnemonic
" concatenated with an optional user-supplied passphrase string.
PBKDF2 stretches the mnemonic and salt parameters using 2048 rounds of
hashing with the HMAC-SHA512 algorithm, producing a 512-bit value as its
final output. That 512-bit value is the seed.
[fig\_5\_7] shows how a mnemonic is used to generate a seed.

![From mnemonic to seed](https://raw.githubusercontent.com/ethereumbook/ethereumbook/develop/images/bip39-part2.png)

> **Tip**
>
> The key-stretching function, with its 2048 rounds of hashing, is a
> somewhat effective protection against brute-force attacks against the
> mnemonic or the passphrase. It makes it costly (in computation) to try
> more than a few thousand passphrase and mnemonic combinations, while
> the number of possible derived seeds is vast (2<sup>512</sup>).

Tables \#mnemonic\_128\_no\_pass, \#mnemonic\_128\_w\_pass, and
\#mnemonic\_256\_no\_pass show some examples of mnemonic codes and the
seeds they produce (without any passphrase).

<table>
<caption>128-bit entropy mnemonic code, no passphrase, resulting seed</caption>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<tbody>
<tr class="odd">
<td align="left"><p><strong><strong>Entropy input (128 bits)</strong></strong></p></td>
<td align="left"><p>0c1e24e5917779d297e14d45f14e1a1a</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong><strong>Mnemonic (12 words)</strong></strong></p></td>
<td align="left"><p>army van defense carry jealous true garbage claim echo media make crunch</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong><strong>Passphrase</strong></strong></p></td>
<td align="left"><p>(none)</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong><strong>Seed (512 bits)</strong></strong></p></td>
<td align="left"><p>5b56c417303faa3fcba7e57400e120a0ca83ec5a4fc9ffba757fbe63fbd77a89a1a3be4c67196f57c39 a88b76373733891bfaba16ed27a813ceed498804c0570</p></td>
</tr>
</tbody>
</table>

<table>
<caption>128-bit entropy mnemonic code, with passphrase, resulting seed</caption>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<tbody>
<tr class="odd">
<td align="left"><p><strong><strong>Entropy input (128 bits)</strong></strong></p></td>
<td align="left"><p>0c1e24e5917779d297e14d45f14e1a1a</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong><strong>Mnemonic (12 words)</strong></strong></p></td>
<td align="left"><p>army van defense carry jealous true garbage claim echo media make crunch</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong><strong>Passphrase</strong></strong></p></td>
<td align="left"><p>SuperDuperSecret</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong><strong>Seed (512 bits)</strong></strong></p></td>
<td align="left"><p>3b5df16df2157104cfdd22830162a5e170c0161653e3afe6c88defeefb0818c793dbb28ab3ab091897d0 715861dc8a18358f80b79d49acf64142ae57037d1d54</p></td>
</tr>
</tbody>
</table>

<table>
<caption>256-bit entropy mnemonic code, no passphrase, resulting seed</caption>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<tbody>
<tr class="odd">
<td align="left"><p><strong><strong>Entropy input (256 bits)</strong></strong></p></td>
<td align="left"><p>2041546864449caff939d32d574753fe684d3c947c3346713dd8423e74abcf8c</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong><strong>Mnemonic (24 words)</strong></strong></p></td>
<td align="left"><p>cake apple borrow silk endorse fitness top denial coil riot stay wolf luggage oxygen faint major edit measure invite love trap field dilemma oblige</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong><strong>Passphrase</strong></strong></p></td>
<td align="left"><p>(none)</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong><strong>Seed (512 bits)</strong></strong></p></td>
<td align="left"><p>3269bce2674acbd188d4f120072b13b088a0ecf87c6e4cae41657a0bb78f5315b33b3a04356e53d062e5 5f1e0deaa082df8d487381379df848a6ad7e98798404</p></td>
</tr>
</tbody>
</table>

#### Optional passphrase in BIP-39

passphrasesThe BIP-39 standard allows the use of an optional passphrase
in the derivation of the seed. If no passphrase is used, the mnemonic is
stretched with a salt consisting of the constant string "mnemonic",
producing a specific 512-bit seed from any given mnemonic. If a
passphrase is used, the stretching function produces a *different* seed
from that same mnemonic. In fact, given a single mnemonic, every
possible passphrase leads to a different seed. Essentially, there is no
"wrong" passphrase. All passphrases are valid and they all lead to
different seeds, forming a vast set of possible uninitialized wallets.
The set of possible wallets is so large (2<sup>512</sup>) that there is
no practical possibility of brute-forcing or accidentally guessing one
that is in use, as long as the passphrase has sufficient complexity and
length.

> **Tip**
>
> There are no "wrong" passphrases in BIP-39. Every passphrase leads to
> some wallet, which unless previously used will be empty.

The optional passphrase creates two important features:

-   A second factor (something memorized) that makes a mnemonic useless
    on its own, protecting mnemonic backups from compromise by a thief.

-   A form of plausible deniability or "duress wallet," where a chosen
    passphrase leads to a wallet with a small amount of funds used to
    distract an attacker from the "real" wallet that contains the
    majority of funds.

However, it is important to note that the use of a passphrase also
introduces the risk of loss:

-   If the wallet owner is incapacitated or dead and no one else knows
    the passphrase, the seed is useless and all the funds stored in the
    wallet are lost forever.

-   Conversely, if the owner backs up the passphrase in the same place
    as the seed, it defeats the purpose of a second factor.

While passphrases are very useful, they should only be used in
combination with a carefully planned process for backup and recovery,
considering the possibility of surviving the owner and allowing his or
her family to recover the cryptocurrency estate.

#### Working with mnemonic codes

BIP-39 is implemented as a library in many different programming
languages:

[python-mnemonic](https://github.com/trezor/python-mnemonic)  
The reference implementation of the standard by the SatoshiLabs team
that proposed BIP-39, in Python

[Consensys/eth-lightwallet](https://github.com/ConsenSys/eth-lightwallet)  
Lightweight JS Ethereum Wallet for nodes and browser (with BIP-39)

[npm/bip39](https://www.npmjs.com/package/bip39)  
JavaScript implementation of Bitcoin BIP39: Mnemonic code for generating
deterministic keys

There is also a BIP-39 generator implemented in a standalone webpage,
which is extremely useful for testing and experimentation.
[figure\_title](#a_bip39_generator_as_a_standalone_web_page) shows a
standalone web page that generates mnemonics, seeds, and extended
private keys.

![A BIP-39 generator as a standalone web page](https://raw.githubusercontent.com/ethereumbook/ethereumbook/develop/images/bip39_web.png)

startref=mnemonic05 startref=mnemonic05startref=BIP3905
startref=BIP3905The page (<https://iancoleman.github.io/bip39/>) can be
used offline in a browser, or accessed online.

### Creating an HD Wallet from the Seed

walletstechnology ofcreating HD wallets from root seed technology
ofcreating HD wallets from root seed creating HD wallets from root
seedroot seedshierarchical deterministic (HD) walletsHD wallets are
created from a single *root seed*, which is a 128-, 256-, or 512-bit
random number. Most commonly, this seed is generated from a *mnemonic*
as detailed in the previous section.

Every key in the HD wallet is deterministically derived from this root
seed, which makes it possible to re-create the entire HD wallet from
that seed in any compatible HD wallet. This makes it easy to back up,
restore, export, and import HD wallets containing thousands or even
millions of keys by simply transferring only the mnemonic that the root
seed is derived from.

\[\[bip32\_bip43/44\]\] ==== Hierarchical Deterministic Wallets (BIP-32)
and paths (BIP-43/44)

Most HD wallets follow the BIP-32 standard, which has become a de-facto
industry standard for deterministic key generation. You can read the
detailed specification in:

<https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki>

We won’t be discussing the details of BIP-32 here, only the components
necessary to understand how it is used in wallets. There are dozens of
interoperable implementations of BIP-32 offered in many software
libraries:

[Consensys/eth-lightwallet](https://github.com/ConsenSys/eth-lightwallet)  
Lightweight JS Ethereum Wallet for nodes and browser (with BIP-32)

There is also a BIP-32 standalone web page generator that is very useful
for testing and experimentation with BIP-32:

<http://bip32.org/>

> **Note**
>
> The standalone BIP-32 generator is not an HTTPS site. That’s to remind
> you that the use of this tool is not secure. It is only for testing.
> You should not use the keys produced by this site in production (with
> real funds).

#### Extended public and private keys

In BIP-32 terminology, a parent key that can be extended to produce
"children," is called an *extended key*. If it is a private key, it is
an *extended private key* distinguished by the prefix *xprv*:

    xprv9s21ZrQH143K2JF8RafpqtKiTbsbaxEeUaMnNHsm5o6wCW3z8ySyH4UxFVSfZ8n7ESu7fgir8imbZKLYVBxFPND1pniTZ81vKfd45EHKX73

An *extended public key* is distinguished by the prefix *xpub*:

    xpub661MyMwAqRbcEnKbXcCqD2GT1di5zQxVqoHPAgHNe8dv5JP8gWmDproS6kFHJnLZd23tWevhdn4urGJ6b264DfTGKr8zjmYDjyDTi9U7iyT

A very useful characteristic of HD wallets is the ability to derive
public child keys from public parent keys, *without* having the private
keys. This gives us two ways to derive a child public key: either from
the child private key, or directly from the parent public key.

An extended public key can be used, therefore, to derive all of the
*public* keys (and only the public keys) in that branch of the HD wallet
structure.

This shortcut can be used to create very secure public key–only
deployments where a server or application has a copy of an extended
public key and no private keys whatsoever. That kind of deployment can
produce an infinite number of public keys and Ethereum addresses, but
cannot spend any of the money sent to those addresses. Meanwhile, on
another, more secure server, the extended private key can derive all the
corresponding private keys to sign transactions and spend the money.

One common application of this solution is to install an extended public
key on a web server that serves an e-commerce application. The web
server can use the public key derivation function to create a new
Ethereum address for every transaction (e.g., for a customer shopping
cart). The web server will not have any private keys that would be
vulnerable to theft. Without HD wallets, the only way to do this is to
generate thousands of Ethereum addresses on a separate secure server and
then preload them on the e-commerce server. That approach is cumbersome
and requires constant maintenance to ensure that the e-commerce server
doesn’t "run out" of keys.

cold storagestoragecold storage cold storagehardware walletsAnother
common application of this solution is for cold-storage or hardware
wallets. In that scenario, the extended private key can be stored on a
hardware wallet, while the extended public key can be kept online. The
user can create "receive" addresses at will, while the private keys are
safely stored offline. To spend the funds, the user can use the extended
private key on an offline signing Ethereum client or sign transactions
on the hardware wallet device.

#### Hardened child key derivation

public and private keyshardened child key derivation hardened child key
derivationhardened derivationThe ability to derive a branch of public
keys from an xpub is very useful, but it comes with a potential risk.
Access to an xpub does not give access to child private keys. However,
because the xpub contains the chain code, if a child private key is
known, or somehow leaked, it can be used with the chain code to derive
all the other child private keys. A single leaked child private key,
together with a parent chain code, reveals all the private keys of all
the children. Worse, the child private key together with a parent chain
code can be used to deduce the parent private key.

To counter this risk, HD wallets use an alternative derivation function
called *hardened derivation*, which "breaks" the relationship between
parent public key and child chain code. The hardened derivation function
uses the parent private key to derive the child chain code, instead of
the parent public key. This creates a "firewall" in the parent/child
sequence, with a chain code that cannot be used to compromise a parent
or sibling private key.

In simple terms, if you want to use the convenience of an xpub to derive
branches of public keys, without exposing yourself to the risk of a
leaked chain code, you should derive it from a hardened parent, rather
than a normal parent. As a best practice, the level-1 children of the
master keys are always derived through the hardened derivation, to
prevent compromise of the master keys.

#### Index numbers for normal and hardened derivation

The index number used in the BIP-32 derivation function is a 32-bit
integer. To easily distinguish between keys derived through the normal
derivation function versus keys derived through hardened derivation,
this index number is split into two ranges. Index numbers between 0 and
2<sup>31</sup>–1 (0x0 to 0x7FFFFFFF) are used *only* for normal
derivation. Index numbers between 2<sup>31</sup> and 2<sup>32</sup>–1
(0x80000000 to 0xFFFFFFFF) are used *only* for hardened derivation.
Therefore, if the index number is less than 2<sup>31</sup>, the child is
normal, whereas if the index number is equal or above 2<sup>31</sup>,
the child is hardened.

To make the index number easier to read and display, the index number
for hardened children is displayed starting from zero, but with a prime
symbol. The first normal child key is therefore displayed as 0, whereas
the first hardened child (index 0x80000000) is displayed as 0&\#x27;. In
sequence then, the second hardened key would have index 0x80000001 and
would be displayed as 1&\#x27;, and so on. When you see an HD wallet
index i&\#x27;, that means 2<sup>31</sup>+i.

#### HD wallet key identifier (path)

hierarchical deterministic (HD) walletsKeys in an HD wallet are
identified using a "path" naming convention, with each level of the tree
separated by a slash (/) character (see [table\_title](#hd_path_table)).
Private keys derived from the master private key start with "m." Public
keys derived from the master public key start with "M." Therefore, the
first child private key of the master private key is m/0. The first
child public key is M/0. The second grandchild of the first child is
m/0/1, and so on.

The "ancestry" of a key is read from right to left, until you reach the
master key from which it was derived. For example, identifier m/x/y/z
describes the key that is the z-th child of key m/x/y, which is the y-th
child of key m/x, which is the x-th child of m.

<table>
<caption>HD wallet path examples</caption>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">HD path</th>
<th align="left">Key described</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>m/0</p></td>
<td align="left"><p>The first (0) child private key from the master private key (m)</p></td>
</tr>
<tr class="even">
<td align="left"><p>m/0/0</p></td>
<td align="left"><p>The first grandchild private key of the first child (m/0)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>m/0'/0</p></td>
<td align="left"><p>The first normal grandchild of the first <em>hardened</em> child (m/0')</p></td>
</tr>
<tr class="even">
<td align="left"><p>m/1/0</p></td>
<td align="left"><p>The first grandchild private key of the second child (m/1)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>M/23/17/0/0</p></td>
<td align="left"><p>The first great-great-grandchild public key of the first great-grandchild of the 18th grandchild of the 24th child</p></td>
</tr>
</tbody>
</table>

#### Navigating the HD wallet tree structure

The HD wallet tree structure offers tremendous flexibility. Each parent
extended key can have 4 billion children: 2 billion normal children and
2 billion hardened children. Each of those children can have another 4
billion children, and so on. The tree can be as deep as you want, with
an infinite number of generations. With all that flexibility, however,
it becomes quite difficult to navigate this infinite tree. It is
especially difficult to transfer HD wallets between implementations,
because the possibilities for internal organization into branches and
subbranches are endless.

Two BIPs offer a solution to this complexity by creating some proposed
standards for the structure of HD wallet trees. BIP-43 proposes the use
of the first hardened child index as a special identifier that signifies
the "purpose" of the tree structure. Based on BIP-43, an HD wallet
should use only one level-1 branch of the tree, with the index number
identifying the structure and namespace of the rest of the tree by
defining its purpose. For example, an HD wallet using only branch
m/i&\#x27;/ is intended to signify a specific purpose and that purpose
is identified by index number "i."

Extending that specification, BIP-44 proposes a multicurrency
multiaccount structure as "purpose" number 44' under BIP-43. All HD
wallets following the BIP-44 structure are identified by the fact that
they only used one branch of the tree: m/44'/.

BIP-44 specifies the structure as consisting of five predefined tree
levels:

    m / purpose' / coin_type' / account' / change / address_index

The first-level "purpose" is always set to 44'. The second-level
"coin\_type" specifies the type of cryptocurrency coin, allowing for
multicurrency HD wallets where each currency has its own subtree under
the second level. There are several currencies defined in a standards
document, called SLIP0044:

<https://github.com/satoshilabs/slips/blob/master/slip-0044.md>

A few examples: Ethereum is m/44&\#x27;/60&\#x27;, Ethereum Classic is
m/44&\#x27;/61&\#x27;, Bitcoin is m/44&\#x27;/0&\#x27;, and Testnet for
all currencies is m/44&\#x27;/1&\#x27;.

The third level of the tree is "account," which allows users to
subdivide their wallets into separate logical subaccounts, for
accounting or organizational purposes. For example, an HD wallet might
contain two Ethereum "accounts": m/44&\#x27;/60&\#x27;/0&\#x27; and
m/44&\#x27;/60&\#x27;/1&\#x27;. Each account is the root of its own
subtree.

keys and addressessee=also public and private keys see=also public and
private keysBecause BIP-44 was created originally for bitcoin, it
contains a "quirk" that isn’t relevant in the Ethereum world. On the
fourth level of the path, "change," an HD wallet has two subtrees, one
for creating receiving addresses and one for creating change addresses.
Only the "receive" path is used in Ethereum, as there is no such thing
as a change address. Note that whereas the previous levels used hardened
derivation, this level uses normal derivation. This is to allow this
level of the tree to export extended public keys for use in a
non-secured environment. Usable addresses are derived by the HD wallet
as children of the fourth level, making the fifth level of the tree the
"address\_index." For example, the third receiving address for Ethereum
payments in the primary account would be
M/44&\#x27;/60&\#x27;/0&\#x27;/0/2. [table\_title](#bip44_path_examples)
shows a few more examples.

<table>
<caption>BIP-44 HD wallet structure examples</caption>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">HD path</th>
<th align="left">Key described</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>M/44&amp;#x27;/60&amp;#x27;/0&amp;#x27;/0/2</p></td>
<td align="left"><p>The third receiving public key for the primary Ethereum account</p></td>
</tr>
<tr class="even">
<td align="left"><p>M/44&amp;#x27;/0&amp;#x27;/3&amp;#x27;/1/14</p></td>
<td align="left"><p>The fifteenth change-address public key for the fourth bitcoin account</p></td>
</tr>
<tr class="odd">
<td align="left"><p>m/44&amp;#x27;/2&amp;#x27;/0&amp;#x27;/0/1</p></td>
<td align="left"><p>The second private key in the Litecoin main account, for signing transactions</p></td>
</tr>
</tbody>
</table>

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
