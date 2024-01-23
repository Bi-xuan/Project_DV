library(openxlsx)
library(shiny)
library(dplyr)
library(tidyverse)

df_rs <- read.xlsx("data_reshaped.xlsx")

# Rename columns
colnames(df_rs) <- c("Category", "Date","Value")

# Convert date column to Date format
df_rs$Date <- as.numeric(df_rs$Date)
df_rs$Date <- as.Date(df_rs$Date, origin = "1899-12-30")

# UI
ui <- fluidPage(selectInput(inputId = "Category", 
                            label = "Choose an Entry", 
                            choices = df_rs$Category[!duplicated(df_rs$Category)], 
                            multiple = TRUE,
                            selected = "Number of unemployed"), 
                plotOutput("line"))

server <- function(input, output) {
  output$line <- renderPlot({
    ggplot(df_rs %>% filter(Category == input$Category), 
           aes(Date, Value, 
               color = Category, group = Category)) + geom_line() + 
      labs(title = "Labor Market of Luxembourg",x=NULL, y=NULL, color=NULL) +
      theme_bw( base_size = 15)
  })
}

# View App
shinyApp(ui, server)