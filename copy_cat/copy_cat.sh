# Title:       copy_cat.sh
# Auther:      Calvin Gross
# Date:        10/18/25
# Description: This program is my rendition of the linux core utility cat.
#              It can read into a new file or print the content from an  
#              existing file. It also contains the flag -n which numbers 
#              each line including empty lines and -b which numbers each
#              non-empty line.



# if no args read from stdin and write to stdout
if (( $# == 0 )); then

    # read each line and print to stdout
    # IFS is used so the line is not preemptively split
    # -r is used to disable / escapes
    while IFS= read -r line; do
        echo $line
    done

# else, there are args so we most read from a file
else

    # -n flag; number each output line including empty lines
    if [[ $1 == "-b" || $1 == "--number-nonblank" ]]; then

        for file in "$@"; do
            # if the file is readable
            if [[ -r "$file" ]]; then 

                # read each line and print to stdout
                # IFS is used so the line is not preemptively split
                # -r is used to disable / escapes
                c=1
                while IFS= read -r line; do
                    # if the line is empty
                    if [[ -z "$line" ]]; then
                        echo ""
                    # else if the line is not empty
                    else
                        echo "     $c  $line"
                        ((c+=1))
                    fi
                # read from the file this time, instead of stdin
                done < "$file"
            fi
        done


    # -n flag; number each output line including empty lines
    elif [[ $1 == "-n" || $1 == "--number" ]]; then

        for file in "$@"; do
            # if the file is readable
            if [[ -r "$file" ]]; then 

                # read each line and print to stdout
                # IFS is used so the line is not preemptively split
                # -r is used to disable / escapes
                c=1
                while IFS= read -r line; do
                    echo "     $c  $line"
                    ((c+=1))
                # read from the file this time, instead of stdin
                done < "$file"
            fi
        done


    # MAIN CASE / NO FLAGS
    else
        for file in "$@"; do
            
            # if the file is readable
            if [[ -r "$file" ]]; then 

                # read each line and print to stdout
                # IFS is used so the line is not preemptively split
                # -r is used to disable / escapes
                while IFS= read -r line; do
                    echo $line
                # read from the file this time, instead of stdin
                done < "$file"
            fi
        done
    fi
fi