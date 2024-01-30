library(shiny)
library(tidyverse)
library(gridExtra)
library(shinythemes)

shinyUI(fluidPage(theme = shinytheme("flatly"),
                  titlePanel("UCI Heart Failure Dataset EDS"),
                  
                  tabsetPanel(
                    tabPanel("Input",
                             sidebarLayout(
                               sidebarPanel(
                                 fileInput("file", "Upload CSV file", accept = c(".csv")),
                                 tags$hr(),
                                 h4("Data Summary"),
                                 verbatimTextOutput("summary"),
                                 tags$hr(),
                                 h4("Categorical Column Selection"),
                                 uiOutput("select_categorical_columns")
                               ),
                               mainPanel(
                                 DT::dataTableOutput("data_table")
                               )
                             )
                    ),
                    tabPanel("Preprocessing",
                             sidebarLayout(
                               sidebarPanel(
                                 h4("Column Labels"),
                                 uiOutput("column_labels")
                               ),
                               mainPanel(
                                 DT::dataTableOutput("data_table_labeled")
                               )
                             )
                    ),
                    tabPanel("Plots",
                             sidebarLayout(
                               sidebarPanel(
                                 h4("Column Selection for Plotting"),
                                 uiOutput("select_columns"),
                                 uiOutput("select_categorical"),
                                 tags$hr(),
                                 h4("Plot Options"),
                                 checkboxGroupInput("plot_types", "Choose plot types:",
                                                    choices = list("Histogram" = "hist",
                                                                   "Density Plot" = "density",
                                                                   "Box Plot" = "box",
                                                                   "Violin Plot" = "violin")),
                                 conditionalPanel(
                                   condition = "input.plot_types.indexOf('hist') > -1",
                                   sliderInput("hist_bins", "Number of bins for histogram:",
                                               min = 5, max = 100, value = 30, step = 1)
                                 ),
                                 tags$hr(),
                                 h4("Plot Layout"),
                                 sliderInput("plots_per_row", "Plots per row:", min = 1, max = 6, value = 3),
                                 sliderInput("plots_per_col", "Plots per column:", min = 1, max = 6, value = 2)
                               ),
                               mainPanel(
                                 plotOutput("plots")
                               )
                             )
                    )
                  )
))
