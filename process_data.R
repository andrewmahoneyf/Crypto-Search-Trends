install.packages(c("ggplot2", "data.table", "dplyr", "devtools"))
library(data.table)
library(dplyr)
library(ggplot2)

system.time(crypto_data <- fread("data/crypto_history.bz2"))

ethereum <- crypto_data %>% filter(symbol == "ETC")
