
source("scripts/process_data.R")
# Loads Libraries 

library(dplyr)
library(plotly)
library(rsconnect)
library(ggplot2)
library(forcats)

red.text <- element_text(size=16, face = "bold.italic", color = "#f93e3e")

shinyServer(function(input, output) {
  output$coinPlot <- renderPlot({
    
    if(input$currency == "Litecoin (LTC)") {
      coin_selected <- litecoin
    }else if(input$currency == "Bitcoin (BTC)"){
      coin_selected <- bitcoin
    }else if(input$currency == "Ripple (XRP)"){
      coin_selected <- ripple
    }else if(input$currency == "Ethereum (ETH)"){
      coin_selected <- ethereum
    }else if(input$currency == "Bitcoin Cash (BCH)"){
      coin_selected <- bitcoin_cash
    }else {
      coin_selected <- top5
    }
    

 #as.Date(input$plot_hover$x, origin = "1970-01-01")     
      ggplot(data=coin_selected, aes(x=as.Date(week_start), y=close_avg)) +
        geom_line(color="red") +
        labs(x="Date", y="Price (USD)") + 
        theme(plot.background = element_rect(fill="black")) +
        theme(axis.text.y=element_text(color="white")) + theme(axis.text.x=element_text(colour="white")) + 
        theme(axis.title = red.text)
      #geom_point(size=0)   

         
      
      
  })
  
  

  output$info <- renderText({
    paste0("x=", as.Date(input$plot_click$x, origin = "1970-01-01") , "\ny=", input$plot_click$y)
  })
  
})