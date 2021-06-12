# objective: replicate Table 2a, 2b and Figure 1 in Rust 1987



# install packages
if (!require("tidyverse")) install.packages("tidyverse")
library(tidyverse)
library(lubridate)


# read data
list_01_constructed_data <- readRDS("./intermediate/list_01_constructed_data.rds")



# make a data frame for descriptive stats

# Table 2a
# Subsample: buses for which at least 1 replacement occurred
## Mileage
df_Bus_group_mileage_sub <- map_dfr(list_01_constructed_data, function(x){
  return(x %>% filter(month_of_1st_engine_replacement>0) %>% select(Bus_group, odometer_at_1st_replacement, odometer_at_2nd_replacement))})

df_Bus_group_mileage_sub <- 
  df_Bus_group_mileage_sub %>% 
  mutate(odometer_at_2nd_replacement_diff = 
           if_else(odometer_at_2nd_replacement > odometer_at_1st_replacement, odometer_at_2nd_replacement - odometer_at_1st_replacement, 0)) %>% 
  select(-odometer_at_2nd_replacement) %>% 
  pivot_longer(cols = -Bus_group, names_to = "when", values_to = "mileage")

df_Bus_group_mileage_sub_stats <- 
  df_Bus_group_mileage_sub %>% 
  filter(mileage > 0) %>% 
  group_by(Bus_group) %>% 
  summarise(Max_Mileage = max(mileage), 
            Min_Mileage = min(mileage), 
            Mean_Mileage = round(mean(mileage)), 
            SD_Mileage = round(sd(mileage)),
            Number_of_Observations = n()) %>% 
  ungroup()



## Elapsed Time (Months)
df_Bus_group_elapsed_time_sub <- map_dfr(list_01_constructed_data, function(x){
  return(x %>% filter(month_of_1st_engine_replacement>0) %>% select(Bus_group, month_purchased, year_purchased, month_of_1st_engine_replacement, year_of_1st_engine_replacement, month_of_2nd_engine_replacement, year_of_2nd_engine_replacement))})

df_Bus_group_elapsed_time_sub <- 
  df_Bus_group_elapsed_time_sub %>% 
  mutate(date_begin = paste(paste0("19", year_purchased), month_purchased, "1", sep = "-"),
         date_first = paste(paste0("19", year_of_1st_engine_replacement), month_of_1st_engine_replacement, "1", sep = "-"),
         date_second = paste(paste0("19", year_of_2nd_engine_replacement), month_of_2nd_engine_replacement, "1", sep = "-")) %>% 
  mutate(date_second = if_else(date_second == "190-0-1", "1900-1-1", date_second)) %>% # 2回目の交換をしてない場合、適当な日付にしておく。
  mutate(date_begin = as.Date(date_begin),
         date_first = as.Date(date_first),
         date_second = as.Date(date_second),
         elpased_time_diff_1 = date_first - date_begin,
         elpased_time_diff_2 = date_second - date_first) %>% 
  select(Bus_group, elpased_time_diff_1, elpased_time_diff_2)

df_Bus_group_elapsed_time_sub_stats <- 
  df_Bus_group_elapsed_time_sub %>% 
  pivot_longer(cols = -Bus_group, names_to = "when", values_to = "elapsed_time") %>% 
  mutate(elapsed_time = if_else(elapsed_time >= 0, elapsed_time/30, NaN)) %>% 
  group_by(Bus_group) %>% 
  summarise(Max_Elapsed_Time = floor(max(elapsed_time, na.rm = TRUE))%>% as.numeric(),
            Min_Elapsed_Time = ceiling(min(elapsed_time, na.rm = TRUE))%>% as.numeric(),
            Mean_Elapsed_Time = round(mean(elapsed_time, na.rm = TRUE), digits = 1)%>% as.numeric(),
            SD_Elapsed_Time = round(sd(elapsed_time, na.rm = TRUE), digits = 1)%>% as.numeric()) %>% 
  ungroup()

