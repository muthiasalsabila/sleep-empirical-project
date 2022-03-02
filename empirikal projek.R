setwd("C:/users/tough/OneDrive/dokumen/R")
getwd()
dir()

#installing packages 
install.packages("readxl")
install.packages("Rcpp")


#Required Packages:
install.packages("wooldridge")
install.packages("carData")
install.packages("psych")
install.packages("car")

#library (data.table)
install.packages("plm")
install.packages("lmtest")
install.packages("stargazer")
install.packages("Hmisc")


library(readxl)
library(wooldridge)
library(carData)
library(psych)
library(car)
library(plm)
library(lmtest)
library(stargazer)
library(Hmisc)
library(Rcpp)
library(ggplot2)

sleeping <- read_excel("data/sleeping.xls")
sleeping <- as.data.frame(sleeping)

data(sleep75, package = "wooldridge")

dataset7_sleepingw <- as.data.frame(sleep75)
tail(dataset7_sleepingw) #makesure tail of hrwage date are NA
work <- lm(totwrk ~ hrwage)
plot(sleep75$totwrk, sleep$hrwage)
abline(totwrk)
str(sleep75)
qplot(hrwage,totwrk, data = sleep75)
ggplot(sleep75, aes(totwrk, hrwage)) + geom_curve(totwrk, hrwage)
u_totwrk <- resid(totwrk)
qqnorm(u_totwrk)
qqline(u_totwrk)

summary(dataset7_sleepingw) #statistic descriptive (mean, median,q1,dst)
scatter.smooth(x=sleep75$totwrk, y=sleep75$hrwage, xlab="totwrk", ylab="hrwage", main="totwrk ~ hrwage", col="dark gray")
?scatter.smooth
boxplot(sleep75$totwrk, main="totwrk")
boxplot.stats(sleep75$totwrk)$out #value of outlier
which(sleep75$totwrk %in% c(boxplot.stats(sleep75$totwrk)$out))
earns_selected <- sleep75[c("totwrk","hrwage","earns74","rlxall","age","educ")]
rcorr(as.matrix(earns_selected))  #package:Hmisc
head(earns_selected)
psych::describe(dataset7_sleepingw)
describe(dataset7_sleepingw$totwrk)
?psych::describe
summary(dataset7_sleepingw)

sleeping1 <- lm(sleep ~ hrwage + totwrk + earns74 + hrwage*earns74 + exper + educ, data = dataset7_sleepingw) #normalkuantitatif
sleeping2 <- lm(log(rlxall) ~ log(hrwage) + totwrk + earns74 + hrwage*earns74 + exper + educ, data = dataset7_sleepingw) #log kuantitatif
sleeping3 <- lm(rlxall ~ hrwage + I(hrwage^2) + totwrk + earns74 + exper + educ, data = dataset7_sleepingw)#kuadratic 
totwrk <- lm(totwrk ~ hrwage + I(hrwage^2) + earns74 + earns74*hrwage + rlxall + age + educ, data = dataset7_sleepingw)
resettest(totwrk)
summary(totwrk)
stargazer(totwrk, type="text")
vif(totwrk)
bptest(totwrk)
totwrk_robust <- coeftest(totwrk, vcov=hccm(totwrk, type="hc0"))
summary(totwrk)
totwrk_robust
stargazer(totwrk_robust, type="text")

linearHypothesis(totwrk, c("hrwage=0", "hrwage:earns74=0"), white.adjust = "hc0")

summary(sleeping1)
summary(sleeping2)
summary(sleeping3)

vif(sleeping1)
vif(sleeping3)

bptest(sleeping1)
bptest(sleeping3) #acc on 1% ,5% and 10% 
sleeping1_robust <- coeftest(sleeping1, vcov=hccm (sleeping1, type = "hc0"))
sleeping1_robust