
source("scripts/process_data.R")
# Loads Libraries 
library(scales)
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
    
    # if(input$radio2 == "Yes") {
    #   #display news data
    # }

    ggplot(data=coin_selected, aes(x=as.Date(week_start), y=close_avg)) +
      geom_point(size=.5) + geom_line(aes(color=factor(coin_selected$symbol)), size=.5) + 
      geom_errorbar(aes(ymin=low_avg, ymax=high_avg,color=factor(coin_selected$symbol)),
                    size = .7, width=8,                  
                    position = position_dodge(.9)) +
      theme(plot.background = element_rect(fill="black")) + theme(legend.position='top') +
      theme(panel.background = element_rect(fill = "black")) +
      theme(axis.text.y=element_text(color="white")) + theme(axis.title = red.text) + 
      labs(title=paste(input$currency,"Price Correlation"), y="Average Close Price", color="Trend Line ") +
      theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
      theme(legend.title = element_text(colour = "steelblue",  face = "bold", size = (30)), 
            legend.text = element_text(face = "italic", colour="steelblue4", size = (20)), 
            legend.background = element_rect(fill="black")) +
      theme(panel.grid.major.x = element_blank(), panel.grid.minor.x = element_blank())
      
  })
  
  output$coinPlot2 <- renderPlot({
    
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
    
    if(input$radio == "Search Volume (percentile rank)") {
      correlation <- coin_selected %>% select(week_start,`Google Trends`)
    } else { #Display trade volume
      correlation <- coin_selected %>% select(week_start, volume_avg)
    }
    
    ggplot(correlation, aes(x=as.Date(week_start), y=correlation[2])) +
      geom_bar(stat = "identity", aes(color=factor(coin_selected$symbol)),show.legend = F) + 
      theme(plot.background = element_rect(fill="black")) + labs(y = "Volume", x = "Month") +
      theme(panel.background = element_rect(fill = "black")) +
      scale_x_date(breaks = date_breaks("months"), labels = date_format("%b-%y")) +
      theme(axis.text.y=element_text(color="white")) + theme(axis.text.x=element_text(colour="white")) + 
      theme(axis.title = red.text) + scale_color_discrete(name="Indicator", label = input$radio) + 
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
    
  }, height = 125, units="px")
  
  output$description <- renderDataTable({
    top5 <- top5 %>% select(Symbol = symbol, Week = week_start, Open = open_avg, Close = close_avg, Low = low_avg, High = high_avg, Volume = volume_avg, `Market Cap` = market_avg, `Google Trends`)
    top5$Week <- format(as.Date(top5$Week, "%Y-%m-%d"), "%m-%d %Y")
    
    toUSD <- function(column){
      return(paste("$", round(column, 2), sep=""))
    }
    top5$Low <- toUSD(top5$Low)
    top5$Open <- toUSD(top5$Open)
    top5$High <- toUSD(top5$High)
    top5$Close <- toUSD(top5$Close)
    top5$`Market Cap` <- toUSD(top5$`Market Cap`)
    top5
  }, options = list(pageLength = 50)) 


  output$info <- renderText({
    paste0("x=", as.Date(input$plot_click$x, origin = "1970-01-01") , "\ny=", input$plot_click$y)
  })
  
})