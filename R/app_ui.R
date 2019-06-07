#' @import shiny
#' @import shinydashboard
#' @param n_quest number of questions to generate
app_ui <- function(n_quest = 20) {
  tagList(
    # Leave this function for adding external resources
    # from inst/app/www
    golem_add_external_resources(),
    golem::js(),
    golem::favicon(),
    shinyjs::useShinyjs(),
    # includeCSS("www/custom.css"),

    # List the first level UI elements here

    dashboardPage(
      dashboardHeader(
        title = "What is my package ?"
      ),
      dashboardSidebar(
        disable = TRUE
      ),
      dashboardBody(
        tags$br(),

        fluidRow(
          column(
            width = 3,
            # display timer
            mod_timer_ui("timer_ui_1")
          ),
          column(
            width = 3,
            offset = 6,
            # display score
            mod_realtime_score_ui("realtime_score_ui_1")
          )
        ),

        # create place for questions
        fluidRow(
          column(
            width = 8,
            offset = 2,
            lapply(1:n_quest, function(x) {
              tags$div(id = paste0("placeholder", x), class = "question_placeholder")
            })
          )
        )
      )
    )
  )
}

golem_add_external_resources <- function() {
  addResourcePath(
    "www", system.file("app/www", package = "whatismypackage")
  )

  tagList(
    # Add here all the external resources
    # If you have a custom.css in the inst/app/www
    tags$link(rel = "stylesheet", type = "text/css", href = "www/custom.css")
  )
}
