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
#'
#' @rdname mod_add_user_score
#'
#' @keywords internal
#' @export 
#' @import shiny 
#' @importFrom DT renderDataTable dataTableOutput datatable
#' @importFrom shinyjs disable click
mod_add_user_score_ui <- function(id, curr_theme){
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
            actionButton(inputId = ns("validate"),
                         label = "Save my score",
                         icon = icon("save"))
          ),
          style = "padding:0px;margin:0px;"
        ),
        
        tags$br(),
        tags$br(),
        fluidRow(
          column(
            width = 10,
            offset = 1,
            align = "center",
            selectInput(
              inputId = ns("theme"),
              label = "Display scores from : ",
              choices = c('All',theme_choices),
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
      DT::dataTableOutput(ns("table_score")),
      cellWidths = c("40%","60%")
    )
    
    
    
  )
}
    
# Module Server
    
#' @rdname mod_add_user_score
#' @export
#' @keywords internal
    
mod_add_user_score_server <- function(input, output, session, curr_theme, score){
  ns <- session$ns
  
  observeEvent(input$validate,{
    if(input$nickname!=""){
      newline = paste(
        as.character(Sys.Date()),
        curr_theme(),
        input$nickname,
        score,
        sep = ";"
      )
      
      write(newline, file = "save_scores.txt", append = TRUE)

      # table_scores <- table_scores[order(-as.numeric(table_scores$Score), as.Date(table_scores$Date)),]
      
      # table_scores <- rbind(table_scores, newline)
      # table_scores$Rank <- 1:nrow(table_scores)
      # write.table(table_scores, file = "save_scores.txt", sep = ";", 
      #             row.names = FALSE,
      #             quote = FALSE)
      
      table_scores <- read.table("save_scores.txt", sep = ";", header = TRUE, stringsAsFactors = FALSE)
      
      if(nrow(merge(table_scores,newline))>1){
        shinyjs::disable("validate")
        shinyjs::disable("nickname")
        shinyjs::disable("save_score")
        shinyjs::click("refresh")
      }
    }
  })
  
  output$table_score <- DT::renderDataTable({
    input$refresh
    
    table_scores <- read.table("save_scores.txt", sep = ";", header = TRUE, stringsAsFactors = FALSE)
    
    if(input$theme != "All"){
      table_scores <- table_scores[table_scores$Theme == input$theme,]
    }

    DT::datatable(
      table_scores,
      rownames = FALSE,
      options = list(scrollX = TRUE,
                     pageLength = 6,
                     lengthChange = FALSE,
                     order = list(list(3, 'desc'))))
    })
}
    
## To be copied in the UI
# mod_add_user_score_ui("add_user_score_ui_1")
    
## To be copied in the server
# callModule(mod_add_user_score_server, "add_user_score_ui_1")
 
