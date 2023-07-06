metadataUI <- function(id) {
    tagList(
        DTOutput(NS(id, 'metadata'))
    )
}

metadataServer <- function(id, metadata_tbl, species) {
    moduleServer(id, function(input, output, session){
        
        tablePrep <- function(tbl) {
            filtered_tbl <- tbl %>% 
                mutate(Cells = paste0('n = ', as.character(format(total_cells, big.mark = ','))),
                       Donors = paste0('n = ', as.character(Donors)),
                       `GEO ID` = paste0('<a href="',`GEO ID url`,'" target="_blank">',`GEO ID`,'</a>'),
                       Citation = paste0('<a href="',`Citation url`,'" target="_blank">',`Citation`,'</a>')) %>% 
                select(Species, `GEO ID`, Citation, Platform, Donors, Cells) %>%
                filter(Species == species) %>% 
                distinct() %>% 
                t() %>% 
                as.data.frame()
            
            reset_tbl <- filtered_tbl %>%
                mutate(title_col = rownames(filtered_tbl)) %>%
                select(title_col, V1)
            
            
            # reset_tbl,
            # list(
            #     title_col = formatter(
            #         'span',
            #         style = x ~ style(
            #             font.weight = 'bold'
            #         )
            #     )
            # )
            # #%>% 
            # #DT::as.datatable()
        }
        
        output$metadata <- renderDT(
            (datatable(tablePrep(metadata_tbl),
                       rownames = F,
                       colnames = '',
                       escape = F,
                      options = list(
                          lengthChange = F,
                          filter = 0,
                          dom = 't',
                          ordering = F)
                      ) %>% formatStyle('title_col', fontWeight = 'bold'))
        )
    })
}