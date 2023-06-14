
library(shiny)

# Define server logic required to draw a histogram
function(input, output, session) {
  
  updateSelectizeInput(session, 
                       'gene_symbol', 
                       choices = gene_list,
                       options = list(
                         # placeholder = 'Choose Gene',
                         onInitialize = I('function() { this.setValue(""); }')
                       ), 
                       server = T)
  
  observeEvent(input$gene_symbol, {
    barplotServer('human', input$gene_symbol, human, graphType = input$scale)
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
