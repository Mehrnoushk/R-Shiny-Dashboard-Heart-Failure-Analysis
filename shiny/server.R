library(shiny)
library(tidyverse)
library(gridExtra)
library(shinythemes)

shinyServer(function(input, output) {
  
  data <- reactive({
    req(input$file)
    read.csv(input$file$datapath, header = TRUE)
  })
  
  output$summary <- renderPrint({
    summary(data())
  })
  
  output$select_categorical_columns <- renderUI({
    checkboxGroupInput("categorical_columns", "Select categorical columns:",
                       choices = colnames(data()), selected = NULL)
  })
  
  data_with_factors <- reactive({
    df <- data()
    for (col_name in input$categorical_columns) {
      df[[col_name]] <- as.factor(df[[col_name]])
    }
    df
  })
  
  output$data_table <- DT::renderDataTable({
    DT::datatable(data_with_factors(), options = list(lengthMenu = c(5, 10, 20, 50), pageLength = 10))
  })
  
  output$select_columns <- renderUI({
    selectInput("columns", "Choose a numeric column for plotting:", choices = colnames(data_with_factors()[sapply(data_with_factors(), is.numeric)]), selected = colnames(data_with_factors()[sapply(data_with_factors(), is.numeric)])[1])
  })
  
  output$select_categorical <- renderUI({
    selectInput("categorical", "Choose a categorical column for grouping (optional):", choices = c("None" = "", colnames(data_with_factors()[sapply(data_with_factors(), function(x) is.logical(x) | is.factor(x))])), selected = "")
  })
  
  output$column_labels <- renderUI({
    label_choices <- colnames(data_with_factors()[sapply(data_with_factors(), is.factor)])
    inputs <- lapply(seq_along(label_choices), function(i) {
      name <- label_choices[i]
      id <- paste0("label_", name)
      label <- paste0(name, ": ")
      textInput(id, label, value = "")
    })
    do.call(tagList, inputs)
  })
  
  labeled_data <- reactive({
    labeled <- data_with_factors()
    for (col in colnames(labeled)[sapply(labeled, is.factor)]) {
      labels_str <- input[[paste0("label_", col)]]
      if (labels_str != "") {
        labels <- strsplit(labels_str, "\\s*,\\s*")[[1]]
        levels(labeled[[col]]) <- labels
      }
    }
    labeled
  })
  
  output$data_table_labeled <- DT::renderDataTable({
    DT::datatable(labeled_data(), options = list(lengthMenu = c(5, 10, 20, 50), pageLength = 10))
  })
  
  output$plots <- renderPlot({
    req(input$columns, input$plot_types)
    
    if (input$categorical != "") {
      selected_data <- labeled_data()[, c(input$columns, input$categorical)]
    } else {
      selected_data <- labeled_data()[, input$columns, drop = FALSE]
    }
    
    num_plots <- length(input$plot_types)
    num_rows <- ceiling(num_plots / input$plots_per_row)
    num_cols <- ceiling(num_plots / input$plots_per_col)
    
    plots <- list()
    for (i in seq_len(num_plots)) {
      plot_type <- input$plot_types[i]
      if (plot_type == "hist") {
        p <- ggplot(selected_data, aes_string(x = input$columns)) +
          geom_histogram(bins = input$hist_bins, fill = "dodgerblue", color = "black", alpha = 0.8)
        p <- p + theme_minimal() + labs(title = "Histogram")
        if (input$categorical != "") {
          p <- p + facet_wrap(~ .data[[input$categorical]], ncol = input$plots_per_row)
        }
        plots <- append(plots, list(p))
      } else if (plot_type == "density") {
        p <- ggplot(selected_data, aes_string(x = input$columns, fill = input$categorical)) +
          geom_density(alpha = 0.6) +
          theme_minimal() + labs(title = "Density Plot")
        if (input$categorical != "") {
          p <- p + scale_fill_discrete(name = input$categorical)
        } else {
          p <- p + guides(fill = FALSE)
        }
        plots <- append(plots, list(p))
      } else if (plot_type == "box") {
        p <- ggplot(selected_data, aes_string(x = input$categorical, y = input$columns, fill = input$categorical)) +
          geom_boxplot(alpha = 0.6) +
          theme_minimal() + labs(title = "Box Plot")
        if (input$categorical != "") {
          p <- p + scale_fill_discrete(name = input$categorical)
        } else {
          p <- p + guides(fill = FALSE)
        }
        plots <- append(plots, list(p))
      } else if (plot_type == "violin") {
        p <- ggplot(selected_data, aes_string(x = input$categorical, y = input$columns, fill = input$categorical)) +
          geom_violin(alpha = 0.6) +
          theme_minimal() + labs(title = "Violin Plot")
        if (input$categorical != "") {
          p <- p + scale_fill_discrete(name = input$categorical)
        } else {
          p <- p + guides(fill = FALSE)
        }
        plots <- append(plots, list(p))
      }
    }
    
    do.call("grid.arrange", c(plots, ncol = num_cols, nrow = num_rows))
  })
})
