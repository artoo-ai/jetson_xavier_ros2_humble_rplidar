#ARG IMAGE_NAME=dustynv/ros:humble-ros-base-l4t-r35.4.1
ARG IMAGE_NAME=dustynv/ros:humble-desktop-l4t-r35.4.1 

FROM ${IMAGE_NAME}

ARG ROS_DISTRO=humble

WORKDIR /root/ros2_ws

# Setup workspace
RUN git clone https://github.com/Slamtec/sllidar_ros2.git /root/ros2_ws/src/sllidar_ros2 && \
    source /opt/ros/$ROS_DISTRO/install/setup.bash && \
    rosdep update --rosdistro $ROS_DISTRO  && \
    rosdep install --from-paths src --ignore-src -y

# Create healthcheck package
#RUN cd /root/ros2_ws/src/ && \
#    source /opt/ros/$ROS_DISTRO/install/setup.bash && \
#    ros2 pkg create healthcheck_pkg --build-type ament_cmake --dependencies rclcpp sensor_msgs && \
#    sed -i '/find_package(sensor_msgs REQUIRED)/a \
#            add_executable(healthcheck_node src/healthcheck.cpp)\n \
#            ament_target_dependencies(healthcheck_node rclcpp sensor_msgs)\n \
#            install(TARGETS healthcheck_node DESTINATION lib/${PROJECT_NAME})' \
#            /root/ros2_ws/src/healthcheck_pkg/CMakeLists.txt

# Build
RUN source /opt/ros/$ROS_DISTRO/install/setup.bash && \
    source /opt/ros/$ROS_DISTRO/install/local_setup.bash && \
    colcon build --symlink-install --cmake-args --no-warn-unused-cli
    #echo $(cat /ros2_ws/src/sllidar_ros2/package.xml | grep '<version>' | sed -r 's/.*<version>([0-9]+.[0-9]+.[0-9]+)<\/version>/\1/g') > /version.txt && \
    #rm -rf build log

# Create udev rules
RUN cd /root/ros2_ws/src/sllidar_ros2 && \
    source /root/ros2_ws/install/setup.bash && \
    source scripts/create_udev_rules.sh

# Setup environment variables 
COPY ros_entrypoint_jetson.sh /sbin/ros_entrypoint.sh
RUN sudo chmod 755 /sbin/ros_entrypoint.sh

# Run RPLIDAR C1
#RUN source /opt/ros/$ROS_DISTRO/install/setup.bash && \
#    source /root/ros2_ws/install/setup.bash && \
#    #ros2 launch sllidar_ros2 view_sllidar_c1_launch.py
#    ros2 launch sllidar_ros2 sllidar_c1_launch.py

#CMD ["bash"]

ENTRYPOINT ["/sbin/ros_entrypoint.sh"]
CMD ["bash"]