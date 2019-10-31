# this file must be saved as app.R; then you get a Run App button appear. Otherwise it won't work!

library(tidyverse)
library(shiny)
library(shinythemes)

# note read_csv rather than read.csv (reads into a tibble with readr package)
# ALWAYS use read_csv (doesn't have strings as factors problem, can be faster)
spooky <- read_csv("spooky_data.csv")

# workflow we used was:
#  1) in UI, create widgets, specify input
#  2) in server, take that input and do something with it, make output
#  3) in UI, call output and make it appear

# a note that "inputs" are things that go from UI to server, and "outputs" go from server to UI

# User Interface
# watch out for the many nested parentheses!

ui <- fluidPage(  # fluid page is the 'net' around the user interface
  titlePanel("Awesome Halloween app"),  # add a title to the app
  sidebarLayout(  # specifies a layout for the app page with a sidebar
    sidebarPanel("These are my widgets:", # put widgets in sidebar panel; you don't have to but it is common
                 selectInput(
                   inputId = "state_select", # name of the input; important for server below, must match
                   label = "Choose a state:",
                   choices = unique(spooky$state) # dropdown options will be all unique states in data frame (but can also manually specify options if you don't want all of them)
                 ), # this is an R Shiny widget; can Google for list of many widget options
                 radioButtons(inputId = "region_select",
                              label = "Choose a region:",
                              choices = unique(spooky$region_us_census)
                 )
                 ),
    mainPanel("These are my outputs",
              tableOutput(outputId = "candy_table"))
  )
)

# server is a function
server <- function(input, output) {

  # when you create a reactive subset, no parenthese are needed, but you DO need them when you call it later
  state_candy <- reactive({  # need both parentheses and brackets
    spooky %>% # control+shift+m for pipe
      filter(state == input$state_select) # filter spooky dataset based on what user selected for state
  })

  output$candy_table <- renderTable({
    state_candy()
  })

}

# specify the user interface and server for the app

shinyApp(ui = ui, server = server)
