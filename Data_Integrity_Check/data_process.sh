#!/bin/bash # This script would be interpret by “/bin/bash”

# 5 col with rssi values of 5 nodes in every package

count=1
while (( $count<=16 )) # Define a loop in order to process 13 files
do
    # Preprocess so as to remove redundant data
    tail -n 160 "p$count.data" | gawk '{print $17 " " $19 $20 $21 $22 " " $23}' > "p-p$count.data"
    
    # Convert hexadecimal data to decimal one
    cat "p-p$count.data" | gawk '{print strtonum("0x"$2) " " strtonum("0x"$1) " " strtonum("0x"$3)}' > "processed1-p$count.data"
    
    # Sort all the data according to anchor-ID
    sort -t, -nk2 "processed1-p$count.data" > "processed2-p$count.data"

    # Merge lines based on Package-ID
    #--------------------------------------------------------------------#
    # Following code section would be executed for N times where N stands for the number of lines in each file.
    # On every execution, "$0","$2" and "$3" represent the value in "every column", "column 2" and "column 3" respectively on line x, where line x is equal to current number of cycles.
    # Also, we would remove one of two RSSI values with same node number in one package
    
    # Array a would continuously append data from every line until it comes to a different ID value. Then the content of array a would be output and be reset to NULL, waitting for appending data from next line.
    #--------------------------------------------------------------------#
    flag=0
    awk '{
        if(!i){
            num=1;
            a[num]=$1;
            i=$1;
        }
        if($1==i && a[num-1]!=$2){
            num++;
            a[num]=$2;
            num++;
            a[num]=$3;
        }
        else if(a[num-1]==$2){

        }
        else{
            for(j in a){
                if (flag==0) {

                    flag=1;
                }
                else
                    printf "%s ", a[j];
            }

            print "";

            delete a;
            num=1;

            a[num]=$1;
            num++;
            a[num]=$2;
            num++;
            a[num]=$3;
        };
        i=$1;
    }' "processed2-p$count.data" > "processed1-p$count.data"

    cat "processed1-p$count.data" | gawk '{print $2 " " $3 " " $4 " " $5 " " $6 " " $7 " " $8 " " $9 " " $10 " " $11 " "}' > "processed3-p$count.data"

    # Delete redundant files
    rm "p-p$count.data"
    rm "processed1-p$count.data"
    rm "processed2-p$count.data"

    let "count ++"
done

Rscript Graphic.R



















