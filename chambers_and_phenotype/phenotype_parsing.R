

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

test = melt(spring.pheno, id.vars=c('PlantID',
                            'PlantName',
                            'Accession',
                            'ClonalGroup',
                            'Replicate',
                            'AccessionID',
                            'ExperimentID',
                            'User',
                            'GrowthLocation',
                            'TrayPosition',
                            'PlantingDate',
                            'IntoChamberDate',
                            'EmergenceDate',
                            'EarEmergenceDate',
                            'Dec16_TissueHarvest.DNA.Location',
                            'Dec16_TissueHarvest.RNA.Location'))
attach(test)
test$measurement_date = ifelse(variable=='Oct12_GrowthStage','2015-10-12',
                               ifelse(variable=='Oct14_GrowthStage','2015-10-14',
                                      ifelse(variable=='Oct17_GrowthStage','2015-10-17',
                                             ifelse(variable=='Oct19_GrowthStage','2015-10-19',
                                                    ifelse(variable=='Oct21_GrowthStage','2015-10-23',
                                                           ifelse(variable=='Oct23_GrowthStage','2015-10-23',
                                                                  ifelse(variable=='Oct26_GrowthStage','2015-10-26',
                                                                         ifelse(variable=='Oct28_GrowthStage','2015-10-28',
                                                                                ifelse(variable=='Oct30_GrowthStage','2015-10-30',
                                                                                       ifelse(variable=='Nov2_GrowthStage','2015-11-02',
                                                                                              ifelse(variable=='Nov4_GrowthStage','2015-11-04',
                                                                                                     ifelse(variable=='Nov6_GrowthStage','2015-11-06',
                                                                                                            ifelse(variable=='Nov13_GrowthStage','2015-11-13',
                                                                                                                   ifelse(variable=='Nov16_GrowthStage','2015-11-16',
                        ifelse(variable=='Oct17_Heightcm','2015-10-17',
                               ifelse(variable=='Oct23_Heightcm','2015-10-23',
                                      ifelse(variable=='Oct30_Heightcm','2015-10-30',
                                             ifelse(variable=='Nov6_Heightcm','2015-11-06',
                                                    ifelse(variable=='Nov13_Heightcm','2015-11-13',
                                                           ifelse(variable=='Nov20_Heightcm','2015-11-20',
                                                                  ifelse(variable=='Dec4_Heightcm','2015-12-04',
                                                                         ifelse(variable=='Dec11_Heightcm','2015-12-11',
                       ifelse(variable=='Nov11_TillerCount','2015-11-11',
                              ifelse(variable=='Dec9_TillerCount','2015-12-09',
                                     ifelse(variable=='X3rd.Leaf_Width.cm','2015-11-11',
                                            ifelse(variable=='X3rd.Leaf_Length.cm','2015-11-11',
                                                   ifelse(variable=='Final.Height.cm','2016-02-12',
                                                          ifelse(variable=='Final.Tiller.Count','2016-02-12',
                                                                 ifelse(variable=='Ear.Count','2016-02-12',
                                                                        ifelse(variable=='AboveSoil.BioMass.mg','2016-03-08','nope'))))))))))))))))))))))))))))))

