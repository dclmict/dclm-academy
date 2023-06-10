#!/bin/sh
#
# ____          __  __  _____ 
# |  _ \   /\   |  \/  |/ ____|     repo:     https://github.com/opeoniye
# | |_) | /  \  | \  / | (___       porfolio: https://opeoniye.vercel.app/
# |  _ < / /\ \ | |\/| |\___ \      credit:   http://patorjk.com/software/taag/
# | |_) / ____ \| |  | |____) |
# |____/_/    \_\_|  |_|_____/ 
#                             
#
# Based on https://gist.github.com/2206527

# install dependencies
echo "\033[31mInstalling app dependencies\033[0m" && \
composer install --optimize-autoloader --no-dev && \

# start supervisord
echo "\033[31mStarting all services with supervisord\033[0m" && \
/usr/bin/supervisord -c /etc/supervisord.conf

# Moodle cron job
echo "\033[31mStarting cron jobs\033[0m"
cron