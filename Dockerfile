# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
FROM jupyter/scipy-notebook

LABEL maintainer="Patrick Windmiller <sysadmin@pstat.ucsb.edu>"

USER root

RUN pip install saspy && \
    pip install sas_kernel && \
    pip install nbgrader && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

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
RUN chown -R $NB_USER:users /opt/sasinside/SASHome && \
    chown -R $NB_USER:users /usr/local/share/jupyter && \
    chmod -R ug+w /usr/local/share/jupyter

# Re-install SAS Kernel and nbextensions post creation of user home directory
# comment out SASLog enabling commands (PW-12/5/19)
RUN pip install https://github.com/sassoftware/sas_kernel/archive/V2.1.7.tar.gz && \
    jupyter nbextension install --py sas_kernel.showSASLog && \
    jupyter nbextension enable sas_kernel.showSASLog --py && \
    jupyter nbextension install --py sas_kernel.theme && \
    jupyter nbextension enable sas_kernel.theme --py
