

#libs
library(plyr)
library(dplyr)
library(broom)
library(reshape2)
library(ggplot2)
library(tidyr)
library(readr)
library(lubridate)
library(gganimate)
library(xts)
library(grid)
library(knitr)
library(animation)
library(scales)


#goal is to make the phenomic data into a 'tidy' format for subsequent analyses and reproducable science.

#input data is a direct cvs dump of the google sheet used to initially collect  the phenotypic information (SRE & AMH) from 2015-2016

#final measurments coded to the final day in the chamber
#final height, tiller, ear count on March 8th, 2016 - ch02


spring.pheno=read.csv('BVZ0049-phenotyping-record-CH02-Spring.csv',head=T)
spring.pheno = spring.pheno %>% tbl_df()
spring.pheno = within(spring.pheno, rm(X4.4.re.dry.BioMass, Seed.Count, X50seed.Weight))

#growth stages late for hybridum were not measured, marked as '-', converting to numeric and NAs
spring.pheno$Nov13_GrowthStage = as.numeric(as.character(spring.pheno$Nov13_GrowthStage))
spring.pheno$Nov16_GrowthStage = as.numeric(as.character(spring.pheno$Nov16_GrowthStage))

#start making more tidy
test = spring.pheno %>% select(-Dec16_TissueHarvest.DNA.Location, -Dec16_TissueHarvest.RNA.Location) %>% gather(variable,value, 
                               -PlantID, 
                               -PlantName,
                               -Accession, 
                               -ClonalGroup, 
                               -Replicate, 
                               -AccessionID, 
                               -ExperimentID, 
                               -User, 
                               -GrowthLocation, 
                               -TrayPosition, 
                               -PlantingDate, 
                               -IntoChamberDate, 
                               -EmergenceDate, 
                               -EarEmergenceDate)

#pull a column into measurement date to relate to time
test$measurement_date = ifelse(test$variable=='Oct12_GrowthStage','2015-10-12',
                               ifelse(test$variable=='Oct14_GrowthStage','2015-10-14',
                                      ifelse(test$variable=='Oct17_GrowthStage','2015-10-17',
                                             ifelse(test$variable=='Oct19_GrowthStage','2015-10-19',
                                                    ifelse(test$variable=='Oct21_GrowthStage','2015-10-23',
                                                           ifelse(test$variable=='Oct23_GrowthStage','2015-10-23',
                                                                  ifelse(test$variable=='Oct26_GrowthStage','2015-10-26',
                                                                         ifelse(test$variable=='Oct28_GrowthStage','2015-10-28',
                                                                                ifelse(test$variable=='Oct30_GrowthStage','2015-10-30',
                                                                                       ifelse(test$variable=='Nov2_GrowthStage','2015-11-02',
                                                                                              ifelse(test$variable=='Nov4_GrowthStage','2015-11-04',
                                                                                                     ifelse(test$variable=='Nov6_GrowthStage','2015-11-06',
                                                                                                            ifelse(test$variable=='Nov13_GrowthStage','2015-11-13',
                                                                                                                   ifelse(test$variable=='Nov16_GrowthStage','2015-11-16',
                        ifelse(test$variable=='Oct17_Heightcm','2015-10-17',
                               ifelse(test$variable=='Oct23_Heightcm','2015-10-23',
                                      ifelse(test$variable=='Oct30_Heightcm','2015-10-30',
                                             ifelse(test$variable=='Nov6_Heightcm','2015-11-06',
                                                    ifelse(test$variable=='Nov13_Heightcm','2015-11-13',
                                                           ifelse(test$variable=='Nov20_Heightcm','2015-11-20',
                                                                  ifelse(test$variable=='Dec4_Heightcm','2015-12-04',
                                                                         ifelse(test$variable=='Dec11_Heightcm','2015-12-11',
                       ifelse(test$variable=='Nov11_TillerCount','2015-11-11',
                              ifelse(test$variable=='Dec9_TillerCount','2015-12-09',
                                     ifelse(test$variable=='X3rd.Leaf_Width.cm','2015-11-11',
                                            ifelse(test$variable=='X3rd.Leaf_Length.cm','2015-11-11',
                                                   ifelse(test$variable=='Final.Height.cm','2016-02-12',
                                                          ifelse(test$variable=='Final.Tiller.Count','2016-02-12',
                                                                 ifelse(test$variable=='Ear.Count','2016-02-12',
                                                                        ifelse(test$variable=='AboveSoil.BioMass.mg','2016-03-08','nope'))))))))))))))))))))))))))))))
