

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

# Merge multiple CSV files generated in the previous stage in order to have the whole period in a single file
library(data.table)
filenames <- list.files()
data_all_years <- rbindlist(lapply(filenames,fread))

# Save CSV file (this CSV file will be the subset file for this study)
Save_output_2 = "C:/Users/Weeberb/Google Drive/Documents/2- Career/5_Fundacao Getulio Vargas/7_Papers/4_Wildfire and health in Brazil/Statistical analysis/2_Input_data_subset_for_this_study/"
name_2 <- paste0(Save_output_2, "Admissions_cardiorespiratory_2008_2018", ".csv")
write.csv(data_all_years, file=name_2)


# Run this line below if I need to open the data "data_all_years" in a new R section
data_all_years <- read.csv("Admissions_cardiorespiratory_2008_2018.csv")



### Part 2 - Organize and clean the wildfire and covariates data ((this is the data downloaded from SISAM)
#############################################################################################################

library(plyr)

setwd("C:/Users/Weeberb/Desktop/SISAM_data_to test the script for wildfire and health paper")
sep= "/"
Save_output = "C:/Users/Weeberb/Desktop/SISAM_data_to test the script for wildfire and health paper/edited"

# Loop over the wildfire and covariate files
fileNames = list.files()
for (fileName in fileNames) {
  
  # Open the data
  data_wildfire_covariates <- read.csv(fileName, header = TRUE)
  
  # Extract Date, Year, Month, Day, and Hour into different colluns
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
  name <- paste0(Save_output, sep, fileName, "_edited", ".csv")
  write.csv(data_wildfire_covariates_daily, file=name)
  
  rm(data_wildfire_covariates)
  rm(data_wildfire_covariates_daily)
  
  print(paste(Sys.time(),fileName))
  
}
               

# Merge multiple CSV files generated in the previous stage in order to have the whole period and all municialities in a single file
setwd(paste0(Save_output, sep))
library(data.table)
filenames <- list.files()
data_full <- rbindlist(lapply(filenames,fread))

# Save CSV file (this CSV file will be the subset file for this study)
Save_output_2 = "C:/Users/Weeberb/Google Drive/Documents/2- Career/5_Fundacao Getulio Vargas/7_Papers/4_Wildfire and health in Brazil/Statistical analysis/2_Input_data_subset_for_this_study/"
name_2 <- paste0(Save_output_2, "Wildfire_and_covariates", ".csv")
write.csv(data_full, file=name_2)


# Run this line below if I need to open the data "data_full" in a new R section
data_full <- read.csv("Wildfire_and_covariates.csv")



### Part 3 - Merge health data with the wildfire and covariates
################################################################

health_data <- data_all_years
wildfire_covariates <- data_full

### Do the last edits in the health data before the merging
# Add a variable with 7-digits code (from IBGE) for the municipality. We will perform the merge using tis 7-digits code
code_7digits <- read.csv("Codigo_municipio_SixAndSeven_digits.csv")
health_data_2 <- merge(health_data, code_7digits, by="MUNIC_RES")
head(health_data_2)

# Extract Year, month, and day (of the hospital admission) into single columns 
health_data_2$Date <- as.Date(health_data_2$dt_inter)
health_data_2$Year <- lubridate::year(health_data_2$Date)
health_data_2$Month <- lubridate::month(health_data_2$Date)
health_data_2$Day <- lubridate::day(health_data_2$Date)

### Now, apply the merge --> health data and wildfire/covariates
final_data <- merge(health_data_2, wildfire_covariates, by.x = c("CD_GEOCMU", "Date"), by.y = c("mun_geocod", "Date"), all.x = TRUE, all.y = FALSE)



### Part 4 - Remove missing values in th predictors
###################################################
library(tidyr)
final_data_2 <- final_data %>% drop_na(co_ppb, no2_ppb, o3_ppb, pm25_ugm3, so2_ugm3, precipitacao_mmdia, temperatura_c, 
                                       umidade_relativa_percentual, vento_direcao_grau, vento_velocidade_ms)


# For the "focos_queimada" variable, replace NA values with zeros (this is because when there were no wildfires, for some reason it appears as NA)
final_data_2$focos_queimada[is.na(final_data_2$focos_queimada)] <- 0



### Part 5 - Statistical analyses
##########################################################

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
            "res_ALTITUDE")                                                                      # Geographical variable

final_data_3 <- final_data_2[, myvars, with = FALSE]


