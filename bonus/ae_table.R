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
  build() %>%
  mutate(row_label2 = if_else(row_label1 == "Any Body System",
                              row_label1,
                              str_to_title(row_label2)))


# Make tfrmt --------------------------------------------------------------

tfrmt_n_pct(
  n = "distinct_n",
  pct = "distinct_pct",
  frmt_when("==1" ~ frmt(""),
            ">.99" ~ frmt("(>99%)"), "==0" ~ "",
            "<0.01" ~ frmt("(<1%)"),
            "TRUE" ~ frmt("(xx.x%)", transform = ~.*100))
) %>%
  tfrmt(
    group = row_label2,
    column = col1,
    param = param,
    value = value,
    label = row_label1,
    col_plan = col_plan(
      everything(),
      Total
    )
  ) %>%
  print_to_gt(.data = ae_ard)



