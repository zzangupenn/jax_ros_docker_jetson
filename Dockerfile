FROM dustynv/jax:r36.4.0

RUN locale
RUN apt update && apt install locales -y
RUN locale-gen en_US en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
RUN export LANG=en_US.UTF-8
RUN apt install software-properties-common -y
RUN add-apt-repository universe
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null
RUN apt update
RUN apt install tar bzip2 wget -y
ARG DEBIAN_FRONTEND=noninteractive
RUN apt install python3-colcon-common-extensions -y
RUN lsb_release -a
RUN apt install ros-humble-desktop -y

# default root user won't work with user outside of the docker in ROS
RUN useradd -m -d /home/docker -u 1000 docker
USER root
RUN chown -R docker:docker /workspace
USER 1000:1000
ENV PATH="${PATH}:/home/user/.local/bin"

RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
RUN echo "PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$ '" >> ~/.bashrc

WORKDIR /workspace
ENTRYPOINT ["bash", "-l"]

