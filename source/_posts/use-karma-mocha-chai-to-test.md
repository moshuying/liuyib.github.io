---
title: 使用 Karma + Mocha 构建单元测试环境
date: 2020-03-20 16:04:11
tags:
  - 单元测试
  - Mocha
  - Karma
categories:
  - 项目配置
---

本文是对项目配置的总结，不会过多讲解相关知识。阅读正文之前，你需要了解并使用过 webpack、Babel，了解 ES6、CommonJS 规范，了解过前端单元测试，否则部分内容阅读起来可能较为吃力，不过我会尽量给与合理的解释。

<!-- more -->

## 适用场景

首先说明一下本文的适用场景：

1. 项目使用了 ES6 或 CommonJS 等模块化规范，需要打包编译才能在浏览器里运行。
2. 需要进行 DOM, BOM 相关的单元测试。

如果你的项目符合以上的要求，那么本文可以带你 从 0 到 1 搭建好 Web 单元测试环境。

> 不过建议读者新建一个 Demo 项目，跟着本文配置成功之后，再应用到实际项目中。

如果你的项目不需要打包编译，并且只需要进行逻辑相关的单元测试，不涉及 DOM, BOM。那么没必要使用 Karma

## 测试框架对比

TODO

## 为什么不用 Jest

TODO

## 认识 Karma

TODO

## 使用 Karma

首先，安装 Karma：

```bash
$ npm install --save-dev karma
```

然后，使用 `cli` 初始化 Karma 的配置：

```bash
# karma 配置文件命名规则 [name].conf.js
$ karma init ./karma.conf.js
```

接下来，根据提示进行选择：

![](/assets/posts/use-karma-mocha-chai-to-test/karma-init.png)

1. 想要使用的测试框架 `mocha` 或 `jasmine`
   > 两者选其一即可，本文以 `mocha` 为例。
2. 你的项目是否用到了 `require.js`
   > 如果你不清楚，直接选 `no`。
3. 想要测试的浏览器环境
   > 可选值：`Chrome`, `ChromeHeadLess`, `ChromeCanary`, `Firefox`, `Safari`, `IE`, `Opera`, `PhantomJS`。
   > 可以指定单个或多个，本文以 `Chrome` 为例。
4. 源文件和测试文件的路径
   > 先输入源文件的路径：`src/**/*.js`（举例），回车之后，再输入测试文件的路径：`test/**/*.js`（举例）
5. 需要排除的文件
6. 是否允许 Karma 监听所有文件的变动，并在文件发生变动时，重新执行测试

根据上面选择的项，会生成以下内容（这里去掉了默认注释，并加上了中文注释）：

```js
// karma.conf.js
module.exports = function(config) {
  config.set({
    // 路径前缀
    basePath: "",

    // 用到的库或框架
    // 添加到这里表示注册为全局变量（不用反复在代码中 import 或 require）
    frameworks: ["mocha"],

    // 需要提供给浏览器的源文件和测试文件
    files: ["src/**/*.js", "test/**/*.js"],

    // 需要排除的文件
    exclude: [],

    // 将文件提供给浏览器之前，进行预处理
    preprocessors: {},

    // 信息报告器
    reporters: ["progress"],

    // 在浏览器中运行的端口
    port: 9876,

    // 是否将输出信息彩色显示（用于 reporters 和日志信息）
    colors: true,

    // 显示日志的级别
    logLevel: config.LOG_INFO,

    // 是否监听所有文件的变动
    autoWatch: true,

    // 需要测试的浏览器环境
    browsers: ["Chrome"],

    // 如果为 true 的话，Karma 将捕获浏览器，运行测试，并自动退出
    // 使用持续集成时会用到该选项（这里先默认，后面会说明）
    singleRun: false,

    // 允许同时启动的浏览器个数，默认无限个
    concurrency: Infinity
  });
};
```

## 安装插件

根据初始化 Karma 配置时选择的内容，安装相关插件。

1. 本文选择了 Mocha 测试框架，需要安装 `mocha` 和 `karma-mocha` 插件：

   ```bash
   $ npm install --save-dev mocha karma-mocha
   ```

   > 其中 `karma-mocha` 的作用是让 `mocha` 可以在 Karma 中工作。

2. 测试的浏览器我选择了 Chrome，需要安装 `karma-chrome-launcher` 插件：

   ```bash
   $ npm install --save-dev karma-chrome-launcher
   ```

   > 该插件用于在测试的时候，自动打开对应浏览器，你不需要对浏览器进行任何操作，因为 Karma 仅仅是借用浏览器的环境而已。
   >
   > 当然如果你选择了其他浏览器，安装对应的插件即可。例如选择 FireFox，则需要安装 `karma-firefox-launcher` 插件。

## 编写代码

在 `src` 目录下，新建 `add.js`，编写如下代码：

```js
export function add(a, b) {
  return a + b;
}
```

## 使用 Babel

由于我们用到了 ES6 语法，所以需要用 Babel 编译一下，安装 Babel 和 webpack 相关插件：

```bash
$ npm install --save-dev @babel/core @babel/preset-env babel-loader webpack
```

