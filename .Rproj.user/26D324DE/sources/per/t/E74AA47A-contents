#' @import shiny
app_ui <- function(n_quest = 20) {
  tagList(
    # Leave this function for adding external resources
    # from inst/app/www
    golem_add_external_resources(),
    golem::js(),
    golem::favicon(),
    # shinyjs::useShinyjs(),
    # List the first level UI elements here 
    fluidPage(
      h1("What is my package ?"),
      mod_timer_ui("timer_ui_1"),

      lapply(1:n_quest, function(x){
        tags$div(id=paste0("placeholder",x))
      })
      
      # tags$div(id="placeholder1"),
      # tags$div(id="placeholder2"),
      # tags$div(id="placeholder3"),
      # tags$div(id="placeholder4")
      # mod_question_ui("question_ui_1"),
      # mod_question_ui("question_ui_2"),
      # mod_question_ui("question_ui_3")

      
    )
  )
}

golem_add_external_resources <- function(){
  
  addResourcePath(
    'www', system.file('app/www', package = 'whatismypackage')
  )
 
  tagList(
    # Add here all the external resources
    # If you have a custom.css in the inst/app/www
    tags$link(rel="stylesheet", type="text/css", href="www/custom.css")
  )
}
