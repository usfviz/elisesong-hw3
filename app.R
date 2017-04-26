library("shiny")
library("ggplot2")
library("GGally")
library("plotly")

#setwd("/Users/Elise/DataViz/HW3")
rm(list = ls())
cat("\014") 
df <- read.csv("dataset_Facebook.csv", sep=";", header=T)

ui <- fluidPage(
  headerPanel("Facebook Visualization"),
  mainPanel(
    tabsetPanel(
      tabPanel(title = "Bubble Plot", plotlyOutput("bubble", width= 900, height=600)),
      tabPanel(title = "Scatterplot Matrix", plotlyOutput("scatter", width= 800, height=500)),
      tabPanel(title = "Parallel Coordinates Plot", plotlyOutput("parallel", width= 800, height=500))
    )
  )
)
server <- function(input, output) {
  output$bubble <- renderPlotly({
    ggplot(df, aes(like, Lifetime.Post.Total.Impressions)) +
      geom_point(aes(size = Total.Interactions, colour = Type))
  })
  output$scatter <- renderPlotly({
    ggpairs(df, columns = c(16:19), columnLabels = colnames(df)[16:19])
  })
  output$parallel <- renderPlotly({
    ggparcoord(data = df, columns = 16:19, groupColumn = 'Type', scale = 'center') 
  })
}

shinyApp(ui = ui, server = server)
