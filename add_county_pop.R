library(tidyverse)
library(lubridate)
library(here)

county_df <- read_csv("co-est2019-alldata.csv")

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
  mutate(
    cases_per_capita = cases / population,
    deaths_per_capita = deaths / population
  )


state_pops <- read_csv("state_populations.csv")

nyt_state_df <- nytcovstate %>% 
  left_join(state_pops, by = c("state" = "State")) %>% 
  mutate(cases_per_capita = 1000 * cases / Pop)