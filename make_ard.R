#######################################################
# Here we will start the ARD for the demography table #
#######################################################
library(tidyverse)
library(tardis)
library(haven)

# First we are going to read in the data
adsl <- read_xpt(url("https://github.com/phuse-org/TestDataFactory/raw/main/Updated/TDF_ADaM/adsl.xpt"))

# Lets set up our ard. First we are going to define the data source and
# important variables
demog_ard <- adsl %>%
  tardis_table(treat_var = TRT01A, where = SAFFL == "Y") %>%
  add_total_group(group_name = "Total")

# Now let's add some variables we want. First we are going to start with AGE
demog_ard %>%
  add_layer(
    group_desc(target_var = AGE, by = vars("Age (years)"))
  )

# To see how this looks we are going to use the build function to build the ARD
demog_ard %>%
  build()

# Time for the next variable AGEGRP1, remember this time we want to use
# `group_count` because it is a categorical variable
demog_ard %>%
  add_layer(
    group_count(target_var = AGEGR1, by = "Age (years)")
  )

# Now we can see what it looks like with the new layer added
demog_ard %>%
  build() %>%
  tail()

# Let's add a couple more layers
demog_ard %>%
  add_layer(
    group_count(target_var = SEX, by = "Sex")
  ) %>%
  add_layer(
    group_desc(target_var = HEIGHTBL, by = "Height (cm)")
  )

# Exercise 1 --------------------------------------------------------------

# In this exercise we need you to add descriptive statistics for `WEIGHTBL` with
# the label 'Weight (kg)'



# -------------------------------------------------------------------------

data <- demog_ard %>%
  build()

write_csv(data, "./data/ard.csv")
