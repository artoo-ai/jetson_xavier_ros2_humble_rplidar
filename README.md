
# Run


```bash
docker run -it --privileged --rm --network host -v /dev:/dev --runtime nvidia dc7bc
```


```bash
source install/setup.bash
ros2 launch sllidar_ros2 view_sllidar_c1_launch.py
```


# Run
```bash
docker build -f Dockerfile -t rplidar:latest
```
