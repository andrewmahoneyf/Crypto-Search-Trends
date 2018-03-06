#Require shiny
library(shiny)

#Define the functionality of the user interface
shinyUI(fluidPage(
  
  # Add a descriptive application title
  titlePanel("Crypto Correlation"),
  
  # Add the app interactivity
  sidebarLayout(
    sidebarPanel(
      #selectInput Manufacturer #inputID = Manufacturer
      selectInput(inputId = "currency",
                  label = "Currency:",
                  choices = c("Bitcoin (BTC)", "Ethereum (ETH)", "Ripple (XRP)", "Bitcoin Cash (BCH)", "Litecoin (LTC)", "All"),
                  selected = "All"),

      #selectInput for calorie amount #inputID = calories
      selectInput(inputId = "price",
                  label = "Most Recent Price:",
                  choices = c("Less than 10", "10 - 100", "100 - 500", "500 - 1000", "Over 1000", "All"),
                  selected= "All")
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("coinPlot")
    )
  )
))