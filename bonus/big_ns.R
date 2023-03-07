################################################################
# Adding Big N's to the column labels for the demography table #
###############################################################

# First we are going to get the same code to make the demography table as before

library(tidyverse)
library(haven)
library(tardis)

adsl <- read_xpt(url("https://github.com/phuse-org/TestDataFactory/raw/main/Updated/TDF_ADaM/adsl.xpt"))


# Make demog ardis  -------------------------------------------------------

tbl_setup <- adsl %>%
  tardis_table(treat_var = TRT01A, where = SAFFL == "Y")

demog_ard <- tbl_setup %>%
  add_total_group(group_name = "Total") %>%
  add_layer(
    group_desc(target_var = AGE, by = vars("Age (years)"))
  ) %>%
  add_layer(
    group_count(target_var = AGEGR1, by = "Age (years)")
  ) %>%
  add_layer(
    group_count(target_var = SEX, by = "Sex")
  ) %>%
  add_layer(
    group_desc(target_var = HEIGHTBL, by = "Height (cm)")
  ) %>%
  add_layer(
    group_desc(target_var = WEIGHTBL, by = 'Weight (kg)')
  )

# Build the ardis to an ARD
data <- demog_ard %>%
  build()


# Get the big N dataset ---------------------------------------------------
full_data <- tbl_setup %>%
  header_n() %>%
  rename(value = n,
         col1 = TRT01A) %>% #Here we are just making the values match to the columns above
  mutate(param = "bigN") %>%
  bind_rows(data)


# Write out ---------------------------------------------------------------

write_csv(full_data, "bonus/data/demog-big_ns.csv")




