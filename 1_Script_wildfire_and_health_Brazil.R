

########################### Script for the Wildfire paper in Brazil (Wildfire and health) ###################################
#############################################################################################################################


#######################################################
### Hospital admissions analysis ######################
#######################################################


### Part 1 - Organize and clean the health data
################################################

# Check the health outcome available in the health data (this is the health data in Brazil, specifically the "Hospital_admissions_SUS_2008_2018")
data <- read.csv("ETLSIH.ST_2008.csv", sep="\t", header = TRUE)
head(data)

unique(data$DIAG_PRINC)
library("plyr")
count(data$DIAG_PRINC=="J440")

# Loop over the  files (each file represents one year) and subset the dataset for the diseases that I will consider in the study
setwd("C:/Users/Weeberb/Desktop/Health_data/ETLSIH")
sep= "/"
Save_output = "C:/Users/Weeberb/Desktop/ETLSIH/edited"

fileNames = list.files()
for (fileName in fileNames) {
  
  # Open the data
  data <- read.csv(fileName, sep="\t", header = TRUE)
  
  # Subset the dataset for the diseases that I will consider in the study (Respiratory = J00-J99; Circulatory = I00-I99)
  newdata <- data[data$DIAG_PRINC %like% "J" | data$DIAG_PRINC %like% "I" , ]    
  
  # Save the new files
  name <- paste0(Save_output, sep, fileName, "_cardiorespitatory", ".csv")
  write.csv(newdata, file=name)
  
  rm(newdata)
  print(paste(Sys.time(),fileName))
  
}

# Append multiple CSV files generated in the previous stage in order to have the whole period in a single file
library(data.table)
filenames <- list.files()
health_data_all_years <- rbindlist(lapply(filenames,fread))

# Save CSV file (this CSV file will be the subset file for this study)
Save_output_2 = "C:/Users/Weeberb/Google Drive/Documents/2- Career/5_Fundacao Getulio Vargas/7_Papers/4_Wildfire and health in Brazil/Statistical analysis/2_Input_data_subset_for_this_study/"
name_2 <- paste0(Save_output_2, "Admissions_cardiorespiratory_2008_2018", ".csv")
write.csv(health_data_all_years, file=name_2)


# Run this line below if I need to open the data "health_data_all_years" in a new R section
health_data_all_years <- read.csv("Admissions_cardiorespiratory_2008_2018.csv")



### Part 2 - Organize and clean the wildfire and covariates data (this is the data downloaded from SISAM)
##########################################################################################################
library(plyr)

setwd("C:/Users/Weeberb/Desktop/queimadas/")

# Loop over the wildfire and covariate files
fileNames = list.files(recursive = TRUE)
for (fileName in fileNames) {
  
  # Open the data
  data_wildfire_covariates <- read.csv(fileName, header = TRUE)
  
  # Extract Date, Year, Month, Day, and Hour into different columns
  data_wildfire_covariates$Date <- as.Date(data_wildfire_covariates$datahora)
  data_wildfire_covariates$Year <- lubridate::year(data_wildfire_covariates$datahora)
  data_wildfire_covariates$Month <- lubridate::month(data_wildfire_covariates$datahora)
  data_wildfire_covariates$Day <- lubridate::day(data_wildfire_covariates$datahora)
  data_wildfire_covariates$Hour <- lubridate::hour(data_wildfire_covariates$datahora)

  # Aggregate by Date (daily average)
  data_wildfire_covariates_daily <- ddply(data_wildfire_covariates, c("Date", "mun_geocod", "mun_nome", "mun_lat", "mun_lon", "mun_uf_nome", "Year", "Month", "Day"), summarise,
                co_ppb = mean(co_ppb, na.rm=TRUE),
                no2_ppb = mean(no2_ppb, na.rm=TRUE),
                o3_ppb = mean(o3_ppb, na.rm=TRUE),
                pm25_ugm3 = mean(pm25_ugm3, na.rm=TRUE),
                so2_ugm3 = mean(so2_ugm3, na.rm=TRUE),
                precipitacao_mmdia = mean(precipitacao_mmdia, na.rm=TRUE),
                temperatura_c = mean(temperatura_c, na.rm=TRUE),
                umidade_relativa_percentual = mean(umidade_relativa_percentual, na.rm=TRUE),
                vento_direcao_grau = mean(vento_direcao_grau, na.rm=TRUE),
                vento_velocidade_ms = mean(vento_velocidade_ms, na.rm=TRUE),
                focos_queimada = mean(focos_queimada, na.rm=TRUE))
  
  # Save the new files
  name <- paste0(fileName, "_edited", ".csv")
  write.csv(data_wildfire_covariates_daily, file=name)
  
  rm(data_wildfire_covariates)
  rm(data_wildfire_covariates_daily)
  
  print(paste(Sys.time(),fileName))
  
}
               

# Append multiple CSV files generated in the previous stage in order to have the whole period for each state in a single RDS file
library(data.table)
{
setwd("C:/Users/Weeberb/Desktop/queimadas/11/")
filenames <- list.files(pattern = "_edited")
wildfire_and_predictors_data_all_years <- rbindlist(lapply(filenames,fread))
saveRDS(wildfire_and_predictors_data_all_years, file="all_11.rds")

setwd("C:/Users/Weeberb/Desktop/queimadas/12/")
filenames <- list.files(pattern = "_edited")
wildfire_and_predictors_data_all_years <- rbindlist(lapply(filenames,fread))
saveRDS(wildfire_and_predictors_data_all_years, file="all_12.rds")

setwd("C:/Users/Weeberb/Desktop/queimadas/13/")
filenames <- list.files(pattern = "_edited")
wildfire_and_predictors_data_all_years <- rbindlist(lapply(filenames,fread))
saveRDS(wildfire_and_predictors_data_all_years, file="all_13.rds")

setwd("C:/Users/Weeberb/Desktop/queimadas/14/")
filenames <- list.files(pattern = "_edited")
wildfire_and_predictors_data_all_years <- rbindlist(lapply(filenames,fread))
saveRDS(wildfire_and_predictors_data_all_years, file="all_14.rds")

setwd("C:/Users/Weeberb/Desktop/queimadas/15/")
filenames <- list.files(pattern = "_edited")
wildfire_and_predictors_data_all_years <- rbindlist(lapply(filenames,fread))
saveRDS(wildfire_and_predictors_data_all_years, file="all_15.rds")

setwd("C:/Users/Weeberb/Desktop/queimadas/16/")
filenames <- list.files(pattern = "_edited")
wildfire_and_predictors_data_all_years <- rbindlist(lapply(filenames,fread))
saveRDS(wildfire_and_predictors_data_all_years, file="all_16.rds")

setwd("C:/Users/Weeberb/Desktop/queimadas/17/")
filenames <- list.files(pattern = "_edited")
wildfire_and_predictors_data_all_years <- rbindlist(lapply(filenames,fread))
saveRDS(wildfire_and_predictors_data_all_years, file="all_17.rds")

setwd("C:/Users/Weeberb/Desktop/queimadas/21/")
filenames <- list.files(pattern = "_edited")
wildfire_and_predictors_data_all_years <- rbindlist(lapply(filenames,fread))
saveRDS(wildfire_and_predictors_data_all_years, file="all_21.rds")

setwd("C:/Users/Weeberb/Desktop/queimadas/22/")
filenames <- list.files(pattern = "_edited")
wildfire_and_predictors_data_all_years <- rbindlist(lapply(filenames,fread))
saveRDS(wildfire_and_predictors_data_all_years, file="all_22.rds")

setwd("C:/Users/Weeberb/Desktop/queimadas/23/")
filenames <- list.files(pattern = "_edited")
wildfire_and_predictors_data_all_years <- rbindlist(lapply(filenames,fread))
saveRDS(wildfire_and_predictors_data_all_years, file="all_23.rds")

setwd("C:/Users/Weeberb/Desktop/queimadas/24/")
filenames <- list.files(pattern = "_edited")
wildfire_and_predictors_data_all_years <- rbindlist(lapply(filenames,fread))
saveRDS(wildfire_and_predictors_data_all_years, file="all_24.rds")

setwd("C:/Users/Weeberb/Desktop/queimadas/25/")
filenames <- list.files(pattern = "_edited")
wildfire_and_predictors_data_all_years <- rbindlist(lapply(filenames,fread))
saveRDS(wildfire_and_predictors_data_all_years, file="all_25.rds")

setwd("C:/Users/Weeberb/Desktop/queimadas/51/")
filenames <- list.files(pattern = "_edited")
wildfire_and_predictors_data_all_years <- rbindlist(lapply(filenames,fread))
saveRDS(wildfire_and_predictors_data_all_years, file="all_51.rds")

setwd("C:/Users/Weeberb/Desktop/queimadas/26/")
filenames <- list.files(pattern = "_edited")
wildfire_and_predictors_data_all_years <- rbindlist(lapply(filenames,fread))
saveRDS(wildfire_and_predictors_data_all_years, file="all_26.rds")

setwd("C:/Users/Weeberb/Desktop/queimadas/27/")
filenames <- list.files(pattern = "_edited")
wildfire_and_predictors_data_all_years <- rbindlist(lapply(filenames,fread))
saveRDS(wildfire_and_predictors_data_all_years, file="all_27.rds")

setwd("C:/Users/Weeberb/Desktop/queimadas/28/")
filenames <- list.files(pattern = "_edited")
wildfire_and_predictors_data_all_years <- rbindlist(lapply(filenames,fread))
saveRDS(wildfire_and_predictors_data_all_years, file="all_28.rds")

setwd("C:/Users/Weeberb/Desktop/queimadas/29/")
filenames <- list.files(pattern = "_edited")
wildfire_and_predictors_data_all_years <- rbindlist(lapply(filenames,fread))
saveRDS(wildfire_and_predictors_data_all_years, file="all_29.rds")

setwd("C:/Users/Weeberb/Desktop/queimadas/31/")
filenames <- list.files(pattern = "_edited")
wildfire_and_predictors_data_all_years <- rbindlist(lapply(filenames,fread))
saveRDS(wildfire_and_predictors_data_all_years, file="all_31.rds")

setwd("C:/Users/Weeberb/Desktop/queimadas/32/")
filenames <- list.files(pattern = "_edited")
wildfire_and_predictors_data_all_years <- rbindlist(lapply(filenames,fread))
saveRDS(wildfire_and_predictors_data_all_years, file="all_32.rds")

setwd("C:/Users/Weeberb/Desktop/queimadas/33/")
filenames <- list.files(pattern = "_edited")
wildfire_and_predictors_data_all_years <- rbindlist(lapply(filenames,fread))
saveRDS(wildfire_and_predictors_data_all_years, file="all_33.rds")

setwd("C:/Users/Weeberb/Desktop/queimadas/35/")
filenames <- list.files(pattern = "_edited")
wildfire_and_predictors_data_all_years <- rbindlist(lapply(filenames,fread))
saveRDS(wildfire_and_predictors_data_all_years, file="all_35.rds")

setwd("C:/Users/Weeberb/Desktop/queimadas/41/")
filenames <- list.files(pattern = "_edited")
wildfire_and_predictors_data_all_years <- rbindlist(lapply(filenames,fread))
saveRDS(wildfire_and_predictors_data_all_years, file="all_41.rds")

setwd("C:/Users/Weeberb/Desktop/queimadas/42/")
filenames <- list.files(pattern = "_edited")
wildfire_and_predictors_data_all_years <- rbindlist(lapply(filenames,fread))
saveRDS(wildfire_and_predictors_data_all_years, file="all_42.rds")

setwd("C:/Users/Weeberb/Desktop/queimadas/43/")
filenames <- list.files(pattern = "_edited")
wildfire_and_predictors_data_all_years <- rbindlist(lapply(filenames,fread))
saveRDS(wildfire_and_predictors_data_all_years, file="all_43.rds")

setwd("C:/Users/Weeberb/Desktop/queimadas/50/")
filenames <- list.files(pattern = "_edited")
wildfire_and_predictors_data_all_years <- rbindlist(lapply(filenames,fread))
saveRDS(wildfire_and_predictors_data_all_years, file="all_50.rds")

setwd("C:/Users/Weeberb/Desktop/queimadas/51/")
filenames <- list.files(pattern = "_edited")
wildfire_and_predictors_data_all_years <- rbindlist(lapply(filenames,fread))
saveRDS(wildfire_and_predictors_data_all_years, file="all_51.rds")

setwd("C:/Users/Weeberb/Desktop/queimadas/52/")
filenames <- list.files(pattern = "_edited")
wildfire_and_predictors_data_all_years <- rbindlist(lapply(filenames,fread))
saveRDS(wildfire_and_predictors_data_all_years, file="all_52.rds")

setwd("C:/Users/Weeberb/Desktop/queimadas/53/")
filenames <- list.files(pattern = "_edited")
wildfire_and_predictors_data_all_years <- rbindlist(lapply(filenames,fread))
saveRDS(wildfire_and_predictors_data_all_years, file="all_53.rds")
}


