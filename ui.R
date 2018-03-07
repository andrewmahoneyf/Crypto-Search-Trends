#Require shiny

library(shiny)
library(shinythemes)

#Define the functionality of the user interface
shinyUI(fluidPage(
  
  theme = shinytheme("darkly"),
  
  # Add a descriptive application title
  titlePanel("Crypto Correlation"),
  
  # Add the app interactivity
  sidebarLayout(
    sidebarPanel(
      tags$style(type="text/css",
                 ".shiny-output-error { visibility: hidden; }",
                 ".shiny-output-error:before { visibility: hidden; }"
      ),
      #selectInput Manufacturer #inputID = Manufacturer
      selectInput(inputId = "currency",
                  label = "Currency:",
                  choices = c("Bitcoin (BTC)", "Ethereum (ETH)", "Ripple (XRP)", "Bitcoin Cash (BCH)", "Litecoin (LTC)", "All"),
                  selected = "Bitcoin (BTC)"),
      
      radioButtons("radio",
                   label = "Volume Indicator:",
                   choices = c("Search Volume", "Trade Volume"),
                   selected = "Search Volume"
      ),
      
      radioButtons("radio2",
                   label = "Display Crypto News Updates?",
                   choices = c("Yes", "No"),
                   selected = "Yes"
      )
    
    ),
    
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("Summary", dataTableOutput("description")),
        tabPanel("Crypto Plot",
                 fluidRow(
                 verbatimTextOutput("info"),
                 plotOutput("coinPlot",  click = "plot_click"),
                 plotOutput("coinPlot2")
                 
                 )
                 
        )
      )
    )
    #restore
  )
))