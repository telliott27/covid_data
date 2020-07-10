library(tidyverse)
library(lubridate)
library(here)

source(here("get_data.R"))

load(here("data", "covid_data.Rdata"))

rmarkdown::render(
  input = here("index.Rmd"),
  output_format = "github_document",
  envir = new.env()
)

rmarkdown::render(
  input = here("bay_area.Rmd"),
  output_format = "github_document",
  envir = new.env()
)

the_states <- list(
  "Alabama" = "alabama",
  "Alaska" = "alaska",
  "Arizona" = "arizona",
  "Arkansas" = "arkansas",
  "California" = "california",
  "Colorado" = "colorado",
  "Florida" = "florida",
  "Georgia" = "georgia",
  "Illinois" = "illinois",
  "Louisiana" = "louisiana",
  "Michigan" = "michigan",
  "Mississippi" = "mississippi",
  "Nevada" = "nevada",
  "New Jersey" = "new_jersey",
  "New York" = "new_york",
  "North Carolina" = "north_carolina",
  "Oklahoma" = "oklahoma",
  "South Carolina" = "south_carolina",
  "Tennessee" = "tennessee",
  "Texas" = "texas",
  "Utah" = "utah",
  "Washington" = "washington",
  "West Virginia" = "west_virginia"
)

for( state in seq_along(the_states) ) {
  state_name <- names(the_states[state])
  file_name <- the_states[[state]]
  rmarkdown::render(
    input = str_glue("States/state_report.Rmd"),
    output_file = file_name,
    output_format = "github_document",
    params = list(
      report_state = state_name
    ),
    envir = new.env()
  )
  Sys.sleep(1)
  knitr::knit_meta(class=NULL, clean = TRUE)
}

rmarkdown::render(
  input = here("README.Rmd"),
  output_format = "github_document",
  envir = new.env()
)
