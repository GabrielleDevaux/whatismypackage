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
mod_hello_ui <- function(id){
  ns <- NS(id)
  tagList(
  )
}
    
# Module Server
    
#' @rdname mod_hello
#' @export
#' @keywords internal
    
mod_hello_server <- function(input, output, session){
  ns <- session$ns
  
  showModal(modalDialog(
    title = tags$h1("Welcome to \"What is my package ?\" game !",
                    style = "text-align:center;"),
    "introduction and rules of the game",

    footer = actionButton(
      inputId = ns("play"),
      label = "Play",
      icon = icon("play")
    )
  ))

  observeEvent(input$play, {
    removeModal()
  })
  
  return(reactive(input$play))
  
}
    
## To be copied in the UI
# mod_hello_ui("hello_ui_1")
    
## To be copied in the server
# callModule(mod_hello_server, "hello_ui_1")
 
