barplotUI <- function(id) {
  tagList(
    withSpinner(plotOutput(NS(id, "barplot")))
  )
}

barplotServer <- function(id, gene = NULL, database = NULL, graphType = NULL) {
  moduleServer(id, function(input, output, session){
    
    output$barplot <- renderPlot({
      
      shiny::validate(
        need(gene != '', 'Ortholog not available')
      )
      
      shiny::validate(
        need((gene %in% database$Gene) == TRUE,
             'Gene not in dataset')
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
      
      database$celltype <- factor(database$celltype, levels = rev(level_order))
      
      database %>% 
        filter(Gene == gene) %>% 
        ggplot(aes(x=celltype, y = !!as.name(graphType), fill = celltype)) + 
        geom_col(position = position_dodge()) +
        coord_flip() +
        theme_minimal() +
        theme(axis.title.y = element_blank(),
              axis.text.y = element_text(size = 10),
              axis.text.x = element_text(size = 10),
              legend.position = 'none') +
        labs(y = graphType) +
        scale_fill_manual(values = colors) +
        scale_x_discrete(drop = F)
    })
  })
}