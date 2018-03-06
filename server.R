

#setwd("~/info201b/Info-201-Final")
source("scripts/process_data.R")
# Loads Libraries 
library(dplyr)
#library(plotly)
library(rsconnect)
#library(ggplot2)
#library(forcats)


shinyServer(function(input, output) {
  output$dataPlot <- renderPlot({
    
    if(input$currency == "Litecoin (LTC)") {
      coin_selected <- top5 %>% filter(symbol == "LTC")
    }else if(input$currency == "Bitcoin (BTC)"){
      coin_selected <- top5 %>% filter(symbol == "BTC")
    }else if(input$currency == "ripple (XRP)"){
      coin_selected <- top5 %>% filter(symbol == "XRP")
    }else if(input$currency == "ethereum (ETH)"){
      coin_selected <- top5 %>% filter(symbol == "ETH")
    }else if(input$currency == "Bitcoin Cash (BCH)"){
      coin_selected <- top5 %>% filter(symbol == "BCH")
    }else {coin_selected <- top5
    }
    
    
     
      
    
    
    
    
  })
})