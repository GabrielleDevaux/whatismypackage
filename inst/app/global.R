

load("data_fun_dev.RData")

# Timer in seconds
timersec <- 20

# Delay before next question in milliseconds
delai <- 1000

# number of placeholders to generate for the questions
n_quest <- timersec * delai/1000 + 1
