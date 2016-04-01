#!/usr/bin/env Rscript

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

# Divide the whole dataset to training set and testing set
ind <- sample(2, nrow(data),replace=TRUE,prob=c(0.8,0.2)) # Number each tuple with 1 and 2
trainData <- data[ind==1,] # Arrange each tuple according to their number
testData <- data[ind==2,]

# Construct NB classifier
myformula = Position ~ L2 + L3 + L4 + L5 + L6
tuning <- tune.control(random=FALSE, nrepeat=1, repeat.aggregate=min, sampling=c("cross"), sampling.aggregate=mean, cross=10, best.model=TRUE, performances=TRUE)
nb_model <- naiveBayes(myformula, trainData, tuning)

pred <- predict(nb_model, newdata=testData, type='class')
actu <- testData[,6]

# Calculate measures for evaluating performace
for (i in 1:13) {
	p_loc <- NULL
	pos <- paste("^P",i,"$",sep="") # Regular Expression: strating with "P" and ending with a number "i"
	p_loc <- grep(pos,actu) # Get an arry of positions with required class label

	if (length(p_loc) != 0) {
		# P
		P <- length(p_loc)
		# N
		N <- length(pred) - length(p_loc)
		
		# TP
		TP = 0
		for (j in p_loc[1]:p_loc[length(p_loc)]) {
			if ( pred[j] == actu[j] )
				TP <- TP + 1
		}
		# TN
		TN = 0
		for (j in 1:length(pred)) {
			if ( j >= p_loc[1] && j <=p_loc[length(p_loc)])
				next
			else if ( pred[j] == actu[j] )
				TN <- TN +1
		}

		# Accuracy
		ACCU = round((TP + TN) / (P + N), 2)

		if (i == 1)
			# Sensitivity
			SENS = round(TP / P, 2)
		else
			SENS = append(SENS,round(TP / P, 2))
	}
}
# Draw bar plot here
color=1
name="Accuracy"
width=2
for (i in 1:length(SENS)) {
	color = append(color,2)
	name = append(name,"Recll")
	width = append(width,1)
}
barplot(c(ACCU,SENS),names=name,col = color,space=c(1,1),width=width)
title("Accuracy & Recall")
box()























