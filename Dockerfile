FROM debian:jessie

RUN apt-get update && apt-get install -y \
	apache2 \
	git \
	mysql-client \
	php5 \
	php5-mysql \
	php5-sqlite \
	vim

COPY apache.conf /etc/apache2/sites-enabled/000-default.conf
COPY php.ini /usr/local/etc/php/
COPY deps deps.lock /var/www/
COPY bin/ /var/www/bin

WORKDIR /var/www/
RUN /var/www/bin/vendors install \
	&& find . -name "*.git" | xargs rm -r \
	&& mkdir /var/www/app/cache/dev \
	&& mkdir /var/www/app/cache/prod \
	&& chown -R www-data:www-data /var/www \
	&& chmod -R 755 /var/www \
	&& a2enmod rewrite

ENTRYPOINT ["apachectl"]
CMD ["DFOREGROUND"]
