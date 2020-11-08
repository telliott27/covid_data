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
  "Connecticut" = "connecticut",
  "Delaware" = "delaware",
  "Florida" = "florida",
  "Georgia" = "georgia",
  "Hawaii" = "hawaii",
  "Idaho" = "idaho",
  "Illinois" = "illinois",
  "Iowa" = "iowa",
  "Louisiana" = "louisiana",
  "Michigan" = "michigan",
  "Mississippi" = "mississippi",
  "Montana" = "montana",
  "Nebraska" = "nebraska",
  "Nevada" = "nevada",
  "New Jersey" = "new_jersey",
  "New York" = "new_york",
  "North Carolina" = "north_carolina",
  "North Dakota" = "north_dakota",
  "Oklahoma" = "oklahoma",
  "South Carolina" = "south_carolina",
  "South Dakota" = "south_dakota",
  "Tennessee" = "tennessee",
  "Texas" = "texas",
  "Utah" = "utah",
  "Washington" = "washington",
  "West Virginia" = "west_virginia",
  "Wisconsin" = "wisconsin"
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
