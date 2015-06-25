#!/bin/sh


echo "Database URL\n"


bundle exec rake db:migrate
bundle exec unicorn -p ${PORT} -c config/deploy/unicorn.rb -E ${RAILS_ENV}
