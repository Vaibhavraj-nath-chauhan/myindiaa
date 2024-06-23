FROM node:18

WORKDIR /code

COPY package.json /code/package.json

RUN npm install

COPY . /code

CMD ["npm", "start"]