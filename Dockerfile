FROM jekyll/jekyll:3.8.3 as build-stage

WORKDIR /tmp

COPY Gemfile* ./

RUN bundle install

WORKDIR /usr/src/app

COPY . .

RUN chown -R jekyll .

RUN jekyll build

FROM nginx:alpine

COPY --from=build-stage /usr/src/app/_site/ /usr/share/nginx/html

# see https://dev.to/levelupkoodarit/deploying-containerized-nginx-to-heroku-how-hard-can-it-be-3g14
CMD sed -i -e s/80/$PORT/g /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'
