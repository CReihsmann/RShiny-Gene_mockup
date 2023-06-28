library(tidyverse)
library(ggplot2)
library(plotly)
library(shiny)
library(shinydashboard)
library(ggpubr)
library(shinyWidgets)
library(shinycssloaders)
library(httr2)
library(jsonlite)
library(DT)
library(formattable)
library(fontawesome)

source('barplotModule.R')
source('information_module.R')
source('metadata_module.R')
source('percentDonut_module.R')

human <- read_csv('20230602-human_data.csv')
nhp <- read_csv('20230602-nhp_data.csv')
mouse <- read_csv('20230602-mouse_data.csv')
orthologs <- read_csv('gene_dict_df.csv')
ensemble_data <- read_csv('ensemble_dict.csv')
metadata_tbl <- read_csv('species_metadata.csv')

gene_list <- c(unique(human$Gene),"")
nhp_orthos <- with(orthologs, setNames(`Macaque gene name`, `Gene`))
ms_orthos <- with(orthologs, setNames(`Mouse gene name`, `Gene`))
ensemble_dict <- with(ensemble_data, setNames(Ensembl, Gene))

colors <- c('Alpha'='#89cdee', 
            'Beta'='#cd6678', 
            'Delta'='#decd78', 
            'Epsilon'='#301c89',
            'Gamma'='#9a9a30', 
            'Endothelial'='#42ab9a', 
            'Immune'='#669acd', 
            'Stellate'='#ab429a',
            'Ductal'='#660900', 
            'Acinar' = '#087830', 
            'Fibroblast' = '#891c54')

level_order <- c('Alpha', 'Beta', 'Delta', 'Gamma',
                 'Epsilon', 'Endothelial', 'Stellate', 'Fibroblast',
                 'Immune', 'Acinar', 'Ductal')

