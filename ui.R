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
                  selected = "All"),
      
      radioButtons("radio",
                   label = "Correlations",
                   choices = c("Google Trends", "Crypto News", "All"),
                   selected = "Google Trends"
      ),
      
      #selectInput for calorie amount #inputID = calories
      selectInput(inputId = "price",
                  label = "Most Recent Price:",
                  choices = c("Less than 10", "10 - 100", "100 - 500", "500 - 1000", "Over 1000", "All"),
                  selected= "All")
      
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
                 h3("what we did"),
                 p("paragraph about methodology"),
                 h3("what we found"),
                 p("paragraph about results/findings")
                 
        )
      )
    )
    
  )
))