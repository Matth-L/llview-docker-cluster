# This dockerfile builds the Web Version of LLView
# .ie https://apps.fz-juelich.de/jsc/llview/docu/install/juri_install/
# Author : Matthias LAPU (CEA)

FROM php:7.2-apache

RUN a2enmod authz_groupfile headers rewrite

# Activate :         AllowOverride All
# Deactivate .htaccess in the other folder. It's a proof of concept we do not
# need all the users to connect
COPY ./000-default.conf /etc/apache2/sites-enabled/000-default.conf

EXPOSE 80