> 这里安装的版本分别为 babel 7.x | babel-loader 8.x | webpack 4.x
>
> 详见：https://github.com/babel/babel-loader#install

- `@babel/core`（旧版名称 `babel-core`，已废弃，不推荐）：是 Babel 语法分析的核心，很多 Babel 插件依赖于它。
- `@babel/preset-env`（旧版名称 `babel-preset-env`，已废弃，不推荐）：会检测你的配置或运行环境，将代码编译到合适版本。
- `babel-loader`：允许你使用 Babel 和 webpack 转译 JavaScript 文件。
- `webpack`：负责打包编译。

## 配置 webpack

首先，我们需要安装 karma-webpack：

```bash
$ npm install --save-dev webpack karma-webpack
```

> 该插件的作用是让 webpack 可以在 Karma 中工作。

然后按照 karma-webpack 的[文档](https://github.com/webpack-contrib/karma-webpack)进行配置，修改 `preprocessors` 配置项：

```js
...
preprocessors: {
  // 匹配源文件，并使用 webpack 进行预处理
  'src/**/*.js': ['webpack'],
  // 匹配测试文件，并使用 webpack 进行预处理
  'test/**/*.js': ['webpack']
}
...
```

该配置的作用是在文件运行之前使用 webpack 进行预处理。当然你可以继续添加其它插件来处理文件，用法同上，即：`['插件名称', '插件名称', ...]`。

接下来，你需要自己配置 webpack，在 `karma.conf.js` 里添加 `webpack: {}` 配置项，然后参照 webpack [文档](https://webpack.js.org/concepts/)进行配置，下面是一些配置示例。

如果你只需要把 ES6+ 语法编译到 ES5，那么只需要进行下面的配置即可：

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
          // 传递给 loader 的参数
          options: {
            presets: ['@babel/preset-env']
          }
        }
      }
    ]
  }
}
...
```

你可以[点击这里](TODO)，查看修改了哪些代码 。

## 启动 Karma

在 `package.json` 中添加一条 npm 指令：

```json
...
script: {
  "test": "karma start ./karma.conf.js"
}
...
```

然后在命令行中执行 `npm run test`，如果控制台中没有报错信息，并且程序自动打开了你选择的浏览器，证明以上配置没有问题。否则，你需要检查你的上述配置是否正确。

## 编写测试代码

我们首先全局引入断言库 [Chai](https://www.chaijs.com/)，修改 `karma.conf.js`：

```js
...
frameworks: ['mocha', 'chai'];
...
```

你也可以不全局引入，那么你必须在文件中，手动进行 `import` 或 `require`：

```js
import { expect } form 'chai';         // ES6
// 或
const expect = require('chai').expect; // CommonJS
```

在 `test` 目录下，新建 `add.test.js`，然后编写测试代码：

```js
import { add } from "../src/add";

describe("add.js", function() {
  it("add(1, 2) should number 3", function() {
    expect(add(1, 2)).to.equal(3);
  });
});
```

其中，`describe` 块称为“测试套件（test suite）”，表示一组相关的测试。它是一个函数，第一个参数是测试套件的名称，第二个参数是一个实际执行的函数。

`it` 块称为“测试用例（test case）”，表示一个单独的测试，是测试的最小单位。它也是一个函数，第一个参数是测试用例的名称，第二个参数是一个实际执行的函数。

本文使用了 expect 风格的断言，其特点是更接近自然语言。比如上面的示例中：`expect(add(1, 2)).to.equal(3)`，意思是“期望 `add(1, 2)` 等于 `3`”。如果这个断言为真，则对应测试用例通过，否则不通过。

## 汇报测试结果

写好了测试代码，如果直接执行 `npm run test`，控制台是不会输出测试结果的，因此我们需要一个报告器（reporter）来将测试结果输出到控制台，以便我们查看。

这里列举几个常用的报告器插件：

- [karma-spec-reporter](https://github.com/mlex/karma-spec-reporter)
- [karma-mocha-reporter](https://github.com/litixsoft/karma-mocha-reporter)
- [karma-nyan-reporter](https://github.com/dgarlitt/karma-nyan-reporter)

> 查看更多报告器插件请访问：[https://npmjs.org/browse/keyword/karma-reporter](https://npmjs.org/browse/keyword/karma-reporter)

> 注意，这些插件的文档中指出了 `karma.conf.js` 中的 `plugins` 配置项。一般情况下，以 `karma-` 开头命名的插件，会自动被 Karma 引入，所以一般你不需要指定 `plugins` 配置项。但要知道，一旦你设置了 `plugins` 配置项，就必须引入**所有**以 `karma-` 开头的插件，否则请直接留空。

安装，这里以 `karma-spec-reporter` 作为示例：

```bash
$ npm install --save-dev karma-spec-reporter
```

配置也很简单，只需要修改 `karma.conf.js`：

```js
...
reporters: ['spec'];
...
```

> 这里只是演示了最基本的配置，更详细的配置，请自行阅读插件文档。

然后执行 `npm run test`，控制台会输出 “哪些测试用例通过了，哪些没通过”。例如使用 `karma-spec-reporter` 的输出结果：

![](/assets/posts/use-karma-mocha-chai-to-test/test-info-cli.png)

## 生成覆盖率报告

这里列举几个常用的生成覆盖率的插件：

- [karma-coverage](https://github.com/karma-runner/karma-coverage)
- [karma-coverage-istanbul-reporter](https://github.com/mattlewis92/karma-coverage-istanbul-reporter)

其中 `karma-coverage` 是官方的。尝试并比较过之后，个人觉着 `karma-coverage-istanbul-reporter` 更好用一些，这里就用后者作为演示。

首先，安装该插件：

```bash
$ npm install --save-dev karma-coverage-istanbul-reporter
```

> 这里不需要安装 istanbul，因为该插件已将 istanbul 作为生产依赖（`dependencies`）。

然后，参考该插件[文档](https://github.com/mattlewis92/karma-coverage-istanbul-reporter/blob/master/README.md)，修改 `karma.conf.js`：

```js
...
reporters: ['spec', 'coverage-istanbul'],

