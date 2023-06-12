

library(shinydashboard)
library(shinyWidgets)

header <- dashboardHeader(
  title = "Inter-Species Gene Comparison"
)

body <- dashboardBody(
  fluidRow(
    column(width = 2,
           selectizeInput('gene_symbol',
                          'Gene:',
                          choices = NULL,
                          multiple = F,
                          options = list(
                            placeholder = 'Choose Gene',
                            onInitialize = I('function() { this.setValue(""); }')
                          )
           ))
  ),
  fluidRow(
    column(width = 4,
           radioGroupButtons('scale',
                                'Choose Scale:',
                                choices = c('AVG', 'SCALED', '% EXP')
           ))
  ),
  fluidRow(
    column(width = 4,
           h3(strong('Human'),
             style = 'text-align:center;')),
    column(width = 4,
           h3(strong('Non-Human Primate'),
              style = 'text-align:center;')),
    column(width = 4,
           h3(strong('Mouse'),
              style = 'text-align:center;'))
  ),
  fluidRow(
    column(6,
           h4(strong(tags$u('Additional Information:'))),
           p(strong('Gene:'), textOutput('test_test', inline = T)),
           p(strong('Gene Symbol:'), textOutput('test_test', inline = T)),
           p(strong('UniProt ID:'), textOutput('test_test', inline = T)),
           p(strong('Description:'), textOutput('test_test', inline = T)),
           p(strong('Function:'), textOutput('test_test', inline = T)),
           p(strong('Seq Length:'), textOutput('test_test', inline = T)),
           p(strong('Mol Mass:'), textOutput('test_test', inline = T))
           ),
    column(6,
           h4(strong(tags$u())))
  )
)

dashboardPage(
  header,
  dashboardSidebar(disable = T),
  body
)