# full sample
## Mileage
df_Bus_group_mileage_full <- map_dfr(list_01_constructed_data, function(x){
  return(x %>% filter(month_of_1st_engine_replacement>0) %>% select(Bus_group, odometer_at_1st_replacement, odometer_at_2nd_replacement))})

df_Bus_group_mileage_full_stats <- 
  df_Bus_group_mileage_full %>% 
  mutate(odometer_at_2nd_replacement_diff = 
           if_else(odometer_at_2nd_replacement > odometer_at_1st_replacement, odometer_at_2nd_replacement - odometer_at_1st_replacement, 0)) %>% 
  select(-odometer_at_2nd_replacement) %>% 
  mutate(Bus_group = 0) %>% 
  pivot_longer(cols = -Bus_group, names_to = "when", values_to = "mileage") %>% 
  filter(mileage > 0) %>% 
  group_by(Bus_group) %>% 
  summarise(Max_Mileage = max(mileage), 
            Min_Mileage = min(mileage), 
            Mean_Mileage = round(mean(mileage)), 
            SD_Mileage = round(sd(mileage)),
            Number_of_Observations = n()) %>% 
  ungroup()
  
## Elapsed time
df_Bus_group_elapsed_time_full <- map_dfr(list_01_constructed_data, function(x){
  return(x %>% filter(month_of_1st_engine_replacement>0) %>% select(Bus_group, month_purchased, year_purchased, month_of_1st_engine_replacement, year_of_1st_engine_replacement, month_of_2nd_engine_replacement, year_of_2nd_engine_replacement))})

df_Bus_group_elapsed_time_full <- 
  df_Bus_group_elapsed_time_full %>% 
  mutate(date_begin = paste(paste0("19", year_purchased), month_purchased, "1", sep = "-"),
         date_first = paste(paste0("19", year_of_1st_engine_replacement), month_of_1st_engine_replacement, "1", sep = "-"),
         date_second = paste(paste0("19", year_of_2nd_engine_replacement), month_of_2nd_engine_replacement, "1", sep = "-")) %>% 
  mutate(date_second = if_else(date_second == "190-0-1", "1900-1-1", date_second)) %>% # 2回目の交換をしてない場合、適当な日付にしておく。
  mutate(date_begin = as.Date(date_begin),
         date_first = as.Date(date_first),
         date_second = as.Date(date_second),
         elpased_time_diff_1 = date_first - date_begin,
         elpased_time_diff_2 = date_second - date_first) %>% 
  select(Bus_group, elpased_time_diff_1, elpased_time_diff_2)

df_Bus_group_elapsed_time_full_stats <- 
  df_Bus_group_elapsed_time_full %>% 
  pivot_longer(cols = -Bus_group, names_to = "when", values_to = "elapsed_time") %>% 
  mutate(elapsed_time = if_else(elapsed_time >= 0, elapsed_time/30, NaN),
         Bus_group = 0) %>% 
  group_by(Bus_group) %>% 
  summarise(Max_Elapsed_Time = floor(max(elapsed_time, na.rm = TRUE))%>% as.numeric(),
            Min_Elapsed_Time = ceiling(min(elapsed_time, na.rm = TRUE))%>% as.numeric(),
            Mean_Elapsed_Time = round(mean(elapsed_time, na.rm = TRUE), digits = 1)%>% as.numeric(),
            SD_Elapsed_Time = round(sd(elapsed_time, na.rm = TRUE), digits = 1)%>% as.numeric()) %>% 
  ungroup()


# make a table
df_table_2_a <- 
  df_Bus_group_mileage_sub_stats %>% 
  left_join(df_Bus_group_elapsed_time_sub_stats, by = "Bus_group") %>% 
  rbind(c(1, rep(0, 9))) %>% 
  rbind(c(2, rep(0, 9))) %>% 
  arrange(Bus_group) %>% 
  bind_rows(left_join(df_Bus_group_mileage_full_stats, df_Bus_group_elapsed_time_full_stats, by = "Bus_group")) %>% 
  mutate(Bus_group = as.character(Bus_group)) %>% 
  mutate(Bus_group = if_else(Bus_group == "0", "Full Sample", Bus_group)) %>% 
  select(Bus_group, Max_Mileage, Min_Mileage, Mean_Mileage, SD_Mileage, Max_Elapsed_Time, Min_Elapsed_Time, Mean_Elapsed_Time, SD_Elapsed_Time, Number_of_Observations)


