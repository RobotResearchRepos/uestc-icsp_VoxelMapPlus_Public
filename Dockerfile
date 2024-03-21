FROM osrf/ros:noetic-desktop-full

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y git \
 && rm -rf /var/lib/apt/lists/*

RUN  mkdir -p /catkin_ws/src/VoxelMapPlus_Public

COPY . /catkin_ws/src/VoxelMapPlus_Public

RUN git clone https://github.com/Livox-SDK/livox_ros_driver /catkin_ws/src/livox_ros_driver

RUN . /opt/ros/$ROS_DISTRO/setup.bash \
 && apt-get update \
 && rosdep install -r -y \
     --from-paths /catkin_ws/src \
     --ignore-src \
 && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
 && apt-get install -y libgoogle-glog-dev \
 && rm -rf /var/lib/apt/lists/*

RUN git clone https://ceres-solver.googlesource.com/ceres-solver \
 && cd ceres-solver && mkdir build && cd build \
 && cmake .. -DBUILD_TESTING=OFF -DBUILD_EXAMPLES=OFF \
 && make install \
 && cd .. && rm -fr ceres-solver

RUN . /opt/ros/$ROS_DISTRO/setup.bash \
 && cd /catkin_ws \
 && catkin_make -j1
 
 