# Create lags (1-5 days).
# The files created in this process are the files saved in the folder "Wildfires_covariates_by_state_2000_2018"
setwd("C:/Users/Weeberb/Desktop/queimadas/")
Save_output = "C:/Users/Weeberb/Desktop/queimadas/"

library(dplyr)

filenames <- list.files(recursive = TRUE, pattern = ".rds")
for (fileName in filenames) {
  
  # Open the data
  data_wildfire_covariates <- readRDS(fileName)
  
  # Create lags
  data_wildfire_covariates = data_wildfire_covariates %>% arrange(Date) %>% group_by(mun_geocod) %>% 
  mutate(Lag1_PM25 = lag(pm25_ugm3, 1)) %>%
  mutate(Lag2_PM25 = lag(pm25_ugm3, 2)) %>%
  mutate(Lag3_PM25 = lag(pm25_ugm3, 3)) %>%
  mutate(Lag4_PM25 = lag(pm25_ugm3, 4)) %>%
  mutate(Lag5_PM25 = lag(pm25_ugm3, 5)) %>%
  
  mutate(Lag1_CO = lag(co_ppb, 1)) %>%
  mutate(Lag2_CO = lag(co_ppb, 2)) %>%
  mutate(Lag3_CO = lag(co_ppb, 3)) %>%
  mutate(Lag4_CO = lag(co_ppb, 4)) %>%
  mutate(Lag5_CO = lag(co_ppb, 5)) %>%
  
  mutate(Lag1_NO2 = lag(no2_ppb, 1)) %>%
  mutate(Lag2_NO2 = lag(no2_ppb, 2)) %>%
  mutate(Lag3_NO2 = lag(no2_ppb, 3)) %>%
  mutate(Lag4_NO2 = lag(no2_ppb, 4)) %>%
  mutate(Lag5_NO2 = lag(no2_ppb, 5)) %>%
  
  mutate(Lag1_SO2 = lag(so2_ugm3, 1)) %>%
  mutate(Lag2_SO2 = lag(so2_ugm3, 2)) %>%
  mutate(Lag3_SO2 = lag(so2_ugm3, 3)) %>%
  mutate(Lag4_SO2 = lag(so2_ugm3, 4)) %>%
  mutate(Lag5_SO2 = lag(so2_ugm3, 5)) %>%
    
  mutate(Lag1_O3 = lag(o3_ppb, 1)) %>%
  mutate(Lag2_O3 = lag(o3_ppb, 2)) %>%
  mutate(Lag3_O3 = lag(o3_ppb, 3)) %>%
  mutate(Lag4_O3 = lag(o3_ppb, 4)) %>%
  mutate(Lag5_O3 = lag(o3_ppb, 5)) %>%
  
  mutate(Lag1_Queimadas = lag(focos_queimada, 1)) %>%
  mutate(Lag2_Queimadas = lag(focos_queimada, 2)) %>%
  mutate(Lag3_Queimadas = lag(focos_queimada, 3)) %>%
  mutate(Lag4_Queimadas = lag(focos_queimada, 4)) %>%
  mutate(Lag5_Queimadas = lag(focos_queimada, 5)) %>%
  
  mutate(Lag1_Precipitacao = lag(precipitacao_mmdia, 1)) %>%
  mutate(Lag2_Precipitacao = lag(precipitacao_mmdia, 2)) %>%
  mutate(Lag3_Precipitacao = lag(precipitacao_mmdia, 3)) %>%
  mutate(Lag4_Precipitacao = lag(precipitacao_mmdia, 4)) %>%
  mutate(Lag5_Precipitacao = lag(precipitacao_mmdia, 5)) %>%
  
  mutate(Lag1_Temperature = lag(temperatura_c, 1)) %>%
  mutate(Lag2_Temperature = lag(temperatura_c, 2)) %>%
  mutate(Lag3_Temperature = lag(temperatura_c, 3)) %>%
  mutate(Lag4_Temperature = lag(temperatura_c, 4)) %>%
  mutate(Lag5_Temperature = lag(temperatura_c, 5)) %>%
  
  mutate(Lag1_Humidity = lag(umidade_relativa_percentual, 1)) %>%
  mutate(Lag2_Humidity = lag(umidade_relativa_percentual, 2)) %>%
  mutate(Lag3_Humidity = lag(umidade_relativa_percentual, 3)) %>%
  mutate(Lag4_Humidity = lag(umidade_relativa_percentual, 4)) %>%
  mutate(Lag5_Humidity = lag(umidade_relativa_percentual, 5)) %>%
  
  mutate(Lag1_Wind_direction = lag(vento_direcao_grau, 1)) %>%
  mutate(Lag2_Wind_direction = lag(vento_direcao_grau, 2)) %>%
  mutate(Lag3_Wind_direction = lag(vento_direcao_grau, 3)) %>%
  mutate(Lag4_Wind_direction = lag(vento_direcao_grau, 4)) %>%
  mutate(Lag5_Wind_direction = lag(vento_direcao_grau, 5)) %>%
  
  mutate(Lag1_Wind_speed = lag(vento_velocidade_ms, 1)) %>%
  mutate(Lag2_Wind_speed = lag(vento_velocidade_ms, 2)) %>%
  mutate(Lag3_Wind_speed = lag(vento_velocidade_ms, 3)) %>%
  mutate(Lag4_Wind_speed = lag(vento_velocidade_ms, 4)) %>%
  mutate(Lag5_Wind_speed = lag(vento_velocidade_ms, 5))
  
  data_wildfire_covariates <- as.data.frame(data_wildfire_covariates)
  
  # Save the new files
  # The files created in this process are the files saved in the folder "Wildfires_covariates_by_state_2000_2018"
  name <- paste0(Save_output, fileName, ".rds")
  saveRDS(data_wildfire_covariates, file=name)
  
  rm(data_wildfire_covariates)
  
  print(paste(Sys.time(),fileName))
  
}
  

# Loop over the  files created in the last step and subset the dataset for the period 2008-2018
setwd("C:/Users/Weeberb/Google Drive/Documents/2- Career/5_Fundacao Getulio Vargas/7_Papers/4_Wildfire and health in Brazil/Statistical analysis/2_Input_data_subset_for_this_study/Wildfires_covariates_by_state_2000_2018")
sep= "/"
Save_output = "C:/Users/Weeberb/Google Drive/Documents/2- Career/5_Fundacao Getulio Vargas/7_Papers/4_Wildfire and health in Brazil/Statistical analysis/2_Input_data_subset_for_this_study/Wildfires_covariates_by_state_2008_2018"

fileNames = list.files()
for (fileName in fileNames) {
  
  # Open the data
  data <- readRDS(fileName)
  
  # Subset the dataset for the period between 2008 and 2018
  newdata <- data[data$Year >= 2008 , ]    
  
  # Save the new files
  name <- paste0(Save_output, sep, fileName, "_2008_2018", ".rds")
  saveRDS(newdata, file=name)
  
  rm(newdata)
  print(paste(Sys.time(),fileName))
  
}



# Append the RDS files generated in the previous stage in order to have the whole period of the study (2008-2018) and and the whole states in a single RDS file
# This RDS file will be the predictor dataset file for this study
setwd("C:/Users/Weeberb/Google Drive/Documents/2- Career/5_Fundacao Getulio Vargas/7_Papers/4_Wildfire and health in Brazil/Statistical analysis/2_Input_data_subset_for_this_study/Wildfires_covariates_by_state_2008_2018/")
filenames <- list.files(pattern = ".rds")
wildfire_and_predictors_data_all_years_states <- lapply(filenames,readRDS)
saveRDS(wildfire_and_predictors_data_all_years_states, file="C:/Users/Weeberb/Google Drive/Documents/2- Career/5_Fundacao Getulio Vargas/7_Papers/4_Wildfire and health in Brazil/Statistical analysis/2_Input_data_subset_for_this_study/Wildfire_and_covariates.rds")


# Run this line below if I need to open the data "wildfire_and_predictors_data_all_years_states" in a new R section
setwd("C:/Users/Weeberb/Google Drive/Documents/2- Career/5_Fundacao Getulio Vargas/7_Papers/4_Wildfire and health in Brazil/Statistical analysis/2_Input_data_subset_for_this_study")
wildfire_and_predictors_data_all_years_states <- readRDS("Wildfire_and_covariates.rds")



### Part 3 - Merge health data with the wildfire and covariates
################################################################
library(data.table)
lstData <- Map(as.data.frame, wildfire_and_predictors_data_all_years_states)
wildfire_covariates <- rbindlist(lstData)
remove(lstData)
remove(wildfire_and_predictors_data_all_years_states)
gc()


health_data <- health_data_all_years
remove(health_data_all_years)


## Do the last edits in the health data before the merging
# Add a variable with 7-digits code (from IBGE) for the municipality. We will perform the merge using tis 7-digits code
code_7digits <- read.csv("Codigo_municipio_SixAndSeven_digits.csv")
health_data_2 <- merge(health_data, code_7digits, by="MUNIC_RES")
head(health_data_2)

# Extract Year, month, and day (of the hospital admission) into single columns 
health_data_2$Date <- as.Date(health_data_2$dt_inter)
health_data_2$Year <- lubridate::year(health_data_2$Date)
health_data_2$Month <- lubridate::month(health_data_2$Date)
health_data_2$Day <- lubridate::day(health_data_2$Date)

## Now, apply the merge --> health data and wildfire/covariates
health_data_2$Date <- as.character(health_data_2$Date)
library(dplyr)
final_data <- left_join(health_data_2, wildfire_covariates, by = c("CD_GEOCMU" = "mun_geocod", "Date" = "Date"), keep= TRUE)

remove(code_7digits, health_data, health_data_2, wildfire_covariates)

### Remove missing values in the predictors. This will remove observations that did not merge 
library(tidyr)
final_data_2 <- final_data %>% drop_na(co_ppb, no2_ppb, o3_ppb, pm25_ugm3, so2_ugm3, precipitacao_mmdia, temperatura_c, 
                                         umidade_relativa_percentual, vento_direcao_grau, vento_velocidade_ms)


# For the "focos_queimada" variable, replace NA values with zeros (this is because when there were no wildfires, for some reason it appears as NA)
final_data_2$focos_queimada[is.na(final_data_2$focos_queimada)] <- 0



### Part 4 - Finalize the data before statistical model - select predictors, remove missing values, and set additional variables
##################################################################################################################################

