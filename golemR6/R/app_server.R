#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @import gargoyle
#' @import R6
#' @noRd
app_server <- function( input, output, session ) {
  # Your application server logic
  
  last_id <- reactiveVal(NULL)
  last_id_tab <- reactiveVal(NULL)
  
  # class representing standalone UI insertion
  x <- DynamicClass$new(
    module_ui = mod_dynamic_ui,
    module_server = mod_dynamic_server,
    selector = paste0('#', "add_inputs_here"),
    removal_input_id = "set_to_remove",
    session = session
  )
  
  # class representing tabset UI insertion
  x_tabs <- DynamicClass$new(
    module_ui = mod_dynamic_ui,
    module_server = mod_dynamic_server,
    selector = "add_tabs_here",
    removal_input_id = "tab_to_remove",
    session = session,
    tabset = TRUE
  )
  
  # add dynamic UI set (tabset)
  observeEvent(input$add_tabs, {
    id <- x_tabs$insert()
    
    last_id_tab(id)
    # update selectInput
    updateSelectInput(
      session,
      "tab_to_remove",
      choices = x_tabs$all_ids()
    )
  })
  
  # add dynamic UI set (standalone)
  observeEvent(input$add_inputs, {
    id <- x$insert(display_id = TRUE)
    #last_id(tail(ids, n = 1))
    last_id(id)
    # update selectInput
    updateSelectInput(
      session,
      "set_to_remove",
      choices = x$all_ids()
    )
  })
  
  # remove selected dynamic UI container
  observeEvent(input$remove_inputs, {
    req(input$set_to_remove)
    removeId <- input$set_to_remove
    ids <- x$remove(removeId)
    last_id(tail(ids, n = 1))
    # update selectInput
    updateSelectInput(
      session,
      "set_to_remove",
      choices = ids
    )
  })
  
  output$single_value <- renderPrint({
    req(last_id())
    lapply(x$results_obj(last_id()), function(obj) {
      print(obj())
    })
  })
  
  output$values <- renderPrint({
    lapply(x$results_obj(), function(obj) {
      print(obj())
    })
  })
  
  # # Triggers
  # init("printinfo")
  # 
  # # Create new object to share data across modules using the R6 Class
  # questionnaire_responses <- QuestionnaireResponses$new()
  # 
  # # List the first level callModules here
  # callModule(mod_a_server, "a_ui_1", questionnaire_responses)
  # callModule(mod_b_server, "b_ui_1", questionnaire_responses)
}
