if [ ! -d "files" ]; then
       mkdir files
fi
grep  "^[^#*]" $1 >"files/test1".txt
while read i ;
do
       temp=$(wget $i -q -O -)
       state=$?
       t="$i"
       t="${t////\\}"
       if [ $state -eq 0 ]; then
                if [ ! -f "files/$t".txt ]; then
                        echo "$i INIT"
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
                        >&2 echo "$i FAILED"
                else
                        echo "FAILED" > "files/$t".txt
                        >&2 echo "$i FAILED"
                fi
        fi
done <"files/test1".txt
rm "files/test1".txt

