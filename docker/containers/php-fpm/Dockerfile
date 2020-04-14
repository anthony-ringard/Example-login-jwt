ARG PHP_VERSION=7.3.3

FROM php:${PHP_VERSION}-fpm-alpine3.8

ARG APCU_VERSION=5.1.11

RUN set -xe \
	&& apk add --no-cache --virtual .build-deps \
		$PHPIZE_DEPS \
		icu-dev \
        libzip-dev \
        zip \
        mysql-client \
		libxml2-dev \
		curl \
		unzip \
		gd \
		libpng-dev \
    && docker-php-ext-configure zip --with-libzip \
	&& docker-php-ext-install -j$(nproc) \
		intl \
		mysqli \
		pdo_mysql \
		zip \
		soap \
		bcmath \
		gd \

	&& pecl install \
		apcu-${APCU_VERSION} \
	&& pecl install -o -f redis \
	&& pecl clear-cache \
	&& docker-php-ext-enable --ini-name 20-apcu.ini apcu \
	&& docker-php-ext-enable --ini-name 05-opcache.ini opcache \
	&& rm -rf /tmp/pear \
    && docker-php-ext-enable redis \
	&& runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	    )" \
	&& apk add --no-cache --virtual .api-phpexts-rundeps $runDeps

# blackfire
RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/alpine/amd64/$version \
    && mkdir -p /tmp/blackfire \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire \
    && mv /tmp/blackfire/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini \
    && rm -rf /tmp/blackfire /tmp/blackfire-probe.tar.gz

