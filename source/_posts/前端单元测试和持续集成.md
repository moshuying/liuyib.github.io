---
title: 前端单元测试和持续集成
date: 2019-06-04 22:54:49
top_image: https://raw.githubusercontent.com/liuyib/picBed/master/hexo-blog/cover-img/20190911001211.jpg
math: false
tags:
  - 前端自动化
  - 单元测试
  - 持续集成
  - Github徽章
---

经常使用 Github 的同学应该知道，一些开源项目中常常会挂上很多花花绿绿了的小徽章，比如 vue 的：

![](https://raw.githubusercontent.com/liuyib/picBed/master/hexo-blog/post/20190604131517.png)

这些徽章不仅起到装饰 README 的作用，更给人以安全可靠的感觉。由于好奇，自己也探究了一番。

## 给项目装上徽章

想要获取徽章，有很多方式，最简单的可以通过 [shields.io](https://shields.io/) 网站获取，基本上想要的徽章都能获取到，没有的也可以进行 DIY，很方便。

<!-- more -->

举个例子，将项目的开源协议通过徽章进行展示，你只需要填写 Github 用户名和项目名称，网站就会自动获取你项目中的数据。

![](https://raw.githubusercontent.com/liuyib/picBed/master/hexo-blog/post/20190604131257.png)

![](https://raw.githubusercontent.com/liuyib/picBed/master/hexo-blog/post/20190604131255.png)

然后你只需要复制链接，将徽章放入你的 README 即可。

## 单元测试

上面所说的开源协议这类徽章基本上只有展示作用，还有一些徽章，用户点击后，可以获取到他们想知道的数据，比如 `build passing`、`coverage 97%` 这些徽章是项目进行 CI（Continuous integration, 持续集成）测试和生成代码覆盖率报告后，展示出来的徽章。当用户点击它们，就可以看到项目 CI 测试的情况和代码覆盖率的报告图。

为什么要展示代码覆盖率？原因很简单，代码覆盖率常常被认为是衡量单元测试好坏的一个指标，而单元测试的好坏在某种程度上又会反应项目代码的质量。因此当项目挂上 `coverage: 100%` 的徽章时，总给人以满满的安全感。

那么为什么要进行单元测试，推荐看一个知乎上的优质回答：[单元测试到底是什么？应该怎么做？](https://www.zhihu.com/question/28729261/answer/163637881)。这里我只简单介绍一下前端单元测试的流程。

前端的单元测试包括但不限于：单元功能测试、UI 测试、兼容性测试等等。一个测试体系大体包括四部分：

- 测试运行器（eg: [karma](https://github.com/karma-runner/karma)）
- 测试框架（eg: [mocha](https://github.com/mochajs/mocha), [jest](https://github.com/facebook/jest), [jasmine](https://github.com/jasmine/jasmine), [qunit](https://github.com/qunitjs/qunit)）
- 断言库（eg: [should](https://github.com/shouldjs/should.js), [chai](https://github.com/chaijs/chai)）
- 代码覆盖率（eg: [istanbul](https://github.com/gotwarlost/istanbul)）

下面我们通过一个单元功能测试的例子来了解如果进行前端单元测试。

> 举的这个例子没有涉及测试运行器，只讲了测试框架、断言库和测试覆盖率的使用。以我个人比较喜欢的 `mocha + should + istanbul` 组合为例。

### 建立项目

首先，执行 `npm init --yes` 创建 package.json 文件。

然后，新建一个 main.js 文件，编写 factorial 函数，用于求一个数的阶乘。

```js
var factorial = function(n) {
  if (n === 0) {
    return 1;
  }

  return factorial(n - 1) * n;
};

if (require.main === module) {
  // 如果是直接执行 main.js，则进入此处
  // 如果 main.js 被其他文件 require，则此处不会执行
  var n = Number(process.argv[2]);
  console.log("factorial(" + n + ") is", factorial(n));
}
```

这只是简单的实现，我们先运行一下，看看结果是否正确。执行指令：`node main.js 5`，效果如下。

![](https://raw.githubusercontent.com/liuyib/picBed/master/hexo-blog/post/20190604172016.png)

结果是 120，符合预期。但是一个测试例子并不能说明什么，我们还需要验证如果输入，负数、非数字、小数、很大的数等等，程序会返回什么。所以接下来我们将进行 **测试驱动开发**（Test-Driven Development, TDD），通过不断的测试来逐步完善我们的代码。

### 运行测试

在 main.js 中添加一句 `exports.fibonacci = fibonacci;` 将函数暴露出去。这样才可以在其他文件中 `require` 这个函数。

在 test 目录下新建测试文件，命名为 `main.test.js`。然后在测试文件中引用 fibonacci 函数，并使用 mocha 和 should 进行测试。

> 测试文件通常放在 test 目录下，文件的命名规则是在原来的文件名后面加 `.test`

```js
var main = require("../src/main");
var should = require("should");

describe("test/main.js", function() {
  it("should equal 0 when n === 0", function() {
    main.factorial(0).should.equal(1);
  });
});
```

> 其中 `describe()`、`it()` 是 mocha 提供的 api，看不懂的话先记住就好了。

接着我们来跑通测试文件。

首先全局安装 mocha：`npm install mocha -g`，然后执行指令：`mocha ./test/main.test.js`，结果如下，显示 passing 表明测试通过。

![](https://raw.githubusercontent.com/liuyib/picBed/master/hexo-blog/post/20190604175056.png)

到这里，我们已经使用测试框架 + 断言库进行了最简单的测试，接下来需要不断完善测试用例来使我们的代码健壮起来。

### 完善测试用例

首先，明确函数功能。我们的 factorial 函数应该有以下功能。

- 当 n === 0 时，返回 1。
- 当 n > 0 时，返回 `factorial(n - 1) * n`。
- 当 n < 0 时，抛出错误。因为没有意义。
- 当 n 不是数字时，抛出错误。
- 当 n > 10 时，抛出错误。这里为了演示，只进行 10 以内的阶乘运算。

然后，我们需要根据功能来完善测试用例。

```js
describe("test/main.js", function() {
  it("should equal 1 when n === 0", function() {
    main.factorial(0).should.equal(1);
  });

  it("should equal 1 when n === 1", function() {
    main.factorial(1).should.equal(1);
  });

  it("should equal 3628800 when n === 10", function() {
    main.factorial(10).should.equal(3628800);
  });

  it("should throw when n > 10", function() {
    (function() {
      main.factorial(11);
    }.should.throw("n should <= 10"));
  });

  it("should throw when n < 0", function() {
    (function() {
      main.factorial(-1);
    }.should.throw("n should >= 0"));
  });

  it("should throw when n is not Number", function() {
    (function() {
      main.factorial("参数类型错误");
    }.should.throw("n should be a Number"));
  });
});
```

接着，执行测试指令 `mocha ./test/main.test.js`，效果如下。

![](https://raw.githubusercontent.com/liuyib/picBed/master/hexo-blog/post/20190604181013.png)

可以看到后面三个测试用例都没有通过，这说明 factorial 函数并不是在所有情况下都可以正常运行。所以我们更新 factorial 的实现。

```js
var factorial = function(n) {
  if (typeof n !== "number") {
    throw new Error("n should be a Number");
  }

  if (n < 0) {
    throw new Error("n should >= 0");
  }

  if (n > 10) {
    throw new Error("n should <= 10");
  }

  if (n === 0) {
    return 1;
  }

  return factorial(n - 1) * n;
};
```

然后再次执行测试指令，效果如下。

![](https://raw.githubusercontent.com/liuyib/picBed/master/hexo-blog/post/20190604191932.png)

完美通过测试。这就是测试驱动开发的流程，首先明确程序的功能，然后跑测试用例，如果测试用例没有通过，修改程序，直到测试用例通过。

### 生成代码覆盖率

有一个指标用于检测编写的测试用例是否合理。这个指标叫做 “代码覆盖率”。它包含四个方面。

- **行覆盖率**：是否每一行都执行了
- **函数覆盖率**：是否每个函数都调用了
- **分支覆盖率**：是否每个 if 代码块都执行了
- **语句覆盖率**：是否每个语句都执行了

这里我们使用 istanbul 来生成代码覆盖率。首先全局安装 istanbul：`npm install istanbul -g`，执行指令：`istanbul cover _mocha`（如果这条指令执行时报错，那就将 mocha 项目级安装：`npm install mocha --save-dev`，然后执行指令：`istanbul cover ./node_modules/mocha/bin/_mocha`）

> 注意，这条指令中 `_mocha` 前面的下划线不能省略。因为，mocha 和 \_mocha 是两个不同的命令，前者会新建一个进程执行测试，而后者是在当前进程（即 istanbul 所在的进程）执行测试，只有这样， istanbul 才会捕捉到覆盖率数据。其他测试框架也是如此，必须在同一个进程执行测试。

效果如下。

![](https://raw.githubusercontent.com/liuyib/picBed/master/hexo-blog/post/20190604200739.png)

具体的覆盖率情况，可以运行 `coverage/lcov-report` 目录下的 `index.html` 文件查看。

![](https://raw.githubusercontent.com/liuyib/picBed/master/hexo-blog/post/20190604201523.png)

其实这次的覆盖率是 100%，因为函数在被其他文件引用时 24、25 这两行不会执行，所以没办法测。如果将这两行所在的 if 语句删除，可以得到 100% 的覆盖率。

![](https://raw.githubusercontent.com/liuyib/picBed/master/hexo-blog/post/20190604201923.png)

### 上传代码覆盖率

主流的的展示代码覆盖率的工具有 [Codecov](https://codecov.io/) 和 [Coveralls](https://coveralls.io/)。至于选择哪一个，答案是都可以，不过 Coveralls 网站的界面有种古典的气息，相比之下我更喜欢 Codecov，所以这里以 Codecov 为例。

首先，打开 Codecov 官网，绑定 Github 账号之后，选择要展示覆盖率的仓库。

然后，项目级安装 codecov：`npm install codecov --save-dev`。

接着，将上传覆盖率的指令写入 `package.json` 文件。

```json
"script": {
  "codecov": "cat ./coverage/lcov.info | ./node_modules/.bin/codecov"
}
```

这条指令中 `cat ./coverage/lcov.info` 指令用于读取 coverage 目录下的 `lcov.info` 文件， `./node_modules/.bin/codecov` 指令用于将覆盖率上传到 Codecov 网站。

> 注意，上传覆盖率的指令在本地运行是没有作用的，需要在 CI 中执行才有效。

下面会讲如何在 CI 中上传代码覆盖率。

## 持续集成

了解了单元测试和代码覆盖率后，这还不够，因为我们不可能每次都手动运行测试脚本，我们需要的是自动化测试。这就涉及到了持续集成的概念。

持续集成是一种软件开发实践，每次集成都通过自动化的构建（包括编译，发布，自动化测试）来验证，从而尽早地发现集成错误。

主流的持续集成工具有 [Travis CI](https://travis-ci.org/) 和 [Circle CI](https://circleci.com/)，个人比较喜欢前者，因此这里以 Travis CI 为例。

### Travis CI 的使用

首先，进入官网后，点击 Sign In 按钮绑定 Github。然后在仓库列表中选择你要进行持续集成的仓库，点击按钮启用。

![](https://raw.githubusercontent.com/liuyib/picBed/master/hexo-blog/post/20190604205207.png)

然后，你需要在项目根目录下创建 `.travis.yml` 文件（如果没有这个文件，Travis 会默认执行 `npm install` 和 `npm test`），配置文件示例如下。

```yml
language: node_js

node_js:
  - 10

# Travis CI cache
cache:
  directories:
    - node_modules

install:
  - npm install

script:
  - npm run coverage

after_success:
  - npm run codecov

branches:
  only:
    - master
```

在这个配置文件中，指定了我们代码的语言（languages），语言版本（node_js），构建之前运行什么指令安装依赖包（install），执行测试程序的指令（script），测试指令执行成功后执行的指令（after_success）以及对项目的哪些分支进行测试（branches）。更多的配置请查看 Travis 的[官方文档](https://docs.travis-ci.com/user/tutorial/)。

此外这里还使用了 Travis 的 cache 功能缓存 npm 包，来节省构建时间。

上面配置文件中的 `npm run coverage` 和 `npm run codecov` 指令定义在 `package.json` 文件里。

```json
"scripts": {
  "coverage": "./node_modules/.bin/istanbul cover ./node_modules/mocha/bin/_mocha --report lcovonly -- -R spec",
  "codecov": "cat ./coverage/lcov.info | ./node_modules/.bin/codecov"
}
```

此外我们还需要将用到的测试库项目级安装。

``` bash
npm install --save-dev codecov istanbul mocha should
```

> 也就是说，你项目的 package.json 文件中的 `devDependencies` 字段或 `dependencies` 字段里，要有这些用到的库的信息才行，这样 CI 执行 `npm run install` 时，才能安装它们，否则会找不到 `istanbul`、`mocha`、`codecov` 这些指令。

如果你 `.travis.yml` 文件中的 install 字段配置如下。

```yml
install:
  - npm install
  - npm install istanbul -g
  - npm install codecov -g
```

那么 `npm run coverage` 和 `npm run codecov` 指令就可以修改为。

```json
"scripts": {
  "coverage": "istanbul cover ./node_modules/mocha/bin/_mocha --report lcovonly -- -R spec",
  "codecov": "cat ./coverage/lcov.info | codecov"
},
```

也就是说和你自己跑指令时一样，全局安装的依赖包就不需要指定路径。

> 这里建议不要将 mocha 全局安装，而且依赖包最好都项目级安装。

### 带上你的荣誉徽章

实现了 CI，也上传了代码覆盖率，接下来我们只需要将结果以徽章的形式放入 READMD 即可。

Travis 的徽章这样获取。

![](https://raw.githubusercontent.com/liuyib/picBed/master/hexo-blog/post/20190604225243.png)

Codecov 的徽章这样获取。

![](https://raw.githubusercontent.com/liuyib/picBed/master/hexo-blog/post/20190604225017.png)

每当项目 commit 之后，CI 测试就会自动进行，然后测试的结果就会通过徽章展示在你的项目文档中。

### 跨浏览器集成测试

浏览器端使用的库，在各个浏览器端的兼容性也是非常重要的。一些项目会选择在模拟环境中进行测试，这样虽然方便，但是毕竟是模拟的，测试效果无法媲美真实环境。所以就需要用到跨浏览器测试的工具，有两个选择 [SauceLabs](https://saucelabs.com/) 和 [BrowserStack](https://www.browserstack.com/)，这个工具提供了多重的浏览器环境（包括 PC 端和移动端），帮助你在多种浏览器中自动运行脚本。

关于跨浏览器集成测试更详尽的使用，推荐阅读：[前端持续集成解决方案](https://segmentfault.com/a/1190000007221668#articleHeader3)
