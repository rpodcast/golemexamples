#' @importFrom shiny tagList div insertUI
stateInsertUI <- function(
    moduleUI,
    moduleServer,
    session = shiny::getDefaultReactiveDomain(),
    selector,
    ...
) {
  
  # create random ID for input container
  new_id <- stringi::stri_rand_strings(1, 6)
  
  # establish slots in session$userData to track state
  if (is.null(session$userData$sets_ids)) {
    session$userData$sets_ids <- c()
  }
  
  session$userData$sets_ids <- c(
    session$userData$sets_ids, 
    new_id
  )
  
  # assemble UI container
  ui <- tagList(
    div(
      id = new_id,
      moduleUI(new_id)
    )
  )
  
  insertUI(
    ui = ui,
    selector = selector, 
    session = session,
    ...
  )
  
  if (is.null(session$userData$results)) {
    session$userData$results <- list()
  }
  
  session$userData$results[[new_id]] <- moduleServer(new_id)
  
  return(session$userData$sets_ids)
}

#' @importFrom shiny removeUI
stateRemoveUI <- function(
    removeId,
    session = shiny::getDefaultReactiveDomain(),
    ...
) {
  
  removeUI(
    selector = paste0("#", removeId), 
    session = session, 
    ...
  )
  
  session$userData$sets_ids <- base::setdiff(session$userData$sets_ids, removeId)
  
  session$userData$results[[removeId]] <- NULL
  
  return(session$userData$sets_ids)
}
