#' @title generate_questions
#'
#' @description A function to generate a random sample of questions composed of a function name, its package, and
#' some wrong packages.
#'
#' @param all_funs function names and their package
#' @param n number of questions to generate
#' @param theme theme of the functions
#'
#' @return
#' @export
#'
#' @import dplyr
generate_questions <- function(all_funs, n, theme){
  
  questions <- all_funs %>% 
    sample_n(n) %>%
    filter(theme == theme) %>%
    select(functions, package)
  
  fausses <- as.data.frame(t(apply(questions,1,
                                   function(x){
                                     true_pkg <- x[2]
                                     list_pkg <- unique(all_funs$package)
                                     list_pkg <- list_pkg[list_pkg != true_pkg]
                                     false_pkg <- sample(list_pkg, 3)
                                     
                                     return(false_pkg)
                                   })), stringsAsFactors = FALSE)
  
  colnames(fausses) <- c("fake1", "fake2", "fake3")
  
  questions <- cbind(questions, fausses)
  
  return(questions)
}

