##### Libraries (and installs) #####
# Communication will be provided as to whether to install koel from HEAD or dev
{
  library(remotes)
  remotes::install_github("atlasoflivingaustralia/koel")
  library(readr)
  library(galah)
  library(koel)
}

##### Downloads -> data / data_temp #####
# - files in "Lists/Edited Lists/" -> "data_temp/edited_lists/"
# - files in "Lists/Raw Lists/" -> "data_temp/raw_lists/"
# - files in "Lists/Shapefiles/" -> "data/shapefiles"
# - "Lists/email_list.csv" -> "data/email_list.csv"
# - "Lists/Lists metadata -> "data/Lists metadata.xlsx"

##### koel Function  #####
# 1. import lists and save as combined file
#     - should have 8 columns and ~8k rows
combined_species_list <- get_species_lists("./data_temp/edited_lists/")
# save object combined_species_list
write_csv(combined_species_list, file = "./data/combined_list.csv")

##### COMMIT + PUSH ALL CHANGES #####