test$variable = ifelse(variable=='Oct12_GrowthStage','Growth Stage',
                               ifelse(variable=='Oct14_GrowthStage','Growth Stage',
                                      ifelse(variable=='Oct17_GrowthStage','Growth Stage',
                                             ifelse(variable=='Oct19_GrowthStage','Growth Stage',
                                                    ifelse(variable=='Oct21_GrowthStage','Growth Stage',
                                                           ifelse(variable=='Oct23_GrowthStage','Growth Stage',
                                                                  ifelse(variable=='Oct26_GrowthStage','Growth Stage',
                                                                         ifelse(variable=='Oct28_GrowthStage','Growth Stage',
                                                                                ifelse(variable=='Oct30_GrowthStage','Growth Stage',
                                                                                       ifelse(variable=='Nov2_GrowthStage','Growth Stage',
                                                                                              ifelse(variable=='Nov4_GrowthStage','Growth Stage',
                                                                                                     ifelse(variable=='Nov6_GrowthStage','Growth Stage',
                                                                                                            ifelse(variable=='Nov13_GrowthStage','Growth Stage',
                                                                                                                   ifelse(variable=='Nov16_GrowthStage','Growth Stage',
                                                                                                                          ifelse(variable=='Oct17_Heightcm','Height',
                                                                                                                                 ifelse(variable=='Oct23_Heightcm','Height',
                                                                                                                                        ifelse(variable=='Oct30_Heightcm','Height',
                                                                                                                                               ifelse(variable=='Nov6_Heightcm','Height',
                                                                                                                                                      ifelse(variable=='Nov13_Heightcm','Height',
                                                                                                                                                             ifelse(variable=='Nov20_Heightcm','Height',
                                                                                                                                                                    ifelse(variable=='Dec4_Heightcm','Height',
                                                                                                                                                                           ifelse(variable=='Dec11_Heightcm','Height',
                                                                                                                                                                                  ifelse(variable=='Nov11_TillerCount','Tiller Count',
                                                                                                                                                                                         ifelse(variable=='Dec9_TillerCount','Tiller Count',
                                                                                                                                                                                                ifelse(variable=='X3rd.Leaf_Width.cm','Leaf Width',
                                                                                                                                                                                                       ifelse(variable=='X3rd.Leaf_Length.cm','Leaf Length',
                                                                                                                                                                                                              ifelse(variable=='Final.Height.cm','Height',
                                                                                                                                                                                                                     ifelse(variable=='Final.Tiller.Count','Tiller Count',
                                                                                                                                                                                                                            ifelse(variable=='Ear.Count','Ear Count',
                                                                                                                                                                                                                                   ifelse(variable=='AboveSoil.BioMass.mg','Biomass','nope'))))))))))))))))))))))))))))))





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

test = melt(fall.pheno, id.vars=c('PlantID',
                                    'PlantName',
                                    'Accession',
                                    'ClonalGroup',
                                  'Replicate',
                                    'AccessionID',
                                    'ExperimentID',
                                    'User',
                                    'GrowthLocation',
                                    'TrayPosition',
                                    'ChamberX',
                                  'ChamberY',
                                  'PlantingDate',
                                    'IntoChamberDate',
                                    'EmergenceDate',
                                    'EarEmergenceDate',
                                    'Jan6TissueHarvest.DNA.Location',
                                    'Jan6.TissueHarvest.RNA.Location'))
