library(shiny)
library(ggplot2)

# Define UI for application that draws dynamical system trajectories
shinyUI(fluidPage(
  titlePanel("DYNAmical System TrajectorY Plot (DYNASTYPlot)"),
  sidebarLayout(
    sidebarPanel(
                 h1("Options"), 
                 h2("Governing equations"),
                 textInput("dxdt", label = "dx/dt"),
                 textInput("dydt", label = "dy/dt"),
                 h2("Parameters"), 
                 h2("Display Options"),
                 numericInput("maxTime", label = "Maximum time", value = 1.0),
                 checkboxInput("fixedPoints", label = "Display fixed points"),
                 checkboxInput("nullclines", label = "Display nullclines"),
                 sliderInput("plotSize", label = "Plot size", min = 100, max = 1000, value = 500),
                 actionButton("go", label = "Plot")
    ),
    mainPanel(
        h1("Plot"),
        textOutput("xdot"),
        textOutput("ydot"),
        plotOutput("plot", click = "plot_click"),
        textOutput("pos"),
        textOutput("size"),
        actionButton("clear", label = "Clear plot"),
        textOutput("cleared")
      )
    )

))

