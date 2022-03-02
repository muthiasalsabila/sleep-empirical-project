setwd("C:/users/tough/OneDrive/dokumen/R")
getwd()
dir()

library(wooldridge)
library(carData)
library(readxl)
library(lmtest)
library(psych)
library(stargazer)
library(car)
library(Hmisc)
library(plm)

mone <- read_excel("data/mone2.xlsx")
mone <- as.data.frame(mone)
summary(mone)
psych::describe(mone)

#IS
is <- lm(gdp ~ log(ipinves) + pmtb, data = mone)
summary(is)
stargazer(is, type="text")
?stargazer
plot(mone$gdp, mone$isimp, ylim = c(0, 2000000))
abline(is)
abline(lm)


#LM
lm <- lm(gdp ~ log(isimp) + m1, data = mone)
summary(lm)
stargazer(lm, type="text")


#ggplot
ggplot()+
  geom_line(data = mone, aes(x = gdp, y = ipinves), color = "blue") +
  geom_line(data = mone, aes(x = gdp, y = isimp), color = "red")
ggplot(data = mone, aes(x = ipinves, y = gdp)) + geom_point() + xlab("Pendapatan Nasional") + ylab("Suku Bunga")+geom_smooth(method = "lm", se = F)
ggplot(data = mone, aes(x = isimp, y = gdp)) + geom_point() + xlab("Pendapatan Nasional") + ylab("Suku Bunga")+geom_smooth(method = "lm", se = F)

ggplot(mone, aes(x = gdp, y = ipinves)) +
  geom_point() + 
  theme_classic() + 
  geom_smooth(method = "lm")

ggplot(mone, aes(x = gdp, y = isimp)) +
  geom_point() + 
  theme_classic() + 
  geom_smooth(method = "lm")+
  stat_smooth(formula = lm)

curve(lm, from = -1000000, to = 2000000)
ggplot(mone, aes(x = gdp, y = isimp))+
  stat_function(fun = lm)


ggplot(data = mone, aes(x = gdp, y = ipinves))+
  stat_function(fun = is, color = "red")

ggplot(data.frame(x=c(1, 50)), aes(x=x)) + 
  stat_function(fun=is)

library(effects)
is1 <- lm(ipinves ~ gdp + pmtb, data = mone)
lm1 <- lm(isimp ~ gdp + m1, data = mone)
plot(effect("log(ipinves)", is), xlab = "gdp", ylab = "suku bunga", main = "Kurva IS - LM") + plot(effect("log(isimp)",lm), xlab = "gdp", ylab = "suku bunga", main = "Kurva LM")
?effects

