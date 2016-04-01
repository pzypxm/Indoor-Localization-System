# source("Graphic-1.R")

# We need to draw 13 graphics, each illustrates mean and standard deviation of RSSI value in node L2 to L6 of position P1 to P13.
# x-axis: L2-L6
# y-axis: mean and standard deviation of RSSI value

# Read data from files to object "data"
data = read.table("processed-p1.data")
for (j in 2:13) {
	fileName=paste("processed-p",j,".data",sep="") # sep="" makes sure there is no any space between each component of final string
	data = data.frame(data,read.table(fileName))
}

# Draw the graphic
par(mfrow=c(2,4)) # Construct a 2*7 grid to hold created graphics
for (count in c(5,6,7,8)) {
	title <- paste("Position ",count) # Joint characters to string, so that we are able to draw all graphic at one time with loop
	plot(data[(1+2*(count-1)):(2*count)], col="red", type="p", xlim=c(2,6), ylim=c(50,100), main=title, xlab="L Number", ylab=" ")
}
















