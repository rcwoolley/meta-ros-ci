docker run -it \
	-v $HOME/.gitconfig:/home/rosuser/.gitconfig \
	-v roscache:/home/rosuser/.ros \
	-v rosdistro:/home/rosuser/rosdistro \
	-v meta-ros:/home/rosuser/meta-ros \
	meta-ros-ci:latest $@
