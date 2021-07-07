# objective: Estimate first stage and replicate Table 4, 5 in Rust 1987



# install packages
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("Rsolnp")) install.packages("Rsolnp")
library(tidyverse)
library(Rsolnp)


# read data
list_01_constructed_data <- readRDS("./intermediate/list_01_constructed_data.rds")


# Group 1
df_group_1_estimation_first <- 
  list_01_constructed_data$group1 %>% 
  select(bus_number, starts_with("odometer_reading_")) %>% 
  pivot_longer(cols = -bus_number, names_to = "date", values_to = "mileage") %>% 
  mutate(date = str_replace(date, pattern = "odometer_reading_", replacement = "") %>% lubridate::as_date()) %>% 
  group_by(bus_number) %>% 
  mutate(t = row_number(), # t期
         mileage_lag = lag(mileage),
         mileage_diff = mileage - mileage_lag) %>% 
  ungroup() %>% 
  select(-mileage_lag) %>% 
  mutate(mileage_diff_discrete = case_when(
    mileage_diff < 5000 ~ 0,
    mileage_diff >= 5000 & mileage_diff < 10000 ~ 1,
    mileage_diff >= 10000 ~ 2
  ))



# Estimate parameters of transition probability
df_group_1_estimation_first %>% pull(mileage_diff_discrete) %>% table()
# 0: 276, 1: 84, 2: 0
theta_3_init <- c(0.197, 0.789, 0.014)
n <- 360

# log of likelihood
loglikelihood <- function(theta_3){ 
  return(-(log(prod((276+1):360)) - log(factorial(84)) - log(factorial(0)) + 276*log(theta_3[1]) + 84*log(theta_3[2]) + 0*log(theta_3[3])))
}

loglikelihood(theta_3_init)

# constraint 
constraint_prob <- function(theta_3){
  return(sum(theta_3))
}

# estiamte -> 結果が合わない
theta_3_estimated <- solnp(theta_3_init, fun = loglikelihood, eqfun = constraint_prob, eqB = 1, LB = c(0, 0, 0), UB = c(1, 1, 1))



# inverse


# 0: 276, 1: 84, 2: 0
theta_3_init <- c(0.197, 0.789, 0.014)
size_init <- c(45, 0, 0)

# log of likelihood
loglikelihood_check <- function(theta_3, size){ 
  return(log(prod((size[1]+1):sum(size))) - log(factorial(size[2])) - log(factorial(size[3])) + size[1]*log(theta_3[1]) + size[2]*log(theta_3[2]) + size[3]*log(theta_3[3]))
}

loglikelihood_check(theta_3_init, size_init)















