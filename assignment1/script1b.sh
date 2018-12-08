function compare(){
 temp=$(wget $1 -q -O -)
       state=$?
       t="$1"
       t="${t////\\}"
       if [ $state -eq 0 ]; then
                if [ ! -f "filesTemp12345/$t".txt ]; then
                        echo "$1 INIT"
                        touch "filesTemp12345/$t".txt
                        echo $temp > "filesTemp12345/$t".txt
                else
                        touch "filesTemp12345/tmp$t".txt
                       echo $temp > "filesTemp12345/tmp$t".txt
                    if ! cmp -s "filesTemp12345/$t".txt "filesTemp12345/tmp$t".txt; then
                                 echo "$t"
				 echo $temp > "filesTemp12345/$t".txt
                         fi
                rm "filesTemp12345/tmp$t".txt
                 fi
        else
		if [ ! -f "filesTemp12345/$t".txt ]; then
			>&2 echo "$1 FAILED"
		else
                	echo "FAILED" > "filesTemp12345/$t".txt
                	>&2 echo "$1 FAILED"
		fi
        fi
}

if [ ! -d "filesTemp12345" ]; then
       mkdir files
fi
grep "^[^#*]" $1 > "filesTemp12345/test1".txt
while read i ;
do
	compare $i &	
done <"filesTemp12345/test1".txt
wait
rm "filesTemp12345/test1".txt




