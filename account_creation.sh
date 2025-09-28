# Title:       account_creation.sh
# Auther:      Calvin Gross
# Date:        9/11/25
# Description: This program adds a user to the server and takes in
#              user input for the users name and role. Using this 
#              info it assigns the user a username and group.


# takes user input
read -p "Enter the first and last name of the new user: " first last
read -p "What is their role (User, AV Tech, or Admin): " role

# creates username
username="<$first>-<$last>"

# validify username and role.
echo "The username will be: $username and their role is $role."
read -p "Is this correct? (y/n): " correct

# If valid
if [ correct = 'y' ]; then
    
    # turns all to lowercase
    role=${role,,}

    # removes all spaces
    role=${role// /}

    # puts user in proper groups based on their roles.
    if [ $role = "admin" ]; then
        sudo useradd -m -G wheel $username

    elif [ $role = "vatech" ]; then
        sudo useradd -m -G video,audio $username

    else
        sudo useradd -m $username
    fi
    echo "$first's account has been created!"

# If not valid
else 
    echo "------Account Creation Canceled------"
    echo " $first's account will not be created"
fi

echo "account_ceation.sh Finished"
