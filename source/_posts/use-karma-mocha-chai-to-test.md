---
title: 使用 Karma + Mocha + Chai 搭建 Web 单元测试环境
date: 2020-03-20 16:04:11
tags:
  - 单元测试
  - Karma
  - Mocha
  - Chai
categories:
  - 项目总结
---

本文属于对配置项目的总结，不会过多讲解相关知识。阅读正文之前，你需要了解并使用过 webpack、Babel，了解 ES6、CommonJS 规范，了解过前端单元测试。

<!-- more -->

## 适用场景

说明一下本文的适用场景：

1. 项目使用了 ES6 或 CommonJS 等模块化规范，需要打包编译才能在浏览器里运行。
2. 需要进行 DOM, BOM 相关的单元测试。

如果你的项目不适用于以上两点，那么没必要使用 Karma，直接使用 Jest 或 Mocha + Chai + Istanbul 组合即可。

## 为什么不用 Jest

[Jest](https://jestjs.io/) 是 Facebook 开源的测试框架，简单易用，只需少量的配置即可开始使用。它使用了 JSDOM 模拟浏览器环境来支持测试，提高了性能，但是也带来了 JSDOM 的局限性。最大的问题是：不能方便的在真实的浏览器中测试。因此难免会使得测试结果不那么准确，毕竟模拟环境无法媲美真实环境。

如果项目涉及 DOM，BOM 相关的一些测试，就不必浪费时间在 Jest 上折腾了，直接使用 Karma 手动搭建测试环境反而会更容易。

## 认识 Karma

[Karma](https://karma-runner.github.io/latest/index.html) 是一个开源的测试运行器（Test Runner），它的最大优势是：允许你在多种真实的浏览器环境中测试代码。能够和主流的测试框架（Mocha, Jasmine, QUnit）很好的结合，并且支持 webpack 和 Babel 的使用。

不过，Karma 的配置没有那么简单，其官方文档中，并没有介绍如何从 0 到 1 进行配置，因此对新手来说不够友好。

## 使用 Karma

在本文中，我们会用 NPM 来管理依赖包，所以先初始化它的配置文件 `package.json`：

```bash
$ npm init -y
```

> `-y`（`--yes`）参数表示不进行询问，直接使用默认的配置。

然后，项目级安装 Karma：

```bash
$ npm install --save-dev karma
```

为了方便使用，我们将其全局安装一下（这里也可以不全局安装，直接跳过）：

```bash
$ npm install --global karma
```

Karma 配置文件的命名规则是 `[name].conf.js`。你可以选择手动编写 Karma 的配置文件，不过更推荐使用 CLI 来自动生成：

```bash
# 如果你全局安装了 Karma，执行这个
$ karma init ./karma.conf.js

# 如果你没有全局安装 Karma，执行这个
$ ./node_modules/.bin/karma init ./karma.conf.js
```

接下来，根据一系列的提问进行选择（本文选择的内容如图所示）：

![](/assets/posts/use-karma-mocha-chai-to-test/karma-init.png)

1. 想要使用的测试框架 `mocha` 或 `jasmine`
   > 两者选其一即可，也可以指定其它的，本文以 `mocha` 为例。
2. 你的项目是否用到了 `Require.js`
   > [Require.js](http://www.requirejs.org/) 是异步加载规范（AMD）的实现。如果你不清楚，直接选 `no`。
3. 想要测试的浏览器环境
   > 可选值：`Chrome`, `ChromeHeadLess`, `ChromeCanary`, `Firefox`, `Safari`, `IE`, `Opera`, `PhantomJS`。
   > 可以指定单个或多个，本文以 `Chrome` 为例。
4. 源文件和测试文件的路径
   > 先输入源文件的路径：`src/**/*.js`（举例），回车之后，再输入测试文件的路径：`test/**/*.js`（举例）
5. 需要排除的文件
6. 是否允许 Karma 监听所有文件的变动，并在文件发生变动时，重新执行测试

根据上面选择的项，会自动生成以下内容（这里去掉了默认注释，并加上了中文注释）：

```js
// karma.conf.js

module.exports = function(config) {
  config.set({
    // 路径前缀
    basePath: '',

    // 用到的库或框架
    // 添加到这里表示注册为全局变量（不用反复在代码中 import 或 require）
    frameworks: ['mocha'],

    // 需要提供给浏览器的源文件和测试文件
    files: ['src/**/*.js', 'test/**/*.js'],

    // 需要排除的文件
    exclude: [],

    // 将文件提供给浏览器之前，进行预处理
    preprocessors: {},

    // 测试信息报告器
    reporters: ['progress'],

    // 在浏览器中运行的端口
    port: 9876,

    // 是否将输出信息彩色显示（用于 reporters 和日志信息）
    colors: true,

    // 显示日志的级别
    logLevel: config.LOG_INFO,

    // 是否监听所有文件的变动
    autoWatch: true,

    // 需要测试的浏览器环境
    browsers: ['Chrome'],

    // 如果为 true 的话，Karma 将捕获浏览器，运行测试，并自动退出
    // 使用持续集成时会用到该选项（这里先默认，后面会说明）
    singleRun: false,

    // 允许同时启动的浏览器个数，默认无限个
    concurrency: Infinity
  });
};
```

## 安装插件

初始化 Karma 的配置文件后，首先需要根据你选择的内容，安装相关插件：

1. 本文选择了 Mocha 测试框架，需要安装 `mocha` 和 `karma-mocha` 插件：

   ```bash
   $ npm install --save-dev mocha karma-mocha
   ```

   > 其中 `karma-mocha` 的作用是让 `mocha` 可以在 Karma 中工作。

2. 测试的浏览器我选择了 Chrome，需要安装 `karma-chrome-launcher` 插件：

   ```bash
   $ npm install --save-dev karma-chrome-launcher
   ```

   > 该插件用于在测试的时候，自动控制对应的浏览器，你不需要对浏览器进行任何操作，因为 Karma 仅仅是借用浏览器的环境而已。
   >
   > 如果你选择了其他浏览器，安装对应的插件即可。例如选择 FireFox，则需要安装 `karma-firefox-launcher` 插件。

这里只是安装了最基本的插件，其它插件的安装会在后面用到时说明。

为了方便读者，我为本文建了一个 Github 仓库：[
liuyib/karma-mocha-demo](https://github.com/liuyib/karma-mocha-demo)。如果某些修改的地方不太清楚，可以参考该仓库中的 commit 记录。到此为止，本文示例中所做的修改在[这里](https://github.com/liuyib/karma-mocha-demo/commit/cfb20fd3a663bfe819350895edb9944d0cceb8b8)查看。

## 编写代码

为了使本文的示例更具有参考性，这里新建两个模块 `utils.js` 和 `main.js`。

在 `src` 目录下，新建 `utils.js`，编写如下代码：

```js
// utils.js

// 一个加法函数，返回两数之和
export function add(a, b) {
  return a + b;
}
```

然后，在 `src` 目录下，新建 `main.js`，编写如下代码：

```js
// main.js

import { add } from './utils';

var main = function(selector) {
  var elem = document.querySelector(selector);

  elem.addEventListener('click', function() {
    var value = parseInt(elem.innerText, 10);
    elem.innerText = add(value, 1);
  });
};

export default main;
```

上面这段代码的作用不难看出，就是根据传入的选择器获取 DOM 元素，然后监听该元素的 `click` 事件，当用户点击时，将该元素内容 + 1（为了方便演示，假设该元素内容是数字）。

下文中我们会介绍到，如何测试“DOM 相关的操作”和“需要用户交互的逻辑”。

## 使用 Babel

由于我们的代码中用到了 ES6 语法，所以需要用 Babel 编译一下，安装 Babel 和 webpack 相关插件：

```bash
$ npm install --save-dev @babel/core @babel/preset-env babel-loader webpack
```

> 这里安装的依赖版本分别为 `babel 7.x` | `babel-loader 8.x` | `webpack 4.x`
>
> 详见：https://github.com/babel/babel-loader#install

- `@babel/core`（旧版名称 `babel-core`，已废弃，不推荐）：是 Babel 语法分析的核心，很多 Babel 插件依赖于它。
- `@babel/preset-env`（旧版名称 `babel-preset-env`，已废弃，不推荐）：会检测你的配置或运行环境，将代码编译到合适版本。
- `babel-loader`：允许你使用 Babel 和 webpack 转译 JavaScript 文件。
- `webpack`：负责打包编译。

> 如果使用 CommonJS 规范，并且想要运行在浏览器中，那么也需要使用 Babel 编译。

## 配置 webpack

首先，我们需要安装 `karma-webpack` 插件：

```bash
$ npm install --save-dev karma-webpack
```

> 该插件的作用是让 `webpack` 可以在 Karma 中工作。

然后，参照该插件的[文档](https://github.com/webpack-contrib/karma-webpack)进行配置，修改 `karma.conf.js` 文件：

```js
...
preprocessors: {
  // 匹配源文件，并使用 webpack 进行预处理
  'src/**/*.js': ['webpack'],
  // 匹配测试文件，并使用 webpack 进行预处理
  'test/**/*.js': ['webpack']
},
...
```

上面的配置作用是：在文件提供给浏览器运行之前，使用 webpack 进行预处理。当然你可以继续添加其它插件来处理文件，用法同上，即：`['插件名称', '插件名称', ...]`。

接下来，你需要自己配置 webpack，在 `karma.conf.js` 文件里添加 `webpack: {}` 配置项，然后参照 webpack [文档](https://webpack.js.org/concepts/)进行配置，下面是一些配置示例。

如果你的项目只需要把 ES6+ 语法编译到 ES5，那么只进行下面的配置即可，修改 `karma.conf.js` 文件：

```js
...
webpack: {
  mode: 'development',
  module: {
    rules: [
      {
        // 匹配 JavaScript 文件
        test: /\.js$/,
        // 排除 node_modules 和 bower_components 目录
        exclude: /(node_modules|bower_components)/,
        use: {
          // 使用的 loader
          loader: 'babel-loader',
          // 传递给 babel-loader 的参数
          options: {
            presets: ['@babel/preset-env']
          }
        }
      }
    ]
  }
},
...
```

其中，传递给 `babel-loader` 的参数，更**推荐**写入 `.babelrc` 文件中：

```js
// .babelrc
{
  "presets": ["@babel/preset-env"]
}
```

对于本文的示例代码来说，只需要将 ES6+ 语法编译到 ES5，上面的配置足够使用。因此，如果你需要更复杂的配置，请自行查看 webpack 的文档。

> 到此为止，读者可以访问[这里](https://github.com/liuyib/karma-mocha-demo/commit/fc4c77e421c9ae297c604418bfb1697c94b12817)，查看所做的修改。

## 启动 Karma

在 `package.json` 中添加一条 NPM 指令：

```json
...
"script": {
  "test": "karma start ./karma.conf.js"
},
...
```

然后在命令行中执行 `npm run test`，如果控制台中没有报错信息，并且Karma 自动打开了你选择的浏览器，证明你的上述配置没有问题。否则，你需要检查之前的配置是否正确。

## 编写测试代码

首先，安装断言库 `chai` 和 `karma-chai`：

```bash
$ npm install --save-dev chai karma-chai
```

> 其中 `karma-chai` 的作用是让 `chai` 可以在 Karma 中工作。

然后全局引入 Chai，修改 `karma.conf.js` 文件：

```js
...
frameworks: ['mocha', 'chai'],
...
```

你也可以不全局引入，那么你必须在文件中，手动进行 `import` 或 `require`：

```js
import { expect } form 'chai';         // ES6
// 或
const expect = require('chai').expect; // CommonJS
```

通常，测试文件与所要测试的源文件同名，但是后缀名为 `.test.js`（表示测试）或 `.spec.js`（表示规格）。

接下来，我们开始编写测试代码。首先来测试 `utils` 模块，在 `test` 目录下，新建 `utils.test.js`：

```js
// utils.test.js

import { add } from '../src/utils';

describe('utils::add test', function() {
  it('should 3 when add(1, 2) return', function() {
    expect(add(1, 2)).to.equal(3);
  });
});
```

上述代码中：

- `describe` 块称为“测试套件（test suite）”，表示一组相关的测试。它是一个函数，第一个参数是测试套件的名称，第二个参数是一个实际执行的函数。

- `it` 块称为“测试用例（test case）”，表示一个单独的测试，是测试的最小单位。它也是一个函数，第一个参数是测试用例的名称，第二个参数是一个实际执行的函数。

本文使用了 expect 风格的断言，其特点是更接近自然语言。例如上面的代码中：`expect(add(1, 2)).to.equal(3)`，意思是“期望 `add(1, 2)` 等于 `3`”。如果这个断言为真，则对应测试用例通过，否则不通过。

然后，再来测试 `main` 模块，在 `test` 目录下，新建 `main.test.js`：

```js
// main.test.js

import main from '../src/main';

describe('main::DOM test', function() {
  // 钩子函数
  beforeEach(function() {
    // 向页面的 body 元素中添加 DOM 元素，来辅助测试
    document.body.innerHTML = '<button id="btn">0</button>';

    main('#btn');
  });

  it('should 1 when button is clicked once', function() {
    // 获取前面添加的元素
    var btn = document.querySelector('#btn');
    // 模拟用户点击
    btn.click();

    expect(btn.innerText).to.equal('1');
  });
});
```

> 上述代码中，`beforeEach` 是 Mocha 提供的钩子函数，作用是：在每个测试用例（`it` 块）执行之前，都会执行一次。
>
> 类似的 Mocha 提供的钩子函数总共有四个：`before`, `after`, `beforeEach`, `afterEach`。它们的具体作用这里不再介绍。

如果想要测试 DOM 相关的操作，我们需要在测试之前，向页面中添加需要用到的元素，例如上述示例代码中的 `document.body.innerHTML = '<button id="btn">0</button>';`。

接着，我们在测试用例（`it` 块）中，获取了提前添加好的 DOM 元素，然后通过 `btn.click();` 来主动触发该元素的点击事件，从而模拟了用户操作。

最后，进行断言来完成测试：`expect(btn.innerText).to.equal('1');`。

> 到此为止，读者可以访问[这里](https://github.com/liuyib/karma-mocha-demo/commit/69748d28ac7cf17b6ac761fb3629055aa88590f2)，查看所做的修改。

## 汇报测试结果

编写完测试代码后，执行测试指令 `npm run test`，Karma 会使用默认的报告器来汇报测试结果，如图所示：

![](/assets/posts/use-karma-mocha-chai-to-test/karma-default-reporter.png)

{% note success %}
如果你想使用默认的报告器，请直接跳过下面这段。
{% endnote %}

这里列举几个常用的报告器插件：

- [karma-spec-reporter](https://github.com/mlex/karma-spec-reporter)
- [karma-mocha-reporter](https://github.com/litixsoft/karma-mocha-reporter)
- [karma-nyan-reporter](https://github.com/dgarlitt/karma-nyan-reporter)

> 查看更多报告器插件请访问：[https://npmjs.org/browse/keyword/karma-reporter](https://npmjs.org/browse/keyword/karma-reporter)

> 注意，这些插件的文档中指出了 `karma.conf.js` 中的 `plugins` 配置项。一般情况下，以 `karma-` 开头命名的插件，会自动被 Karma 引入，所以一般你不需要指定 `plugins` 配置项。但要知道，一旦你设置了 `plugins` 配置项，就必须引入**所有**以 `karma-` 开头的插件，否则请直接留空。

本文以 `karma-spec-reporter` 作为示例，首先安装插件：

```bash
$ npm install --save-dev karma-spec-reporter
```

配置也很简单，只需要修改 `karma.conf.js` 文件：

```js
...
reporters: ['spec'],
...
```

然后执行 `npm run test`，控制台会输出 “哪些测试用例通过了，哪些没通过”，如图所示：

![](/assets/posts/use-karma-mocha-chai-to-test/karma-spec-reporter.png)

> 到此为止，读者可以访问[这里](https://github.com/liuyib/karma-mocha-demo/commit/5db1630e08f9bfb73b781ee410e5acedda2ac6e8)，查看所做的修改。

## 生成覆盖率报告

这里列举两个常用的生成覆盖率的插件：

- [karma-coverage](https://github.com/karma-runner/karma-coverage)
- [karma-coverage-istanbul-reporter](https://github.com/mattlewis92/karma-coverage-istanbul-reporter)

其中 `karma-coverage` 是官方的插件，而 `karma-coverage-istanbul-reporter` 基于它进行了一些改进。在我使用的过程中，体验到它俩最大的不同是：生成 `text` 和 `text-summary` 类型的报告方式不同。前者会将这两种类型的报告生成到文件中，而后者会将这两种类型的报告生成到控制台中。本文以 `karma-coverage` 作为举例。

首先，安装 `karma-coverage` 插件：

```bash
$ npm install --save-dev karma-coverage
```

然后，参照该插件的[文档](https://github.com/karma-runner/karma-coverage)进行配置，修改 `karma.conf.js` 文件：

```js
...
preprocessors: {
  'src/**/*.js': ['webpack', 'coverage'],
  'test/**/*.js': ['webpack']
},

reporters: ['spec', 'coverage'],

coverageReporter: {
  // 生成报告的目录
  dir: 'coverage/',
  // 要生成的报告类型
  reporters: [
    { type: 'lcov', subdir: '.' },
    { type: 'text', subdir: '.', file: 'text.txt' },
    { type: 'text-summary', subdir: '.', file: 'text-summary.txt' }
  ]
},
...
```

执行测试指令 `npm run test`，会生成 `coverage` 目录，并在该目录下生成覆盖率报告。

> 这里需要介绍一下几种常用的报告类型：
>
> - `html` 报告类型
>   这是给人看的覆盖率报告。默认会生成一个 `lcov-report` 文件夹。
> - `lcovonly` 报告类型
>   这是给 CI 用的，默认生成的文件名为 `lcov.info`。
> - `lcov` 报告类型
>   该报告类型 == `html` 报告类型 + `lcovonly` 报告类型
> - `text-summary` 报告类型（效果如下）
>   ```
>   =============================== Coverage summary ===============================
>   Statements   : 54.02% ( 47/87 )
>   Branches     : 19.23% ( 10/52 )
>   Functions    : 56.52% ( 13/23 )
>   Lines        : 61.64% ( 45/73 )
>   ================================================================================
>   ```
> - `text` 报告类型（效果如下）
>   ```
>   ----------|----------|----------|----------|----------|-------------------|
>   File      |  % Stmts | % Branch |  % Funcs |  % Lines | Uncovered Line #s |
>   ----------|----------|----------|----------|----------|-------------------|
>   All files |    54.02 |    19.23 |    56.52 |    61.64 |                   |
>    main.js  |    54.55 |    19.23 |    58.33 |    62.16 |... 69,70,71,72,73 |
>    utils.js |    53.49 |    19.23 |    54.55 |    61.11 |... 69,70,71,72,73 |
>   ----------|----------|----------|----------|----------|-------------------|
>   ```
> 一般情况下，常用的报告类型就是 `lcov`, `text`, `text-summary` 这三种。你可以访问[这里](https://istanbul.js.org/docs/advanced/alternative-reporters/)，查看所有报告类型的格式和作用。

找到 `coverage/lcov-report` 目录中的 `index.html` 文件，将其在浏览器中运行，可以查看到详细的覆盖率报告信息，如图所示：

![](/assets/posts/use-karma-mocha-chai-to-test/coverage-in-browser-1.png)

> 到此为止，读者可以访问[这里](https://github.com/liuyib/karma-mocha-demo/commit/0b70ec801aabdfd60ddd4e5c0b17e089c51872bd)，查看所做的修改。

本文的示例代码中，理论上测试覆盖率应该是 100%，但是实际并没有这么多。而且，细心的话可以发现，代码的总行数也变多了，这是因为 webpack 会在编译之后加入一些代码，影响了覆盖率。为了解决这个问题，有两个插件可供选择：

- [babel-plugin-istanbul](https://github.com/istanbuljs/babel-plugin-istanbul)
- [istanbul-instrumenter-loader](https://github.com/webpack-contrib/istanbul-instrumenter-loader)

如果你的项目只使用了 Babel，没有使用 webpack，那么你只能使用 `babel-plugin-istanbul` 来解决这个问题。如果你的项目使用了 webpack，那么两个插件可以任选其一来使用。

由于本文示例中用到了 webpack，所以这两个插件可以任选其一，我们以 `babel-plugin-istanbul` 为例：

首先，安装该插件：

```bash
$ npm install --save-dev babel-plugin-istanbul
```

然后，参照其文档进行配置，修改 `karma.conf.js` 文件：

```diff
...
webpack: {
  mode: 'development',
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /(node_modules|bower_components)/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['@babel/preset-env'],
+           plugins: ['istanbul']
          }
        }
      }
    ]
  }
},
...
```

如果将该配置放入 `.babelrc` 文件，则如下所示：

```diff
// .babelrc
{
  "presets": ["@babel/preset-env"],
+ "plugins": ["istanbul"]
}
```

再次执行测试指令 `npm run test`，即可得到 100% 的覆盖率，如图所示：

![](/assets/posts/use-karma-mocha-chai-to-test/coverage-in-browser-2.png)

> 如果你使用 `karma-coverage-istanbul-reporter` 插件来生成覆盖率，可能会遇到覆盖率信息全为 `0` 或 `Unknown` 的情况。这个问题和上述覆盖率统计不正确类似，都是由于插件默认无法统计 ES6+ 代码引起的。你只需要按照上文中的说明，使用 `babel-plugin-istanbul` 或 `istanbul-instrumenter-loader` 插件即可解决此类问题。

> 到此为止，读者可以访问[这里](https://github.com/liuyib/karma-mocha-demo/commit/8ec8303fd703a9681ca6b3f96ff1bab5a3ba8495)，查看所做的修改。

## 持续集成

常用的持续集成工具有 [Travis CI](https://travis-ci.com/) 和 [CircleCI](https://circleci.com/)。本文以 Travis CI 作为举例。

### 配置 Travis CI

由于 Travis CI 是在命令行中运行，因此跑不了 GUI 程序。如果要在 Travis CI 中运行需要 GUI 的测试，则要用到 `xvfb`（X Virtual Framebuffer）来模拟显示。详见：[Using xvfb to Run Tests That Require a GUI](https://docs.travis-ci.com/user/gui-and-headless-browsers/#using-xvfb-to-run-tests-that-require-a-gui)。

新建 Travis CI 的配置文件 `.travis.yml`，并编写以下内容：

```yaml
language: node_js

node_js:
  - 10

# 使用 xvfb 来模拟显示 GUI
services:
  - xvfb

# 指定要使用的浏览器以及版本
addons:
  chrome: stable

script:
  - npm run test

after_script:
  - npm run codecov
```

除了配置 Travis CI 外，我们还需要配置 Krama，修改 `karma.conf.js` 文件：

> 如果你不准备使用 CI，请忽略该配置，默认即可。

```js
...
// 如果设为 true 的话，Karma 将捕获浏览器，运行测试，并自动退出
// process.env.CI 是环境变量，在 CI 中值为 true，否则值为 false
singleRun: !!process.env.CI,
...
```

该配置项默认为 `false`，会使得 Karma 在测试结束后仍然监听文件变化，不会退出测试，但是在 CI 中必须在测试结束后退出测试，否则 CI 将会一直等待，直到超时。


### 上传覆盖率

生成了覆盖率，配置了 CI，最后还需要做的是，将覆盖率上传到 [Coveralls](https://coveralls.io/) 或 [Codecov](https://codecov.io/) 中进行分析。本文以 Codecov 为例。

首先，安装 `codecov` 插件：

```bash
$ npm install --save-dev codecov
```

然后，参照该插件的[文档](https://github.com/codecov/codecov-node)进行配置，添加一个 NPM 指令，修改 `package.json` 文件：

```diff
...
"script": {
  "test": "karma start ./karma.conf.js",
+ "codecov": "./node_modules/.bin/codecov"
},
...
```

该指令的作用是：读取 `coverage` 目录中的 `lcov.info` 文件，然后上传到 Codecov 网站。

> 在上传覆盖率之前，你最好确认一下当你执行 `npm run test` 指令后，可以在 `coverage` 目录中生成 `lcov.info` 文件。

> 到此为止，读者可以访问[这里](https://github.com/liuyib/karma-mocha-demo/commit/cef265c71b6d0c002cd83863d53a434d8a0e01fe)，查看所做的修改。

### 展示徽章

最后，我们把测试的结果，以 Travis CI 和 Codecov 徽章的形式放入 README。例如，本文配套的 Github 仓库 [karma-mocha-demo](https://github.com/liuyib/karma-mocha-demo) 的测试结果：

[![Travis CI](https://img.shields.io/travis/liuyib/karma-mocha-demo.svg)](https://travis-ci.com/github/liuyib/karma-mocha-demo)
[![Codecov](https://img.shields.io/codecov/c/github/liuyib/karma-mocha-demo.svg)](https://codecov.io/gh/liuyib/karma-mocha-demo)

对应代码如下：

```md
[![Travis CI](https://img.shields.io/travis/liuyib/karma-mocha-demo.svg)](https://travis-ci.com/github/liuyib/karma-mocha-demo)
[![Codecov](https://img.shields.io/codecov/c/github/liuyib/karma-mocha-demo.svg)](https://codecov.io/gh/liuyib/karma-mocha-demo)
```

将其中的用户名（`liuyib`）和仓库名（`karma-mocha-demo`）换成你的即可。

---

参考链接：

- [搭建 Karma+Mocha+Chai 测试 TypeScript 项目](https://blog.crimx.com/2019/06/19/%E6%90%AD%E5%BB%BA-karma-mocha-chai-%E6%B5%8B%E8%AF%95-typescript-%E9%A1%B9%E7%9B%AE/)
- [测试框架 Mocha 实例教程](http://www.ruanyifeng.com/blog/2015/12/a-mocha-tutorial-of-examples.html)
- [学习 Karma+Jasmine+istanbul+webpack 自动化单元测试](https://www.cnblogs.com/tugenhua0707/p/8433847.html)
- [使用 Karma + Jasmine 构建 Web 测试环境](https://www.ibm.com/developerworks/cn/web/wa-lo-use-karma-jasmine-build-test-environment/index.html)
- [Travis CI XVFB Breaking Change](https://benlimmer.com/2019/01/14/travis-ci-xvfb/)