# Set case/control
final_data_3$case[final_data_3$focos_queimada >"0"] <- 1   # This is the case
final_data_3$case[final_data_3$focos_queimada=="0"] <- 0   # This is the control


# Set the strata id
{
final_data_3$strata_id[final_data_3$dia_semana_internacao == "seg" & final_data_3$Month.x == 1 & final_data_3$Year.x == 2008] <- 1   
final_data_3$strata_id[final_data_3$dia_semana_internacao == "ter" & final_data_3$Month.x == 1 & final_data_3$Year.x == 2008] <- 2
final_data_3$strata_id[final_data_3$dia_semana_internacao == "qua" & final_data_3$Month.x == 1 & final_data_3$Year.x == 2008] <- 3
final_data_3$strata_id[final_data_3$dia_semana_internacao == "qui" & final_data_3$Month.x == 1 & final_data_3$Year.x == 2008] <- 4
final_data_3$strata_id[final_data_3$dia_semana_internacao == "sex" & final_data_3$Month.x == 1 & final_data_3$Year.x == 2008] <- 5
final_data_3$strata_id[final_data_3$dia_semana_internacao == "sab" & final_data_3$Month.x == 1 & final_data_3$Year.x == 2008] <- 6
final_data_3$strata_id[final_data_3$dia_semana_internacao == "dom" & final_data_3$Month.x == 1 & final_data_3$Year.x == 2008] <- 7

final_data_3$strata_id[final_data_3$dia_semana_internacao == "seg" & final_data_3$Month.x ==2 & final_data_3$Year.x == 2008] <- 8   
final_data_3$strata_id[final_data_3$dia_semana_internacao == "ter" & final_data_3$Month.x ==2 & final_data_3$Year.x == 2008] <- 9
final_data_3$strata_id[final_data_3$dia_semana_internacao == "qua" & final_data_3$Month.x ==2 & final_data_3$Year.x == 2008] <- 10
final_data_3$strata_id[final_data_3$dia_semana_internacao == "qui" & final_data_3$Month.x ==2 & final_data_3$Year.x == 2008] <- 11
final_data_3$strata_id[final_data_3$dia_semana_internacao == "sex" & final_data_3$Month.x ==2 & final_data_3$Year.x == 2008] <- 12
final_data_3$strata_id[final_data_3$dia_semana_internacao == "sab" & final_data_3$Month.x ==2 & final_data_3$Year.x == 2008] <- 13
final_data_3$strata_id[final_data_3$dia_semana_internacao == "dom" & final_data_3$Month.x ==2 & final_data_3$Year.x == 2008] <- 14

final_data_3$strata_id[final_data_3$dia_semana_internacao == "seg" & final_data_3$Month.x ==3 & final_data_3$Year.x == 2008] <- 15    
final_data_3$strata_id[final_data_3$dia_semana_internacao == "ter" & final_data_3$Month.x ==3 & final_data_3$Year.x == 2008] <- 16 
final_data_3$strata_id[final_data_3$dia_semana_internacao == "qua" & final_data_3$Month.x ==3 & final_data_3$Year.x == 2008] <- 17 
final_data_3$strata_id[final_data_3$dia_semana_internacao == "qui" & final_data_3$Month.x ==3 & final_data_3$Year.x == 2008] <- 18 
final_data_3$strata_id[final_data_3$dia_semana_internacao == "sex" & final_data_3$Month.x ==3 & final_data_3$Year.x == 2008] <- 19
final_data_3$strata_id[final_data_3$dia_semana_internacao == "sab" & final_data_3$Month.x ==3 & final_data_3$Year.x == 2008] <- 20
final_data_3$strata_id[final_data_3$dia_semana_internacao == "dom" & final_data_3$Month.x ==3 & final_data_3$Year.x == 2008] <- 21

final_data_3$strata_id[final_data_3$dia_semana_internacao == "seg" & final_data_3$Month.x ==4 & final_data_3$Year.x == 2008] <- 22   
final_data_3$strata_id[final_data_3$dia_semana_internacao == "ter" & final_data_3$Month.x ==4 & final_data_3$Year.x == 2008] <- 23
final_data_3$strata_id[final_data_3$dia_semana_internacao == "qua" & final_data_3$Month.x ==4 & final_data_3$Year.x == 2008] <- 24
final_data_3$strata_id[final_data_3$dia_semana_internacao == "qui" & final_data_3$Month.x ==4 & final_data_3$Year.x == 2008] <- 25
final_data_3$strata_id[final_data_3$dia_semana_internacao == "sex" & final_data_3$Month.x ==4 & final_data_3$Year.x == 2008] <- 26
final_data_3$strata_id[final_data_3$dia_semana_internacao == "sab" & final_data_3$Month.x ==4 & final_data_3$Year.x == 2008] <- 27
final_data_3$strata_id[final_data_3$dia_semana_internacao == "dom" & final_data_3$Month.x ==4 & final_data_3$Year.x == 2008] <- 28

final_data_3$strata_id[final_data_3$dia_semana_internacao == "seg" & final_data_3$Month.x ==5 & final_data_3$Year.x == 2008] <- 29   
final_data_3$strata_id[final_data_3$dia_semana_internacao == "ter" & final_data_3$Month.x ==5 & final_data_3$Year.x == 2008] <- 30
final_data_3$strata_id[final_data_3$dia_semana_internacao == "qua" & final_data_3$Month.x ==5 & final_data_3$Year.x == 2008] <- 31
final_data_3$strata_id[final_data_3$dia_semana_internacao == "qui" & final_data_3$Month.x ==5 & final_data_3$Year.x == 2008] <- 32
final_data_3$strata_id[final_data_3$dia_semana_internacao == "sex" & final_data_3$Month.x ==5 & final_data_3$Year.x == 2008] <- 33
final_data_3$strata_id[final_data_3$dia_semana_internacao == "sab" & final_data_3$Month.x ==5 & final_data_3$Year.x == 2008] <- 34
final_data_3$strata_id[final_data_3$dia_semana_internacao == "dom" & final_data_3$Month.x ==5 & final_data_3$Year.x == 2008] <- 35  
  
final_data_3$strata_id[final_data_3$dia_semana_internacao == "seg" & final_data_3$Month.x ==6 & final_data_3$Year.x == 2008] <- 36   
final_data_3$strata_id[final_data_3$dia_semana_internacao == "ter" & final_data_3$Month.x ==6 & final_data_3$Year.x == 2008] <- 37
final_data_3$strata_id[final_data_3$dia_semana_internacao == "qua" & final_data_3$Month.x ==6 & final_data_3$Year.x == 2008] <- 38
final_data_3$strata_id[final_data_3$dia_semana_internacao == "qui" & final_data_3$Month.x ==6 & final_data_3$Year.x == 2008] <- 39
final_data_3$strata_id[final_data_3$dia_semana_internacao == "sex" & final_data_3$Month.x ==6 & final_data_3$Year.x == 2008] <- 40
final_data_3$strata_id[final_data_3$dia_semana_internacao == "sab" & final_data_3$Month.x ==6 & final_data_3$Year.x == 2008] <- 41
final_data_3$strata_id[final_data_3$dia_semana_internacao == "dom" & final_data_3$Month.x ==6 & final_data_3$Year.x == 2008] <- 42  
  
final_data_3$strata_id[final_data_3$dia_semana_internacao == "seg" & final_data_3$Month.x ==7 & final_data_3$Year.x == 2008] <- 43   
final_data_3$strata_id[final_data_3$dia_semana_internacao == "ter" & final_data_3$Month.x ==7 & final_data_3$Year.x == 2008] <- 44
final_data_3$strata_id[final_data_3$dia_semana_internacao == "qua" & final_data_3$Month.x ==7 & final_data_3$Year.x == 2008] <- 45
final_data_3$strata_id[final_data_3$dia_semana_internacao == "qui" & final_data_3$Month.x ==7 & final_data_3$Year.x == 2008] <- 46
final_data_3$strata_id[final_data_3$dia_semana_internacao == "sex" & final_data_3$Month.x ==7 & final_data_3$Year.x == 2008] <- 47
final_data_3$strata_id[final_data_3$dia_semana_internacao == "sab" & final_data_3$Month.x ==7 & final_data_3$Year.x == 2008] <- 48
final_data_3$strata_id[final_data_3$dia_semana_internacao == "dom" & final_data_3$Month.x ==7 & final_data_3$Year.x == 2008] <- 49  

final_data_3$strata_id[final_data_3$dia_semana_internacao == "seg" & final_data_3$Month.x ==8 & final_data_3$Year.x == 2008] <- 50   
final_data_3$strata_id[final_data_3$dia_semana_internacao == "ter" & final_data_3$Month.x ==8 & final_data_3$Year.x == 2008] <- 51
final_data_3$strata_id[final_data_3$dia_semana_internacao == "qua" & final_data_3$Month.x ==8 & final_data_3$Year.x == 2008] <- 52
final_data_3$strata_id[final_data_3$dia_semana_internacao == "qui" & final_data_3$Month.x ==8 & final_data_3$Year.x == 2008] <- 53
final_data_3$strata_id[final_data_3$dia_semana_internacao == "sex" & final_data_3$Month.x ==8 & final_data_3$Year.x == 2008] <- 54
final_data_3$strata_id[final_data_3$dia_semana_internacao == "sab" & final_data_3$Month.x ==8 & final_data_3$Year.x == 2008] <- 55
final_data_3$strata_id[final_data_3$dia_semana_internacao == "dom" & final_data_3$Month.x ==8 & final_data_3$Year.x == 2008] <- 56
  
final_data_3$strata_id[final_data_3$dia_semana_internacao == "seg" & final_data_3$Month.x ==9 & final_data_3$Year.x == 2008] <- 57   
final_data_3$strata_id[final_data_3$dia_semana_internacao == "ter" & final_data_3$Month.x ==9 & final_data_3$Year.x == 2008] <- 58
final_data_3$strata_id[final_data_3$dia_semana_internacao == "qua" & final_data_3$Month.x ==9 & final_data_3$Year.x == 2008] <- 59
final_data_3$strata_id[final_data_3$dia_semana_internacao == "qui" & final_data_3$Month.x ==9 & final_data_3$Year.x == 2008] <- 60
final_data_3$strata_id[final_data_3$dia_semana_internacao == "sex" & final_data_3$Month.x ==9 & final_data_3$Year.x == 2008] <- 61
final_data_3$strata_id[final_data_3$dia_semana_internacao == "sab" & final_data_3$Month.x ==9 & final_data_3$Year.x == 2008] <- 62
final_data_3$strata_id[final_data_3$dia_semana_internacao == "dom" & final_data_3$Month.x ==9 & final_data_3$Year.x == 2008] <- 63
  
final_data_3$strata_id[final_data_3$dia_semana_internacao == "seg" & final_data_3$Month.x ==10 & final_data_3$Year.x == 2008] <- 64   
final_data_3$strata_id[final_data_3$dia_semana_internacao == "ter" & final_data_3$Month.x ==10 & final_data_3$Year.x == 2008] <- 65
final_data_3$strata_id[final_data_3$dia_semana_internacao == "qua" & final_data_3$Month.x ==10 & final_data_3$Year.x == 2008] <- 66
final_data_3$strata_id[final_data_3$dia_semana_internacao == "qui" & final_data_3$Month.x ==10 & final_data_3$Year.x == 2008] <- 67
final_data_3$strata_id[final_data_3$dia_semana_internacao == "sex" & final_data_3$Month.x ==10 & final_data_3$Year.x == 2008] <- 68
final_data_3$strata_id[final_data_3$dia_semana_internacao == "sab" & final_data_3$Month.x ==10 & final_data_3$Year.x == 2008] <- 69
final_data_3$strata_id[final_data_3$dia_semana_internacao == "dom" & final_data_3$Month.x ==10 & final_data_3$Year.x == 2008] <- 70
  
final_data_3$strata_id[final_data_3$dia_semana_internacao == "seg" & final_data_3$Month.x ==11 & final_data_3$Year.x == 2008] <- 71   
final_data_3$strata_id[final_data_3$dia_semana_internacao == "ter" & final_data_3$Month.x ==11 & final_data_3$Year.x == 2008] <- 72
final_data_3$strata_id[final_data_3$dia_semana_internacao == "qua" & final_data_3$Month.x ==11 & final_data_3$Year.x == 2008] <- 73
final_data_3$strata_id[final_data_3$dia_semana_internacao == "qui" & final_data_3$Month.x ==11 & final_data_3$Year.x == 2008] <- 74
final_data_3$strata_id[final_data_3$dia_semana_internacao == "sex" & final_data_3$Month.x ==11 & final_data_3$Year.x == 2008] <- 75
final_data_3$strata_id[final_data_3$dia_semana_internacao == "sab" & final_data_3$Month.x ==11 & final_data_3$Year.x == 2008] <- 76
final_data_3$strata_id[final_data_3$dia_semana_internacao == "dom" & final_data_3$Month.x ==11 & final_data_3$Year.x == 2008] <- 77
  
final_data_3$strata_id[final_data_3$dia_semana_internacao == "seg" & final_data_3$Month.x ==12 & final_data_3$Year.x == 2008] <- 78   
final_data_3$strata_id[final_data_3$dia_semana_internacao == "ter" & final_data_3$Month.x ==12 & final_data_3$Year.x == 2008] <- 79
final_data_3$strata_id[final_data_3$dia_semana_internacao == "qua" & final_data_3$Month.x ==12 & final_data_3$Year.x == 2008] <- 80
final_data_3$strata_id[final_data_3$dia_semana_internacao == "qui" & final_data_3$Month.x ==12 & final_data_3$Year.x == 2008] <- 81
final_data_3$strata_id[final_data_3$dia_semana_internacao == "sex" & final_data_3$Month.x ==12 & final_data_3$Year.x == 2008] <- 82
final_data_3$strata_id[final_data_3$dia_semana_internacao == "sab" & final_data_3$Month.x ==12 & final_data_3$Year.x == 2008] <- 83
final_data_3$strata_id[final_data_3$dia_semana_internacao == "dom" & final_data_3$Month.x ==12 & final_data_3$Year.x == 2008] <- 84
}


