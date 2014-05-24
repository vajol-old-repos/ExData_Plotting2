## This script gives an answer to how have emissions from motor vehicle-related sources changed
## in city of Baltimore from 1999-2008?

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

## Create a list of "vehicle" related SCC's
vehscc <- scc[grep("vehicle",scc$Short.Name,ignore.case = TRUE), ]$SCC

## Subset NEI data set selecting only rows with "vehicle" related SCC's
neiveh <- subset(nei, scc %in% vehscc)

## Create a subset of previous data set, selecting only rows related to Baltimore (fips=24510) 
neibalveh <- neiveh[neiveh$fips == "24510", ]

## Summarize emissions per year for all "vehicle" related sources 
balvehsum <- aggregate(neibalveh$emissions, by = list(neibalveh$year), FUN = sum)

## Define more user friendly coulmn names for summarized data set
names(balvehsum) <- c("year", "total")

## Initialize graphics device
png(filename = "plot5.png", width=480, height=480)

## Create a bar plot showing total emissions per year for Baltimore,  for all "vehicle" related sources 
barplot(height = balvehsum[, "total"], names.arg = balvehsum[,"year"], las = 2, cex.axis = 0.7, 
        cex.names = 0.7, main = "Coal PM emissions per year from vehicle sources in Baltimore", 
        ylab = "Total Coal PM emissions")

## Close graphics device
dev.off()


