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

colors <- c('Alpha'='red', 
            'Beta'='green', 
            'Delta'='blue', 
            'Epsilon'='plum4',
            'Gamma'='olivedrab4', 
            'Endothelial'='pink3', 
            'Immune'='orange3', 
            'Stellate'='violet',
            'Ductal'='purple', 
            'Acinar' = 'gray', 
            'Fibroblasts' = 'brown')

level_order <- c('Alpha', 'Beta', 'Delta', 'Epsilon',
                 'Gamma', 'Endothelial', 'Immune', 'Stellate',
                 'Ductal', 'Acinar', 'Fibroblasts')

