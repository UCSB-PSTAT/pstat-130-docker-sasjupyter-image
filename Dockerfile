# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
FROM jupyter/scipy-notebook

LABEL maintainer="Patrick Windmiller <sysadmin@pstat.ucsb.edu>"

USER root

#Install required libs for SAS
RUN echo "deb http://security.ubuntu.com/ubuntu xenial-security main" >> /etc/apt/sources.list
RUN apt-get update && \
    apt-get install -y libpng12-0 \
    libjpeg62-dev \
    libmagic-dev \
    default-jre-headless 

# Make the SASHome directory and add the TAR file 
RUN mkdir -p /opt/sasinside/SASHome 
ADD SASHomeTar.tar / 
RUN chown -R $NB_USER:users /opt/sasinside/SASHome

# Install SAS Kernel and nbextensions post creation of user home directory
RUN pip install saspy && \
    pip install sas_kernel && \
    pip install nbgrader && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER && \
    jupyter nbextension install --py sas_kernel.showSASLog && \
    jupyter nbextension install --py sas_kernel.theme
   
USER ${NB_USER}

RUN jupyter nbextension enable sas_kernel.showSASLog --py && \
    jupyter nbextension enable sas_kernel.theme --py
