addInfoUI <- function(id) {
  tagList(
    h4(strong(tags$u('Additional Information:'))),
    p(strong('Gene:'), textOutput(NS(id, 'gene'), inline = T)),
    p(strong('Gene Symbol:'), textOutput(NS(id, 'gene_symb'), inline = T)),
    p(strong('UniProt ID:'), textOutput(NS(id, 'uniprot'), inline = T)),
    p(strong('Description:'), textOutput(NS(id, 'description'), inline = T)),
    # p(strong('Function:'), textOutput(NS(id, 'f'), inline = T)),
    p(strong('Seq Length:'), textOutput(NS(id, 'length'), inline = T)),
    p(strong('Mol Mass:'), textOutput(NS(id, 'mass'), inline = T))
  )
}

addInfoServer <- function(id, gene = NULL, dictionary = NULL) {
  moduleServer(id, function(input, output, session){
    
    api_calls <- reactive({
      req_pa <- request('www.proteinatlas.org/api/search_download.php')
      
      resp_pa <- req_pa %>% 
        req_url_query(
          search = dictionary[gene],
          format = 'json',
          columns = 'g,gs,gd,up',
          compress = 'no') %>% #,gs,gd,up,upbp,t_RNA_pancreas') %>%
        req_perform()
      
      result_pa <- fromJSON(resp_pa %>% resp_body_string())
      
      uniprot <- pull(result_pa, Uniprot)
      
      req_uniprot <- request('https://rest.uniprot.org/uniprotkb/search')
      
      resp_uniprot <- req_uniprot %>% 
        req_url_query(
          fields = 'id, length, mass, cc_function',
          query = paste0('accession:', uniprot, sep = ''),
          format = 'json'
        ) %>% 
        req_perform()
      
      result_uniprot <-fromJSON(resp_uniprot %>% resp_body_string())[['results']]
      
      all_data <- result_pa %>% 
        mutate(gene_function = pull(as_tibble((result_uniprot[[3]][[1]])[[1]][[1]]), value),
               sequence_length = pull(result_uniprot$sequence[1]),
               mol_mass = pull(result_uniprot$sequence[2]))
               
    })
    
    output$gene <- renderText({
      pull(api_calls(), `Gene description`)
    })
    output$gene_symb <- renderText({
      pull(api_calls(), Gene)
    })
    output$uniprot <- renderText({
      pull(api_calls(), Uniprot)[[1]]
    })
    output$description <- renderText({
      pull(api_calls(), gene_function)
    })
    output$length <- renderText({
      pull(api_calls(), sequence_length)
    })
    output$mass <- renderText({
      pull(api_calls(), mol_mass)
    })
  })
}