# Table 2b
# Subsample: buses for which no replacement occured
## Mileage
df_Bus_group_mileage_sub_no <- map_dfr(list_01_constructed_data, function(x){
  return(x %>% filter(month_of_1st_engine_replacement==0) %>% select(Bus_group, `odometer_reading_1985-05-01`))})

df_Bus_group_mileage_sub_no_stats <- 
  df_Bus_group_mileage_sub_no %>% 
  group_by(Bus_group) %>% 
  summarise(Max_Mileage = max(`odometer_reading_1985-05-01`), 
            Min_Mileage = min(`odometer_reading_1985-05-01`), 
            Mean_Mileage = round(mean(`odometer_reading_1985-05-01`)), 
            SD_Mileage = round(sd(`odometer_reading_1985-05-01`))) %>% 
  ungroup() %>% 
  replace_na(list(SD_Mileage = 0))

## Elapsed time
df_Bus_group_elapsed_time_sub_no <- map_dfr(list_01_constructed_data, function(x){
  return(x %>% filter(month_of_1st_engine_replacement==0) %>% select(Bus_group, month_purchased, year_purchased))})

df_Bus_group_elapsed_time_sub_no_stats <- 
  df_Bus_group_elapsed_time_sub_no %>% 
  mutate(date_purcased = paste(paste0("19",year_purchased ), month_purchased, "1", sep = "-"),
         elapsed_time = as.Date("1985-05-01") - as.Date(date_purcased)) %>% 
  group_by(Bus_group) %>% 
  summarise(Max_Elapsed_Time = max(floor(elapsed_time/30))%>% as.numeric(),
            Min_Elapsed_Time = min(floor(elapsed_time/30))%>% as.numeric(),
            Mean_Elapsed_Time = round(mean(floor(elapsed_time/30)), digits = 1)%>% as.numeric(),
            SD_Elapsed_Time = round(sd(floor(elapsed_time/30)), digits = 2)%>% as.numeric(),
            Number_of_Observations = n()) %>% 
  ungroup()%>% 
  replace_na(list(SD_Elapsed_Time = 0))


# Full sample
df_Bus_group_mileage_full_no <- map_dfr(list_01_constructed_data, function(x){
  return(x %>% filter(month_of_1st_engine_replacement==0) %>% select(Bus_group, `odometer_reading_1985-05-01`))})

df_Bus_group_mileage_full_no_stats <- 
  df_Bus_group_mileage_full_no %>% 
  mutate(Bus_group = 0) %>% 
  group_by(Bus_group) %>% 
  summarise(Max_Mileage = max(`odometer_reading_1985-05-01`), 
            Min_Mileage = min(`odometer_reading_1985-05-01`), 
            Mean_Mileage = round(mean(`odometer_reading_1985-05-01`)), 
            SD_Mileage = round(sd(`odometer_reading_1985-05-01`))) %>% 
  ungroup()


## Elapsed time
df_Bus_group_elapsed_time_full_no <- map_dfr(list_01_constructed_data, function(x){
  return(x %>% filter(month_of_1st_engine_replacement==0) %>% select(Bus_group, month_purchased, year_purchased))})

