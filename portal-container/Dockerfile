FROM ubuntu:22.04

ARG JOBS
ENV JOBS $JOBS
ARG USE_NICE
ENV USE_NICE $USE_NICE

RUN apt-get update && apt-get install -y \
  ffmpeg

WORKDIR /app

COPY ./video ./video/
COPY wait.sh .
RUN chmod 0777 wait.sh

# COPY entrypoint.sh /entrypoint.sh
# RUN chmod +x /entrypoint.sh
# ENTRYPOINT ["/entrypoint.sh"]

CMD ./wait.sh