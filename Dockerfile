FROM ubuntu:18.04

# Install OS dependencies
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \ 
    apt-get -yq dist-upgrade && \
    apt-get install -yq --no-install-recommends bzip2 \
    ca-certificates \
    wget \
    locales \
    python3-pip \
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
    nano \
    ssh \
    python3-dev \
    graphviz && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

# Setup locale
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Install spark
RUN cd /tmp && \
    wget -q  https://archive.apache.org/dist/spark/spark-2.4.0/spark-2.4.0-bin-hadoop2.7.tgz && \
         tar xzf spark-2.4.0-bin-hadoop2.7.tgz -C /usr/local && \
         rm spark-2.4.0-bin-hadoop2.7.tgz

# Setup spark
RUN cd /usr/local && ln -s spark-2.4.0-bin-hadoop2.7 spark && \
    export SPARK_HOME=/usr/local/spark && \
    export PATH=$SPARK_HOME/bin:$PATH

# Upgrade Pip
RUN pip3 install --upgrade pip setuptools

# Install Python Packages
RUN pip3 install jupyter \
	         jupyter_contrib_nbextensions \
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
	         dask distributed --upgrade \
		 paramiko \
	         yapf \
		 bokeh \
	         graphviz \
	         pydotplus \
		 xgboost \
		 translate

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
    jupyter nbextension enable tree-filter/index && \
    jupyter nbextension enable toc2/main
    
# Generate jupyter notebook config
RUN jupyter notebook --generate-config

# Setup tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]

EXPOSE 8888
CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--allow-root", "--ip=0.0.0.0"]
