FROM ubuntu:16.04
MAINTAINER Jonathan Langford <jrobinlangford@gmail.com>

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        ca-certificates \
	apache2 \
        imagemagick \
        netcat \
        git

RUN apt-get update && \
    apt-get install -y \
        python-software-properties \
	software-properties-common

# XXX: Consider switching to nginx.
RUN set -x; \
    LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        libapache2-mod-php7.1 \
        php7.1-mysql \
        php7.1-cli \
        php7.1-gd \
        php7.1-curl \
        php7.1-mbstring \
        php7.1-xml  && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/archives/* && \
    a2enmod rewrite && \
    a2enmod proxy && \
    a2enmod proxy_http && \
    # Remove the default Debian index page.
    rm /var/www/html/index.html


ENV MEDIAWIKI_VERSION 1.29.0
# MediaWiki setup
RUN set -x; \
    mkdir -p /usr/src \
    && git clone \
        --depth 1 \
        -b $MEDIAWIKI_VERSION \
        https://gerrit.wikimedia.org/r/p/mediawiki/core.git \
        /usr/src/mediawiki \
    && cd /usr/src/mediawiki \
    && git submodule update --init skins \
    && git submodule update --init vendor

RUN set -x; \
    cd /usr/src/mediawiki/extensions \
    # Extensions
    # TODO: make submodules shallow clones?
    && git submodule update --init --recursive Cite \
    && git submodule update --init --recursive CiteThisPage \
    && git submodule update --init --recursive ConfirmEdit \
    && git submodule update --init --recursive Gadgets \
    && git submodule update --init --recursive ImageMap \
    && git submodule update --init --recursive InputBox \
    && git submodule update --init --recursive Interwiki \
    && git submodule update --init --recursive LocalisationUpdate \
    && git submodule update --init --recursive Nuke \
    && git submodule update --init --recursive ParserFunctions \
    && git submodule update --init --recursive Poem \
    && git submodule update --init --recursive Renameuser \
    && git submodule update --init --recursive SimpleAntiSpam \
    && git submodule update --init --recursive SyntaxHighlight_GeSHi \
    && git submodule update --init --recursive TitleBlacklist \
    && git submodule update --init --recursive Vector \
    && git submodule update --init --recursive WikiEditor

 RUN set -x; \
    cd /usr/src/mediawiki/extensions \
    && git clone \
	--depth 1 \
	-b REL1_29 \
	https://gerrit.wikimedia.org/r/p/mediawiki/extensions/VisualEditor.git \
    && cd VisualEditor \
    && git submodule update --init --recursive


COPY php.ini /usr/local/etc/php/conf.d/mediawiki.ini

COPY apache/mediawiki.conf /etc/apache2/
RUN echo "Include /etc/apache2/mediawiki.conf" >> /etc/apache2/apache2.conf

COPY CustomSettings.php conf/CustomSettings.php

COPY docker-entrypoint.sh /entrypoint.sh

EXPOSE 80 443
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apachectl", "-e", "info", "-D", "FOREGROUND"]
