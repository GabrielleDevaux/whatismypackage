# Module UI

#' @title   mod_add_user_score_ui and mod_add_user_score_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#' @param curr_theme theme
#' @param score score
#' @param usecase usecase
#' @param ec_room ethercalc room for saving scores
#' @param ec_host ethercalc host
#' @param scores_path score path
#'
#' @rdname mod_add_user_score
#'
#' @keywords internal
#' @export
#' @import shiny
#' @import dplyr
#' @importFrom DT renderDT DTOutput datatable
#' @importFrom shinyjs disable click delay
#' @importFrom ethercalc ec_edit ec_read
#' @importFrom utils read.table
mod_add_user_score_ui <- function(id, curr_theme, theme_choices){
  ns <- NS(id)
  tagList(
    splitLayout(
      tagList(
        tags$br(),

        fluidRow(
          column(
            width = 10,
            offset = 1,
            align = "center",
            textInput(
              inputId = ns("nickname"),
              label = "",
              placeholder = "Nickname"
            )
          ),
          style = "padding:0px;margin:0px;"
        ),

        tags$br(),
        fluidRow(
          column(
            width = 6,
            offset = 6,
            align = "center",
            actionButton(
              inputId = ns("validate"),
              label = "Save my score",
              icon = icon("save")
            )
          ),
          style = "padding:0px;margin:0px;"
        ),

        htmlOutput(ns("apologies")),

        tags$hr(),
        fluidRow(
          column(
            width = 10,
            offset = 1,
            align = "center",
            selectInput(
              inputId = ns("theme"),
              label = "Display scores from : ",
              choices = c("All", theme_choices),
              selected = curr_theme()
            )
          ),
          style = "padding:0px;margin:0px;"
        ),

        tags$br(),
        fluidRow(
          column(
            width = 6,
            offset = 6,
            align = "center",
            actionButton(
              inputId = ns("refresh"),
              label = "Refresh scores",
              icon = icon("sync")
            )
          ),
          style = "padding:0px;margin:0px;"
        )
      ),
      DT::DTOutput(ns("table_score")),
      cellWidths = c("40%", "60%")
    )
  )
}

# Module Server

#' @rdname mod_add_user_score
#' @export
#' @keywords internal

mod_add_user_score_server <- function(input, output, session, curr_theme, score,
                                      usecase, ec_room, ec_host,
                                      scores_path) {
  ns <- session$ns
  
  
  output$apologies <- renderUI({
    if(usecase == "shinyappsio"){
      res <- tags$div("Apologies : the score saving is experimental and may not work everytime. Please be gentle with the button, wait a few seconds and refresh scores before trying again.",
                        style = "white-space: pre-wrap; word-break: keep-all; padding:0px;margin:0px; margin-right:10px; font-size:80%; font-style:italic;"
      )
    } else { 
      res <- ""
    }
    res
  })
  

  observeEvent(input$validate, {
    if (input$nickname != "") {
      newline <- data.frame(
        Date = as.character(format(Sys.Date(), "%d - %m - %Y")),
        Theme = curr_theme(),
        Nickname = input$nickname,
        Score = score,
        stringsAsFactors = FALSE
      )

      if (usecase == "local") {
        # save score with local file
        write(paste(newline[1, ], collapse = ";"), file = scores_path, append = TRUE)
        table_scores <- read.table(scores_path, sep = ";", header = TRUE, stringsAsFactors = FALSE)
      } else if (usecase == "shinyappsio") {
        # save score on ethercalc
        data <- ec_read(room = ec_room, ec_host = ec_host)
        data <- rbind(data, newline)
        ec_edit(data, room = ec_room, browse = FALSE, ec_host = ec_host)
        # ec_append(newline, room = .EC_ROOM, browse = FALSE, ec_host = .EC_HOST)
        Sys.sleep(2) # little delay
        table_scores <- ec_read(room = ec_room, ec_host = ec_host)
      }

      # disable saving button to avoid double save
      if (nrow(merge(table_scores, newline)) >= 1) {
        shinyjs::disable("validate")
        shinyjs::disable("nickname")
        shinyjs::click("refresh")
      }
    }
  })

  output$table_score <- DT::renderDT({
    input$refresh

    if (usecase == "local") {
      # read score locally
      table_scores <- read.table(scores_path, sep = ";", header = TRUE, stringsAsFactors = FALSE)
    } else if (usecase == "shinyappsio") {
      # read score on ethercalc
      table_scores <- ec_read(room = ec_room, ec_host = ec_host)
    }

    if (input$theme != "All" & nrow(table_scores) > 0) {
      # filter by theme
      table_scores <- table_scores[table_scores$Theme == input$theme, ]
    }

    DT::datatable(
      table_scores,
      rownames = FALSE,
      options = list(
        scrollX = TRUE,
        pageLength = 6,
        lengthChange = FALSE,
        order = list(list(3, "desc"))
      )
    )
  })
}

## To be copied in the UI
# mod_add_user_score_ui("add_user_score_ui_1")

## To be copied in the server
# callModule(mod_add_user_score_server, "add_user_score_ui_1")
