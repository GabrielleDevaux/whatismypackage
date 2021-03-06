
# load the function names and their packages
# load("data_fun_dev.RData")
load("data_fun_prod.RData")

theme_choices <- unique(all_funs$theme)

# Timer in seconds
timersec <- 40

# Delay before next question in milliseconds
delai <- 500

# number of placeholders to generate for the questions
n_quest <- timersec * 1000/delai + 1
