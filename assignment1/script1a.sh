if [ ! -d "filesTemp12345" ]; then
       mkdir filesTemp12345
fi
grep  "^[^#*]" $1 >"filesTemp12345/test1".txt
while read i ;
do
       temp=$(wget $i -q -O -)
       state=$?
       t="$i"
       t="${t////\\}"
       if [ $state -eq 0 ]; then
                if [ ! -f "filesTemp12345/$t".txt ]; then
                        echo "$i INIT"
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
                        >&2 echo "$i FAILED"
                else
                        echo "FAILED" > "filesTemp12345/$t".txt
                        >&2 echo "$i FAILED"
                fi
        fi
done <"filesTemp12345/test1".txt
rm "filesTemp12345/test1".txt

