#!/bin/bash

yearlist=(2013 2015)

for i in "${yearlist[@]}"

do
	echo " process year $i"

    ./download_mosaic_stack_batch.bash $i

done
