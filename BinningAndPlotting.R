#---------Setup---------------
source("SingleWellChamber.R")
source("SaveBinnedData.R")
p<-ParametersClass.SingleWell()
p<-SetParameter(p, Feeding.Threshold.Value = 40, Feeding.Interval.Minimum = 40,
                Feeding.Minevents=5, Tasting.Threshold.Interval=c(10,40))

binInterval = 30 #Set to desired interval in minutes. 
#Note: Anytime this interval changes, the 'Bin Data' section needs to be re-run 
#      before saving or plotting data.
#---------Setup---------------


#--------Bin Data-------------
#Change numeric values to correspond to data
dfm1 <- DFMClass(101,p)
bindfm1ev <- BinFeedingData.Events(dfm1, binInterval)

for (i in 1:7) {
  dfm1 <- DFMClass((101+i),p)
  bindfm1ev <- rbind(bindfm1ev,BinFeedingData.Events(dfm1, binInterval))
}

dfm2 <- DFMClass(201,p)
bindfm2ev <- BinFeedingData.Events(dfm2, binInterval)

for (i in 1:7) {
  dfm2 <- DFMClass((201+i),p)
  bindfm2ev <- rbind(bindfm2ev,BinFeedingData.Events(dfm2, binInterval))
}

dfm8 <- DFMClass(801,p)
bindfm8ev <- BinFeedingData.Events(dfm8, binInterval)

for (i in 1:7) {
  dfm8 <- DFMClass((801+i),p)
  bindfm8ev <- rbind(bindfm8ev,BinFeedingData.Events(dfm8, binInterval))
}

dfm11 <- DFMClass(1101,p)
bindfm11ev <- BinFeedingData.Events(dfm11, binInterval)

for (i in 1:7) {
  dfm11 <- DFMClass((1101+i),p)
  bindfm11ev <- rbind(bindfm11ev,BinFeedingData.Events(dfm11, binInterval))
}

dfm16 <- DFMClass(1601,p)
bindfm16ev <- BinFeedingData.Events(dfm16, binInterval)

for (i in 1:7) {
  dfm16 <- DFMClass((1601+i),p)
  bindfm16ev <- rbind(bindfm16ev,BinFeedingData.Events(dfm16, binInterval))
}

dfm17 <- DFMClass(1701,p)
bindfm17ev <- BinFeedingData.Events(dfm17, binInterval)

for (i in 1:7) {
  dfm17 <- DFMClass((1701+i),p)
  bindfm17ev <- rbind(bindfm17ev,BinFeedingData.Events(dfm17, binInterval))
}

dfm18 <- DFMClass(1801,p)
bindfm18ev <- BinFeedingData.Events(dfm18, binInterval)

for (i in 1:7) {
  dfm18 <- DFMClass((1801+i),p)
  bindfm18ev <- rbind(bindfm18ev,BinFeedingData.Events(dfm18, binInterval))
}

dfm19 <- DFMClass(1901,p)
bindfm19ev <- BinFeedingData.Events(dfm19, binInterval)

for (i in 1:7) {
  dfm19 <- DFMClass((1901+i),p)
  bindfm19ev <- rbind(bindfm19ev,BinFeedingData.Events(dfm19, binInterval))
}

# # dfm14 <- DFMClass(14,p)
# # bindfm14 <- BinFeedingData.Licks(dfm14, binInterval)
# # 
# # for (i in 1:10) {
# #   dfm14 <- DFMClass((1400+i),p)
# #   bindfm14 <- rbind(bindfm14,BinFeedingData.Licks(dfm14, binInterval))
# # }
# # 
# # dfm15 <- DFMClass(15,p)
# # bindfm15 <- BinFeedingData.Licks(dfm15, binInterval)
# # 
# # for (i in 1:10) {
# #   dfm15 <- DFMClass((1500+i),p)
# #   bindfm15 <- rbind(bindfm15,BinFeedingData.Licks(dfm15, binInterval))
# # }
# #--------Bin Data-------------
# 

#------Save to Excel----------
# Change numeric values and file names below to correspond to data
BinFeedingData.Licks.SaveResults(dfm1, bindfm1ev, "Ev01_28Jul2019.xlsx", binInterval)

BinFeedingData.Licks.SaveResults(dfm2, bindfm2ev, "Ev02_28Jul2019.xlsx", binInterval)

BinFeedingData.Licks.SaveResults(dfm8, bindfm8ev, "Ev08_28Jul2019.xlsx", binInterval)

BinFeedingData.Licks.SaveResults(dfm11, bindfm11ev, "Ev11_28Jul2019.xlsx", binInterval)

BinFeedingData.Licks.SaveResults(dfm16, bindfm16ev, "Ev16_28Jul2019.xlsx", binInterval)

BinFeedingData.Licks.SaveResults(dfm17, bindfm17ev, "Ev17_28Jul2019.xlsx", binInterval)

BinFeedingData.Licks.SaveResults(dfm18, bindfm18ev, "Ev18_28Jul2019.xlsx", binInterval)

BinFeedingData.Licks.SaveResults(dfm19, bindfm19ev, "Ev19_28Jul2019.xlsx", binInterval)
# 
# BinFeedingData.Licks.SaveResults(dfm15, bindfm15, "M15_18Oct2018.xlsx", binInterval)
# 
# BinFeedingData.Licks.SaveResults(dfm12, bindfm12, "M12_18Oct2018.xlsx", binInterval)
#-------Save to Excel----------
