# author: Magali Blanco
# data: 7/20/23
# purpose: example code for Nede to look at site concentration SD & correlated covariates
############################
# SETUP
rm(list = ls(all = TRUE))
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse) 

# I usually set a seed to ensure the results are the same anytime there may be any kind of randomnesss in the results
set.seed(1)

############################
# LOAD DATA
stop_data0 <- read.csv(file.path("data", "stop_data.csv"))
covariates0 <- read.csv(file.path("data", "dr0311_mobile_covars.csv"))

############################
# 1. CALCULATE SD OF EACH SITE

# --> Make sure to look at the dataframe after each code chunk & check that you understand each function

stop_data <- stop_data0 %>%
  # only keep nanoscan data
  filter(variable == "ns_total_conc")

# calcualte SD for each site
stop_data <- stop_data %>%
  # for each location...
  group_by(location) %>%
  # do the following...
  summarize(
    # count the number of rows (observations used to calcualte everything below)
    n = n(),
    sd = sd(median_value)
  )

# the resulting dataset has 309 rows (sites), each with the SD of the observations

############################
# 2. MERGE THE SITE SD & COVARIATES (WHAT EACH SITE LOOKS LIKE)
merged_dt <- left_join(stop_data, covariates0, by=c("location" = "native_id"))

correlation_dt <- merged_dt %>%
  # only keep the columns you want to compare, since each row is 1 site
  select(sd, m_to_a1:last_col())
  
############################
# LOOK TO SEE IF THERE ARE ANY CORRELATIONS BETWEEN HOW VARIABLE A SITE IS AND ITS CHARACTERISTICS

# this is a quick/messy way to do this. you only care about the correlation between sd & every other variable
correlation_dt <- cor(correlation_dt)


# now you can look to see which have the highest absolute correlations (closest to 1 or -1 & away from 0)
correlation_dt <- correlation_dt %>%
  #convert form a "matrix" to a dataframe you can more easily manipulate
  as.data.frame() %>%
  select(sd) 

# you can convert the row names to a column to make things easier



############################
# PUT SOME PLOTS/TABLES TOGETHER SUMMARIZING WHAT YOU ARE SEEING








