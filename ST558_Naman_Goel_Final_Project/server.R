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

# Define server logic required to draw a histogram
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


  
  
})
