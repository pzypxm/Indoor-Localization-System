# source("Graphic-1.R")

# We need to draw 13 graphics, each illustrates mean and standard deviation of RSSI value in node L2 to L6 of position P1 to P13.
# x-axis: L2-L6
# y-axis: mean and standard deviation of RSSI value

# Read data from files to object "data"
data = read.table("processed-p1.data")
for (j in 2:13) {
	fileName=paste("processed-p",j,".data",sep="") # sep="" makes sure there is no any space between each component of final string
	data = append(data,read.table(fileName))
}

# Calculate mean and standard deviation of RSSI value in each node
final_mean=NULL
final_sd=NULL
mean=NULL
sd=NULL
for (k in 1:13) {
	for (j in 2:6) {
		temp <- NULL
		for (i in 1:nrow(data.frame(data))) {
			if (data[1+(k-1)*2]$V1[i] == j) {
				temp <- append(temp,data[k*2]$V2[i])
			}
		}
		mean <- append(mean,mean(temp)) # Append reasult of mean to array "mean"
		sd <- append(sd,sd(temp))
		if (j == 2 && k == 1) {
			final_mean <-data.frame(mean)
			final_sd <- data.frame(sd)
		}
		else {
			final_mean <- data.frame(final_mean,mean)
			final_sd <- data.frame(final_sd,sd)
		}
		mean <- NULL
		sd <- NULL
	}
}

# Draw the graphic
par(mfrow=c(2,4)) # Construct a 2*7 grid to hold created graphics
for (count in 1:4) {
	title <- paste("P",count) # Joint characters to string, so that we are able to draw all graphic at one time with loop
	
	temp_mean <- NULL
	temp_sd <- NULL
	for (i in (1+(count-1)*5):(5+(count-1)*5)) {
		temp_mean <- append(temp_mean,final_mean[,i])
		temp_sd <- append(temp_sd,final_sd[,i])
	}
	
	plot(2:6, temp_mean, col="red", type="o", xlim=c(2,6), ylim=c(0,100), main=title, xlab="L Number", ylab=" ")
	lines(2:6, temp_sd, col="blue", type="o") # Add lines to exist graphic
	legend("topright", legend = c("Mean","Dtandard Deviation"), col=c("red","blue"), lty=1:2) # Creat a legend
}












