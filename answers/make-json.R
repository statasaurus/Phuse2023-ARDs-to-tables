
# This is the code used to make the display JSON which was modified in the app
library(tfrmt)
library(tidyverse)
test_demog <- read_csv("data/ard.csv")

tfrmt(
  group = row_label2,
  label = row_label1,
  column = col1,
  param = param,
  value = value,
  body_plan = body_plan(
    frmt_structure(group_val = ".default", label_val = ".default",
                   frmt_combine("{n} {pct}",
                                n = frmt("xx"),
                                pct = frmt_when("==100" ~ "",
                                                "==0" ~ "",
                                                TRUE ~ frmt("(x.x %)")))),

    frmt_structure(group_val = ".default", label_val = "n", frmt("xx")),
    frmt_structure(group_val = ".default", label_val = c("Median"),
                   frmt("xx.x")),
    frmt_structure(group_val = ".default", label_val= "Min, Max",
                   frmt_combine("{min}, {max}",
                              min = frmt("xx"),
                              max = frmt("xx"))),
    frmt_structure(group_val = ".default", label_val = "Mean (SD)",
                   frmt_combine("{mean} ({sd})",
                                mean = frmt("xx.x"),
                                sd = frmt("xx.xx"))),
    frmt_structure(group_val = ".default", label_val = c("Q1, Q3"),
                   frmt_combine("{q1}, {q3}",
                                q1 = frmt("xx.x"),
                                q3 = frmt("xx.x"))),
    frmt_structure(group_val = ".default", label_val = "Missing",
                   frmt("xx"))
  ),
  col_plan = col_plan(everything(), Total,
                      -row_label3)
) %>%
  tfrmt_to_json("./data/ard.json")
