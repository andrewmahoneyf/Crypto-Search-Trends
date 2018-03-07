
## File used for processing data sets
# install.packages(c("data.table", "dplyr"))
library(data.table)
library(dplyr)
library("lubridate")

## import static files
system.time(crypto_data <- fread("data/crypto_history.bz2"))
system.time(news_data <- fread("data/201718-filtered-news-complete.csv"))
google_data <- read.csv("data/google_trends.csv", sep=",", header=T, check.names=FALSE, colClasses=c(rep("factor", "numeric",5)))

# Manipulate data sets for desired use and compatibility
crypto_data <- crypto_data %>% filter(substr(date, 0, 4) == "2017" | substr(date, 0, 4) == "2018")
news_data <- news_data %>% select(date, title, publication, url) 
news_data$date <- as.Date(news_data$date, format = "%m/%d/%y")
news_data$week_start <- floor_date(news_data$date, unit="week") + 1
google_data$Week <- as.Date(google_data$Week, format = "%m/%d/%y") + 1

# Create a data frame for top 5 cryptocoins
top5 <- crypto_data %>% filter(ranknow <= 5)
top5$week <- strftime(top5$date, format = "%Y %W")

# This function returns the currency data grouped by week 
GetDataByCurrencyWeekly <- function(symbol_name){
  dataset <- top5 %>% filter(symbol == symbol_name)
  dataset <- dataset %>% 
    group_by(week) %>% 
    summarize(
      symbol = symbol_name,
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

# Join google trends data with each cryptocurrency by week start
JoinGoogleTrends <- function(df, currency){
    df <- left_join(df, select(google_data, Week, paste(currency, ": (Worldwide)", sep="")), by = c("week_start" = "Week"))
    colnames(df)[13] <- "Google Trends"
    df$`Google Trends`=as.numeric(levels(df$`Google Trends`))[df$`Google Trends`]
    df = df[-1,]
    return(df)
}

#  Store the weekly average data per currency and join Google trends data
ethereum <- GetDataByCurrencyWeekly("ETH") %>% JoinGoogleTrends("Ethereum")
bitcoin <- GetDataByCurrencyWeekly("BTC") %>% JoinGoogleTrends("Bitcoin")
litecoin <- GetDataByCurrencyWeekly("LTC") %>% JoinGoogleTrends("Litecoin")
bitcoin_cash <- GetDataByCurrencyWeekly("BCH") %>% JoinGoogleTrends("Bitcoin Cash")
ripple <- GetDataByCurrencyWeekly("XRP") %>% JoinGoogleTrends("Ripple")

# Update top5 data frame to match new format
top5 <- rbind(bitcoin[, 1:11], ethereum[, 1:11], ripple[, 1:11], bitcoin_cash[, 1:11], litecoin[, 1:11])
google_data[2:6] <- data.frame(sapply(google_data[2:6], function(x) as.numeric(as.character(x))))
google_data$`Google Trends` <- rowMeans(google_data[2:6])
top5 <- left_join(top5, select(google_data, Week, `Google Trends`), by = c("week_start" = "Week"))
drops <- c("week","week_end", "open_avg", "market_avg", "close_ratio_avg")
top5 <- top5[ , !(names(top5) %in% drops)]
# top5 <- select(top5, symbol, week_start, open_avg, high_avg, low_avg,)