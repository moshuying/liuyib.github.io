---
title: 前端单元测试和持续集成
date: 2019-06-04 22:54:49
tags:
  - 单元测试
  - 持续集成
  - Github徽章
categories:
  - 前端自动化
top_image: /assets/banner/3.jpg
---

前端的单元测试包括但不限于：单元功能测试、UI 测试、兼容性测试等等。一个测试体系大体包括四部分：

- 测试运行器（e.g. [Karma](https://github.com/karma-runner/karma)）
- 测试框架（e.g. [Mocha](https://github.com/mochajs/mocha), [Jest](https://github.com/facebook/jest), [Jasmine](https://github.com/jasmine/jasmine), [Qunit](https://github.com/qunitjs/qunit)）
- 断言库（e.g. [Should](https://github.com/shouldjs/should.js), [Chai](https://github.com/chaijs/chai)）
- 测试覆盖率（e.g. [Istanbul](https://github.com/gotwarlost/istanbul)）

<!-- more -->

本文会通过一个例子，来一步步了解如何进行前端单元测试。

> 本文举的例子中，没有涉及测试运行器，只涉及测试框架、断言库和测试覆盖率。并以 `Mocha + Should + Istanbul` 组合为例。
>
> 如果你知道 Karma 是干什么的，并且需要用到它，推荐阅读我的另一篇文章：[使用 Karma + Mocha 构建 Web 单元测试环境](https://liuyib.github.io/2020/03/20/use-karma-mocha-chai-to-test/)

## 新建项目

如果你的电脑上没有安装 Node.js，那么你需要访问它的[官网](https://nodejs.org/zh-cn/)，下载并安装到你的电脑上。NPM 是 Node.js 的包管理工具，会随着 Node.js 一起安装。

然后，我们需要用 NPM（Node Package Manager）来管理依赖包，所以先初始化 NPM 的配置文件 `package.json`，执行指令：

```bash
$ npm init -y
```

> `-y` 参数表示不进行询问，直接使用默认的配置。

下面我们在 `src` 目录下，新建 `main.js` 文件，并编写一个 `factorial` 函数（用于求数的阶乘）：

```js
// main.js

var factorial = function(n) {
  if (n === 0) {
    return 1;
  }

  return factorial(n - 1) * n;
};

if (require.main === module) {
  // 如果是在命令行中执行 main.js，则此处会执行。
  // 如果 main.js 被其他文件 require，则此处不会执行。
  var n = Number(process.argv[2]);
  console.log('factorial(' + n + ') is', factorial(n));
}
```

运行一下这个文件，看看结果是否正确。执行指令：`node ./src/main.js 5`，效果如下：

![](/assets/posts/front-end-unit-test-and-ci/run-main-file-in-node.png)

结果是 `120`，符合预期。但是一个例子并不能说明什么，我们还需要对负数、非数字、小数、很大的数等进行验证，在逐步的验证过程中，代码中的不足也会逐渐暴露出来。所以接下来我们将进行**测试驱动开发**（Test-Driven Development, TDD），通过不断的测试来完善代码。

## 编写测试文件

首先，在 `main.js` 文件最后添加代码：

```js
exports.factorial = factorial;
```

这段代码的作用是将 `factorial` 函数暴露出去，这样才可以在其他文件中 `require` 这个函数。

通常，测试文件与所要测试的源文件同名，但是后缀名为 `.test.js`（表示测试）或 `.spec.js`（表示规格）。例如，`main.js` 的测试文件就是 `main.test.js`：

```js
// main.test.js

var main = require('../src/main');
var should = require('should');

describe('test/main.js', function() {
  it('should equal 1 when n === 0', function() {
    should(main.factorial(0)).equal(1);
  });
});
```

上面的代码中：

- `describe` 块称为“测试套件（test suite）”，表示一组相关的测试。它是一个函数，第一个参数是测试套件的名称，第二个参数是一个实际执行的函数。

- `it` 块称为“测试用例（test case）”，表示一个单独的测试，是测试的最小单位。它也是一个函数，第一个参数是测试用例的名称，第二个参数是一个实际执行的函数。

一个测试文件中，可以包含一个或多个 `describe` 块，一个 `describe` 块中可以包含一个或多个 `it` 块。

想要运行这个测试文件，需要安装依赖 Mocha 和 Should：

```bash
$ npm install --save-dev mocha should
```

然后，在 `package.json` 中新建一条 NPM 指令：

```json
...
"scripts": {
  "test": "./node_modules/.bin/mocha ./test/main.test.js"
}
...
```

该指令的作用就是：使用安装在项目目录中的 Mocha 命令 `./node_modules/.bin/mocha` 来测试 `./test/main.test.js` 文件。

执行这个指令 `npm run test`，结果如下（可以看到测试通过）：

![](/assets/posts/front-end-unit-test-and-ci/mocha-test-one-case.png)

到这里，我们就使用测试框架 + 断言库，体验了基本的单元测试流程，接下来我们通过不断完善测试用例，来使代码健壮起来。

## 完善测试用例

首先，明确函数功能。我们的 `factorial` 函数应该有以下功能：

- 当 `n === 0` 时，返回 `1`。
- 当 `n > 0` 时，返回 `factorial(n - 1) * n`。
- 当 `n < 0` 时，抛出错误，因为没有意义。
- 当 `n` 不是数字时，抛出错误。
- 当 `n > 10` 时，抛出错误（本文为了演示，只进行 `10` 以内的阶乘运算）。

然后，我们根据确定好的功能来完善测试用例：

```js
var main = require('../src/main');
var should = require('should');

describe('test/main.js', function() {
  it('should equal 1 when n === 0', function() {
    should(main.factorial(0)).equal(1);
  });

  it('should equal 1 when n === 1', function() {
    should(main.factorial(1)).equal(1);
  });

  it('should equal 3628800 when n === 10', function() {
    should(main.factorial(10)).equal(3628800);
  });

  it('should throw when n > 10', function() {
    (function() {
      main.factorial(11);
    }.should.throw('n should <= 10'));
  });

  it('should throw when n < 0', function() {
    (function() {
      main.factorial(-1);
    }.should.throw('n should >= 0'));
  });

  it('should throw when n is not Number', function() {
    (function() {
      main.factorial('123');
    }.should.throw('n should be a Number'));
  });
});
```

执行测试指令 `npm run test`，效果如下：

![](/assets/posts/front-end-unit-test-and-ci/mocha-test-some-case-1.png)

可以看到后面三个测试用例都没有通过，这说明 `factorial` 函数并不是在所有情况下都可以正常运行，所以我们需要更新 `factorial` 的实现：

```js
var factorial = function(n) {
  if (typeof n !== 'number') {
    throw new Error('n should be a Number');
  }

  if (n < 0) {
    throw new Error('n should >= 0');
  }

  if (n > 10) {
    throw new Error('n should <= 10');
  }

  if (n === 0) {
    return 1;
  }

  return factorial(n - 1) * n;
};
```

再次执行测试指令 `npm run test`，效果如下：

![](/assets/posts/front-end-unit-test-and-ci/mocha-test-some-case-2.png)

可以看到，所有的测试用例都通过了，这证明 `factorial` 函数的功能已经符合了我们的预期要求，而且代码健壮性有了很大的提高。

以上就是 TDD 的基本流程，总的来说就是：**首先明确程序的功能，然后跑测试用例，如果测试用例没有通过，修改程序，直到测试用例通过**。

## 生成覆盖率

如果你想知道测试用例是否合理，可以用“代码覆盖率”来判断。一般而言，如果测试用例写的合理，那么代码覆盖率越高越好，但不是绝对的。

代码覆盖率包括以下几个方面：

- **行覆盖率**：是否每一行都执行了
- **函数覆盖率**：是否每个函数都调用了
- **分支覆盖率**：是否每个 `if` 代码块都执行了
- **语句覆盖率**：是否每个语句都执行了

生成代码覆盖率，需要用到插件 Istanbul，首先将其安装：

```bash
$ npm install --save-dev istanbul
```

然后，在 `package.json` 中新建一条 NPM 指令，用于生成覆盖率：

```json
...
"scripts": {
  "coverage": "./node_modules/.bin/istanbul cover ./node_modules/mocha/bin/_mocha"
}
...
```

> 注意，指令中 `_mocha` 的下划线不能省略。因为，`mocha` 和 `_mocha` 是两个不同的命令，前者会新建一个进程执行测试，而后者是在当前进程（即 Istanbul 所在的进程）执行测试，只有这样， Istanbul 才会捕捉到覆盖率数据。其他测试框架也是如此，必须在同一个进程执行测试。

执行这个指令 `npm run coverage`，结果如下：

![](/assets/posts/front-end-unit-test-and-ci/code-coverage-in-cli-1.png)

将 `coverage/lcov-report` 目录下的 `index.html` 文件在浏览器中运行，可以查看具体的覆盖率。如图所示：

![](/assets/posts/front-end-unit-test-and-ci/code-coverage-in-browser.png)

其实，这次的覆盖率应该是 100%，因为函数在被其他文件引用时 24、25 这两行不会执行，所以没法测。由于这两行代码仅仅是为了刚开始方便演示用，之后我们就不在命令行中测试了，所以直接将这两行语句所在的 `if` 块删除即可。

再次执行测试指令，就得到了 100% 的覆盖率：

![](/assets/posts/front-end-unit-test-and-ci/code-coverage-in-cli-2.png)

## 上传覆盖率

想要展示测试覆盖率，有两个网站可供选择：[Codecov](https://codecov.io/) 和 [Coveralls](https://coveralls.io/)。本文以 Codecov 为例。

首先，打开 Codecov 官网，绑定 Github 账号之后，选择要展示测试覆盖率的仓库。

然后，安装 Codecov：

```bash
$ npm install --save-dev codecov
```

接着，在 `package.json` 中新建一条 NPM 指令，来上传测试覆盖率：

```json
...
"script": {
  "codecov": "cat ./coverage/lcov.info | ./node_modules/.bin/codecov"
}
...
```

> 其中 `cat ./coverage/lcov.info` 用于读取 `coverage` 目录下的 `lcov.info` 文件，`./node_modules/.bin/codecov` 用于将覆盖率上传到 Codecov 网站。

该指令在接下来配置 CI（Continuous integration, 持续集成）时会用到。

## 持续集成

如果每次修改代码之后，都手动进行单元测试，不仅加重工作量，而且容易出错，因此我们需要进行自动化测试，这就用到了持续集成。

持续集成是一种软件开发实践，每次集成都通过自动化的构建（包括编译，发布，测试等）来验证，从而尽早地发现代码中的错误。

可供选择的持续集成工具有 [Travis CI](https://travis-ci.org/) 和 [Circle CI](https://circleci.com/)。本文以 Travis CI 为例。

### 使用 Travis CI

首先，Travis CI 进入官网后，点击 Sign In 按钮绑定 Github。然后在仓库列表中选择你要进行持续集成的仓库，点击按钮启用：

![](/assets/posts/front-end-unit-test-and-ci/travis-ci-settings.png)

然后，你需要在项目根目录下创建 `.travis.yml` 文件（如果没有这个文件，Travis CI 会默认执行 `npm install` 和 `npm test`），配置文件示例如下：

```yml
# 要使用的语言
language: node_js

# 要使用的语言版本
node_js:
  - 10

# 缓存 NPM 依赖，加快构建
cache:
  directories:
    - node_modules

# 安装依赖
install:
  - npm install

# 执行指令
script:
  - npm run coverage

# 指令执行成功后
after_success:
  - npm run codecov

# 指定分支
branches:
  only:
    - master
```

最后，将所有修改提交到远程仓库的 master 分支上，就可以看到 Travis CI 正在自动构建。

### 展示徽章

当 CI 构建完成之后，我们可以通过访问 Travis CI 和 Codecov 的网站查看到详细结果，当然也可以将结果以徽章的形式放入 README，这样更清晰明了。

Travis CI 的徽章这样获取：

![](/assets/posts/front-end-unit-test-and-ci/travis-badge.png)

Codecov 的徽章这样获取：

![](/assets/posts/front-end-unit-test-and-ci/codecov-badge.png)

每当 CI 构建完成，结果就会以徽章的形式，展示在你的项目文档中。
