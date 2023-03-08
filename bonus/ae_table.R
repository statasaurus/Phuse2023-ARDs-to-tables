########################
# Creating an AE Table #
########################

library(tidyverse)
library(haven)
library(tardis)
library(tfrmt)

# Frist we are going to get the data
adsl <- read_xpt(url("https://github.com/phuse-org/TestDataFactory/raw/main/Updated/TDF_ADaM/adsl.xpt"))
adae <- read_xpt(url("https://github.com/phuse-org/TestDataFactory/raw/main/Updated/TDF_ADaM/adae.xpt"))


# Make ARD ----------------------------------------------------------------

# We are going to setup the table and unlike with the demog table, we need to
# add a population data (i.e. adsl) and we are going to have a total column
tbl_setup <- tardis_table(rename(adae,TRT01A= TRTA) , treat_var = TRT01A) %>%
  set_pop_data(adsl) %>%
  add_total_group()

# Now we are going to add a layer to calculate the number and percentage of
# *unique* subjects with any AE
ae_ard <- tbl_setup %>% add_layer(
    group_count("Any Body System") %>%
      set_distinct_by(USUBJID) %>%
      set_summaries(vars(distinct_n),
                    vars(distinct_pct))
  )  %>%
  add_layer(
    group_count(target_var = vars(AEBODSYS, AETERM)) %>%
      set_distinct_by(USUBJID) %>%
      set_summaries(vars(distinct_n),
                    vars(distinct_pct))
  )  %>%
  build()




