---
title: 使用 Pjax 让你的网站实现局部刷新
date: 2019-09-24 20:49:16
tags:
  - Pjax
  - 第三方库
  - 局部刷新
categories:
  - 优化用户体验
top_image:
math: false
---

## 前言

一般情况下，当我们点击一个网页链接后，浏览器就会努力发送网络请求，然后将请求到的网页渲染出来。有时，我们经常会在一个网站中不停地点击链接，然后网页不停地跳转。通常，浏览器会对文件资源进行一定的缓存，这样使得同一个网站之间的页面跳转时，能够更快的加载。

虽然浏览的对资源的缓存加快了页面的加载速度，但是页面每一次跳转时，都会整体刷新一次，这一定程度上降低了用户体验。为了解决这一问题，我们可以使用 Pjax 来让页面不跳转进行局部刷新。

<!-- more -->

## Pjax 原理

首先要知道 `Pjax = Ajax + pushState`。当用户进行超链请求时，Pjax 会拦截请求，然后触发 Ajax 请求和 `pushState`。其中，Ajax 使你的页面局部刷新，`pushState` 用于修改 URL 而不跳转页面，从而实现不跳转页面局部刷新的功能。

## 开始使用

Pjax 有依赖和不依赖 jQuery 的两种版本：

- [defunkt/jquery-pjax](https://github.com/defunkt/jquery-pjax)【依赖于 jQuery】
- [MoOx/pjax](https://github.com/MoOx/pjax)【推荐】

这里以不依赖 jQuery 的 [MoOx/pjax](https://github.com/MoOx/pjax) 作为教程。

### 引用文件

为了方便，这里直接使用 JSDelivr 公共的 CDN 地址。

``` html
<script src="https://cdn.jsdelivr.net/npm/pjax/pjax.js"></script>
```

### 分析页面

在网站页面切换时，有些部分是不变的，有些是改变的。我们需要根据网站的 DOM 结构自行分析。举个例子，假设页面的结构如下：

``` html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Liuyib's Blog</title>
  <meta name="keywords" content="liuyib, Liuyib's Blog">
</head>
<body>
  <header id="header" class="header">
    顶部栏...
  </header>
  <main id="main" class="main">
    主体部分...
  </main>
  <footer id="footer" class="footer">
    底部栏...
  </footer>
</body>
</html>
```

每次切换页面时，`title` 会随之改变，`header` 和 `footer` 一般不变，而 `main` 是网站的主体部分，也会改变。因此，我们可以这样来使用 Pjax：

``` js
var pjax = new Pjax({
  // 这里填写页面不变的部分（和 CSS 选择器用法一样）
  selectors: [
    "head title",
    "#main"
  ]
})
```

这样，就实现了一个最简单的 Pjax 网站，不过这才刚开始。下面是一些常用的参数：

- `elements`：默认值 `a[href], form[action]`

  指定应用 Pjax 的链接。

- `switches`：默认值 `{}`

  使用旧元素替换新元素。

- `history`：默认值 `true`

  是否启用 `pushState`。禁用后 Pjax 就变成了 Ajax。

- `scrollTo`：默认值 `0`

  页面切换后到顶部的距离。设为 `false` 表示页面保持在切换前的位置。

- `scrollRestoration`：默认值 `true`

  切换页面后，Pjax 将尝试恢复滚动位置。

- `cacheBust`：默认值 `true`

  是否在 URL 上添加时间戳，防止浏览器缓存。

更多参数，请查看 MoOx/pjax 项目的 [READMD](https://github.com/MoOx/pjax)。

### 添加进度条

使用了 Pjax 后，在进行页面跳转时，浏览器没有任何加载提示，并且在跳转完成之前，页面不会有任何变化，因此在网速比较慢的情况下，我们可能会以为页面并没有进行跳转。为了改善体验，可以添加一个进度条，以此来告诉用户“页面正在加载”。

说到这里，就不得不提到 Github 的加载进度条。如果心细的同学可能会发现，Github 也使用了 Pjax。那么下面我们仿照 Github 来实现一个 Pjax 加载进度条吧。

首先要清楚一点，这里要实现的加载进度条实际上是**假的**，也就是说，页面实际加载了多少我们并没有办法知道，进度条也只是按照一定的速度增加的。

> 如果可以控制服务端的话，可以做出**真的**加载进度条，至少在 Github Pages 上还做不到。

HTML(Pug):

``` html
div.loading-bar
  div.progress
```

CSS(Stylus):

``` css
.loading-bar {
  position: fixed;
  top: 0;
  left: 0;
  z-index: 99999;
  opacity: 0;
  transition: opacity .4s linear;

  .progress {
    position: fixed;
    top: 0;
    left: 0;
    width: 0;
    height: 2px;
    background-color: #77b6ff;
    box-shadow: 0 0 10px rgba(119, 182, 255, .7);
  }

  &.loading {
    opacity: 1;
    transition: none;

    .progress {
      transition: width .4s ease;
    }
  }
}
```

JavaScript:

``` js
var loadingBar = document.querySelector('.loading-bar');
var progress = document.querySelector('.loading-bar .progress');
var timer = null;

// 通过 Pjax 切换页面开始时执行的函数
document.addEventListener('pjax:send', function (){
  // 进度条默认已经加载 20%
  var loadingBarWidth = 20;
  // 进度条最大增加的宽度
  var MAX_LOADING_WIDTH = 95;

  // 显示进度条
  loadingBar.classList.add('loading');
  // 初始化进度条的宽度
  progress.style.width = loadingBarWidth + '%';

  clearInterval(timer);
  timer = setInterval(function () {
    // 进度条的增长速度（可以改为一个随机值，显得更加真实）
    loadingBarWidth += 3;

    // 当进度条到达 95% 后停止增加
    if (loadingBarWidth > MAX_LOADING_WIDTH) {
      loadingBarWidth = MAX_LOADING_WIDTH;
    }

    progress.style.width = loadingBarWidth + '%';
  }, 500);
});

// 通过 Pjax 切换页面完成之后执行的函数
document.addEventListener('pjax:complete', function () {
  clearInterval(timer);
  progress.style.width = '100%';
  loadingBar.classList.remove('loading');

  setTimeout(function () {
    progress.style.width = 0;
  }, 400);
});
```

上面的代码基本上实现了 Github 中 Pjax 加载进度条的效果，仅供参考。具体效果可以在我的[个人博客](https://liuyib.github.io/)上体验一下。

### 重载 JS 脚本

**这里的重载指的是重新加载**。由于通过 Pjax 切换的页面并没有完全刷新，浏览器不会将网页从头执行一遍，因此有些 JS 将不会生效。重载 JS 脚本大致分为三种，一种是重载 JS 函数，一种是重载整个 JS 文件，另一种是重载整个内联的 `script` 标签。

1. 重载 JS 函数

这种重载一般适用于用户自己编写的一些 JS 函数。但是具体情况比较复杂，函数要不要重载还得具体分析。下面举一些例子：

- 页面不变部分对应的事件

比如，页面顶部栏有一个搜索按钮，点击之后会弹出搜索框：

``` js
document.querySelector('.search-button').onclick = function () {
  // ...
};
```

由于页面顶部栏不变，所以其中的元素上绑定的事件仍然可以使用，这部分元素对应的 JS 事件不需要重载。

- 页面可变部分对应的事件

比如，页面主体部分是变化的，懒加载其中的图片：

``` js
var imgs = document.querySelectorAll('img.lazyload');

lazyload(imgs);
```

当通过 Pjax 切换页面后，由于主体部分改变，上述代码已经失效，因此需要进行重载。为了方便使用，我们使用函数封装一下：

``` js
function pjax_reload() {
  var imgs = document.querySelectorAll('img.lazyload');

  lazyload(imgs);
}

// 通过 Pjax 切换页面完成后，重新加载上面的函数
document.addEventListener('pjax:complete', function (){
  pjax_reload();
});
```

2. 重载整个 JS 文件

这种情况多数用于第三方文件，比如，卜算子统计的脚本、谷歌 / 百度 / 腾讯分析的脚本等，这些脚本在每一次页面加载后都需要执行。

我的做法是，在引入这些文件的标签上添加 `data-pjax` 属性，然后将具有这个属性的标签重新添加在页面中。有时候不方便在这些标签上添加额外的属性，那么你可以在这些标签外套一层标签，如 `<div class=".pjax-reload"></div>`，然后将 `.pjax-reload` 里的元素全部重新添加到页面中即可。代码示例如下。

``` html
<script src="https://cdn.jsdelivr.net/gh/sukkaw/busuanzi/bsz.pure.mini.js" data-pjax>

<div class=".pjax-reload">
  <script src="https://www.google-analytics.com/analytics.js"></script>
</div>
```

``` js
// jQuery 写法
$('script[data-pjax], .pjax-reload script').each(function () {
  $(this).parent().append($(this).remove());
});

// 原生 JS 写法
document.querySelector('script[data-pjax], .pjax-reload script').forEach(function (elem) {
  var id = element.id || '';
  var src = element.src || '';
  var code = element.text || element.textContent || element.innerHTML || '';
  var parent = element.parentNode;
  var script = document.createElement('script');

  parent.removeChild(element);

  if (id !=='') {
    script.id = element.id;
  }

  if (src !== '') {
    script.src = src;
    script.async = false;
  }

  if (code !== '') {
    script.appendChild(document.createTextNode(code));
  }

  parent.appendChild(script);
});
```

看到两种写法的差距，感觉整个人都不好了。

3. 重载整个 `script` 标签

这种情况和前面类似，如果一些 JS 脚本写在 `script` 标签中，并且需要重载，可以选择直接重载整个 `script` 标签。具体做法和上一步相同，在标签上添加 `data-pjax` 属性后，进行操作即可。

## 总结

本文主要介绍了 Pjax 的基本用法，以及一些常见问题的解决方法。到这里，你的网站应该就可以正常的使用 Pjax 了。

---

参考链接：

- [pjax 是如何工作的？](https://www.zhihu.com/question/20289254)
- [让你的网站实现 PJAX 无刷新](https://paugram.com/coding/add-pjax-to-your-website.html)
