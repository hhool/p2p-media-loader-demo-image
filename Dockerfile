FROM nginx:1.27.0-alpine3.19

RUN echo -e "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.19/main/\nhttps://mirror.tuna.tsinghua.edu.cn/alpine/v3.19/community/" > /etc/apk/repositories && \
    apk add --no-cache bash python3 py3-pip

# 调试工具
# RUN apk add --no-cache vim curl

ADD ./launcher /opt/launcher
RUN chmod +x /opt/launcher/launch.sh
RUN pip install -r /opt/launcher/requirements.txt --no-cache-dir --index-url https://pypi.tuna.tsinghua.edu.cn/simple/ --break-system-packages

ADD ./p2p-media-loader-demo /var/www/html

ENV HV_RELEASE=true
ENV HV_HTTP_PORT=80
ENV HV_HTTPS_CERT=
ENV HV_HTTPS_CERT_KEY=
ENV HV_P2P_TRACKERS=
ENV HV_P2P_ICE_SERVERS=

EXPOSE 80
VOLUME [ "/etc/launcher" ]

ENTRYPOINT [ "/opt/launcher/launch.sh" ]