# Select variables for statistical analyses
myvars <- c("res_uf_CODIGO_UF", "mun_uf_nome", "res_uf_SIGLA_UF",                                # Location variables
            "MUNIC_RES", "CD_GEOCMU", "res_MUNNOMEX", "res_CAPITAL", "def_regiao_res",           # Location variables
            "res_LATITUDE", "res_LONGITUDE",                                                     # Coordinates
            "DIAG_PRINC", "QT_DIARIAS",                                                          # Health outcome 
            "DT_INTER", "dt_inter", "Year.x", "Month.x", "Day.x", "dia_semana_internacao",       # Temporal variables   
            "def_sexo", "IDADE", "INSTRU", "CBOR", "def_raca_cor",                               # SES variables  
            "co_ppb", "no2_ppb", "o3_ppb", "pm25_ugm3", "so2_ugm3",                              # Air pollution variables
            "precipitacao_mmdia", "temperatura_c", "umidade_relativa_percentual",                # Weather variables
            "vento_direcao_grau", "vento_velocidade_ms",                                         # Weather variables
            "focos_queimada",                                                                    # Wildfire variable
            "res_ALTITUDE",                                                                      # Geographical variable
            "Lag1_PM25", "Lag2_PM25", "Lag3_PM25", "Lag4_PM25", "Lag5_PM25",                                                     # Lag variables 
            "Lag1_CO", "Lag2_CO", "Lag3_CO", "Lag4_CO", "Lag5_CO",                                                               # Lag variables
            "Lag1_NO2", "Lag2_NO2", "Lag3_NO2", "Lag4_NO2", "Lag5_NO2",                                                          # Lag variables
            "Lag1_SO2", "Lag2_SO2", "Lag3_SO2", "Lag4_SO2", "Lag5_SO2",                                                          # Lag variables
            "Lag1_O3", "Lag2_O3", "Lag3_O3", "Lag4_O3", "Lag5_O3",                                                               # Lag variables
            "Lag1_Queimadas", "Lag2_Queimadas", "Lag3_Queimadas", "Lag4_Queimadas", "Lag5_Queimadas",                            # Lag variables
            "Lag1_Precipitacao", "Lag2_Precipitacao", "Lag3_Precipitacao", "Lag4_Precipitacao", "Lag5_Precipitacao",             # Lag variables
            "Lag1_Temperature", "Lag2_Temperature", "Lag3_Temperature", "Lag4_Temperature", "Lag5_Temperature",                  # Lag variables
            "Lag1_Humidity", "Lag2_Humidity", "Lag3_Humidity", "Lag4_Humidity", "Lag5_Humidity",                                 # Lag variables
            "Lag1_Wind_direction", "Lag2_Wind_direction", "Lag3_Wind_direction", "Lag4_Wind_direction", "Lag5_Wind_direction",   # Lag variables
            "Lag1_Wind_speed", "Lag2_Wind_speed", "Lag3_Wind_speed", "Lag4_Wind_speed", "Lag5_Wind_speed")                       # Lag variables                                                                      

final_data_3 <- final_data_2[myvars]


# Save this final file
saveRDS(final_data_3, file= "input_final.rds")

remove(final_data, final_data_2, myvars)
gc()

# Run this line below if I need to open the data "final_data_5" in a new R section
setwd("C:/Users/Weeberb/Google Drive/Documents/2- Career/5_Fundacao Getulio Vargas/7_Papers/4_Wildfire and health in Brazil/Statistical analysis/2_Input_data_subset_for_this_study")
final_data_3 <- readRDS("input_final.rds")



### Part 5 - Statistical analyses 
####################################

# Subset the dataset by region
library("plyr")
unique(final_data_3$def_regiao_res)

region = "Região Nordeste"                       ####### Change here, to specify the analysis for a specific region.

data_region <- final_data_3[which(final_data_3$def_regiao_res == region), ]    
unique(data_region$def_regiao_res)


# Health outcome - Select the options below 
#########################################################################
# OPTION 1
#outcome = "Cardiorespiratory Hospital Admissions"

# OPTION 2
library(data.table)
outcome = "Respiratory Hospital Admissions"
outcome_filter = "J"                
data_region <- final_data_3[final_data_3$DIAG_PRINC %like% outcome_filter, ]   
data_region <- data_region[which(data_region$def_regiao_res == region), ]

# OPTION 3
#library(data.table)
#outcome = "Circulatory Hospital Admissions"
#outcome_filter = "I"                
#data_region <- final_data_3[final_data_3$DIAG_PRINC %like% outcome_filter, ]   
#data_region <- data_region[which(data_region$def_regiao_res == region), ]
############################################################################

unique(data_region$def_regiao_res)
unique(data_region$DIAG_PRINC)

{
  
# Remove very extreme values
data_region <- subset(data_region, pm25_ugm3 < 300 & co_ppb < 500 & no2_ppb < 200 & o3_ppb < 200)

## Moving averages
# PM25 (1 day)
vars <- c("pm25_ugm3", "Lag1_PM25")
data_region$PM25_avg_1day <- rowMeans(data_region[ , vars], na.rm = TRUE)
# PM25 (2 days)
vars <- c("pm25_ugm3", "Lag1_PM25", "Lag2_PM25")
data_region$PM25_avg_2days <- rowMeans(data_region[ , vars], na.rm = TRUE)
# PM25 (3 days)
vars <- c("pm25_ugm3", "Lag1_PM25", "Lag2_PM25", "Lag3_PM25")
data_region$PM25_avg_3days <- rowMeans(data_region[ , vars], na.rm = TRUE)
# PM25 (4 days)
vars <- c("pm25_ugm3", "Lag1_PM25", "Lag2_PM25", "Lag3_PM25", "Lag4_PM25")
data_region$PM25_avg_4days <- rowMeans(data_region[ , vars], na.rm = TRUE)
# PM25 (5 days)
vars <- c("pm25_ugm3", "Lag1_PM25", "Lag2_PM25", "Lag3_PM25", "Lag4_PM25", "Lag5_PM25")
data_region$PM25_avg_5days <- rowMeans(data_region[ , vars], na.rm = TRUE)

# CO (1 day)
vars <- c("co_ppb", "Lag1_CO")
data_region$CO_avg_1day <- rowMeans(data_region[ , vars], na.rm = TRUE)
# CO (2 days)
vars <- c("co_ppb", "Lag1_CO", "Lag2_CO")
data_region$CO_avg_2days <- rowMeans(data_region[ , vars], na.rm = TRUE)
# CO (3 days)
vars <- c("co_ppb", "Lag1_CO", "Lag2_CO", "Lag3_CO")
data_region$CO_avg_3days <- rowMeans(data_region[ , vars], na.rm = TRUE)
# CO (4 days)
vars <- c("co_ppb", "Lag1_CO", "Lag2_CO", "Lag3_CO", "Lag4_CO")
data_region$CO_avg_4days <- rowMeans(data_region[ , vars], na.rm = TRUE)
# CO (5 days)
vars <- c("co_ppb", "Lag1_CO", "Lag2_CO", "Lag3_CO", "Lag4_CO", "Lag5_CO")
data_region$CO_avg_5days <- rowMeans(data_region[ , vars], na.rm = TRUE)

# NO2 (1 day)
vars <- c("no2_ppb", "Lag1_NO2")
data_region$NO2_avg_1day <- rowMeans(data_region[ , vars], na.rm = TRUE)
# NO2 (2 days)
vars <- c("no2_ppb", "Lag1_NO2", "Lag2_NO2")
data_region$NO2_avg_2days <- rowMeans(data_region[ , vars], na.rm = TRUE)
# NO2 (3 days)
vars <- c("no2_ppb", "Lag1_NO2", "Lag2_NO2", "Lag3_NO2")
data_region$NO2_avg_3days <- rowMeans(data_region[ , vars], na.rm = TRUE)
# NO2 (4 days)
vars <- c("no2_ppb", "Lag1_NO2", "Lag2_NO2", "Lag3_NO2", "Lag4_NO2")
data_region$NO2_avg_4days <- rowMeans(data_region[ , vars], na.rm = TRUE)
# NO2 (5 days)
vars <- c("no2_ppb", "Lag1_NO2", "Lag2_NO2", "Lag3_NO2", "Lag4_NO2", "Lag5_NO2")
data_region$NO2_avg_5days <- rowMeans(data_region[ , vars], na.rm = TRUE)

# O3 (1 day)
vars <- c("o3_ppb", "Lag1_O3")
data_region$O3_avg_1day <- rowMeans(data_region[ , vars], na.rm = TRUE)
# O3 (2 days)
vars <- c("o3_ppb", "Lag1_O3", "Lag2_O3")
data_region$O3_avg_2days <- rowMeans(data_region[ , vars], na.rm = TRUE)
# O3 (3 days)
vars <- c("o3_ppb", "Lag1_O3", "Lag2_O3", "Lag3_O3")
data_region$O3_avg_3days <- rowMeans(data_region[ , vars], na.rm = TRUE)
# O3 (4 days)
vars <- c("o3_ppb", "Lag1_O3", "Lag2_O3", "Lag3_O3", "Lag4_O3")
data_region$O3_avg_4days <- rowMeans(data_region[ , vars], na.rm = TRUE)
# O3 (5 days)
vars <- c("o3_ppb", "Lag1_O3", "Lag2_O3", "Lag3_O3", "Lag4_O3", "Lag5_O3")
data_region$O3_avg_5days <- rowMeans(data_region[ , vars], na.rm = TRUE)

# Temperature (1 day)
vars <- c("temperatura_c", "Lag1_Temperature")
data_region$Temperature_avg_1day <- rowMeans(data_region[ , vars], na.rm = TRUE)
# Temperature (2 days)
vars <- c("temperatura_c", "Lag1_Temperature", "Lag2_Temperature")
data_region$Temperature_avg_2days <- rowMeans(data_region[ , vars], na.rm = TRUE)
# Temperature (3 days)
vars <- c("temperatura_c", "Lag1_Temperature", "Lag2_Temperature", "Lag3_Temperature")
data_region$Temperature_avg_3days <- rowMeans(data_region[ , vars], na.rm = TRUE)
# Temperature (4 days)
vars <- c("temperatura_c", "Lag1_Temperature", "Lag2_Temperature", "Lag3_Temperature", "Lag4_Temperature")
data_region$Temperature_avg_4days <- rowMeans(data_region[ , vars], na.rm = TRUE)
# Temperature (5 days)
vars <- c("temperatura_c", "Lag1_Temperature", "Lag2_Temperature", "Lag3_Temperature", "Lag4_Temperature", "Lag5_Temperature")
data_region$Temperature_avg_5days <- rowMeans(data_region[ , vars], na.rm = TRUE)

# Humidity (1 day)
vars <- c("umidade_relativa_percentual", "Lag1_Humidity")
data_region$Humidity_avg_1day <- rowMeans(data_region[ , vars], na.rm = TRUE)
# Humidity (2 days)
vars <- c("umidade_relativa_percentual", "Lag1_Humidity", "Lag2_Humidity")
data_region$Humidity_avg_2days <- rowMeans(data_region[ , vars], na.rm = TRUE)
# Humidity (3 days)
vars <- c("umidade_relativa_percentual", "Lag1_Humidity", "Lag2_Humidity", "Lag3_Humidity")
data_region$Humidity_avg_3days <- rowMeans(data_region[ , vars], na.rm = TRUE)
# Humidity (4 days)
vars <- c("umidade_relativa_percentual", "Lag1_Humidity", "Lag2_Humidity", "Lag3_Humidity", "Lag4_Humidity")
data_region$Humidity_avg_4days <- rowMeans(data_region[ , vars], na.rm = TRUE)
# Humidity (5 days)
vars <- c("umidade_relativa_percentual", "Lag1_Humidity", "Lag2_Humidity", "Lag3_Humidity", "Lag4_Humidity", "Lag5_Humidity")
data_region$Humidity_avg_5days <- rowMeans(data_region[ , vars], na.rm = TRUE)

# Wind_direction (1 day)
vars <- c("vento_direcao_grau", "Lag1_Wind_direction")
data_region$Wind_direction_avg_1day <- rowMeans(data_region[ , vars], na.rm = TRUE)
# Wind_direction (2 days)
vars <- c("vento_direcao_grau", "Lag1_Wind_direction", "Lag2_Wind_direction")
data_region$Wind_direction_avg_2days <- rowMeans(data_region[ , vars], na.rm = TRUE)
# Wind_direction (3 days)
vars <- c("vento_direcao_grau", "Lag1_Wind_direction", "Lag2_Wind_direction", "Lag3_Wind_direction")
data_region$Wind_direction_avg_3days <- rowMeans(data_region[ , vars], na.rm = TRUE)
# Wind_direction (4 days)
vars <- c("vento_direcao_grau", "Lag1_Wind_direction", "Lag2_Wind_direction", "Lag3_Wind_direction", "Lag4_Wind_direction")
data_region$Wind_direction_avg_4days <- rowMeans(data_region[ , vars], na.rm = TRUE)
# Wind_direction (5 days)
vars <- c("vento_direcao_grau", "Lag1_Wind_direction", "Lag2_Wind_direction", "Lag3_Wind_direction", "Lag4_Wind_direction", "Lag5_Wind_direction")
data_region$Wind_direction_avg_5days <- rowMeans(data_region[ , vars], na.rm = TRUE)

# Wind_speed (1 day)
vars <- c("vento_velocidade_ms", "Lag1_Wind_speed")
data_region$Wind_speed_avg_1day <- rowMeans(data_region[ , vars], na.rm = TRUE)
# Wind_speed (2 days)
vars <- c("vento_velocidade_ms", "Lag1_Wind_speed", "Lag2_Wind_speed")
data_region$Wind_speed_avg_2days <- rowMeans(data_region[ , vars], na.rm = TRUE)
# Wind_speed (3 days)
vars <- c("vento_velocidade_ms", "Lag1_Wind_speed", "Lag2_Wind_speed", "Lag3_Wind_speed")
data_region$Wind_speed_avg_3days <- rowMeans(data_region[ , vars], na.rm = TRUE)
# Wind_speed (4 days)
vars <- c("vento_velocidade_ms", "Lag1_Wind_speed", "Lag2_Wind_speed", "Lag3_Wind_speed", "Lag4_Wind_speed")
data_region$Wind_speed_avg_4days <- rowMeans(data_region[ , vars], na.rm = TRUE)
# Wind_speed (5 days)
vars <- c("vento_velocidade_ms", "Lag1_Wind_speed", "Lag2_Wind_speed", "Lag3_Wind_speed", "Lag4_Wind_speed", "Lag5_Wind_speed")
data_region$Wind_speed_avg_5days <- rowMeans(data_region[ , vars], na.rm = TRUE)

# Precipitacao (1 day)
vars <- c("precipitacao_mmdia", "Lag1_Precipitacao")
data_region$Precipitacao_avg_1day <- rowMeans(data_region[ , vars], na.rm = TRUE)
# Precipitacao (2 days)
vars <- c("precipitacao_mmdia", "Lag1_Precipitacao", "Lag2_Precipitacao")
data_region$Precipitacao_avg_2days <- rowMeans(data_region[ , vars], na.rm = TRUE)
# Precipitacao (3 days)
vars <- c("precipitacao_mmdia", "Lag1_Precipitacao", "Lag2_Precipitacao", "Lag3_Precipitacao")
data_region$Precipitacao_avg_3days <- rowMeans(data_region[ , vars], na.rm = TRUE)
# Precipitacao (4 days)
vars <- c("precipitacao_mmdia", "Lag1_Precipitacao", "Lag2_Precipitacao", "Lag3_Precipitacao", "Lag4_Precipitacao")
data_region$Precipitacao_avg_4days <- rowMeans(data_region[ , vars], na.rm = TRUE)
# Precipitacao (5 days)
vars <- c("precipitacao_mmdia", "Lag1_Precipitacao", "Lag2_Precipitacao", "Lag3_Precipitacao", "Lag4_Precipitacao", "Lag5_Precipitacao")
data_region$Precipitacao_avg_5days <- rowMeans(data_region[ , vars], na.rm = TRUE)

# Queimadas (1 day)
vars <- c("focos_queimada", "Lag1_Queimadas")
data_region$Queimadas_avg_1day <- rowSums(data_region[ , vars], na.rm = TRUE)
# Queimadas (2 days)
vars <- c("focos_queimada", "Lag1_Queimadas", "Lag2_Queimadas")
data_region$Queimadas_avg_2days <- rowSums(data_region[ , vars], na.rm = TRUE)
# Queimadas (3 days)
vars <- c("focos_queimada", "Lag1_Queimadas", "Lag2_Queimadas", "Lag3_Queimadas")
data_region$Queimadas_avg_3days <- rowSums(data_region[ , vars], na.rm = TRUE)
# Queimadas (4 days)
vars <- c("focos_queimada", "Lag1_Queimadas", "Lag2_Queimadas", "Lag3_Queimadas", "Lag4_Queimadas")
data_region$Queimadas_avg_4days <- rowSums(data_region[ , vars], na.rm = TRUE)
# Queimadas (5 days)
vars <- c("focos_queimada", "Lag1_Queimadas", "Lag2_Queimadas", "Lag3_Queimadas", "Lag4_Queimadas", "Lag5_Queimadas")
data_region$Queimadas_avg_5days <- rowSums(data_region[ , vars], na.rm = TRUE)


# Remove very extreme values from moving average variables
data_region <- subset(data_region, PM25_avg_1day < 300 & PM25_avg_2days < 300 & PM25_avg_3days < 300 & PM25_avg_4days < 300 & PM25_avg_5days < 300 &
                        CO_avg_1day < 500 & CO_avg_2days < 500 & CO_avg_3days < 500 & CO_avg_4days < 500 & CO_avg_5days < 500 &
                        NO2_avg_1day < 200 & NO2_avg_2days < 200 & NO2_avg_3days < 200 & NO2_avg_4days < 200 & NO2_avg_5days < 200 &
                        O3_avg_1day < 200 & O3_avg_2days < 200 & O3_avg_3days < 200 & O3_avg_4days < 200 & O3_avg_5days < 200)

# Set the strata id
library(dplyr)
data_region <- data_region[order(data_region$DT_INTER),]
data_region$variable_indice_for_strata_id <- paste(data_region$dia_semana_internacao,"_",data_region$Month.x,"_",data_region$Year.x)
data_region$strata_id <- data_region %>% group_indices(variable_indice_for_strata_id)   # creating unique group IDs by day of week, month, and year.
data_region <- data_region[order(data_region$strata_id),]


### Primary model - 1-day moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_region$Queimadas_avg_1day, c(.99)))
quantile_PM = as.numeric(quantile(data_region$PM25_avg_1day, c(.99)))
data_region$case <- ifelse(data_region$Queimadas_avg_1day >= quantile_fire & data_region$PM25_avg_1day >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_region$case))

