# load packages ----------------------------------------------------------------

library(tidyverse)
library(glue)
library(webshot2)

# load data --------------------------------------------------------------------

# saved as txt because jekyll doesn't like csvs...
contest19 <- read_delim("_data/showcase-prep/contest19.txt", delim = "\t") %>%
  filter(
    add_to_showcase == "Yes",
    advocate_agreed == "Yes"
  )

# keyword analysis -------------------------------------------------------------

tags <- contest19 %>% 
  pull(tag) %>% 
  str_split(",") %>% 
  unlist() %>% 
  str_trim()

table(tags) %>% sort()

# showcase.yml -----------------------------------------------------------------

contest19 %>%
  group_by(category) %>%
  count(slug) %>%
  select(category, slug) %>%
  write_delim(path = "_data/showcase-prep/showcase-yml-helper.txt", delim = "\t")

# fix user URLs ----------------------------------------------------------------

contest19 <- contest19 %>%
  mutate(
    user_url_fixed = ifelse(is.na(user_url), 
                            glue("https://community.rstudio.com/u/{user_community}"),
                            user_url)
  )

# fix contest_descriotion ------------------------------------------------------

contest19 <- contest19 %>%
  mutate(
    contest_description = ifelse(is.na(contest_description), "", contest_description)
  )


# to_md: function to write each row to md --------------------------------------

to_md <- function(title, user_name, user_url_fixed,
                  tag, app_url, source_url, rscloud_url, 
                  description, contest_description, slug, 
                  contest, contest_year, path, date){
  
  glue(
    '---
  layout:       app-showcase
  title:        "{title}"
  user_name:    {user_name}
  user_url:     {user_url_fixed}
  date:         {date}
  tags:         {tag}
  app_url:      {app_url}
  source_url:   {source_url}
  rscloud_url:  {rscloud_url}
  contest:      {contest}
  contest_year: {contest_year}
  thumbnail:    {slug}.png
  ---
  
{description}
    
{contest_description}'
  ) %>%
    cat(file = glue("{path}/{date}-{slug}.md"))
  
}

# create mds -------------------------------------------------------------------

contest19_for_md <- contest19 %>%
  select(title, user_name, user_url_fixed,
         tag, app_url, source_url, rscloud_url, 
         description, contest_description, slug)

pwalk(contest19_for_md, to_md, date = "2019-05-31", path = "gallery/_posts/", contest = "yes", contest_year = "2019")

# take shots -------------------------------------------------------------------

for(i in 1:nrow(contest19)){
  webshot(url = contest19$app_url[i], 
          file = paste0("gallery/images/thumbnails/", contest19$slug[i], ".png"),
          vwidth = 1600, vheight = 900, 
          cliprect = "viewport",
          delay = 10) %>%
    resize("370x268")
  Sys.sleep(1)
  print(i)
}

# reshot apps that didn't load

webshot(url = "https://gpilgrim.shinyapps.io/SwimmingProject-Click/", 
        file = paste0("gallery/images/thumbnails/", "ncaa-swim-team-finder", ".png"),
        vwidth = 1600, vheight = 900, 
        cliprect = "viewport",
        delay = 25) %>%
  resize("370x268")

webshot(url = "https://marcus.shinyapps.io/bus_simulator", 
        file = paste0("gallery/images/thumbnails/", "bus-company-simulation", ".png"),
        vwidth = 1600, vheight = 900, 
        cliprect = "viewport",
        delay = 25) %>%
  resize("370x268")


webshot(url = "https://jennadallen.shinyapps.io/pet-records-app/", 
        file = paste0("gallery/images/thumbnails/", "dog-medical-history", ".png"),
        vwidth = 1600, vheight = 900, 
        cliprect = "viewport",
        delay = 25) %>%
  resize("370x268")

webshot(url = "https://kaplanas.shinyapps.io/living_in_the_lego_world/", 
        file = paste0("gallery/images/thumbnails/", "lego-world", ".png"),
        vwidth = 1600, vheight = 900, 
        cliprect = "viewport",
        delay = 25) %>%
  resize("370x268")

