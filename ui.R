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
      menuItem("Model:",tabName = "Model"),
      menuItem("Data:",tabName="Data")
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
                       box(width=NULL,height=45,title="Bar Plots",background="aqua")
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
      tabItem(tabName = "Model",
              tabsetPanel(
                tabPanel("Model Theory",
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
                           column(1
                           ),
                           column(12,align = "center",
                                  box(width=NULL,height=45,title="Splitting the Data",background="aqua")
                           ),
                           column(1
                           )
                         ),
                         fluidRow(
                           column(1
                           ),
                           column(5,
                                  box(width=NULL,status="info",
                                      sliderInput("split_now","Training Set Splitting %age",min=0.6,max=0.9,value=0.65,step=0.05))
                           ),
                           column(5,
                                  box(width =NULL,status = "info",align="center",background="aqua", actionButton("split","Split Data"))
                           ),
                           column(1
                           )
                         ),
                         fluidRow(
                           
                           column(4,
                                  box(width=NULL,title="Regression Tree",
                                      status="info",solidHeader = TRUE,
                                      checkboxGroupInput("variable2_train","Select variables:",
                                                         c("Undergraduate Degree"="Undergrad_Degree","Undergraduate Grade"="Undergrad_Grade",
                                                           "MBA Grade"="MBA_Grade","Previous Work Experience"="Work_Experience",
                                                           "Empliyability Before MBA"="Employability_Before",#"Empliyability After MBA"="Employability_After",
                                                           "Job Status"="Status","Salary"="Salary"),
                                                         selected=c("Undergrad_Grade","Work_Experience","Status")),
                                      sliderInput("complexity","Select the Complexity",
                                                  min=0.0,max=0.5,value=0.2,step=0.05)
                                  )
                           ),
                           column(4,
                                  box(width=NULL,title="Linear Regression",status="info",solidHeader = TRUE,
                                      checkboxGroupInput("variable1_train","Select variables:",
                                                         c("Undergraduate Degree"="Undergrad_Degree","Undergraduate Grade"="Undergrad_Grade",
                                                           "MBA Grade"="MBA_Grade","Previous Work Experience"="Work_Experience",
                                                           "Empliyability Before MBA"="Employability_Before",#"Empliyability After MBA"="Employability_After",
                                                           "Job Status"="Status","Salary"="Salary"),
                                                         selected=c("Undergrad_Grade","Work_Experience","Status"))
                                  )
                           ),
                           column(4,
                                  box(width=NULL,title="Random Forest Model",
                                      status="info",solidHeader = TRUE,
                                      checkboxGroupInput("variable3_train","Select variables:",
                                                         c("Undergraduate Degree"="Undergrad_Degree","Undergraduate Grade"="Undergrad_Grade",
                                                           "MBA Grade"="MBA_Grade","Previous Work Experience"="Work_Experience",
                                                           "Empliyability Before MBA"="Employability_Before",#"Empliyability After MBA"="Employability_After",
                                                           "Job Status"="Status","Salary"="Salary"),
                                                         selected=c("Undergrad_Grade","Work_Experience","Status")),
                                      sliderInput("trees","Select number of variables to randomly sample for every split",
                                                  min=1,max=101,value=10,step=5)
                                  )
                           )
                         ),
                         fluidRow(
                           column(2),
                           column(8,align = "center",
                                  box(width=NULL,
                                      h4("Click below to check the RMSE of the 3 models"),
                                      actionButton(inputId="train_mod",label="Train models and observe prediction")
                                  )
                           ),
                           column(2)
                         ),
                         fluidRow(
                           column(4,
                                  box(width=NULL,title="Linear Regression",status="info",solidHeader = TRUE,
                                      h5(tags$b("Training RMSE:")),verbatimTextOutput("lin_train_rmse")
                                  )
                           ),
                           column(4,
                                  box(width=NULL,title="Regression Tree",status="info",solidHeader = TRUE,
                                      h5(tags$b("Training RMSE:")),verbatimTextOutput("decision_tree_train_rmse")
                                      
                                  )
                           ),
                           column(4,
                                  box(width=NULL,title="Random Forest Model",status="info",solidHeader = TRUE,
                                      h5(tags$b("Training RMSE:")),verbatimTextOutput("rf_train_rmse")
                                  )
                           )
                         ),
                         fluidRow(
                           column(4,
                                  box(width=NULL,status="info",h5(tags$b("Testing RMSE:")),
                                      verbatimTextOutput("linear_test_rmse")
                                  )
                           ),
                           column(4,
                                  box(width=NULL,status="info",h5(tags$b("Testing RMSE:")),
                                      verbatimTextOutput("decision_tree_test_rmse")
                                  )
                           ),
                           column(4,
                                  box(width=NULL,status="info",h5(tags$b("Testing RMSE:")),
                                      verbatimTextOutput("rf_test_rmse")
                                  )
                           )
                         )
                ),
                tabPanel("Prediction",
                         fluidRow(
                           column(2),
                           column(8,
                                  box(width=NULL,
                                      selectInput("model_choose","Select the model you want to use 
                              for prediction",
                                                  c("Linear Regression"="linear",
                                                    "Regression Tree"="reg tree",
                                                    "Random Forest"="forest"),selected="linear")
                                  )     
                           ),
                           column(2)
                         ),
                         fluidRow(
                           column(1),
                           column(5,
                                  box(width=NULL,title="Select the values of predictors",
                                      selectInput("p_ud","Undergraduate Degree",
                                                  c("Business"=1,"Computer Science"=2,"Engineering"=3,"Finance"=4,"Art"=5),selected=1,width=350),
                                      numericInput("p_ug","Undergraduate Grade",
                                                   min=0,max=100,value=65,step=0.1,width=350),
                                      numericInput("p_mb","MBA Grade",
                                                   min=0,max=100,value=65,step=0.1,width=350),
                                      selectInput("p_we","Previous Work Experience",
                                                  c("Yes"=1,"No"=0),selected=0,width=350),
                                      numericInput("p_eb","Employability Before",
                                                   min=62,max=423,value=191,step=1,width=350),
                                      selectInput("p_js","Job Status",
                                                  c("Placed"=1,"Not Placed"=0),selected=1,width=350),
                                      numericInput("p_sal","Salary",
                                                   min=76000,max=470000,value=148000,step=1000,width=350)
                                  )
                           ),
                           column(5,
                                  box(width=NULL,title="Prediction",solidHeader=TRUE,
                                      status="info",align="center",
                                      textOutput("predicted_output"))
                           ),
                           column(1)
                         ),
                )
              )
      ), #tabItem
      tabItem(tabName = "Data",
              
              
              fluidRow(
                column(3,
                       box(width=NULL,
                           checkboxGroupInput("get_data","Select predictor variables:",
                                              c("Undergraduate Degree"="Undergrad_Degree",
                                                "Undergraduate Grade"="Undergrad_Grade",
                                                "MBA Grade"="MBA_Grade",
                                                "Previous Work Experience"="Work_Experience",
                                                "Empliyability Before MBA"="Employability_Before",
                                                "Empliyability After MBA"="Employability_After",
                                                "Job Status"="Status","Salary"="Salary"),
                                              selected=c("Undergrad_Degree","Salary","Work_Experience")),
                           numericInput("offset","Select offset value",
                                        min=100,max=1200,value=0,step=1,width=300),
                           
                           downloadButton('download',"Download CSV")
                       )
                ),
                column(9,
                       box(width=NULL,
                           dataTableOutput("data_csv"))
                )
              )
      ) 
    ) 
  ) 
) 