#rename measurements properly
test$variable = ifelse(test$variable=='Oct12_GrowthStage','Growth Stage',
                               ifelse(test$variable=='Oct14_GrowthStage','Growth Stage',
                                      ifelse(test$variable=='Oct17_GrowthStage','Growth Stage',
                                             ifelse(test$variable=='Oct19_GrowthStage','Growth Stage',
                                                    ifelse(test$variable=='Oct21_GrowthStage','Growth Stage',
                                                           ifelse(test$variable=='Oct23_GrowthStage','Growth Stage',
                                                                  ifelse(test$variable=='Oct26_GrowthStage','Growth Stage',
                                                                         ifelse(test$variable=='Oct28_GrowthStage','Growth Stage',
                                                                                ifelse(test$variable=='Oct30_GrowthStage','Growth Stage',
                                                                                       ifelse(test$variable=='Nov2_GrowthStage','Growth Stage',
                                                                                              ifelse(test$variable=='Nov4_GrowthStage','Growth Stage',
                                                                                                     ifelse(test$variable=='Nov6_GrowthStage','Growth Stage',
                                                                                                            ifelse(test$variable=='Nov13_GrowthStage','Growth Stage',
                                                                                                                   ifelse(test$variable=='Nov16_GrowthStage','Growth Stage',
                                                                                                                          ifelse(test$variable=='Oct17_Heightcm','Height',
                                                                                                                                 ifelse(test$variable=='Oct23_Heightcm','Height',
                                                                                                                                        ifelse(test$variable=='Oct30_Heightcm','Height',
                                                                                                                                               ifelse(test$variable=='Nov6_Heightcm','Height',
                                                                                                                                                      ifelse(test$variable=='Nov13_Heightcm','Height',
                                                                                                                                                             ifelse(test$variable=='Nov20_Heightcm','Height',
                                                                                                                                                                    ifelse(test$variable=='Dec4_Heightcm','Height',
                                                                                                                                                                           ifelse(test$variable=='Dec11_Heightcm','Height',
                                                                                                                                                                                  ifelse(test$variable=='Nov11_TillerCount','Tiller Count',
                                                                                                                                                                                         ifelse(test$variable=='Dec9_TillerCount','Tiller Count',
                                                                                                                                                                                                ifelse(test$variable=='X3rd.Leaf_Width.cm','Leaf Width',
                                                                                                                                                                                                       ifelse(test$variable=='X3rd.Leaf_Length.cm','Leaf Length',
                                                                                                                                                                                                              ifelse(test$variable=='Final.Height.cm','Height',
                                                                                                                                                                                                                     ifelse(test$variable=='Final.Tiller.Count','Tiller Count',
                                                                                                                                                                                                                            ifelse(test$variable=='Ear.Count','Ear Count',
                                                                                                                                                                                                                                   ifelse(test$variable=='AboveSoil.BioMass.mg','Biomass','nope'))))))))))))))))))))))))))))))





test = test %>% tbl_df() %>%
  mutate(Replicate = as.factor(Replicate),
         AccessionID = as.factor(AccessionID),
         PlantID = as.factor(PlantID),
         PlantingDate = parse_date_time(PlantingDate, '%m/%d/%y'),
         IntoChamberDate = parse_date_time(IntoChamberDate, '%m/%d/%y'),
         EmergenceDate = parse_date_time(EmergenceDate, '%m/%d/%y'),
         EarEmergenceDate = parse_date_time(EarEmergenceDate, '%m/%d/%y'),
         measurement_date = parse_date_time(measurement_date, '%y/%m/%d'),
         value = as.numeric(as.character(value)))

