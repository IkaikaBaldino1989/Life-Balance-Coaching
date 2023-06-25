#1. library(dplyr)
#2. library(ggplot2)
#3. library(tidyverse)
#4. library(readxl)

#data pre-processing 
#5. data <- read_excel("coaching_data.xlsx")
#6. data <- select(data, -c(1:3))
#7. data <- filter(data, !is.na(data$coaching))
#8. data$coaching <- as.factor(data$coaching)
#9. data$coaching_level <- as.factor(data$coaching_level)

#exploratory data analysis 
#10. summary(data)
#11. table(data$coaching_level)
#12. table(data$coaching)
#13. ggplot(data, aes(x=coaching_level)) + geom_bar()
#14. ggplot(data, aes(x=coaching)) + geom_bar()

#15. install.packages("corrplot")
#16. library(corrplot)
#17. corrplot(cor(data))

#data modeling 
#18. install.packages("caret")
#19. library(caret)

#20. model_control <- trainControl(method = "repeatedcv", number = 10, repeats = 5, 
#                                 savePredictions = TRUE, classProbs = TRUE)

#21. set.seed(20)
#22. model_gbm <- train(coaching_level ~ ., data = data,
#                       method = "gbm", trControl = model_control, verbose = FALSE)

#23. set.seed(20)
#24. model_glm <- train(coaching_level ~ ., data = data,
#                       method = "glm", trControl = model_control, verbose = FALSE)

#25. set.seed(20)
#26. model_rf <- train(coaching_level ~ ., data = data,
#                      method = "rf", trControl = model_control, verbose = FALSE)

#model performance evaluation
#27. results <- resamples(list(gbm = model_gbm, rf = model_rf, glm = model_glm))
#28. summary(results)
#29. dotplot(results)

#30. install.packages("pROC")
#31. library(pROC)
#32. gbm_roc <- roc(data$coaching_level, predict(model_gbm, type = "prob")[,2])
#33. rf_roc <- roc(data$coaching_level, predict(model_rf, type = "prob")[,2])
#34. glm_roc <- roc(data$coaching_level, predict(model_glm, type = "prob")[,2])

#35. plot(gbm_roc, col="blue", lwd=3, lty=1, main="ROC Curves for GBM, RF and GLM models")
#36. plot(rf_roc, col="red", lwd=3, lty=2, add= TRUE)
#37. plot(glm_roc, col="green", lwd=3, lty=3, add= TRUE)

#38. install.packages("ROCR")
#39. library(ROCR)
#40. gbm_roc_data <- prediction(predict(model_gbm, type = "prob")[,2], data$coaching_level)
#41. rf_roc_data <- prediction(predict(model_rf, type = "prob")[,2], data$coaching_level)
#42. glm_roc_data <- prediction(predict(model_glm, type = "prob")[,2], data$coaching_level)

#43. gbm_performance <- performance(gbm_roc_data, "auc")
#44. rf_performance <- performance(rf_roc_data, "auc")
#45. glm_performance <- performance(glm_roc_data, "auc")

#46. gbm_auc <- as.numeric(gbm_performance@y.values[[1]])
#47. rf_auc <- as.numeric(rf_performance@y.values[[1]])
#48. glm_auc <- as.numeric(glm_performance@y.values[[1]])

#49. auc_scores <- data.frame(model = c("gbm","rf","glm"),
#                            auc_score = c(gbm_auc, rf_auc, glm_auc))
#50. auc_scores

#data validation 
#51. library(caret)
#52. pred_gbm <- predict(model_gbm, newdata = data)
#53. pred_rf <- predict(model_rf, newdata = data)
#54. pred_glm <- predict(model_glm, newdata = data)

#55. confusionMatrix(data$coaching_level, pred_gbm)
#56. confusionMatrix(data$coaching_level, pred_rf)
#57. confusionMatrix(data$coaching_level, pred_glm)

#build report 
#58. install.packages("knitr")
#59. library(knitr)
#60. install.packages("rmarkdown")
#61. library(rmarkdown)

#62. report <- render("coaching_company_report.Rmd")
#63. cat(report)

#build Shiny app 
#64. install.packages("shiny")
#65. library(shiny)
#66. shinyApp(ui = ui, server = server)

#67. ui <- fluidPage(
#    titlePanel("Coaching Company"),
#    sidebarLayout(
#        sidebarPanel(
#            sliderInput("coaching_slider",
#                        label = "How often do you receive coaching?",
#                        min = 0, max = 10, value = 0,
#                        step = 1),
#            selectInput("coaching_level",
#                        label = "What is your current level of coaching?",
#                        choices = c("0 - Not Coached",
#                                    "1 - Beginning",
#                                    "2 - Intermediate",
#                                    "3 - Advanced"))
#        ),
#        mainPanel(
#            plotOutput("coaching_plot"),
#            textOutput("coaching_output")
#        )
#    )
#)

#68. server <- function(input, output) {
#    output$coaching_plot <- renderPlot({
#        ggplot(data, aes(x=coaching)) +
#            geom_bar(fill = "orange") +
#            labs(x="Levels of Coaching", y="Number of People")
#    })
#    output$coaching_output <- renderText({
#        if(input$coaching_slider == 0){
#            "A coaching company that focuses on helping individuals achieve balance in their personal and professional lives can be a great help!"
#        }
#        else if(input$coaching_level == "1 - Beginning"){
#            "A coaching company that helps individuals take the first step towards balance can help you achieve your goals!"
#        }
#        else if(input$coaching_level == "2 - Intermediate"){
#            "A coaching company that can help you fine-tune your balance can help you reach your peak performance!"
#        }
#        else if(input$coaching_level == "3 - Advanced"){
#            "A coaching company that can help you stay on top of your balance can help you stay ahead of the curve!"
#        }
#    })
#}

#69. shinyApp(ui = ui, server = server)

#deploy Shiny app 
#70. install.packages("rsconnect")
#71. library(rsconnect)
#72. rsconnect::setAccountInfo(name="<ACCOUNT_NAME>",
#                              token="<TOKEN>",
#                              secret="<SECRET>")
#73. rsconnect::deployApp("coaching_company_app",
#                         account="<ACCOUNT_NAME>")