coverageIstanbulReporter: {
  // 要生成的报告类型
  reports: ['lcov', 'text', 'text-summary']
}
...
```

> 这里只是演示了最基本的配置，更详细的配置，请自行阅读插件文档。

> 几种常用的报告类型：
>
> - `html`
>   > 这是给人看的覆盖率报告。默认会生成一个 `lcov-report` 文件夹，在浏览器里运行其中的 `index.html` 文件，即可查看到结果。
> - `lcovonly`
>   > 这是给 `CI` 用的，默认生成的文件名为 `lcov.info`。
> - `lcov`
>   > 该报告类型 == `html` 报告类型 + `lcovonly` 报告类型
> - `text` 和 `text-summary` 报告类型的效果如下（显示在控制台中）：
>   ![](/assets/posts/use-karma-mocha-chai-to-test/coverage-in-cli.png)
>   如果是 karma-coverage 插件，则会将 `text` 和 `text-summary` 类型的报告生成到文件中。
>
> 你可以访问 [https://istanbul.js.org/docs/advanced/alternative-reporters/](https://istanbul.js.org/docs/advanced/alternative-reporters/)，查看所有报告类型的格式和作用。

然后执行 `npm run test`，可以发现在 `coverage` 目录中生成了覆盖率报告的相关文件。找到其中 `lcov-report` 目录下的 `index.html` 文件，然后在浏览器里运行，就可以看到覆盖率相关信息了。如图所示：

![](/assets/posts/use-karma-mocha-chai-to-test/coverage-in-browser-1.png)

> 记得把 `coverage` 目录加入 `.gitignore` 中，防止提交到远程仓库。

可以看到覆盖率不是 100%（我们在 `add.test.js` 中写的测试用例，理论上是 100% 覆盖率），并且我们只写了几行代码，却显示有几十行，这是因为 webpack 会在打包之后加入一些代码，影响了覆盖率。因此我们需要通过插件 [istanbul-instrumenter-loader](https://github.com/webpack-contrib/istanbul-instrumenter-loader) 来解决这个问题。

首先，安装该插件：

```bash
$ npm install --save-dev istanbul-instrumenter-loader
```

然后按照该插件的[文档](https://github.com/webpack-contrib/istanbul-instrumenter-loader/blob/master/README.md)，修改 `karma.conf.js`：

```js
var path = require('path');

...
webpack: {
  module: {
    rules: [
      {
        test: /\.js$/,
        include: path.resolve('src/'),
        use: {
          loader: 'istanbul-instrumenter-loader',
          options: {
            // 如果使用了 Babel，需要加上这个
            esModules: true
          }
        },
        // 如果使用了 Babel，需要加上这个
        enforce: 'post'
      }
    ];
  }
}
...
```

然后执行 `npm run test` 指令，可以看到得到了正确的覆盖率结果：

![](/assets/posts/use-karma-mocha-chai-to-test/coverage-in-browser-2.png)

## 持续集成

修改 `karma.conf.js` 中的 `singleRun` 配置项：

```js
...
singleRun: !!process.env.CI;
...
```

如果你不准备使用持续集成，那么忽略该配置，默认即可。

---

参考链接：

- [搭建 Karma+Mocha+Chai 测试 TypeScript 项目](https://blog.crimx.com/2019/06/19/%E6%90%AD%E5%BB%BA-karma-mocha-chai-%E6%B5%8B%E8%AF%95-typescript-%E9%A1%B9%E7%9B%AE/)
- [测试框架 Mocha 实例教程](http://www.ruanyifeng.com/blog/2015/12/a-mocha-tutorial-of-examples.html)
- [学习 Karma+Jasmine+istanbul+webpack 自动化单元测试](https://www.cnblogs.com/tugenhua0707/p/8433847.html)
- [使用 Karma + Jasmine 构建 Web 测试环境](https://www.ibm.com/developerworks/cn/web/wa-lo-use-karma-jasmine-build-test-environment/index.html)
- [How to test the HTML elements and their DOM properties with the Jasmine framework](https://christosmonogios.com/2016/09/08/How-To-Test-The-HTML-Elements-And-Their-DOM-Properties-When-Using-The-Jasmine-Framework/)
