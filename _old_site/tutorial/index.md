---
layout: newframe-bare
title: Tutorial
categories: tutorial
---
<link href="{{ site.baseurl }}/tutorial/tutorials.css" rel="stylesheet" type="text/css">

<div id="app" class="shrinkHeader alwaysShrinkHeader">
  <div id="main">
    {% include header.html %}
    <header class="section-gs tutorial-header">
      <div class="container-gs">
        <div class="row-gs">
          <div class="header-col">
            <h1>Shiny Learning Resources</h1>
            <p>The resources on this page are designed for you to learn at your own pace. It doesn’t matter if you're new and want to learn the basics or if you’re a seasoned veteran looking to go deeper &mdash; you’ve come the right place!</p>
            <ul class="page-anchors list-unstyled">
              <li><a href="#get-started"><img src="/tutorial/images/icon-start-lg.png" alt="Get Started Button" /><span>Get Started</span></a></li>
              <li><a href="#level-up"><img src="/tutorial/images/icon-lvl-up-lg.png" alt="Level Up Button" /><span>Level Up</span></a></li>
              <li><a href="#deep-dive"><img src="/tutorial/images/icon-deep-dive-lg.png" alt="Deep Dive Button"/><span>Dive Deep</span></a></li>
            </ul>
          </div>
          <div class="header-col">
            <img class="shiny-app" src="/tutorial/images/shiny-covid-app-covid.png" alt="Shiny App - COVID Tracker" />
            <img class="shiny-app" src="/tutorial/images/shiny-covid-app-pancreatic-cancer.png" alt="Shiny App - Pancreatic Cancer" />
          </div>
        </div>
      </div><!-- Container End -->
    </header>
    <div id="get-started" class="section-gs">
      <div class="container-gs">
        <div class="row-gs intro-container">
          <img src="/tutorial/images/icon-start-lg.png" alt="Get Started Icon"/>
          <h2>Brand new to Shiny?</h2>
          <p class="intro">No worries! Here are some of our favorite resources to get you on your way.
          </p>
        </div><!-- Row End -->
        <div class="row-gs classes">
          <div class="col-6 class-tile-container ">
            <div class="class-tile">
              <div class="class-tile--icon-title">
                <img src="/tutorial/images/icon-get-started-app.png" alt="Icon - Getting Started - Projects and Apps" />
                <h5>Get Started</h5>
              </div>
              <h3>Shiny Basics</h3>
              <p> 
              A step by step tutorial that takes you through the fundamental concepts in Shiny. Each of the seven lessons takes about 20 minutes and teaches one new Shiny skill.</p>
              <a class="primary-btn" href="https://shiny.rstudio.com/tutorial/written-tutorial/lesson1/">Get Started</a>
            </div>
          </div>
          <div class="col-6 class-tile-container ">
            <div class="class-tile">
              <div class="class-tile--icon-title">
                <img src="/tutorial/images/icon-get-started-lessons.png" alt="Icon - Getting Started - Lessons" />
                <h5>Get Started</h5>
              </div>
              <h3>Build an App</h3>
              <p>Take what you learned in Shiny Basics and apply it to build an IMDB movie database app, while also picking up a new suite of skills along the way.
