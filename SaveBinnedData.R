library(xlsx)
library(fields)

# Take the output from SingleWellChamber.R BinFeedingData.Licks function,
# and write as a tableto the specified file, then also add worksheets with the
# data separated by day for each well, as well as a summary sheet of well by day.
BinFeedingData.Licks.SaveResults <- function(dfm, bindfm, filename, binsize.minutes=30){
  starttime <- as.character(dfm$LickData$Time[1])
  write.xlsx(bindfm, file=filename, sheetName="DataSheet")
  
  resultsByWell = BinFeedingData.Licks.ResultsByWell(dfm, bindfm, binsize.minutes)

  #Write the individual well spreadsheets
  lapply(resultsByWell$binsByDay, WriteSingleWellSheet, filename)
  
  #Now write a sheet with the summary by day for each well
  write.xlsx(resultsByWell$dayTotals, file=filename, sheetName = "Summary", append=TRUE)
}

BinFeedingData.Licks.ResultsByWell <- function(dfm, bindfm, binsize.minutes){
  starttime <- as.character(dfm$EventData$Time[1])
  #We should have all the data, in columns Interval, Min, W1, W2, ...
  #Separate it out by well.
  wellNames <- names(bindfm)
  wellNames <- wellNames[grepl("^W.*", wellNames)]
  
  #Get just the first time in the interval as the start time
  bindfm$starttime <- as.numeric(gsub(",.*","", gsub("\\[|\\(","",bindfm[["Interval"]]))) 
  
  #Separate each well and divide into days
  binsByDay = lapply(wellNames, SingleWellByDay, bindfm, starttime, binsize.minutes)
  
  #Calculate the totals for each day sheets for each well
  dayTotals <- SingleWellDayTotals(binsByDay, wellNames)
  
  return(list(binsByDay=binsByDay, dayTotals=dayTotals))
}

SingleWellByDay <- function(wellName, bindfm, starttime, binsize.minutes){
  timedata <- bindfm[["starttime"]]
  #Find out how many days we have here
  endtime <- tail(bindfm$starttime,1)
  totaldays <- floor(endtime/1440) + 1 
  #AJR Fix 1-4-17
  #totaldays <- ceiling(endtime/1440)
  #Initialize the data array
  bincount <- 24*60/binsize.minutes
  daycounts <- matrix(0,bincount,totaldays)
  #Get the binned data for this well
  welldata <- bindfm[[wellName]]
  #Convert the starttime to a timestamp
  starttime <- as.POSIXct(paste("2016-01-01 ", starttime))
  #Create the 30-minute time interval strings
  intervaltimes <- format(seq(from=starttime, length.out = bincount, 
                              by = paste(as.character(binsize.minutes), "min")),"%H:%M:%S")
  for (tIdx in 1:length(timedata)){
    #For each one of the time data intervals, put the corresponding value for this well in
    #the correct line/column of output
    t <- timedata[tIdx]
    #The timedata is in minutes; each day has 1440 minutes, so Day 2 first row starts at 1440 and so on.
    column <- floor(t/1440) + 1
    row <- floor((t %% 1440) / binsize.minutes) + 1
    daycounts[row,column] <- welldata[tIdx]
    #Update the day array
  }
  #Combine the times, counts, and an average column all into 
  averages <- apply(daycounts,1,mean)
  totals <- apply(daycounts,1,sum)
  dataout <- data.frame(daycounts,totals,averages)
  #Update the column headers... first create a list of the day names
  daylist <- paste(array("Day",totaldays), as.character(1:totaldays))
  row.names(dataout) <- intervaltimes
  dataout <- setNames(dataout, c(daylist, "Total", paste(wellName, "Average")))
  return(dataout)
}

SingleWellDayTotals <- function(dataByDay, wellNames){
  #Get the totals
  welltotals <- lapply(dataByDay, apply, 2, sum)
  daytotals <- do.call("rbind", welltotals)
  daytotals <- daytotals[,1:(ncol(daytotals)-2)]
  #If there's only one day of data, daytotals isn't going to be a matrix 
  #Make it one, since that's what the rest of this is expecting.
  if (!is.matrix(daytotals)){
    daytotals <- matrix(daytotals)
  }
  row.names(daytotals) <- wellNames
  return(daytotals)
  
}
WriteSingleWellSheet <- function(dataout, filename){
  #Since the well name is being saved as part of the Average label in the last column, 
  # find it here to name the spreadsheet.
  wellName <- extractWellName(dataout)
  write.xlsx(dataout[1:(ncol(dataout)-2)], file=filename, sheetName=wellName, append=TRUE)
}

