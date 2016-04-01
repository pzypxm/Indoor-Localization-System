# source("Graphic-2.R")

# We need to draw 5 graphics, each illustrates the RSSI value of one node from L2 to L6 in position P1 to P13.
# x-axis: Position number
# y-axis: RSSI value of current node

# Read data from files to object "data"
data = read.table("processed-p1.data")
for (j in 2:13) {
	fileName=paste("processed-p",j,".data",sep="") # sep="" makes sure there is no any space between each component of final string
	data = append(data,read.table(fileName))
}

# Calculate mean of RSSI value in each node
final=NULL
mean=NULL
for (j in 2:6) {
	for (k in 1:13) {
		temp <- NULL
		for (i in 1:nrow(data.frame(data))) {
			if (data[1+(k-1)*2]$V1[i] == j) { # The grammar of read certain value of object "data": data[x]$V1[y]
				temp <- append(temp,data[k*2]$V2[i]) # Store all the RSSI value of certain node to object "temp"
			}
		}
		mean <- append(mean,mean(temp)) # Append reasult of mean to array "mean"
	}
	if (j == 2)
		final <-data.frame(mean)
	else
		final <- data.frame(final,mean)
	mean <- NULL
}

# Draw the graphic
par(mfrow=c(2,2)) # Construct a 2*3 grid to hold created graphics
for (count in 1:4) {
	title <- paste("L",count+1) # Joint characters to string, so that we are able to draw all graphic at one time with loop
	plot(1:13, final[,count], col="red", type="o", xlim=c(1,13), ylim=c(60,100), main=title, xlab="P Number", ylab="RSSI Mean Value")
}