webshot(url = "https://nsgrantham.shinyapps.io/tidytuesdayrocks/", 
        file = paste0("gallery/images/thumbnails/", "tidy-tuesday", ".png"),
        vwidth = 1600, vheight = 900, 
        cliprect = "viewport",
        delay = 25) %>%
  resize("370x268")

webshot(url = "https://opndt.shinyapps.io/bloodbank_india/", 
        file = paste0("gallery/images/thumbnails/", "india-blood-banks", ".png"),
        vwidth = 1600, vheight = 900, 
        cliprect = "viewport",
        delay = 25) %>%
  resize("370x268")

webshot(url = "https://lyux.shinyapps.io/viscover/", 
        file = paste0("gallery/images/thumbnails/", "viscover", ".png"),
        vwidth = 1600, vheight = 900, 
        cliprect = "viewport",
        delay = 25) %>%
  resize("370x268")

webshot(url = "https://jgassen.shinyapps.io/expand_fuel_economy/", 
        file = paste0("gallery/images/thumbnails/", "explore-panel-data", ".png"),
        vwidth = 1600, vheight = 900, 
        cliprect = "viewport",
        delay = 25) %>%
  resize("370x268")

webshot(url = "https://kevinrue.shinyapps.io/isee-shiny-contest/", 
        file = paste0("gallery/images/thumbnails/", "isee", ".png"),
        vwidth = 1600, vheight = 900, 
        cliprect = "viewport",
        delay = 25) %>%
  resize("370x268")

webshot(url = "https://matt-kumar.shinyapps.io/visabs", 
        file = paste0("gallery/images/thumbnails/", "visual-abstracts", ".png"),
        vwidth = 1600, vheight = 900, 
        cliprect = "viewport",
        delay = 25) %>%
  resize("370x268")

webshot(url = "https://tbradley.shinyapps.io/tree-subset-shiny/", 
        file = paste0("gallery/images/thumbnails/", "phylo-tree-view-subset", ".png"),
        vwidth = 1600, vheight = 900, 
        cliprect = "viewport",
        delay = 25) %>%
  resize("370x268")

webshot(url = "https://doomlab.shinyapps.io/mote/", 
        file = paste0("gallery/images/thumbnails/", "mote-effect-size", ".png"),
        vwidth = 1600, vheight = 900, 
        cliprect = "viewport",
        delay = 25) %>%
  resize("370x268")

webshot(url = "https://cjteeter.shinyapps.io/MastersGolf/", 
        file = paste0("gallery/images/thumbnails/", "masters", ".png"),
        vwidth = 1600, vheight = 900, 
        cliprect = "viewport",
        delay = 25) %>%
  resize("370x268")

webshot(url = "https://vivekkatial.shinyapps.io/uber_shiny", 
        file = paste0("gallery/images/thumbnails/", "uber-rider", ".png"),
        vwidth = 1600, vheight = 900, 
        cliprect = "viewport",
        delay = 25) %>%
  resize("370x268")

webshot(url = "https://bbspring.shinyapps.io/App24/", 
        file = paste0("gallery/images/thumbnails/", "map-twitter-sentiment", ".png"),
        vwidth = 1600, vheight = 900, 
        cliprect = "viewport",
        delay = 25) %>%
  resize("370x268")

webshot(url = "https://gallery.shinyapps.io/nz-trade-dash/", 
        file = paste0("gallery/images/thumbnails/", "nz-trade-dash", ".png"),
        vwidth = 1600, vheight = 900, 
        cliprect = "viewport",
        delay = 25) %>%
  resize("370x268")

webshot(url = "https://abenedetti.shinyapps.io/bioNPS/", 
        file = paste0("gallery/images/thumbnails/", "biodiversity-national-parks", ".png"),
        vwidth = 1600, vheight = 900, 
        cliprect = "viewport",
        delay = 25) %>%
  resize("370x268")






