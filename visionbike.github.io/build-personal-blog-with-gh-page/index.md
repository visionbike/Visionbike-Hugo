# Build Personal Blog With Github-Page


Writing a personal blog is an exciting hobby when I can write my idea, take notes and share them with everyone. But no one wants to spend too much time building everything from scratch. After some searching, I got to know there are several static site generators out there, and the most used generators are Jekyll, Hexo, and Hugo. All of them work perfectly with GitHub Pages. I chose Hugo as my site generator, and it worked perfectly.

Hugo is a static site generator written in Go. It is “the world’s fastest framework for building websites”, as stated in the [official website](https://gohugo.io) and after using it I’ve nothing to complain about the speed.

Besides, building a blog with Hugo is simple and easy. Here is how:

## 1. Requirements

You can install latest version of [:(far fa-file-archive fa-fw): Hugo (> 0.62.0)](https://gohugo.io/getting-started/installing/) for your OS (**Windows**, **Linux**, **macOS**).

{{< admonition note "Why not support earlier versions of Hugo?" >}}
Since [Markdown Render Hooks](https://gohugo.io/getting-started/configuration-markup#markdown-render-hooks) was introduced in the [Hugo Christmas Edition](https://gohugo.io/news/0.62.0-relnotes/), this theme only supports Hugo versions above **0.62.0**.
{{< /admonition >}}

{{< admonition tip "Hugo extended version is recommended" >}}
Since some features of this theme need to processes :(fab fa-sass fa-fw): SCSS to :(fab fa-css3 fa-fw): CSS, it is recommended to use Hugo **extended** version for better experience.
{{< /admonition >}}

I am using Ubuntu and the installation is quite simple:

```bash
sudo apt install hugo
```

To check the installation:

```bash
hugo version
```

The Hugo version should show up if the installation is successful.

## 2. Build Local Project And Connect To Github

The following steps are here to help you initialize your new website on the local machine and instruct you to store the source code and deploy your website.

### 2.1. Create The Project In Local Machine

Hugo provides a `new` command to create a new website:

```bash
hugo new [USERNAME]-Hugo
```

![](create-local-hugo-project.png)

{{< admonition note "What is [USERNAME]?" >}}
`[USERNAME]` is the your Github's username.
{{< /admonition >}}

### 2.2. Create Necessary Repositories On GitHub

First, your need to create a new repository on GitHub with `[USERNAME].github.io`. This repository is the place to host your GitHub page.

![](create-host-repository.png)

You also need a repository on Github to store your souce code and it also help you to automatic deploy your website via `submodule`. The source code repository should be named as `[USERNAME]-Hugo` for easily memorizing.

![](create-source-code-repository.png)

{{< admonition tip >}}
If you create a repository **without** a README file, it will be easy to avoid accidental history conflicts when pushing a local project to a fresh repo. We can always add one later.
{{< /admonition >}}

### 2.3. Install the Theme

Hugo provides plenty of free themes to decorate your website and make the configuration even more easier. You can access free Hugo themes via [this website](https://themes.gohugo.io/).

In my blog, I chose the [**LoveIt**](https://github.com/dillonzq/LoveIt) theme because of its style and awesome features. To use the theme, you have to download its source code and locate the folder in `themes`.

```bash
git init
git submodule add https://github.com/dillonzq/LoveIt.git themes/LoveIt
```

### 2.4. Basic Configuration

The following is a basic configuration for the my website, just modify as you want:

```toml
# base URL
baseURL = "https://[USERNAME].github.io"
# site publish directory
publishdir = "[USERNAME].github.io"
# language code
languageCode = 'en-us'
# site title
title = "[USERNAME]"
# site theme
theme = "LoveIt"
themedir = "themes"
```

{{< admonition tip >}}
You should name `publishdir` as your hosting repository's name, it will store your generated website. It will be setup as an submodule to live deploy your website to GitHub page.
{{< /admonition >}}

You can read more the [**LoveIt**](https://hugoloveit.com/categories/documentation/) documentation to customize your wesite as your want.

### 2.5. Link Local Project to Repositories

Before linking your Hugo project, add our hosting submodule to the project. Our goal is to separate the commit histories of our project source and our site built output to the `publishdir` directory.

```bash
git submodule add https://github.com/[USERNAME]/[USERNAME].github.io.git /[USERNAME].github.io
```

Let’s do a quick site build just to put something into the remote GitHub repo.

```bash
# 1. Perform a site build and output to 'public/' directory.
> hugo

# 2-4.
> cd [USERNAME].github.io
> git add .
> git commit -m "first build"

# 5. Return to the project root.
> cd ../

# 6-7.
> git add .
> git commit -m "first build - update submodule reference"

# 8. Push the source project *and* the public submodule to GitHub together.
> git push -u origin master --recurse-submodules=on-demand
```

{{< admonition note >}}
It is super important when we build to make sure that we commit and push both the `[USERNAME].github.io` submodule and the main project. For each submodule commit, the project updates its reference to the submodule to maintain its connection to the correct commit. The `--recurse-submodules=on-demand` command pushes all of the project modules at the same time.
{{< /admonition >}}

You can read more in [this website](https://dev.to/aormsby/how-to-set-up-a-hugo-site-on-github-pages-with-git-submodules-106p) to know the benefits and drawbacks when using submodule to deploy the GitHub page.

### 2.6. Create Your First Post

Here is the way to create your first post:

```bash
hugo new posts/first_post.md
```

Feel free to edit the post file by adding some sample content and replacing the title value in the beginning of the file.

{{< admonition note >}}
By default all posts and pages are created as a draft. If you want to render these pages, remove the property `draft: true` from the metadata, set the property `draft: false` or add `-D`/`--buildDrafts` parameter to `hugo server` command.

To test the website on local machine, you can run the following command:
```bash
hugo server -D --disableFastRender
```
{{< /admonition >}}

After completion, you just follow the instrustion in **Section 2.5** to publish the post. To custom your post, you can read more [the document](https://hugoloveit.com/theme-documentation-content/) of LoveIt Theme.
