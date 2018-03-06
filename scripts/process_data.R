
## File used for processing data sets
# install.packages(c("data.table", "dplyr"))
library(data.table)
library(dplyr)
library("lubridate")

## import static files
system.time(crypto_data <- fread("../data/crypto_history.bz2"))
system.time(news_data <- fread("../data/201718-filtered-news-complete.csv"))
system.time(google_data <- fread("../data/google_trends.csv"))

# Manipulate both data sets for desired use and compatibility
crypto_data <- crypto_data %>% filter(substr(date, 0, 4) == "2017" | substr(date, 0, 4) == "2018")

# Create a data frame for top 5 cryptocoins
top5 <- crypto_data %>% filter(ranknow <= 5)
top5$week <- strftime(top5$date,format = "%V")

# Write function to take in the crypto data set and string parameter
# and output a data frame for the specified cryptocurrency
temp <- top5 %>% group_by(name) %>% summarise(Days = n())

GetDataByCurrencyWeekly <- function(symbol_name){
  dataset <- top5 %>% filter(symbol == symbol_name)
  dataset <- dataset %>% 
    group_by(week) %>% 
    summarize(
      week_start = as.Date(min(as.numeric(as.Date(date))), origin = "1970-01-01"), 
      week_end = as.Date(max(as.numeric(as.Date(date))), origin = "1970-01-01"), 
      open_avg = mean(open),
      high_avg = mean(high),
      low_avg = mean(low),
      close_avg = mean(close),
      volume_avg = mean(volume),
      market_avg = mean(market),
      close_ratio_avg = mean(close_ratio),
      spread_avg = mean(spread)
    )
  return(dataset)
}

ethereum <- GetDataByCurrencyWeekly("ETH")
bitcoin <- GetDataByCurrencyWeekly("BTC")
litecoin <- GetDataByCurrencyWeekly("LTC")
bitcoin_cash <- GetDataByCurrencyWeekly("BCH")
ripple <- GetDataByCurrencyWeekly("XRP")

# Write a function to maniputale the crypto data and create a seperate
# data frame with weekly averages instead of daily

