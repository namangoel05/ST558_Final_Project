# server function for  daily student alchohol consumption

library(shiny)
library(tidyverse)
library(caret)
library(leaps)
library(psych) 
library(corrplot)

setwd("C:\\Users\\naman\\OneDrive\\Desktop\\NCSU Fin Math\\Assignments - Semester 3\\ST 558\\Project4\\ST558_Final_Project")
school_data <- read.csv("Maven Business School.csv",stringsAsFactors = F,header=T)
school_data2 <- read.csv("Maven Business School.csv",stringsAsFactors = F,header=T)

school_data$Work_Experience <- as.factor(school_data$Work_Experience)
school_data$Work_Experience <- factor(school_data$Work_Experience, levels = c("No", "Yes"), labels = c(0,1))
school_data$Undergrad_Degree<-as.factor(school_data$Undergrad_Degree)
school_data$Undergrad_Degree <- factor(school_data$Undergrad_Degree, levels = c("Business","Computer Science","Engineering","Finance","Art"), labels = c(1,2,3,4,5))
school_data$Status <- as.factor(school_data$Status)
school_data$Status <- factor(school_data$Status, levels = c("Not Placed", "Placed"), labels = c(0,1))

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  mydata<-reactive({
    val<-input$bar_plots
  })
  s <- reactive({
    val<-c(input$cont_var1,input$cont_var2)
  })
  
  output$contingency_table<-renderTable({
    contin<- s()
    
    table(dataextra[[contin[1]]],dataextra[[contin[2]]])
    
    
  })
  output$work_exp<- renderPlot({
    newdata=mydata()
    for (i in newdata){
      if(i=="Work_Experience"){
        school_data2$Work_Experience <- factor(school_data2$Work_Experience, levels = 0:1, labels =c("No", "Yes"))
        p<-ggplot(data=school_data, aes(x=Experience,fill = Experience, colour = Experience)) +
          geom_bar(position = "dodge")
      }}
    p
  })
  output$job_status<- renderPlot({
    newdata=mydata()
    for (i in newdata){
      if(i=="Status"){
        school_data2$Status <- factor(school_data2$Status, levels = 0:1, labels =c("Not Placed", "Placed"))
        p<-ggplot(data=school_data2, aes(x=status,fill = status, colour =status)) +
          geom_bar(position = "dodge")
      }}
    p
  })
  output$plot_degree<- renderPlot({
    newdata=mydata()
    for (i in newdata){
      if(i=="Undergrad_Degree"){
        school_data2$Undergrad_Degree <- factor(school_data2$Undergrad_Degree, levels = 0:3, labels = c("Business","Computer Science","Engineering","Finance","Art"))
        p<-ggplot(data=school_data2, aes(x=Degree,fill = Degree, colour =Degree)) +
          geom_bar(position = "dodge")
      }}
    p
  })
  
  
})
