### Flow cam data import
### Dec 22 2016
### Last updated by JB

# load libraries ----------------------------------------------------------

library(tidyverse)
library(purrr)
library(lubridate)
library(stringr)

# Step 1: get a list of all the files
cell_files <- c(list.files("/Users/Joey/Documents/M.Tseng/flowcam-summaries-dec22", full.names = TRUE),
								list.files("/Users/Joey/Documents/M.Tseng/flowcam-summaries-dec24", full.names = TRUE))
								


names(cell_files) <- cell_files %>% 
	gsub(pattern = ".csv$", replacement = "")


#### Step 2: read in all the files!

all_cells <- map_df(cell_files, read_csv, col_names = FALSE, .id = "file_name")


#### Step 3: pull out just the data we want, do some renaming etc.

scenedesmus_dec <- all_cells %>% 
	rename(obs_type = X1,
				 value = X2) %>% 
	filter(obs_type %in% c("List File", "Start Time", "Particles / ml", "Volume (ABD)")) %>%
	spread(obs_type, value) %>%
	separate(`List File`, into = c("replicate", "other"), sep = "[:punct:]") %>% 
	rename(start_time = `Start Time`,
				 cell_density = `Particles / ml`,
				 cell_volume = `Volume (ABD)`) %>% 
	select(-other)

#### Step 4: write out the summary data to file
write_csv(scenedesmus_dec, "data-processed/scenedesmus_dec.csv")