# Run the clogit model
library(survival)
model_clogit <- clogit(case ~ PM25_avg_1day +
                         CO_avg_1day + NO2_avg_1day + O3_avg_1day +
                         Temperature_avg_1day + Humidity_avg_1day +
                         Wind_direction_avg_1day + Wind_speed_avg_1day + Precipitacao_avg_1day + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_region)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results<-data.frame()
results.temp <- data.frame()

results.temp[1,1]<-region
results.temp[1,2]<-outcome
results.temp[1,3]<-"Primary analysis"
results.temp[1,4]<-"1-day moving average"
results.temp[1,5]<- case_control[1,2]
results.temp[1,6]<- case_control[2,2]
results.temp[1,7]<- beta
results.temp[1,8]<- lo95ci
results.temp[1,9]<- hi95ci 
results.temp[1,10]<- beta_perc
results.temp[1,11]<- lo95ci_perc
results.temp[1,12]<- hi95ci_perc


### Primary model - 2-days moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_region$Queimadas_avg_2days, c(.99)))
quantile_PM = as.numeric(quantile(data_region$PM25_avg_2days, c(.99)))
data_region$case <- ifelse(data_region$Queimadas_avg_2days >= quantile_fire & data_region$PM25_avg_2days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_region$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_2days +
                         CO_avg_2days + NO2_avg_2days + O3_avg_2days +
                         Temperature_avg_2days + Humidity_avg_2days +
                         Wind_direction_avg_2days + Wind_speed_avg_2days + Precipitacao_avg_2days + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_region)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[2,1]<-region
results.temp[2,2]<-outcome
results.temp[2,3]<-"Primary analysis"
results.temp[2,4]<-"2-days moving average"
results.temp[2,5]<- case_control[1,2]
results.temp[2,6]<- case_control[2,2]
results.temp[2,7]<- beta
results.temp[2,8]<- lo95ci
results.temp[2,9]<- hi95ci 
results.temp[2,10]<- beta_perc
results.temp[2,11]<- lo95ci_perc
results.temp[2,12]<- hi95ci_perc


### Primary model - 3-days moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_region$Queimadas_avg_3days, c(.99)))
quantile_PM = as.numeric(quantile(data_region$PM25_avg_3days, c(.99)))
data_region$case <- ifelse(data_region$Queimadas_avg_3days >= quantile_fire & data_region$PM25_avg_3days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_region$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_3days +
                         CO_avg_3days + NO2_avg_3days + O3_avg_3days +
                         Temperature_avg_3days + Humidity_avg_3days +
                         Wind_direction_avg_3days + Wind_speed_avg_3days + Precipitacao_avg_3days + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_region)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[3,1]<-region
results.temp[3,2]<-outcome
results.temp[3,3]<-"Primary analysis"
results.temp[3,4]<-"3-days moving average"
results.temp[3,5]<- case_control[1,2]
results.temp[3,6]<- case_control[2,2]
results.temp[3,7]<- beta
results.temp[3,8]<- lo95ci
results.temp[3,9]<- hi95ci 
results.temp[3,10]<- beta_perc
results.temp[3,11]<- lo95ci_perc
results.temp[3,12]<- hi95ci_perc


### Primary model - 4-days moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_region$Queimadas_avg_4days, c(.99)))
quantile_PM = as.numeric(quantile(data_region$PM25_avg_4days, c(.99)))
data_region$case <- ifelse(data_region$Queimadas_avg_4days >= quantile_fire & data_region$PM25_avg_4days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_region$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_4days +
                         CO_avg_4days + NO2_avg_4days + O3_avg_4days +
                         Temperature_avg_4days + Humidity_avg_4days +
                         Wind_direction_avg_4days + Wind_speed_avg_4days + Precipitacao_avg_4days + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_region)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[4,1]<-region
results.temp[4,2]<-outcome
results.temp[4,3]<-"Primary analysis"
results.temp[4,4]<-"4-days moving average"
results.temp[4,5]<- case_control[1,2]
results.temp[4,6]<- case_control[2,2]
results.temp[4,7]<- beta
results.temp[4,8]<- lo95ci
results.temp[4,9]<- hi95ci 
results.temp[4,10]<- beta_perc
results.temp[4,11]<- lo95ci_perc
results.temp[4,12]<- hi95ci_perc


### Primary model - 5-days moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_region$Queimadas_avg_5days, c(.99)))
quantile_PM = as.numeric(quantile(data_region$PM25_avg_5days, c(.99)))
data_region$case <- ifelse(data_region$Queimadas_avg_5days >= quantile_fire & data_region$PM25_avg_5days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_region$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_5days +
                         CO_avg_5days + NO2_avg_5days + O3_avg_5days +
                         Temperature_avg_5days + Humidity_avg_5days +
                         Wind_direction_avg_5days + Wind_speed_avg_5days + Precipitacao_avg_5days + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_region)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[5,1]<-region
results.temp[5,2]<-outcome
results.temp[5,3]<-"Primary analysis"
results.temp[5,4]<-"5-days moving average"
results.temp[5,5]<- case_control[1,2]
results.temp[5,6]<- case_control[2,2]
results.temp[5,7]<- beta
results.temp[5,8]<- lo95ci
results.temp[5,9]<- hi95ci 
results.temp[5,10]<- beta_perc
results.temp[5,11]<- lo95ci_perc
results.temp[5,12]<- hi95ci_perc



##################################################################


### Stratified by sex - Man - 1-day moving average
########################################

# Subset the dataset by sex
library("plyr")
unique(final_data_3$def_sexo)
sexo = "Masculino"     
data_sex <- data_region[which(data_region$def_sexo == sexo), ]    
unique(data_sex$def_sexo)

# Set the strata id
library(dplyr)
data_sex <- data_sex[order(data_sex$DT_INTER),]
data_sex$variable_indice_for_strata_id <- paste(data_sex$dia_semana_internacao,"_",data_sex$Month.x,"_",data_sex$Year.x)
data_sex$strata_id <- data_sex %>% group_indices(variable_indice_for_strata_id)   # creating unique group IDs by day of week, month, and year.
data_sex <- data_sex[order(data_sex$strata_id),]

# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_sex$Queimadas_avg_1day, c(.99)))
quantile_PM = as.numeric(quantile(data_sex$PM25_avg_1day, c(.99)))
data_sex$case <- ifelse(data_sex$Queimadas_avg_1day >= quantile_fire & data_sex$PM25_avg_1day >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_sex$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_1day +
                         CO_avg_1day + NO2_avg_1day + O3_avg_1day +
                         Temperature_avg_1day + Humidity_avg_1day +
                         Wind_direction_avg_1day + Wind_speed_avg_1day + Precipitacao_avg_1day + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_sex)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[6,1]<-region
results.temp[6,2]<-outcome
results.temp[6,3]<-"Stratified by sex - Man"
results.temp[6,4]<-"1-day moving average"
results.temp[6,5]<- case_control[1,2]
results.temp[6,6]<- case_control[2,2]
results.temp[6,7]<- beta
results.temp[6,8]<- lo95ci
results.temp[6,9]<- hi95ci 
results.temp[6,10]<- beta_perc
results.temp[6,11]<- lo95ci_perc
results.temp[6,12]<- hi95ci_perc


