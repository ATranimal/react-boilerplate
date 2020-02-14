FROM node:12-alpine as build-deps

WORKDIR /usr/src/app
RUN npm install react-scripts@2.1.8 -g --silent

COPY ./package.json ./yarn.lock ./

RUN yarn
COPY ./ ./
RUN CI=true npm test
RUN yarn build

FROM nginx:1.15.9-alpine
COPY --from=build-deps /usr/src/app/build /usr/share/nginx/html
COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]