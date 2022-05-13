ARG DEBIAN_FRONTEND=noninteractive

FROM ubuntu:20.04

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV TZ=Europe/Helsinki
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


# Install 
RUN apt-get update && apt-get install -y \
    wget \
    apache2 \
    python \
    python-dev \
    git \
    libapache2-mod-python \
    mysql-server \
    libmysqlclient-dev \
    build-essential \
    curl \
    unzip \
 && rm -rf /var/lib/apt/lists/*

# Install  pip
WORKDIR /pip-install
RUN wget https://bootstrap.pypa.io/pip/2.7/get-pip.py
RUN python2 get-pip.py

# Install and configure Kipa
WORKDIR /kipa-app
RUN wget https://github.com/partio-scout/kipa/archive/refs/heads/master.zip
RUN unzip master

WORKDIR /kipa-app/kipa-master
RUN ls -la && echo $PWD
RUN pip install -r requirements.txt

COPY ./apache2.conf /etc/apache2/sites-enabled/kipa-site.conf
COPY ./modules.conf /etc/apache2/conf-enabled/x_modules.conf

RUN chown www-data /kipa-app/kipa-master/web
RUN chown www-data /kipa-app/kipa-master/web/tupa.db
RUN ln -s /kipa-app/kipa-master/web/media /var/www/html/kipamedia

# Start apache2
CMD ["apache2ctl", "-D", "FOREGROUND"]