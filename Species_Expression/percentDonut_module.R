percentPlotUI <- function(id) {
  tagList(
    plotOutput(NS(id, 'donut'), height = '225px')
  )
}

percentPlotServer <- function(id, species = NULL, metadata = NULL) {
  moduleServer(id, function(input, output, session) {
    
    output$donut <- renderPlot({
      
      metadata$celltype <- factor(metadata$celltype, levels = level_order)
      
      metadata %>% 
        filter(Species == species) %>% 
        mutate(ymax = cumsum((perc_total/100))) %>% 
        mutate(ymin = c(0, head(ymax, n=-1))) %>% 
        mutate(labelPosition = (ymax +ymin)/2) %>% 
        ggplot(aes(ymax = ymax, ymin=ymin, xmax = 4, xmin = 3, fill = celltype)) +
        geom_rect(color = 'white') +
        coord_polar('y') +
        xlim(c(1.5,4)) +
        theme_void() +
        labs(title = 'Celltype \n Proportions') +
        theme(legend.position = 'none',
              plot.margin = unit(c(0, 0, 0, 0), 'inches'),
              plot.title = element_text(hjust = 0.5, vjust = -2, face = 'bold')) +
        scale_fill_manual(values = colors)
        
    })
  })
}