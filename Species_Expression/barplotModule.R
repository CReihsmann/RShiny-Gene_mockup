barplotUI <- function(id) {
  tagList(
    plotOutput(NS(id, "barplot"))
  )
}

barplotServer <- function(id, gene = NULL, database = NULL, graphType = NULL) {
  moduleServer(id, function(input, output, session){
    
    output$barplot <- renderPlot({
      
      shiny::validate(
        need(gene != '', 'Choose Gene')
      )
      
      if(graphType == 'avg_expr') {
        y_axis = 'Average Expression'
      }
      else if(graphType == 'scaled_expr'){
        y_axis = 'Average Expression Scaled'
      }
      else {
        y_axis = 'Percent Expression'
      }
      # human <- read_csv('20230602-human_data.csv')
      
      colors <- c('Alpha'='red', 
                  'Beta'='green', 
                  'Delta'='blue', 
                  'Epsilon'='plum4',
                  'Gamma'='olivedrab4', 
                  'Endothelial'='pink3', 
                  'Immune'='orange3', 
                  'Stellate'='violet',
                  'Ductal'='purple', 
                  'Acinar' = 'gray', 
                  'Fibroblasts' = 'brown')
      
      level_order <- c('Alpha', 'Beta', 'Delta', 'Epsilon',
                       'Gamma', 'Endothelial', 'Immune', 'Stellate',
                       'Ductal', 'Acinar', 'Fibroblasts')
      
      database$celltype <- factor(database$celltype, levels = rev(level_order))
      
      database %>% 
        filter(Gene == gene) %>% 
        ggplot(aes(x=celltype, y = !!as.name(graphType), fill = celltype)) + 
        geom_col(position = position_dodge()) +
        coord_flip() +
        theme_minimal() +
        theme(axis.title.y = element_blank(),
              legend.position = 'none') +
        labs(y = graphType) +
        scale_fill_manual(values = colors) +
        scale_x_discrete(drop = F)
      # database %>% 
      #   filter(Gene == gene) %>% 
      #   ggplot(aes(x=celltype, y = !!as.name(graphType), fill = celltype)) + 
      #   geom_col(position = position_dodge()) +
      #   coord_flip() +
      #   theme_minimal() +
      #   theme(axis.title.y = element_blank(),
      #         legend.position = 'none') +
      #   labs(y = y_axis) +
      #   fill_palette(palette = colors) +
      #   scale_x_discrete(drop = F)
    })
  })
}