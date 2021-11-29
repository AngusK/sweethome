function tattach --description 'Attach tmux session' --argument sess_name
    if not test -n "$sess_name"
        set sess_name "0"
    end
    echo "Attaching session $sess_name"
    sleep 0.5
    tmux attach-session -t $sess_name
end
