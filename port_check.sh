# Title:       port-check.sh
# Auther:      Calvin Gross
# Date:        10/7/25
# Description: This program determines if a specific port or ports are currently
#              in use. It does so by creating a hashtable of every port that is
#              currently in use. Then it takes in any number of given arguments
#              which are the port numbers and checks if a key exists for that port
#              in the hash. This has a computational complexity of O(n).


# output help statement if help flag is passed or if an invaild call is made (no args were passed).
# -eq used for number comparison
if [[ $# -eq 0 || $1 == "-h" || $1 == "--help" ]]; then
    echo -e "Usage: port_check [ports]...\n"
    echo "Flags:"
    echo "      -v, --verbose       be verbose"
    echo -e "      -h, --help          show this explaination\n"
    echo "Description:"
    echo "      This program determines if a specific port or ports are currently"
    echo "      in use. It does so by creating a hashtable of every port that is"
    echo "      currently in use. Then it takes in any number of given arguments"
    echo "      which are the port numbers and checks if a key exists for that port"
    echo -e "      in the hash.\n"
    echo "Exit Codes:"
    echo "      None of the provided ports are currently in use."
    echo -e "      At least one of the provided ports is currently in use.\n\n"

    # exit code 0 cause nothing went wrong and no code found
    exit 0
fi


# creates a hashtable for every port in use
declare -A ports_in_use

# for each line of output from netstat -t, skipping the first two lines,
# set col_4 = 4th column
for col_4 in $(netstat -t | awk 'NR>2 {print $4}'); do
    # splits the local address and takes what is after the colon (the port number)
    ports_in_use["${col_4##*:}"]=1
done

# VERBOSE OPTION

if [[ $1 == "-v" || $1 == "--verbose" ]]; then
    ports=()
    # for every given argument
    for arg in "$@"; do
        # if key for the provided arg is in the hashtable ports_in_use,
        # then return exit code 1 because at least one of the provided
        # ports is in use.
        if [[ -v ports_in_use["$arg"] ]]; then
            ports+=("$arg")
        fi
    done

    # if none of the ports are in use (length of ports = 0) and exit with 0
    if [[ ${#nums[@]} == 0 ]]; then
        echo "None of the provided ports are in use."
        exit 0
    fi

    # else print each port being used and exit with 1
    echo "Ports in use: ${nums[@]}"
    exit 1
fi

# NON-VERBOSE OPTION

# for every given argument
for arg in "$@"; do
    # if key for the provided arg is in the hashtable ports_in_use,
    # then return exit code 1 because at least one of the provided
    # ports is in use.
    if [[ -v ports_in_use["$arg"] ]]; then
    exit 1
    fi
done

# if none of the ports in the arguments were found in the 
# hash of ports in use, than return exit code 0.
exit 0























