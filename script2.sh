if [ ! -d "gitFilesTemp12345" ]; then
	mkdir gitFilesTemp12345
else 
	rm -rf gitFilesTemp12345
	mkdir gitFilesTemp12345
fi
tar -xzvf $1 -C gitFilesTemp12345 > /dev/null
cd gitFilesTemp12345
t1=$1
t1=${t1%".tar.gz"}
touch "files".txt
touch "testFile".txt
echo ". ./dataA.txt ./more ./more/dataC.txt ./more/dataB.txt" >> "testFile".txt
cd $t1
a="$(find -type f)"
arr=$(echo $a | tr " " "\n")
cd ..
for element in "${arr[@]}"
do
    echo "$element" > "files".txt
done
if [ ! -f "repo".txt ]; then
	touch "repo".txt
else
	rm "repo".txt
	touch "repo".txt
fi
while read i;
do
	i=${i#"./"}
	grep -m 1 ^https "$t1/$i" >> "repo".txt	
done < "files".txt
mkdir assignments
if [ ! -f "assignments/repo_names".txt ]; then
        touch "assignments/repo_names".txt
else
        rm "assignments/repo_names".txt
        touch "assignments/repo_names".txt
fi
while read i;
do
	cd assignments
	git clone --quiet "$i" > /dev/null 2>&1
	ret=$?
	t2=$i
	t2=${t2##*"/"}
	t2=${t2%".git"}
	if [ $ret -eq 0 ]; then
		echo "$i : CLONING OK"
		echo $t2 >> "repo_names".txt	
	else
		>&2 echo "$i : CLONING FAILED"
	fi
	cd ..
done < "repo".txt
cd assignments
while read i;
do
	cd $i
	echo "$i :"
	d=$(find . -not -path '*/\.*' -type d | wc -l)
	tx=$(find . -not -path '*/\.*' -type f -name "*.txt" | wc -l)
	f=$(find . -not -path '*/\.*' -type f | wc -l)
	struct=$(find . -not -path '*/\.*')
	echo "Number of directories: $(($d-1))"; 
     	echo "Number of txt files : $tx"
	echo "Number of other files : $(($f-$tx))"       
	cd ..	
	cd ..
	touch "tmp".txt
        echo $struct > "tmp".txt
        if  !  cmp -s "tmp".txt "testFile".txt  ; then
   	     echo "Structure is not OK"
        else
		echo "Structure is OK"
        fi
             rm "tmp".txt
	     cd assignments
done < "repo_names".txt
cd ..
cd ..
rm -rf gitFilesTemp12345
