function broot
    set -l orig_dir $PWD
    while not test $PWD = "/" && not test -e WORKSPACE
        cd ..
    end
    if not test -e WORKSPACE
        echo "Can not locate WORKSPACE file"
        cd $orig_dir
    end
end
