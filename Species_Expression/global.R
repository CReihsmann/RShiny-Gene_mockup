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

source('barplotModule.R')
source('information_module.R')

human <- read_csv('20230602-human_data.csv')
nhp <- read_csv('20230602-nhp_data.csv')
mouse <- read_csv('20230602-mouse_data.csv')
orthologs <- read_csv('gene_dict_df.csv')
ensemble_data <- read_csv('ensemble_dict.csv')

gene_list <- c(unique(human$Gene),"")
nhp_orthos <- with(orthologs, setNames(`Macaque gene name`, `Gene`))
ms_orthos <- with(orthologs, setNames(`Mouse gene name`, `Gene`))
ensemble_dict <- with(ensemble_data, setNames(Ensembl, Gene))

# test <- ensemble_dict['INS']
# 
if(!is.na(ensemble_dict['lkj']) == T) {
    print('foo')
} else {
    print('bar')
}

