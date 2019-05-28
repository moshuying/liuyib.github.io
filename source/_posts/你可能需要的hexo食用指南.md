---
title: 你可能需要的hexo食用指南
date: 2019-05-28 13:01:42
tags:
  - hexo
---

## 前言

为什么要写这篇文章？简单来说，是当做我开发的 hexo 主题 -- [stun](https://github.com/liuyib/hexo-theme-stun) 说明文档的一部分。

记得我当初第一次用 hexo 搭建网站时，和其他人一样，遇到很多坑，其中有很多坑看看 hexo 文档就能解决。但是对于不了解 hexo 的同学来说，直接去看文档的话，看完也不知道怎么用。不看的话，只要遇到问题时，第一反应就是主题的问题，于是就会去主题的使用文档里找答案，如果看完使用文档没有解决问题，就可能会去向主题开发者寻求帮助，甚至是通过 issue 提问。通过这种做法，问题得不到有效的解决，而且在 issue 里询问有关使用上的问题，是一种不太好的行为（没有使用文档除外）。

除了 hexo 的重度使用者和 hexo 的主题开发者以外，能主动去阅读 hexo 文档的人很少，毕竟 hexo 的文档写的挺烂的。所以这篇文章会讲一些使用 hexo 过程中可能会遇到的一些问题，目的是帮助主题开发者减少回答 issue 里的 hexo 使用问题。

## 摘要

在 markdown 源文件中添加代码 `<!-- more -->`，之前的部分将会成为文章摘要。这是 hexo 提供语法，只要添加了这个代码，hexo 就会将前面的内容解析为摘要。

能不能让主题自动保留摘要，比如，前三百字显示为摘要？

目前 stun 还不支持，我尝试开发这个功能，但是效果不好，现在先将其保留为一个 features。

## 引用


markdown 中的尖括号语法（ `>` ）提供了引用最基本的用法。但是如果想要添加作者、来源和来源链接就需要用到 hexo 提供的语法。

```
{% blockquote [author[, source]] [link] [source_link_title] %}
content
{% endblockquote %}
```

示例

- 添加作者和来源

```
{% blockquote liuyib, hexo theme stun %}
hello stun
{% endblockquote %}
```

{% blockquote liuyib, hexo theme stun %}
hello stun
{% endblockquote %}

- 添加作者、来源链接

```
{% blockquote liuyib https://github.com/liuyib/hexo-theme-stun %}
hello stun
{% endblockquote %}
```

{% blockquote liuyib https://github.com/liuyib/hexo-theme-stun %}
hello stun
{% endblockquote %}

- 添加作者、自定义来源链接的文字

```
{% blockquote liuyib https://github.com/liuyib/hexo-theme-stun hexo-theme-stun %}
hello stun
{% endblockquote %}
```

{% blockquote liuyib https://github.com/liuyib/hexo-theme-stun hexo-theme-stun %}
hello stun
{% endblockquote %}

当然，如果你说，想要添加作者和链接，直接添加文字多方便，用得着多记一个语法吗。这没问题，按照你喜欢的来即可。

## 代码块

如果只是显示代码（或指定语言进行高亮），直接用 markdown 的**反引号**语法即可。如果想要代码所在文件名，那就需要使用 hexo 提供的语法了。

示例

{% codeblock &emsp; lang:js https://underscorejs.org/#compact Underscore.js %}
/**
 * Debounce
 * @param {Object} func Callback function
 * @param {Number} wait Waiting time
 * @param {Number} immediate Time interval for immediate run
 */
function debounce(func, wait, immediate) {
  var timeout;
  return function() {
    var context = this;
    var args = arguments;
    var later = function() {
      timeout = null;
      if (!immediate) func.apply(context, args);if (!immediate) func.apply(context, args);if (!immediate) func.apply(context, args);if (!immediate) func.apply(context, args);if (!immediate) func.apply(context, args);if (!immediate) func.apply(context, args);
    };
    var callNow = immediate && !timeout;
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
    if (callNow) func.apply(context, args);
  };
}

var aa = () => {
  console.log(1);
};

var a = [0, 1];

console.log(123);

try {
    if (cls.search(/\bno\-highlight\b/) != -1)
      return process(block, true, 0x0F) +
             ` class="${cls}"`;
  } catch (e) {
    /* handle exception */
  }
{% endcodeblock %}

- 显示代码所在文件名

```
{% codeblock Underscore.js lang:js https://underscorejs.org/#compact Underscore.js %}
_.compact([0, 1, false, 2, '', 3]);
=> [1, 2, 3]
{% endcodeblock %}
```

效果如下

{% codeblock Underscore.js lang:js https://underscorejs.org/#compact Underscore.js  %}
_.compact([0, 1, false, 2, '', 3]);
=> [1, 2, 3]
{% endcodeblock %}

- 显示代码所在文件的链接

```
{% codeblock &emsp; lang:js https://underscorejs.org/#compact Underscore.js %}
_.compact([0, 1, false, 2, '', 3]);
=> [1, 2, 3]
{% endcodeblock %}
```

效果如下

{% codeblock &emsp; lang:js https://underscorejs.org/#compact Underscore.js %}
_.compact([0, 1, false, 2, '', 3]);
=> [1, 2, 3]
{% endcodeblock %}

> `&emsp;` 作为占位符（可以是其他字符，如果添加注释，就不需要这个占位符了），否则后面的链接会被认为是第二个参数。

按照上面这样做的好处是，这是 hexo 提供的语法，只要你使用的主题遵循它，那么当你切换主题时，你的 markdown 文档都是可以正常显示的。

## 关于图片

- 插入指定大小的图片

语法

```
{% img [class names] /path/to/image [width] [height] [title text [alt text]] %}
```

示例

```
{% img /imgs/my_avatar.jpg 100 100 my avatar %}
```

效果如下

{% img /imgs/my_avatar.jpg 100 100 my avatar %}

- 插入 inline 图片

// TODO ![](https://raw.githubusercontent.com/liuyib/picBed/master/hexo-blog/20190528162724.png)

## 嵌入本地代码

hexo 提供了一个嵌入本地代码的功能，如果需要，将代码文件放入放在站点目录的 `source/downloads/code` 文件夹（没有就新建一个）中，然后按照下面的方式使用。

语法

``` text
{% include_code [title] [lang:language] path/to/file %}
```

示例

``` text
{% include_code hello-stun lang:js hello-stun.js %}
```

效果

{% include_code hello-stun lang:js hello-stun.js %}
