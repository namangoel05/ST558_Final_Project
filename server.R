# server function for  daily student alchohol consumption

library(shiny)
library(tidyverse)
library(caret)
library(leaps)
library(psych) 
library(corrplot)

setwd("C:\\Users\\naman\\OneDrive\\Desktop\\NCSU Fin Math\\Assignments - Semester 3\\ST 558\\Project4\\ST558_Final_Project")
school_data <- read.csv("Maven Business School.csv",stringsAsFactors = F,header=T)
school_data3 <- school_data

school_data$Work_Experience <- as.factor(school_data$Work_Experience)
school_data$Work_Experience <- factor(school_data$Work_Experience, levels = c("No", "Yes"), labels = c(0,1))
school_data$Undergrad_Degree<-as.factor(school_data$Undergrad_Degree)
school_data$Undergrad_Degree <- factor(school_data$Undergrad_Degree, levels = c("Business","Computer Science","Engineering","Finance","Art"), labels = c(1,2,3,4,5))
school_data$Status <- as.factor(school_data$Status)
school_data$Status <- factor(school_data$Status, levels = c("Not Placed", "Placed"), labels = c(0,1))
school_data2 <- school_data

shinyServer(function(input, output) {
  mydata<-reactive({
    val<-input$bar_plots
  })
  s <- reactive({
    val<-c(input$variable1,input$variable2)
  })
  
  
  summaries<-reactive({
    val1<-c(input$numerical)
  })
  output$num_summ<-renderDataTable({
    
    df_summary<-school_data2%>%select(summaries())
    describe(df_summary)[,1:6]
  })
  output$work_exp<- renderPlot({
    newdata=mydata()
    for (i in newdata){
      if(i=="Work_Experience"){
        school_data2$Work_Experience <- factor(school_data2$Work_Experience, levels = 0:1, labels =c("No", "Yes"))
        p<-ggplot(data=school_data2, aes(x=Work_Experience,fill = Work_Experience, colour = Work_Experience)) +
          geom_bar(position = "dodge")
      }}
    p
  })
  output$job_status<- renderPlot({
    newdata=mydata()
    for (i in newdata){
      if(i=="Status"){
        school_data2$Status <- factor(school_data2$Status, levels = 0:1, labels =c("Not Placed", "Placed"))
        p<-ggplot(data=school_data2, aes(x=Status,fill = Status, colour =Status)) +
          geom_bar(position = "dodge")
      }}
    p
  })
  output$plot_degree<- renderPlot({
    newdata=mydata()
    for (i in newdata){
      if(i=="Undergrad_Degree"){
        school_data2$Undergrad_Degree <- factor(school_data2$Undergrad_Degree, levels = 1:5, labels = c("Business","Computer Science","Engineering","Finance","Art"))
        p<-ggplot(data=school_data2, aes(x=Undergrad_Degree,fill = Undergrad_Degree, colour =Undergrad_Degree)) +
          geom_bar(position = "dodge")
      }}
    p
  }) # Code for plotting scatterplot or histogram
  
  output$plot1<-renderPlot({
    
    if(input$Scatter_Line=="scatter"){
      plot<- school_data2 %>% 
        select(Undergrad_Grade, Salary) %>% 
        group_by(Undergrad_Grade) %>% 
        summarise(Avg_Salary = mean(Salary))
      p<-ggplot(data = plot, aes(Undergrad_Grade,Avg_Salary)) + 
        labs(x="Undergrad_Grade",y="Average Salary",title="Undergrad Grade vs Salary") + 
        geom_point()+
        theme(plot.title = element_text(hjust = 0.5))
    }
    p
  })
  
  output$plot2<-renderPlot({
    
    if(input$Scatter_Line=="scatter"){
      plot<- school_data2 %>%
        select(MBA_Grade, Salary) %>%
        group_by(MBA_Grade) %>%
        summarise(Avg_Salary = mean(Salary))
      p<-ggplot(data = plot, aes(MBA_Grade,Avg_Salary)) +
        labs(x="MBA_Grade",y="Average Salary",title="MBA Grade vs Salary") +
        geom_point()+
        theme(plot.title = element_text(hjust = 0.5))
    }
    p
  })
  
  output$plot5<-renderPlot({
    
    if(input$Scatter_Line=="scatter_and_line"){
      plot<- school_data2 %>%
        select(Undergrad_Grade, Salary) %>%
        group_by(Undergrad_Grade) %>%
        summarise(Avg_Salary = mean(Salary))
      p<-ggplot(data = plot, aes(Undergrad_Grade,Avg_Salary)) +
        labs(x="Undergrad_Grade",y="Average Salary",title="Undergrad Grade vs Salary") +
        geom_point()+
        theme(plot.title = element_text(hjust = 0.5))
    }
    p
  })
  output$plot6<-renderPlot({
    
    if(input$Scatter_Line=="scatter_and_line"){
      plot<- school_data2 %>%
        select(MBA_Grade, Salary) %>%
        group_by(MBA_Grade) %>%
        summarise(Avg_Salary = mean(Salary))
      p<-ggplot(data = plot, aes(MBA_Grade,Avg_Salary)) +
        labs(x="MBA_Grade",y="Average Salary",title="MBA Grade vs Salary") +
        geom_point()+
        theme(plot.title = element_text(hjust = 0.5))
    }
    p
  })
  
  output$plot3<-renderPlot({
    if(input$Scatter_Line=="line"){
      p<-plot(seq(1:1200), school_data2$Salary, xlab = "Number", ylab = "Salary", 
              type = "l")
    }
    
    p
  })
  output$plot4<-renderPlot({
    if(input$Scatter_Line=="line"){
      p<-plot(seq(1:1200), school_data2$MBA_Grade, xlab = "Number", ylab = "MBA Grade", 
              type = "l")
    }
    
    p
  })
  
  output$plot7<-renderPlot({
    if(input$Scatter_Line=="scatter_and_line"){
      p<-plot(seq(1:1200), school_data2$Salary, xlab = "Number", ylab = "Salary", 
              type = "l")
    }
    
    p
  })
  output$plot8<-renderPlot({
    if(input$Scatter_Line=="scatter_and_line"){
      p<-plot(seq(1:1200), school_data2$MBA_Grade, xlab = "Number", ylab = "MBA Grade", 
              type = "l")
    }
    
    p
  })
  
  # Splitting the data 
  split_data<-eventReactive(input$split,{
    
    input$split_now
    
  })
  
  # Selecting features for linear regression
  lin_feat<-eventReactive(input$train_mod,{
    d1<-c(input$variable1_train)
  })
  
  # Fitting Random forest
  
  forest_features<-eventReactive(input$train_mod,{
    d1<-c(input$variable3_train)
  })
  
  tune_rf<-eventReactive(input$train_mod,{
    d1<-c(input$trees)
  })
  
  output$rf_train_rmse<-renderText({
    split_first<-split_data()
    forest_features<-forest_features()
    forest_data<-school_data2%>%select(forest_features(),Employability_After)
    split_size <- sample(nrow(forest_data), nrow(forest_data)*split_data())
    
    Forest_Train <- forest_data[split_size,]
    
    Forest_Test <- forest_data[-split_size,]
    
    cv<-trainControl(method = "repeatedcv", number = 5, repeats = 3)
    tuning<-expand.grid(.mtry=ncol(Forest_Train)/3)
    ntrees=tune_rf()
    forest_fit <- train(Employability_After~., 
                        data = Forest_Train, 
                        method = "rf",
                        trControl=cv, 
                        preProcess = c("center", "scale"),
                        ntree=ntrees,
                        tuneGrid = tuning)
    forest_predict <- predict(forest_fit, newdata = Forest_Train)
    forest_train_mse <- sqrt(mean((forest_predict - Forest_Train$Employability_After)^2))
    print(forest_train_mse)
    
    
  })
  
  output$rf_test_rmse<-renderText({
    split_first<-split_data()
    forest_features<-forest_features()
    forest_data<-school_data2%>%select(forest_features(),Employability_After)
    split_size <- sample(nrow(forest_data), nrow(forest_data)*split_data())
    
    Forest_Train <- forest_data[split_size,]
    
    Forest_Test <- forest_data[-split_size,]
    
    cv<-trainControl(method = "repeatedcv", number = 5, repeats = 3)
    tuning<-expand.grid(.mtry=ncol(Forest_Train)/3)
    ntrees=tune_rf()
    forest_fit <- train(Employability_After~., 
                        data = Forest_Train, 
                        method = "rf",
                        trControl=cv, 
                        preProcess = c("center", "scale"),
                        ntree=ntrees,
                        tuneGrid = tuning)
    forest_predict <- predict(forest_fit, newdata = Forest_Test)
    rf_test_mse <- sqrt(mean((forest_predict - Forest_Test$Employability_After)^2))
    print(rf_test_mse)
    
  })
  
  # Fitting Decision Tree
  decision_features<-eventReactive(input$train_mod,{
    d1<-c(input$variable2_train)
  })
  
  tune_dt<-eventReactive(input$train_mod,{
    d1<-c(input$complexity)
  })
  
  output$decision_tree_train_rmse<-renderText({
    split_first<-split_data()
    tree_features<-decision_features()
    tree_data<-school_data2%>%select(decision_features(),Employability_After)
    split_size <- sample(nrow(tree_data), nrow(tree_data)*split_data())
    
    Decision_Train <- tree_data[split_size,]
    
    Decision_Test <- tree_data[-split_size,]
    decision_fit = train(Employability_After ~ ., data=Decision_Train, method="rpart", trControl = trainControl(method = "cv"),tuneGrid =  expand.grid(cp = tune_dt()))
    decision_predict=predict(decision_fit,Decision_Train)
    decision_train_rmse<-sqrt(mean((Decision_Train$Employability_After-decision_predict)^2))
    print(decision_train_rmse)
    
  })
  
  output$decision_tree_test_rmse<-renderText({
    split_first<-split_data()
    tree_features<-decision_features()
    tree_data<-school_data2%>%select(decision_features(),Employability_After)
    split_size <- sample(nrow(tree_data), nrow(tree_data)*split_data())
    
    Decision_Train <- tree_data[split_size,]
    
    Decision_Test <- tree_data[-split_size,]
    decision_fit = train(Employability_After ~ ., 
                         data=Decision_Train, 
                         method="rpart", 
                         trControl = trainControl(method = "cv"),
                         tuneGrid =  expand.grid(cp = tune_dt())
    )
    decision_predict=predict(decision_fit,Decision_Test)
    decision_test_rmse<-sqrt(mean((Decision_Test$Employability_After-decision_predict)^2))
    print(decision_test_rmse)
    
  })
  
  
  # Fitting Linear Regression
  output$linear_test_rmse<-renderText({
    split_first<-split_data()
    linear_feature<-lin_feat()
    linear_data<-school_data%>%select(lin_feat(),Employability_After)
    split_size <- sample(nrow(linear_data), nrow(linear_data)*split_first)
    
    Linear_Train <- linear_data[split_size,]
    
    Linear_Test <- linear_data[-split_size,]
    
    linear_fit<-lm(Employability_After~.,data=Linear_Train,trControl=trainControl(method = "repeatedcv", number = 5, repeats = 3))
    linear_predict=predict(linear_fit,Linear_Test)
    linear_test_rmse<-sqrt(mean((Linear_Test$Employability_After-linear_predict)^2))
    print(linear_test_rmse)
  })
  
  output$lin_train_rmse<-renderText({
    split_first<-split_data()
    linear_feature<-lin_feat()
    linear_data<-school_data%>%select(lin_feat(),Employability_After)
    split_size <- sample(nrow(linear_data), nrow(linear_data)*split_data())
    
    Linear_Train <- linear_data[split_size,]
    
    Linear_Test <- linear_data[-split_size,]
    
    linear_fit<-lm(Employability_After~.,data=Linear_Train,trControl=trainControl(method = "repeatedcv", number = 5, repeats = 3))
    
    linear_predict=predict(linear_fit,Linear_Train)
    lin_train_rmse<-sqrt(mean((Linear_Train$Employability_After-linear_predict)^2))
    print(lin_train_rmse)
  })
  
  ##Prediction
  type_model<-reactive({
    input$model_choose
  })
  
  predict_param<-reactive({
    predict_value<-c(input$p_ud,input$p_ug,input$p_mb,input$p_we,input$p_eb,input$p_js,input$p_sal)
  })
  
  output$predicted_output<-renderText({
    model_choose<-type_model()
    
    if(model_choose=="linear"){
      parameters<-predict_param()
      split_first<-split_data()
      split_quant <- sample(nrow(school_data2), nrow(school_data2)*split_data())
      
      Linear_Train <- school_data2[split_quant,]
      
      Linear_Test <- school_data2[-split_quant,]
      fit_linear<-lm(Employability_After~.,data=Linear_Train,trControl=trainControl(method = "repeatedcv", number = 5, repeats = 3))
      
      predict_value<-predict(fit_linear,data.frame(Undergrad_Degree=as.factor(parameters[[1]]),Undergrad_Grade=as.numeric(parameters[[2]]),MBA_Grade=as.numeric(parameters[[3]]),Work_Experience=as.factor(parameters[[4]]),Employability_Before=as.numeric(parameters[[5]]),
                                                   Status=as.factor(parameters[[6]]),Salary=as.numeric(parameters[[7]])))
      
    }
    if(model_choose=="reg tree"){
      parameters<-predict_param()
      split_first<-split_data()
      split_quant <- sample(nrow(school_data2), nrow(school_data2)*split_data())
      
      Decision_Train <- school_data2[split_quant,]
      
      Decision_Test <- school_data2[-split_quant,] 
      
      fit_decision = train(Employability_After ~ ., 
                           data=Decision_Train, 
                           method="rpart", 
                           trControl = trainControl(method = "cv"),
                           tuneGrid =  expand.grid(cp = tune_dt())
      )
      predict_value=predict(fit_decision,data.frame(Undergrad_Degree=as.factor(parameters[[1]]),Undergrad_Grade=as.numeric(parameters[[2]]),MBA_Grade=as.numeric(parameters[[3]]),Work_Experience=as.factor(parameters[[4]]),Employability_Before=as.numeric(parameters[[5]]),
                                                    Status=as.factor(parameters[[6]]),Salary=as.numeric(parameters[[7]])))
      
      
    }
    if(model_choose=="forest"){
      parameters<-predict_param()
      split_first<-split_data()
      split_quant <- sample(nrow(school_data2), nrow(school_data2)*split_data())
      
      Forest_Train <- school_data2[split_quant,]
      
      Forest_Test <- school_data2[-split_quant,]
      cv<-trainControl(method = "repeatedcv", number = 5, repeats = 3)
      
      ntrees=tune_rf()
      fit_forest <- train(Employability_After~., 
                          data = Forest_Train, 
                          method = "rf",
                          trControl=cv, 
                          preProcess = c("center", "scale"),
                          ntree=ntrees
      )
      predict_value <- predict(fit_forest, data.frame(Undergrad_Degree=as.factor(parameters[[1]]),Undergrad_Grade=as.numeric(parameters[[2]]),MBA_Grade=as.numeric(parameters[[3]]),Work_Experience=as.factor(parameters[[4]]),Employability_Before=as.numeric(parameters[[5]]),
                                                      Status=as.factor(parameters[[6]]),Salary=as.numeric(parameters[[7]])))
      
      
      
    }
    predict_value
  })
  
  # Reading the data and downloading it  
  reading<-reactive({
    attribute_1<-c(input$get_data)
  })
  rows_count<-reactive({
    school_data3[c(1:input$offset),]
  })
  output$data_csv<-renderDataTable({
    
    
    data_sub<-rows_count()%>%select(reading())
    
  })    
  
  # Download the data
  
  output$download <- downloadHandler(
    filename = function() { 
      paste("Maven1", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      down_data<-rows_count()%>%select(reading())
      
      write.csv(down_data , file)
    }
  )  
})
