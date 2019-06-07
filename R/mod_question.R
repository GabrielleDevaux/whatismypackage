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
#' @import shiny
#' @importFrom shinyjs disable removeCssClass addCssClass
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

  # initialize the results
  result <- reactiveValues(score = NULL, close = NULL)

  # generate question
  output$fun_name <- renderUI(
    HTML(paste0("<p class = 'function_name'>", question$functions, "() ?", "</p>"))
  )

  # shuffle good answer / bad answers
  pkgs <- reactive(sample(question %>% select(package, fake1, fake2, fake3) %>% unlist(use.names = FALSE)))

  # generate answer buttons
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

  # when the previous question is over, display the current question
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

  # check if clicked button is the good answer
  check_answer <- function(buttonId, trueanswer, answer) {
    score <- NULL
    if (trueanswer == answer) {
      shinyjs::removeCssClass(id = buttonId, class = "answers_button")
      shinyjs::addCssClass(id = buttonId, class = "true_button")
      score <- 1
    } else {
      shinyjs::removeCssClass(id = buttonId, class = "answers_button")
      shinyjs::addCssClass(id = buttonId, class = "false_button")
      score <- 0
    }
    return(score)
  }

  # reaction to a clicked answer : check if it is the good one
  lapply(1:4, function(i) {
    observeEvent(input[[paste0("btn", i)]], {
      result$score <- check_answer(buttonId = paste0("btn", i), trueanswer = question$package, answer = pkgs()[i])
    })
  })

  # show the good answer anyway
  show_true <- function() {
    lapply(1:4, function(i) {
      if (pkgs()[i] == question$package) {
        shinyjs::delay(100, {
          shinyjs::removeCssClass(id = paste0("btn", i), class = "answers_button")
          shinyjs::addCssClass(id = paste0("btn", i), class = "true_button")
        })
      }
    })
  }
  # disable all buttons when one is clicked
  disable_all <- function() {
    lapply(1:4, function(i) {
      shinyjs::disable(paste0("btn", i))
    })
  }

  # when a button is clicked = when the score isn't null anymore, disable buttons
  # and show true answer
  observeEvent(result$score, {
    disable_all()
    show_true()

    # wait a few milliseconds so the user sees if the answer is good or not
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
