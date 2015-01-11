library(data.table)

#checking if data.table is loaded, trying to resolve its absence
if(!require(data.table))
{
	message("Did not find data.table, so trying to install it")
	install.packages(data.table)
	
	if(require(data.table))
	{
		message("data.table is installed successfully")
	} else 
	{
		stop("Did not find and could not install data.table")
	}
}

#setting common environment
workDir <- "tmp"
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
fileNameZip <- "power_consumption.zip"
fileName <- "household_power_consumption.txt"
powerNA <- "?"
powerColClasses <- c(rep("character", 2), rep("numeric", 7))
validDates <- c("1/2/2007", "2/2/2007")
filePathZip = paste(workDir, fileNameZip, sep="/")
filePath = paste(workDir, fileName, sep="/")

#setting locale to prevent non-English output
Sys.setlocale("LC_TIME", "C")

#setting task-specific environment
pngName <- "plot4.png"

#creating a directory to store data
message("Creating a data directory")
if(!file.exists(workDir)){
    dir.create(workDir)
}

#downloading .zip 
message("Downloading the file to the data directory")
if(0 != download.file(fileURL, filePathZip, "curl"))
{
	stop("Could not download data")
}

#extracting .zip
message("Unzipping the file")
if(filePath != unzip(filePathZip, fileName, list=FALSE, overwrite=TRUE, exdir=workDir))
{
	stop("Could not unzip data")
}

#reading subset of columns (specified as powerSelect) to data.table
powerData <- fread(filePath, sep=";", header=TRUE, na.strings = powerNA, colClasses = powerColClasses)

#plotting, with filtering by validDates
png(pngName, 480, 480)
plotData <- powerData[is.element(powerData$Date, validDates)]
plotData[,t:=as.POSIXct(strptime(paste(plotData$Date, plotData$Time, sep=" "), format="%d/%m/%Y %H:%M:%S"))]

par(cex = 0.65)
par(cex.axis = 0.85)
par(cex.lab = 0.95)
par(cex.main = 1)
par(mar = c(4, 4, 2, 1))

par(mfrow = c(2, 2))

plot(plotData$t, plotData$Global_active_power, ylab = "Global Active Power", xlab = "", type="l")

plot(plotData$t, plotData$Voltage, ylab = "Voltage", xlab = "datetime", type="l")

plot(plotData$t, as.numeric(plotData$Sub_metering_1), type = "n", xlab="", ylab="Energy sub metering")
lines(plotData$t, as.numeric(plotData$Sub_metering_1), col = "black")
lines(plotData$t, as.numeric(plotData$Sub_metering_2), col = "red")
lines(plotData$t, as.numeric(plotData$Sub_metering_3), col = "blue")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lty=c(rep("solid", 3)), bty="n", cex = 0.8)

plot(plotData$t, plotData$Global_reactive_power, ylab = "Global_reactive_power", xlab = "datetime", type="l")

dev.off()

q()
