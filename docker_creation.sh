#!/bin/bash

if [[ ( $@ == "--help") ||  $@ == "-h" ]]
then 
	echo "Usage: $0 [IMAGE_NAME] [CONTAINER_NAME] [DEVEL FOLDER]"
	exit 0
fi 

if [[ ($# -eq 0 ) ]]
then
	echo "No arguments specified, using wizard mode"
	
	echo "Insert the absolute path of the dev folder [~/dev]"
	read dev_folder
	if [[ ($dev_folder -eq "") ]]
	then 
		dev_folder="/home/$USER/dev"
	fi
	if [ ! -d $dev_folder ] 
	then
		echo "[WARNING] devel folder doesn't exists, creating a new one"
		mkdir /home/$USER/dev
		#exit 0
	fi
	echo dev folder: $dev_folder
	
	echo "Insert the name image for the container or select an image"
	echo "1 - ROS1 image"
	echo "2 - ROS2 image"
	
	read in
	if [[ ($in -eq "1") ]]
	then
		echo "Selected ROS1 image"
		im_name=osrf/ros:noetic-desktop		
	elif [[ ($in -eq "2") ]]
	then
			echo "Selected ROS2 image"
			im_name=osrf/ros:humble-desktop
	else
			im_name=$in
	fi
	
	echo "Image name: " $im_name
	
	
	echo "Insert the name of the container"
	read container_name
	
	
	for c in $(docker container ls -a --format '{{.Names}}')
	do
		if [ $container_name == $c ] 
		then
			echo "[ERROR] Name already used for a container, exiting"
			exit 0
		fi
	done
else
	im_name=$1
	container_name=$2
	dev_folder=$3
fi


echo -e "\n\nCreating a new container" 
echo "Docker Image ... " $im_name
echo "Container name ... " $container_name
echo "Developer folder ... " $dev_folder

##Without sharing a folder

#xhost +

docker run -it --privileged \
-e LOCAL_USER_ID=$(id -u) \
-v $dev_folder:/home/dev/:rw \
-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
-e DISPLAY=:0 \
--network host \
--workdir="/home/dev/" \
--name=$container_name $im_name bash



