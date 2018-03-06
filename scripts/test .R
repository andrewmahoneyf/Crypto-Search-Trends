## File used for processing both data sets
install.packages(c("ggplot2", "data.table", "dplyr", "devtools"))
setwd("~/info201b/Info-201-Final")
library(data.table)
library(dplyr)
library(ggplot2)
install.packages(rggobi)
## import static files
system.time(crypto_data <- fread("data/crypto_history.bz2"))
# system.time(twitter_data <- fread("data/twitter_history.csv"))
#head(crypto_data)
# Manipulate both data sets for desired use and compatibility
crypto_data <- crypto_data %>% filter(substr(date, 0, 4) == "2017" | substr(date, 0, 4) == "2018")

# Create a data frame for top 5 cryptocoins
top5 <- crypto_data %>% filter(ranknow <= 5)
coin_selected <- top5 %>% filter(symbol == "XRP")

ggplot(data=coin_selected, aes(x=date, y=close, group=1)) +
  geom_line(color="red")+
  geom_point()   

# Write function to take in the crypto data set and string parameter
# and output a data frame for the specified cryptocurrency
ethereum <- crypto_data %>% filter(symbol == "ETC")

# Write a function to maniputale the crypto data and create a seperate
# data frame with weekly averages instead of daily
