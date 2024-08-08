---
layout:       app-showcase
title:        "City Cycle Race (with STRAVA) - Compare the cycling speed of cities"
user_name:    Sebastian Wolf
user_url:     http://medium.com/@zappingseb
date:         2019-05-31
tags:         map, cycling, strava
app_url:      https://sebastianwolf.shinyapps.io/stravachaserapp/
source_url:   https://github.com/zappingseb/stravachaser
rscloud_url:  https://rstudio.cloud/project/180441
contest:      yes
contest_year: 2019
thumbnail:    city-cycle.png
---

This shiny app allows to compare how fast people cycle in your city. This app uses data from strava to compare the cyclists in two cities. How is this possible? Strava is a sports tracking app. Basically whenever people cycle they can track themselves using GPS. Afterwards they will know how fast they went on their track. This is not comparable. Though, strava build in a feature called segments. These segments are tracks of any length all around the world. On each of these segments strava the users can have a virtual race. The time they needed for the segment is stored on a leaderboard. The fastest cyclist is the King of the Mountain on this segment. The data is available for everybody having a strava account via the strava API. This package ( + app) includes the data and allows to crawl it by certain features.
  
