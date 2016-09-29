#!/bin/bash

yearlist=(2006 2007 2008 2009 2010 2011 2012 2013)

for i in "${yearlist[@]}"

do
	echo " process year $i"

    ./download_mosaic_stack_batch_dir2.bash $i

done
