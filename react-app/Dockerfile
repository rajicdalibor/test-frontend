FROM node:16-alpine as builder

WORKDIR /app

COPY package*.json ./


RUN yarn install

COPY . .

RUN yarn build

FROM nginx:alpine

COPY nginx.conf /etc/nginx/conf.d/configfile.template
ENV PORT 3000
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 3000

COPY nginx-entrypoint.sh /
ENTRYPOINT [ "sh", "/nginx-entrypoint.sh" ]
