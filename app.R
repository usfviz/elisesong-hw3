rm(list = ls())
cat("\014") 
if (!require(GGally))
{
  install.packages("GGally")
}

if (!require(plotly))
{
  install.packages("plotly")
}

library("shiny")
library("ggplot2")
library("GGally")
library("plotly")

#setwd("/Users/Elise/DataViz/HW3")
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
    scatter_data <- subset(df, select = c("comment", "like", "share", "Total.Interactions", "Type"))
    ggplotly(ggpairs(data = scatter_data, columns = 1:4, columnLabels = colnames(scatter_data)[1:4],mapping = ggplot2::aes(alpha = 0.6, color=Type))+
               theme(legend.position = "none"))
    
  })
  output$parallel <- renderPlotly({
    ggparcoord(data = df, columns = 16:19, groupColumn = 'Type', scale = 'center') 
  })
}

shinyApp(ui = ui, server = server)
