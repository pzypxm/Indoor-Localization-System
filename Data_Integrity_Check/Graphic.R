#!/usr/bin/env Rscript

# source("Graphic-3.R")

# We need to draw 1 graphic, each illustrates the proportion of intact packages which content all the RSSI value from node L2 to L6 of 13 files.
# x-axis: Position Number
# y-axis: Proportion
final=NULL
for (j in 1:16) {
	length=NULL
	fileName=paste("processed3-p",j,".data",sep="") # sep="" makes sure there is no any space between each component of final string
	conn=file(fileName)
	linn=readLines(conn) # Read content of the file line by line
	for (i in 1:length(linn)) {
		if (i == 1)
			length = nchar(linn[i])
		else
			length = append(length,nchar(linn[i]))
	}
	close(conn)
	mode = as.numeric(names(table(length))[which.max(table(length))]) # Calculate the mode which stand for the length of intact packages
	count=0
	for (i in 1:length(linn)) {
		if(nchar(linn[i]) == mode) {
			count <- count +1
		}
	}		
	final = append(final,count/length(linn)*100)
}
name="P1" # Construct names argument for function barplot
for (k in 2:16){
	temp=paste("p",k,sep="")
	name=append(name,temp)
}
barplot(final,names=name,space=c(1,1))
title("Proportion of intact package")
box()













