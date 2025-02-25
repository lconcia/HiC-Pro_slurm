FROM ubuntu:18.04
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

LABEL authors="Nicolas Servant" \
      description="Docker image containing all requirements for the HiC-Pro pipeline"

## Install system tools
RUN apt-get update &&  \
  apt-get install -y build-essential \
  bzip2 \
  gcc \
  g++ \
  unzip \
  wget && \
apt-get clean


## Install miniconda.
RUN wget https://repo.continuum.io/miniconda/Miniconda3-py37_4.8.2-Linux-x86_64.sh -O ~/anaconda.sh && \
    bash ~/anaconda.sh -b -p /usr/local/anaconda && \
    rm ~/anaconda.sh
ENV PATH /usr/local/anaconda/bin:$PATH


## Install all dependencies using conda
COPY environment.yml /
RUN conda env create -f /environment.yml && conda clean -a
ENV PATH /usr/local/anaconda/envs/HiC-Pro_v3.1.0/bin:$PATH

## Install HiCPro
RUN cd /tmp && \
    echo "master.zip" | wget --base=https://github.com/lconcia/HiC-Pro_slurm/archive/refs/heads/ -i - -O hicpro_latest.zip && \
    unzip hicpro_latest.zip && \
    cd HiC-Pro_slurm-master && \ 
    make configure prefix=/ && \
    make install && \
    cd .. && \
    rm -fr HiC-Pro*

RUN /HiC-Pro_3.1.0/bin/HiC-Pro -h
