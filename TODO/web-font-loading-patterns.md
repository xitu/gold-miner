>* 原文链接 : [Web Font Loading Patterns](https://www.bramstein.com/writing/web-font-loading-patterns.html)
* 原文作者 : [Bram Stein](https://www.bramstein.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


Web font load­ing may seem com­pli­cated, but it is ac­tu­ally quite sim­ple if you use these font load­ing pat­terns. Com­bine the pat­terns to cre­ate cus­tom font load­ing be­hav­iour that works in all browsers.

The code ex­am­ples in these pat­terns use [Font Face Ob­server](https://github.com/bramstein/fontfaceobserver), a small and sim­ple web font loader. Font Face Ob­server will use the most ef­fi­cient way to load a font de­pend­ing on browser sup­port, so it is a great way to load web fonts with­out hav­ing to worry about cross-browser com­pat­i­bil­ity.

1.  [Ba­sic font load­ing](#basic-font-loading)
2.  [Load­ing groups of fonts](#loading-groups-of-fonts)
3.  [Load­ing fonts with a time­out](#loading-fonts-with-a-timeout)
4.  [Pri­ori­tised load­ing](#prioritised-loading)
5.  [Cus­tom font dis­play](#custom-font-display)
6.  [Op­ti­mise for caching](#optimise-for-caching)

It’s im­pos­si­ble to rec­om­mend a sin­gle pat­tern that works best for every­one. Take a close look at your site and vis­i­tors and se­lect a font load­ing pat­tern, or a com­bi­na­tion of pat­terns, that work best for you.

## [](https://www.bramstein.com/writing/web-font-loading-patterns.html#basic-font-loading)Basic font loading

Font Face Ob­server gives you con­trol over web font load­ing us­ing a sim­ple promise based in­ter­face. It does­n’t mat­ter where your fonts come from: you can host them your­self, or use a web font ser­vice such as [Google Fonts](http://www.google.com/fonts), [Type­kit](http://typekit.com/), [Fonts.com](https://fonts.com/), and [Web­type](http://webtype.com/).

To keep the pat­terns sim­ple this ar­ti­cle as­sumes you’re self-host­ing web fonts. This means you should have one or mul­ti­ple `@font-face` rules in your <abbr>CSS</abbr> files for the web fonts you want to load us­ing Font Face Ob­server. For the sake of brevity, the `@font-face` rules won’t be in­cluded in each font load­ing pat­terns, but they should be as­sumed to be there.

    @font-face {
      font-family: Output Sans;
      src: url(output-sans.woff2) format("woff2"),
           url(output-sans.woff) format("woff");
    }

The most ba­sic pat­tern is to load one or mul­ti­ple in­di­vid­ual fonts. You can do this by cre­at­ing sev­eral `FontFaceObserver` in­stances, one for each web font, and call­ing their `load` method.

    var output = new FontFaceObserver('Output Sans');
    var input = new FontFaceObserver('Input Mono');

    output.load().then(function () {
      console.log('Output Sans has loaded.');
    });

    input.load().then(function () {
      console.log('Input Mono has loaded.');
    });

This will load each web font in­de­pen­dently, which is use­ful when the fonts are un­re­lated and sup­posed to ren­der pro­gres­sively (i.e. as soon as they load). Un­like the [na­tive font load­ing <abbr>API</abbr>](https://www.w3.org/TR/css-font-loading/) you don’t pass font <abbr>URL</abbr>s to Font Face Ob­server. It will use the `@font-face` rules al­ready avail­able in your <abbr>CSS</abbr> to load fonts. This al­lows you to load your web fonts man­u­ally us­ing JavaScript, with a grace­ful degra­da­tion to ba­sic <abbr>CSS</abbr>.

## [](https://www.bramstein.com/writing/web-font-loading-patterns.html#loading-groups-of-fonts)Loading groups of fonts

You can also load mul­ti­ple fonts at the same time by group­ing them: they will ei­ther all load, or the en­tire group will fail to load. This can be use­ful if the fonts you’re load­ing be­long to the same fam­ily and you want to stop the group from ren­der­ing un­less all of the styles load. This will pre­vent the browser from gen­er­at­ing faux styles when it does­n’t have the en­tire font fam­ily.

    var normal = new FontFaceObserver('Output Sans');
    var italic = new FontFaceObserver('Output Sans', {
      style: 'italic'
    });

    Promise.all([
      normal.load(),
      italic.load()
    ]).then(function () {
      console.log('Output Sans family has loaded.');
    });

You can group fonts by us­ing `Promise.all`. When the promise is re­solved all fonts will have loaded. If the promise is re­jected at least one of the fonts failed to load.

An­other use case for group­ing fonts is to re­duce re­flows. If you load and ren­der web fonts pro­gres­sively the browser will need to re­cal­cu­late the lay­out mul­ti­ple times due to the dif­fer­ence in font met­rics be­tween the fall­back and web fonts. Group­ing can re­duce this to a sin­gle re­lay­out.

## [](https://www.bramstein.com/writing/web-font-loading-patterns.html#loading-fonts-with-a-timeout)Loading fonts with a timeout

Some­times fonts take a long time to load. This can be prob­lem­atic be­cause web fonts are of­ten used to ren­der the main con­tent of your site: the text. It’s not ac­cept­able to in­def­i­nitely wait for a font to load. You can fix this by adding a timer to your font load­ing.

The fol­low­ing helper func­tion cre­ates timers by re­turn­ing a promise that is re­jected when the time has ex­pired.

    function timer(time) {
      return new Promise(function (resolve, reject) {
        setTimeout(reject, time);
      });
    }

By us­ing `Promise.race` we can let font load­ing and the timer “race” each other. For ex­am­ple, if the font loads be­fore the timer fires, the font has won and the promise will be re­solved. If the timer fires be­fore the font loads, the promise will be re­jected.

    var font = new FontFaceObserver('Output Sans');

    Promise.race([
      timer(1000),
      font.load()
    ]).then(function () {
      console.log('Output Sans has loaded.');
    }).catch(function () {
      console.log('Output Sans has timed out.');
    });

In this ex­am­ple a font is raced against a timer of one sec­ond. In­stead of rac­ing against a sin­gle font it is also pos­si­ble to race a timer against a group of fonts. This is a sim­ple and ef­fec­tive way to limit the amount of time it takes to load fonts.

## [](https://www.bramstein.com/writing/web-font-loading-patterns.html#prioritised-loading)Prioritised loading

Of­ten, only a hand­ful of fonts are crit­i­cal to ren­der the “above the fold” con­tent on your site. Load­ing these fonts first, be­fore other more op­tional fonts, will im­prove the per­for­mance of your site. You can do this us­ing pri­ori­tised load­ing.

    var primary = new FontFaceObserver('Primary');
    var secondary = new FontFaceObserver('Secondary');

    primary.load().then(function () {
      console.log('Primary font has loaded.')

      secondary.load().then(function () {
        console.log('Secondary font has loaded.')
      });
    });

Pri­ori­tised load­ing makes the sec­ondary font de­pen­dent on the pri­mary font. If the pri­mary font fails to load, the sec­ondary font will never load. This can be a very use­ful prop­erty.

For ex­am­ple, you could use pri­ori­tised load­ing to load a small pri­mary font with lim­ited char­ac­ter sup­port fol­lowed by a larger sec­ondary font with sup­port for more char­ac­ters or styles. Be­cause the pri­mary font is very small it will load and ren­der much faster. If the pri­mary font fails to load you prob­a­bly don’t want to try to load the sec­ondary font ei­ther, be­cause it is likely to fail as well.

This use of pri­ori­tised load­ing is de­scribed in more de­tail by Zach Leather­man in [Flash of Faux Text](http://www.zachleat.com/web/foft/) and [Web Font Anti-Pat­terns: Data URIs](http://www.zachleat.com/web/web-font-data-uris/).

## [](https://www.bramstein.com/writing/web-font-loading-patterns.html#custom-font-display)Custom font display

Be­fore a browser can show a web font it needs to be down­loaded over the net­work. This usu­ally takes a lit­tle while, and browsers be­have dif­fer­ently while they are down­load­ing web fonts. Some browsers hide text while web fonts are load­ing, while oth­ers show fall­back fonts im­me­di­ately. This is com­monly re­ferred to as the Flash Of In­vis­i­ble Text (<abbr>FOIT</abbr>) and the Flash Of Un­styled Text (<abbr>FOUT</abbr>).

![](http://ww1.sinaimg.cn/large/a490147fgw1f3aa9x12itj21540lraf4.jpg)

In­ter­net Ex­plorer and Edge use <abbr>FOUT</abbr> and show fall­back fonts un­til the web font has fin­ished down­load­ing. All other browsers use <abbr>FOIT</abbr> and hide text while web fonts are down­load­ing.

A new <abbr>CSS</abbr> prop­erty called `font-display` ([CSS Font Ren­der­ing Con­trols](https://tabatkins.github.io/specs/css-font-display/)) is meant to con­trol this be­hav­iour. Un­for­tu­nately, it is still un­der de­vel­op­ment and not yet sup­ported in any browser (it’s cur­rently be­hind a flag in Chrome and Opera). How­ever, we can im­ple­ment the same be­hav­iour in all browsers us­ing [Font Face Ob­server](https://github.com/bramstein/fontfaceobserver).

You can trick browsers that use <abbr>FOIT</abbr> into ren­der­ing fall­back fonts im­me­di­ately by only us­ing fully loaded web fonts in your font stack. If a web font is not in your font stack while it is be­ing down­loaded, those browsers will not at­tempt to hide text.

The eas­i­est way to do this is by set­ting a class on your `html` el­e­ment for each of the three load­ing state of web fonts: load­ing, loaded, and failed. The `fonts-loading` class is set as soon as font load­ing starts. The `fonts-loaded` class is added when fonts load, and the `fonts-failed` class is added when they fail to load.

    var font = new FontFaceObserver('Output Sans');
    var html = document.documentElement;

    html.classList.add('fonts-loading');

    font.load().then(function () {
      html.classList.remove('fonts-loading');
      html.classList.add('fonts-loaded');
    }).catch(function () {
      html.classList.remove('fonts-loading');
      html.classList.add('fonts-failed');
    });

Us­ing these three classes and some sim­ple <abbr>CSS</abbr> you can im­ple­ment <abbr>FOUT</abbr> that works across all browsers. We start by defin­ing fall­back fonts for all el­e­ments that will use web fonts. When the `fonts-loaded` class is pre­sent on the `html` el­e­ment we ap­ply the web font by chang­ing the font stack for those el­e­ments. This will force the browser to load the web font, but be­cause the font has al­ready loaded it will be ren­dered al­most in­stan­ta­neously.

    body {
      font-family: Verdana, sans-serif;
    }

    .fonts-loaded body {
      font-family: Output Sans, Verdana, sans-serif;
    }

Load­ing web fonts this way might re­mind you of pro­gres­sive en­hance­ment. This is not a co­in­ci­dence. The Flash Of Un­styled Text is pro­gres­sive en­hance­ment. The de­fault ex­pe­ri­ence is ren­dered us­ing fall­back fonts, and then en­hanced with web fonts.

Im­ple­ment­ing <abbr>FOIT</abbr> is equally sim­ple. When web fonts start load­ing you hide con­tent that is us­ing web fonts, and when the web fonts load you dis­play the con­tent again. Take care to also deal with fail­ure. Your con­tent should be ac­ces­si­ble even if your web fonts fail to load.

    .fonts-loading body {
      visibility: hidden;
    }

    .fonts-loaded body,
    .fonts-failed body {
      visibility: visible;
    }

Does hid­ing con­tent like this make you un­com­fort­able? Good. It should. Hid­ing con­tent should only be used in very spe­cial cir­cum­stances, for ex­am­ple if there is no good fall­back for your web font, or if you know the font is al­ready cached.

## [](https://www.bramstein.com/writing/web-font-loading-patterns.html#optimise-for-caching)Optimise for caching

The other font load­ing pat­terns let you cus­tomise when and how fonts load. Of­ten you want your code to be­have dif­fer­ently if a font is al­ready in the cache. For ex­am­ple, if a font is cached, there is no need to ren­der fall­back fonts first. We can ac­com­plish this by keep­ing track of the cache state of web fonts us­ing ses­sion stor­age.

When a font loads we set a boolean flag in the ses­sion stor­age. This flag will stored through­out a browse ses­sion, so it is a fairly good in­di­ca­tor for whether or not a file is in the browser cache.

    var font = new FontFaceObserver('Output Sans');

    font.load().then(function () {
      sessionStorage.fontsLoaded = true;
    }).catch(function () {
      sessionStorage.fontsLoaded = false;
    });

You can then use this in­for­ma­tion to change your font load­ing strat­egy when the font is cached. For ex­am­ple you can in­clude the fol­low­ing JavaScript snip­pet in the `head` el­e­ment of your page to im­me­di­ately ren­der web fonts.

    if (sessionStorage.fontsLoaded) {
      var html = document.documentElement;

      html.classList.add('fonts-loaded');
    }

If you’re load­ing fonts this way your vis­i­tors will ex­pe­ri­ence <abbr>FOUT</abbr> the first time they visit your site, but sub­se­quent pages will ren­der web fonts im­me­di­ately. This means you can have pro­gres­sive en­hance­ment and still have a good user ex­pe­ri­ence with­out dis­tract­ing your re­peat vis­i­tors.

