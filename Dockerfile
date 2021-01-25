FROM ubuntu:bionic

RUN apt update \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt install php7.2 -y \
  && apt install wget -y \
  && apt-get install php-dev -y \
  && wget https://raw.githubusercontent.com/composer/getcomposer.org/76a7060ccb93902cd7576b67264ad91c8a2700e2/web/installer -O - -q | php -- --quiet \
  && mv /composer.phar /usr/local/bin/composer \
  && composer --version \
  && wget https://get.symfony.com/cli/installer -O - | bash \
  && mv /root/.symfony/bin/symfony /usr/local/bin/symfony \
  && apt install php-pear -y \
  && pecl install mongodb \
  && apt install git zip unzip php-zip -y \
  && apt-get install php-mongodb -y \
  && apt-get install php7.2-mbstring \
#  && echo "extension=mongodb.so" >> /etc/php/7.2/cli/php.ini \
  && php --ri mongodb | grep version \
  && mkdir -p /home/user/project \
  && chown 1000:1000 /home/user/project \
  && chmod 777 /home/user/project \
  && rm -rf /var/lib/apt/lists/*

COPY phpruntime.ini /etc/php/7.2/cli/conf.d

WORKDIR /home/user/project

COPY composer.json .
RUN composer install
COPY .env .
COPY .env.test .
COPY .phpunit.result.cache .
COPY phpunit.xml.dist .
COPY symfony.lock .

ENTRYPOINT ["symfony", "server:start", "--port=80", "--no-tls"]

