# Setting up the work environment and download the file
#-------------------------------

setwd("~/Dropbox (Personal)/edu/Coursera/exploratory/hpc")
fileURL <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileURL, destfile="./data.zip")
unzip("data.zip")

hpc <- read.table("household_power_consumption.txt", sep=";", header=TRUE, na.strings="?")

# Get familiar with the data set
str(hpc)
head(hpc)
table(hpc[8])

# Subset dates to 2007-02-01 and 2007-02-02
hpc.a <- hpc
hpc.a$Date <- as.Date(hpc$Date, format="%d/%m/%Y")
hpc.b <- subset(hpc.a,hpc.a$Date =="2007-02-01" | hpc.a$Date=="2007-02-02")

# You may find it useful to convert the Date and Time variables to Date/Time classes in R using the  strptime()  and  as.Date()  functions.
Datetime <-paste(hpc.b$Date,hpc.b$Time)
Datetime <- strptime(Datetime, format="%Y-%m-%d %H:%M:%S")
str(Datetime)
hpc.b$Datetime <- Datetime

# Plot 1: Global Active Power
# X: Kilowats
# Y: Frequency
#-------------------------------

hist(hpc.b$Global_active_power, xlab="Global Active Power (kilowatts)",main="Global Active Power",col="red",freq=TRUE)
dev.copy(png, file="plot1.png", width=480, height=480)
dev.off()

# Plot 2: Consumption line graph
# X: Time/Day
# Y: Consumption
#-------------------------------
plot(hpc.b$Datetime,hpc.b$Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)")
dev.copy(png, file="plot2.png", width=480, height=480)
dev.off()

# Plot 3: Consumption line graph (breakout)
# X: Time/Day
# Y: Energy Sub metering
#-------------------------------
plot(hpc.b$Datetime,hpc.b$Sub_metering_1, type="l", xlab="", ylab="Global Active Power (kilowatts)", col="black")
lines(hpc.b$Datetime,hpc.b$Sub_metering_2, col="red")
lines(hpc.b$Datetime,hpc.b$Sub_metering_3, col="blue")
legend("topright", lty=1, legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col=c("black","red","blue"))
dev.copy(png, file="plot3.png", width=480, height=480)
dev.off()

# Plot 4: Dashboard 
# X: Time/Day
# Y: GAP, Voltage, Energy Sub Metering, Global Reactive Power 
#-------------------------------
par(mfrow = c(2,2), mar=c(4,4,3,1))

with(hpc.b, {
  plot(Datetime,Global_active_power,type="l",ylab="Global Active Power", xlab="")
  plot(Datetime,Voltage, type="l", ylab="Voltage", xlab="datetime")
  plot(Datetime,Sub_metering_1, type="l", xlab="", ylab="Global Active Power (kilowatts)", col="black")
    lines(Datetime,Sub_metering_2, col="red")
    lines(Datetime,Sub_metering_3, col="blue")
    legend("topright", lty=1, bty="n", legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col=c("black","red","blue"), cex=0.7)
  plot(Datetime, Global_reactive_power, type="l",ylab="Global_Reactive_power", xlab="datetime")
})

dev.copy(png, file="plot4.png", width=480, height=480)
dev.off()
