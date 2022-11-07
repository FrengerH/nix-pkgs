terminals=$(tmux ls | wc -l)
if [ $terminals -lt 1 ];
then
    tmux attach -t base || tmux new -s base
else
    tmux
fi