df_Bus_group_elapsed_time_full_no_stats <- 
  df_Bus_group_elapsed_time_full_no %>% 
  mutate(date_purcased = paste(paste0("19",year_purchased ), month_purchased, "1", sep = "-"),
         elapsed_time = as.Date("1985-05-01") - as.Date(date_purcased)) %>% 
  mutate(Bus_group = 0) %>% 
  group_by(Bus_group) %>% 
  summarise(Max_Elapsed_Time = max(floor(elapsed_time/30)) %>% as.numeric(),
            Min_Elapsed_Time = min(floor(elapsed_time/30))%>% as.numeric(),
            Mean_Elapsed_Time = round(mean(floor(elapsed_time/30)), digits = 1)%>% as.numeric(),
            SD_Elapsed_Time = round(sd(floor(elapsed_time/30)), digits = 2)%>% as.numeric(),
            Number_of_Observations = n()) %>% 
  ungroup()

# made a table
df_table_2_b <- 
  df_Bus_group_mileage_sub_no_stats %>% 
  left_join(df_Bus_group_elapsed_time_sub_no_stats, by = "Bus_group") %>% 
  rbind(c(7, rep(0, 9))) %>% 
  rbind(c(8, rep(0, 9))) %>% 
  bind_rows(left_join(df_Bus_group_mileage_full_no_stats, df_Bus_group_elapsed_time_full_no_stats, by = "Bus_group")) %>% 
  mutate(Bus_group = as.character(Bus_group)) %>% 
  mutate(Bus_group = if_else(Bus_group == "0", "Full Sample", Bus_group))



# Figure 1
df_replace_f1_mileage <- 
  df_Bus_group_mileage_sub %>% 
  filter(mileage > 0) %>% 
  select(-when)

df_replace_f1_elapsed_time <- 
  df_Bus_group_elapsed_time_sub %>% 
  pivot_longer(cols = -Bus_group,names_to = "when", values_to = "elapsed_time") %>% 
  filter(elapsed_time > 0) %>% 
  mutate(elapsed_time = elapsed_time/30)
  select(-c("Bus_group", "when"))
  
df_replace_f1 <- 
  df_replace_f1_mileage %>% 
  bind_cols(df_replace_f1_elapsed_time) %>% 
  mutate(type = "replace")
  
df_keep_f1 <- map_dfr(list_01_constructed_data, function(x){
  return(x %>% select(Bus_group, odometer_at_1st_replacement, odometer_at_2nd_replacement, `odometer_reading_1985-05-01`, month_purchased, year_purchased, month_of_1st_engine_replacement, year_of_1st_engine_replacement, month_of_2nd_engine_replacement, year_of_2nd_engine_replacement))})
  
df_keep_f1 <- 
  df_keep_f1 %>% 
  mutate(odometer_max = if_else(odometer_at_2nd_replacement > 0, odometer_at_2nd_replacement, odometer_at_1st_replacement)) %>% 
  mutate(date_begin = paste(paste0("19", year_purchased), month_purchased, "1", sep = "-"),
         date_first = paste(paste0("19", year_of_1st_engine_replacement), month_of_1st_engine_replacement, "1", sep = "-"),
         date_second = paste(paste0("19", year_of_2nd_engine_replacement), month_of_2nd_engine_replacement, "1", sep = "-")) %>% 
  mutate(date_first = if_else(date_first == "190-0-1", "1900-1-1", date_first),
         date_second = if_else(date_second == "190-0-1", "1900-1-1", date_second)) %>% 
  mutate(date_max = case_when(
    date_first == "1900-1-1" & date_second == "1900-1-1" ~ date_begin,
    date_first != "1900-1-1" & date_second == "1900-1-1" ~ date_first,
    TRUE ~ date_second
  )) %>% 
  mutate(mileage = `odometer_reading_1985-05-01`-odometer_max,
         elapsed_time = (as.Date("1985-05-01") - as.Date(date_max))/30) %>% 
  select(Bus_group, mileage, elapsed_time) %>% 
  mutate(type = "keep")
  
df_f1 <- df_replace_f1 %>% 
  bind_rows(df_keep_f1)

# save output as rds
list_02_table_figure_data <- list(
  table_2_a = df_table_2_a,
  table_2_b = df_table_2_b,
  figure_1 = df_f1
)

saveRDS(list_02_table_figure_data, "./intermediate/list_02_table_figure_data.rds")






            