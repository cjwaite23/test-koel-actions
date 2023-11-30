##### Description #####
# This is the script to test run the ALA biosecurity alerts system using the koel
#   package.

### IMPORTANT: Make sure you are on the `run-alerts` branch of this repo ###

##### Libraries (and installs) #####
# Communication will be provided as to whether to install koel from HEAD or dev

{
  library(remotes)
  library(readr)
  library(galah)
  library(koel)
}

options(chromote.timeout = 60)

##### Set up galah_config() #####
# You are welcome to use your own email or keep mine
galah_config(
  email = "callumwaite2000@gmail.com",
  run_checks = FALSE,
  verbose = FALSE)

##### Set up directory names and structure #####
# create correct file structure
dir.create("cache")
dir.create("./cache/maps")
dir.create("./cache/species_images")
cache_path <- "./cache/"

# 1. Load in combined species list
combined_species_list <- read_csv("./data/combined_list.csv")

# 2a. record the correct and common name assignments
#     - should have 2 columns and ~30-60% of the rows of combined_species_list
correct_common_names <- assign_common_names(combined_species_list)
# 2b. search the ALA for occurrences (will take ~5-10 minutes)
species_records <- search_occurrences(combined_species_list, correct_common_names, 
                                      event_date_start = 28, event_date_end = 0,
                                      upload_date_start = 7, upload_date_end = 0)
#  c. filter species_records by country, state, LGA and shapefile specifications
species_filtered <- filter_occurrences(species_records, "./data/shapefiles/")
#  d. download one media item per record and save in cache_path directory
species_downloads <- download_occurrences(species_filtered, cache_path)

# reload species_downloads output in as alerts_data (not strictly necessary)
alerts_data <- species_downloads

write_csv(alerts_data, file = "current_alerts_data.csv")

# 3. build and send the email
# email_list <- readr::read_csv("./data/email_list_test.csv", show_col_types = FALSE)
email_list <- data.frame(email = character(), list = character())
build_email_large(alerts_data, cache_path, 
                  template_path = "email_template.Rmd", 
                  output_path = NULL,
                  email_list = email_list,
                  test = TRUE)
