# Module UI

#' @title   mod_hello_ui and mod_hello_server
#' @description  A shiny Module. A "hello" popup to introduce the game and its rules.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_hello
#'
#' @keywords internal
#' @export
#' @importFrom shiny NS tagList
#'
mod_hello_ui <- function(id) {
  ns <- NS(id)
}

# Module Server

#' @rdname mod_hello
#' @export
#' @keywords internal

mod_hello_server <- function(input, output, session) {
  ns <- session$ns

  showModal(modalDialog(
    title = tags$div("Welcome to \"What is my package ?\" game !",
      style = "text-align:center;"
    ),
    tags$br(),
    tags$p(paste("Find the good package for as much R functions as possible in", timersec, "seconds !")),
    tags$p("Each function can belong to only one package."),

    tags$br(),

    tags$p("Choose a theme and click the play button to begin the game !"),

    fluidRow(
      column(
        width = 6,
        offset = 3,
        align = "center",
        tags$div(selectInput(
          inputId = ns("choice_theme"),
          label = "",
          choices = theme_choices
        ),
        style = "text-align : center; display: block;"
        )
      )
    ),


    footer =
      actionButton(
        inputId = ns("play"),
        label = "Play",
        icon = icon("play")
      )
  ))

  observeEvent(input$play, {
    removeModal()
  })

  return(list(start = reactive(input$play), theme = reactive(input$choice_theme)))
}

## To be copied in the UI
# mod_hello_ui("hello_ui_1")

## To be copied in the server
# callModule(mod_hello_server, "hello_ui_1")