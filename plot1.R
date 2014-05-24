## This script gives an answer are total emissions from PM2.5 have decreased in the United States 
## from 1999 to 2008? A plot showis the total PM2.5 emission from all sources per year.

## Check existence of a working directory
setwd("c:/")
if (!file.exists("tmp")) {
  dir.create("tmp")
}

## Set working directory
setwd("c:/tmp")

## Set URL for download
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

## Download zip archive file
download.file(fileUrl, destfile = "nei_data.zip")

## Document a date when the files have been downloaded
dateDownloaded <- date()
print(dateDownloaded)

## Unzip archive file
unzip("nei_data.zip")

## Load NEI the data into table
nei <- readRDS("summarySCC_PM25.rds")

## Load SCC the data into table
scc <- readRDS("Source_Classification_Code.rds")

## Define more user friendly coulmn names for NEI data set
names(nei) <- c("fips", "scc", "pollutant", "emissions", "type", "year")

## Summarize emissions per year
psum <- aggregate(nei$emissions, by = list(nei$year), FUN = sum)

## Define more user friendly coulmn names for summarized data set
names(psum) <- c("year","total")

## Initialize graphics device
png(filename = "plot1.png", width=480, height=480)

## Create a bar plot showing total emissions per year
barplot(height = psum[, "total"], names.arg = psum[,"year"], las = 2, cex.axis = 0.7, 
        cex.names = 0.7, main = "Total PM emissions over years", ylab = "PM emissions")

## Close graphics device
dev.off()