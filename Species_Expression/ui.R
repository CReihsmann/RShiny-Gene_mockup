

header <- dashboardHeader(
  title = "InGENEX"
)

body <- dashboardBody(
  fluidRow(
    column(width = 2,
           selectizeInput(inputId = 'gene_symbol',
                          label = 'Gene:',
                          choices = NULL,
                          multiple = F
           ),
           radioGroupButtons('scale',
                             'Choose data format:',
                             choices = c('AVG' = 'avg_expr',
                                         'SCALED' = 'scaled_expr',
                                         '% EXP' = 'pct_expr')
           )),
    column(width = 2,
           strong('AVG: '),br('average expression wthin cell type'),
           strong('Scaled: '),br('expression compared to other cell types'),
           strong('% EXP: '),br('percent of cells expressing gene')),
    column(width = 8,
           wellPanel(addInfoUI('info')))
  ),
  fluidRow(
    column(width = 4,
           h3(strong('Human'),
              style = 'text-align:center;'),
           barplotUI('human')),
    column(width = 4,
           h3(strong('Non-Human Primate'),
              style = 'text-align:center;'),
           barplotUI('nhp')),
    column(width = 4,
           h3(strong('Mouse'),
              style = 'text-align:center;'),
           barplotUI('mouse'))
  ),
  br(),
  fluidRow(
      column(width = 4,
             percentPlotUI('human_donut'),
             metadataUI('human_meta')),
      column(width = 4,
             percentPlotUI('nhp_donut'),
             metadataUI('nhp_meta')),
      column(width = 4,
             percentPlotUI('mouse_donut'),
             metadataUI('mouse_meta'))
  )#,
  # addInfoUI('info')
)

dashboardPage(
  header,
  dashboardSidebar(disable = T),
  body
)
