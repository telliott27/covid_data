library(tidyverse)
library(lubridate)
library(here)

county_df <- read_csv("co-est2019-alldata.csv")

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


state_pops <- read_csv("state_populations.csv")

nyt_state_df <- nytcovstate %>% 
  left_join(state_pops, by = c("state" = "State")) %>% 
  mutate(cases_per_capita = 1000 * cases / Pop)