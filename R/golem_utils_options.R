#' get_golem_options
#'
#' @param which number or name of element
#'
#' @importFrom shiny getShinyOption
#' @export

get_golem_options <- function(which = NULL){
  if (is.null(which)){
    getShinyOption("golem_options")
  } else {
    getShinyOption("golem_options")[[which]]
  }
}

#' with_golem_options
#'
#' @param app shiny app object
#' @param golem_opts options
#'

with_golem_options <- function(app, golem_opts){
  app$appOptions$golem_options <- golem_opts
  app
}