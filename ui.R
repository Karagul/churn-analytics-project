library(shiny)

shinyUI(fluidPage(
  titlePanel("Consumer_Complaints - Churn Analysis"),
  sidebarLayout(
    sidebarPanel(
      radioButtons("var", "Select option for uni-variate analysis:", c("Company", "Product", "Year","State","Mode of submission"), selected = "Company" ),
      radioButtons("var2", "Select option for bi-variate analysis:",c("Product + Timely response", "Product + Mode of submission"))
    ),
    mainPanel(
      tabsetPanel(
      tabPanel("Univariate Analysis",plotOutput(outputId="x")),
      tabPanel("Bivariate Analysis",plotOutput(outputId="y")),
      tabPanel("Model",verbatimTextOutput(outputId="a")),
      tabPanel("Predicted data", verbatimTextOutput(outputId="b"))
    ))
  )
))
