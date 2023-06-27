

header <- dashboardHeader(
  title = "InGENEX"
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
           percentPlotUI('human_donut'),
           metadataUI('human_meta')),
    column(width = 4,
           h3(strong('Non-Human Primate'),
              style = 'text-align:center;'),
           barplotUI('nhp'),
           percentPlotUI('nhp_donut'),
           metadataUI('nhp_meta')),
    column(width = 4,
           h3(strong('Mouse'),
              style = 'text-align:center;'),
           barplotUI('mouse'),
           percentPlotUI('mouse_donut'),
           metadataUI('mouse_meta'))
  ),
  addInfoUI('info')
  # fluidRow(
  #   column(6,addInfoUI('info')
  #          ),
  #   column(6,
  #          h4(strong(tags$u('Links'))),
  #          p(strong('Protein Atlas'), textOutput('test', inline = T)),
  #          p(strong('UniProt'), textOutput('w', inline = T)),
  #          p(strong('Panther'), textOutput('e', inline = T))
  #          )
  # )
)

dashboardPage(
  header,
  dashboardSidebar(disable = T),
  body
)
