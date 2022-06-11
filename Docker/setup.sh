#!/bin/bash

set -eux

# Superflore
git clone https://github.com/ros-infrastructure/superflore.git
cd superflore
python3 ./setup.py install
cd ..

# rosdep
rosdep init

sed -ie "s|^\(yaml.*osx\)|#\1|" /etc/ros/rosdep/sources.list.d/20-default.list
sed -ie "s|https://raw.githubusercontent.com/ros/rosdistro/master/rosdep|file:///home/rosuser/rosdistro/rosdep|" /etc/ros/rosdep/sources.list.d/20-default.list
