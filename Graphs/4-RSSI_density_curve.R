# source("Graphic-1.R")

# We need to draw 13 graphics, each illustrates mean and standard deviation of RSSI value in node L2 to L6 of position P1 to P13.
# x-axis: L2-L6
# y-axis: mean and standard deviation of RSSI value

# Load necessary package
library(e1071)
# Read data from file and add name to each column
data = read.table("dataset.data")
names(data) = c("L2","L3","L4","L5","L6","Position")

# Use k-means cluster to eliminate exceptions according to distance from center
kmeans_result <- kmeans(data[,1:5],center=13,iter.max=10)
centers <- kmeans_result$centers[kmeans_result$cluster,]
distances <- sqrt(rowSums((data[,1:5] - centers)^2))
outliers <- order(distances, decreasing=T)[1:100]
data <- data[-outliers,]

for (k in 9) { # You can manually input the position you want
	par(mfrow=c(2,3))
	for (j in 1:5) {
		temp = 1
		for(i in 1:nrow(data)) {
			if (data[i,6] == paste("P",k,sep="")) {
				temp <- data.frame(temp,data[i,j])
			}
			temp <- data.matrix(temp) # You need a vector of data in order to draw its density curve
		}
		title <- paste("Density graph of RSSI value in L",j) 
		plot(density(temp[2:(ncol(temp)-1)]),col="red", type="l",main=title)
	}
}






















