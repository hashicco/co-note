FROM mysql:5.7.19

# Set debian default locale to ja_JP.UTF-8
RUN apt-get update && \
    apt-get install -y locales && \
    dpkg-reconfigure locales && \
    rm -rf /var/lib/apt/lists/* && \
    echo "ja_JP.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen ja_JP.UTF-8 && \
    update-locale ja_JP.UTF-8 && \
    \cp -fp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

ENV LC_ALL=ja_JP.UTF-8

COPY script/prepare_log_dir.sh /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/prepare_log_dir.sh




