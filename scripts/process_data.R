
## File used for processing data sets
# install.packages(c("data.table", "dplyr"))
library(data.table)
library(dplyr)

## import static files
system.time(crypto_data <- fread("../data/crypto_history.bz2"))
system.time(news_data <- fread("../data/201718-filtered-news-complete.csv"))
system.time(google_data <- fread("../data/google_trends.csv"))

# Manipulate both data sets for desired use and compatibility
crypto_data <- crypto_data %>% filter(substr(date, 0, 4) == "2017" | substr(date, 0, 4) == "2018")

# Create a data frame for top 5 cryptocoins
top5 <- crypto_data %>% filter(ranknow <= 5)

# Write function to take in the crypto data set and string parameter
# and output a data frame for the specified cryptocurrency
temp <- top5 %>% group_by(name) %>% summarise(Days = n())
ethereum <- crypto_data %>% filter(symbol == "ETH")

# Write a function to maniputale the crypto data and create a seperate
# data frame with weekly averages instead of daily
