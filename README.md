This repository contains the sources for the Shiny for R website.

## Setup and build

  1. [Install Quarto](https://quarto.org/docs/get-started/).

  2. Clone this repository:
```bash
git clone https://github.com/rstudio/shiny-dev-center.git
cd shiny-dev-center
```

  3. Run site locally

```bash
quarto preview
```

This will open a browser and show the site locally at http://localhost:1313/

**HOWEVER**, if you make changes to global options (e.g. `_quarto.yml`) you need to fully re-render your site to have all of the changes reflected. This can be accomplished with:

```bash
quarto render
```

([More about preview and render here](https://quarto.org/docs/websites/index.html#website-preview))


## Adding content

### Blog Posts

To add a blog post:

* Create a new folder in `blog/posts/`.  The folder name will be the slug of your blog post.
* Create an `index.qmd` file to write your post, and include all its resources (images, etc.) in the folder.
* The image for your post will be constrained to 1200x630px (or a smaller version of that aspect ratio) on the blog’s list page and at the top of your post. That size was chosen because this image is also used as the meta image for social media sharing. One image to rule them all.

Each `index.qmd` should have this yaml at the top, using one of Nick’s posts as an example:

```
---
title: "Weather App Story Pt. 2: Caching"
description: Here we demonstrate how the bindCache() function can greatly speed up a Shiny app with little effort.
author: Nick Strayer
date: 2021-01-22
twitter-card:
  image: caching.jpg
open-graph:
  image: caching.jpg
image: caching.jpg
imagealt: "A plot showing how much faster an app will load with caching"
---
```

### Articles

Articles are very similar to the blog posts above, though they are split into 4 sections: Start, Build, Improve, Share.

* Create a sub-folder inside one of those category folders. For example, the `debugging` folder is in ‘r/articles/improve/’
* Just like blog posts, this folder name will become the slug of your article… So the above example has the URL `https://shyr-test-center.netlify.app/r/articles/improve/debugging/`
* Add an `index.qmd` all of your article’s resources (images, etc.) to that folder.
* Your article should have this yaml at the top:
```
---
title: Debugging Shiny applications
description: Debugging Shiny applications can be challenging....
author: Bill Murray
date: 2019-10-15
---
```

* Once your article is finished, you'll need to add it to your chosen category’s yml file to have it appear on the `r/articles/` list page. This also allows you to state which subcategory you want it in (eg. The “Refactor: Code quality” subcategory of the Improve section.) This also allows you to place your article in whatever order you think it should be on the `r/articles/` list page under that subcategory.

![debugging-example](https://github.com/rstudio/shiny-dev-center/assets/5993637/547c3b5c-43de-46d2-ad96-b6663bf62481)



### Gallery applications

To add a Shiny app to the gallery:

* Create a folder in the appropriate subfolder within `r/gallery/`. (The folder name will be the slug for your gallery item.)
* Place an `index.qmd` and any other associated content (images, etc.) in your folder
* Include a title, description, and any associated links in the yaml of your `index.qmd`:

```
---
title: "Didactic modeling process: Linear regression"
description: "Users can try to perform a linear regression model based on the ordinary least squares method, step by step."
author: "Oscar Daniel Rivera Baena"
image: thumbnail.png
date: 2019-05-31
authorurl: "https://radiant-rstats.github.io/docs/"
appurl:      "https://danielrivera1.shinyapps.io/Regression2/"
sourceurl:   "https://github.com/radiant-rstats"
rscloudurl:  "https://rstudio.cloud/project/249309"
---
```
Optional yaml options:
`no-app-padding: true`: This will remove additional padding around your app inside its iframe. Defaults to false.


## Generating API reference with staticdocs

For each release of Shiny, the API reference must be generated using pkgdown. To generate it:

* Make sure you have a recent version of pkgdown:

    ```R
    install.packages('pkgdown')
    ```

* Run unit tests for Shiny (one set of tests makes sure that there are proper entries for pkgdown).
* Make a symbolic link from `./shiny_sym`, pointing to the shiny source directory.
* You must have git installed and use a `GITHUB_PAT` system environment variable.
* Run R script `source("scripts/generate_docs.R"); main()`
* Make sure _all_ the contents of `r/reference/shiny` are added and committed into the git history. You may have to add that directory with `git add -f r/reference/shiny`.

## Manually deploying the site

You should never need to do a manual deployment, but if you do, please see the “Deploy to Netlify” step in the Github Actions workflow


## Promo Materials

### Colors

Shiny’s primary color: #007BC2

Background color: #FFFFFF or #F8F8F8

### Logos

<table>
<tr>
<td>
<img alt="Logo for shiny" src="https://raw.githubusercontent.com/rstudio/hex-stickers/main/thumbs/shiny.png" width="120" height="139"><br />
  <a href="https://github.com/rstudio/hex-stickers/blob/main/PNG/shiny.png">shiny.png</a><br />
  <a href="https://github.com/rstudio/hex-stickers/blob/main/SVG/shiny.svg">shiny.svg</a>
</td>

<td>
<img alt="Shiny with Swoop" src="https://github.com/rstudio/shiny-dev-center/blob/main/images/shiny-swoop.png" width="120"><br />
  <a href="https://github.com/rstudio/shiny-dev-center/blob/main/images/shiny-swoop.png">shiny-swoop.png</a><br />
  <a href="https://github.com/rstudio/shiny-dev-center/blob/main/images/shiny-swoop.svg">shiny-swoop.svg</a>
</td>

<td>
  <img src="https://shyr-test-center.netlify.app/images/shiny-solo.png" alt="Shiny logo." width="120"><br />
<a href="https://shyr-test-center.netlify.app/images/shiny-solo.png">shiny-solo.png</a><br />
<a href="https://github.com/rstudio/shiny-dev-center/blob/main/images/shiny-solo.svg">shiny-solo.svg</a>
</td>
</tr>
</table>
