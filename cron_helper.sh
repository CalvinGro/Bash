# Title:       cron_helper.sh
# Auther:      Calvin Gross
# Date:        9/16/25
# Description: This program allows users to easily create a cron task.
#              They just decide how frequently to have there program run.
#              The program takes the provided pathway varifies it with which
#              and -e and -x. Then it takes the users input for how frequently
#              it should run. Then it verifies with the user that this is
#              what they want. If it is correct, then it adds it to the crontab.

echo "What is the cron task you want to run? Please input"
read -p "the file here: " pathway

# verification that the path is valid
pathway=$(which "$pathway")                     # use which to find the absolute path of the file
if [[ ! -e $pathway || ! -x $pathway ]]; then   # if the pathway does not exist or is not executable
        echo "Input does not exist or is not executable"
        exit 1
fi


echo "How frequently do you want this cron task to repeat?"
echo "Please input one of the following: hourly, daily, weekly, monthly, or custom."
read -p "Input frequency: " frequency

# turns frequency to lowercase
frequency=${frequency,,}

# removes all spaces
frequency=${frequency// /}

case $frequency in

    "hourly")
        # verify the cron task before creating
        echo "Do you want to schedule $pathway for every hour?"
        read -p "input (y/n)" continue
        if [[ ${continue,,} == 'y' ]]; then

            # "crontab -l" - list out current cron tasks
            # "2>/dev/null;" - send all errors (specifically the error it would throw if the list was empty) to /dev/null
            # "echo new cron task" - prints the new cron task after all the previous ones
            # "| crontab -" pipes all the previous stdout and reads it into crontab.
            # this process is repeated for all the cases
            (crontab -l 2>/dev/null; echo "@hourly $pathway") | crontab - 
        else 
            echo "Canceled event <$pathway hourly>"
            exit 2
        fi          
    ;;

    "daily")
        
        # verify the cron task before creating
        echo "Do you want to schedule $pathway for every day?"
        read -p "input (y/n)" continue
        if [[ ${continue,,} == 'y' ]]; then
            (crontab -l 2>/dev/null; echo "@daily $pathway") | crontab - 
        else 
            echo "Canceled event <$pathway daily>"
            exit 2
        fi
    ;;

    "monthly")
        
        # verify the cron task before creating
        echo "Do you want to schedule $pathway for every month?"
        read -p "input (y/n)" continue
        if [[ ${continue,,} == 'y' ]]; then
            (crontab -l 2>/dev/null; echo "@monthly $pathway") | crontab - 
        else 
            echo "Canceled event <$pathway monthly>"
            exit 2
        fi
    ;;

    "weekly")
        
        # verify the cron task before creating
        echo "Do you want to schedule $pathway for every week?"
        read -p "input (y/n)" continue
        if [[ ${continue,,} == 'y' ]]; then
            (crontab -l 2>/dev/null; echo "@weekly $pathway") | crontab - 
        else 
            echo "Canceled event <$pathway weekly>"
            exit 2
        fi
    ;;

    # handles a custom scheduled time
    "custom")
        echo "For your custom time, what month do you want it to operate in?"
        read -p "Please enter a number from 1 - 12 or * for every month: " month

        # validation of the month input
        if [[ ( $month != '*' ) && ( $month -gt 12 || $month -lt 1 ) ]]; then
            echo "Invalid input for the month, exiting."
            exit 1
        fi

        echo "Would you want to chose the day based of the current week day"
        echo "or day of the month? Please input either month or week"
        read -p "type of day: " day_type

        # clean up day_type
        day_type=${day_type,,}
        day_type=${day_type// /}
        case $day_type in

        "month")
        w_day='*'
        echo "What day in the month do you want your task to operate on? Please input"
        read -p "a number from 1-31 or * for everyday: " m_day

        # validation of day in the month input
        if [[ ( $m_day != '*' ) && ( $m_day -gt 31 || $m_day -lt 1 ) ]]; then
            echo "Invalid input in day of the month, exiting."
            exit 1
        fi

        ;;

                "week")
        m_day='*'
        echo "What day in the week do you want your task to operate on? Please input a number"
        read -p "from 0-6 (0=sunday) or * for everyday: " w_day

        # validation of week day input
        if [[ ( $w_day != '*' ) && ( $w_day -gt 6 || $w_day -lt 0 ) ]]; then
            echo "Invalid input in week day, exiting."
            exit 1
        fi

        ;;
        esac

        echo "What hour in the day do you want your task to run? Please input a"
        read -p "number from 0-23 or * for every hour: " hour

        # validation of hour input
        if [[ ( $hour != '*' ) && ( $hour -gt 23 || $hour -lt 0 ) ]]; then
            echo "Invalid input in hour, exiting."
            exit 1
        fi

        echo "What minute in the hour do you want your task to run? Please input a"
        read -p "number from 0-59 or * for every hour: " minute

        # validation of minute input
        if [[ ( $minute != '*' ) && ( $minute -gt 59 || $minute -lt 0 ) ]]; then
            echo "Invalid input in minute, exiting."
            exit 1
        fi

        # verify the cron task before creating
        echo "Do you want to schedule $pathway for $minute $hour $m_day $month $w_day?"
        read -p "input (y/n)" continue
        if [[ ${continue,,} == 'y' ]]; then
            (crontab -l 2>/dev/null; echo "$minute $hour $m_day $month $w_day $pathway") | crontab - 
        else 
            echo "Canceled event <$pathway at $minute $hour $m_day $month $w_day>"
            exit 2
        fi

    ;;

    # catch all
    *)
        echo "Invalid Frequency"
    ;;
esac