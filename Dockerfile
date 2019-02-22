FROM ubuntu:16.04

# Install all OS dependencies for notebook server that starts but lacks all
# features (e.g., download as all possible file formats)
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -yq dist-upgrade \
 && apt-get install -yq --no-install-recommends \
    bzip2 \
    ca-certificates \
    wget \
    build-essential \
    libreadline-gplv2-dev \
    libncursesw5-dev \
    libssl-dev \
    libsqlite3-dev \
    tk-dev \
    libgdbm-dev \
    libc6-dev \
    libbz2-dev \
    libffi-dev
    
# Install Python 3.7.2
RUN cd /tmp && \
    wget --quiet https://www.python.org/ftp/python/3.7.2/Python-3.7.2.tgz && \
    tar xzf Python-3.7.2.tgz && \
    cd Python-3.7.2 && \
    ./configure --enable-optimizations && \
    make altinstall && \
    pip3.7 install --upgrade pip
       
# Install jupyter
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
                   datetime
                  
# Enable nbextension
RUN jupyter contrib nbextension install

# Generate jupyter notebook config
RUN jupyter notebook --generate-config && \
    jupyter notebook --no-browser --allow-root
