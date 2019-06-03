# Module UI
  
#' @title   mod_question_ui and mod_question_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#' @param question data.frame of one row containing a question
#'
#' @rdname mod_question
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
#' @importFrom shinyjs disable 
#' @import dplyr
mod_question_ui <- function(id){
  ns <- NS(id)
  # tagList(
  #   shinyjs::useShinyjs(),
  #   wellPanel(
  #     
  #     textOutput(outputId = ns("fun_name")),
  #     
  #     uiOutput(outputId = ns("answers"))
  #     
  #     
  #   )
  # )
}
    
# Module Server
    
#' @rdname mod_question
#' @export
#' @keywords internal
    
mod_question_server <- function(input, output, session, question, placeholder, event, delai){
  ns <- session$ns
  
  result <- reactiveValues(score = NULL, close = NULL)
  
  output$fun_name <- renderText(
    paste0(question$functions, "() ?")
  )
  
  pkgs <- reactive(sample(question %>% select(package, fake1, fake2, fake3) %>% unlist(use.names = FALSE)))
  
  # observe({print(pkgs())})
  
  output$answers <- renderUI({
    tagList(
      actionButton(inputId = ns("btn1"),
                   label = pkgs()[1]),
      actionButton(inputId = ns("btn2"),
                   label = pkgs()[2]),
      actionButton(inputId = ns("btn3"),
                   label = pkgs()[3]),
      actionButton(inputId = ns("btn4"),
                   label = pkgs()[4])
    )
  })
  
  disable_all <- function(){
    shinyjs::disable("btn1")
    shinyjs::disable("btn2")
    shinyjs::disable("btn3")
    shinyjs::disable("btn4")
  }
  
  
  # observe(print(event()))
  
  observeEvent(event(),{
    insertUI(selector = placeholder,
             ui =   tagList(
               shinyjs::useShinyjs(),
               wellPanel(
                 
                 textOutput(outputId = ns("fun_name")),
                 
                 uiOutput(outputId = ns("answers"))
                 
                 
               )
             ))
  })
  

  observeEvent(input$btn1,{
    if(question$package == pkgs()[1]){
      updateActionButton(session = session, inputId = "btn1", label = "", icon = icon('grin-hearts'))
      result$score <- 1
    } else{
      updateActionButton( session = session, inputId = "btn1", label = "", icon = icon('sad-cry'))
      result$score <- 0
    }
    disable_all()
  })
  observeEvent(input$btn2,{
    if(question$package == pkgs()[2]){
      updateActionButton(session = session, inputId = "btn2", label = "", icon = icon('grin-hearts'))
      result$score <- 1
    } else{
      updateActionButton( session = session, inputId = "btn2", label = "", icon = icon('sad-cry'))
      result$score <- 0
    }
    disable_all()
  })
  observeEvent(input$btn3,{
    if(question$package == pkgs()[3]){
      updateActionButton(session = session, inputId = "btn3", label = "", icon = icon('grin-hearts'))
      result$score <- 1
    } else{
      updateActionButton( session = session, inputId = "btn3", label = "", icon = icon('sad-cry'))
      result$score <- 0
    }
    disable_all()
  })
  observeEvent(input$btn4,{
    if(question$package == pkgs()[4]){
      updateActionButton(session = session, inputId = "btn4", label = "", icon = icon('grin-hearts'))
      result$score <- 1
    } else{
      updateActionButton( session = session, inputId = "btn4", label = "", icon = icon('sad-cry'))
      result$score <- 0
    }
    disable_all()
  })
  
  # observe({print(score())})
  
  observeEvent(result$score,{
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
 
