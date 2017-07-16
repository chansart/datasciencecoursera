#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Orange trees"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("circumference",
                      "Circumference:",
                      min=30,
                      max=230,
                      value=100),
         numericInput("tree",
                      "Tree:",
                      min=1,
                      max=5,
                      value=1)
         ),
      
      # Show a plot of the generated distribution
      mainPanel(
         h5("The plot below shows the evolution of the circumference of  orange trees regarding their age and their class. 
             Below the plot, you can see the predicted age of an orange tree in function of its circumference and, for the second model, its class."),
         h5("Play with these parameters in the side panel !"),
         plotOutput("plot"),
         h3("Predicted age from circumference model:"),
         textOutput("pred1"),
         h3("Predicted age from full model (circumference + tree):"),
         textOutput("pred2")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
  modelCircum <- lm(age~circumference, data=Orange)
  modelTreeCircum <- lm(age~Tree+circumference, data=Orange)
  
  modelCircumPred <- reactive({
    circumInput <- input$circumference
    predict(modelCircum, newdata = data.frame(circumference = circumInput))
  })
  
  modelTreeCircumPred <- reactive({
    circumInput <- input$circumference
    treeInput <- as.factor(input$tree)
    predict(modelTreeCircum, newdata = data.frame(circumference = circumInput, Tree = treeInput))
  })
  
   output$plot <- renderPlot({
     circumInput <- input$circumference
     treeInput <- input$tree
     
     ggplot(Orange, aes(x=age, y=circumference, col=Tree)) +
       geom_point() +
       geom_line()
   })
   
   output$pred1 <- renderText({
     modelCircumPred()
   })
   
   output$pred2 <- renderText({
     modelTreeCircumPred()
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

