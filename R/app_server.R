#' @import shiny
app_server <- function(input, output, session) {
  # all_funs, timersec, n_quest and delai are defined in global.R

  # List the first level callModules here

  # welcome to the game and rules
  hello <- callModule(
    module = mod_hello_server,
    id = "hello_ui_1"
  )

  # calculate and display remaining time
  timer <- callModule(
    module = mod_timer_server,
    id = "timer_ui_1",
    start = hello$start,
    seconds = timersec
  )

  # Generate all questions
  data_questions <- reactive(
    generate_questions(all_funs, n_quest, hello$theme)
  )

  # Initialize results
  results_question <- reactiveValues()

  # First question
  results_question$q1 <- callModule(
    mod_question_server,
    "question_ui_1",
    question = data_questions()[1, ],
    placeholder = "#placeholder1",
    event = hello$start,
    delai = delai
  )

  # All the next questions
  lapply(2:n_quest, function(x) {
    results_question[[paste0("q", x)]] <- callModule(
      mod_question_server,
      paste0("question_ui_", x),
      question = data_questions()[x, ],
      placeholder = paste0("#placeholder", x),
      event = reactive(reactiveValuesToList(results_question[[paste0("q", x - 1)]])$close),
      delai = delai
    )
  })

  # calculate and display real time score
  realtime_score <- callModule(
    module = mod_realtime_score_server,
    id = "realtime_score_ui_1",
    results_question = results_question
  )

  # Ending game popup when time is over
  play_again <- callModule(
    module = mod_playagain_server,
    id = "playagain_ui_1",
    timer = timer,
    score = realtime_score
  )

  # Reload the app if the player wants to play again
  observeEvent(play_again(), {
    session$reload()
  }, ignoreInit = TRUE)
}
