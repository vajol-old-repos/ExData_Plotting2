## This script gives an answer to how have emissions from coal combustion-related sources changed
## across United States from 1999-2008?

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

## Create a list of "coal" related SCC's
coalscc <- scc[grep("coal",scc$Short.Name,ignore.case = TRUE), ]$SCC

## Subset NEI data set selecting only rows with "coal" related SCC's
neicoal <- subset(nei, scc %in% coalscc)

## Summarize emissions per year for all coal related sources 
coalsum <- aggregate(neicoal$emissions, by = list(neicoal$year), FUN = sum)

## Define more user friendly coulmn names for summarized data set
names(coalsum) <- c("year", "total")

## Initialize graphics device
png(filename = "plot4.png", width=480, height=480)

## Create a bar plot showing total emissions per year for all coal related sources 
barplot(height = coalsum[, "total"], names.arg = coalsum[,"year"], las = 2, cex.axis = 0.7, 
        cex.names = 0.7, main = "Coal PM emissions over years", ylab = "Total Coal PM emission")

## Close graphics device
dev.off()
