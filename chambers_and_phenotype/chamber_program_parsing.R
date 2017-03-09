
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

setconditions.spring=read.csv('BVZ0049_SPRING_CH02_program.csv',head=T)

setconditions.spring = setconditions.spring %>% 
  tbl_df() %>% 
  mutate(sim.date = parse_date_time(matrix(unlist(strsplit(as.character(Simulated.Date.Time),' ')),ncol=2,byrow=T)[,1], 'd/m/y')) %>% 
  mutate(sim.time = parse_date_time(matrix(unlist(strsplit(as.character(Simulated.Date.Time),' ')),ncol=2,byrow=T)[,2], 'H:M')) %>%
  mutate(Simulated.Date.Time = parse_date_time(as.character(Simulated.Date.Time),'d/m/y H:M')) %>%
  mutate(real.date.time = parse_date_time(paste(as.character(Date), as.character(Time), sep=':'), 'd/m/y:H:M')) %>%
  mutate(Date = parse_date_time(as.character(Date), 'd/m/y')) %>%
  mutate(Time = parse_date_time(as.character(Time),'HM')) 


setconditions.fall=read.csv('BVZ0049_FALL_CH05_program.csv',head=T)

setconditions.fall = setconditions.fall %>% 
  tbl_df() %>% 
  mutate(sim.date = parse_date_time(matrix(unlist(strsplit(as.character(Simulated.Date.Time),' ')),ncol=2,byrow=T)[,1], 'd/m/y')) %>% 
  mutate(sim.time = parse_date_time(matrix(unlist(strsplit(as.character(Simulated.Date.Time),' ')),ncol=2,byrow=T)[,2], 'H:M')) %>%
  mutate(Simulated.Date.Time = parse_date_time(as.character(Simulated.Date.Time),'d/m/y H:M')) %>%
  mutate(real.date.time = parse_date_time(paste(as.character(Date), as.character(Time), sep=':'), 'd/m/y:H:M')) %>%
  mutate(Date = parse_date_time(as.character(Date), 'd/m/y')) %>%
  mutate(Time = parse_date_time(as.character(Time),'HM')) 

merged.conditions=merge(setconditions.spring,setconditions.fall,by='real.date.time')
merged.dates= merged.conditions %>% group_by(Date.x) %>% select(Date.x,sim.date.x,sim.date.y) %>% unique()

#read in watering dates
watering.dates=read.csv('BVZ0049_watering_dates.csv',head=T)
watering.dates = watering.dates %>% tbl_df() %>% mutate(real_date = parse_date_time(real_date,'d/m/y'))

#add watering times to merged.dates
merged.dates= merge(merged.dates,watering.dates,by.x='Date.x',by.y='real_date',all.x=T)


#read in chamber logs spring (ch02)
logs.spring=read.csv('BVZ0049_SPRING_CH02-COND-LOG.csv',head=T)

logs.spring = logs.spring %>% tbl_df() %>% mutate(Date = parse_date_time(Date,'y/m/d')) %>%
  mutate(Time = parse_date_time(Time,'H:M:S'))

logs.spring.date = logs.spring %>% group_by(Date) %>%
  summarise(mean_temp = mean(Temp),
            max_temp = max(Temp),
            min_temp = min(Temp))
logs.spring.date=merge(logs.spring.date,merged.dates,by.x='Date',by.y='Date.x')
logs.spring.date=subset(logs.spring.date,logs.spring.date$sim.date.x > as.POSIXct('2012-04-26') & logs.spring.date$sim.date.x < as.POSIXct('2012-09-06'))


#read in chamber logs spring (ch05)
logs.fall=read.csv('BVZ0049_FALL_CH05-COND-LOG.csv',head=T)

logs.fall = logs.fall %>% tbl_df() %>% mutate(Date = parse_date_time(Date,'y/m/d')) %>%
  mutate(Time = parse_date_time(Time,'H:M:S'))

logs.fall.date = logs.fall %>% group_by(Date) %>%
  summarise(mean_temp = mean(Temp),
            max_temp = max(Temp),
            min_temp = min(Temp))

logs.fall.date=merge(logs.fall.date,merged.dates,by.x='Date',by.y='Date.x')
logs.fall.date.start=subset(logs.fall.date,logs.fall.date$sim.date.y > as.POSIXct('2012-10-16'))
logs.fall.date.end = subset(logs.fall.date,logs.fall.date$sim.date.y < as.POSIXct('2012-06-28'))




setconditions.dayavg = setconditions.spring %>% 
  group_by(sim.date) %>% 
  summarise(mean_temp = mean(ChamTemp),
            max_temp = max(ChamTemp),
            min_temp = min(ChamTemp),
            mean_rh=mean(ChamRH),
            max_rh=max(ChamRH), 
            min_rh=min(ChamRH),
            mean_solar=mean(Total.Solar..Watt.m2.),
            max_solar=max(Total.Solar..Watt.m2.),
            min_solar=min(Total.Solar..Watt.m2.))