### Stratified by sex - Man - 2-days moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_sex$Queimadas_avg_2days, c(.99)))
quantile_PM = as.numeric(quantile(data_sex$PM25_avg_2days, c(.99)))
data_sex$case <- ifelse(data_sex$Queimadas_avg_2days >= quantile_fire & data_sex$PM25_avg_2days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_sex$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_2days +
                         CO_avg_2days + NO2_avg_2days + O3_avg_2days +
                         Temperature_avg_2days + Humidity_avg_2days +
                         Wind_direction_avg_2days + Wind_speed_avg_2days + Precipitacao_avg_2days + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_sex)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[7,1]<-region
results.temp[7,2]<-outcome
results.temp[7,3]<-"Stratified by sex - Man"
results.temp[7,4]<-"2-days moving average"
results.temp[7,5]<- case_control[1,2]
results.temp[7,6]<- case_control[2,2]
results.temp[7,7]<- beta
results.temp[7,8]<- lo95ci
results.temp[7,9]<- hi95ci 
results.temp[7,10]<- beta_perc
results.temp[7,11]<- lo95ci_perc
results.temp[7,12]<- hi95ci_perc


### Stratified by sex - Man - 3-days moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_sex$Queimadas_avg_3days, c(.99)))
quantile_PM = as.numeric(quantile(data_sex$PM25_avg_3days, c(.99)))
data_sex$case <- ifelse(data_sex$Queimadas_avg_3days >= quantile_fire & data_sex$PM25_avg_3days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_sex$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_3days +
                         CO_avg_3days + NO2_avg_3days + O3_avg_3days +
                         Temperature_avg_3days + Humidity_avg_3days +
                         Wind_direction_avg_3days + Wind_speed_avg_3days + Precipitacao_avg_3days + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_sex)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[8,1]<-region
results.temp[8,2]<-outcome
results.temp[8,3]<-"Stratified by sex - Man"
results.temp[8,4]<-"3-days moving average"
results.temp[8,5]<- case_control[1,2]
results.temp[8,6]<- case_control[2,2]
results.temp[8,7]<- beta
results.temp[8,8]<- lo95ci
results.temp[8,9]<- hi95ci 
results.temp[8,10]<- beta_perc
results.temp[8,11]<- lo95ci_perc
results.temp[8,12]<- hi95ci_perc


### Stratified by sex - Man - 4-days moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_sex$Queimadas_avg_4days, c(.99)))
quantile_PM = as.numeric(quantile(data_sex$PM25_avg_4days, c(.99)))
data_sex$case <- ifelse(data_sex$Queimadas_avg_4days >= quantile_fire & data_sex$PM25_avg_4days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_sex$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_4days +
                         CO_avg_4days + NO2_avg_4days + O3_avg_4days +
                         Temperature_avg_4days + Humidity_avg_4days +
                         Wind_direction_avg_4days + Wind_speed_avg_4days + Precipitacao_avg_4days + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_sex)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[9,1]<-region
results.temp[9,2]<-outcome
results.temp[9,3]<-"Stratified by sex - Man"
results.temp[9,4]<-"4-days moving average"
results.temp[9,5]<- case_control[1,2]
results.temp[9,6]<- case_control[2,2]
results.temp[9,7]<- beta
results.temp[9,8]<- lo95ci
results.temp[9,9]<- hi95ci 
results.temp[9,10]<- beta_perc
results.temp[9,11]<- lo95ci_perc
results.temp[9,12]<- hi95ci_perc


### Stratified by sex - Man - 5-days moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_sex$Queimadas_avg_5days, c(.99)))
quantile_PM = as.numeric(quantile(data_sex$PM25_avg_5days, c(.99)))
data_sex$case <- ifelse(data_sex$Queimadas_avg_5days >= quantile_fire & data_sex$PM25_avg_5days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_sex$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_5days +
                         CO_avg_5days + NO2_avg_5days + O3_avg_5days +
                         Temperature_avg_5days + Humidity_avg_5days +
                         Wind_direction_avg_5days + Wind_speed_avg_5days + Precipitacao_avg_5days + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_sex)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[10,1]<-region
results.temp[10,2]<-outcome
results.temp[10,3]<-"Stratified by sex - Man"
results.temp[10,4]<-"5-days moving average"
results.temp[10,5]<- case_control[1,2]
results.temp[10,6]<- case_control[2,2]
results.temp[10,7]<- beta
results.temp[10,8]<- lo95ci
results.temp[10,9]<- hi95ci 
results.temp[10,10]<- beta_perc
results.temp[10,11]<- lo95ci_perc
results.temp[10,12]<- hi95ci_perc


##################################################################


### Stratified by sex - Woman - 1-day moving average
########################################

# Subset the dataset by sex
library("plyr")
unique(final_data_3$def_sexo)
sexo = "Feminino"       
data_sex <- data_region[which(data_region$def_sexo == sexo), ]    
unique(data_sex$def_sexo)

# Set the strata id
library(dplyr)
data_sex <- data_sex[order(data_sex$DT_INTER),]
data_sex$variable_indice_for_strata_id <- paste(data_sex$dia_semana_internacao,"_",data_sex$Month.x,"_",data_sex$Year.x)
data_sex$strata_id <- data_sex %>% group_indices(variable_indice_for_strata_id)   # creating unique group IDs by day of week, month, and year.
data_sex <- data_sex[order(data_sex$strata_id),]

# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_sex$Queimadas_avg_1day, c(.99)))
quantile_PM = as.numeric(quantile(data_sex$PM25_avg_1day, c(.99)))
data_sex$case <- ifelse(data_sex$Queimadas_avg_1day >= quantile_fire & data_sex$PM25_avg_1day >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_sex$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_1day +
                         CO_avg_1day + NO2_avg_1day + O3_avg_1day +
                         Temperature_avg_1day + Humidity_avg_1day +
                         Wind_direction_avg_1day + Wind_speed_avg_1day + Precipitacao_avg_1day + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_sex)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[11,1]<-region
results.temp[11,2]<-outcome
results.temp[11,3]<-"Stratified by sex - Woman"
results.temp[11,4]<-"1-day moving average"
results.temp[11,5]<- case_control[1,2]
results.temp[11,6]<- case_control[2,2]
results.temp[11,7]<- beta
results.temp[11,8]<- lo95ci
results.temp[11,9]<- hi95ci 
results.temp[11,10]<- beta_perc
results.temp[11,11]<- lo95ci_perc
results.temp[11,12]<- hi95ci_perc


### Stratified by sex - Woman - 2-days moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_sex$Queimadas_avg_2days, c(.99)))
quantile_PM = as.numeric(quantile(data_sex$PM25_avg_2days, c(.99)))
data_sex$case <- ifelse(data_sex$Queimadas_avg_2days >= quantile_fire & data_sex$PM25_avg_2days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_sex$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_2days +
                         CO_avg_2days + NO2_avg_2days + O3_avg_2days +
                         Temperature_avg_2days + Humidity_avg_2days +
                         Wind_direction_avg_2days + Wind_speed_avg_2days + Precipitacao_avg_2days + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_sex)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[12,1]<-region
results.temp[12,2]<-outcome
results.temp[12,3]<-"Stratified by sex - Woman"
results.temp[12,4]<-"2-days moving average"
results.temp[12,5]<- case_control[1,2]
results.temp[12,6]<- case_control[2,2]
results.temp[12,7]<- beta
results.temp[12,8]<- lo95ci
results.temp[12,9]<- hi95ci 
results.temp[12,10]<- beta_perc
results.temp[12,11]<- lo95ci_perc
results.temp[12,12]<- hi95ci_perc


### Stratified by sex - Woman - 3-days moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_sex$Queimadas_avg_3days, c(.99)))
quantile_PM = as.numeric(quantile(data_sex$PM25_avg_3days, c(.99)))
data_sex$case <- ifelse(data_sex$Queimadas_avg_3days >= quantile_fire & data_sex$PM25_avg_3days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_sex$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_3days +
                         CO_avg_3days + NO2_avg_3days + O3_avg_3days +
                         Temperature_avg_3days + Humidity_avg_3days +
                         Wind_direction_avg_3days + Wind_speed_avg_3days + Precipitacao_avg_3days + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_sex)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[13,1]<-region
results.temp[13,2]<-outcome
results.temp[13,3]<-"Stratified by sex - Woman"
results.temp[13,4]<-"3-days moving average"
results.temp[13,5]<- case_control[1,2]
results.temp[13,6]<- case_control[2,2]
results.temp[13,7]<- beta
results.temp[13,8]<- lo95ci
results.temp[13,9]<- hi95ci 
results.temp[13,10]<- beta_perc
results.temp[13,11]<- lo95ci_perc
results.temp[13,12]<- hi95ci_perc


### Stratified by sex - Woman - 4-days moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_sex$Queimadas_avg_4days, c(.99)))
quantile_PM = as.numeric(quantile(data_sex$PM25_avg_4days, c(.99)))
data_sex$case <- ifelse(data_sex$Queimadas_avg_4days >= quantile_fire & data_sex$PM25_avg_4days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_sex$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_4days +
                         CO_avg_4days + NO2_avg_4days + O3_avg_4days +
                         Temperature_avg_4days + Humidity_avg_4days +
                         Wind_direction_avg_4days + Wind_speed_avg_4days + Precipitacao_avg_4days + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_sex)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[14,1]<-region
results.temp[14,2]<-outcome
results.temp[14,3]<-"Stratified by sex - Woman"
results.temp[14,4]<-"4-days moving average"
results.temp[14,5]<- case_control[1,2]
results.temp[14,6]<- case_control[2,2]
results.temp[14,7]<- beta
results.temp[14,8]<- lo95ci
results.temp[14,9]<- hi95ci 
results.temp[14,10]<- beta_perc
results.temp[14,11]<- lo95ci_perc
results.temp[14,12]<- hi95ci_perc


### Stratified by sex - Woman - 5-days moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_sex$Queimadas_avg_5days, c(.99)))
quantile_PM = as.numeric(quantile(data_sex$PM25_avg_5days, c(.99)))
data_sex$case <- ifelse(data_sex$Queimadas_avg_5days >= quantile_fire & data_sex$PM25_avg_5days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_sex$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_5days +
                         CO_avg_5days + NO2_avg_5days + O3_avg_5days +
                         Temperature_avg_5days + Humidity_avg_5days +
                         Wind_direction_avg_5days + Wind_speed_avg_5days + Precipitacao_avg_5days + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_sex)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[15,1]<-region
results.temp[15,2]<-outcome
results.temp[15,3]<-"Stratified by sex - Woman"
results.temp[15,4]<-"5-days moving average"
results.temp[15,5]<- case_control[1,2]
results.temp[15,6]<- case_control[2,2]
results.temp[15,7]<- beta
results.temp[15,8]<- lo95ci
results.temp[15,9]<- hi95ci 
results.temp[15,10]<- beta_perc
results.temp[15,11]<- lo95ci_perc
results.temp[15,12]<- hi95ci_perc



##################################################################


### Stratified by age (0-5 years old) - 1-day moving average
########################################

# Set age group
data_region$age_group <- ifelse(data_region$IDADE %in% 0:5, "yes", "no")

# Subset the dataset by age
data_age <- data_region[which(data_region$age_group == "yes"), ]    
unique(data_age$age_group)

# Set the strata id
library(dplyr)
data_age <- data_age[order(data_age$DT_INTER),]
data_age$variable_indice_for_strata_id <- paste(data_age$dia_semana_internacao,"_",data_age$Month.x,"_",data_age$Year.x)
data_age$strata_id <- data_age %>% group_indices(variable_indice_for_strata_id)   # creating unique group IDs by day of week, month, and year.
data_age <- data_age[order(data_age$strata_id),]

# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_age$Queimadas_avg_1day, c(.99)))
quantile_PM = as.numeric(quantile(data_age$PM25_avg_1day, c(.99)))
data_age$case <- ifelse(data_age$Queimadas_avg_1day >= quantile_fire & data_age$PM25_avg_1day >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_age$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_1day +
                         CO_avg_1day + NO2_avg_1day + O3_avg_1day +
                         Temperature_avg_1day + Humidity_avg_1day +
                         Wind_direction_avg_1day + Wind_speed_avg_1day + Precipitacao_avg_1day + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_age)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[16,1]<-region
