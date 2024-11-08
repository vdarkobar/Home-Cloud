#!/bin/bash

# Install sudo if it's not already installed
apt update
apt install -y sudo

# Prompt for username and password with input validation
while true; do
    echo
    read -p "Enter a username for the new user: " USERNAME
    USERNAME=$(echo "$USERNAME" | xargs)  # Trim leading/trailing spaces

    if [[ -z "$USERNAME" || ! "$USERNAME" =~ ^[a-zA-Z0-9_]+$ ]]; then
        echo "Invalid username. Only alphanumeric characters and underscores are allowed. Please try again."
    else
        break
    fi
done

while true; do
    echo
    read -s -p "Enter a password for the new user: " PASSWORD
    echo
    if [[ -z "$PASSWORD" ]]; then
        echo "Password cannot be blank. Please enter a valid password."
    else
        read -s -p "Confirm the password: " PASSWORD_CONFIRM
        echo
        if [[ "$PASSWORD" != "$PASSWORD_CONFIRM" ]]; then
            echo "Passwords do not match. Please try again."
        else
            break
        fi
    fi
done

# Add the user
useradd -m -s /bin/bash $USERNAME

# Set the password for the new user
echo "$USERNAME:$PASSWORD" | chpasswd

# Add the user to the 'sudo' group
usermod -aG sudo $USERNAME

# Add new user to sudo
echo "$USERNAME ALL=(ALL) ALL" >> /etc/sudoers
