FROM debian

RUN set -ex \
 && apt-get -y update \
 && apt-get -y upgrade \
 && apt-get -y install lib32gcc1 lib32z1 lib32ncurses5 curl \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
 && adduser --disabled-password --gecos "" gameserver

USER gameserver
ENV HOME /home/gameserver
ENV SERVER $HOME/server
ENV STEAMCMD $HOME/steamcmd

RUN set -ex \
 && mkdir -p $SERVER $STEAMCMD \
 && curl -sSLf http://media.steampowered.com/client/steamcmd_linux.tar.gz | tar -C $STEAMCMD -xvz

ADD ./install.txt $SERVER/install.txt
ADD ./update.sh $SERVER/update.sh
ADD ./start.sh $SERVER/start.sh

RUN $SERVER/update.sh

EXPOSE 27000/udp 27000/tcp 27003/udp 27020 27021
VOLUME "/home/gameserver/.avorion"

ENTRYPOINT ["/home/gameserver/server/start.sh"]
CMD ["--"]
