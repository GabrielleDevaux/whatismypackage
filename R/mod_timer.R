# Module UI

#' @title   mod_timer_ui and mod_timer_server
#' @description  A shiny Module. A timer
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#' @param start bool
#' @param seconds integer
#'
#' @rdname mod_timer
#'
#' @keywords internal
#' @export
#' @import shiny
#' @importFrom lubridate seconds_to_period
mod_timer_ui <- function(id) {
  ns <- NS(id)
  tagList(
    tags$div(class = "info_box", htmlOutput(ns("timeleft")))
  )
}

# Module Server

#' @rdname mod_timer
#' @export
#' @keywords internal

mod_timer_server <- function(input, output, session, start = reactive(0), seconds) {
  ns <- session$ns

  # Initialize the timer, 5 seconds, not active.
  timer <- reactiveVal(seconds)
  active <- reactiveVal(FALSE)

  # Output the time left.
  output$timeleft <- renderUI({
    HTML(paste(
      "<p class = 'info_title'>REMAINING TIME</p>",
      paste("<p class = 'info_content'>", seconds_to_period(timer()), "</p>")
    ))
  })

  # observer that invalidates every second. If timer is active, decrease by one.
  observe({
    invalidateLater(1000, session)
    isolate({
      if (active()) {
        timer(timer() - 1)
        if (timer() < 1) {
          active(FALSE)
        }
      }
    })
  })

  observeEvent(start(), {
    active(TRUE)
  })

  return(timer)
}

## To be copied in the UI
# mod_timer_ui("timer_ui_1")

## To be copied in the server
# callModule(mod_timer_server, "timer_ui_1")
