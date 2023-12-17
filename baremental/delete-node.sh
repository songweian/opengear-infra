for i in {1..5}
do
    multipass delete k$i
done

multipass purge
