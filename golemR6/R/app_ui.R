#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    
    # List the first level UI elements here 
    fluidPage(
      h2("Dynamic UI Generation"),
      
      fluidRow(
        column(
          width = 12,
          tabsetPanel(
            id = "add_tabs_here",
          ),
          actionButton("add_tabs", "Add Tabs"),
          actionButton("remove_tabs", "Remove Tabs"),
          selectInput(
            "tab_to_remove",
            "Select tab to remove",
            choices = NULL
          )
        )
      ),
      
      fluidRow(
        column(
          width = 6,
          # placeholder for UI elements
          div(id = "add_inputs_here")
        ),
        column(
          width = 3,
          h4("Single Result View"),
          verbatimTextOutput("single_value")
        ),
        column(
          width = 3,
          h4("Multiple Results View"),
          verbatimTextOutput("values")
        )
      ),
      
      fluidRow(
        actionButton("add_inputs", "Add Inputs"),
        actionButton("remove_inputs", "Remove Inputs"),
        selectInput(
          "set_to_remove",
          "Select set to remove",
          choices = NULL
        )
      )
      # mod_a_ui("a_ui_1"),
      # mod_b_ui("b_ui_1")
    )
  )
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
 
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'golemR6'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

