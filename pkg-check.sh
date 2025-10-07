# Title:       pkg-check.sh
# Auther:      Calvin Gross
# Date:        9/28/25
# Description: This program is meant to be used as a cron task. It 
#              first updates the package repositories, then it creates
#              a list of every package that needs upgrading and outputs
#              it to a text file (update-list.txt) for the user to view.


# update all package repositories
sudo apt update

# If update-list doesn't exist then > creates it, otherwise it is overwritten.
apt list --upgradeable > /var/tmp/update-list.txt
