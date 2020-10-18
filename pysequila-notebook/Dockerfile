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

ARG USER_NAME=jovyan
ENV HOME=/tmp/$USER_NAME
RUN mkdir -p $HOME && chown -R $USER_NAME $HOME

RUN curl -s https://get.sdkman.io | bash
RUN chmod a+x "$HOME/.sdkman/bin/sdkman-init.sh"
RUN source "$HOME/.sdkman/bin/sdkman-init.sh" && sdk install java ${JAVA_VERSION}
RUN source "$HOME/.sdkman/bin/sdkman-init.sh" && sdk install scala ${SCALA_VERSION}
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
ADD mango /tmp/mango
RUN chmod -R 777 /tmp/mango
USER $NB_USER


RUN source /opt/conda/etc/profile.d/conda.sh && \
    conda create python=3.7 -p $HOME/venv/pysequila -y && \
    conda activate $HOME/venv/pysequila && \
    pip install -U ipykernel pandas && \
    python -m ipykernel install --user --name pysequila --display-name pysequila && \
    cd /tmp/mango/mango-pileup && \
    pip install -e . && \
    conda deactivate

ADD resources/cache_warmup.scala /tmp/cache_warmup.scala

#sequila version can be overriden in entrypoint from user env var
ENV _JAVA_OPTIONS="-Divy.home=$HOME/.ivy2 -Dsbt.ivy.home=$HOME/.ivy2"
RUN source "$HOME/.sdkman/bin/sdkman-init.sh" && sdk use java ${JAVA_VERSION} && \
    spark-shell --packages org.biodatageeks:sequila_2.11:${SEQUILA_VERSION} -i /tmp/cache_warmup.scala

##install mango-widgets
#According to https://github.com/bigdatagenomics/mango/tree/master/mango-pileup
RUN cd /tmp/mango/mango-pileup && \
    pip install -e . && \
    cd bdgenomics/mango/js && \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager && \
    jupyter labextension install .

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]