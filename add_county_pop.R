library(tidyverse)
library(lubridate)
library(here)

county_df <- read_csv(here("co-est2019-alldata.csv"))

## Convenince "Not in" operator
"%nin%" <- function(x, y) {
  return( !(x %in% y) )
}

top_n_counties <- function(data, n = 5, wt = cases, label = full_name) {
  data %>%
    group_by(full_name) %>%
    filter(date == max(date)) %>%
    ungroup() %>%
    top_n(n, wt = {{ wt }}) %>%
    pull({{ label }})
}

top_n_state <- function(data, n = 5, wt = cases) {
  data %>%
    group_by(state) %>%
    filter(date == max(date)) %>%
    ungroup() %>%
    top_n(n, wt = {{ wt }}) %>%
    pull(state)
}

bay_area <- c(
  "Alameda",
  "Contra Costa",
  "Marin",
  "Napa",
  "San Francisco",
  "San Mateo",
  "Santa Clara",
  "Solano",
  "Sonoma"
)

county_pop <- county_df %>% 
  filter(SUMLEV == "050") %>% 
  mutate(fips = str_c(STATE,COUNTY)) %>% 
  select(
    fips,
    county_name = CTYNAME, 
    STNAME, 
    population = POPESTIMATE2019)

nyt_county_data <- nytcovcounty %>% 
  left_join(county_pop, by = "fips") %>% 
  mutate(
    population = case_when(
      county == "New York City" ~ 18804000,
      county == "Kansas City" & state == "Missouri" ~ 505198,
      TRUE ~ population
    ),
    full_name = str_c(county, ", ", state)
  ) %>% 
  group_by(full_name) %>% 
  arrange(date) %>% 
  mutate(
    cases_per_capita = cases / population,
    deaths_per_capita = deaths / population,
    weekly_change = cases - lag(cases, 7),
    change_per_capita = weekly_change / population,
    percent_weekly_change = weekly_change / lag(cases, 7),
    percent_weekly_change = case_when(
      cases < 100 ~ NA_real_,
      percent_weekly_change == Inf ~ NA_real_,
      TRUE ~ percent_weekly_change
    )
  ) %>% 
  ungroup()


state_pops <- read_csv(here("state_populations.csv"))

nyt_state_df <- nytcovstate %>% 
  left_join(state_pops, by = c("state" = "State")) %>% 
  mutate(cases_per_capita = 1000 * cases / Pop) %>% 
  group_by(state) %>% 
  arrange(date) %>% 
  mutate(
    weekly_change = cases - lag(cases, 7)
  )