extractWellName <- function(binsByDay){
  wellName <- colnames(binsByDay)
  wellName <- tail(wellName,1)
  wellName <- sub(" .*", "", wellName)
  return(wellName)
}

BinFeedingData.Licks.ResultsByDay <- function(resultsByWell) {
  wellData <- resultsByWell$binsByDay
  #This is a list with one well in each list, where every column is a day's data.
  #So for the first day's plot, we need the first column from every item in the list.
  wellNames <- lapply(wellData, extractWellName)
  daycount <- ncol(wellData[[1]]) - 2 #the last 2 columns are total & average
  binsPerDay <- nrow(wellData[[1]])

  #I suspect there is a more efficient and/or cleaner way to do this...
  dayData <- lapply(as.list(1:daycount), extractSingleDay, wellData, wellNames)
  
  return(dayData)
}

extractSingleDay <- function(index, wellData, wellNames){
  dayData <- lapply(wellData, "[", index)
  dayData <- lapply(dayData, t)
  dayData <- do.call("rbind",dayData)
  row.names(dayData) <- wellNames
  return(dayData)
}

BinFeedingData.Licks.PlotWellsByDay <- function(dfm, bindfm, binInterval,title="", wellsToPlot=NULL){
  resultsByWell <- BinFeedingData.Licks.ResultsByWell(dfm,bindfm,binInterval)
  resultsByDay <- BinFeedingData.Licks.ResultsByDay(resultsByWell)
  #Keep the color scale the same for all days
  minValue  <-  min(unlist(resultsByDay))
  maxValue <-  max(unlist(resultsByDay))
  jet.colors <- colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan",
                                   "#7FFF7F", "yellow", "#FF7F00", "red"))
  colorList <- jet.colors(100)
  breakList <- seq.int(minValue, maxValue+1, (maxValue+1)/100)
  lapply(as.list(1:length(resultsByDay)), plotSingleDay, resultsByDay, colorList, breakList, title, wellsToPlot)
  return()
}

plotSingleDay <- function(dayNum, resultsByDay, colorList, breakList,title, wellsToPlot=NULL){
  if (is.null(wellsToPlot)) {
    wellsToPlot <- 1:nrow(resultsByDay[[dayNum]])
  } else if(is.character(wellsToPlot) && toupper(wellsToPlot) == 'ODD') {
    wellsToPlot <- seq(1,nrow(resultsByDay[[dayNum]]), 2)
  } else if(is.character(wellsToPlot) && toupper(wellsToPlot) == 'EVEN') {
    wellsToPlot <- seq(2,nrow(resultsByDay[[dayNum]]), 2)
  } else if(any(wellsToPlot > nrow(resultsByDay[[dayNum]]))) {
    stop('One or more of the specified wells to plot is greater than the total number of wells available.')
  } 
  
  x <- 1:ncol(resultsByDay[[dayNum]])
  y <- 1:length(wellsToPlot)
  z <- t(resultsByDay[[dayNum]][wellsToPlot,])
  #Set up a layout so the image and legend fit nicely together
  par(mar=c(5,4.5,3,5))
  image(x, y, z, main=paste(title,"Day", dayNum, sep=" "),las=2, axes=FALSE,ylab='',xlab='', col=colorList, breaks = breakList)
  #Label every other time point on the x axis
  xseq <- seq.int(1,length(x),2)
  labels  <- rownames(z)
  axis(1,at=x[xseq], labels = labels[xseq], las=2)
  #Label every well on the y axis
  axis(2,at=y, labels = colnames(z),las=2)
  # add the legend
  zlim <- c(min(breakList), max(breakList)-1)
  image.plot( legend.only=TRUE, horizontal = FALSE, col=colorList, zlim=zlim, 
              axis.args=list(at=zlim, labels=zlim),legend.shrink=0.8, legend.width=.9) 
  return()
}