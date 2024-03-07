#!/bin/bash

for a in `docker ps -a -q`
do
  echo "Stopping container - $a"
  docker rm $a
  docker kill $a
done

sudo docker rm $(docker ps -a -q)
sudo docker kill $(docker ps -a -q)
docker kill $(docker ps -q)



