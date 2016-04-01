#!/usr/bin/env Rscript

# Load necessary package
library(e1071)
# Read data from file and add name to each column
data = read.table("dataset.data")
names(data) = c("L2","L3","L4","L5","L6","Position")

# Use k-means cluster to eliminate exceptions according to distance from center
kmeans_result <- kmeans(data[,1:5],center=13,iter.max=10)
centers <- kmeans_result$centers[kmeans_result$cluster,] # Get the objects viewed as centers of clusters
distances <- sqrt(rowSums((data[,1:5] - centers)^2)) # Calculate the distance between objects in dataset and centers
outliers <- order(distances, decreasing=T)[1:220] # Find out outliers set according to how much objects you would like to eliminate  
data <- data[-outliers,] # Eliminate outliers

# Divide the whole dataset to training set and testing set
ind <- sample(2, nrow(data),replace=TRUE,prob=c(0.8,0.2)) # Number each tuple with 1 and 2
trainData <- data[ind==1,] # Arrange each tuple according to their number
testData <- data[ind==2,]

# Construct NB classifier
myformula = Position ~ L2 + L3 + L4 + L5 + L6
tuning <- tune.control(cross=10, best.model=TRUE)
nb_model <- naiveBayes(myformula, trainData, tuning)

pred <- predict(nb_model, newdata=testData, type='class')
actu <- testData[,6]

# Use model to classify data in testing set
print("-----------------------Predicted Position----------------------------")
print(pred)
print("------------------------Actual Position------------------------------")
print(actu)

# Calculate measures for evaluating performace
for (i in 1:13) {
	p_loc <- NULL
	pos <- paste("^P",i,"$",sep="") # Regular Expression: strating with "P" and ending with a number "i"
	p_loc <- grep(pos,actu) # Get an arry of positions with required class label
	
	print(paste("P",i,sep=""))
	print(p_loc)

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
		# FP
		FP =0
		for (j in p_loc[1]:p_loc[length(p_loc)]) {
			if ( pred[j] != actu[j] )
				FP <- FP + 1
		}
		# FN
		FN =0
		for (j in 1:length(pred)) {
			if ( j >= p_loc[1] && j <=p_loc[length(p_loc)])
				next
			else if ( pred[j] != actu[j] )
				FN <- FN +1
		}

		# Accuracy
		ACCU = round((TP + TN) / (P + N), 2)
		# Erro Rate
		ERRO = round((FP + FN) / (P + N), 2)
		# Sensitivity
		SENS = round(TP / P, 2)
	}
	# Print Result
	print(paste("P:",P,"N:",N,"TP:",TP,"TN:",TN,"FP:",FP,"FN:",FN,"|","Accuracy:",ACCU,"Erro Rate:",ERRO,"Sensitivity:",SENS))
}
print(ACCU)
























