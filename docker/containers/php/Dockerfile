ARG PHP_VERSION=7.3.3

FROM php:${PHP_VERSION}

ARG APCU_VERSION=5.1.11

ENV PHPIZE_DEPS \
		autoconf \
		dpkg-dev \
		file \
		g++ \
		gcc \
		libc-dev \
		make \
		pkg-config \
		re2c

# persistent / runtime deps
RUN apt-get update && apt-get install -y \
		$PHPIZE_DEPS \
		ca-certificates \
		curl \
		xz-utils \
		sudo \
		git \
        libzip-dev \
		zip \
		libicu-dev \
		libxml2-dev \
		libpng-dev \
	--no-install-recommends && rm -r /var/lib/apt/lists/* \
    && docker-php-ext-configure zip --with-libzip \
	&& docker-php-ext-install \
    		intl \
    		pdo_mysql \
    		zip \
    		soap \
    		gd

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
  php composer-setup.php --filename=composer --install-dir=/bin --version=1.7.3 && \
  php -r "unlink('composer-setup.php');"

# blackfire
RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
    && mkdir -p /tmp/blackfire \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire \
    && mv /tmp/blackfire/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini \
    && rm -rf /tmp/blackfire /tmp/blackfire-probe.tar.gz

WORKDIR /app

COPY docker-php-entrypoint /usr/local/bin/

ENTRYPOINT ["docker-php-entrypoint"]

