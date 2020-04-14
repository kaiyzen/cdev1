FROM mhart/alpine-node:12

WORKDIR /app
COPY catapult-rest/ .

# If you have native dependencies, you'll need extra tools
RUN apk add --no-cache make gcc g++ python
RUN npm install -g yarn
RUN ./yarn_setup.sh
RUN cd rest && pwd && ls -al && yarn run build

EXPOSE 3000

WORKDIR /app/rest

CMD ["yarn", "start", "resources/rest.json"]