results.temp[16,2]<-outcome
results.temp[16,3]<-"Stratified by age (0-5 years old)"
results.temp[16,4]<-"1-day moving average"
results.temp[16,5]<- case_control[1,2]
results.temp[16,6]<- case_control[2,2]
results.temp[16,7]<- beta
results.temp[16,8]<- lo95ci
results.temp[16,9]<- hi95ci 
results.temp[16,10]<- beta_perc
results.temp[16,11]<- lo95ci_perc
results.temp[16,12]<- hi95ci_perc


### Stratified by age (0-5 years old) - 2-days moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_age$Queimadas_avg_2days, c(.99)))
quantile_PM = as.numeric(quantile(data_age$PM25_avg_2days, c(.99)))
data_age$case <- ifelse(data_age$Queimadas_avg_2days >= quantile_fire & data_age$PM25_avg_2days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_age$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_2days +
                         CO_avg_2days + NO2_avg_2days + O3_avg_2days +
                         Temperature_avg_2days + Humidity_avg_2days +
                         Wind_direction_avg_2days + Wind_speed_avg_2days + Precipitacao_avg_2days + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_age)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[17,1]<-region
results.temp[17,2]<-outcome
results.temp[17,3]<-"Stratified by age (0-5 years old)"
results.temp[17,4]<-"2-days moving average"
results.temp[17,5]<- case_control[1,2]
results.temp[17,6]<- case_control[2,2]
results.temp[17,7]<- beta
results.temp[17,8]<- lo95ci
results.temp[17,9]<- hi95ci 
results.temp[17,10]<- beta_perc
results.temp[17,11]<- lo95ci_perc
results.temp[17,12]<- hi95ci_perc


### Stratified by age (0-5 years old) - 3-days moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_age$Queimadas_avg_3days, c(.99)))
quantile_PM = as.numeric(quantile(data_age$PM25_avg_3days, c(.99)))
data_age$case <- ifelse(data_age$Queimadas_avg_3days >= quantile_fire & data_age$PM25_avg_3days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_age$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_3days +
                         CO_avg_3days + NO2_avg_3days + O3_avg_3days +
                         Temperature_avg_3days + Humidity_avg_3days +
                         Wind_direction_avg_3days + Wind_speed_avg_3days + Precipitacao_avg_3days + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_age)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[18,1]<-region
results.temp[18,2]<-outcome
results.temp[18,3]<-"Stratified by age (0-5 years old)"
results.temp[18,4]<-"3-days moving average"
results.temp[18,5]<- case_control[1,2]
results.temp[18,6]<- case_control[2,2]
results.temp[18,7]<- beta
results.temp[18,8]<- lo95ci
results.temp[18,9]<- hi95ci 
results.temp[18,10]<- beta_perc
results.temp[18,11]<- lo95ci_perc
results.temp[18,12]<- hi95ci_perc


### Stratified by age (0-5 years old) - 4-days moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_age$Queimadas_avg_4days, c(.99)))
quantile_PM = as.numeric(quantile(data_age$PM25_avg_4days, c(.99)))
data_age$case <- ifelse(data_age$Queimadas_avg_4days >= quantile_fire & data_age$PM25_avg_4days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_age$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_4days +
                         CO_avg_4days + NO2_avg_4days + O3_avg_4days +
                         Temperature_avg_4days + Humidity_avg_4days +
                         Wind_direction_avg_4days + Wind_speed_avg_4days + Precipitacao_avg_4days + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_age)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[19,1]<-region
results.temp[19,2]<-outcome
results.temp[19,3]<-"Stratified by age (0-5 years old)"
results.temp[19,4]<-"4-days moving average"
results.temp[19,5]<- case_control[1,2]
results.temp[19,6]<- case_control[2,2]
results.temp[19,7]<- beta
results.temp[19,8]<- lo95ci
results.temp[19,9]<- hi95ci 
results.temp[19,10]<- beta_perc
results.temp[19,11]<- lo95ci_perc
results.temp[19,12]<- hi95ci_perc


### Stratified by age (0-5 years old) - 5-days moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_age$Queimadas_avg_5days, c(.99)))
quantile_PM = as.numeric(quantile(data_age$PM25_avg_5days, c(.99)))
data_age$case <- ifelse(data_age$Queimadas_avg_5days >= quantile_fire & data_age$PM25_avg_5days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_age$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_5days +
                         CO_avg_5days + NO2_avg_5days + O3_avg_5days +
                         Temperature_avg_5days + Humidity_avg_5days +
                         Wind_direction_avg_5days + Wind_speed_avg_5days + Precipitacao_avg_5days + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_age)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[20,1]<-region
results.temp[20,2]<-outcome
results.temp[20,3]<-"Stratified by age (0-5 years old)"
results.temp[20,4]<-"5-days moving average"
results.temp[20,5]<- case_control[1,2]
results.temp[20,6]<- case_control[2,2]
results.temp[20,7]<- beta
results.temp[20,8]<- lo95ci
results.temp[20,9]<- hi95ci 
results.temp[20,10]<- beta_perc
results.temp[20,11]<- lo95ci_perc
results.temp[20,12]<- hi95ci_perc


##################################################################


### Stratified by age (35-64 years old) - 1-day moving average
########################################

# Set age group
data_region$age_group <- ifelse(data_region$IDADE %in% 35:64, "yes", "no")

# Subset the dataset by age
data_age <- data_region[which(data_region$age_group == "yes"), ]    
unique(data_age$age_group)

# Set the strata id
library(dplyr)
data_age <- data_age[order(data_age$DT_INTER),]
data_age$variable_indice_for_strata_id <- paste(data_age$dia_semana_internacao,"_",data_age$Month.x,"_",data_age$Year.x)
data_age$strata_id <- data_age %>% group_indices(variable_indice_for_strata_id)   # creating unique group IDs by day of week, month, and year.
data_age <- data_age[order(data_age$strata_id),]

# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_age$Queimadas_avg_1day, c(.99)))
quantile_PM = as.numeric(quantile(data_age$PM25_avg_1day, c(.99)))
data_age$case <- ifelse(data_age$Queimadas_avg_1day >= quantile_fire & data_age$PM25_avg_1day >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_age$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_1day +
                         CO_avg_1day + NO2_avg_1day + O3_avg_1day +
                         Temperature_avg_1day + Humidity_avg_1day +
                         Wind_direction_avg_1day + Wind_speed_avg_1day + Precipitacao_avg_1day + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_age)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[21,1]<-region
results.temp[21,2]<-outcome
results.temp[21,3]<-"Stratified by age (35-64 years old)"
results.temp[21,4]<-"1-day moving average"
results.temp[21,5]<- case_control[1,2]
results.temp[21,6]<- case_control[2,2]
results.temp[21,7]<- beta
results.temp[21,8]<- lo95ci
results.temp[21,9]<- hi95ci 
results.temp[21,10]<- beta_perc
results.temp[21,11]<- lo95ci_perc
results.temp[21,12]<- hi95ci_perc


### Stratified by age (35-64 years old) - 2-days moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_age$Queimadas_avg_2days, c(.99)))
quantile_PM = as.numeric(quantile(data_age$PM25_avg_2days, c(.99)))
data_age$case <- ifelse(data_age$Queimadas_avg_2days >= quantile_fire & data_age$PM25_avg_2days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_age$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_2days +
                         CO_avg_2days + NO2_avg_2days + O3_avg_2days +
                         Temperature_avg_2days + Humidity_avg_2days +
                         Wind_direction_avg_2days + Wind_speed_avg_2days + Precipitacao_avg_2days + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_age)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[22,1]<-region
results.temp[22,2]<-outcome
results.temp[22,3]<-"Stratified by age (35-64 years old)"
results.temp[22,4]<-"2-days moving average"
results.temp[22,5]<- case_control[1,2]
results.temp[22,6]<- case_control[2,2]
results.temp[22,7]<- beta
results.temp[22,8]<- lo95ci
results.temp[22,9]<- hi95ci 
results.temp[22,10]<- beta_perc
results.temp[22,11]<- lo95ci_perc
results.temp[22,12]<- hi95ci_perc


### Stratified by age (35-64 years old) - 3-days moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_age$Queimadas_avg_3days, c(.99)))
quantile_PM = as.numeric(quantile(data_age$PM25_avg_3days, c(.99)))
data_age$case <- ifelse(data_age$Queimadas_avg_3days >= quantile_fire & data_age$PM25_avg_3days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_age$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_3days +
                         CO_avg_3days + NO2_avg_3days + O3_avg_3days +
                         Temperature_avg_3days + Humidity_avg_3days +
                         Wind_direction_avg_3days + Wind_speed_avg_3days + Precipitacao_avg_3days + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_age)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[23,1]<-region
results.temp[23,2]<-outcome
results.temp[23,3]<-"Stratified by age (35-64 years old)"
results.temp[23,4]<-"3-days moving average"
results.temp[23,5]<- case_control[1,2]
results.temp[23,6]<- case_control[2,2]
results.temp[23,7]<- beta
results.temp[23,8]<- lo95ci
results.temp[23,9]<- hi95ci 
results.temp[23,10]<- beta_perc
results.temp[23,11]<- lo95ci_perc
results.temp[23,12]<- hi95ci_perc



### Stratified by age (35-64 years old) - 4-days moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_age$Queimadas_avg_4days, c(.99)))
quantile_PM = as.numeric(quantile(data_age$PM25_avg_4days, c(.99)))
data_age$case <- ifelse(data_age$Queimadas_avg_4days >= quantile_fire & data_age$PM25_avg_4days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_age$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_4days +
                         CO_avg_4days + NO2_avg_4days + O3_avg_4days +
                         Temperature_avg_4days + Humidity_avg_4days +
                         Wind_direction_avg_4days + Wind_speed_avg_4days + Precipitacao_avg_4days + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_age)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[24,1]<-region
results.temp[24,2]<-outcome
results.temp[24,3]<-"Stratified by age (35-64 years old)"
results.temp[24,4]<-"4-days moving average"
results.temp[24,5]<- case_control[1,2]
results.temp[24,6]<- case_control[2,2]
results.temp[24,7]<- beta
results.temp[24,8]<- lo95ci
results.temp[24,9]<- hi95ci 
results.temp[24,10]<- beta_perc
results.temp[24,11]<- lo95ci_perc
results.temp[24,12]<- hi95ci_perc


### Stratified by age (35-64 years old) - 5-days moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_age$Queimadas_avg_5days, c(.99)))
quantile_PM = as.numeric(quantile(data_age$PM25_avg_5days, c(.99)))
data_age$case <- ifelse(data_age$Queimadas_avg_5days >= quantile_fire & data_age$PM25_avg_5days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_age$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_5days +
                         CO_avg_5days + NO2_avg_5days + O3_avg_5days +
                         Temperature_avg_5days + Humidity_avg_5days +
                         Wind_direction_avg_5days + Wind_speed_avg_5days + Precipitacao_avg_5days + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_age)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[25,1]<-region
results.temp[25,2]<-outcome
results.temp[25,3]<-"Stratified by age (35-64 years old)"
results.temp[25,4]<-"5-days moving average"
results.temp[25,5]<- case_control[1,2]
results.temp[25,6]<- case_control[2,2]
results.temp[25,7]<- beta
results.temp[25,8]<- lo95ci
results.temp[25,9]<- hi95ci 
results.temp[25,10]<- beta_perc
results.temp[25,11]<- lo95ci_perc
results.temp[25,12]<- hi95ci_perc


##################################################################


### Stratified by age (> 64 years old) - 1-day moving average
########################################

# Set age group
data_region$age_group <- ifelse(data_region$IDADE>64, "yes", "no")

# Subset the dataset by age
data_age <- data_region[which(data_region$age_group == "yes"), ]    
unique(data_age$age_group)

# Set the strata id
library(dplyr)
data_age <- data_age[order(data_age$DT_INTER),]
data_age$variable_indice_for_strata_id <- paste(data_age$dia_semana_internacao,"_",data_age$Month.x,"_",data_age$Year.x)
data_age$strata_id <- data_age %>% group_indices(variable_indice_for_strata_id)   # creating unique group IDs by day of week, month, and year.
data_age <- data_age[order(data_age$strata_id),]

# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_age$Queimadas_avg_1day, c(.99)))
quantile_PM = as.numeric(quantile(data_age$PM25_avg_1day, c(.99)))
data_age$case <- ifelse(data_age$Queimadas_avg_1day >= quantile_fire & data_age$PM25_avg_1day >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_age$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_1day +
                         CO_avg_1day + NO2_avg_1day + O3_avg_1day +
                         Temperature_avg_1day + Humidity_avg_1day +
                         Wind_direction_avg_1day + Wind_speed_avg_1day + Precipitacao_avg_1day + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_age)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[26,1]<-region
results.temp[26,2]<-outcome
results.temp[26,3]<-"Stratified by age (> 64 years old)"
results.temp[26,4]<-"1-day moving average"
results.temp[26,5]<- case_control[1,2]
results.temp[26,6]<- case_control[2,2]
results.temp[26,7]<- beta
results.temp[26,8]<- lo95ci
results.temp[26,9]<- hi95ci 
results.temp[26,10]<- beta_perc
results.temp[26,11]<- lo95ci_perc
results.temp[26,12]<- hi95ci_perc


### Stratified by age (> 64 years old) - 2-days moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_age$Queimadas_avg_2days, c(.99)))
quantile_PM = as.numeric(quantile(data_age$PM25_avg_2days, c(.99)))
data_age$case <- ifelse(data_age$Queimadas_avg_2days >= quantile_fire & data_age$PM25_avg_2days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_age$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_2days +
                         CO_avg_2days + NO2_avg_2days + O3_avg_2days +
                         Temperature_avg_2days + Humidity_avg_2days +
                         Wind_direction_avg_2days + Wind_speed_avg_2days + Precipitacao_avg_2days + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_age)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[27,1]<-region
results.temp[27,2]<-outcome
results.temp[27,3]<-"Stratified by age (> 64 years old)"
results.temp[27,4]<-"2-days moving average"
results.temp[27,5]<- case_control[1,2]
results.temp[27,6]<- case_control[2,2]
results.temp[27,7]<- beta
results.temp[27,8]<- lo95ci
results.temp[27,9]<- hi95ci 
results.temp[27,10]<- beta_perc
results.temp[27,11]<- lo95ci_perc
results.temp[27,12]<- hi95ci_perc


### Stratified by age (> 64 years old) - 3-days moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_age$Queimadas_avg_3days, c(.99)))
quantile_PM = as.numeric(quantile(data_age$PM25_avg_3days, c(.99)))
data_age$case <- ifelse(data_age$Queimadas_avg_3days >= quantile_fire & data_age$PM25_avg_3days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_age$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_3days +
                         CO_avg_3days + NO2_avg_3days + O3_avg_3days +
                         Temperature_avg_3days + Humidity_avg_3days +
                         Wind_direction_avg_3days + Wind_speed_avg_3days + Precipitacao_avg_3days + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_age)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[28,1]<-region
results.temp[28,2]<-outcome
results.temp[28,3]<-"Stratified by age (> 64 years old)"
results.temp[28,4]<-"3-days moving average"
results.temp[28,5]<- case_control[1,2]
results.temp[28,6]<- case_control[2,2]
results.temp[28,7]<- beta
results.temp[28,8]<- lo95ci
results.temp[28,9]<- hi95ci 
results.temp[28,10]<- beta_perc
results.temp[28,11]<- lo95ci_perc
results.temp[28,12]<- hi95ci_perc


### Stratified by age (> 64 years old) - 4-days moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_age$Queimadas_avg_4days, c(.99)))
quantile_PM = as.numeric(quantile(data_age$PM25_avg_4days, c(.99)))
data_age$case <- ifelse(data_age$Queimadas_avg_4days >= quantile_fire & data_age$PM25_avg_4days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_age$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_4days +
                         CO_avg_4days + NO2_avg_4days + O3_avg_4days +
                         Temperature_avg_4days + Humidity_avg_4days +
                         Wind_direction_avg_4days + Wind_speed_avg_4days + Precipitacao_avg_4days + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_age)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[29,1]<-region
results.temp[29,2]<-outcome
results.temp[29,3]<-"Stratified by age (> 64 years old)"
results.temp[29,4]<-"4-days moving average"
results.temp[29,5]<- case_control[1,2]
results.temp[29,6]<- case_control[2,2]
results.temp[29,7]<- beta
results.temp[29,8]<- lo95ci
results.temp[29,9]<- hi95ci 
results.temp[29,10]<- beta_perc
results.temp[29,11]<- lo95ci_perc
results.temp[29,12]<- hi95ci_perc


### Stratified by age (> 64 years old) - 5-days moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_age$Queimadas_avg_5days, c(.99)))
quantile_PM = as.numeric(quantile(data_age$PM25_avg_5days, c(.99)))
data_age$case <- ifelse(data_age$Queimadas_avg_5days >= quantile_fire & data_age$PM25_avg_5days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_age$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_5days +
                         CO_avg_5days + NO2_avg_5days + O3_avg_5days +
                         Temperature_avg_5days + Humidity_avg_5days +
                         Wind_direction_avg_5days + Wind_speed_avg_5days + Precipitacao_avg_5days + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_age)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[30,1]<-region
results.temp[30,2]<-outcome
results.temp[30,3]<-"Stratified by age (> 64 years old)"
results.temp[30,4]<-"5-days moving average"
results.temp[30,5]<- case_control[1,2]
results.temp[30,6]<- case_control[2,2]
results.temp[30,7]<- beta
results.temp[30,8]<- lo95ci
results.temp[30,9]<- hi95ci 
results.temp[30,10]<- beta_perc
results.temp[30,11]<- lo95ci_perc
results.temp[30,12]<- hi95ci_perc



##########################################################################################################


### Primary model excluding the other pollutants (CO, NO2, and O3) - 1-day moving average 
###########################################################################

# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_region$Queimadas_avg_1day, c(.99)))
quantile_PM = as.numeric(quantile(data_region$PM25_avg_1day, c(.99)))
data_region$case <- ifelse(data_region$Queimadas_avg_1day >= quantile_fire & data_region$PM25_avg_1day >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_region$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_1day +
                         Temperature_avg_1day + Humidity_avg_1day +
                         Wind_direction_avg_1day + Wind_speed_avg_1day + Precipitacao_avg_1day + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_region)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[31,1]<-region
results.temp[31,2]<-outcome
results.temp[31,3]<-"Primary model excluding the other pollutants (CO, NO2, and O3)"
results.temp[31,4]<-"1-day moving average"
results.temp[31,5]<- case_control[1,2]
results.temp[31,6]<- case_control[2,2]
results.temp[31,7]<- beta
results.temp[31,8]<- lo95ci
results.temp[31,9]<- hi95ci 
results.temp[31,10]<- beta_perc
results.temp[31,11]<- lo95ci_perc
results.temp[31,12]<- hi95ci_perc


### Primary model excluding the other pollutants (CO, NO2, and O3) - 2-days moving average
########################################

# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_region$Queimadas_avg_2days, c(.99)))
quantile_PM = as.numeric(quantile(data_region$PM25_avg_2days, c(.99)))
data_region$case <- ifelse(data_region$Queimadas_avg_2days >= quantile_fire & data_region$PM25_avg_2days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_region$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_2days +
                         Temperature_avg_2days + Humidity_avg_2days +
                         Wind_direction_avg_2days + Wind_speed_avg_2days + Precipitacao_avg_2days + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_region)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[32,1]<-region
results.temp[32,2]<-outcome
results.temp[32,3]<-"Primary model excluding the other pollutants (CO, NO2, and O3)"
results.temp[32,4]<-"2-days moving average"
results.temp[32,5]<- case_control[1,2]
results.temp[32,6]<- case_control[2,2]
results.temp[32,7]<- beta
results.temp[32,8]<- lo95ci
results.temp[32,9]<- hi95ci 
results.temp[32,10]<- beta_perc
results.temp[32,11]<- lo95ci_perc
results.temp[32,12]<- hi95ci_perc


### Primary model excluding the other pollutants (CO, NO2, and O3) - 3-days moving average
########################################

# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_region$Queimadas_avg_3days, c(.99)))
quantile_PM = as.numeric(quantile(data_region$PM25_avg_3days, c(.99)))
data_region$case <- ifelse(data_region$Queimadas_avg_3days >= quantile_fire & data_region$PM25_avg_3days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_region$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_3days +
                         Temperature_avg_3days + Humidity_avg_3days +
                         Wind_direction_avg_3days + Wind_speed_avg_3days + Precipitacao_avg_3days + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_region)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[33,1]<-region
results.temp[33,2]<-outcome
results.temp[33,3]<-"Primary model excluding the other pollutants (CO, NO2, and O3)"
results.temp[33,4]<-"3-days moving average"
results.temp[33,5]<- case_control[1,2]
results.temp[33,6]<- case_control[2,2]
results.temp[33,7]<- beta
results.temp[33,8]<- lo95ci
results.temp[33,9]<- hi95ci 
results.temp[33,10]<- beta_perc
results.temp[33,11]<- lo95ci_perc
results.temp[33,12]<- hi95ci_perc


### Primary model excluding the other pollutants (CO, NO2, and O3) - 4-days moving average
########################################

# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_region$Queimadas_avg_4days, c(.99)))
quantile_PM = as.numeric(quantile(data_region$PM25_avg_4days, c(.99)))
data_region$case <- ifelse(data_region$Queimadas_avg_4days >= quantile_fire & data_region$PM25_avg_4days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_region$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_4days +
                         Temperature_avg_4days + Humidity_avg_4days +
                         Wind_direction_avg_4days + Wind_speed_avg_4days + Precipitacao_avg_4days + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_region)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[34,1]<-region
results.temp[34,2]<-outcome
results.temp[34,3]<-"Primary model excluding the other pollutants (CO, NO2, and O3)"
results.temp[34,4]<-"4-days moving average"
results.temp[34,5]<- case_control[1,2]
results.temp[34,6]<- case_control[2,2]
results.temp[34,7]<- beta
results.temp[34,8]<- lo95ci
results.temp[34,9]<- hi95ci 
results.temp[34,10]<- beta_perc
results.temp[34,11]<- lo95ci_perc
results.temp[34,12]<- hi95ci_perc


### Primary model excluding the other pollutants (CO, NO2, and O3) - 5-days moving average
########################################

# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_region$Queimadas_avg_5days, c(.99)))
quantile_PM = as.numeric(quantile(data_region$PM25_avg_5days, c(.99)))
data_region$case <- ifelse(data_region$Queimadas_avg_5days >= quantile_fire & data_region$PM25_avg_5days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_region$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_5days +
                         Temperature_avg_5days + Humidity_avg_5days +
                         Wind_direction_avg_5days + Wind_speed_avg_5days + Precipitacao_avg_5days + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_region)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[35,1]<-region
results.temp[35,2]<-outcome
results.temp[35,3]<-"Primary model excluding the other pollutants (CO, NO2, and O3)"
results.temp[35,4]<-"5-days moving average"
results.temp[35,5]<- case_control[1,2]
results.temp[35,6]<- case_control[2,2]
results.temp[35,7]<- beta
results.temp[35,8]<- lo95ci
results.temp[35,9]<- hi95ci 
results.temp[35,10]<- beta_perc
results.temp[35,11]<- lo95ci_perc
results.temp[35,12]<- hi95ci_perc


######################################################################################

### Primary model excluding race - 1-day moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_region$Queimadas_avg_1day, c(.99)))
quantile_PM = as.numeric(quantile(data_region$PM25_avg_1day, c(.99)))
data_region$case <- ifelse(data_region$Queimadas_avg_1day >= quantile_fire & data_region$PM25_avg_1day >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_region$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_1day +
                         CO_avg_1day + NO2_avg_1day + O3_avg_1day +
                         Temperature_avg_1day + Humidity_avg_1day +
                         Wind_direction_avg_1day + Wind_speed_avg_1day + Precipitacao_avg_1day + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         QT_DIARIAS + strata(strata_id), data_region)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[36,1]<-region
results.temp[36,2]<-outcome
results.temp[36,3]<-"Primary model excluding race"
results.temp[36,4]<-"1-day moving average"
results.temp[36,5]<- case_control[1,2]
results.temp[36,6]<- case_control[2,2]
results.temp[36,7]<- beta
results.temp[36,8]<- lo95ci
results.temp[36,9]<- hi95ci 
results.temp[36,10]<- beta_perc
results.temp[36,11]<- lo95ci_perc
results.temp[36,12]<- hi95ci_perc


