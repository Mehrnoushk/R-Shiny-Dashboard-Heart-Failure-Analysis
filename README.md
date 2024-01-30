# UCI Heart Failure Dataset EDS

This is a Shiny web application for exploratory data analysis (EDA) of the [UCI Heart Failure Dataset](https://archive.ics.uci.edu/ml/datasets/Heart+failure+clinical+records). It allows the user to upload a CSV file of the dataset, mark categorical variables, define labels for categorical variables, and generate various plots.

<div style="text-align: center;">
    <img src="https://github.com/Mehrnoushk/R-Shiny-Dashboard-Heart-Failure-Analysis/blob/main/assets/shiny-app-01.jpg?raw=true" width="75%">
</div>

## Installation

To run this app locally, you'll need to have R and RStudio installed on your machine. You can download them here:

- [R](https://www.r-project.org/)
- [RStudio](https://www.rstudio.com/products/rstudio/download/)

Once you have R and RStudio installed, you can download this repository and open the `ui.R` file in RStudio. Then, you can click the "RunApp" button in the top right corner of the script editor to launch the app in your web browser.

## Usage

Once the app is running in your web browser, you can use the tabs at the top of the app to navigate between different sections:

- **Load Data and Categorical Selection**: Use this tab to upload your CSV file and mark the categorical variables in the dataset.
- **Preprocessing**: Use this tab to define labels for the categorical variables in the dataset.
- **Plots**: Use this tab to generate various plots of the numeric variables in the dataset.

You can modify various plot parameters such as the number of bins, x and y limits, and plot layout in the "Plots" tab using the sidebar on the left.

## Dataset

The UCI Heart Failure Dataset can be found at the following link: https://archive.ics.uci.edu/ml/datasets/Heart+failure+clinical+records

## Contributing

If you find any bugs or issues with this app, or if you have any suggestions for improvements, please open an issue or submit a pull request in this repository.

## Credits

The dataset used in this app is the [UCI Heart Failure Dataset](https://archive.ics.uci.edu/ml/datasets/Heart+failure+clinical+records).

