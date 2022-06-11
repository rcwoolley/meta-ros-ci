#!/bin/bash

ROSDISTRO_REPO_PATH="/home/rosuser/rosdistro"
ROSDISTRO_REPO_URL="https://github.com/ros/rosdistro.git"

METAROS_REPO_PATH="/home/rosuser/meta-ros"
METAROS_REPO_URL="https://github.com/ros/meta-ros.git"

function checkGitRepo() {
    local REPO_NAME="$1"
    local REPO_PATH="$2"
    local REPO_URL="$3"

    # Check if the repository directory exists
    if [ ! -d "${2}" ]; then
        echo "WARN: ${1} (${2}) could not be found." >&2
        return 1
    fi

    if [ ! -d "${2}/.git" ]; then
        echo "WARN: ${1} (${2}/.git) could not be found." >&2
        return 2
    fi

    GIT_ORIGIN_URL=$(git -C ${2} config --get remote.origin.url)
    if [ "${3}" != ${GIT_ORIGIN_URL} ]; then
        echo "WARN: ${1} git repo origin URL does not match." >&2
        return 3
    fi

    return 0
}

function updateGitRepo() {
    local REPO_NAME="$1"
    local REPO_PATH="$2"
    local REPO_URL="$3"

    checkGitRepo "${REPO_NAME}" "${REPO_PATH}" "${REPO_URL}"
    if [ $? -eq 0 ]; then
        git -C "${REPO_PATH}" pull --rebase
    else
        git clone "${REPO_URL}" "${REPO_PATH}"
        if [ $? -ne 0 ]; then
            echo "ERROR: Could not could clone ${REPO_URL}" >&2
            return 1
        fi
    fi
    return 0
}


rosdep fix-permissions

# rosdistro
updateGitRepo "rosdistro repo" "${ROSDISTRO_REPO_PATH}" "${ROSDISTRO_REPO_URL}"
if [ $? -ne 0 ]; then
    exit 1
fi

cd ${ROSDISTRO_REPO_PATH}
ROSDISTRO_DATE=$(git show -s --format=%cd --date=format:'%Y-%m-%d')
ROSDISTRO_COMMIT=$(git show -s --format=%H)

rosdep update

# meta-ros
updateGitRepo "meta-ros repo" "${METAROS_REPO_PATH}" "${METAROS_REPO_URL}"
if [ $? -ne 0 ]; then
    exit 1
fi

cd ${METAROS_REPO_PATH}
for ROS_DISTRO in melodic noetic foxy galactic humble rolling; do
	sh scripts/ros-generate-cache.sh ${ROS_DISTRO} ${ROSDISTRO_DATE} ${ROSDISTRO_REPO_PATH} ${ROSDISTRO_COMMIT}
done

for ROS_DISTRO in melodic noetic foxy galactic humble rolling; do
	sh scripts/ros-generate-recipes.sh ${ROS_DISTRO}
done
