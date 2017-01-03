### Cell count plots
### Jan 03 2017
### Last updated by JB

# load libraries ----------------------------------------------------------

library(tidyverse)
library(purrr)
library(lubridate)
library(stringr)



# read in data ------------------------------------------------------------

cells <- read_csv("data-processed/scenedesmus_dec.csv")


# format dates ------------------------------------------------------------

cells2 <- cells %>% 
	mutate(date = day(start_time)) %>%
	mutate(date = ifelse(date == "24", "December 24 2016", date)) %>% 
	mutate(date = ifelse(date == "22", "December 22 2016", date)) %>% 
	mutate(date = mdy(date))

cells2 %>% 
	mutate(replicate = factor(replicate)) %>% 
	mutate(temperature = ifelse(as.numeric(replicate) < 8.5, "12C", "18C")) %>%
	group_by(replicate) %>%
ggplot(aes(x = date, y = cell_density, group = replicate, color = temperature)) + geom_point(size = 4) +
	geom_line()

ggsave("figures/dec_growth.png")

	
	