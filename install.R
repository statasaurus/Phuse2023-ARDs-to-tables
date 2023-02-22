# This is the install script. You do not need to run it if you are in our posit
# cloud workspace. But, if you are running locally you may need to install these packages


install.packages("tidyverse")

# ARD generating package
devtools::install_github("https://github.com/atorus-research/tardis")
# Table rendering packages
devtools::install_github("https://github.com/GSK-Biostatistics/tfrmt")
devtools::install_github("https://github.com/GSK-Biostatistics/tfrmtbuilder")

