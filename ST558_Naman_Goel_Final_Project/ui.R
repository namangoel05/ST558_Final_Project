library(shiny)
library(shinydashboard)
library(DT)

dashboardPage(
  dashboardHeader(title = "Business School Graduates"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("About:",tabName="About"),
      menuItem("Exploratory Data Analysis:",tabName="EDA"
      ),
      menuItem("Model",tabName = "model"),
      menuItem("Data",tabName="data")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "About",
              
              fluidRow(
                column(3),
                column(6,align = "center",
                       box(width=NULL,height=45,background="aqua",
                           title="Shiny App - Business School Data"
                       )
                ),
                column(3)
              ),
              fluidRow(
                column(12,
                       box(width=NULL,title="About the App",status="info",solidHeader = TRUE,
                           h4("The purpose of this app is to create an interactive application on business school data"),
                           h4("Through this application, we will try and explore the business school data and how students coming from different backgrounds in there undergraduate degrees perform in an MBA class. The app will contain information about 
                                        data, exploaratory data analysis and summaries of various features in the data. Along with that different machine learning models will be explained and how they performed on the actual data."))
                       
                )),
              fluidRow(
                column(12,
                       box(width=NULL,title="Data",status="info",solidHeader = TRUE,
                           h4("As part of this project, I decided to opt for a business school dataset which holds information about students and how they performed individually. The idea is to understand if the program is biased towards students coming from a certain background and more favourable towards certain."),
                           h4("The dataset contains 1200 rows of data. Some of the attributes we have as part of the dataset are student undergraduate degree, undergraduate marks, MBA marks, if they have prior work experience or not, have they got a job or not, and an employability score. The data set has no missing or errenous values."),
                           h4("The data set is taken from",a(href="https://www.kaggle.com/datasets/oluwatosinamosu/graduate-business-school-dataset","Business School",style="font-size:20px;")))
                       
                       
                       
                )),
              fluidRow(
                column(12,
                       box(width=NULL,title="Contents",status="info",solidHeader = TRUE,
                           h4("1) About the application"),
                           h4("2) Exploratory Data Analysis"),
                           h4("3) Prediction using Modelling"),
                           h4("4) Data and its attributes"))
                       
                )),
              fluidRow(
                column(12,
                       box(width=NULL,title="About the application",status="info",solidHeader = TRUE,h4())
                       
                )
                
                
              )
      ),
      tabItem(tabName = "EDA",
              
              
             
              fluidRow(
                column(6,
                       box(width=NULL,height=405,title="Numerical Summary",
                           checkboxGroupInput("numerical",
                                              "Variable selection for numerical summary",
                                              c("Undergrad Degree"="Undergrad_Degree",
                                                "Work Experience"="Work_Experience",
                                                "Status"="Status"),
                                              selected=c("Undergrad_Degree","Work_Experience","Status"))
                       )
                ),
                column(6,
                       box(width=NULL,title="Summary",
                           dataTableOutput("num_summ")
                       )
                )
              ),
              # fluidRow(
              #   column(1
              #   ),
              #   column(10,align = "center",
              #          box(width=NULL,height=45,title="Quantitative Data Graphs",background="red")
              #   ),
              #   column(1
              #   )
              # ),
              fluidRow(
                column(2,
                       box(width=NULL,title="Types of plot",
                           selectInput("Scatter_Line","Please select between Scatter plot or Line plot",
                                       c("Scatterplot"="scatter","Line"="line",
                                         "Scatterplot and Line"="scatter_and_line"),selected="scatter")
                       )),
                
                
                column(5,
                       conditionalPanel(
                         condition = "input.Scatter_Line == 'scatter'",
                         box(width=NULL,
                             plotOutput('plot1')
                         )),
                       conditionalPanel(
                         condition = "input.Scatter_Line == 'line'",
                         box(width=NULL,
                             plotOutput('plot3')
                         )),
                       conditionalPanel(
                         condition = "input.Scatter_Line == 'scatter_and_line'",
                         
                         box(width=NULL,
                             plotOutput("plot5")
                         ),
                         box(width=NULL,
                             plotOutput("plot7")
                         )
                       )      
                ),
                column(5,
                       conditionalPanel(
                         condition = "input.Scatter_Line == 'scatter'",
                         box(width=NULL,
                             plotOutput('plot2')
                         )),
                       conditionalPanel(
                         condition = "input.Scatter_Line == 'line'",
                         box(width=NULL,
                             plotOutput('plot4')
                         )),
                       conditionalPanel(
                         condition = "input.Scatter_Line == 'scatter_and_line'",
                         box(width=NULL,
                             plotOutput("plot6")
                         ),
                         box(width=NULL,
                             plotOutput("plot8")
                         )
                       )   
                )
              ),
              fluidRow(
                column(1
                ),
                column(10,align = "center",
                       box(width=NULL,height=45,title="Bar Plots",background="orange")
                ),
                column(1
                )
              ),
              fluidRow(
                column(2,
                       box(width=NULL,title="Plots for categorical variables",
                           checkboxGroupInput("bar_plots",
                                              "Select the variables for which you want to see bar plots",
                                              c("Work Experience"="Work_Experience","Status"="Status",
                                                "Undergraduate Degree"="Undergrad_Degree"),
                                              selected=c("Work_Experience","Status","Undergrad_Degree"))
                       )
                ),
                column(10,
                       fluidRow(
                         column(12,
                                
                                
                                conditionalPanel(
                                  condition = "input.bar_plots.includes('Work_Experience')",
                                  box(width=NULL,
                                      plotOutput("work_exp"))
                                ),
                                conditionalPanel(
                                  condition = "input.bar_plots.includes('Status')",
                                  box(width=NULL,
                                      plotOutput("job_status"))
                                ),
                                conditionalPanel(
                                  condition = "input.bar_plots.includes('Undergrad_Degree')",
                                  box(width=NULL,
                                      plotOutput("plot_degree"))
                                ),
                                
                                
                         )
                       )
                )
              )
              
      ), #tabItem
      tabItem(tabName = "model",
              tabsetPanel(
                tabPanel("Modeling Info",
                         fluidRow(
                           column(12,
                                  box(width=NULL,title="Linear Regression",
                                      status="info",solidHeader = TRUE,
                                      h4("A variable's value can be predicted using linear regression analysis based on the value of another variable. The dependent variable is the one you want to be able to forecast. The independent variable is the one you're using to make a prediction about the value of the other variable."),
                                      h4(""),
                                      withMathJax(),
                                      helpText('$$y = \\beta_0 + \\beta_1 \\cdot x_1 + 
                         \\beta_2 \\cdot x_2 + ... + \\beta_k \\cdot x_k$$'),
                                      
                                      h4("Here Y is the dependent variable, x1,x2....xk are independent variables and Betas are co-efficent of independe variables. Coefficients are the amount by which change in X must be multiplied to give the corresponding average change in Y."),
                                      h4(tags$b("Benefits:"),
                                         tags$br(),
                                         "Linear regression performs exceptionally well for linearly separable data",
                                         tags$br(),
                                         "Easier to implement, interpret and efficient to train",
                                         tags$br(),
                                         "It handles overfitting pretty well using dimensionally reduction techniques, regularization, and cross-validation"),
                                      h4(tags$b("Drawbacks:"),
                                         tags$br(),
                                         "The assumption of linearity between dependent and independent variables",
                                         tags$br(),
                                         "It is often quite prone to noise and overfitting",
                                         tags$br(),
                                         "It is prone to multicollinearity "
                                      )
                                  )
                           )
                         ),
                         fluidRow(
                           column(12,
                                  box(width=NULL,title="Regression Decision Tree",
                                      status="info",solidHeader = TRUE,
                                      h4("Regression trees are decision trees with continuous target variables rather than class labels on the leaves. Modified split selection criteria and halting criteria are used with regression trees. The decisions may be explained, prospective outcomes can be seen, and potential events can be identified using a regression tree."),
                                      
                                      h4(tags$b("Benefits:"),
                                         tags$br(),
                                         "Compared to other algorithms decision trees requires less effort for data preparation during pre-processing.",
                                         tags$br(),
                                         "A decision tree does not require normalization and scaling of data",
                                         tags$br(),
                                         "A Decision tree model is very intuitive and easy to explain"),
                                      h4(tags$b("Drawbacks:"),
                                         tags$br(),
                                         "A small change in the data can cause a large change in the structure of the decision tree causing instability.",
                                         tags$br(),
                                         "Decision tree often involves higher time to train the model.",
                                         tags$br(),
                                         "Need to prune them to reduce variance")
                                      
                                  )
                           )
                         ),
                         fluidRow(
                           column(12,
                                  box(width=NULL,title="Random Forest Model",
                                      status="info",solidHeader = TRUE,
                                      h4("Random Forest develops on functionalities of Bagging. A number of multiple bootstrap samples are created with replacement and trees are fitted on these samples to predict the response variable. Random forest take average of these trees to arrive at a result. However random forest don't take all the feature for building the trees, unlike bagging. The features are selected at random which helps to reduce the correlation among the trees and hence reduces variance."),
                                      
                                      h4(tags$b("Benefits:"),
                                         tags$br(),
                                         "It solves the issue of overfitting in decision trees.",
                                         tags$br(),
                                         "It provides an effective way of handling missing data.",
                                         tags$br(),
                                         "It can produce a reasonable prediction without hyper-parameter tuning."),
                                      h4(tags$b("Drawbacks:"),
                                         tags$br(),
                                         "It is a difficult tradeoff between the training time (and space) and increased number of trees.",
                                         tags$br(),
                                         "Random forest may not get good results for small data or low-dimensional data.",
                                         tags$br(),
                                         "Less interpretability.")
                                  )
                           )
                         )
                ),
                tabPanel("Model Fitting",
                         fluidRow(
                           column(4,
                                  box(width=NULL,title="Generalized Linear Model: Binary Logistic Regression",
                                      status="info",solidHeader = TRUE,
                                      checkboxGroupInput("train_var1","Select predictor variables:",
                                                         c("Age (age)"="age","Sex (sex)"="sex",
                                                           "Chest pain type (cp)"="cp",
                                                           "Resting blood pressure (trestbps)"="trestbps",
                                                           "Cholestrol (chol)"="chol",
                                                           "Fasting blood sugar (fbs)"="fbs",
                                                           "Resting ECG (restecg)"="restecg",
                                                           "Max. heart rate (thalach)"="thalach",
                                                           "Exercise induced angina (exang)"="exang",
                                                           "ST depression induced (oldpeak)"="oldpeak",
                                                           "Slope (slope)"="slope",
                                                           "Blood disorder (thal)"="thal"),
                                                         selected=c("age","sex","chol","fbs","thalach","cp",
                                                                    "trestbps","restecg","exang","oldpeak",
                                                                    "slope","thal"))
                                  )
                           ),
                           column(4,
                                  box(width=NULL,title="Classification Tree",
                                      status="info",solidHeader = TRUE,
                                      checkboxGroupInput("train_var2","Select predictor variables:",
                                                         c("Age (age)"="age","Sex (sex)"="sex",
                                                           "Chest pain type (cp)"="cp",
                                                           "Resting blood pressure (trestbps)"="trestbps",
                                                           "Cholestrol (chol)"="chol",
                                                           "Fasting blood sugar (fbs)"="fbs",
                                                           "Resting ECG (restecg)"="restecg",
                                                           "Max. heart rate (thalach)"="thalach",
                                                           "Exercise induced angina (exang)"="exang",
                                                           "ST depression induced (oldpeak)"="oldpeak",
                                                           "Slope (slope)"="slope",
                                                           "Blood disorder (thal)"="thal"),
                                                         selected=c("age","sex","chol","fbs","thalach","cp",
                                                                    "trestbps","restecg","exang","oldpeak",
                                                                    "slope","thal")),
                                      sliderInput("max_depth","Select the max depth of the tree",
                                                  min=2,max=10,value=6,step=1)
                                  )
                           ),
                           column(4,
                                  box(width=NULL,title="Random Forest Model",
                                      status="info",solidHeader = TRUE,
                                      checkboxGroupInput("train_var3","Select predictor variables:",
                                                         c("Age (age)"="age","Sex (sex)"="sex",
                                                           "Chest pain type (cp)"="cp",
                                                           "Resting blood pressure (trestbps)"="trestbps",
                                                           "Cholestrol (chol)"="chol",
                                                           "Fasting blood sugar (fbs)"="fbs",
                                                           "Resting ECG (restecg)"="restecg",
                                                           "Max. heart rate (thalach)"="thalach",
                                                           "Exercise induced angina (exang)"="exang",
                                                           "ST depression induced (oldpeak)"="oldpeak",
                                                           "Slope (slope)"="slope",
                                                           "Blood disorder (thal)"="thal"),
                                                         selected=c("age","sex","chol","fbs","thalach","cp",
                                                                    "trestbps","restecg","exang","oldpeak",
                                                                    "slope","thal")),
                                      sliderInput("mtry","Select the  number of variables to randomly sample as candidates at each split",
                                                  min=2,max=10,value=5,step=1)
                                  )
                           )
                         ),
                         fluidRow(
                           column(2),
                           column(8,align = "center",
                                  box(width=NULL,
                                      h4("For each of the models select the predictor variables 
                          and other model settings above.Use the button below to 
                          train all the models and perform predictions on test data."),
                                      #h5("NOTE: In case you need to change model parameters, follow these steps:"),
                                      #h5("1.Uncheck the box below"),
                                      #h5("2.Change model parameters/ predictor variables"),
                                      #h5("3.Check the box below and wait till you see 'Training Complete' message"),
                                      actionButton(inputId="model_train",label="Train models and Predict")
                                      #textOutput("model_fits")
                                  )
                           ),
                           column(2)
                         ),
                         fluidRow(
                           column(4,
                                  box(width=NULL,title="Generalized Linear Model: Binary Logistic Regression",
                                      status="info",solidHeader = TRUE,
                                      h5(tags$b("Training accuracy:")),
                                      verbatimTextOutput("train_stats_lg"),
                                      h5(tags$b("Summary:")),
                                      verbatimTextOutput("train_stats_lg_summary")
                                  )
                           ),
                           column(4,
                                  box(width=NULL,title="Classification Tree",
                                      status="info",solidHeader = TRUE,
                                      h5(tags$b("Training accuracy:")),
                                      verbatimTextOutput("train_stats_tree"),
                                      h5(tags$b("Summary:")),
                                      verbatimTextOutput("train_stats_tree_summary")
                                      
                                  )
                           ),
                           column(4,
                                  box(width=NULL,title="Random Forest Model",
                                      status="info",solidHeader = TRUE,
                                      h5(tags$b("Training accuracy:")),
                                      verbatimTextOutput("train_stats_rf"),
                                      h5(tags$b("Summary:")),
                                      verbatimTextOutput("train_stats_rf_summary")
                                  )
                           )
                         ),
                         fluidRow(
                           column(4,
                                  box(width=NULL,status="info",
                                      h5(tags$b("Testing accuracy:")),
                                      verbatimTextOutput("test_stats_lg"),
                                      h5(tags$b("Confusion Matrix:")),
                                      verbatimTextOutput("test_cf_lg")
                                  )
                           ),
                           column(4,
                                  box(width=NULL,status="info",
                                      h5(tags$b("Testing accuracy:")),
                                      verbatimTextOutput("test_stats_tree"),
                                      h5(tags$b("Confusion Matrix:")),
                                      verbatimTextOutput("test_cf_tree")
                                  )
                           ),
                           column(4,
                                  box(width=NULL,status="info",
                                      h5(tags$b("Testing accuracy:")),
                                      verbatimTextOutput("test_stats_rf"),
                                      h5(tags$b("Confusion Matrix:")),
                                      verbatimTextOutput("test_cf_rf")
                                  )
                           )
                         )
                ),
                tabPanel("Prediction",
                         fluidRow(
                           column(2),
                           column(8,
                                  box(width=NULL,
                                      selectInput("model_input","Select the model you want to use 
                              for prediction",
                                                  c("Binary Logistic Regression"="lg",
                                                    "Classification Tree"="tree",
                                                    "Random Forest"="rf"),selected="lg")
                                  )     
                           ),
                           column(2)
                         ),
                         fluidRow(
                           column(3),
                           column(6,
                                  box(width=NULL,status="info",align="center",
                                      h4("NOTE"),
                                      h5("In the Model Fitting tab (previous tab), please train the 
                     selected model on all the variables before proceeding with Prediction")
                                  )
                           ),
                           column(3)
                         ),
                         fluidRow(
                           column(1),
                           column(5,
                                  box(width=NULL,title="Select the values of predictors",
                                      numericInput("p_age","Age",min=29,max=77,value=50,step=2,
                                                   width=300),
                                      selectInput("p_sex","Sex",c("Male"=1,"Female"=0),selected=1,
                                                  width=300),
                                      selectInput("p_cp","Chest pain type",
                                                  c("Typical Angina"=0,"Atypical Angina"=1,
                                                    "Non-Anginal"=2,"Aysmptomatic"=3),selected=0,
                                                  width=300),
                                      numericInput("p_trestbps","Resting Blood pressure",
                                                   min=94,max=200,value=130,step=2,width=300),
                                      numericInput("p_chol","Cholestrol level",
                                                   min=126,max=564,value=200,step=10,width=300),
                                      selectInput("p_fbs","Fasting blood sugar greater than 120 mg/dl",
                                                  c("Yes"=1,"No"=0),selected=0,width=300),
                                      selectInput("p_restecg","Resting ECG",
                                                  c("Normal"=0,"Having ST-T wave abnormality"=1,
                                                    "Showing left ventricular hypertrophy"=2),
                                                  selected=0,width=300),
                                      numericInput("p_thalach","Max. Heart rate",
                                                   min=71,max=202,value=90,step=2,width=300),
                                      selectInput("p_exang","Exercise Induced Angina",
                                                  c("Yes"=1,"No"=0),selected=0,width=300),
                                      numericInput("p_oldpeak","ST depression induced by exercise 
                               relative to rest",
                                                   min=0,max=6.2,value=4,step=0.1,width=300),
                                      selectInput("p_slope","Slope of the peak exercise ST segment",
                                                  c("0"=0,"1"=1,"2"=2),selected=1,width=300),
                                      selectInput("p_thal","Blood disorder(thalassemia)",
                                                  c("Normal"=1,"Fixed defect"=2,"Reversable defect"=3),
                                                  selected=1,width=300),
                                  )
                           ),
                           column(5,
                                  box(width=NULL,title="Prediction",solidHeader=TRUE,
                                      status="info",align="center",
                                      textOutput("final_prediction"))
                           ),
                           column(1)
                         ),
                )
              )
      ), #tabItem
      tabItem(tabName = "data",
              fluidRow(
                column(3),
                column(6,align = "center",
                       box(width=NULL,height=45,background="red",
                           title="Get Dataset"
                       )
                ),
                column(3)
              ),
              fluidRow(
                column(2),
                column(8,
                       box(width=NULL,height=150,align="center",
                           h5("You can use this page to obtain the csv file for the dataset."),
                           h5("1. Select the variables you want from the dataset."),
                           h5("2. Select",tags$b("Offset:"),"The record number from which you want to get the data."),
                           h5("3. Select",tags$b("Count:"),"The number of record you want in your dataset"),
                           h5("4. Download CSV")
                       )
                ),
                column(2),
              ),
              fluidRow(
                column(3,
                       box(width=NULL,
                           checkboxGroupInput("get_data","Select predictor variables:",
                                              c("Age (age)"="age","Sex (sex)"="sex",
                                                "Chest pain type (cp)"="cp",
                                                "Resting blood pressure (trestbps)"="trestbps",
                                                "Cholestrol (chol)"="chol",
                                                "Fasting blood sugar (fbs)"="fbs",
                                                "Resting ECG (restecg)"="restecg",
                                                "Max. heart rate (thalach)"="thalach",
                                                "Exercise induced angina (exang)"="exang",
                                                "ST depression induced (oldpeak)"="oldpeak",
                                                "Slope (slope)"="slope",
                                                "Blood disorder (thal)"="thal","Target"="target"),
                                              selected=c("age","sex","chol","fbs","thalach","cp",
                                                         "trestbps","restecg","exang","oldpeak",
                                                         "slope","thal","target")),
                           numericInput("offset","Select offset value",
                                        min=0,max=1020,value=0,step=1,width=300),
                           numericInput("count","Select count value",
                                        min=5,max=1025,value=100,step=1,width=300),
                           downloadButton('download',"Download CSV")
                       )
                ),
                column(9,
                       box(width=NULL,
                           dataTableOutput("data_csv"))
                )
              )
      ) #tabItem
    ) #tabItems
  ) #dashboardBody
) #dashboardPage