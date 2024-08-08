---
layout: upgrade-note
title: Upgrade notes for Shiny 0.11
---

Shiny 0.11 switches away from the Bootstrap 2 web framework to the next version, Bootstrap 3. This is in part because Bootstrap 2 is no longer being developed, and in part because it allows us to tap into the ecosystem of Bootstrap 3 themes.


## Known issues for migration

<ul>
  <li markdown="1" style="padding-bottom: 10px;">In Bootstrap 3, images in `<img>` tags are no longer automatically scaled to the width of their container. If you use `img()` in your UI code, or `<img>` tags in your raw HTML source, it's possible that they will be too large in the new version of Shiny. To address this you can add the `img-responsive` class:

{% highlight r %}
img(src = "picture.png", class = "img-responsive")
{% endhighlight %}

The R code above will generate the following HTML:
    
{% highlight html %}
<img src="picture.png" class="img-responsive">
{% endhighlight %}

  <li markdown="1" style="padding-bottom: 10px;">The sliders have been replaced. Previously, Shiny used the [jslider](https://github.com/egorkhmelev/jslider) library, but now it uses [ion.RangeSlider](https://github.com/IonDen/ion.rangeSlider). The new sliders have an updated appearance, and they have allowed us to fix many long-standing interface issues with the sliders.

  * The `sliderInput()` function no longer uses the `format` or `locale` options. Instead, you can use `pre`, `post`, and `sep` options to control the prefix, postfix, and thousands separator.

  * `updateSliderInput()` can now control the min, max, value, and step size of a slider. Previously, only the value could be controlled this way, and if you wanted to change other values, you needed to use Shiny's dynamic UI.
    
  <li markdown="1" style="padding-bottom: 10px;">If in your HTML you are using custom CSS classes that are specific to Bootstrap, you may need to update them for Bootstrap 3. See the Bootstrap [migration guide](http://getbootstrap.com/migration/).
{::nomarkdown}</ul>{:/nomarkdown}

If you encounter other migration issues, please let us know on the [shiny-discuss](https://groups.google.com/forum/#!forum/shiny-discuss) mailing list, or on the Shiny [issue tracker](https://github.com/rstudio/shiny/issues).


## Using shinybootstrap2

If you would like to use Shiny 0.11 with Bootstrap 2, you can use the **shinybootstrap2** package. Installation and usage instructions are on available on the [project page](https://github.com/rstudio/shinybootstrap2). We recommend that you do this only as a temporary solution because  future development on Shiny will use Bootstrap 3.


## Installing an older version of Shiny

If you want to install a specific version of Shiny other than the latest CRAN release, you can use the `install_version()` function from devtools:

{% highlight r %}
# Install devtools if you don't already have it:
install.package("devtools")

# Install the last version of Shiny prior to 0.11
devtools::install_version("shiny", "0.10.2.2")
{% endhighlight %}


## Themes

Along with the release of Shiny 0.11, we've packaged up some Bootstrap 3 themes in the [shinythemes](http://rstudio.github.io/shinythemes/) package. This package makes it easy to use Bootstrap themes with Shiny.