# Sort the data by strata_id
final_data_4 <- final_data_3[order(strata_id),]


### Fit the conditional logistic model:
############################################
library(survival)
help(clogit)


############################################
# Primary model:
model_clogit_1 <- clogit(case ~ pm25_ugm3 + co_ppb + temperatura_c + umidade_relativa_percentual + 
                         vento_direcao_grau + vento_velocidade_ms + precipitacao_mmdia + res_ALTITUDE +
                         def_raca_cor + strata(strata_id), final_data_4)
summary(model_clogit_1)


# Extract the OR with 95% CI:
beta <- summary(model_clogit_1)$coefficients[1,2]
se <- sqrt(summary(model_clogit_1)$coefficients[1,3])
lo95ci=((beta-1.96*se))
hi95ci=((beta+1.96*se))

# Estimate the effect of 'x' change in covariate. Here, I am estimating the effect of a 10 units change in predictor variable.
OR_changes=beta*10
lo95ci_changes=((beta-1.96*se)*10)
hi95ci_changes=((beta+1.96*se)*10)

# Estimate the % increase in outcome (95%CI) by 'x' change in covariate.  
OR_changes_perc=(beta*10)*100
lo95ci_changes_perc=((beta-1.96*se)*10)*100
hi95ci_changes_perc=((beta+1.96*se)*10)*100

