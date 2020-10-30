FROM redis:6.0.5-alpine

RUN apk add --no-cache \
    stunnel \
    python3 \
    py3-pip

RUN python3 -m pip install honcho==1.0.*

COPY ./certs/cert.pem /certs/cert.pem
COPY ./certs/key.pem /certs/key.pem

WORKDIR /
COPY stunnel.conf ProcfileWithoutPwd ProcfileWithPwd start.sh /
RUN chmod +x start.sh

ENV PYTHONUNBUFFERED=1
CMD ["sh", "start.sh"]
