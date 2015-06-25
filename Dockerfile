FROM ruby:2.2.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs vim
ENV RAILS_ENV production
ENV APP_DIR /docker_composer
ENV GEM_DIR /docker_composer/gems
RUN adduser --system --group deploy
RUN mkdir ${APP_DIR}
WORKDIR ${APP_DIR}
RUN chown -R deploy:deploy ${APP_DIR}
USER deploy
RUN mkdir .bundle gems
ADD Gemfile ${APP_DIR}/Gemfile
ADD Gemfile.lock ${APP_DIR}/Gemfile.lock
ENV GEM_HOME ${GEM_DIR}
ENV GEM_PATH ${GEM_DIR}
RUN gem install bundler
ENV BUNDLE_APP_CONFIG /docker_composer/.bundle/config
RUN bundle config --global path /docker_composer/.bundle
RUN bundle install --deployment --without development:test --path /docker_composer/.bundle
ADD . ${APP_DIR}
USER root
RUN chown -R deploy:deploy ${APP_DIR}
USER deploy
ENV PORT 8000
EXPOSE ${PORT}
RUN touch ${APP_DIR}/log/${RAILS_ENV}.log
ENV SECRET_KEY_BASE 06614348ee23dbba0fd6a1b06fef18b7cd894ca7deaa1fa5dd863eebb4e33af1fd4365eb8f707645c55c50e3af8c032065d012f388484247748df584e017bcab
CMD ["config/deploy/db_tasks.sh"]
