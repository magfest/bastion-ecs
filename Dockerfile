FROM alpine

RUN apk add --no-cache openssh bash curl sudo
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x entrypoint.sh

ENV USERS=bitbyt3r,kitsuta

EXPOSE 22
ENTRYPOINT [ "/entrypoint.sh" ]