### Primary model excluding race - 2-days moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_region$Queimadas_avg_2days, c(.99)))
quantile_PM = as.numeric(quantile(data_region$PM25_avg_2days, c(.99)))
data_region$case <- ifelse(data_region$Queimadas_avg_2days >= quantile_fire & data_region$PM25_avg_2days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_region$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_2days +
                         CO_avg_2days + NO2_avg_2days + O3_avg_2days +
                         Temperature_avg_2days + Humidity_avg_2days +
                         Wind_direction_avg_2days + Wind_speed_avg_2days + Precipitacao_avg_2days + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         QT_DIARIAS + strata(strata_id), data_region)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[37,1]<-region
results.temp[37,2]<-outcome
results.temp[37,3]<-"Primary model excluding race"
results.temp[37,4]<-"2-days moving average"
results.temp[37,5]<- case_control[1,2]
results.temp[37,6]<- case_control[2,2]
results.temp[37,7]<- beta
results.temp[37,8]<- lo95ci
results.temp[37,9]<- hi95ci 
results.temp[37,10]<- beta_perc
results.temp[37,11]<- lo95ci_perc
results.temp[37,12]<- hi95ci_perc


### Primary model excluding race - 3-days moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_region$Queimadas_avg_3days, c(.99)))
quantile_PM = as.numeric(quantile(data_region$PM25_avg_3days, c(.99)))
data_region$case <- ifelse(data_region$Queimadas_avg_3days >= quantile_fire & data_region$PM25_avg_3days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_region$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_3days +
                         CO_avg_3days + NO2_avg_3days + O3_avg_3days +
                         Temperature_avg_3days + Humidity_avg_3days +
                         Wind_direction_avg_3days + Wind_speed_avg_3days + Precipitacao_avg_3days + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         QT_DIARIAS + strata(strata_id), data_region)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[38,1]<-region
results.temp[38,2]<-outcome
results.temp[38,3]<-"Primary model excluding race"
results.temp[38,4]<-"3-days moving average"
results.temp[38,5]<- case_control[1,2]
results.temp[38,6]<- case_control[2,2]
results.temp[38,7]<- beta
results.temp[38,8]<- lo95ci
results.temp[38,9]<- hi95ci 
results.temp[38,10]<- beta_perc
results.temp[38,11]<- lo95ci_perc
results.temp[38,12]<- hi95ci_perc


### Primary model excluding race - 4-days moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_region$Queimadas_avg_4days, c(.99)))
quantile_PM = as.numeric(quantile(data_region$PM25_avg_4days, c(.99)))
data_region$case <- ifelse(data_region$Queimadas_avg_4days >= quantile_fire & data_region$PM25_avg_4days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_region$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_4days +
                         CO_avg_4days + NO2_avg_4days + O3_avg_4days +
                         Temperature_avg_4days + Humidity_avg_4days +
                         Wind_direction_avg_4days + Wind_speed_avg_4days + Precipitacao_avg_4days + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         QT_DIARIAS + strata(strata_id), data_region)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[39,1]<-region
results.temp[39,2]<-outcome
results.temp[39,3]<-"Primary model excluding race"
results.temp[39,4]<-"4-days moving average"
results.temp[39,5]<- case_control[1,2]
results.temp[39,6]<- case_control[2,2]
results.temp[39,7]<- beta
results.temp[39,8]<- lo95ci
results.temp[39,9]<- hi95ci 
results.temp[39,10]<- beta_perc
results.temp[39,11]<- lo95ci_perc
results.temp[39,12]<- hi95ci_perc


### Primary model excluding race - 5-days moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_region$Queimadas_avg_5days, c(.99)))
quantile_PM = as.numeric(quantile(data_region$PM25_avg_5days, c(.99)))
data_region$case <- ifelse(data_region$Queimadas_avg_5days >= quantile_fire & data_region$PM25_avg_5days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_region$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_5days +
                         CO_avg_5days + NO2_avg_5days + O3_avg_5days +
                         Temperature_avg_5days + Humidity_avg_5days +
                         Wind_direction_avg_5days + Wind_speed_avg_5days + Precipitacao_avg_5days + 
                         res_ALTITUDE + res_LATITUDE + res_LONGITUDE +
                         res_CAPITAL + res_uf_SIGLA_UF +
                         QT_DIARIAS + strata(strata_id), data_region)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[40,1]<-region
results.temp[40,2]<-outcome
results.temp[40,3]<-"Primary model excluding race"
results.temp[40,4]<-"5-days moving average"
results.temp[40,5]<- case_control[1,2]
results.temp[40,6]<- case_control[2,2]
results.temp[40,7]<- beta
results.temp[40,8]<- lo95ci
results.temp[40,9]<- hi95ci 
results.temp[40,10]<- beta_perc
results.temp[40,11]<- lo95ci_perc
results.temp[40,12]<- hi95ci_perc



#############################################################################################


### Primary model excluding state and lat/long - 1-day moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_region$Queimadas_avg_1day, c(.99)))
quantile_PM = as.numeric(quantile(data_region$PM25_avg_1day, c(.99)))
data_region$case <- ifelse(data_region$Queimadas_avg_1day >= quantile_fire & data_region$PM25_avg_1day >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_region$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_1day +
                         CO_avg_1day + NO2_avg_1day + O3_avg_1day +
                         Temperature_avg_1day + Humidity_avg_1day +
                         Wind_direction_avg_1day + Wind_speed_avg_1day + Precipitacao_avg_1day + 
                         res_ALTITUDE + 
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_region)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[41,1]<-region
results.temp[41,2]<-outcome
results.temp[41,3]<-"Primary model excluding state and lat/long"
results.temp[41,4]<-"1-day moving average"
results.temp[41,5]<- case_control[1,2]
results.temp[41,6]<- case_control[2,2]
results.temp[41,7]<- beta
results.temp[41,8]<- lo95ci
results.temp[41,9]<- hi95ci 
results.temp[41,10]<- beta_perc
results.temp[41,11]<- lo95ci_perc
results.temp[41,12]<- hi95ci_perc


### Primary model excluding state and lat/long - 2-days moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_region$Queimadas_avg_2days, c(.99)))
quantile_PM = as.numeric(quantile(data_region$PM25_avg_2days, c(.99)))
data_region$case <- ifelse(data_region$Queimadas_avg_2days >= quantile_fire & data_region$PM25_avg_2days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_region$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_2days +
                         CO_avg_2days + NO2_avg_2days + O3_avg_2days +
                         Temperature_avg_2days + Humidity_avg_2days +
                         Wind_direction_avg_2days + Wind_speed_avg_2days + Precipitacao_avg_2days + 
                         res_ALTITUDE + 
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_region)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[42,1]<-region
results.temp[42,2]<-outcome
results.temp[42,3]<-"Primary model excluding state and lat/long"
results.temp[42,4]<-"2-days moving average"
results.temp[42,5]<- case_control[1,2]
results.temp[42,6]<- case_control[2,2]
results.temp[42,7]<- beta
results.temp[42,8]<- lo95ci
results.temp[42,9]<- hi95ci 
results.temp[42,10]<- beta_perc
results.temp[42,11]<- lo95ci_perc
results.temp[42,12]<- hi95ci_perc


### Primary model excluding state and lat/long - 3-days moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_region$Queimadas_avg_3days, c(.99)))
quantile_PM = as.numeric(quantile(data_region$PM25_avg_3days, c(.99)))
data_region$case <- ifelse(data_region$Queimadas_avg_3days >= quantile_fire & data_region$PM25_avg_3days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_region$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_3days +
                         CO_avg_3days + NO2_avg_3days + O3_avg_3days +
                         Temperature_avg_3days + Humidity_avg_3days +
                         Wind_direction_avg_3days + Wind_speed_avg_3days + Precipitacao_avg_3days + 
                         res_ALTITUDE + 
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_region)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[43,1]<-region
results.temp[43,2]<-outcome
results.temp[43,3]<-"Primary model excluding state and lat/long"
results.temp[43,4]<-"3-days moving average"
results.temp[43,5]<- case_control[1,2]
results.temp[43,6]<- case_control[2,2]
results.temp[43,7]<- beta
results.temp[43,8]<- lo95ci
results.temp[43,9]<- hi95ci 
results.temp[43,10]<- beta_perc
results.temp[43,11]<- lo95ci_perc
results.temp[43,12]<- hi95ci_perc


### Primary model excluding state and lat/long - 4-days moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_region$Queimadas_avg_4days, c(.99)))
quantile_PM = as.numeric(quantile(data_region$PM25_avg_4days, c(.99)))
data_region$case <- ifelse(data_region$Queimadas_avg_4days >= quantile_fire & data_region$PM25_avg_4days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_region$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_4days +
                         CO_avg_4days + NO2_avg_4days + O3_avg_4days +
                         Temperature_avg_4days + Humidity_avg_4days +
                         Wind_direction_avg_4days + Wind_speed_avg_4days + Precipitacao_avg_4days + 
                         res_ALTITUDE + 
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_region)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[44,1]<-region
results.temp[44,2]<-outcome
results.temp[44,3]<-"Primary model excluding state and lat/long"
results.temp[44,4]<-"4-days moving average"
results.temp[44,5]<- case_control[1,2]
results.temp[44,6]<- case_control[2,2]
results.temp[44,7]<- beta
results.temp[44,8]<- lo95ci
results.temp[44,9]<- hi95ci 
results.temp[44,10]<- beta_perc
results.temp[44,11]<- lo95ci_perc
results.temp[44,12]<- hi95ci_perc


### Primary model excluding state and lat/long - 5-days moving average
########################################
# Set case (defined as "1")/control (defined as "0")
quantile_fire = as.numeric(quantile(data_region$Queimadas_avg_5days, c(.99)))
quantile_PM = as.numeric(quantile(data_region$PM25_avg_5days, c(.99)))
data_region$case <- ifelse(data_region$Queimadas_avg_5days >= quantile_fire & data_region$PM25_avg_5days >= quantile_PM, 1 , 0)  
case_control = as.data.frame(table(data_region$case))

# Run the clogit model
model_clogit <- clogit(case ~ PM25_avg_5days +
                         CO_avg_5days + NO2_avg_5days + O3_avg_5days +
                         Temperature_avg_5days + Humidity_avg_5days +
                         Wind_direction_avg_5days + Wind_speed_avg_5days + Precipitacao_avg_5days + 
                         res_ALTITUDE + 
                         res_CAPITAL + res_uf_SIGLA_UF +
                         def_raca_cor + QT_DIARIAS + strata(strata_id), data_region)

summary(model_clogit)

# Extract the OR
beta <- summary(model_clogit)$coefficients[1,2]
# Extract percentage increase associated with wildfire-related air pollution events
beta_perc <- (beta-1)*100
# Extract SE
se <- summary(model_clogit)$coefficients[1,3]
# Extract OR 95%CI
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))
# Extract 95%CI percentage increase associated with wildfire-related air pollution events
lo95ci_perc= (lo95ci-1)*100
hi95ci_perc= (hi95ci-1)*100

# Save results
results.temp[45,1]<-region
results.temp[45,2]<-outcome
results.temp[45,3]<-"Primary model excluding state and lat/long"
results.temp[45,4]<-"5-days moving average"
results.temp[45,5]<- case_control[1,2]
results.temp[45,6]<- case_control[2,2]
results.temp[45,7]<- beta
results.temp[45,8]<- lo95ci
results.temp[45,9]<- hi95ci 
results.temp[45,10]<- beta_perc
results.temp[45,11]<- lo95ci_perc
results.temp[45,12]<- hi95ci_perc



################################################################################
################################################################################

### Save the results in a Table
################################################
colnames(results.temp)<-c("Region", "Outcome", "Model", "Moving Average", "Controls(n)", "Cases(n)", 
                          "Odds Ratio", "Lower 95%CI", "Upper 95%CI", 
                          "% increase", "% increase Lower 95%CI", "% increase Upper 95%CI")

results<-rbind(results, results.temp)
name <- paste("Results_coefficients_",region, "_", outcome, ".csv", sep="")
setwd("C:/Users/Weeberb/Google Drive/Documents/2- Career/5_Fundacao Getulio Vargas/7_Papers/4_Wildfire and health in Brazil/Statistical analysis")
write.csv(results, file=name, row.names=FALSE)

}



















  
