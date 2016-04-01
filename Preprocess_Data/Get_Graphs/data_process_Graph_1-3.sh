#!/bin/bash

# 2 col with node num and rssi values

count=1
while (( $count<=13 )) 
do
	# Preprocess so as to remove redundant data
    tail -n 145 "p$count.data" | gawk '{print $17 " " $19 $20 $21 $22 " " $23}' > "p-p$count.data"
    
    # Convert hexadecimal data to decimal one
    cat "p-p$count.data" | gawk '{print strtonum("0x"$1) " " strtonum("0x"$3)}' > "processed1-p$count.data"
    
    # Sort all the data according to anchor-ID
    sort -t, -nk2 "processed1-p$count.data" > "processed2-p$count.data"

    cat "processed2-p$count.data" > "processed-p$count.data"

    rm "p-p$count.data"
    rm "processed1-p$count.data"
    rm "processed2-p$count.data"
	
	let count++
done