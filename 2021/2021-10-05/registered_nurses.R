library(tidytuesdayR)
library(tidyverse)
library(janitor)
library(scales)
library(usmap)
library(gganimate)

# data ----
tuesdata <- tidytuesdayR::tt_load('2021-10-05')
nurses <- tuesdata$nurses %>% clean_names()

# animated heat map ----

p <- nurses %>%
  mutate(state = str_to_lower(state)) %>%
  inner_join(map_data("state"), by = c(state = "region")) %>%
  ggplot(aes(long, lat, group = group, fill = hourly_wage_median)) +
  geom_polygon() +
  coord_map() +
  scale_fill_viridis_c(labels = dollar_format(), direction = -1) +
  labs(title = "Hourly Wage of Registered Nurses {closest_state}",
       fill = "Median Wage",
       caption = "by @MichaelMcFerran | source: #TidyTuesday/Registered Nurses") +
  xlab(element_blank()) +
  ylab(element_blank()) +
  theme(panel.background = element_blank(), 
        axis.text = element_blank()) +
  transition_states(year, transition_length = 1, state_length = 1)

nurses_anim <-animate(p, nframes=49, fps=10,renderer=gifski_renderer("hourly_wage_median_nurses.gif"))
