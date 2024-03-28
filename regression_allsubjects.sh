#for subj in $(seq -f "%02g" 1 10)
#do
#    ./regression.sh $subj
#done
for subj in $(seq -f "%02g" 1 10)
do
    ./regression.sh $subj
done