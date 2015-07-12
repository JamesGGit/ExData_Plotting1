#Plot1
library(data.table)
projectDir <- "./Project1"
dataDir <- paste(projectDir,"data",sep="/")
zipFileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipFileName <- paste(dataDir,"electricPowerConsumption.zip",sep="/")

if (!file.exists(projectDir)) {
    dir.create(projectDir)
} else {
    print(paste(projectDir, "already exists in Working directory", getwd(),sep=" "))
}

zipFilePath <- paste(getwd(),zipFileName,sep="/")

if(file.exists(projectDir)) {
    print(paste("Project directory is at", paste(getwd(),projectDir,sep="/"), sep=" "))
    
    if(!file.exists(zipFileName)) {
        unlink(dataDir,recursive = TRUE)
        dir.create(dataDir)
        
        download.file(zipFileUrl,zipFileName)
        dateTimeFileDownloaded <- date()
        print(paste("Downloaded file to",zipFilePath,sep=" "))
    } else {
        print (paste(zipFilePath,"already exists. Using downloaded copy",sep=" "))
    }
    
    unzip(zipFilePath,exdir = dataDir)
    unzippedData <- unzip(zipFilePath,list = TRUE)
    unzippedFilePath <- paste(getwd(),dataDir,unzippedData[["Name"]],sep="/")
    
    #print(unzippedFilePath)
    #rowStartToEndIndexes <- 66638:69517
    
    powerConsumptionDT <- read.table(unzippedFilePath,sep = ";",nrows=1,header=TRUE)
    colNames <- colnames(powerConsumptionDT)
    powerConsumptionDT <- read.table(unzippedFilePath,sep = ";",skip=66637,nrows=2880,na.strings = "?")
    colnames(powerConsumptionDT) <- colNames
    powerConsumptionDT$Date <- as.Date(powerConsumptionDT$Date,format="%d/%m/%Y")
    powerConsumptionDT$Time <- strptime(powerConsumptionDT$Time,format="%H:%M:%S")
    
    #Create Plot 1 PNG
    png(file="plot1.png",width = 480, height = 480, units = "px")
    hist(powerConsumptionDT$Global_active_power,col="red",main="Global Active Power",xlab="Global Active Power(kilowatts)")
    dev.off()

    
} else {
    print(paste(projectDir, "directory could not be created at location", 
                getwd(), "Please check if you have permissions to create files",
                "there",sep=" "))
}



