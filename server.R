library(shiny)
library(r4ss)
library(ggplot2)
shinyServer(function(input, output) {

    calc <- reactive({
        n <- as.numeric(input$n)
        N <- as.numeric(input$N)
        CI <- as.numeric(input$CI)
        p <- as.numeric(input$p)

        df <- data.frame(matrix(nrow=N,ncol=6))
        colnames(df) <- c("hits","pHat","pSD","pHatMax","pHatMin","no.sample")
        
        for (i in 1:N){
            x <- rbinom(n,size=1,prob=p)
            pHat <- mean(x)
            pSD <- sqrt(pHat*(1-pHat)/n)
            CI.corrected <- ((100-CI)/2+CI)/100
            q <- qnorm(CI.corrected)
            pHatMax <- (pHat+q*pSD)
            pHatMin <- (pHat-q*pSD)
            hits <- pHatMax>p && pHatMin<p
            df[i,] <- list(hits,pHat,pSD,pHatMax,pHatMin,i)
           
        }
        df
    })

    hits <- reactive({
        df <- calc()
        sum(df[,1])/nrow(df)*100
        
    })
        

    output$hits <-
        renderText(paste("Simulation Sample Mean CI",round(hits(),digits=1),"%."))
    output$hits2 <-
        renderText(paste("Expected Sample Mean CI",as.numeric(input$CI),"%."))

    output$plot1 <- renderPlot({
        df <- calc()
        df$hits <- as.factor(df$hits)
        df$hits <- relevel(df$hits,"TRUE")
        ggplot(df, aes(x=no.sample, y=pHat, colour=hits)) +
        geom_errorbar(aes(ymin=pHatMin, ymax=pHatMax), width=1) +
        geom_hline(yintercept=as.numeric(input$p), linetype="dashed",
        color = "red",
        size=2)+scale_color_manual(breaks=c("TRUE","FALSE"),values=c("green","red"))+
            coord_flip() + xlab("Sample #") +
        ylab("Sample Mean")
        
    })
    
    
    ## output$plot2  <-
    ##     renderText("X axis denotes the Sample Mean. Y axis denotes the Sample #. The red vertical line is the Population Mean. Green confidence bands contain the Population Mean. Red confidence bands DO NOT contain the Population Mean.")

    output$plot2 <- renderUI({
        tags$div(
                 tags$ul(
                          tags$li("X axis denotes the Sample Mean."),
                          tags$li("Y axis denotes the Sample #."),
                          tags$li("Red Line is the Population Mean."),
                          tags$li("Green Confidence Bands contain the Population Mean."),
                          tags$li("Red Confidence Bands DO NOT contain the Population Mean.")
                      )
             )
    })
    
    output$docu <-
        renderText("Change the sliders to see the change in the plots. The above plots inform if it is a reasonable approximation to take the SE (standard error) of the sample as a ssubstitute for the population standard deviation.")

    output$docu2 <-
        renderText("We compute the number of times a 'mean of a random sample' is within 'X' Standard errors of population probability. This number is shown above the plot and is very close to the Confidence interval.")
    
    url2 <- a("KhanAcademy CI Simulator", href="https://www.khanacademy.org/math/ap-
statistics/estimating-confidence-ap/introduction-confidence-intervals/
v/confidence-interval-simulation")
    
    output$insp <- renderUI({
        tags$div(
                 tags$ul(
                          tags$li(url2)
                          
                      )
             )
    })

    url3 <- a("repository",
              href="https://github.com/tkravichandran/ci-simulation")

    ## output$code <- renderUI({
    ##     tagList("The scripts and calculations can be found in this", url3)
    ## })

    output$code <- renderUI({
        tags$div(
                 tags$ul(
                          tags$li(tagList("The scripts and calculations can be found in this", url3,"."))
                          
                      )
             )
    })


#### Github Plug
    
    url <- a("tkravichandran", href="https://github.com/tkravichandran")
    
    output$mySite <- renderUI({
        
        tagList("Made by", url)
    })


    ## output$Site <- renderUI({
    ##     tags$div(img(src = "gitmark.png", align="left"))
    ##     })
        
##     output$insp <- renderText("https://www.khanacademy.org/math/ap-
## statistics/estimating-confidence-ap/introduction-confidence-intervals/
## v/confidence-interval-simulation")

    ## output$code <-
    ##     renderText("The Code and calculations are shown in presentation of this assignment.")

    

    })
