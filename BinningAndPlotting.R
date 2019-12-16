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
dfm1 <- DFMClass(1,p)
bindfm1ev <- BinFeedingData.Events(dfm1, binInterval)


  dfm1 <- DFMClass((101),p)
  bindfm1ev <- rbind(bindfm1ev,BinFeedingData.Events(dfm1, binInterval))


dfm2 <- DFMClass(2,p)
bindfm2ev <- BinFeedingData.Events(dfm2, binInterval)


  dfm2 <- DFMClass((201),p)
  bindfm2ev <- rbind(bindfm2ev,BinFeedingData.Events(dfm2, binInterval))


dfm8 <- DFMClass(8,p)
bindfm8ev <- BinFeedingData.Events(dfm8, binInterval)


  dfm8 <- DFMClass((801),p)
  bindfm8ev <- rbind(bindfm8ev,BinFeedingData.Events(dfm8, binInterval))


dfm11 <- DFMClass(11,p)
bindfm11ev <- BinFeedingData.Events(dfm11, binInterval)


  dfm11 <- DFMClass((1101),p)
  bindfm11ev <- rbind(bindfm11ev,BinFeedingData.Events(dfm11, binInterval))


dfm18 <- DFMClass(18,p)
bindfm18ev <- BinFeedingData.Events(dfm18, binInterval)
# 

  dfm18 <- DFMClass((1801),p)
  bindfm18ev <- rbind(bindfm18ev,BinFeedingData.Events(dfm18, binInterval))

# 
dfm17 <- DFMClass(17,p)
bindfm17ev <- BinFeedingData.Events(dfm17, binInterval)
# 

  dfm17 <- DFMClass((1701),p)
  bindfm17ev <- rbind(bindfm17ev,BinFeedingData.Events(dfm17, binInterval))

# 
# # dfm12 <- DFMClass(12,p)
# # bindfm12 <- BinFeedingData.Licks(dfm12, binInterval)
# # 
# # for (i in 1:10) {
# #   dfm12 <- DFMClass((1200+i),p)
# #   bindfm12 <- rbind(bindfm12,BinFeedingData.Licks(dfm12, binInterval))
# # }
# # 
# # dfm13 <- DFMClass(13,p)
# # bindfm13 <- BinFeedingData.Licks(dfm13, binInterval)
# # 
# for (i in 1:10) {
#   dfm13 <- DFMClass((1300+i),p)
#   bindfm13 <- rbind(bindfm13,BinFeedingData.Licks(dfm13, binInterval))
# }
# 
dfm19 <- DFMClass(19,p)
bindfm19ev <- BinFeedingData.Events(dfm19, binInterval)
# 

  dfm19 <- DFMClass((1901),p)
  bindfm19ev <- rbind(bindfm19ev,BinFeedingData.Events(dfm19, binInterval))

# 
dfm16 <- DFMClass(16,p)
bindfm16ev <- BinFeedingData.Events(dfm16, binInterval)
# 

  dfm16 <- DFMClass((1601),p)
  bindfm16ev <- rbind(bindfm16ev,BinFeedingData.Events(dfm16, binInterval))

#--------Bin Data-------------


#------Save to Excel----------
# Change numeric values and file names below to correspond to data
BinFeedingData.Licks.SaveResults(dfm1, bindfm1ev, "NumEv01_26Jul2019.xlsx", binInterval)

BinFeedingData.Licks.SaveResults(dfm2, bindfm2ev, "NumEv02_26Jul2019.xlsx", binInterval)

BinFeedingData.Licks.SaveResults(dfm8, bindfm8ev, "NumEv08_26Jul2019.xlsx", binInterval)

BinFeedingData.Licks.SaveResults(dfm11, bindfm11ev, "NumEv11_26Jul2019.xlsx", binInterval)

BinFeedingData.Licks.SaveResults(dfm16, bindfm16ev, "NumEv16_26Jul2019.xlsx", binInterval)

BinFeedingData.Licks.SaveResults(dfm17, bindfm17ev, "NumEv17_26Jul2019.xlsx", binInterval)

BinFeedingData.Licks.SaveResults(dfm18, bindfm18ev, "NumEv18_26Jul2019.xlsx", binInterval)

BinFeedingData.Licks.SaveResults(dfm19, bindfm19ev, "NumEv19_26Jul2019.xlsx", binInterval)
# 
# BinFeedingData.Licks.SaveResults(dfm15, bindfm15, "M15_18Oct2018.xlsx", binInterval)
# 
# BinFeedingData.Licks.SaveResults(dfm12, bindfm12, "M12_18Oct2018.xlsx", binInterval)
#-------Save to Excel----------
