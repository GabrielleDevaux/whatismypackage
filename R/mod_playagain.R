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
mod_playagain_ui <- function(id){
  ns <- NS(id)
  tagList(
  
  )
}
    
# Module Server
    
#' @rdname mod_playagain
#' @export
#' @keywords internal
    
mod_playagain_server <- function(input, output, session, timer, results_question){
  ns <- session$ns
  observe({
    if(timer() < 1){

      results <- lapply(
        X = reactiveValuesToList(results_question), 
        FUN = reactiveValuesToList
      )
      
      score <- lapply(
        results,
        function(x){x$score}
      )
      res <- as.numeric(score[!sapply(score, is.null)] )

      showModal(modalDialog(
        title = "Important message",
        "Time is over ! ",
        paste("your score is",sum(res), "points over", length(res), "questions, congratulations !"),

        footer = actionButton(
          inputId = ns("play_again"),
          label = "Play again",
          icon = icon("play")
        )
      ))
    }
  })
  
  return(reactive(input$play_again))
}
    
## To be copied in the UI
# mod_playagain_ui("playagain_ui_1")
    
## To be copied in the server
# callModule(mod_playagain_server, "playagain_ui_1")
 
