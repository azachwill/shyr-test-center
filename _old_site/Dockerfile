# This Dockerfile is used to create a Docker image for Jenkins, for automatic
# deployment of the site.
#
# Build Docker image:
#   docker build -t shiny-dev-center .
#
# Run container interactively:
#   docker run --rm -it -v $(pwd):/opt/shiny-dev-center -w /opt/shiny-dev-center shiny-dev-center bash

FROM ubuntu:18.04

RUN apt-get update -qq \
  && apt-get install -y \
    software-properties-common \
    locales \
    build-essential \
    git \
    openssh-client \
    python \
    python-pip \
    rsync \
    sudo

RUN apt-add-repository -y ppa:rael-gc/rvm \
  && apt-get update -qq \
  && apt-get install -y rvm

RUN /usr/sbin/locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

RUN pip install awscli

ARG JENKINS_GID=999
ARG JENKINS_UID=999
RUN groupadd -g $JENKINS_GID jenkins && \
    useradd -m -d /var/lib/jenkins -u $JENKINS_UID -g jenkins jenkins && \
    echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN /bin/bash -l -c '/usr/share/rvm/bin/rvm install ruby ruby-2.6.2'
RUN cp /usr/share/rvm/environments/ruby-2.6.2 /etc/profile.d/02-ruby.sh
RUN bash -l -c 'gem install bundler -v 1.17.3'

ENTRYPOINT ["/bin/bash", "-l", "-c"]
