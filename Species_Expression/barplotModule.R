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
      
      colors <- c('gray', 'purple', 'violet', 'orange3', 'pink3', 'olivedrab4', 'plum4', 'blue', 'green', 'red')
      
      level_order <- c('Fibroblasts', 'Acinar', 'Ductal', 'Stellate', 'Immune', 'Endothelial', 'Gamma', 'Epsilon', 'Delta', 'Beta', 'Alpha')
      
      database$celltype <- factor(human$celltype, levels = level_order)
      
      database %>% 
        filter(Gene == gene) %>% 
        ggplot(aes(x=celltype, y = !!as.name(graphType), fill = celltype)) + 
        geom_col(position = position_dodge()) +
        coord_flip() +
        theme_minimal() +
        theme(axis.title.y = element_blank(),
              legend.position = 'none') +
        labs(y = graphType) +
        fill_palette(palette = colors) +
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