#plot it all out
pdf('BVZ0049_condition_summary.pdf',height=8,width=11)
ggplot(setconditions.dayavg,aes(x=sim.date, y=mean_temp)) + 
  geom_ribbon(aes(ymax=max_temp,ymin=min_temp),alpha=0.2,fill='red') + 
  geom_line(size=1) + 
  geom_rect(aes(xmin=as.POSIXct('2012-04-26'),xmax=as.POSIXct('2012-09-06'),ymin=0,ymax=1),fill='green',alpha=0.5) +
  geom_rect(aes(xmin=as.POSIXct('2012-10-16'),xmax=as.POSIXct('2012-12-31'),ymin=2,ymax=3),fill='orange',alpha=0.5) +
  geom_rect(aes(xmin=as.POSIXct('2012-01-01'),xmax=as.POSIXct('2012-06-28'),ymin=2,ymax=3),fill='orange',alpha=0.5) +
  geom_point(data=subset(merged.dates,merged.dates$ch2_water=='x'),inherit.aes=F,aes(x=sim.date.x,y=0.5),col='blue') +
  geom_point(data=subset(merged.dates,merged.dates$ch5_water=='x'),inherit.aes=F,aes(x=sim.date.y,y=2.5),col='blue') +
  geom_line(data=logs.spring.date,inherit.aes = F, aes(sim.date.x,mean_temp),col='green') +
  geom_ribbon(data=logs.spring.date,inherit.aes = F,aes(sim.date.x,ymax=max_temp,ymin=min_temp),alpha=0.4,fill='green')+
  geom_line(data=logs.fall.date.start,inherit.aes = F, aes(sim.date.y,mean_temp),col='orange') +
  geom_ribbon(data=logs.fall.date.start,inherit.aes = F,aes(sim.date.y,ymax=max_temp,ymin=min_temp),alpha=0.4,fill='orange') +
  geom_line(data=logs.fall.date.end,inherit.aes = F, aes(sim.date.y,mean_temp),col='orange') +
  geom_ribbon(data=logs.fall.date.end,inherit.aes = F,aes(sim.date.y,ymax=max_temp,ymin=min_temp),alpha=0.4,fill='orange') +
  geom_hline(yintercept=5) +
  annotate('text',x=as.POSIXct('2012-05-13'),y=1.5,label = 'Spring Planting') +
  annotate('text',x=as.POSIXct('2012-10-30'),y=3.5,label = 'Fall Planting') +
  ggtitle('BVZ0049 - Simulated year for CH02 and CH05') +
  xlab('Simulated chamber date') +
  ylab('Mean Temp (C)') +
  theme_bw()
dev.off()

#plot it all in polar coords

pdf('BVZ0049_condition_summary_polar.pdf',height=10,width=10)
ggplot(setconditions.dayavg,aes(x=sim.date, y=mean_temp)) + 
  geom_ribbon(aes(ymax=max_temp,ymin=min_temp),alpha=0.2,fill='red') + 
  geom_line(size=1) + 
  geom_rect(aes(xmin=as.POSIXct('2012-04-26'),xmax=as.POSIXct('2012-09-06'),ymin=30,ymax=31),fill='green',alpha=0.5) +
  geom_rect(aes(xmin=as.POSIXct('2012-10-16'),xmax=as.POSIXct('2012-12-31'),ymin=32,ymax=33),fill='orange',alpha=0.5) +
  geom_rect(aes(xmin=as.POSIXct('2012-01-01'),xmax=as.POSIXct('2012-06-28'),ymin=32,ymax=33),fill='orange',alpha=0.5) +
  geom_point(data=subset(merged.dates,merged.dates$ch2_water=='x'),inherit.aes=F,aes(x=sim.date.x,y=30.5),col='blue') +
  geom_point(data=subset(merged.dates,merged.dates$ch5_water=='x'),inherit.aes=F,aes(x=sim.date.y,y=32.5),col='blue') +
  geom_line(data=logs.spring.date,inherit.aes = F, aes(sim.date.x,mean_temp),col='green') +
  geom_ribbon(data=logs.spring.date,inherit.aes = F,aes(sim.date.x,ymax=max_temp,ymin=min_temp),alpha=0.4,fill='green')+
  geom_line(data=logs.fall.date.start,inherit.aes = F, aes(sim.date.y,mean_temp),col='orange') +
  geom_ribbon(data=logs.fall.date.start,inherit.aes = F,aes(sim.date.y,ymax=max_temp,ymin=min_temp),alpha=0.4,fill='orange') +
  geom_line(data=logs.fall.date.end,inherit.aes = F, aes(sim.date.y,mean_temp),col='orange') +
  geom_ribbon(data=logs.fall.date.end,inherit.aes = F,aes(sim.date.y,ymax=max_temp,ymin=min_temp),alpha=0.4,fill='orange') +
  geom_hline(yintercept=5) +
  annotate('text',x=as.POSIXct('2012-05-13'),y=31.5,label = 'Spring Planting') +
  annotate('text',x=as.POSIXct('2012-10-30'),y=33.5,label = 'Fall Planting') +
  ggtitle('BVZ0049 - Simulated year for CH02 and CH05') +
  xlab('Simulated chamber date') +
  ylab('Mean Temp (C)') +
  theme_bw() + coord_polar()
dev.off()



#cumulative sum of temp over the year
ggplot(setconditions.dayavg,aes(sim.date,cumsum(mean_temp))) + 
  geom_line(size=1) + 
  geom_ribbon(aes(ymax=cumsum(max_temp),ymin=cumsum(min_temp)),fill='red',alpha=0.2) + 
  geom_line()