FROM ubuntu:16.04

# Install all OS dependencies for notebook server that starts but lacks all
# features (e.g., download as all possible file formats)
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -yq dist-upgrade \
 && apt-get install -yq --no-install-recommends \
    bzip2 \
    ca-certificates \
    wget \
    locales \
    build-essential \
    libreadline-gplv2-dev \
    libncursesw5-dev \
    libssl-dev \
    libsqlite3-dev \
    tk-dev \
    libgdbm-dev \
    libc6-dev \
    libbz2-dev \
    libffi-dev \
    default-jdk \
    nano

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Install Python 3.7.2
RUN cd /tmp && \
    wget --quiet https://www.python.org/ftp/python/3.7.2/Python-3.7.2.tgz && \
    tar xzf Python-3.7.2.tgz && \
    cd Python-3.7.2 && \
    ./configure --enable-optimizations && \
    make altinstall && \
    ln -s /usr/local/bin/python3.7 /usr/bin/python && \
    pip3.7 install --upgrade pip

# Install Spark
RUN wget https://archive.apache.org/dist/spark/spark-2.4.0/spark-2.4.0-bin-hadoop2.7.tgz && \
    tar -xzf spark-2.4.0-bin-hadoop2.7.tgz && \
    rm spark-2.4.0-bin-hadoop2.7.tgz && \
    mv spark-2.4.0-bin-hadoop2.7 /opt/spark-2.4.0 && \
    ln -s /opt/spark-2.4.0 /opt/spark && \
    export SPARK_HOME=/opt/spark && \
    export PATH=$SPARK_HOME/bin:$PATH

# Install Jupyter
RUN pip3.7 install jupyter

# Install Python Packages
RUN pip3.7 install jupyter_contrib_nbextensions \
                   pandas \
                   matplotlib \
                   scipy \ 
                   seaborn \
                   scikit-learn \
                   sympy \
                   sqlalchemy \
                   beautifulsoup4 \
                   datetime \
                   findspark \
                   pyspark \
                   requests \
                   dask \
                   yapf
                  
# Enable nbextension and extensions
RUN jupyter contrib nbextension install && \
    jupyter nbextension enable hinterland/hinterland && \
    jupyter nbextension enable autosavetime/main && \
    jupyter nbextension enable code_prettify/code_prettify && \
    jupyter nbextension enable help_panel/help_panel && \
    jupyter nbextension enable scroll_down/main && \
    jupyter nbextension enable varInspector/main && \
    jupyter nbextension enable comment-uncomment/main && \
    jupyter nbextension enable execute_time/ExecuteTime && \
    jupyter nbextension enable printview/main && \
    jupyter nbextension enable table_beautifier/main && \
    jupyter nbextension enable freeze/main && \
    jupyter nbextension enable hide_input/main && \
    jupyter nbextension enable keyboard_shortcut_editor/main && \
    jupyter nbextension enable spellchecker/main && \
    jupyter nbextension enable scratchpad/main && \
    jupyter nbextension enable tree-filter/index
    
# Generate jupyter notebook config
RUN jupyter notebook --generate-config

# Add Tini. Tini operates as a process subreaper for jupyter. This prevents
# kernel crashes.
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]

EXPOSE 8888
CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--allow-root", "--ip=0.0.0.0"]
