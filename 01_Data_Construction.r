# objective: 



# install packages
if (!require("tidyverse")) install.packages("tidyverse")
library(tidyverse)



# read .asc files and make them matrix.
# Bus group 1: 1983 Grumman model 870 buses (15 buses total)
df_group_1 <- 
  read.csv("./dat/g870.asc", header = FALSE) %>% 
  as.matrix() %>% 
  matrix(ncol  = 15) %>% 
  t() %>% 
  as_tibble()

# Bus group 2: 1981 Chance RT-50 buses (4 buses total)
df_group_2 <- 
  read.csv("./dat/rt50.asc", header = FALSE) %>% 
  as.matrix() %>% 
  matrix(ncol = 4) %>% 
  t() %>% 
  as_tibble()

# Bus group 3: 1979 GMC model t8h203 buses (48 buses total)
df_group_3 <- 
  read.csv("./dat/t8h203.asc", header = FALSE) %>% 
  as.matrix() %>% 
  matrix(ncol = 48) %>% 
  t() %>% 
  as_tibble()

# Bus group 4: 1975 GMC model a5308 buses (37 buses total)
df_group_4 <- 
  read.csv("./dat/a530875.asc", header = FALSE) %>% 
  as.matrix() %>% 
  matrix(ncol = 37) %>% 
  t() %>% 
  as_tibble()

# Bus group 5: 1974 GMC model a5308 buses (12 buses total)
df_group_5 <- 
  read.csv("./dat/a530874.asc", header = FALSE) %>% 
  as.matrix() %>% 
  matrix(ncol = 12) %>% 
  t() %>% 
  as_tibble()

# Bus group 6: 1974 GMC model a4523 buses (10 buses total)
df_group_6 <- 
  read.csv("./dat/a452374.asc", header = FALSE) %>% 
  as.matrix() %>% 
  matrix(ncol = 10) %>% 
  t() %>% 
  as_tibble()

# Bus group 7: 1972 GMC model a5308 buses (18 buses total)
df_group_7 <- 
  read.csv("./dat/a530872.asc", header = FALSE) %>% 
  as.matrix() %>% 
  matrix(ncol = 18) %>% 
  t() %>% 
  as_tibble() 

# Bus group 8: 1972 GMC model a4523 buses (18 buses total)
df_group_8 <- 
  read.csv("./dat/a452372.asc", header = FALSE) %>% 
  as.matrix() %>% 
  matrix(ncol = 18) %>% 
  t() %>% 
  as_tibble() 

# make them list 
list_01_constructed_data <- list(
  group1 = df_group_1,
  group2 = df_group_2,
  group3 = df_group_3,
  group4 = df_group_4,
  group5 = df_group_5,
  group6 = df_group_6,
  group7 = df_group_7,
  group8 = df_group_8
) 



# fill column names
# define function 
cols_base <- c("bus_number", "month_purchased", "year_purchased", "month_of_1st_engine_replacement", "year_of_1st_engine_replacement",
               "odometer_at_1st_replacement", "month_of_2nd_engine_replacement", "year_of_2nd_engine_replacement","odometer_at_2nd_replacement",
               "month_odometer_data_begins", "year_odometer_data_begins")

make_colnames <- function(dat){
  check <- dat %>% pull(V1)
  if(check[1] %in% c(2386, 2387, 2388, 2389)){
    duration_data <- seq(as.Date("1981-5-1"), as.Date("1985-5-1"), by = "months")
    col_duration_data <- paste0("odometer_reading_", duration_data)
  }
  else{
    month_data_begin <- dat %>% pull(V10) %>% unique()
    year_data_begin <- dat %>% pull(V11) %>% unique()
    
    date_data_begin <- as.Date(paste(paste0("19", year_data_begin), month_data_begin, "1", sep = "-"))
    duration_data <- seq(date_data_begin, as.Date("1985-5-1"), by = "months")
    col_duration_data <- paste0("odometer_reading_", duration_data)
  }
  
  return(c(cols_base, col_duration_data))
  
}

for (i in 1:length(list_01_constructed_data)){
  colnames(list_01_constructed_data[[i]]) <- make_colnames(list_01_constructed_data[[i]]) 
  
  list_01_constructed_data[[i]] <- 
    list_01_constructed_data[[i]] %>% 
    mutate(Bus_group = i)
  
}

# save RDS
saveRDS(list_01_constructed_data, "./intermediate/list_01_constructed_data.rds")











