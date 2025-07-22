FROM dustynv/jax:0.5.2-r36.4.0-cu128-24.04

RUN locale
RUN apt update && apt install locales -y
RUN locale-gen en_US en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
RUN export LANG=en_US.UTF-8
RUN apt install software-properties-common -y
RUN export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}') && \
    curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo $VERSION_CODENAME)_all.deb"
RUN dpkg -i /tmp/ros2-apt-source.deb

RUN apt update
RUN apt install tar bzip2 wget -y
ARG DEBIAN_FRONTEND=noninteractive
RUN apt install python3-colcon-common-extensions -y
RUN lsb_release -a
RUN apt install ros-dev-tools -y
RUN rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* && \
    apt update && \
    apt install -y --fix-missing ros-jazzy-desktop

RUN apt install -y ros-jazzy-ackermann-msgs 
RUN apt install -y ros-jazzy-tf-transformations 

RUN pip install flax==0.10.2 --no-cache-dir --index-url https://pypi.org/simple
RUN pip install numba --no-cache-dir --index-url https://pypi.org/simple
RUN pip install distrax --no-cache-dir --index-url https://pypi.org/simple

# default root user won't work with user outside of the docker in ROS
# RUN useradd -m -d /home/docker -u 1000 docker
# awk -F: '$3 >= 1000 { print $1, $3 }' /etc/passwd
RUN userdel -r ubuntu && useradd -m -d /home/docker -u 1000 docker
USER root

RUN apt install -y sudo
RUN usermod -aG sudo docker
RUN echo 'docker ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/docker && \
    chmod 0440 /etc/sudoers.d/docker

USER 1000:1000

ENV PATH="${PATH}:/home/docker/.local/bin"
RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc
RUN echo "PS1='\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> ~/.bashrc
# RUN echo "export ROS_DOMAIN_ID=99" >> ~/.bashrc




WORKDIR /home/docker
ENTRYPOINT ["bash", "-l"]

