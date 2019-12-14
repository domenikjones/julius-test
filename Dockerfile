FROM ubuntu:latest

RUN apt-get update  --fix-missing
RUN apt-get install -y build-essential git curl unzip
RUN apt-get install -y alsa-base alsa-utils pulseaudio socat
RUN apt-get install -y zlib1g-dev libsdl2-dev libasound2-dev

RUN git clone https://github.com/julius-speech/julius.git
WORKDIR /julius

RUN chmod +x ./configure
RUN ./configure --enable-words-int
RUN make -j4
RUN ls -l julius/julius
COPY ./models/english/ENVR-v5.4.Dnn.Bin.zip ..
WORKDIR ..
RUN unzip ENVR-v5.4.Dnn.Bin.zip
WORKDIR ENVR-v5.4.Dnn.Bin
COPY ./models/english/dnn.jconf .
COPY ./models/english/mic.jconf .
COPY ./models/english/network.jconf .

CMD ../julius/julius/julius -module -C network.jconf -dnnconf dnn.jconf
#RUN ../julius/julius/julius -C julius.jconf -dnnconf dnn.jconf
#RUN ../julius/julius/julius -C mic.jconf -dnnconf dnn.jconf
#RUN ../julius/julius/julius -module -C mic.jconf
#WORKDIR ../julius/julius/
#RUN export ALSADEV="plughw:1,0"