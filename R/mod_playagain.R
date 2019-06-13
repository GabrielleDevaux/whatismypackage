# Module UI

#' @title   mod_playagain_ui and mod_playagain_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#' @param timer timer
#' @param score current score and number of answered questions
#' @param theme theme
#' @param usecase usecase
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

mod_playagain_server <- function(input, output, session, timer, score, theme, usecase = .USECASE) {
  ns <- session$ns
  observe({
    if (timer() == 0) {

      # Display the end popup
      showModal(modalDialog(
        size = "l",
        title = tags$div(paste("Time is over !", "Your score is", score$scorecumul,"points !"),
          style = "text-align:center;"
        ),

        paste("You made", score$score, "correct answers out of", score$nb_question, "questions in", timersec, "seconds."),

        tags$p(ifelse(is.na(score$score / score$nb_question),
          "You can do better !",
          ifelse(score$score / score$nb_question >= 0.5,
            "Congratulations !",
            "You can do better !"
          )
        ),
        class = "congrats"
        ),

        tags$hr(),

        mod_add_user_score_ui(ns("add_user_score_ui_1"),
          curr_theme = theme
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

  callModule(mod_add_user_score_server, "add_user_score_ui_1",
    curr_theme = theme,
    score = score$scorecumul
  )

  return(reactive(input$play_again))
}

## To be copied in the UI
# mod_playagain_ui("playagain_ui_1")

## To be copied in the server
# callModule(mod_playagain_server, "playagain_ui_1")
