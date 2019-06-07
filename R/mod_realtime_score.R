# Module UI

#' @title   mod_realtime_score_ui and mod_realtime_score_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#' @param results_question output of the question module
#'
#' @rdname mod_realtime_score
#'
#' @keywords internal
#' @export
#' @import shiny
mod_realtime_score_ui <- function(id) {
  ns <- NS(id)
  tagList(
    tags$div(class = "info_box", htmlOutput(ns("current_score")))
  )
}

# Module Server

#' @rdname mod_realtime_score
#' @export
#' @keywords internal

mod_realtime_score_server <- function(input, output, session, results_question) {
  ns <- session$ns

  res <- reactiveValues(score = NULL, nb_question = NULL)

  observe({
    # convert the results to a list
    results <- lapply(
      X = reactiveValuesToList(results_question),
      FUN = reactiveValuesToList
    )

    # extract the score
    score <- lapply(results, function(x) {
      x$score
    })

    # convert to vector
    scorev <- as.numeric(score[!sapply(score, is.null)])
    res$score <- sum(scorev)
    res$nb_question <- length(scorev)
  })

  output$current_score <- renderUI({
    req(res)
    HTML(paste(
      "<p class = 'info_title'>SCORE</p>",
      paste("<p class = 'info_content'>", res$score, "</p>")
    ))
  })
  return(res)
}

## To be copied in the UI
# mod_realtime_score_ui("realtime_score_ui_1")

## To be copied in the server
# callModule(mod_realtime_score_server, "realtime_score_ui_1")
