# Script for analysis of VIS image analysis and water data
library(ggplot2)
library(lubridate)
library(MASS)
library(plyr)
library(car)
library(RColorBrewer)
library(Hmisc)
library(gridExtra)
library(Biobase)
library(fields)
library(plot3D)
library(gtools)
library(gplots)
library(scales)
library(reshape)
library(moments)
library(nlme)
library(mvtnorm)
library(grid)
library(lme4)

dir<-"~/Desktop/r/"
setwd(dir)

############################################
# Read data and format for analysis
############################################


# Read pcv2 data
pcv2.data = read.table(file="pcv2-areatest-050417.csv",sep="\t",header=TRUE)

# read nb data
nb.data=read.table(file="pcv2-nb-areatest-050417.csv", sep="\t", header=TRUE)

pcv2.data$genotype<-NA
pcv2.data$genotype[grep("Dp1",pcv2.data$plantbarcode)]<-"A10"
pcv2.data$genotype[grep("Dp2",pcv2.data$plantbarcode)]<-"B100"

nb.data$genotype<-NA
nb.data$genotype[grep("Dp1",pcv2.data$plantbarcode)]<-"A10"
nb.data$genotype[grep("Dp2",pcv2.data$plantbarcode)]<-"B100"

pcv2.data$treatment<-NA
pcv2.data$treatment[grep("AA",pcv2.data$plantbarcode)]<-100
pcv2.data$treatment[grep("AB",pcv2.data$plantbarcode)]<-0
pcv2.data$treatment[grep("AC",pcv2.data$plantbarcode)]<-0
pcv2.data$treatment[grep("AD",pcv2.data$plantbarcode)]<-33
pcv2.data$treatment[grep("AE",pcv2.data$plantbarcode)]<-66

nb.data$treatment<-NA
nb.data$treatment[grep("AA",pcv2.data$plantbarcode)]<-100
nb.data$treatment[grep("AB",pcv2.data$plantbarcode)]<-0
nb.data$treatment[grep("AC",pcv2.data$plantbarcode)]<-0
nb.data$treatment[grep("AD",pcv2.data$plantbarcode)]<-33
nb.data$treatment[grep("AE",pcv2.data$plantbarcode)]<-66


pcv2.sub<-subset(pcv2.data, select=c(image, camera,genotype,treatment, area, hull.area))

nb.sub<-subset(nb.data,select=c(image,camera,barcode,genotype,treatment,area,hull.area))

merged<-merge(pcv2.sub, nb.sub, by="image", all.x=FALSE, all.y=FALSE)

merged.sv<-merged[merged$camera=="SV" & merged$treatment!=0,]
merged.tv<-merged[merged$camera=="TV" & merged$treatment!=0,]

lm_eqn = function(df){
  m = lm(area.y ~ area.x, df);
  eq <- substitute(italic(y) == a + b %.% italic(x)*","~~italic(r)^2~"="~r2, 
                   list(a = format(coef(m)[1], digits = 2), 
                        b = format(coef(m)[2], digits = 2), 
                        r2 = format(summary(m)$r.squared, digits = 4)))
  as.character(as.expression(eq));                 
}

eq1<-lm_eqn(merged.sv)
eq2<-lm_eqn(merged.tv)

sv<-ggplot(merged.sv, aes(x=area.x, y=area.y))+
  geom_point(aes(group=genotype, color=genotype),size=1)+
  geom_smooth(method="lm", color="black")+
  scale_x_continuous("PlantCV Shoot and leaf area (px)") +
  scale_y_continuous("PlantCV Naive-Bayes Shoot and leaf area (px))") +
  theme_bw() +
  annotate("text",x=100000,y=350000,label="y=1460 + 0.95x, R2=0.99")+
  theme(legend.position=c(0.2,0.8),
        axis.title.x=element_text(face="bold"),
        axis.title.y=element_text(face="bold"))

tv<-ggplot(merged.tv, aes(x=area.x, y=area.y))+
  geom_point(aes(group=genotype,color=genotype),size=1)+
  geom_smooth(method="lm", color="black")+
  scale_x_continuous("PlantCV Shoot and leaf area (px)") +
  scale_y_continuous("PlantCV Naive-Bayes Shoot and leaf area (px)") +
  theme_bw() +
  annotate("text",x=100000,y=1200000,label="y=9787 + 1.1x, R2=0.96")+
  theme(legend.position=c(0.2,0.8),
        axis.title.x=element_text(face="bold"),
        axis.title.y=element_text(face="bold"))

pdf(file="pcv2-nb-comparison.pdf",width=6,height=6,useDingbats = FALSE)
grid.arrange(sv,tv,nrow=2)
invisible(dev.off())

