library(tidyverse)
library(ggplot2)
library(plotly)
library(shiny)
library(shinydashboard)
library(ggpubr)

source('barplotModule.R')

human <- read_csv('20230602-human_data.csv')
nhp <- read_csv('20230602-nhp_data.csv')
mouse <- read_csv('20230602-mouse_data.csv')
orthologs <- read_csv('gene_dict_df.csv')

gene_list <- c(unique(human$Gene),"")
nhp_orthos <- with(orthologs, setNames(`Macaque gene name`, `Gene`))
ms_orthos <- with(orthologs, setNames(`Mouse gene name`, `Gene`))