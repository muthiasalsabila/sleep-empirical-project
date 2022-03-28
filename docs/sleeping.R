setwd("C:/users/tough/OneDrive/dokumen/R")
getwd()
dir()

#Kelas A 
#Dataset 7 - Sleeping

#Anggota Kelompok:
#Apriza Ananda Putri  (12020119140169)
#Chairini Nugraharti  (12020119140181)
#Muthia Salsabila     (12020119120012)
#Priscilia Atrika M   (12020119130151)
#Ratih Dwi Cahyani    (12020119120018)


#Instalasi Packages: ####
install.packages("readxl")
install.packages("Rcpp")
install.packages("wooldridge")
install.packages("carData")
install.packages("psych")
install.packages("car")
install.packages("plm")
install.packages("lmtest")
install.packages("stargazer")
install.packages("Hmisc")
install.packages("ggplot2")
install.packages("effects")

#Menjalankan Packages: ####
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
library(effects)

#Impor Data menggunakan packages Wooldridge atau data dari excel ####
##impor dari Packages Wooldrigde
data(sleep75, package = "wooldridge")
dataset7_sleepingw <- as.data.frame(sleep75) 

##impor dari Data excel
sleeping <- read_excel("data/sleeping.xls")
sleeping <- as.data.frame(sleeping)

#Tahapan awal ####
##Pertanyaan Penelitian: Pengaruh upah perjam terhadap total waktu kerja
##Bentuk Fungsional: level-level (quadratic form)
##Variabel depenpen: totwrk 
##Variabel independen utama: hrwage, (hrwage)^2
##variabel Kontrol: gdhlth, rlxall, age, educ

#Statistik Deskriptif ####
head(dataset7_sleepingw)
str(dataset7_sleepingw)
dim(dataset7_sleepingw)
tail(dataset7_sleepingw)
summary(dataset7_sleepingw)
psych::describe(dataset7_sleepingw)

#Korelasi Antar Variabel ####
totwrk1_selected <- dataset7_sleepingw[c("totwrk","hrwage","gdhlth","rlxall","age","educ")]
rcorr(as.matrix(totwrk1_selected)) 

#Outliers ####
##Histogram
hist(dataset7_sleepingw$totwrk, xlab = "Minutes", main = "Histogram of Total work per week", prob=T)
hist(dataset7_sleepingw$hrwage, xlab = "Hourly Wage", main = "Histogram of Hourly Wage", prob=T)

##Scatter Plot 
scatter.smooth(x=dataset7_sleepingw$totwrk, y=dataset7_sleepingw$hrwage, xlab="totwrk", ylab="hrwage", main="totwrk ~ hrwage", col="brown")

##Boxplot
boxplot(dataset7_sleepingw$totwrk, main="totwrk")
boxplot.stats(dataset7_sleepingw$totwrk)$out #outliers value
which(dataset7_sleepingw$totwrk %in% c(boxplot.stats(dataset7_sleepingw$totwrk)$out))

#Estimasi Model #####
##Total jam kerja = upah perjam +(upah perjam)^2 + [variabel kontrol:kesehatan+waktu santai+umur+lama sekolah] + error terms
##Totwrk = hrwage + (hrwage)^2 + [gdhlth + rlxall + age + educ] + u
totwrk1 <- lm(totwrk ~ hrwage + I(hrwage^2) + gdhlth + rlxall + age + educ, data = dataset7_sleepingw)
summary(totwrk1)
stargazer(totwrk1, type="text")

#Tes Asumsi Gauss Markov ####
##Multikolinearitas - VIF (apabila nilai kurang dari dari 10, bukan multikolinearitas yang parah)
vif(totwrk1)

##Homoskedastisitas - Breusch-Pagan Test
bptest(totwrk1) #hipotesis ditolak pada tingkat 1%

##Menyesuaikan Standar Error yang terkena heteroskedastisitas: Agar BLUE
totwrk1_robust <- coeftest(totwrk1, vcov=hccm(totwrk1, type="hc0"))
totwrk1_robust

#Interpretasi Hasil ####
stargazer(totwrk1_robust, type="text") #Interpretasi dan menyajikan data yang sudah di robust SE-nya

#Visualisasi plot bentuk kuadratik: packages effects ####
plot(effect("hrwage",totwrk1)) #turnpoint: 19,5

