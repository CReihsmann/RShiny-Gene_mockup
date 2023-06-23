

header <- dashboardHeader(
  title = "Inter-Species Gene Comparison"
)

body <- dashboardBody(
  fluidRow(
    column(width = 2,
           selectizeInput(inputId = 'gene_symbol',
                          label = 'Gene:',
                          choices = NULL,
                          multiple = F,
                          # options = list(
                          #   placeholder = 'Choose Gene',
                          #   onInitialize = I('function() { this.setValue(""); }')
                          # )
           ))
  ),
  fluidRow(
    column(width = 4,
           radioGroupButtons('scale',
                             'Choose Scale:',
                             choices = c('AVG' = 'avg_expr',
                                         'SCALED' = 'scaled_expr',
                                         '% EXP' = 'pct_expr')
           ))
  ),
  fluidRow(
    column(width = 4,
           h3(strong('Human'),
              style = 'text-align:center;'),
           barplotUI('human'),
           metadataUI('human_meta')),
    column(width = 4,
           h3(strong('Non-Human Primate'),
              style = 'text-align:center;'),
           barplotUI('nhp'),
           metadataUI('nhp_meta')),
    column(width = 4,
           h3(strong('Mouse'),
              style = 'text-align:center;'),
           barplotUI('mouse'),
           metadataUI('mouse_meta'))
  ),
  fluidRow(
    column(6,addInfoUI('info')
           # h4(strong(tags$u('Additional Information:'))),
           # p(strong('Gene:'), textOutput('test_test', inline = T)),
           # p(strong('Gene Symbol:'), textOutput('a', inline = T)),
           # p(strong('UniProt ID:'), textOutput('s', inline = T)),
           # p(strong('Description:'), textOutput('d', inline = T)),
           # p(strong('Function:'), textOutput('f', inline = T)),
           # p(strong('Seq Length:'), textOutput('x', inline = T)),
           # p(strong('Mol Mass:'), textOutput('v', inline = T))
           ),
    column(6,
           h4(strong(tags$u('Links'))),
           p(strong('Protein Atlas'), textOutput('test', inline = T)),
           p(strong('UniProt'), textOutput('w', inline = T)),
           p(strong('Panther'), textOutput('e', inline = T))
           )
  )
)

dashboardPage(
  header,
  dashboardSidebar(disable = T),
  body
)
