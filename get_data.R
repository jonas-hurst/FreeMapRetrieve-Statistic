# Library to read excel files
library(readxl)

p2f_color = rgb(1, 0, 0, 1/2)
f2p_color = rgb(0, 0, 1, 1/2)


# Get data from questionnaire
get_personal_data <- function(){
  # load csv file
  results <- read.csv(file = 'questionnaire.csv')
  colnames(results) <- c("time",
                         "id",
                         "method",
                         "gender",
                         "age",
                         "exp.gesture",
                         "exp.maps",
                         "exp.energy",
                         "sus.use_frequently",
                         "sus.complex",
                         "sus.easy_to_use",
                         "sus.need_support",
                         "sus.well_integrated",
                         "sus.inconsistency",
                         "sus.most_people_use_frequently",
                         "sus.cumbersome",
                         "sus.confident",
                         "sus.learn_new_things",
                         "tlx.mental_demand",
                         "tlx.physical_demand",
                         "tlx.frustration",
                         "comment")
  results <- filter(results, id <= 90)
  results <- filter(results, id != 5)
  
  results["method"][results["method"] == "Pointer-to-Feature"] <- "P2F"
  results["method"][results["method"] == "Feature-to-Pointer"] <- "F2P"
  
  # Compute SUS Score
  results["sus.score"] <-
    (
      results["sus.use_frequently"] - 1 +
        results["sus.easy_to_use"] - 1 + 
        results["sus.well_integrated"] - 1 +
        results["sus.most_people_use_frequently"] - 1 + 
        results["sus.confident"] - 1 +
        5 - results["sus.complex"] +
        5 - results["sus.need_support"] +
        5 - results["sus.inconsistency"] +
        5 - results["sus.cumbersome"] +
        5 - results["sus.learn_new_things"]
    ) * 2.5
  
  
  # Compute TLX
  results$tlx.mental_demand <- results$tlx.mental_demand * 10
  results$tlx.physical_demand <- results$tlx.physical_demand * 10
  results$tlx.frustration <- results$tlx.frustration * 10
  
  results$observation[results["id"] == 1] <- "First trie P2F mechanism intuitively in Tutorial even though it was not explained to him"
  results$observation[results["id"] == 6] <- "Is intuitive and fun"
  results$observation[results["id"] == 9] <- "Man lernt das übel schnell"
  results$observation[results["id"] == 10] <- "Executing gestuers and interpreting map simultaneously is mentally challenging"
  results$observation[results["id"] == 11] <- "F2P more difficult than P2F would have been"
  results$observation[results["id"] == 13] <- "Frustrating in the beginning until gestures are internalized intuitively. Simultaneous Pan-Zoom for intelligent people"
  results$observation[results["id"] == 18] <- "Not talking a lot was NOT because Thinking and coordinating gestuers isnt posible at the same time"
  results$observation[results["id"] == 24] <- "Difficult to Multi-Task"
  
  return(results)
}

# Get data from evaluation experiment
get_evaluation_data <- function(){
  # load data
  evaluation_data <- read_excel("./evaluation.xlsx")
  evaluation_data$valid <- as.logical(evaluation_data$valid)
  
  # filter data
  evaluation_data <- filter(evaluation_data, valid)
  #evaluation_data <- filter(evaluation_data, time < 60)
  
  evaluation_data$failure_meaning[evaluation_data["failure"] == 1] <- "fail"
  evaluation_data$failure_meaning[evaluation_data["failure"] == 0] <- "success"
  
  return(evaluation_data)
}