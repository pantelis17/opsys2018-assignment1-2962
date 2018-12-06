function compare(){
 temp=$(wget $1 -q -O -)
       state=$?
       t="$1"
       t="${t////\\}"
       if [ $state -eq 0 ]; then
                if [ ! -f "files/$t".txt ]; then
                        echo "$1 INIT"
                        touch "files/$t".txt
                        echo $temp > "files/$t".txt
                else
                        touch "files/tmp$t".txt
                       echo $temp > "files/tmp$t".txt
                    if ! cmp -s "files/$t".txt "files/tmp$t".txt; then
                                 echo "$t"
				 echo $temp > "files/$t".txt
                         fi
                rm "files/tmp$t".txt
                 fi
        else
		if [ ! -f "files/$t".txt ]; then
			>&2 echo "$1 FAILED"
		else
                	echo "FAILED" > "files/$t".txt
                	>&2 echo "$1 FAILED"
		fi
        fi
}

if [ ! -d "files" ]; then
       mkdir files
fi
grep "^[^#*]" $1 > "files/test1".txt
while read i ;
do
	compare $i &	
done <"files/test1".txt
wait
rm "files/test1".txt




