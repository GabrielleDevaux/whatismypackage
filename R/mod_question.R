# Module UI

#' @title   mod_question_ui and mod_question_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#' @param question data.frame of one row containing a question
#' @param placeholder html id
#' @param event event
#' @param delai delay between each question
#'
#' @rdname mod_question
#'
#' @keywords internal
#' @export
#' @importFrom shiny NS tagList
#' @importFrom shinyjs disable
#' @import dplyr
mod_question_ui <- function(id) {
  ns <- NS(id)
}

# Module Server

#' @rdname mod_question
#' @export
#' @keywords internal

mod_question_server <- function(input, output, session, question, placeholder, event, delai) {
  ns <- session$ns

  result <- reactiveValues(score = NULL, close = NULL)

  output$fun_name <- renderUI(
    HTML(paste0("<p class = 'function_name'>", question$functions, "() ?", "</p>"))
  )

  pkgs <- reactive(sample(question %>% select(package, fake1, fake2, fake3) %>% unlist(use.names = FALSE)))

  output$answers <- renderUI({
    tagList(
      lapply(1:4, function(x) {
        actionButton(
          inputId = ns(paste0("btn", x)),
          label = pkgs()[x],
          class = "answers_button"
        )
      })
    )
  })

  disable_all <- function() {
    lapply(1:4, function(x) {
      shinyjs::disable(paste0("btn", x))
    })
  }

  observeEvent(event(), {
    insertUI(
      selector = placeholder,
      ui = tagList(
        wellPanel(
          htmlOutput(outputId = ns("fun_name")),
          tags$br(),
          uiOutput(outputId = ns("answers"))
        )
      )
    )
  })

  check_answer <- function(buttonId, trueanswer, answer) {
    score <- NULL
    if (trueanswer == answer) {
      updateActionButton(session = session, inputId = buttonId, label = "", icon = icon("grin-hearts"))
      score <- 1
    } else {
      updateActionButton(session = session, inputId = buttonId, label = "", icon = icon("sad-cry"))
      score <- 0
    }
    return(score)
  }


  lapply(1:4, function(i) {
    observeEvent(input[[paste0("btn", i)]], {
      result$score <- check_answer(buttonId = paste0("btn", i), trueanswer = question$package, answer = pkgs()[i])
    })
  })


  observeEvent(result$score, {
    disable_all()

    shinyjs::delay(delai, {
      removeUI(selector = placeholder)
      result$close <- TRUE
    })
  })
  return(result)
}

## To be copied in the UI
# mod_question_ui("question_ui_1")

## To be copied in the server
# callModule(mod_question_server, "question_ui_1")
