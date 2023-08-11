# Generate R6 Class
QuestionnaireResponses <- R6::R6Class(
  classname = "QuestionnaireResponses",
  public = list(
    resp_id = NULL,
    timezone = NULL,
    timestamp = NULL,
    gender = NULL
  )
)

DynamicClass <- R6::R6Class(
  "DynamicClass",
  private = list(
    module_ui = NULL,
    module_server = NULL,
    selector = NULL,
    removal_input_id = NULL,
    session = NULL,
    ids = NULL,
    current_id = NULL,
    results = NULL,
    tabset = FALSE
  ),
  public = list(
    counter = 0,
    initialize = function(
    module_ui = NULL,
    module_server = NULL,
    selector = NULL,
    removal_input_id = NULL,
    tabset = FALSE,
    results = NULL,
    session = shiny::getDefaultReactiveDomain()
    ) {
      
      if (is.null(session)) {
        stop("DynamicClass objects need to be initialized within a Shiny or module server function", call. = FALSE)
      }
      
      private$session <- session
      private$module_ui <- module_ui
      private$module_server <- module_server
      private$selector <- selector
      private$removal_input_id <- removal_input_id
      private$results <- shiny::reactiveValues()
      private$tabset <- tabset
    },
    
    insert = function(display_id = FALSE) {
      private$current_id <- stringi::stri_rand_strings(1, 6)
      #private$current_id <- self$new_id()
      
      ui <- htmltools::tagList(
        htmltools::div(
          id = private$current_id,
          if (display_id) h4(paste("container", private$current_id)),
          private$module_ui(private$current_id)
        )
      )
      
      if (private$tabset) {
        shiny::appendTab(
          inputId = private$selector,
          shiny::tabPanel(
            title = private$current_id,
            ui
          )
        )
      } else {
        shiny::insertUI(
          ui = ui,
          selector = private$selector,
          session = private$session
        )
      }
      
      res <- private$module_server(private$current_id)
      private$results[[private$current_id]] <- res
      private$ids <- c(private$ids, private$current_id)
      
      return(private$current_id)
    },
    
    remove = function(removeId) {
      shiny::removeUI(
        selector = paste0("#", removeId),
        session = private$session
      )
      
      private$ids <- base::setdiff(private$ids, removeId)
      private$results[[removeId]] <- NULL
      return(private$ids)
    },
    
    list_results = function(id = NULL) {
      purrr::walk(names(private$results), ~print(private$results[[.x]]()))
    },
    
    all_ids = function() {
      return(private$ids)
    },
    
    results_obj = function(id = TRUE) {
      selected_ids <- if (isTRUE(id)) {
        names(private$results)
        private$ids
      } else {
        # TODO: Error if any id is not present?
        selected_ids <- id
      }
      result <- lapply(selected_ids, function(selected_id) {
        private$results[[selected_id]]
      })
      setNames(result, selected_ids)
    }
  )
)