write.table(test,'BVZ0049_CH02_SPRING_phenotypes_formatted.csv',sep=',',row.names=F,quote=F)

fall.pheno=read.csv('BVZ0049-phenotyping-record-CH05-Fall.csv',head=T)
fall.pheno = fall.pheno %>% tbl_df()
fall.pheno = within(fall.pheno, rm(Seed_Count, X50seed_Weight))

test = fall.pheno %>% select(-ChamberX, -ChamberY,-Jan6TissueHarvest.DNA.Location, 
                             -Jan6.TissueHarvest.RNA.Location) %>% gather(variable,value, 
                               -PlantID, 
                               -PlantName,
                               -Accession, 
                               -ClonalGroup, 
                               -Replicate, 
                               -AccessionID, 
                               -ExperimentID, 
                               -User, 
                               -GrowthLocation, 
                               -TrayPosition,
                               -PlantingDate, 
                               -IntoChamberDate, 
                               -EmergenceDate, 
                               -EarEmergenceDate)

test$measurement_date = ifelse(test$variable=='Sep30_GrowthStage','2015-09-30',
                               ifelse(test$variable=='Oct2_GrowthStage','2015-10-02',
                                      ifelse(test$variable=='Oct5_GrowthStage','2015-10-05',
                                             ifelse(test$variable=='Oct7_GrowthStage','2015-10-07',
                                                    ifelse(test$variable=='Oct9_GrowthStage','2015-10-09',
                                                           ifelse(test$variable=='Oct12_GrowthStage','2015-10-12',
                                                                  ifelse(test$variable=='Oct14_GrowthStage','2015-10-14',
                                                                         ifelse(test$variable=='Oct16_GrowthStage','2015-10-16',
                                                                                ifelse(test$variable=='Oct19_GrowthStage','2015-10-19',
                                                                                       ifelse(test$variable=='Oct21_GrowthStage','2015-10-21',
                                                                                              ifelse(test$variable=='Oct23_GrowthStage','2015-10-23',
                                                                                                     ifelse(test$variable=='Oct26_GrowthStage','2015-10-26',
                                                                                                            ifelse(test$variable=='Oct28_GrowthStage','2015-10-28',
                                                                                                                   ifelse(test$variable=='Oct30_GrowthStage','2015-10-30',
                                                                                                                          ifelse(test$variable=='Nov2_GrowthStage','2015-11-02',
                                                                                                                                 ifelse(test$variable=='Nov4_GrowthStage','2015-11-04',
                                                                                                                                        ifelse(test$variable=='Nov6_GrowthStage','2015-11-06',
                                                                                                                                               ifelse(test$variable=='Nov11_GrowthStage','2015-11-11',
                                                                                                                                                      ifelse(test$variable=='Nov13_GrowthStage','2015-11-13',
                                                                                                                                                             ifelse(test$variable=='Nov16_GrowthStage','2015-11-16',
                                                                                                                                                                    ifelse(test$variable=='Nov18_GrowthStage','2015-11-18',
                                                                                                                                                                           ifelse(test$variable=='Nov25_GrowthStage','2015-11-25',
                                                                                                                                                                                  ifelse(test$variable=='Dec4_GrowthStage','2015-12-04',
                                                                                                                                                                                         ifelse(test$variable=='Dec14_GrowthStage','2015-12-14',
                                                                                                                                                                                                ifelse(test$variable=='Oct2_Heightcm','2015-10-02',
                                                                                                                                                                                                       ifelse(test$variable=='Oct9_Heightcm','2015-10-09',
                                                                                                                                                                                                              ifelse(test$variable=='Oct16_Heightcm','2015-10-16',
                                                                                                                                                                                                                     ifelse(test$variable=='Oct23_Heightcm','2015-10-23',
                                                                                                                                                                                                                            ifelse(test$variable=='Oct30_Heightcm','2015-10-30',
                                                                                                                                                                                                                                   ifelse(test$variable=='Nov6_Heightcm','2015-11-06',
                                                                                                                                                                                                                                          ifelse(test$variable=='Nov13_Heightcm','2015-11-13',
                                                                                                                                                                                                                                                 ifelse(test$variable=='Nov20_Heightcm','2015-11-20',
                                                                                                                                                                                                                                                        ifelse(test$variable=='Dec4_Heightcm','2015-12-04',
                                                                                                                                                                                                                                                               ifelse(test$variable=='Dec14_Heightcm','2015-12-14',
                                                                                                                                                                                                                                                                      ifelse(test$variable=='Jan20_Heightcm','2016-01-20',
                                                                                                                                                                                                                                                                             ifelse(test$variable=='Mar4_Height','2016-03-04',
                                                                                                                                                                                                                                                                                    ifelse(test$variable=='Mar22.23_Height','2016-03-22',
                                                                                                                                                                                                                                                                                           ifelse(test$variable=='Apr12.13_Height','2016-04-12',
                                                                                                                                                                                                                                                                                                  ifelse(test$variable=='Apr27_Height','2016-04-27',
                                                                                                                                                                                                                                                                                                         ifelse(test$variable=='Final_Heightcm','2016-06-03',
                                                                                                                                                                                                                                                                                                                ifelse(test$variable=='Nov11_TillerCount','2015-11-11',
                                                                                                                                                                                                                                                                                                                       ifelse(test$variable=='Jan20_TillerCount','2016-01-20',
                                                                                                                                                                                                                                                                                                                              ifelse(test$variable=='X3rd_Leaf_Width','2015-11-18',
                                                                                                                                                                                                                                                                                                                                     ifelse(test$variable=='X3rd_Leaf_Length','2015-11-18',
                                                                                                                                                                                                                                                                                                                                            ifelse(test$variable=='Final_Tiller_Count','2016-06-03',
                                                                                                                                                                                                                                                                                                                                                   ifelse(test$variable=='Ear_Count','2016-06-08',
                                                                                                                                                                                                                                                                                                                                                          ifelse(test$variable=='AboveSoil_BioMass_mg','2016-06-08','nope')))))))))))))))))))))))))))))))))))))))))))))))


