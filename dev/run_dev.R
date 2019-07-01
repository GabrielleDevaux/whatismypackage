# Set options here
options(golem.app.prod = FALSE) # TRUE = production mode, FALSE = development mode

# Detach all loaded packages and clean your environment
golem::detach_all_attached()
# rm(list=ls(all.names = TRUE))

# Document and reload your package
golem::document_and_reload()

# whatismypackage::run_app("local", score_path = "inst/app/www/save_scores.txt",  data = "inst/app/www/data_fun_prod.RData", timersec = 5)
whatismypackage::run_app(usecase = "shinyappsio", 
                          ec_host = "https://ethercalc.org", 
                          ec_room = "h7v2ay68zbby",
                          data = "inst/app/www/data_fun_prod.RData",
                         timersec = 5)


