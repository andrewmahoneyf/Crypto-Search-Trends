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
                   choices = c("Search Volume (percentile rank)", "Trade Volume (quantity of trades)"),
                   selected = "Search Volume (percentile rank)"
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
        tabPanel("Data", dataTableOutput("description")),
        tabPanel("Crypto Plot",
                 fluidRow(
                   verbatimTextOutput("info"),
                   plotOutput("coinPlot",  click = "plot_click"),
                   plotOutput("coinPlot2"))
        ),
        tabPanel("Summary",
                 h3("Data Sources"),
                 p("We used data from GitHub user JesseVent's \"crypto\" repository, which containeds historical cryptocurrency 
                   prices and market data for all different cryptocurrency tokens. Additionally, we used Google Trends data 
                   related to our selected cryptocurrencies. We then pulled all of the data ranging back to the start of 2017, 
                   as cryptocurrency activity has been more prominent (and arguably more interesting) recently than ever before, 
                   due to rising popularity and a heightened sense of legitimacy from the public."),
                 h3("Findings"),
                 p("paragraph about results/findings")
                 
        )
      )
    )
    
  )
))