---
title: 从0到1开发Hexo主题杂谈
date: 2019-08-20 18:20:24
top_image: 
tags:
  - hexo
  - hexo-theme
categories:
  - [hexo-theme, hexo主题开发]
---

## 前言

在没有开发自己的 Hexo 主题之前，我都是在 Github Issue 里写[博客](https://github.com/liuyib/blog/issues)，但这样的做法总被小伙伴各种吐槽 (￣_￣ )。又想到如果文章多的时候，使用 Github Issue 浏览起来不够方便，所以还是换回了 Hexo。

<!-- more -->

使用 Hexo 首先是要挑选喜欢的主题，以我个人的感受来讲，Hexo 的主题虽然有两百多个，但是能拿出手的也就不到二十个。其中我最佩服的主题 Next 已经足够优秀，但是风格我并不喜欢，最后决定自己开发。

本文记录了我从零开发 Hexo 主题时，遇到的所有坑和经验，**仅供参考**。

## 知识储备

### 模板引擎

传统的 HTML 写起来既不方便，又不能复用，因此在 Hexo 中通常使用模板引擎来呈现网站内容。

常用的几种模板引擎有：[Swig](https://github.com/paularmstrong/swig)、[EJS](https://github.com/hexojs/hexo-renderer-ejs)、[Haml](https://github.com/hexojs/hexo-renderer-haml) 或 [Jade](https://github.com/hexojs/hexo-renderer-jade)。其中 Jade 由于商标问题，改名为 [Pug](https://github.com/pugjs/pug)，虽然它们是兼容的，但使用的时候，推荐安装 Pug 而不是 Jade。Hexo 内置了 Swig，将文件扩展名改为 `.swig` 即可使用，你也可以安装插件来获得另外几种模板引擎的支持，Hexo 会根据文件扩展名来决定使用哪一种。例如：

``` text
layout.swig  -- 使用 swjg
layout.pug   -- 使用 pug
```

这里你需要做的是，选择一个自己喜欢的模板引擎，然后浏览文档，了解这个模板引擎的基本用法。由于我比较喜欢 Pug 的语法风格，因此选择了 Pug。

> 在我开发主题的过程中，有一些功能，使用 Swig 实现起来很简单，而使用 Pug 提供的语法实现起来相对困难或只能换一种方式实现，这使我有很多次想放弃 Pug 使用 Swig 重构代码。因此这里建议，如果不是特别喜欢 Pug，还是不要使用。

### CSS 预处理语言

开发 Hexo 主题，你可以使用最原始的 CSS 来写样式，但是 CSS 不能使用变量，不能复用，也没有函数，这会导致主题开发变得相对麻烦，**甚至某些功能无法实现**。因此最好是使用 CSS 预处理语言。

常见的 CSS 预处理语言有：[Less](http://lesscss.org/)、[Sass](https://sass-lang.com/)、[Stylus](http://stylus-lang.com/)。至于它们的选择，根据自己的喜好即可，这里我选用了 Stylus。

### Hexo 相关知识

有关 Hexo 的知识，这里只列举必要的部分。

#### 构建 Hexo 开发环境

开发主题之前，你需要搭建自己的 Hexo 工作目录，有两种方式可供选择：

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

对于一般的 Hexo 用户，都是使用第一种方式。不过对于 Hexo 主题开发者来说，如果你的主题将来要发布到 Hexo 的[主题列表](https://hexo.io/themes)，建议直接在 Hexo 的主题单元测试项目中进行开发，也就是第二种方式。原因是因为 Hexo 建议在主题发布前，先进行主题单元测试，确保每一项功能都能正常使用。Hexo 提供的单元测试库包括了所有的边缘情况，直接在上面开发就可以在开发时注意到这些边缘情况，而不是开发完再去测试。

搭建完 Hexo 开发环境后，安装相关插件来支持你所使用的渲染引擎。Hexo 默认安装的渲染引擎是 `ejs` 和 `stylus`，如果你选择了其他的，需要自行选择安装：

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

当然只有这些文件目录是不够的，我们还需要另外添加一些其他的文件或目录，例如，`languages` 目录，放置语言文件，用于[国际化（i18n）](https://hexo.io/zh-cn/docs/internationalization)设置。

有关以上目录的详细介绍，请参见：[Hexo 主题](https://hexo.io/zh-cn/docs/themes)。

这里需要提一下，主题目录和 Hexo 根目录中各有一个 `source` 文件夹，当你执行指令 `hexo generate` 来生成静态文件时，这两个 `source` 目录中的文件如果是 markdown 会被解析为 HTML，其他不能解析的文件，会被复制到 `public` 目录中。`public` 目录用于存放生成的静态文件，这些静态文件就是线上跑的网站文件。因此，如果你不清楚 `source` 目录里文件的使用路径是怎样的，那么你可以跑一下指令 `hexo generate`，这些文件生成到 `public` 目录中后，它们的路径关系就明显了。

#### 通读文档

虽然 Hexo 的文档确实很差劲，文档下面的评论区全是吐槽，而且有些部分中英文版本没有同步，但是如果能耐心读完，会有很大的收益，我个人的最大感受是 Hexo 的文档真的特别重要。当然一次掌握是不可能的，最好在开发时每隔一段时间过一遍。

刚开始开发主题，不可能理解 Hexo 文档中提到的所有地方，但是有两个点必须首先掌握：[变量](https://hexo.io/zh-cn/docs/variables)和[辅助函数](https://hexo.io/zh-cn/docs/helpers)，这两点在开发时会经常用到，并且贯穿整个开发过程。

## 主题开发

有了上述的充足准备后，就可以开始主题的开发了。

### 是否支持平滑升级

// 平滑升级特性

### 页面搭建

// 搭建页面骨架的思路

### 暴露配置

// _config.yml 和 stun.yml

### 数据交互

> pug，stylus，js，_config.yml 文件之间的数据交互
> 有关 pug 需要提到的语法拓展 `script.` 等

> 要在script标签里写js代码的话，需要在script后面加个点：script.
如果只是单纯填充某个变量，用!{xxx}就行了。但是如果该变量是个对象的话，则需要通过JSON.stringify先字符串化。具体可以看上面的代码。

### 技术细节

// 说说自己使用的一些配置文件，依赖库，如何优化等

## 发布主题

`source/_data/themes.yml`

``` yaml
- name: stun
  description: A beautiful & simple theme
  link: https://github.com/liuyib/hexo-theme-stun
  preview: https://liuyib.github.io/
  tags:
    - responsive
    - beautiful
    - simple
    - two_column
```