attach(test)
test$measurement_date = ifelse(variable=='Sep30_GrowthStage','2015-09-30',
                               ifelse(variable=='Oct2_GrowthStage','2015-10-02',
                                      ifelse(variable=='Oct5_GrowthStage','2015-10-05',
                                             ifelse(variable=='Oct7_GrowthStage','2015-10-07',
                                                    ifelse(variable=='Oct9_GrowthStage','2015-10-09',
                                                           ifelse(variable=='Oct12_GrowthStage','2015-10-12',
                                                                  ifelse(variable=='Oct14_GrowthStage','2015-10-14',
                                                                         ifelse(variable=='Oct16_GrowthStage','2015-10-16',
                                                                                ifelse(variable=='Oct19_GrowthStage','2015-10-19',
                                                                                       ifelse(variable=='Oct21_GrowthStage','2015-10-21',
                                                                                              ifelse(variable=='Oct23_GrowthStage','2015-10-23',
                                                                                                     ifelse(variable=='Oct26_GrowthStage','2015-10-26',
                                                                                                            ifelse(variable=='Oct28_GrowthStage','2015-10-28',
                                                                                                                   ifelse(variable=='Oct30_GrowthStage','2015-10-30',
                                                                                                                          ifelse(variable=='Nov2_GrowthStage','2015-11-02',
                                                                                                                                 ifelse(variable=='Nov4_GrowthStage','2015-11-04',
                                                                                                                                        ifelse(variable=='Nov6_GrowthStage','2015-11-06',
                                                                                                                                               ifelse(variable=='Nov11_GrowthStage','2015-11-11',
                                                                                                                                                      ifelse(variable=='Nov13_GrowthStage','2015-11-13',
                                                                                                                                                             ifelse(variable=='Nov16_GrowthStage','2015-11-16',
                                                                                                                                                                    ifelse(variable=='Nov18_GrowthStage','2015-11-18',
                                                                                                                                                                           ifelse(variable=='Nov25_GrowthStage','2015-11-25',
                                                                                                                                                                                  ifelse(variable=='Dec4_GrowthStage','2015-12-04',
                                                                                                                                                                                         ifelse(variable=='Dec14_GrowthStage','2015-12-14',
                                                                                                                                                                                                ifelse(variable=='Oct2_Heightcm','2015-10-02',
                                                                                                                                                                                                       ifelse(variable=='Oct9_Heightcm','2015-10-09',
                                                                                                                                                                                                              ifelse(variable=='Oct16_Heightcm','2015-10-16',
                                                                                                                                                                                                                     ifelse(variable=='Oct23_Heightcm','2015-10-23',
                                                                                                                                                                                                                            ifelse(variable=='Oct30_Heightcm','2015-10-30',
                                                                                                                                                                                                                                   ifelse(variable=='Nov6_Heightcm','2015-11-06',
                                                                                                                                                                                                                                          ifelse(variable=='Nov13_Heightcm','2015-11-13',
                                                                                                                                                                                                                                                 ifelse(variable=='Nov20_Heightcm','2015-11-20',
                                                                                                                                                                                                                                                        ifelse(variable=='Dec4_Heightcm','2015-12-04',
                                                                                                                                                                                                                                                               ifelse(variable=='Dec14_Heightcm','2015-12-14',
                                                                                                                                                                                                                                                                      ifelse(variable=='Jan20_Heightcm','2016-01-20',
                                                                                                                                                                                                                                                                             ifelse(variable=='Mar4_Height','2016-03-04',
                                                                                                                                                                                                                                                                                    ifelse(variable=='Mar22.23_Height','2016-03-22',
                                                                                                                                                                                                                                                                                           ifelse(variable=='Apr12.13_Height','2016-04-12',
                                                                                                                                                                                                                                                                                                  ifelse(variable=='Apr27_Height','2016-04-27',
                                                                                                                                                                                                                                                                                                         ifelse(variable=='Final_Heightcm','2016-06-03',
                                                                                                                                                                                                                                                                                                                ifelse(variable=='Nov11_TillerCount','2015-11-11',
                                                                                                                                                                                                                                                                                                                       ifelse(variable=='Jan20_TillerCount','2016-01-20',
                                                                                                                                                                                                                                                                                                                              ifelse(variable=='X3rd_Leaf_Width','2015-11-18',
                                                                                                                                                                                                                                                                                                                                     ifelse(variable=='X3rd_Leaf_Length','2015-11-18',
                                                                                                                                                                                                                                                                                                                                            ifelse(variable=='Final_Tiller_Count','2016-06-03',
                                                                                                                                                                                                                                                                                                                                                   ifelse(variable=='Ear_Count','2016-06-08',
                                                                                                                                                                                                                                                                                                                                                          ifelse(variable=='AboveSoil_BioMass_mg','2016-06-08','nope')))))))))))))))))))))))))))))))))))))))))))))))


