library(shiny)
shinyUI(fluidPage(

    titlePanel(title="Confidence Interval of Sample Mean, a Simulation"),

        titlePanel(
        windowTitle = "NOAA",
        title = tags$head(tags$link(rel="shortcut icon", 
                                    href="https://drive.google.com/file/d/1ovniqPI_LBQf6e16wOfHORQ-DhQQEmR1/view?usp=sharing",
        type="image/x-icon"))),
    
    sidebarLayout(
        sidebarPanel(
            wellPanel(helpText("This app simulates Confidence Intervals.",
                               "E.g., 95% Confidence Interval of a Sample Mean contains Population Mean (p), 95% of the time.")),
            h3("Move the Sliders to see the plot change"),
            wellPanel(sliderInput("n","Sample size(n)",20,100,20),
                      sliderInput("p","Population Mean (p)",0,1,0.3),
                      sliderInput("CI","Confindence Interval (CI%)",0,100,95),
                      sliderInput("N","Number of samples (N)",0,150,30)),
                                        #actionButton("reset","Click
                                        #to resample")
            uiOutput("mySite")
            
        ),
        mainPanel(
            h3("Results and Plot"),
            textOutput("hits2"),
            textOutput("hits"),
            plotOutput("plot1"),
            h3("Plot Explanation"),
            uiOutput("plot2"),
            h3("Code and calulations of Server and UI"),
            uiOutput("code"),
            h3("Inspiration"),
            uiOutput("insp")
            
        )
    )
))
