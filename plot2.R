data <- read.table("household_power_consumption.txt", sep=";", header=TRUE)
str(data)
names(data)

#Selecting data from 2007-02-01 to 2007-02-02
reduced_data <- data[data$Date == "1/2/2007" | data$Date == "2/2/2007",]
reduced_data$dateTime <- strptime(paste(reduced_data$Date, reduced_data$Time, sep=" "), "%d/%m/%Y %H:%M:%S") 
reduced_data$Global_active_power <- as.numeric(as.character(reduced_data$Global_active_power))
reduced_data$Global_reactive_power <- as.numeric(as.character(reduced_data$Global_reactive_power))
reduced_data$Voltage <- as.numeric(as.character(reduced_data$Voltage))
reduced_data$Sub_metering_1 <- as.numeric(as.character(reduced_data$Sub_metering_1))
reduced_data$Sub_metering_2 <- as.numeric(as.character(reduced_data$Sub_metering_2))
reduced_data$Sub_metering_3 <- as.numeric(as.character(reduced_data$Sub_metering_3))
str(reduced_data)

#plot2
png("plot2.png") 
plot(reduced_data$dateTime, reduced_data$Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)")
dev.off()