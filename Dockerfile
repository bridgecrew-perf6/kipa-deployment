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

WORKDIR /kipa-app
RUN wget https://github.com/partio-scout/kipa/archive/refs/heads/master.zip
RUN unzip master

WORKDIR /kipa-app/kipa-master
RUN ls -la && echo $PWD
RUN pip install -r requirements.txt


COPY ./apache2.conf /etc/apache2/sites-enabled/kipa-site.conf
COPY ./modules.conf /etc/apache2/conf-enabled/x_modules.conf
RUN cat /etc/apache2/apache2.conf
RUN cat /etc/apache2/sites-enabled/kipa-site.conf

RUN chown www-data /kipa-app/kipa-master/web
RUN chown www-data /kipa-app/kipa-master/web/tupa.db
RUN ln -s /kipa-app/kipa-master/web/media /var/www/html/kipamedia

#RUN cat /usr/local/apache2/conf/httpd.conf

#EXPOSE 80 3500 
CMD ["apache2ctl", "-D", "FOREGROUND"]
#CMD ["systemctl", "restart", "apache2"]

# set environment variables
# ENV PYTHONDONTWRITEBYTECODE 1
# ENV PYTHONUNBUFFERED 1

# install dependencies
# RUN pip install --upgrade pip

# COPY ./kipa/ /app/

# RUN echo "PYTHONPATH=/usr/local/lib/python2.7/site-packages" | tee -a /etc/profile

# RUN pip install -r /app/requirements.txt

# ENTRYPOINT ["/app/docker-entrypoint.sh"]



