# -----
FROM node:15.5.1-alpine AS build

RUN apk update
RUN apk add --no-cache bash nano coreutils
# RUN apk add --no-cache python gcc make g++ build-base git lzo bzip2 openssl bash file postgresql mosquitto nano go coreutils
#ENV PYTHONUNBUFFERED=1
#RUN apk add --no-cache python3 && \
#    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi 


#RUN mv /usr/src/dagviz/k-explorer /usr/src/k-explorer
#RUN cd /usr/src/k-explorer && npm install && npm link
#RUN npm link k-explorer
#RUN mv /usr/src/dagviz/k-explorer /usr/src/dagviz/k-explorer
#RUN cd /usr/src/dagviz/k-explorer && npm install && npm link
#RUN npm link k-explorer

RUN addgroup -S faucet && adduser -S faucet -G faucet
RUN mkdir -p /run/postgresql
RUN chown karlsen-desktop:karlsen-desktop /run/postgresql

# Tell docker that all future commands should run as the appuser user

WORKDIR /home/faucet/releases/faucet
COPY . .
RUN rm -rf node_modules
RUN rm package-lock.json
#RUN chown -R karlsen-desktop:karlsen-desktop .


RUN npm install
RUN npm install -g emanator@latest
RUN emanate karlsend

USER faucet

EXPOSE 42110 42210 42510 42610 42111 42211 42511 42611

ENTRYPOINT ["node","karlsen-faucet-website.js","--run-karlsen-desktop","--testnet","--devnet"]
