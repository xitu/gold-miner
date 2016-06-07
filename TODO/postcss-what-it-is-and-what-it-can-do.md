>* 原文链接 : [PostCSS – What It Is And What It Can Do](https://web-design-weekly.com/2016/06/04/postcss-what-it-is-and-what-it-can-do/)
* 原文作者 : Jake Bresnehan
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


[PostCSS](http://postcss.org) has been around since September 2013 and has been part of many developers workflow for a while. For those that haven’t had the time to dig into it and put some time aside to understand what it is and what it can do, this post is for you.

> PostCSS is a tool for transforming CSS with JavaScript.

PostCSS itself is very small. It only includes a CSS parser, a CSS node tree API, a source map generator and a node tree stringifier. All the magic happens by the plugins.

At the time of writing the PostCSS ecosystem has over 100 [plugins](http://postcss.parts/ "PostCSS Plugins"). These plugins can do a large array of things, from linting, adding vendor prefixes, enabling the use of the latest CSS syntax, providing statistics on your CSS or giving you the power to use a preprocessors like Sass, Less or Stylus.

### 10 Plugins To Look Into

[Autoprefixer](https://github.com/postcss/autoprefixer "Autoprefixer")

> Parse CSS and add vendor prefixes to CSS rules using values from Can I Use data.

[PostCSS Focus](https://github.com/postcss/postcss-focus "PostCSS Focus")

> PostCSS plugin to add `:focus` selector to every `:hover` for keyboard accessibility.

[PreCSS](https://github.com/jonathantneal/precss "PreCSS")

> A plugin that allows you to use Sass-like markup in your CSS files.

[Stylelint](https://github.com/stylelint/stylelint "Stylelint")

> A mighty, modern CSS linter that helps you enforce consistent conventions and avoid errors in your stylesheets.

[PostCSS CSS Variables](https://github.com/MadLittleMods/postcss-css-variables "PostCSS CSS Vatiables")

> A plugin to transform CSS Custom Properties(CSS variables) syntax into a static representation.

[PostCSS Flexbugs Fixes](https://github.com/luisrudge/postcss-flexbugs-fixes "PostCSS Flexbug FIxes")

> A PostCSS plugin that tries to fix all of flexbug’s issues.

[PostCSS CSSnext](https://github.com/MoOx/postcss-cssnext "PostCSS CSSnext")

> A plugin that helps you to use the latest CSS syntax today. It transforms CSS specs into more compatible CSS so you don’t need to wait for browser support.

[PostCSS CSS Stats](https://github.com/cssstats/postcss-cssstats "PostCSS CSSStats")

> A PostCSS plugin for [cssstats](https://github.com/cssstats/cssstats "CSS Stats"). The plugin returns a cssstats object in the callback which can be used for css analysis.

[PostCSS SVGO](https://github.com/ben-eb/postcss-svgo "PostCSS SVGO")

> Optimise inline SVG with PostCSS.

[PostCSS Style Guide](https://github.com/morishitter/postcss-style-guide "PostCSS Style Guide")

> A PostCSS plugin to generate a style guide automatically. CSS comments will be parsed through Markdown and displayed in a generated HTML document.

If you feel like creating your own plugin and contributing back to the PostCSS community, be sure to have a look at these [guidelines](https://github.com/postcss/postcss/blob/master/docs/guidelines/plugin.md "PostCSS Guidelines") and the offical [PostCSS Plugin Boilerplate](https://github.com/postcss/postcss-plugin-boilerplate "PostCSS Boilerplate").

### Intergrating PostCSS Into Your Workflow

PostCSS is written in JavaScript which makes it quite straight forward to add it to common front-end build tools like [Grunt](http://gruntjs.com/), [Gulp](http://gulpjs.com/) or [Webpack](https://webpack.github.io/).

For the examples below we are going to use the [Autoprefixer](https://github.com/postcss/autoprefixer "Autoprefixer") plugin.

`npm install autoprefixer --save-dev`

**Gulp**  
If you are using Gulp you will also need to install the [gulp-postcss](https://github.com/postcss/gulp-postcss) package.

`npm install --save-dev gulp-postcss`

    gulp.task('autoprefixer', function () {
        var postcss      = require('gulp-postcss');
        var autoprefixer = require('autoprefixer');

        return gulp.src('./src/*.css')
        .pipe(postcss([ autoprefixer({ browsers: ['last 2 versions'] }) ]))
        .pipe(gulp.dest('./dest'));
    });

**Grunt**  
If you are using Grunt you will also need to install the [grunt-postcss](https://github.com/nDmitry/grunt-postcss) package.

`npm install grunt-postcss --save-dev`

    module.exports = function(grunt) {
        grunt.loadNpmTasks('grunt-postcss');

        grunt.initConfig({
            postcss: {
                options: {
                        map: true,
                    processors: [
                        require('autoprefixer')({
                            browsers: ['last 2 versions']
                        })
                    ]
                },
                dist: {
                    src: 'css/*.css'
                }
            }
        });

        grunt.registerTask('default', ['postcss:dist']);

    };

**Webpack**  
If you are using Webpack you will also need to install the [postcss-loader](https://github.com/postcss/postcss-loader) package.

`npm install postcss-loader --save-dev`

    var autoprefixer = require('autoprefixer');

    module.exports = {
        module: {
            loaders: [
                {
                    test:   /\.css$/,
                    loader: "style-loader!css-loader!postcss-loader"
                }
            ]
        },
        postcss: function () {
            return [autoprefixer];
        }
    }

Further reading about integrating can be found on the [PostCSS repo](https://github.com/postcss/postcss#usage).

### Taking The Leap

Sometimes when new technology, new tools and new frameworks get released it is often wise to just observe and see how they evolve. Now that PostCSS has matured and proven its value I would highly recommend taking the leap and making it part of your workflow. It has been around for a while and won’t be going anywhere soon.

