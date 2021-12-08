#! /bin/bash

#make a simple readme for a directory, an checks if entries have been made already

dir=$1

printf "# Title\n description \n \n ## Contents \n" > $dir/preamble

#create readme if does not exist
if [ ! -f  $dir/README.md ]; then
    echo 'creating readme'
    cat $dir/preamble > $dir/README.md
fi
rm $dir/preamble

#create tmp file
#touch $dir/tmp

for k in `ls -S $dir/|grep -v README.md|sort -uf `
do
    #echo $k
    if grep -q $k $dir/README.md;
    then
	grep $k $dir/README.md >> $dir/tmp
    else
	#find first comment and assign that to the description
	#check if .mat or .py
	if [ ${k: -4} == ".mat" ]; then
	    cdelim='%'
	    wl=1
	elif [ ${k: -3} == ".py" ]; then
	    cdelim='#'
	    wl=1
        elif [ ${k: -3} == ".sh" ]; then
            cdelim='#'
	    wl=2 #this avoids the shebang in shell scripts
	else
	    cdelim='%'
	    wl=1
	fi
	
	#try to extract comment and remove the commenting chars    
	comment=`grep $cdelim $k |head -n $wl|tail -n 1|sed s/$cdelim//g`

	#create the entry
	echo "+ $k: $comment" >> $dir/tmp
    fi
    
done

#remove tmp
#rm $dir/tmp

#keep the old preamble
linenum=`grep -n "## Contents" README.md|cut -d : -f 1`

head -n $linenum README.md > $dir/tmp_header

cat $dir/tmp_header > $dir/README.md
printf "\n" >> $dir/README.md
cat $dir/tmp >> $dir/README.md

rm $dir/tmp
rm $dir/tmp_header


