addInfoUI <- function(id) {
  fluidRow(column(8,
         tagList(
           # h4(strong(tags$u('Additional Information:'))),
           p(strong('Gene:'), textOutput(NS(id, 'gene'), inline = T)),
           p(strong('Gene Symbol:'), textOutput(NS(id, 'gene_symb'), inline = T)),
           p(strong('UniProt ID:'), textOutput(NS(id, 'uniprot'), inline = T)),
           p(strong('Description:'), textOutput(NS(id, 'description'), inline = T)),
           # p(strong('Function:'), textOutput(NS(id, 'f'), inline = T)),
           p(strong('Seq Length:'), textOutput(NS(id, 'length'), inline = T))
         )
  ),
  column(4, 
         # h4(strong(tags$u('Links'))),
         uiOutput(NS(id, 'PA_link')),
         uiOutput(NS(id, 'UP_link')),
         uiOutput(NS(id, 'P_link')),
         uiOutput(NS(id, 'NIH_link'))
         ))
}

addInfoServer <- function(id, gene = NULL, dictionary = NULL) {
    moduleServer(id, function(input, output, session){
        
        api_calls <- reactive({
            
            ensembleID <- dictionary[gene]
            
            if (!is.na(ensembleID) == T) {
                
                req_pa <- request('www.proteinatlas.org/api/search_download.php')
                
                resp_pa <- req_pa %>% 
                    req_url_query(
                        search = ensembleID,
                        format = 'json',
                        columns = 'g,gs,gd,up,xref_hgnc,xref_disgenet',
                        compress = 'no') %>% #,gs,gd,up,upbp,t_RNA_pancreas') %>%
                    req_perform() 
                
                result_pa <- fromJSON(resp_pa %>% resp_body_string())
                
                uniprot <- pull(result_pa, Uniprot)
                
                req_uniprot <- request('https://rest.uniprot.org/uniprotkb/search')
                
                resp_uniprot <- req_uniprot %>% 
                    req_url_query(
                        fields = 'id, length, mass, cc_function, xref_hgnc, xref_disgenet',
                        query = paste0('accession:', uniprot, sep = ''),
                        format = 'json'
                    ) %>% 
                    req_perform() 
                
                result_uniprot <-fromJSON(resp_uniprot %>% resp_body_string())[['results']]
                
                if (length(result_uniprot[[4]][[1]])[[1]][[1]] > 0){
                
                all_data <- result_pa %>% 
                    mutate(gene_function = pull(as_tibble((result_uniprot[[4]][[1]])[[1]][[1]]), value),
                           sequence_length = pull(result_uniprot$sequence[1]),
                           hgnc = str_sub(result_uniprot[[5]][[1]][[2]][[2]], -4),
                           gene_id = result_uniprot[[5]][[1]][[2]][[1]])
                } else {
                    all_data <- result_pa %>% 
                        mutate(gene_function = 'N/A',
                               sequence_length = pull(result_uniprot$sequence[1]),
                               hgnc = str_sub(result_uniprot[[5]][[1]][[2]][[2]], -4),
                               gene_id = result_uniprot[[5]][[1]][[2]][[1]])
                }
            }
            else {
                all_data <- tibble(`Gene description` = 'N/A',
                       Gene = 'N/A',
                       Uniprot = 'N/A',
                       gene_function = 'N/A',
                       sequence_length = 'N/A',
                       hgnc = 'N/A',
                       gene_id = 'N/A')
            }
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
        
        output$PA_link <- renderUI({
          ensembleID <- dictionary[gene]
          url <- a(p(strong(icon('book-atlas'),'Human Protein Atlas',icon('arrow-up-right-from-square'))), href = paste0('https://www.proteinatlas.org/', ensembleID))
        })
        output$UP_link <- renderUI({
          uniprot <- pull(api_calls(), Uniprot)[[1]]
          url <- a(p(strong(icon('circle-notch'),'UniProt',icon('arrow-up-right-from-square'))), href = paste0('https://www.uniprot.org/uniprotkb/', uniprot))
        })
        output$P_link <- renderUI({
          uniprot <- pull(api_calls(), Uniprot)[[1]]
          hgnc <- pull(api_calls(), hgnc)[[1]]
          url <- a(p(strong(icon('cat'),'Panther',icon('arrow-up-right-from-square'))), href = paste0('https://www.pantherdb.org/genes/gene.do?acc=HUMAN%7CHGNC%3D', hgnc, '%7CUniProtKB%3D', uniprot))
        })
        output$NIH_link <- renderUI({
          gene_id <- pull(api_calls(), gene_id)[[1]]
          url <- a(p(strong(icon('dna'),'NIH - gene',icon('arrow-up-right-from-square'))), href = paste0('https://www.ncbi.nlm.nih.gov/gene/', gene_id))
        })
    })
}