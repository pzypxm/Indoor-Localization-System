#!/usr/bin/env Rscript

# Load necessary package
library(e1071)
library(gplots)

# Read data from file and add name to each column
data = read.table("dataset.data")
names(data) = c("L2","L3","L4","L5","L6","Position")

# Use k-means cluster to eliminate exceptions according to distance from center
kmeans_result <- kmeans(data[,1:5],center=16,iter.max=10)
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
temp_list <- NULL
for (i in 1:16) {
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

		if (i == 1)
			temp_list = SENS
		else 
			temp_list = append(temp_list,SENS)
	}
}
# Draw heat map
sens_list <- matrix(1:16,byrow=TRUE, nrow=4, ncol=4) # Create a 4*4 matrix
for (i in 1:4) {
	for (j in 1:4) {
		sens_list[i,j] = temp_list[(i-1)*4+j]
	}
}
print(sens_list)

heatmap.2(
	sens_list, 
	trace='none',
	Colv=FALSE,
	Rowv=FALSE,
	dendrogram='none',
	density.info='none',
	keysize=1.5,
	cellnote=matrix(1:16,byrow=TRUE, nrow=4, ncol=4),
	notecol='black', 
	notecex=2,
	labRow=c("","","",""),
	labCol=c("","","",""),
	main="\n\n\n\n\n\n\nSensor nodes are on this side",
	colsep=rbind(1:4),
	rowsep=rbind(1:4),
	sepwidth=c(0.05,0.05),
	sepcolor="white",
	col=colorRampPalette(c("orange","#FFFFCC"))(n = 20),
)






















