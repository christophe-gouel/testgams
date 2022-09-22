FROM python:3.10-bullseye

ARG GAMS_MAJOR=40
ARG GAMS_MINOR=3
ARG GAMS_MAINT=0

RUN apt-get update && apt-get install wget -y
RUN wget https://d37drm4t2jghv5.cloudfront.net/distributions/${GAMS_MAJOR}.${GAMS_MINOR}.${GAMS_MAINT}/linux/linux_x64_64_sfx.exe && \
    chmod a+x linux_x64_64_sfx.exe && \
    ./linux_x64_64_sfx.exe && \
    rm linux_x64_64_sfx.exe && \
    mv "gams${GAMS_MAJOR}.${GAMS_MINOR}_linux_x64_64_sfx" "/opt/gams"

RUN pip install jupyterlab pandas tabulate matplotlib && \
    cd /opt/gams/apifiles/Python/api_310 && \
    export SETUPTOOLS_USE_DISTUTILS=stdlib && \
    python setup.py install

ENV PATH="/opt/gams:${PATH}"

CMD [ "jupyter", "notebook", "--ip=0.0.0.0", "--port=8087", "--allow-root", "--no-browser" ]

EXPOSE 8080
