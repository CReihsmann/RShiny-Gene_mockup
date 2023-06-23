
library(shiny)

function(input, output, session) {
  
  updateSelectizeInput(session, 
                       'gene_symbol', 
                       choices = gene_list,
                       selected = 'INS',
                       server = T)
  
  observeEvent(input$scale, {
    observeEvent(input$gene_symbol, {
    barplotServer('human', input$gene_symbol, human, graphType = input$scale)
    barplotServer('nhp', nhp_orthos[input$gene_symbol], nhp, graphType = input$scale)
    barplotServer('mouse', ms_orthos[input$gene_symbol], mouse, graphType = input$scale)
  })})
  
  observeEvent(input$gene_symbol, {
    addInfoServer('info', input$gene_symbol, ensemble_dict)
  })
  
  # output$barplot <- renderPlot({
  #   colors <- c('gray', 'purple', 'violet', 'orange3', 'pink3', 'olivedrab4', 'plum4', 'blue', 'green', 'red')
  #   
  #   level_order <- c('Fibroblasts', 'Acinar', 'Ductal', 'Stellate', 'Immune', 'Endothelial', 'Gamma', 'Epsilon', 'Delta', 'Beta', 'Alpha')
  #   
  #   human$celltype <- factor(human$celltype, levels = level_order)
  #   
  #   human %>% 
  #     filter(Gene == 'INS') %>% 
  #     ggplot(aes(x=celltype, y = avg_expr, fill = celltype)) + 
  #     geom_col(position = position_dodge()) +
  #     coord_flip() +
  #     theme_minimal() +
  #     theme(axis.title.y = element_blank(),
  #           legend.position = 'none') +
  #     labs(y = 'Scaled Expression') +
  #     fill_palette(palette = colors) +
  #     scale_x_discrete(drop = F)
  # })
                       
}
