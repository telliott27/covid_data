library(tidyverse)
library(lubridate)
library(here)

source(here("get_data.R"))

rmarkdown::render(
  input = here("index.Rmd"),
  output_format = "github_document",
  envir = new.env()
)

the_states <- list(
  "Alabama" = "alabama",
  "Arizona" = "arizona",
  "Arkansas" = "arkansas",
  "California" = "california",
  "Florida" = "florida",
  "Georgia" = "georgia",
  "Michigan" = "michigan",
  "New York" = "new_york",
  "North Carolina" = "north_carolina",
  "Oklahoma" = "oklahoma",
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
}

rmarkdown::render(
  input = here("README.Rmd"),
  output_format = "github_document",
  envir = new.env()
)
