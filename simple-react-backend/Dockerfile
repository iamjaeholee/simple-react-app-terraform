FROM node:10.12.0-alpine

RUN mkdir -p /home/back
WORKDIR /home/back

COPY package.json ./
RUN npm i

COPY app.js ./
COPY bin ./bin
COPY routes ./routes

RUN mkdir /root/.aws
COPY credentials /root/.aws/credentials

RUN cat /root/.aws/credentials

EXPOSE 6449
ENV PORT 6449

ENTRYPOINT ["npm", "run-script", "start"]
