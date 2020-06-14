library(tidyverse)
library(lubridate)
library(here)


source(here("get_data.R"))

rmarkdown::render(
  input = here("index.Rmd"),
  output_format = "github_document",
  envir = new.env()
)

state_rmd <- list.files(path = here("States"), pattern = "*.Rmd")

for( state in state_rmd) {
  rmarkdown::render(
    input = here("States", state),
    output_format = "github_document",
    envir = new.env()
  )
}

