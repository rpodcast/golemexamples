#' dynamic UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList fluidRow column selectInput checkboxGroupInput
mod_dynamic_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      column(
        width = 4,
        selectInput(
          ns("type"),
          "Type",
          choices = c(
            "Alpha" = "alpha",
            "Beta" = "beta",
            "Gamma" = "gamma"
          ),
          selected = "alpha"
        )
      ),
      column(
        width = 4,
        checkboxGroupInput(
          ns("methods"),
          "Choose Method",
          choices = c(
            "Frequentist" = "freq",
            "Bayesian" = "bayes",
            "Machine Learning" = "ml"
          )
        )
      )
    )
  )
}
    
#' dynamic Server Functions
#'
#' @noRd 
#' 
#' @importFrom shiny reactive
mod_dynamic_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # assemble input values into a reactive list
    res <- reactive({
      list(
        type = input$type,
        methods = input$methods
      )
    })
    
    return(res)
  })
}
    
## To be copied in the UI
# mod_dynamic_ui("dynamic_ui_1")
    
## To be copied in the server
# mod_dynamic_server("dynamic_ui_1")
