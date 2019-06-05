# Module UI

#' @title   mod_playagain_ui and mod_playagain_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#' @param timer timer
#'
#' @rdname mod_playagain
#'
#' @keywords internal
#' @export
#' @importFrom shiny NS tagList
mod_playagain_ui <- function(id) {
  ns <- NS(id)
  tagList()
}

# Module Server

#' @rdname mod_playagain
#' @export
#' @keywords internal

mod_playagain_server <- function(input, output, session, timer, results_question) {
  ns <- session$ns
  observe({
    if (timer() == 0) { # or timer() < 1 ? idk what is best

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
      res <- as.numeric(score[!sapply(score, is.null)])

      # Display the end popup
      showModal(modalDialog(
        title = tags$div("Time is over !",
          style = "text-align:center;"
        ),

        paste("Your score is", sum(res), "points over", length(res), "questions in", timersec, "seconds."),

        tags$p(ifelse(is.na(sum(res) / length(res)),
          "You can do better !",
          ifelse(sum(res) / length(res) >= 0.5,
            "Congratulations !",
            "You can do better !"
          )
        ),
        class = "congrats"
        ),

        footer = actionButton(
          inputId = ns("play_again"),
          label = "Play again",
          icon = icon("play")
        ),
        id = "end_popup"
      ))
    }
  })

  return(reactive(input$play_again))
}

## To be copied in the UI
# mod_playagain_ui("playagain_ui_1")

## To be copied in the server
# callModule(mod_playagain_server, "playagain_ui_1")
