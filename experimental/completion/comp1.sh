_foo() 
{
    local cur prev opts
    COMPREPLY=()
#    cur="${COMP_WORDS[COMP_CWORD]}"
#    prev="${COMP_WORDS[COMP_CWORD-1]}"
    _get_comp_words_by_ref -n : cur prev
    opts="--help --verbose --version"

    date >> foo-complete.log
    echo "cur is ${cur}" >> foo-complete.log

    if [[ ${cur} == -* ]] ; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        echo "COMPREPLY is ", ${COMPREPLY} >> foo-complete.log
        return 0
    fi
}
complete -F _foo foo
