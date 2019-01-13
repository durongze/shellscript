#!/bin/bash
gcc hello.c -static -o hello
sudo docker build -f Dockerfile -t dyzhello:1.1 .