test$variable = ifelse(test$variable=='Sep30_GrowthStage','Growth Stage',
                               ifelse(test$variable=='Oct2_GrowthStage','Growth Stage',
                                      ifelse(test$variable=='Oct5_GrowthStage','Growth Stage',
                                             ifelse(test$variable=='Oct7_GrowthStage','Growth Stage',
                                                    ifelse(test$variable=='Oct9_GrowthStage','Growth Stage',
                                                           ifelse(test$variable=='Oct12_GrowthStage','Growth Stage',
                                                                  ifelse(test$variable=='Oct14_GrowthStage','Growth Stage',
                                                                         ifelse(test$variable=='Oct16_GrowthStage','Growth Stage',
                                                                                ifelse(test$variable=='Oct19_GrowthStage','Growth Stage',
                                                                                       ifelse(test$variable=='Oct21_GrowthStage','Growth Stage',
                                                                                              ifelse(test$variable=='Oct23_GrowthStage','Growth Stage',
                                                                                                     ifelse(test$variable=='Oct26_GrowthStage','Growth Stage',
                                                                                                            ifelse(test$variable=='Oct28_GrowthStage','Growth Stage',
                                                                                                                   ifelse(test$variable=='Oct30_GrowthStage','Growth Stage',
                                                                                                                          ifelse(test$variable=='Nov2_GrowthStage','Growth Stage',
                                                                                                                                 ifelse(test$variable=='Nov4_GrowthStage','Growth Stage',
                                                                                                                                        ifelse(test$variable=='Nov6_GrowthStage','Growth Stage',
                                                                                                                                               ifelse(test$variable=='Nov11_GrowthStage','Growth Stage',
                                                                                                                                                      ifelse(test$variable=='Nov13_GrowthStage','Growth Stage',
                                                                                                                                                             ifelse(test$variable=='Nov16_GrowthStage','Growth Stage',
                                                                                                                                                                    ifelse(test$variable=='Nov18_GrowthStage','Growth Stage',
                                                                                                                                                                           ifelse(test$variable=='Nov25_GrowthStage','Growth Stage',
                                                                                                                                                                                  ifelse(test$variable=='Dec4_GrowthStage','Growth Stage',
                                                                                                                                                                                         ifelse(test$variable=='Dec14_GrowthStage','Growth Stage',
                                                                                                                                                                                                ifelse(test$variable=='Oct2_Heightcm','Height',
                                                                                                                                                                                                       ifelse(test$variable=='Oct9_Heightcm','Height',
                                                                                                                                                                                                              ifelse(test$variable=='Oct16_Heightcm','Height',
                                                                                                                                                                                                                     ifelse(test$variable=='Oct23_Heightcm','Height',
                                                                                                                                                                                                                            ifelse(test$variable=='Oct30_Heightcm','Height',
                                                                                                                                                                                                                                   ifelse(test$variable=='Nov6_Heightcm','Height',
                                                                                                                                                                                                                                          ifelse(test$variable=='Nov13_Heightcm','Height',
                                                                                                                                                                                                                                                 ifelse(test$variable=='Nov20_Heightcm','Height',
                                                                                                                                                                                                                                                        ifelse(test$variable=='Dec4_Heightcm','Height',
                                                                                                                                                                                                                                                               ifelse(test$variable=='Dec14_Heightcm','Height',
                                                                                                                                                                                                                                                                      ifelse(test$variable=='Jan20_Heightcm','Height',
                                                                                                                                                                                                                                                                             ifelse(test$variable=='Mar4_Height','Height',
                                                                                                                                                                                                                                                                                    ifelse(test$variable=='Mar22.23_Height','Height',
                                                                                                                                                                                                                                                                                           ifelse(test$variable=='Apr12.13_Height','Height',
                                                                                                                                                                                                                                                                                                  ifelse(test$variable=='Apr27_Height','Height',
                                                                                                                                                                                                                                                                                                         ifelse(test$variable=='Final_Heightcm','Height',
                                                                                                                                                                                                                                                                                                                ifelse(test$variable=='Nov11_TillerCount','Tiller Count',
                                                                                                                                                                                                                                                                                                                       ifelse(test$variable=='Jan20_TillerCount','Tiller Count',
                                                                                                                                                                                                                                                                                                                              ifelse(test$variable=='X3rd_Leaf_Width','Leaf Width',
                                                                                                                                                                                                                                                                                                                                     ifelse(test$variable=='X3rd_Leaf_Length','Leaf Length',
                                                                                                                                                                                                                                                                                                                                            ifelse(test$variable=='Final_Tiller_Count','Tiller Count',
                                                                                                                                                                                                                                                                                                                                                   ifelse(test$variable=='Ear_Count','Ear Count',
                                                                                                                                                                                                                                                                                                                                                          ifelse(test$variable=='AboveSoil_BioMass_mg','Biomass','nope')))))))))))))))))))))))))))))))))))))))))))))))

test = test %>% tbl_df() %>%
  mutate(Replicate = as.factor(Replicate),
         AccessionID = as.factor(AccessionID),
         PlantID = as.factor(PlantID),
         PlantingDate = parse_date_time(PlantingDate, '%m/%d/%y'),
         IntoChamberDate = parse_date_time(IntoChamberDate, '%m/%d/%y'),
         EmergenceDate = parse_date_time(EmergenceDate, '%m/%d/%y'),
         EarEmergenceDate = parse_date_time(EarEmergenceDate, '%m/%d/%y'),
         measurement_date = parse_date_time(measurement_date, '%y/%m/%d'),
         value = as.numeric(as.character(value)))

write.table(test,'BVZ0049_CH05_FALL_phenotypes_formatted.csv',sep=',',row.names=F,quote=F)
