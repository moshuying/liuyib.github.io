---
title: Hello Stun
tags:
  - hexo-theme
  - stun
  - demo
categories:
  - [hexo-theme, stun]
  - 测试文章
---

欢迎使用漂亮的 hexo 主题 [Stun](https://github.com/liuyib/hexo-theme-stun)。这是一篇展示 stun 功能的文章。在这篇文章中，你可以看到 stun 目前支持的文章解析方面的功能。想查看其他的功能，只需要尽情的浏览本站~

如果你使用 stun 时遇到了问题，可以在[这里](https://github.com/liuyib/hexo-theme-stun/issues)寻找答案或进行提问。当然如果你有好的建议，欢迎发起 [issue](https://github.com/liuyib/hexo-theme-stun/issues)，如果想要贡献代码，欢迎 [PR](https://github.com/liuyib/hexo-theme-stun/pulls)。

---

## 摘要

在你文章的 markdown 源文件中，使用 hexo 提供的语法 `<!-- more -->`，之前的部分会被解析为摘要。就像这篇文章一样，这段话之前的部分会成为文章的摘要。在网站首页的文章列表中可以看到效果。

<!-- more -->

## 图片

![](https://raw.githubusercontent.com/liuyib/picBed/master/hexo-blog/20190529223722.jpg)

## 文本

_斜体文本_

**粗体文本**

~~删除文本~~

> 引用文本

{% blockquote liuyib https://github.com/liuyib/hexo-theme-stun hexo-theme-stun %}
带有作者的引用。语法请参考：[https://hexo.io/docs/tag-plugins#Block-Quote](https://hexo.io/docs/tag-plugins#Block-Quote)
{% endblockquote %}

## 列表

### 无序列表

- 无序列表
  - 无序列表
    - 无序列表
    - 无序列表
    - 无序列表

### 有序列表

1. 有序列表 1
2. 有序列表 2
  3. 子列表
  4. 子列表
5. 有序列表 3

### 计划列表

- [ ] 计划任务
- [x] 完成任务

## 链接

文本：[stun](https://github.com/liuyib/hexo-theme-stun)

图片：
![alt](https://raw.githubusercontent.com/liuyib/picBed/master/hexo-blog/20190529124941.png)

行内图片：![alt](https://raw.githubusercontent.com/liuyib/picBed/master/hexo-blog/20190528162724.png)

> 注意：stun 主题中，图片的对齐方式默认是左对齐和支持行内图片。但是如果在主题配置文件中手动设置了图片的对齐方式，那么行内图片将会换行显示。

## 设置图片尺寸

需要使用 hexo 提供的语法（当然你也可以用 `<img>` 标签设置 CSS 属性）。

```text
{% img [class names] /path/to/image [width] [height] [title text [alt text]] %}
```

设置尺寸：

{% img https://raw.githubusercontent.com/liuyib/picBed/master/hexo-blog/20190529124941.png 60 60 %}

## 嵌入资源

- jsFiddle

[https://hexo.io/zh-cn/docs/tag-plugins#jsFiddle](https://hexo.io/zh-cn/docs/tag-plugins#jsFiddle)

嵌入 jsFiddle。

语法

```text
{% jsfiddle shorttag [tabs] [skin] [width] [height] %}
```

示例

<script async src="//jsfiddle.net/coder515/zruvekob/embed/"></script>

> 可以直接使用 jsfiddle 提供的嵌入代码，例如：`<script async src="//jsfiddle.net/usename/xxx/embed/"></script>`

- Gist

[https://hexo.io/zh-cn/docs/tag-plugins#Gist](https://hexo.io/zh-cn/docs/tag-plugins#Gist)

嵌入 Gist。

语法

```text
{% gist gist_id [filename] %}
```

示例

<script src="https://gist.github.com/liuyib/3fa0290ed2a60d106b68511bef81d0f6.js"></script>

> 可以直接使用 github 提供的嵌入代码：例如：`<script src="https://gist.github.com/username/xxx"></script>`

- Include Code

[https://hexo.io/zh-cn/docs/tag-plugins#Include-Code](https://hexo.io/zh-cn/docs/tag-plugins#Include-Code)

嵌入站点文件中的代码。代码文件放在站点目录 `source/downloads/code` 内（没有该目录就新建，名称不能变）。

语法

``` text
{% include_code [title] [lang:language] path/to/file %}
```

示例

{% include_code hello-stun lang:js hello-stun.js %}

> 路径直接写代码文件的名称即可，hexo 会自动去上面的目录下寻找你指定的文件。

- iframe

[https://hexo.io/zh-cn/docs/tag-plugins#iframe](https://hexo.io/zh-cn/docs/tag-plugins#iframe)

嵌入 iframe。

语法

```text
{% iframe url [width] [height] %}
```

- Youtube

[https://hexo.io/zh-cn/docs/tag-plugins#Youtube](https://hexo.io/zh-cn/docs/tag-plugins#Youtube)

嵌入 Youtube 视频。

语法

```text
{% youtube video_id %}
```

- 查看所有 hexo 支持的嵌入资源

[https://hexo.io/zh-cn/docs/tag-plugins](https://hexo.io/zh-cn/docs/tag-plugins)

## 代码块

### 行内代码

这是一段行内代码：`console.log('hello stun')`

### 多行代码

```js
var a = 1;
var b = 2;

console.log(a + b);
```

## 表格 TODO

| :unicorn: | :unicorn: | :unicorn: |
| :-------- | :-------: | --------: |
| 居左      |   居中    |      居右 |
| 🦄        |    🦄     |        🦄 |

## 注脚

语法

```text
一个具有注脚的文本。[^1]

[^1]: 注脚的解释
```

效果

一个具有注脚的文本。[^1]

[^1]: 注脚的解释

## Ruby 注释

利用 H5 的新标签 `<ruby>` 实现 ruby 注释（中文注音或字符）。

语法

```text
<ruby>Response<rp>(</rp><rt>响应</rt><rp>)</rp></ruby>
```

效果

<ruby>Response<rp>(</rp><rt>响应</rt><rp>)</rp></ruby>

## 关于数学公式和各种图

- LaTeX 数学公式
- 甘特图
- UML 图
- Mermaid 流程图
- Flowchart 流程图

目前 stun 还不支持这些。以后的版本中会进行选择性支持。
