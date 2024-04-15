This is intended to run on an Jetson Xavier AGX board.  The
code uses a docker container from dustynv and https://github.com/husarion/rplidar-docker.

# Build
```bash
docker build -f Dockerfile .
```


# Run
```bash
docker run -it --privileged --rm --network host -v /dev:/dev --runtime nvidia <docker_image>
```


# Docker Container Internally
Internally the docker container is using ros_entrypoint_jetson.sh to source
and run the RPLidar code.
```bash
source install/setup.bash
ros2 launch sllidar_ros2 sllidar_c1_launch.py
```


