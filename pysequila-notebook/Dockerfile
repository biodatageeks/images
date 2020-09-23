ARG BASE_IMAGE=jupyter/minimal-notebook
FROM $BASE_IMAGE


USER root

ARG JAVA_VERSION=8.0.265.hs-adpt
ARG SCALA_VERSION=2.11.12
ARG SBT_VERSION=1.3.10
ARG SPARK_VERSION
ARG SEQUILA_VERSION
ARG PYSEQUILA_VERSION
ARG HADOOP_VERSION=2.7
ARG PY4J_VERSION="0.10.7"

ENV SPARK_VERSION=$SPARK_VERSION

RUN apt-get update
RUN apt-get -qq -y install \
    curl \
    unzip \
    zip
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get -qq -y install curl



RUN curl -s https://get.sdkman.io | bash
RUN chmod a+x "$HOME/.sdkman/bin/sdkman-init.sh"
RUN source "$HOME/.sdkman/bin/sdkman-init.sh" && sdk install java ${JAVA_VERSION}
RUN source "$HOME/.sdkman/bin/sdkman-init.sh" && sdk install scala ${SCALA_VERSION}
#RUN source "$HOME/.sdkman/bin/sdkman-init.sh" && sdk install sbt ${SBT_VERSION}
RUN source "$HOME/.sdkman/bin/sdkman-init.sh" && sdk use java ${JAVA_VERSION}


# Spark installation
WORKDIR /tmp
# Using the preferred mirror to download Spark
# hadolint ignore=SC2046
RUN wget -q https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz
RUN tar xzf "spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" -C /usr/local --owner root --group root --no-same-owner && \
    rm "spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz"

WORKDIR /usr/local
RUN ln -s "spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}" spark

# Configure Spark
ENV SPARK_HOME=/usr/local/spark
ENV PYTHONPATH="${SPARK_HOME}/python:${SPARK_HOME}/python/lib/py4j-${PY4J_VERSION}-src.zip" \
    SPARK_OPTS="--driver-java-options=-Xms1024M --driver-java-options=-Xmx4096M --driver-java-options=-Dlog4j.logLevel=info" \
    PATH=$PATH:$SPARK_HOME/bin

ADD resources/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER $NB_USER
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]