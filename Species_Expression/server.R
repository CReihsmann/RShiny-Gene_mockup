
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
  
  percentPlotServer('human_donut', 'Homo sapiens', metadata_tbl)
  percentPlotServer('nhp_donut', 'Macaca fascicularis', metadata_tbl)
  percentPlotServer('mouse_donut', 'Mus musculus', metadata_tbl)
  
  metadataServer('human_meta', metadata_tbl, 'Homo sapiens')
  metadataServer('nhp_meta', metadata_tbl, 'Macaca fascicularis')
  metadataServer('mouse_meta', metadata_tbl, 'Mus musculus')
                       
}
