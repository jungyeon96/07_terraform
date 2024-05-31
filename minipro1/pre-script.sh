#!/bin/bash

echo -n "Enter Your filename: "
read SSH_KEY_FILE

ssh-keygen -t rsa -f ~/.ssh/$SSH_KEY_FILE -N ''
