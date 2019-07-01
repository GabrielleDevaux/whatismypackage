
#' run_app2
#'
#' Run the Shiny Application
#'
#' @param usecase local, shinyappsio or remote
#' @param ec_host ethercalc host
#' @param ec_room ethercalc room
#' @param data data 
#' @param score_path score path
#' @param timersec timer
#'
#' @return
#' @export
#'

run_app <- function(usecase, ec_host = "", ec_room = "", data = "", score_path = "", timersec = 40) {
  if (usecase %in% c("local", "shinyappsio", "remote")) {

    # score_path = path to .csv in /inst/app/www
    # data = path to .RData in /inst/app/www
    load(data)

    delai <- 500
    n_quest <- timersec * 1000/delai + 1
    
    with_golem_options(
      app = shiny::shinyApp(ui = app_ui(n_quest = n_quest), server = app_server),
      golem_opts = list(usecase = usecase,
                        ec_host = ec_host,
                        ec_room = ec_room,
                        all_funs = all_funs,
                        theme_choices = unique(all_funs$theme), 
                        timersec = timersec,
                        delai = delai,
                        n_quest = n_quest,
                        score_path = score_path)
    )
    
  } else {
    stop("Enter a valid usecase")
  }
}
