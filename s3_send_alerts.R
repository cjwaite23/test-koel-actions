##### Description #####
# This is the script to run the oficial alerts for the ALA biosecurity alerts 
# system using the koel package.

### IMPORTANT: Make sure you are on the `run-alerts` branch of this repo ###

##### Libraries (and installs) #####
# Communication will be provided as to whether to install koel from HEAD or dev
{
  remotes::install_github("atlasoflivingaustralia/koel")
  library(remotes)
  library(readr)
  library(galah)
  library(koel)
}

##### Set up directory names and structure #####
# create correct file structure
dir.create("./cache/csv")
dir.create("./cache/html")
cache_path <- output_path <- "./cache/"

# reload species_downloads output in as alerts_data (not strictly necessary)
alerts_data <- read_csv("current_alerts_data.csv")

# 3. build and send the email

### GOOD RUN (SENT TO ALL USERS)
email_list <- read_csv("./data/email_list.csv", show_col_types = FALSE)
build_email_large(alerts_data, cache_path, template_path = "email_template.Rmd", output_path = cache_path,
                    email_list = email_list, email_subject = "ALA Biosecurity Alert",
                    email_send = "biosecurity@ala.org.au", email_password = BIOSEC_EMAIL_PW,
                    email_host = "smtp-relay.gmail.com", email_port = 587,
                    test = FALSE)