#' ghColors
#'
#' A named character vestor that contains the hex values of GitHub's colors from the style guide
#' @export
ghColors <- c( "grey-000" = "#FAFBFC" ,
               "grey-100" = "#F6F8FA" ,
               "grey-200" = "#E2E4E8" ,
               "grey-300" = "#D1D5DB" ,
               "grey-400" = "#949DA5" ,
               "grey-500" = "#6A737D" ,
               "grey" = "#6A737D",
               "grey-600" = "#576069" ,
               "grey-700" = "#444D56" ,
               "grey-800" = "#2F363D" ,
               "grey-900" = "#24292F" ,
               "gray-000" = "#FAFBFC" ,
               "gray-100" = "#F6F8FA" ,
               "gray-200" = "#E2E4E8" ,
               "gray-300" = "#D1D5DB" ,
               "gray-400" = "#949DA5" ,
               "gray-500" = "#6A737D" ,
               "gray-600" = "#576069" ,
               "gray-700" = "#444D56" ,
               "gray-800" = "#2F363D" ,
               "gray-900" = "#24292F" ,
               "blue-000" = "#F1F8FF" ,
               "blue-100" = "#DBEDFF" ,
               "blue-200" = "#C8E1FF" ,
               "blue-300" = "#7AB7FF" ,
               "blue-400" = "#2288FF" ,
               "blue-500" = "#0366D6" ,
               "blue" = "#0366D6",
               "blue-600" = "#005CC5" ,
               "blue-700" = "#054289" ,
               "blue-800" = "#032F62" ,
               "blue-900" = "#04264C" ,
               "green-000" = "#F0FFF4" ,
               "green-100" = "#DCFFE4" ,
               "green-200" = "#BEF5CB" ,
               "green-300" = "#85E89D" ,
               "green-400" = "#35D058" ,
               "green-500" = "#28A745" ,
               "green" = "#28A745" ,
               "green-600" = "#23863A" ,
               "green-700" = "#176F2C" ,
               "green-800" = "#155C26" ,
               "green-900" = "#144620" ,
               "purple-000" = "#F5F0FF" ,
               "purple-100" = "#E6DCFD" ,
               "purple-200" = "#D0BCF9" ,
               "purple-300" = "#B392F0" ,
               "purple-400" = "#8A63D2" ,
               "purple-500" = "#6F42C1" ,
               "purple" = "#6F42C1" ,
               "purple-600" = "#5A32A3" ,
               "purple-700" = "#4C2789" ,
               "purple-800" = "#3A1D6E" ,
               "purple-900" = "#29134E" ,
               "yellow-000" = "#FFFDEF" ,
               "yellow-100" = "#FEFBDD" ,
               "yellow-200" = "#FEF5B1" ,
               "yellow-300" = "#FFEA7F" ,
               "yellow-400" = "#FFDF5E" ,
               "yellow-500" = "#FFD33D" ,
               "yellow" = "#FFD33D" ,
               "yellow-600" = "#F9C514" ,
               "yellow-700" = "#DBAB07" ,
               "yellow-800" = "#B08800" ,
               "yellow-900" = "#735C10" ,
               "orange-000" = "#FFF8F2" ,
               "orange-100" = "#FFEADA" ,
               "orange-200" = "#FFD1AC" ,
               "orange-300" = "#FFAB70" ,
               "orange-400" = "#FB8532" ,
               "orange-500" = "#F66A08" ,
               "orange" = "#F66A08" ,
               "orange-600" = "#E46208" ,
               "orange-700" = "#D05703" ,
               "orange-800" = "#C24E00" ,
               "orange-900" = "#A04100" ,
               "red-000" = "#FFEEF0" ,
               "red-100" = "#FFDCE0" ,
               "red-200" = "#FEAEB7" ,
               "red-300" = "#F97583" ,
               "red-400" = "#E94A5A" ,
               "red-500" = "#D73A4A" ,
               "red" = "#D73A4A" ,
               "red-600" = "#CB2431" ,
               "red-700" = "#B21C29" ,
               "red-800" = "#9E1C23" ,
               "red-900" = "#86181D" ,
               "pink-000" = "#FFEEF8" ,
               "pink-100" = "#FEDBF0" ,
               "pink-200" = "#F9B3DD" ,
               "pink-300" = "#F692CE" ,
               "pink-400" = "#EC6CB9" ,
               "pink-500" = "#EA4AAA" ,
               "pink"     = "#EA4AAA" ,
               "pink-600" = "#D03592" ,
               "pink-700" = "#B93A86" ,
               "pink-800" = "#99306F" ,
               "pink-900" = "#6D224F" ,
               "black" = "#1b1f23" ,
               "white" = "#ffffff" )

#' ghColorSelect
#'
#' A convenience function to select specific colors from the ghColors object. ggplot objects interpret the names of named vectors of color values as
#' indicating which label they correspond to, requiring the use of \code{unname()} to remove the names. This function takes as parameters a
#' comma separated list of color names and returns the corresponding hex values from ghColors as an unnamed vector.
#'
#' @examples
#' ghColorSelect("blue-500")
#' ghColorSelect("blue-500","green-500","red-500")
#'@aliases
#' @export
ghColorSelect<-function(...) {
  colors<-unlist(list(...))
  if( !all(colors%in%names(ghColors)) ) {
    x<-colors[!colors%in%names(ghColors)]
    stop(paste(paste(x,collapse=",")," are not colors in ghColors"))
  } else {
    unname(ghColors[colors])
  }
}


nowt <- function(x = NULL) x
