library(tidyverse)
library(readxl)
library(ggplot2)
library(plotly)
library(Seurat)
library(scCustomize)

# RDS files
load('../data/Islets2.Rda')
mouse_data_rds <- readRDS('../data/erener.data.annotated.Rds')
nhp_data_rds <- readRDS('../data/data.rds')
# matrix files (already parsed)
mouse_data <- read_csv('../data/20230221-Erener_Data_all_gene_exp_per_celltype.csv')
nhp_data_perc <- read_xlsx('../data/NHP-Expression_by_Cluster.xlsx', sheet = '% Expressing')
nhp_data_avg <- read_xlsx('../data/NHP-Expression_by_Cluster.xlsx', sheet = 'Avg Expression (normalized)')
nhp_data_scaled <- read_xlsx('../data/NHP-Expression_by_Cluster.xlsx', sheet = 'Scaled Expression')

#finding shared genes b/w datasets
nhp_genes <- toupper(rownames(nhp_data_rds))
mouse_genes <- toupper(rownames(mouse_data_rds))
human_genes <- as.tibble(toupper(rownames(Islets)))

shared_genes <- human_genes %>% 
  filter(value %in% nhp_genes) %>% 
  filter(value %in% mouse_genes) %>% 
  pull(value)

#_______________________________________________
# Code from Max Cottam (Creative Data Solutions)
#_______________________________________________
## Human percent expression data
expr <- NULL
j <- 0
for (i in rownames(Islets)){
  thresh <- max(Islets@assays$RNA@data[i,])*0.25
  expr1 <- Percent_Expressing(
    Islets,
    i,
    threshold = thresh,
    group_by = 'CellTypes',
    split_by = NULL,
    entire_object = F,
    slot = 'data',
    assay = NULL
  )
  expr <- rbind(expr, expr1)
  j <- j+1
  print(j)
}
expr <- cbind(Gene = rownames(expr), expr)
write_csv(expr, '../data/human-perc_expr.csv')

## Human avg expression data
avg <- AverageExpression(Islets,
                         assays = 'RNA',
                         features = rownames(Islets),
                         group.by = 'CellTypes',
                         slot = 'data')
avg_df <- avg[['RNA']]
avg_df <- as_tibble(cbind(Gene = rownames(avg_df), avg_df))
write_csv(avg_df, '../data/human-avg_expr.csv')

## Human scaled expression data (not by CDS)
scaled <- scale(avg[['RNA']])
scaled <- as_tibble(cbind(Gene = rownames(scaled), scaled))
write_csv(scaled, '../data/human-scaled_expr.csv')

#'_______________________
#' STANDARDIZING DATASETS
#'_______________________

celltypes <- c('Alpha', 'Beta', 'Delta', 'Gamma', 'Epsilon', 'Endothelial', 'Immune', 'Stellate')
# HUMAN
## percent
expr <- read_csv('../data/human-perc_expr.csv')
human_perc <- expr %>% 
  mutate(Gene = toupper(Gene)) %>% 
  # filter(Gene %in% shared_genes) %>% 
  pivot_longer(Alpha:Immune, names_to = "celltype", values_to = 'pct_expr')

## average expression
avg_df <- read_csv('../data/human-avg_expr.csv')
human_avg <- avg_df %>% 
  as_tibble() %>% 
  mutate(Gene = toupper(Gene)) %>% 
  # filter(Gene %in% shared_genes) %>% 
  pivot_longer(Alpha:Immune, names_to = "celltype", values_to = 'avg_expr')
## scaled expression
scaled <- read_csv('../data/human-scaled_expr.csv')
human_scaled <- scaled %>% 
  mutate(Gene = toupper(Gene)) %>% 
  # filter(Gene %in% shared_genes) %>% 
  pivot_longer(Alpha:Immune, names_to = "celltype", values_to = 'scaled_expr')
## combined dataset
human_data <- human_perc %>% 
  left_join(human_avg, by = c('Gene', 'celltype')) %>% 
  left_join(human_scaled, by = c('Gene', 'celltype')) %>% 
  filter(celltype %in% celltypes)
write_csv(human_data, '../data/20230602-human_data.csv')

# Non-Human Primate
nhp_celltypes <- c('Alpha', 'Beta', 'Delta', 'Gamma', 'Epsilon', 'Endothelial', 'Immune', 'Fibroblasts')
## percent
nhp_data_perc <- nhp_data_perc %>% 
  mutate(Gene = toupper(Gene)) %>% 
  # filter(Gene %in% shared_genes) %>% 
  pivot_longer(Alpha:Immune, names_to = "celltype", values_to = 'pct_expr')
## average expression
nhp_data_avg <- nhp_data_avg %>% 
  mutate(Gene = toupper(Gene)) %>% 
  # filter(Gene %in% shared_genes) %>% 
  pivot_longer(Alpha:Immune, names_to = "celltype", values_to = 'avg_expr')
## scaled expression
nhp_data_scaled <- nhp_data_scaled %>% 
  mutate(Gene = toupper(Gene)) %>% 
  # filter(Gene %in% shared_genes) %>% 
  pivot_longer(Alpha:Immune, names_to = "celltype", values_to = 'scaled_expr')
## combined dataset
nhp_data <- nhp_data_perc %>% 
  left_join(nhp_data_avg, by = c('Gene', 'celltype')) %>% 
  left_join(nhp_data_scaled, by = c('Gene', 'celltype')) %>% 
  filter(celltype %in% nhp_celltypes)
write_csv(nhp_data, '../data/20230602-nhp_data.csv')

# Mouse
mouse_data <- mouse_data %>% 
  rename(Gene = ...1, avg_expr = avg.exp, pct_exp = pct.exp, scaled_expr = avg.exp.scaled, celltype = id) %>% 
  select(!c(features.plot)) %>% 
  mutate(Gene = toupper(Gene))  
  # filter(celltype %in% celltypes)
write_csv(mouse_data, '../data/20230602-mouse_data.csv')
