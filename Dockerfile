FROM alpine:3.6
RUN apk add -U --no-cache nfs-utils tzdata &&\
		rm -rf /var/cache/apk/*
EXPOSE 111/udp 2049/tcp
ARG EXPORT_DIR=/exports
VOLUME $EXPORT_DIR
ENV ALLOW_HOST=\* SETTING=rw,sync,no_root_squash,insecure,fsid=0,no_subtree_check
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
CMD ["entrypoint.sh"]
