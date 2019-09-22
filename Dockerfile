FROM php:7.2-apache

## Step 1:
RUN rm /var/www/html/index.php

## Step 2:
# Copy source code to working directory
COPY app/ /var/www/html/

WORKDIR /var/www/html/

EXPOSE 80

