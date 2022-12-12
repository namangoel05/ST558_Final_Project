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
    
    df_summary<-school_data%>%select(summaries())
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
    val1<-c(input$variable1_train)
  })
  
  # Fitting Linear Regression
  output$linear_test_rmse<-renderText({
    split_first<-split_data()
    linear_feature<-lin_feat()
    linear_data<-data%>%select(linear_feature,Salary)
    split_size <- sample(nrow(linear_data), nrow(linear_data)*split_data())
    
    Linear_Train <- linear_data[split_size,]
    
    Linear_Test <- linear_data[-split_size,]
    
    linear_fit<-lm(Salary~.,data=Linear_Train,trControl=trainControl(method = "repeatedcv", number = 5, repeats = 3))
    linear_predict=predict(linear_fit,Linear_Test)
    linear_test_rmse<-sqrt(mean((Linear_Test$Salary-linear_predict)^2))
    print(linear_test_rmse)
  })
  
  output$linear_train_rmse<-renderText({
    split_first<-split_data()
    linear_feature<-lin_feat()
    linear_data<-data%>%select(linear_feature,Salary)
    split_size <- sample(nrow(linear_data), nrow(linear_data)*split_data())
    
    Linear_Train <- linear_data[split_size,]
    
    Linear_Test <- linear_data[-split_size,]
    
    linear_fit<-lm(Salary~.,data=Linear_Train,trControl=trainControl(method = "repeatedcv", number = 5, repeats = 3))
    
    linear_predict=predict(linear_fit,Linear_Train)
    linear_train_rmse<-sqrt(mean((Linear_Train$Salary-linear_predict)^2))
    print(linear_train_rmse)
  })
  
  # Fitting Decision Tree
  features_dt<-eventReactive(input$train_mod,{
    val1<-c(input$train_var2)
  })
  
  tune_dt<-eventReactive(input$train_mod,{
    val1<-c(input$tree_cp)
  })
  
  output$decision_tree_train_rmse<-renderText({
    split_first<-split_data()
    feat_dt<-features_dt()
    dt_data<-data%>%select(feat_dt,Salary)
    split_size <- sample(nrow(dt_data), nrow(dt_data)*split_data())
    
    trainSet_dt <- dt_data[split_size,]
    
    testSet_dt <- dt_data[-split_size,]
    dt_fit = train(Salary ~ ., 
                   data=trainSet_dt, 
                   method="rpart", 
                   trControl = trainControl(method = "cv"),
                   tuneGrid =  expand.grid(cp = tune_dt()))
    dt_predict=predict(dt_fit,trainSet_dt)
    dt_train_rmse<-sqrt(mean((trainSet_dt$Salary-dt_predict)^2))
    print(dt_train_rmse)
    
  })
  
  output$decision_tree_test_rmse<-renderText({
    split_first<-split_data()
    feat_dt<-features_dt()
    dt_data<-data%>%select(feat_dt,Salary)
    split_size <- sample(nrow(dt_data), nrow(dt_data)*split_data())
    
    trainSet_dt <- dt_data[split_size,]
    
    testSet_dt <- dt_data[-split_size,]
    dt_fit = train(Salary ~ ., 
                   data=trainSet_dt, 
                   method="rpart", 
                   trControl = trainControl(method = "cv"),
                   tuneGrid =  expand.grid(cp = tune_dt())
    )
    dt_predict=predict(dt_fit,testSet_dt)
    dt_test_rmse<-sqrt(mean((testSet_dt$Salary-dt_predict)^2))
    print(dt_test_rmse)
    
  })
  
  # Fitting Random forest
  
  features_rf<-eventReactive(input$train_mod,{
    val1<-c(input$train_var3)
  })
  
  tune_rf<-eventReactive(input$train_mod,{
    val1<-c(input$ntree)
  })
  
  output$rf_train_rmse<-renderText({
    split_first<-split_data()
    feat_rf<-features_rf()
    rf_data<-data%>%select(feat_rf,Salary)
    split_size <- sample(nrow(rf_data), nrow(rf_data)*split_data())
    
    trainSet_rf <- rf_data[split_size,]
    
    testSet_rf <- rf_data[-split_size,]
    
    cv<-trainControl(method = "repeatedcv", number = 5, repeats = 3)
    tuning<-expand.grid(.mtry=ncol(trainSet_rf)/3)
    ntrees=tune_rf()
    rf_fit <- train(Salary~., 
                    data = trainSet_rf, 
                    method = "rf",
                    trControl=cv, 
                    preProcess = c("center", "scale"),
                    ntree=ntrees,
                    tuneGrid = tuning)
    rf_predict <- predict(rf_fit, newdata = trainSet_rf)
    rf_train_mse <- sqrt(mean((rf_predict - trainSet_rf$Salary)^2))
    print(rf_train_mse)
    
    
  })
  
  output$rf_test_rmse<-renderText({
    split_first<-split_data()
    feat_rf<-features_rf()
    rf_data<-data%>%select(feat_rf,Salary)
    split_size <- sample(nrow(rf_data), nrow(rf_data)*split_data())
    
    trainSet_rf <- rf_data[split_size,]
    
    testSet_rf <- rf_data[-split_size,]
    
    cv<-trainControl(method = "repeatedcv", number = 5, repeats = 3)
    tuning<-expand.grid(.mtry=ncol(trainSet_rf)/3)
    ntrees=tune_rf()
    rf_fit <- train(Salary~., 
                    data = trainSet_rf, 
                    method = "rf",
                    trControl=cv, 
                    preProcess = c("center", "scale"),
                    ntree=ntrees,
                    tuneGrid = tuning)
    rf_predict <- predict(rf_fit, newdata = testSet_rf)
    rf_test_mse <- sqrt(mean((rf_predict - testSet_rf$Salary)^2))
    print(rf_test_mse)
    
  })
  
  
})
