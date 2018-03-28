library(shiny)
library(ggplot2)


shinyServer(function(input,output){
  output$x <- renderPlot({
    p <- switch(input$var, 
                "Company" = p1,
                "Product" = p2,
                "Year" = p3,
                "State" = p4,
                "Mode of submission" = p5
                )
    print(p)
    
  })
  output$y <- renderPlot({
    q <- switch(input$var2,
                "Product + Timely response" = p6,
                "Product + Mode of submission" = p7
                )
    print(q)
  })
  output$a <- renderPrint({
    print("Results of the modeling")
    print(op1)
    print(op2)
    print("Variables actually used in tree construction")
    print(op3)
    print("Frequency of variables actually used:")
    print(op4)
    print("Evaluate model performance")
    print("Generate confusion matrix showing counts:")
    print(op6)
    print("Generate the confusion matrix showing proportions.")
    print(op7)
    print("Calculate the overall error percentage:")
    print(op8)
    print("Calculate the averaged class error percentage:")
    print(op9)
  })
  output$b <- renderPrint({
    print(" Prediction set (Obtain the response from the Ada Boost model)")
    print(op5)
    print("crs$validate: Complaint IDs")
    print(op10)
  })
})