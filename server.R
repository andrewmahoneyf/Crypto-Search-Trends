
source("scripts/process_data.R")
# Loads Libraries 
library(scales)
library(dplyr)
library(plotly)
library(rsconnect)
library(ggplot2)
library(forcats)

red.text <- element_text(size=16, face = "bold.italic", color = "#f93e3e")

GetCoinSelected <- function(input){
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
  return(coin_selected)
}

GetCorrelation <- function(input, coin_selected){
  if(input$radio == "Search Volume (percentile rank)") {
    correlation <- coin_selected %>% select(week_start,`Google Trends`)
  } else { #Display trade volume
    correlation <- coin_selected %>% select(week_start, volume_avg)
  }
  return(correlation)
}

IsNewsDisplayed <- function(input){
  return(input$radio2 == "Yes")
}

shinyServer(function(input, output) {
  output$coinPlot <- renderPlot({
    coin_selected <- GetCoinSelected(input)
    ggplot(data=coin_selected, aes(x=as.Date(week_start), y=close_avg)) +
      geom_point(size=.5) + geom_line(aes(color=factor(coin_selected$symbol)), size=.5) + 
      geom_errorbar(aes(ymin=low_avg, ymax=high_avg,color=factor(coin_selected$symbol)),
                    size = .7, width=8,                  
                    position = position_dodge(.9)) +
      theme(plot.background = element_rect(fill="black")) + theme(legend.position='top') +
      theme(panel.background = element_rect(fill = "black")) +
      theme(axis.text.y=element_text(color="white")) + theme(axis.title = red.text) + 
      labs(title=paste(input$currency,"Price Correlation"), y="Average Close Price", color="Trend Line") +
      theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
      theme(legend.title = element_text(colour = "steelblue",  face = "bold", size = (30)), 
            legend.text = element_text(face = "italic", colour="steelblue4", size = (20)), 
            legend.background = element_rect(fill="black")) +
      theme(panel.grid.major.x = element_blank(), panel.grid.minor.x = element_blank())
      
  })
  
  output$coinPlot2 <- renderPlot({
    coin_selected <- GetCoinSelected(input)
    correlation <- GetCorrelation(input, coin_selected)

    ggplot(correlation, aes(x=as.Date(week_start), y=correlation[2])) +
      geom_bar(stat = "identity", aes(color=factor(coin_selected$symbol)),show.legend = F) + 
      theme(plot.background = element_rect(fill="black")) + labs(y = "Volume", x = "Month") +
      theme(panel.background = element_rect(fill = "black")) +
      scale_x_date(breaks = date_breaks("months"), labels = date_format("%b-%y")) +
      theme(axis.text.y=element_text(color="white")) + theme(axis.text.x=element_text(colour="white")) + 
      theme(axis.title = red.text) + scale_color_discrete(name="Indicator", label = input$radio) + 
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
    
  })
  
  output$description <- renderDataTable({top5}, options = list(pageLength = 50)) 

  output$info <- renderText({
    paste0("x=", as.Date(input$plot_click$x, origin = "1970-01-01") , "\ny=", input$plot_click$y)
  })
  
})