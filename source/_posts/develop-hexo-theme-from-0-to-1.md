---
title: 从0到1开发Hexo主题杂谈
date: 2019-08-20 18:20:24
tags:
  - Hexo
categories:
  - Hexo主题开发
top_image: https://raw.githubusercontent.com/liuyib/picBed/master/hexo-blog/cover-img/20190911002035.jpg
math: false
---

## 前言

在没有开发自己的 Hexo 主题之前，我都是在 Github issues 里写[博客](https://github.com/liuyib/blog/issues)，但这样的做法总被小伙伴各种吐槽 (￣_￣ )。想到如果文章多的时候，使用 Github issues 浏览起来不够方便，所以还是换回了 Hexo。

使用 Hexo 首先是要挑选喜欢的主题，以我个人的感受来讲，Hexo 的主题虽然有两百多个，但是能拿出手的也就不到二十个。其中我最佩服的主题 Next 已经足够优秀，但是风格我并不喜欢，最后决定自己开坑。

本文主要记录了我从零开发 Hexo 主题 -- [Stun](https://github.com/liuyib/hexo-theme-stun) 时，遇到的所有坑和经验，**仅供参考**，有不足的地方欢迎指出。

<!-- more -->

## 知识储备

### 模板引擎

传统的 HTML 写起来既不方便，又不能复用，因此在 Hexo 中通常使用模板引擎来呈现网站内容。

常用的几种模板引擎有：[Swig](https://github.com/paularmstrong/swig)、[EJS](https://github.com/hexojs/hexo-renderer-ejs)、[Haml](https://github.com/hexojs/hexo-renderer-haml) 或 [Jade](https://github.com/hexojs/hexo-renderer-jade)。其中 Jade 由于商标问题，改名为 [Pug](https://github.com/pugjs/pug)，虽然它们是兼容的，但使用的时候，推荐安装 Pug 而不是 Jade。Hexo 内置了 Swig，将文件扩展名改为 `.swig` 即可使用，你也可以安装插件来获得另外几种模板引擎的支持，Hexo 会根据文件扩展名来决定使用哪一种。例如：

``` text
layout.pug   -- 使用 pug
layout.swig  -- 使用 swig
```

这里你需要做的是，选择一个自己喜欢的模板引擎，然后浏览文档，了解这个模板引擎的基本用法。

- 英文文档地址分别如下：[Swig](https://node-swig.github.io/swig-templates/docs/)、[EJS](https://ejs.co/#docs)、[Pug](https://pugjs.org/api/getting-started.html)、[Haml](http://haml.info/docs.html)。
- 中文文档地址分别如下：[Swig](https://myvin.github.io/swig.zh-CN/docs/index.html)、[EJS](https://ejs.bootcss.com/#docs)、[Pug](https://pugjs.org/zh-cn/api/getting-started.html)、Haml（无）。

这里我选择了 Pug，不过我还是推荐使用 Swig 或 EJS。

### CSS 预处理语言

你可以使用原生 CSS 来写样式，但是原生 CSS 难以复用，不能使用循环，不能使用布尔判断，书写不够方便，等等。这会导致主题开发变得相对麻烦，甚至某些功能无法实现，因此最好是使用 CSS 预处理语言。

常见的 CSS 预处理语言有：[Less](http://lesscss.org/)、[Sass](https://sass-lang.com/)、[Stylus](http://stylus-lang.com/)。至于它们的选择，根据自己的喜好即可。Hexo 默认使用的是 Stylus，它的功能足够强大，完全够用，因此我选用了 Stylus。

### Hexo 相关知识

有关 Hexo 的知识，这里只列举必要的部分。

#### 构建 Hexo 开发环境

开发主题之前，你需要搭建 Hexo 工作目录，有两种方式可供选择：

1. 使用 `hexo-cli`
2. 克隆 Hexo 主题的单元测试项目

第一种方式，去 Hexo [官网](https://hexo.io/zh-cn/)，按照提示安装 `hexo-cli` 并生成你的 Hexo 工作目录，目录主要部分如下：

``` text
.
├── scaffolds
├── source
|   └── _posts
├── themes
├── .gitignore
├── _config.yml
└── package.json
```

第二种方式，克隆 Hexo 官方的[单元测试库](https://github.com/hexojs/hexo-theme-unit-test)，这样会得到同上的文件目录。然后执行指令 `npm install` 安装所有依赖。

对于一般的 Hexo 用户，基本都是使用第一种方式。不过对于 Hexo 主题开发者来说，如果你的主题将来要发布到 Hexo 的[主题列表](https://hexo.io/themes)，建议直接在 Hexo 的主题单元测试项目中进行开发，也就是第二种方式。因为 Hexo 建议在主题发布前，对主题进行单元测试，确保每一项功能都能正常使用。Hexo 提供的单元测试库包括了所有的边缘情况，例如：文章标题过长时的显示效果、文章标题为空时的显示效果（是什么都不显示，还是显示一些默认的提示文字）、对 Front-Matter 的支持程度，等等。直接使用 Hexo 主题的单元测试项目作为你的开发目录，就可以在开发过程中注意到这些边缘情况，而不是开发完再去测试。

搭建完 Hexo 开发环境后，需要安装相关插件来支持你所使用的渲染引擎。Hexo 默认安装的渲染引擎是 EJS 和 Stylus，并且 Hexo 内置了 Swig，因此，如果你选用了 `EJS + Stylus` 或 `Swig + Stylus`，那么可以忽略这段，如果你选择了其他的渲染引擎，需要自行选择安装：

``` bash
# Templates
$ npm install --save hexo-renderer-ejs
$ npm install --save hexo-render-pug
$ npm install --save hexo-render-haml

# Styles
$ npm install --save hexo-renderer-less
$ npm install --save hexo-renderer-sass
$ npm install --save hexo-renderer-stylus
```

#### 生成主题结构目录

上一步只是搭建好了 Hexo 工作目录，接下来是创建主题的文件目录，你可以参考着已有的主题的文件目录手动创建，也可以使用 `Yeoman` 自动生成，使用 `Yeoman` 自动生成的步骤如下。

1. 安装

``` bash
$ npm install --global yo
$ npm install --global generator-hexo-theme
```

2. 生成

进入 Hexo 的 `themes` 目录中，新建一个文件夹作为你的主题目录，然后进入该文件夹中，执行指令：

``` bash
yo hexo-theme
```

按照提示，填写或选择相应的信息，如下图：

![](https://raw.githubusercontent.com/liuyib/picBed/master/hexo-theme-stun/doc/20190822211939.png)

生成的文件目录如下：

``` text
.
├── layout        # 布局文件夹
|   ├── includes
|   |   ├── layout.pug       # 页面总体布局
|   |   └── recent-posts.pug # 文章列表
|   ├── index.pug            # 首页
|   ├── archive.pug          # 归档页
|   ├── category.pug         # 分类页
|   ├── tag.pug              # 标签页
|   ├── post.pug             # 文章页
|   └── page.pug             # 除以上页面之外的页面
├── scripts       # 脚本文件夹
├── source        # 资源文件夹
|   ├── css
|   ├── js
|   └── favicon.ico
├── .editorconfig # 编辑器配置文件
├── _config.yml   # 主题配置文件
└── package.json
```

当然只有这些文件目录是不够的，我们还需要另外添加一些其他的文件或目录，例如，`languages` 目录，放置语言文件，用于[国际化（i18n）](https://hexo.io/zh-cn/docs/internationalization)设置（如果你的主题需要支持多语言，就添加该目录，否则不用添加）。

有关以上目录的介绍，详参见：[Hexo 主题](https://hexo.io/zh-cn/docs/themes)。

> 这里需要提一下，主题目录和 Hexo 根目录中各有一个 `source` 文件夹，当你执行指令 `hexo generate` 来生成静态文件时，这两个 `source` 目录中的文件如果是 Markdown 文件，则会被解析为 HTML，而其他类型的文件则会被复制到 `public` 目录中。`public` 目录用于存放打包后生成的文件，这些文件就是线上跑的网站资源文件。**因此，如果你不清楚 `source` 目录里文件的使用路径是怎样的，那么你可以跑一下指令 `hexo generate`，这些文件生成到 `public` 目录中后，它们的路径关系就很明显了。**

#### 通读文档

虽然 Hexo 的文档确实很差劲，文档下面的评论区全是吐槽，而且有些部分中英文版本没有同步，但是如果能耐心读完，会有很大的收益，我个人的最大感受是 Hexo 的文档真的特别重要。当然一次掌握是不可能的，我的建议是在开发时每隔一段时间过一遍（Hexo 的一些重要功能，例如：标签插件、Front-Matter，等等，也只有通过阅读文档熟悉了之后，才能更好的实现和支持）。

刚开始开发主题，不可能理解 Hexo 文档中提到的所有地方，但是有两个点必须首先掌握：[变量](https://hexo.io/zh-cn/docs/variables)和[辅助函数](https://hexo.io/zh-cn/docs/helpers)，这两点在开发时会经常用到，并且贯穿整个开发过程。

## 主题开发

有了上述的准备后，就可以开始主题的开发了。下面是主题开发中一些值得注意的地方，了解这些，可以帮助你避免踩重复的坑。

### 主题配置文件

主题的配置文件采用了 [Yaml](https://docs.ansible.com/ansible/latest/reference_appendices/YAMLSyntax.html) 语法，和 Json 类似，了解一下语法格式就可以上手使用了。

开发主题时，有的功能可以让用户自己配置，因此我们需要将这些功能的配置项暴露出来，填充到主题的配置文件 `_config.yml` 中。然后在模板引擎中，你可以通过 Hexo 内置的 `theme` 变量来获取这些配置项。例如：

配置文件：

``` yaml _config.yml
copyright:
  enable: true
  text:
```

这样使用：

``` html
// -------------------- Pug 语法 --------------------
if theme.copyright.enable
  div.copyright= theme.copyright.text

// -------------------- Swig 语法 --------------------
{% if theme.copyright.enable %}
<div class="copyright">{{ theme.copyright.text }}</div>
{% endif %}
```

{% note default %}
文章接下来的部分中，模板语言示例代码都会用 Pug 和 Swig 两种语法给出。
{% endnote %}

随着项目的发展，配置文件会越来越大，上面这种做法的缺点也会越来越明显。

- 对于使用者

  当更新主题时，由于配置文件会被覆盖，因此用户必须提前将配置文件备份，等更新完主题后再将备份的数据拷贝回去，这个过程繁琐又容易出错。

- 对于开发者

  在发布主题时，开发者不可能将自己测试用的数据保留在主题配置文件中，而应该预留一份干净的配置文件。因此每次发布主题之前，都需要把主题配置文件里的测试数据清空、备份，然后等发布完主题后再恢复回来。这种做法是无法令人忍受的，因为每次 `git commit` 之前都需要这样做一次。

因此我们需要一种更友好的方式来使用配置文件。在查找资料和参考现有主题 NexT、Melody 的实现后，发现可以利用 Hexo 3.0 提供的新特性 -- [数据文件](https://hexo.io/zh-cn/docs/data-files)，来解决上面的痛点。

使用方法如下，在 Hexo 根目录下的 `source/_data` 文件夹中（没有的文件夹需要自己创建），新建一个 Yaml 配置文件，并**命名为主题的名称**，例如 Stun 主题，就叫做 `stun.yml`。然后将主题配置文件 `_config.yml` 里的内容复制到 `stun.yml` 中，这样 `stun.yml` 就会覆盖 `_config.yml`。如果想要修改配置，直接修改 `stun.yml` 就好了。当用户更新主题或者开发者发布主题时，配置数据保存在 `stun.yml` 中，主题原来的配置文件 `_config.yml` 仍然是干净的。

下面是代码实现，在主题根目录下的 `scripts` 文件夹中（没有就新建），添加一个 JS 文件，文件名随意，添加如下代码：

``` js
hexo.on('generateBefore', function () {
  var rootConfig = hexo.config;

  if (hexo.locals.get) {
    // 获取 source/_data 目录下的文件
    var data = hexo.locals.get('data');

    // 如果存在 stun.yml 文件，就用它覆盖原来的配置文件
    if (data && data.stun) {
      hexo.theme.config = data.stun;
    }
  }

  hexo.theme.config.rootConfig = rootConfig;
});
```

### 页面搭建

你需要分析主题页面的结构，将能够公用的部分抽离出来，例如：

- HTML 的 `head` 部分
- 顶部导航栏
- 页面头部、底部
- 页面侧边栏
- 页面主体部分（显示文章的地方）
- ......

将这些部分对应的代码放在主题 `layout` 目录下的 `layout.pug` 文件中用以复用，例如：

``` html
// -------------------- Pug 语法 --------------------
html
  head
    title
      block title
  body
    header#header.header
      div.header-inner
        include ./header.pug
    
    main#main.main
      div.main-inner
        div#content.content
          div.content-inner
            block content
        
        div#sidebar.sidebar
          div.sidebar-inner
            block sidebar

    footer#footer.footer
      div.footer-inner
        include ./footer.pug

// -------------------- Swig 语法 --------------------
<html>
  <head>
    <title>{% block title %}{% endblock %}</title>
  </head>

  <body>
    <header id="header" class="header">
      <div class="header-inner">
        {% include './header.swig' %}
      </div>
    </header>

    <main id="main" class="main">
      <div class="main-inner">
        <div id="content" class="content">
          <div class="content-inner">
            {% block content %}{% endblock %}
          </div>
        </div>
        
        <div id="sidebar" class="sidebar">
          <div class="sidebar-inner">
            {% block sidebar %}{% endblock %}
          </div>
        </div>
      </div>
    </main>

    <footer id="footer" class="footer">
      <div class="footer-inner">
        {% include './footer.swig' %}
      </div>
    </footer>
  </body>
</html>
```

`layout.pug` 是网站最基础的布局代码，所有的页面都是继承它而来。Pug / Swig 使用 `extends` 和 `block` 实现继承，例如：

``` html
// -------------------- Pug 语法 --------------------
html
  head
    title
      block title

  body
    block content

// -------------------- Swig 语法 --------------------
<html>
  <head>
    <title>{% block title %}{% endblock %}</title>
  </head>
  <body>
    {% block content %}{% endblock %}
  </body>
</html>
```

``` html
// -------------------- Pug 语法 --------------------
extends layout.pug

block title
  My Page

block content
  This is a awesome page.

// -------------------- Swig 语法 --------------------
{% extends 'layout.swig' %}

{% block title %}My Page{% endblock %}

{% block content %}
<p>This is a awesome page.</p>
{% endblock %}
```

除了继承的方式复用代码，还可以通过 `include` 语法直接引文件来实现代码复用，例如：

``` html
// -------------------- Pug 语法 --------------------
div#header.header
  include ./header.pug

// -------------------- Swig 语法 --------------------
<div id="header" class="header">
  {% include './header.swig' %}
</div>
```

> 由于 `layout.pug` 只用于被其他页面继承，并不会单独渲染成页面，因此，可以将文件名改为 `_layout.pug`（以下划线开头）这样 Hexo 就不会解析这个文件，可以提高 Hexo 生成页面的速度。

这里我并不准备介绍页面中更详细的部分如何实现，直接看[源码](https://github.com/liuyib/hexo-theme-stun)效果更好。

### 数据交互

这里介绍下 Pug / Swig、Stylus、JavaScript 这几种文件如何与主题配置文件进行数据交互。

前面我们已经知道了，主题配置文件里的配置项被包含在 `theme` 变量下。因此在我们需要知道如何在另外三种文件中使用 `theme` 变量：

- 在 Pug / Swig 文件中使用

  ``` html
  // -------------------- Pug 语法 --------------------
  div= theme.copyright.text

  html(lang=theme.language)

  if theme.sidebar.enable
    div.sidebar

  div(class=`sidebar ${ if theme.sidebar.show ? 'show' : '' }`)

  // -------------------- Swig 语法 --------------------
  <div>{{ theme.copyright.text }}</div>

  <html lang="{{ theme.language }}"></html>

  {% if theme.sidebar.enable %}
    <div class="sidebar"></div>
  {% endif %}

  <div class="sidebar {% if theme.sidebar.show %}show{% endif %}"></div>
  ```

- 在 Stylus 文件中使用

  需要通过 Hexo 内置的函数 `hexo-config` 来获取 `theme` 变量中的属性，但是不需要加 `theme.` 前缀：

  ``` stylus
  // back2top 是 theme 变量下的一个属性
  if (hexo-config('back2top.enable'))
    .back2top
      display: block

  // 如果配置项的值中含有样式，需要使用 Stylus 的 convert 函数转换一下
  .post-title
    color: convert(hexo-config('post.title.color'))
  ```

  > 在其他的 CSS 预处理语言中，理论上也可以通过 `hexo-config` 来获取 `theme` 变量中的属性，我没试过，开发者可以自行尝试。

- 在 JavaScript 文件中使用

  在 JS 文件中没有办法直接获取到 Hexo 内置的 `theme` 变量，但是我们可以换一种方式来间接获取。新建一个模板引擎文件，我们就叫它 `config.pug`，文件内容如下所示：

  ``` html
  // ----- Pug 语法（注意 script 标签后面的点，表示该标签后面有多行代码）-----
  script.
    var CONFIG = {
      sidebar: '!{ theme.sidebar }',
      back2top: '!{ theme.back2top }',
      ...
    };

    window.CONFIG = CONFIG;

  // -------------------- Swig 语法 --------------------
  <script>
    var CONFIG = {
      sidebar: {{ theme.sidebar | json_encode }},
      back2top: {{ theme.back2top | json_encode }},
      ...
    };

    window.CONFIG = CONFIG;
  </script>
  ```

  然后将 `config.pug` 文件放在 HTML 的 `head` 标签中加载，这样就可以通过全局变量 `CONFIG` 在 JS 中获取主题配置文件里的数据了。

到这里为止，就介绍完了开发 Hexo 主题前必要的知识储备，剩下的就靠开发者自己完成了。

## 发布主题

发布主题之前你需要进行[主题单元测试](https://github.com/hexojs/hexo-theme-unit-test)，确保每一项功能都能正常使用。如果你是按照我之前介绍的方法，直接 Hexo 的主题单元测试库中开发主题，那么你应该就不需要进行这一步了。

1、Fork [hexojs/site](https://github.com/hexojs/site)
2、编辑 `source/_data/themes.yml`，在文件中新增您的主题：

``` yaml themes.yml
- name: Stun
  description: A beautiful & simple theme
  link: https://github.com/liuyib/hexo-theme-stun
  preview: https://liuyib.github.io/
  tags:
    - responsive
    - beautiful
    - simple
    - two_column
```

3、在 `source/themes/screenshots` 中添加一个和你主题同名的图片，图片必须为 800*500 的 PNG 文件。
4、发起新的合并申请（pull request）。

最后，只需要等待 Hexo 仓库的维护人员收录你的主题即可。

---

参考链接：

- [Hexo主题开发经验杂谈](https://molunerfinn.com/make-a-hexo-theme/)
- [Hexo 主题开发指南](http://chensd.com/2016-06/hexo-theme-guide.html)
