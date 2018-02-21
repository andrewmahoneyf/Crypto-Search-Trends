## Run one time to download data from github library 
## Writes data out to a bzcat file for quicker reading
install.packages(c("data.table", "dplyr", "devtools"))
library(data.table)
library(dplyr)

devtools::install_github("jessevent/crypto")  
library(crypto)  
crypto <- getCoins()
fwrite(crypto, "data/crypto_history.bz2")