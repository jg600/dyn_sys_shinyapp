library(shiny)
library(ggplot2)
library(deSolve)

# Define server logic required to draw dynamical system trajectories
shinyServer(function(input, output) {
  
  i <<- 0
  #df <<- data.frame(x = -10:10, y=-10:10, run = rep(i, length(-10:10)))
  axisLim <<- 10
  dataf <<- data.frame(x = -axisLim:axisLim, y = -axisLim:axisLim, run = rep(i, length(-axisLim:axisLim)))
  
  g <<- ggplot(data = dataf, aes(x=x, y=y)) + geom_blank() + coord_fixed() + xlim(-axisLim, axisLim) + ylim(-axisLim, axisLim)
  output$plot <- renderPlot({
    g
  })
  
  
  parameters <<- c()
  
  coords <<- reactiveValues(coordList=c())
  #reactive({
   # if (!is.null(input$plot_click$x)){
    #  coords$coordList <- c(coords$coordList, c(input$plot_click$x, input$plot_click$y))
     # print("HELLO")
    #}
  #})

  observeEvent(input$plot_click,
               {
                  
                 xdot <<- function(t, state, parameters){
                       with(as.list(c(state, parameters)),{
                       dx <- x
                       dy <- y
                       list(c(dx, dy))
                     }
                     )
                   }
                  #output$pos <- renderText({
#paste("(", input$plot_click$x, ",", input$plot_click$y, ")")
                  #})
                  state <- reactiveValues(x = input$plot_click$x, y = input$plot_click$y)
                  times <- seq(0, input$maxTime, 0.01)
                  soln <- ode(y=c(x = state$x, y = state$y), times = times, func = xdot, parms = parameters)
                  
                  xNew <- soln[,2]
                  
                  yNew <- soln[,3]
                  
                  newDf <- as.data.frame(cbind(xNew, yNew))
                  colnames(newDf) <- c("x", "y")
                  
                  pointDf <- data.frame(x = state$x, y = state$y)

                  if (!is.null(state$x)){
                    coords$coordList <- c(coords$coordList, c(state$x, state$y))
                    print("HELLO")
                  }
                  
                  g <<- g + geom_line(data = newDf, aes(x=x, y=y)) + geom_point(data = pointDf, aes(x=x, y=y))

                  output$plot <- renderPlot({   
                    g
                  })
              }
  )
  
  #reactive({
    #size <- reactiveValues(size = input$plotSize)
    
    output$plot <- renderPlot({
      g
      }, height = exprToFunction(input$plotSize), width = exprToFunction(input$plotSize))
  #})
    
    output$size <- renderText({
      paste(input$plotSize)
    })
  
    output$xdot <- renderText({
      paste("dx/dt=", input$dxdt)
    })
    output$ydot <- renderText({
      paste("dy/dt=", input$dydt)
    })


    

    output$pos <- renderText({
      paste("(", tail(coords$coordList, n=2)[1], ",", tail(coords$coordList, n=2)[2], ")")
      #paste(tail(coords$coordList, n=2))
    })
  
    #printCoords <- reactive({
    #  paste("(", input$plot_click$x, ",", input$plot_click$y, ")")

    #})

})