test$variable = ifelse(variable=='Sep30_GrowthStage','Growth Stage',
                               ifelse(variable=='Oct2_GrowthStage','Growth Stage',
                                      ifelse(variable=='Oct5_GrowthStage','Growth Stage',
                                             ifelse(variable=='Oct7_GrowthStage','Growth Stage',
                                                    ifelse(variable=='Oct9_GrowthStage','Growth Stage',
                                                           ifelse(variable=='Oct12_GrowthStage','Growth Stage',
                                                                  ifelse(variable=='Oct14_GrowthStage','Growth Stage',
                                                                         ifelse(variable=='Oct16_GrowthStage','Growth Stage',
                                                                                ifelse(variable=='Oct19_GrowthStage','Growth Stage',
                                                                                       ifelse(variable=='Oct21_GrowthStage','Growth Stage',
                                                                                              ifelse(variable=='Oct23_GrowthStage','Growth Stage',
                                                                                                     ifelse(variable=='Oct26_GrowthStage','Growth Stage',
                                                                                                            ifelse(variable=='Oct28_GrowthStage','Growth Stage',
                                                                                                                   ifelse(variable=='Oct30_GrowthStage','Growth Stage',
                                                                                                                          ifelse(variable=='Nov2_GrowthStage','Growth Stage',
                                                                                                                                 ifelse(variable=='Nov4_GrowthStage','Growth Stage',
                                                                                                                                        ifelse(variable=='Nov6_GrowthStage','Growth Stage',
                                                                                                                                               ifelse(variable=='Nov11_GrowthStage','Growth Stage',
                                                                                                                                                      ifelse(variable=='Nov13_GrowthStage','Growth Stage',
                                                                                                                                                             ifelse(variable=='Nov16_GrowthStage','Growth Stage',
                                                                                                                                                                    ifelse(variable=='Nov18_GrowthStage','Growth Stage',
                                                                                                                                                                           ifelse(variable=='Nov25_GrowthStage','Growth Stage',
                                                                                                                                                                                  ifelse(variable=='Dec4_GrowthStage','Growth Stage',
                                                                                                                                                                                         ifelse(variable=='Dec14_GrowthStage','Growth Stage',
                                                                                                                                                                                                ifelse(variable=='Oct2_Heightcm','Height',
                                                                                                                                                                                                       ifelse(variable=='Oct9_Heightcm','Height',
                                                                                                                                                                                                              ifelse(variable=='Oct16_Heightcm','Height',
                                                                                                                                                                                                                     ifelse(variable=='Oct23_Heightcm','Height',
                                                                                                                                                                                                                            ifelse(variable=='Oct30_Heightcm','Height',
                                                                                                                                                                                                                                   ifelse(variable=='Nov6_Heightcm','Height',
                                                                                                                                                                                                                                          ifelse(variable=='Nov13_Heightcm','Height',
                                                                                                                                                                                                                                                 ifelse(variable=='Nov20_Heightcm','Height',
                                                                                                                                                                                                                                                        ifelse(variable=='Dec4_Heightcm','Height',
                                                                                                                                                                                                                                                               ifelse(variable=='Dec14_Heightcm','Height',
                                                                                                                                                                                                                                                                      ifelse(variable=='Jan20_Heightcm','Height',
                                                                                                                                                                                                                                                                             ifelse(variable=='Mar4_Height','Height',
                                                                                                                                                                                                                                                                                    ifelse(variable=='Mar22.23_Height','Height',
                                                                                                                                                                                                                                                                                           ifelse(variable=='Apr12.13_Height','Height',
                                                                                                                                                                                                                                                                                                  ifelse(variable=='Apr27_Height','Height',
                                                                                                                                                                                                                                                                                                         ifelse(variable=='Final_Heightcm','Height',
                                                                                                                                                                                                                                                                                                                ifelse(variable=='Nov11_TillerCount','Tiller Count',
                                                                                                                                                                                                                                                                                                                       ifelse(variable=='Jan20_TillerCount','Tiller Count',
                                                                                                                                                                                                                                                                                                                              ifelse(variable=='X3rd_Leaf_Width','Leaf Width',
                                                                                                                                                                                                                                                                                                                                     ifelse(variable=='X3rd_Leaf_Length','Leaf Length',
                                                                                                                                                                                                                                                                                                                                            ifelse(variable=='Final_Tiller_Count','Tiller Count',
                                                                                                                                                                                                                                                                                                                                                   ifelse(variable=='Ear_Count','Ear Count',
                                                                                                                                                                                                                                                                                                                                                          ifelse(variable=='AboveSoil_BioMass_mg','Biomass','nope')))))))))))))))))))))))))))))))))))))))))))))))

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
