library("shiny")
library("ggplot2")
library("GGally")
library("plotly")

setwd("/Users/Elise/DataViz/HW3")
rm(list = ls())
cat("\014") 

library("ggplot2")
library(shiny)
library(plotly)

df <- read.csv("dataset_Facebook.csv", sep=";", header=T)

# Bubble Plot
# x=like, y=Lifetime.Post.Total.Impressions, size=Engaged.Users, interaction_1=type

# Scatter Plot Matrix
# x_facets=weekday, y_facets=type, x=interaction(like,comment,share), y=interaction(Lifetime...)

# Parallel Coordinates Plot
# x=c(comment, like, share, total), y=c(lifetime.etc), interaction_1=type

# # Define UI for application
# ui <- fluidPage(
#   headerPanel("Facebook Metrics"),
#   sidebarPanel(
#     sliderInput('Post.Month','Select Month', value = 1, min = 1, 
#                 max = 12, step = 1)
#   ),
#   mainPanel(tabsetPanel(
#     tabPanel("BubblePlot", plotlyOutput("BubblePlot")),
#     tabPanel("ScatterPlot Matrix", plotOutput("ScatterPlot_Matrix")),
#     tabPanel("Parallel", plotlyOutput("Parallel"))
#   ))
# )

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

#ggpairs(df, columns = c(16:18))


# Define server logic required to draw a histogram
server <- function(input, output) {
  output$bubble <- renderPlotly({
    ggplot(df, aes(like, Lifetime.Post.Total.Impressions)) +
      geom_point(aes(size = Total.Interactions, colour = Type))
    # theme(plot.title = element_text(hjust = 0.5), legend.justification = c("right", "top")) 
    # scale_size(range = c(1, 6)*input_size()) +
    # guides(size= "none")
  })
  output$scatter <- renderPlotly({
    ggpairs(df, columns = c(16:19), columnLabels = colnames(df)[16:19])
  })
  output$parallel <- renderPlotly({
    ggparcoord(data = df, columns = 16:19, groupColumn = 'Type', scale = 'center') 
  })
}

# Run the application 
shinyApp(ui = ui, server = server)