##################################################

# Model stratified by sex:
model_clogit_2 <- clogit(case ~ pm25_ugm3 + co_ppb + temperatura_c + umidade_relativa_percentual + 
                         vento_direcao_grau + vento_velocidade_ms + precipitacao_mmdia + res_ALTITUDE +
                         def_raca_cor + strata(strata_id), final_data_4, subset = def_sexo)
summary(model_clogit_2)



### Include the other years in the step above  ----> "Set the strata id"

### Include more predictors --- lat/long of the municipality, some other pollutant.

### Some SES variables are in blank here (e.g., education = "INSTRU"). Take a look at it by applying the summary. Therefore, I have to add
#   SES variables based on the municipality. I have this data from IBGE.

### When I have the full dataset, decide if the exposure will be "pm25_ugm3" or "focos_queimada" (or both of them)

### Stratify by other factors, including regions, age, health outcome etc.

### Sensitivity analyses:
    # Include lag (e.g., 0-5 days) for the exposure and perform the analyses again.
    # Change case/control criteria. For example, instead of the cases being the individuals exposed to one or more wildfire, it could be individuals exposed to more than 10 wildfire





#### Below is the code that I am preparing for the lags. I'm preparing this code here. But, once I finish that,
#### it should be moved at the end of stage 2 above:

data_full <- read.csv("Wildfire_and_covariates.csv")
wildfire_covariates <- data_full


lg <- function(x)c(NA, x[1:(length(x)-1)])
unlist(tapply(wildfire_covariates$pm25_ugm3, wildfire_covariates$mun_geocod, lg))
ddply(wildfire_covariates, ~mun_geocod, transform, lvar = lg(pm25_ugm3))

wildfire_covariates <- data.table(wildfire_covariates)
wildfire_covariates[,lvar := lg(pm25_ugm3), by = c("mun_geocod")]

library(dplyr)
wildfire_covariates %>% group_by(mun_geocod) %>% mutate(lvar = lag(pm25_ugm3))

summary(wildfire_covariates$lvar)    ### Checar aqui se esse lag de -1 realmente funcionou. Fazer um subset só para um município e depois ver a variável "lvar" se ela realmente esta com um lag de -1 dia. Caso sim, fazer para -2, -3, -4, -5 dias.








