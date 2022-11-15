FROM inspectablocktech/php:v0.15

ARG CPUS
ENV CPUS $CPUS

RUN apt-get update && apt-get install -y \
  stress-ng

WORKDIR /app

COPY wait.sh .
RUN chmod 0777 wait.sh

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ./wait.sh