</p>
              <a class="primary-btn" href="https://rstudio-education.github.io/shiny-course/">Get Started</a>
            </div>
          </div>
        </div><!-- Row End -->
      </div>
    </div>
    <div id="level-up" class="section-gs shade">
      <div class="container-gs">
        <div class="row-gs intro-container">
          <img src="/tutorial/images/icon-lvl-up-lg.png" alt="Level Up Icon"/>
          <h2>Looking to level up?</h2>
          <p class="intro">We've got you covered. Here are resources designed to enhance your knowledge base.</p>
        </div><!-- Row End -->
        <div class="row-gs classes">
          <div class="col-4 class-tile-container">
            <div class="class-tile">
              <div class="class-tile--icon-title">
                <img src="/tutorial/images/icon-level-up-mastering.png" alt="Icon - Level Up - Mastering" />
                <h5>Level Up</h5>
              </div>
              <h3>Mastering Shiny</h3>
              <p>A free, online book by Hadley Wickham designed to take you from basic Shiny to creating your own customized apps. </p>
              <a class="primary-btn" href="https://mastering-shiny.org/" target="_blank">Read Now</a>
            </div>
          </div>
          <div class="col-4 class-tile-container">
            <div class="class-tile">
              <div class="class-tile--icon-title">
                <img src="/tutorial/images/icon-level-up-video.png" alt="Icon - Level Up - Mastering" />
                <h5>Level Up</h5>
              </div>
              <h3>Shiny Video Series</h3>
              <p>Get to know the Shiny team as they create and explain projects ranging from a deep dive into their favorite package, to building interactive games with Shiny, and everything in between! </p>
              <a class="primary-btn" href="https://www.youtube.com/playlist?list=PL9HYL-VRX0oRbLoj3FyL5zeASU5FMDgVe">Start Watching</a>
            </div>  
          </div>
          <div class="col-4 class-tile-container">
            <div class="class-tile">
              <div class="class-tile--icon-title">
                <img src="/tutorial/images/icon-level-up-workshop.png" alt="Icon - Level Up - Mastering" />
                <h5>Level Up</h5>
              </div>
              <h3>Shiny Workshop Series</h3>
              <p>Hear directly from Joe Cheng, Winston Chang and Garrett Grolemund about the core concepts that make Shiny tick.</p>
              <a class="primary-btn" href="/tutorial/workshop-series/">Start Watching</a>
            </div>
          </div>
        </div><!-- Row End -->
      </div>
    </div>
    <div id="deep-dive" class="section-gs">
      <div class="container-gs">
        <div class="row-gs intro-container">
          <img src="/tutorial/images/icon-deep-dive-lg.png" alt="Deep Dive Icon"/>
          <h2>Ready to dive deep?</h2>
          <p class="intro">Find everything you need. Here are our articles, stories, and documentation.</p>
        </div>
        <div class="row-gs classes">
          <div class="col-4 class-tile-container">
            <div class="class-tile">
              <div class="class-tile--icon-title">
                <img src="/tutorial/images/icon-deep-dive-articles.png" alt="Icon - Deep Dive - Newspaper" />
                <h5>Deep Dive</h5>
              </div>
              <h3>Shiny Articles</h3>
              <p>Written tutorials ranging from beginner to intermediate, covering every step of the Shiny app development pipeline.</p>
              <a class="primary-btn" href="/articles/">Start Learning</a>
            </div>
          </div>
          <div class="col-4 class-tile-container">
            <div class="class-tile">
              <div class="class-tile--icon-title">
                <img src="/tutorial/images/icon-deep-dive-stories.png" alt="Icon - Level Up - Mastering" />
                <h5>Deep Dive</h5>
              </div>
              <h3>App Stories</h3>
              <p>See demonstrations of new and advanced Shiny features in the context of real-world applications.</p>
              <a class="primary-btn" href="/app-stories/">Start Reading</a>
            </div>
          </div>
          <div class="col-4 class-tile-container">
            <div class="class-tile">
              <div class="class-tile--icon-title">
                <img src="/tutorial/images/icon-deep-dive-references.png" alt="Icon - Deep Dive - Magnifying Glass" />
                <h5>Deep Dive</h5>
              </div>
              <h3>References</h3>
              <p>Here you can find upgrade notes and function references for the most recent and previous versions of the Shiny package.</p>
              <a class="primary-btn" href="/reference/shiny/">Start Exploring</a>
            </div>
          </div>
        </div><!-- Row End -->
      </div>
    </div>
    <!-- rstudio footer -->
    <div id="rStudioFooter" class="band">
      <div class="bandContent">
        <div id="copyright">
          <div>Proudly supported by <a href="https://www.posit.co/"><img src="/images/posit-logo-white-tm.svg" alt="Posit" width="80" style="padding-left: 3px;vertical-align:text-top;"></a></div>
        </div>
        <div id="logos">
          <a href="https://twitter.com/rstudio" class="footerLogo twitter"></a>
          <a href="https://github.com/rstudio" class="footerLogo gitHub"></a>
          <a href="https://www.linkedin.com/company/rstudio-pbc/" class="footerLogo linkedIn"></a>
          <a href="https://www.facebook.com/rstudiopbc/" class="footerLogo facebook"></a>
        </div>
      </div>
    </div>

  </div><!-- Main End -->
</div><!-- #app end -->  

