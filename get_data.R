# Library to read excel files
library(readxl)
setwd("~/ma")

###################################
##  define visualizatino colors  ##
##################################

p2f_color = rgb(1, 0, 0, 1/2)
f2p_color = rgb(0, 0, 1, 1/2)


###################################
##  Get data from questionnaire  ##
###################################

# load csv file
results <- read.csv(file = './data/questionnaire.csv')
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

results.p2f <- filter(results, method == "P2F")
results.f2p <- filter(results, method == "F2P")



###########################################
##  Get data from evaluation experiment  ##
###########################################


# load data
evaluation_data <- read_excel("./data/evaluation.xlsx")
evaluation_data$valid <- as.logical(evaluation_data$valid)

# filter data
evaluation_data <- filter(evaluation_data, valid)
#evaluation_data <- filter(evaluation_data, time < 60)

evaluation_data$failure_meaning <- ""
evaluation_data$failure_meaning[evaluation_data["failure"] == 1] <- "fail"
evaluation_data$failure_meaning[evaluation_data["failure"] == 0] <- "success"

p2f <- filter(evaluation_data, method == "P2F")
f2p <- filter(evaluation_data, method == "F2P")

evaluation_data_large <- filter(evaluation_data, state_type == "large")
evaluation_data_small <- filter(evaluation_data, state_type == "small")

p2f_large <- filter(p2f, state_type == "large")
p2f_small <- filter(p2f, state_type == "small")
f2p_large <- filter(f2p, state_type == "large")
f2p_small <- filter(f2p, state_type == "small")



#############################################
##  Get data from exploration exploration  ##
#############################################

exploration_data <- read_excel("./data/exploration.xlsx")
exploration_data$insightReceivedAt <- minute(exploration_data$time) + second(exploration_data$time) / 60
exploration_data$timeExploredTotal <- ifelse(
  !is.na(exploration_data$overall_time),
  minute(exploration_data$overall_time) + second(exploration_data$overall_time)/60,
  0
)

exploration_summary <- as.data.frame(
  exploration_data %>%
    group_by(id) %>%
    summarise(method = first(method), insight = sum(domainvalue), duration = max(timeExploredTotal),
              insightsRetrieveUsed = sum(needs_retrieve),
              insightsRetrieveNotUsed = sum((function(col, value) col == value)(needs_retrieve, 0)),
              overviewInsights = sum((function(col, value) col == value)(category, 1)),
              patternInsights = sum((function(col, value) col == value)(category, 2)),
              hypothesisNoBackgroundInsights = sum((function(col, value) col == value)(category, 3)),
              hypothesisBackgroundInsights = sum((function(col, value) col == value)(category, 4)))
  )

exploration_summary$percInsightsRetrieveUsed <- 
  exploration_summary$insightsRetrieveUsed*100 / (exploration_summary$insightsRetrieveUsed + 
                                                exploration_summary$insightsRetrieveNotUsed)

exploration_summary$percInsightsRetrieveNotUsed <- 
  exploration_summary$insightsRetrieveNotUsed*100 / (exploration_summary$insightsRetrieveUsed + 
                                                exploration_summary$insightsRetrieveNotUsed)

exploration_summary_p2f <- filter(exploration_summary, method == "P2F")
exploration_summary_f2p <- filter(exploration_summary, method == "F2P")
