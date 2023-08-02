

header <- dashboardHeader(
    title = "InGENEX",
    tags$li(a(href='https://pancreatlas.org',
              img(src='pancreatlas-logo_white.png', height = '50px'),
              style = "padding-top:0px; padding-bottom:0px;"),
            class = 'dropdown')
)

body <- dashboardBody(
    tags$head(tags$style(HTML(css))),
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
                                            'Choose gene expression unit:',
                                            choices = c('AVG' = 'avg_expr',
                                                        'SCALED' = 'scaled_expr',
                                                        '% EXP' = 'pct_expr'),
                                            direction = 'vertical'
                          )),
                   column(width = 8, style = 'padding-left:2px;padding-right:10px;',
                          wellPanel(
                              style = 'background:lightgray; padding:5px;',
                              p(strong('AVG: '),'average expression wthin cell type', br()),
                              p(strong('Scaled: '),'expression compared to other cell types',br()),
                              strong('% EXP: '),'percent of cells expressing gene'))
               )
        ),
        column(width = 8, style = 'margin-top:32px;',
               addInfoUI('info'))
    ),
    fluidRow(
        column(width = 4, style = 'padding:10px;background-color:white;background-clip:content-box;',
               h3(strong('Human'),
                  style = 'text-align:center;'),
               barplotUI('human')),
        column(width = 4, style = 'padding:10px;background-color:white;background-clip:content-box;',
               h3(strong('Non-Human Primate'),
                  style = 'text-align:center;'),
               barplotUI('nhp')),
        column(width = 4, style = 'padding:10px;background-color:white;background-clip:content-box;',
               h3(strong('Mouse'),
                  style = 'text-align:center;'),
               barplotUI('mouse'))
    ),
    fluidRow(style = 'margin=10x'),
    fluidRow(
        column(width = 4, style = 'padding:10px;background-color:white;background-clip:content-box;',
               fluidRow(
                   column(width = 6, style = 'padding-left:15px;padding-right:0px;padding-bottom:0px;padding-top:0px;', 
                          percentPlotUI('human_donut')),
                   column(width = 6, style = 'padding-left:0px;padding-right:0px;padding-bottom:0px;padding-top:45px;', align = 'center',
                          tags$figure(class = 'centerFigure',
                                      tags$img(src = 'Cross-species islets_Human.png',
                                               width = 155)))
               )
               # percentPlotUI('human_donut'),
        ),
        column(width = 4, style = 'padding:10px;background-color:white;background-clip:content-box;',
               fluidRow(
                   column(width = 6, style = 'padding-left:15px;padding-right:0px;padding-bottom:0px;padding-top:0px;',
                          percentPlotUI('nhp_donut')),
                   column(width = 6, style = 'padding-left:0px;padding-right:0px;padding-bottom:0px;padding-top:45px;', align = 'center',
                          tags$figure(class = 'centerFigure',
                                      tags$img(src = 'Cross-species islets_Primate.png',
                                               width = 155)))
               )
        ),
        column(width = 4, style = 'padding:10px;background-color:white;background-clip:content-box;',
               fluidRow(
                   column(width = 6, style = 'padding-left:15px;padding-right:0px;padding-bottom:0px;padding-top:0px;',
                          percentPlotUI('mouse_donut')),
                   column(width = 6, style = 'padding-left:0px;padding-right:0px;padding-bottom:0px;padding-top:45px;', align = 'center',
                          tags$figure(class = 'centerFigure',
                                      tags$img(src = 'Cross-species islets_Mouse.png',
                                               width = 155)))
               )
        )
    ),
    fluidRow(style = 'margin-top:0px;',
             column(width = 4, style = 'padding-left:10px; padding-right:10px; margin-top:0px;',
                    metadataUI('human_meta')),
             column(width = 4, style = 'padding-left:10px; padding-right:10px; margin-top:0px;',
                    metadataUI('nhp_meta')),
             column(width = 4, style = 'padding-left:10px; padding-right:10px; margin-top:0px;',
                    metadataUI('mouse_meta'))
    )
)

dashboardPage(
    header,
    dashboardSidebar(disable = T),
    body
)
