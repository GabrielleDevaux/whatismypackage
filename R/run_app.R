
#' run_app
#'
#' Run the Shiny Application
#'
#' @param usecase local, shinyappsio or remote
#' @param ec_host ethercalc host
#' @param ec_room ethercalc room
#'
#' @return
#' @export
#'

run_app <- function(usecase, ec_host = "", ec_room = "") {
  if (usecase %in% c("local", "shinyappsio", "remote")) {
    if (usecase == "local") {
      .GlobalEnv$.USECASE <- "local"
    }
    if (usecase == "shinyappsio") {
      .GlobalEnv$.USECASE <- "shinyappsio"
      if (ec_host == "" | ec_room == "") {
        stop("Enter a valid ec_host and ex_room")
      } else {
        .GlobalEnv$.EC_HOST <- ec_host
        .GlobalEnv$.EC_ROOM <- ec_room
      }
    }
    if (usecase == "remote") {
      .GlobalEnv$.USECASE <- "remote"
    }
    on.exit(rm(.USECASE, .EC_HOST, .EC_ROOM, envir = .GlobalEnv))
    shiny::runApp(system.file("app", package = "whatismypackage"))
  } else {
    stop("Enter a valid usecase")
  }
}
