---
title: 优雅的修改他人贡献的 Pull Request
date: 2020-09-19 17:14:08
tags:
  - Github
  - Git
categories:
  - 版本控制
top_image: /assets/banner/add-commits-to-others-pr/banner.png
---

2019 年，我在 Github 上开源了自己的第一个开源项目 [hexo-theme-stun](https://github.com/liuyib/hexo-theme-stun)。它是一个基于 Hexo 博客框架的主题，虽然没有很出众，但是我在一直维护。值得庆幸的是，有许多 Github 用户为这个项目贡献了 Pull Request。

有时，他人提出的 Pull Request 并不能直接被接纳，需要一些小的调整：修改错别字、调整代码逻辑、完善文档等等。最直接的，我们可以通过评论，要求贡献者修改。但沟通是有成本的，而且往往不够及时。

有没有更便捷的方法？直接将自己的 Commits 追加到某个 Pull Request 中？答案是肯定的。

## Step 1: 克隆项目

首先，将自己的项目克隆下来。

```bash
$ git clone git@github.com:liuyib/trial-test.git
```

## Step 2: 添加新的 Remote

为了查看或修改他人的 Fork，你应该把他们的 Fork 作为一个 Remote 添加到本地仓库。

```bash
$ git remote add EvanOne0616 https://github.com/EvanOne0616/trial-test.git
```

现在，当你执行 `git remote -v` 指令时，就可以看到他人的 Fork 成为了你的 Remote 之一：

```
sites/git/trial-test on master ➜ git remote -v
EvanOne0616     https://github.com/EvanOne0616/trial-test.git (fetch)
EvanOne0616     https://github.com/EvanOne0616/trial-test.git (push)
origin  git@github.com:liuyib/trial-test.git (fetch)
origin  git@github.com:liuyib/trial-test.git (push)
```

## Step 3: 拉取新的 Remote

```bash
$ git fetch EvanOne0616
```

## Step 4: 切换到他们的分支

你需要确认一下，贡献者提出 Pull Request 时所用的分支（如果你不确定他们使用的哪个分支，请看 Pull Request 顶部的信息）：

![PR Meta Info](/assets/banner/add-commits-to-others-pr/pr-meta-info-branch.png)

在本地，给该分支起一个不重复的名字，例如 `EvanOne0616-patch`，然后切换到贡献者 Fork 的分支：

```bash
$ git checkout -b EvanOne0616-patch EvanOne0616/patch-1
```

## Step 5: 提交修改，推送远程

在本地进行你想要的修改，提交 Commit 后，推送到贡献者的 Fork：

```bash
$ git commit -m "Fix the wrong spelling of the word"
$ git push EvanOne0616 HEAD:patch-1
```

最后，如果一些顺利，你将看到你的 Commit 出现在 Pull Request 的后面：

![Modify Others PR](/assets/banner/add-commits-to-others-pr/add-commit-to-others-pr.png)

## 总结上文

为了降低文章的阅读难度，上文详述了指令的具体操作，这里进行总结：

```bash
# 克隆自己的仓库
$ git clone git@github.com:liuyib/trial-test.git

# 将贡献者 Fork 的仓库地址，添加为新的 Remote
$ git remote add EvanOne0616 https://github.com/EvanOne0616/trial-test.git

# 拉取贡献者的 Commit
$ git fetch EvanOne0616
# 切换到提出 Pull Request 所用的分支
$ git checkout -b EvanOne0616-patch EvanOne0616/patch-1

# 你在本地修改代码，然后提交
$ git add .
$ git commit -m "Add some changes"

# 将 Commit 提交到贡献者 Fork 的仓库
$ git push EvanOne0616 HEAD:patch-1
```

## 其他方式

### 命令行方式

与上文的操作类似，有另一组指令操作也可以实现同样的效果：

```bash
# 克隆自己的仓库
$ git clone git@github.com:liuyib/trial-test.git

# 拉取 PR（其中 patch-1 为提出 PR 的分支名，411 是 PR 的 ID）
$ git pull origin pull/411/head:patch-1
# 切换到该分支
$ git checkout patch-1

# 你在本地修改代码，然后提交
$ git add .
$ git commit -m "Add some changes"

# 将贡献者 Fork 的仓库地址，添加为新的 Remote
$ git remote add EvanOne0616 https://github.com/EvanOne0616/trial-test.git
# 将 Commit 提交到贡献者 Fork 的仓库
$ git push EvanOne0616 patch-1
```

### 图形化方式

对于上述两种指令操作，开发者可以根据个人喜好自行选择。但是如果需要经常修改他人贡献的 Pull Request，不管哪一种指令操作，都难免会显得有些繁琐。因此，我们需要一种更为简便的方式 —— 图形化操作。

TODO

---

参考资料：

- [Adding Commits to Someone Else's Pull Request](https://tighten.co/blog/adding-commits-to-a-pull-request/)
- [如何修改人家贡献的 PR，不想先合并再修改](https://d.cosx.org/d/420363-pr)
