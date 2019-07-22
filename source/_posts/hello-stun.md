---
title: Hello Stun
date: 2019-5-15 22:54:49
top_image: https://raw.githubusercontent.com/liuyib/picBed/master/hexo-blog/20190528163523.jpg
top: true
math: true
tags:
- hexo-theme
- stun
- demo
categories:
- [hexo-theme, stun]
- 测试文章
---

欢迎使用漂亮的 hexo 主题 [Stun](https://github.com/liuyib/hexo-theme-stun)。在这里你可以看到 Stun 的部分功能，要想查看全部功能请访问：[https://liuyib.github.io/hexo-theme-stun/zh-CN/](https://liuyib.github.io/hexo-theme-stun/zh-CN/)

如果你使用 Stun 时遇到了问题，可以在[这里](https://github.com/liuyib/hexo-theme-stun/issues)寻找答案或进行提问。当然如果你有好的建议，欢迎发起 [issue](https://github.com/liuyib/hexo-theme-stun/issues)，如果想要贡献代码，欢迎 [PR](https://github.com/liuyib/hexo-theme-stun/pulls)。

<!-- more -->

---

# hello world

## hello world

### hello world

#### hello world

##### hello world

###### hello world

## 摘要

在你文章的 markdown 源文件中，使用 hexo 提供的语法 `<!-- more -->`，之前的部分会被解析为摘要。就像这篇文章一样，这段话之前的部分会成为文章的摘要。在网站首页的文章列表中可以看到效果。

## 图片

![](https://raw.githubusercontent.com/liuyib/picBed/master/hexo-blog/20190529223722.jpg)

指定图片大小：

![](https://raw.githubusercontent.com/liuyib/picBed/master/hexo-blog/20190529223722.jpg?size=150x100)

详情请看: [设置图片大小](https://liuyib.github.io/hexo-theme-stun/zh-CN/advanced/theme-config.html#%E8%AE%BE%E7%BD%AE%E5%9B%BE%E7%89%87%E5%A4%A7%E5%B0%8F)

行内图片：![alt](https://raw.githubusercontent.com/liuyib/picBed/master/hexo-blog/20190528162724.png)

> Stun 主题中，图片的对齐方式默认是左对齐和支持行内图片。但是如果在主题配置文件中手动设置了图片的对齐方式，那么行内图片将会换行显示。

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

## Emoji 支持

- `:gem:` :gem:
- `:sparkles:` :sparkles:
- `:christmas_tree:` :christmas_tree:

依赖于插件：[hexo-filter-github-emojis](https://github.com/crimx/hexo-filter-github-emojis)，也可以通过更换 markdown 渲染器 [hexo-renderer-markdown-it-plus](https://github.com/CHENXCHEN/hexo-renderer-markdown-it-plus) 来支持 Emoji。详情请查看：[添加 Emoji 支持](https://liuyib.github.io/hexo-theme-stun/zh-CN/advanced/theme-config.html#%E6%B7%BB%E5%8A%A0-emoji-%E6%94%AF%E6%8C%81)

## 嵌入资源

详情请看：[https://hexo.io/zh-cn/docs/tag-plugins](https://hexo.io/zh-cn/docs/tag-plugins)

## 代码块

### 代码高亮

- `diff`

```diff
- alert('hello stun');
+ console.log('hello stun');
```

- `javascript`

``` javascript
function $initHighlight(block, cls) {
  try {
    if (cls.search(/\bno\-highlight\b/) != -1)
      return process(block, true, 0x0F) +
             ` class="${cls}"`;
  } catch (e) {
    /* long long long long long long long long long long long long long long long long long long long long long long comment */
  }
  for (var i = 0 / 2; i < classes.length; i++) {
    if (checkCondition(classes[i]) === undefined)
  }
}

export  $initHighlight;
```

- `...`

### 高亮风格

- `light` 风格

![](https://raw.githubusercontent.com/liuyib/picBed/master/hexo-theme-stun/doc/20190608175153.png)

- `dark` 风格

![](https://raw.githubusercontent.com/liuyib/picBed/master/hexo-theme-stun/doc/20190608175155.png)

- `ocean` 风格

![](https://raw.githubusercontent.com/liuyib/picBed/master/hexo-theme-stun/doc/20190608175154.png)

### 代码换行

- 溢出换行

![](https://raw.githubusercontent.com/liuyib/picBed/master/hexo-theme-stun/doc/20190608214540.png)

- 溢出不换行

![](https://raw.githubusercontent.com/liuyib/picBed/master/hexo-theme-stun/doc/20190608214539.png)

### 添加辅助信息

需要使用 Hexo 提供的语法，才能添加辅助信息：[https://hexo.io/docs/tag-plugins.html#Code-Block](https://hexo.io/docs/tag-plugins.html#Code-Block)

语法如下：

``` text
{% codeblock [title] [lang:language] [url] [link text] %}
code here
{% endcodeblock %}
```

效果如下：

{% codeblock $initHighlight lang:js http://underscorejs.org/#compact Underscore.js %}
_.compact([0, 1, false, 2, '', 3]);
=> [1, 2, 3]
{% endcodeblock %}

## 表格 TODO

| `:unicorn:` | `:unicorn:` | `:unicorn:` |
| :---------- | :---------: | ----------: |
| 居左        |    居中     |        居右 |
| 🦄          |     🦄      |          🦄 |

## 注脚

语法如下：

```plain
一个具有注脚的文本。[^1]

[^1]: 注脚的解释
```

效果如下：

一个具有注脚的文本。[^1]

[^1]: 注脚的解释

## Ruby 注释

利用 H5 的新标签 `<ruby>` 实现 ruby 注释（中文注音或字符）。

语法如下：

```plain
<ruby>Response<rp>(</rp><rt>响应</rt><rp>)</rp></ruby>
```

效果如下：

<ruby>Response<rp>(</rp><rt>响应</rt><rp>)</rp></ruby>

## 数学公式

> 单击公式可以复制公式源码。

- MathJax

|                   :art:                   |                   :star:                    |
| :---------------------------------------: | :-----------------------------------------: |
| $x = {-b \pm \sqrt{b^2-4ac} \over 2a}.$ | <br> `x = {-b \pm \sqrt{b^2-4ac} \over 2a}.` <br><br> |
| $f(a) = \frac{1}{2\pi i} \oint\frac{f(z)}{z-a}dz$ | <br> `f(a) = \frac{1}{2\pi i} \oint\frac{f(z)}{z-a}dz` <br><br> |
| $\cos(θ+φ)=\cos(θ)\cos(φ)−\sin(θ)\sin(φ)$ | <br> `\cos(θ+φ)=\cos(θ)\cos(φ)−\sin(θ)\sin(φ)` <br><br> |
| $\int_D ({\nabla\cdot} F)dV=\int_{\partial D} F\cdot ndS$ | <br> `\int_D ({\nabla\cdot} F)dV=\int_{\partial D} F\cdot ndS` <br><br> |
| $\sigma = \sqrt{ \frac{1}{N} \sum_{i=1}^N (x_i -\mu)^2}$ | <br> `\sigma = \sqrt{ \frac{1}{N} \sum_{i=1}^N (x_i -\mu)^2}` <br><br> |

详情请看：[https://www.mathjax.org/](https://www.mathjax.org/)

- LaTeX

这是一个行内的数学公式：$\begin{vmatrix} a & b \\ c & d\end{vmatrix}$

这个数学公式会换行显示：
$$\begin{vmatrix} a & b \\ c & d\end{vmatrix}$$

一些例子：

| :art:                                          | <center>:star: </center>                                                             | :art:                                          | <center>:star:</center>                                                              |
| :--------------------------------------------: | :------------------------------------------------------------------- | :--------------------------------------------: | :------------------------------------------------------------------- |
| $\begin{matrix} a & b \\ c & d \end{matrix}$   | <pre style="text-align: left;margin: 0;padding-left: 20px;background-color: #fff;">`\begin{matrix}` <br> &emsp; `a & b \\` <br> &emsp; `c & d` <br> `\end{matrix}`</pre> | $\begin{array}{cc} a & b \\ c & d \end{array}$ | <pre style="text-align: left;margin: 0;padding-left: 20px;background-color: #fff;">`\begin{array}{cc}` <br> &emsp; `a & b \\` <br> &emsp; `c & d` <br> `\end{array}`</pre> |
| $\begin{pmatrix} a & b \\ c & d \end{pmatrix}$ | <pre style="text-align: left;margin: 0;padding-left: 20px;background-color: #fff;">`\begin{pmatrix}` <br> &emsp; `a & b \\` <br> &emsp; `c & d` <br> `\end{pmatrix}`</pre> | $\begin{bmatrix} a & b \\ c & d \end{bmatrix}$ | <pre style="text-align: left;margin: 0;padding-left: 20px;background-color: #fff;">`\begin{bmatrix}` <br> &emsp; `a & b \\` <br> &emsp; `c & d` <br> `\end{bmatrix}`</pre> |
| $\begin{vmatrix} a & b \\ c & d\end{vmatrix}$  | <pre style="text-align: left;margin: 0;padding-left: 20px;background-color: #fff;">`\begin{vmatrix}` <br> &emsp; `a & b \\` <br> &emsp; `c & d` <br> `\end{vmatrix}`</pre> | $\begin{Vmatrix} a & b \\ c & d\end{Vmatrix}$  | <pre style="text-align: left;margin: 0;padding-left: 20px;background-color: #fff;">`\begin{Vmatrix}` <br> &emsp; `a & b \\` <br> &emsp; `c & d` <br> `\end{Vmatrix}`</pre> |
| $\begin{Bmatrix} a & b \\ c & d \end{Bmatrix}$ | <pre style="text-align: left;margin: 0;padding-left: 20px;background-color: #fff;">`\begin{Bmatrix}` <br> &emsp; `a & b \\` <br> &emsp; `c & d` <br> `\end{Bmatrix}`</pre> |  $\def\arraystretch{1.5} \begin{array}{c:c:c} a & b & c \\ \hline d & e & f \\ \hdashline g & h & i \end{array}$ | <pre style="text-align: left;margin: 0;padding-left: 20px;background-color: #fff;">`\def\arraystretch{1.5}` <br> &emsp;`\begin{array}{c:c:c}` <br> &emsp;`a & b & c \\ \hline` <br> &emsp;`d & e & f \\` <br> &emsp;`\hdashline` <br> &emsp;`g & h & i` <br> `\end{array}`</pre> |
| $\begin{aligned} a&=b+c \\ d+e&=f \end{aligned}$ | <pre style="text-align: left;margin: 0;padding-left: 20px;background-color: #fff;">`\begin{aligned}` <br> &emsp; `a&=b+c \\` <br> &emsp; `d+e&=f` <br> `\end{aligned}`</pre> | $\begin{alignedat}{2} 10&x+ &3&y = 2 \\ 3&x+&13&y = 4 \end{alignedat}$ | <pre style="text-align: left;margin: 0;padding-left: 20px;background-color: #fff;">`\begin{alignedat}{2}` <br> &emsp; `10&x+ &3&y = 2 \\` <br> &emsp; `3&x+&13&y = 4` <br> `\end{alignedat}`</pre> |
| $\begin{gathered} a=b \\ e=b+c \end{gathered}$ | <pre style="text-align: left;margin: 0;padding-left: 20px;background-color: #fff;">`\begin{gathered}` <br> &emsp; `a=b \\` <br> &emsp; `e=b+c` <br> `\end{gathered}`</pre> | $x = \begin{cases} a &\text{if } b \\ c &\text{if } d \end{cases}$ | <pre style="text-align: left;margin: 0;padding-left: 20px;background-color: #fff;">`x = \begin{cases}` <br> &emsp; `a &\text{if } b \\` <br> &emsp; `c &\text{if } d` <br> `\end{cases}`</pre> |

更多的数学公式支持，请查看：[https://katex.org/docs/supported.html](https://katex.org/docs/supported.html)
