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
pngName <- "plot1.png"
powerSelect <- c("Date", "Time", "Global_active_power")

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
powerData <- fread(filePath, sep=";", header=TRUE, na.strings = powerNA, colClasses = powerColClasses, select=powerSelect)

#plotting, with filtering by validDates
png(pngName, 480, 480)
par(cex = 0.95)
par(cex.axis = 0.85)
par(cex.lab = 0.95)
par(cex.main = 1.2)
hist(as.numeric(powerData[is.element(powerData$Date, validDates)]$"Global_active_power"), main = "Global Active Power", xlab = "Global Active Power (kilowatts)", col = "red")
dev.off()

q()
