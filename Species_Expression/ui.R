

header <- dashboardHeader(
  title = "InGENEX"
)

body <- dashboardBody(
  fluidRow(
    column(width = 4,
           selectizeInput(inputId = 'gene_symbol',
                          label = 'Gene:',
                          choices = NULL,
                          multiple = F
           ),
           fluidRow(
             column(width=4, align = 'center', style = 'padding:2px', 
                    radioGroupButtons('scale',
                                      'Choose data format:',
                                      choices = c('AVG' = 'avg_expr',
                                                  'SCALED' = 'scaled_expr',
                                                  '% EXP' = 'pct_expr'),
                                      direction = 'vertical'
                    )),
             column(width = 8, style = 'padding:2px',
                    wellPanel(
                      style = 'background:lightgray; padding:5px;',
                      p(strong('AVG: '),'average expression wthin cell type', br()),
                      p(strong('Scaled: '),'expression compared to other cell types',br()),
                      strong('% EXP: '),'percent of cells expressing gene'))
           )
    ),
    column(width = 8,
           addInfoUI('info'))
  ),
  fluidRow(
    column(width = 4, style = 'padding: 10px',
           h3(strong('Human'),
              style = 'text-align:center;'),
           barplotUI('human')),
    column(width = 4, style = 'padding: 10px',
           h3(strong('Non-Human Primate'),
              style = 'text-align:center;'),
           barplotUI('nhp')),
    column(width = 4, style = 'padding: 10px',
           h3(strong('Mouse'),
              style = 'text-align:center;'),
           barplotUI('mouse'))
  ),
  br(),
  fluidRow(
    column(width = 4, style = 'padding: 10px',
           percentPlotUI('human_donut'),
           metadataUI('human_meta')),
    column(width = 4, style = 'padding: 10px',
           percentPlotUI('nhp_donut'),
           metadataUI('nhp_meta')),
    column(width = 4, style = 'padding: 10px',
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
