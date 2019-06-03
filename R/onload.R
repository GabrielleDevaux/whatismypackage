#' Adds the content of www to www/ from this package
#'
#' @importFrom shiny addResourcePath
#'
#' @noRd
.onLoad <- function(...) {
  shiny::addResourcePath('www', system.file('app/www', package = 'whatismypackage'))
  shiny::addResourcePath("sbs", system.file("www", package="shinyBS"))
  # shinyBS won't work if not added to resource path
}
