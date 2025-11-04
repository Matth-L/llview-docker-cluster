# This dockerfile builds the Remote Version of LLView
# .ie https://apps.fz-juelich.de/jsc/llview/docu/install/remote_install/
# Author : Matthias LAPU (CEA)

###################################################
###################################################
# Perl Installation
###################################################
###################################################
FROM slurm-docker-cluster:latest AS perl-install

# PERL
ENV PERL_LOCAL_LIB_ROOT=/opt/perl5
ENV PERL_MB_OPT="--install_base /opt/perl5"
ENV PERL_MM_OPT="INSTALL_BASE=/opt/perl5"
ENV PERL5LIB=/opt/perl5/lib/perl5
ENV PATH=/opt/perl5/bin:$PATH

RUN set -ex \
    && dnf -y install \
    cronie \
    perl \
    perl-core \
    perl-CPAN

RUN curl -L https://cpanmin.us | perl - App::cpanminus

RUN cpanm --local-lib=/opt/perl5 \
    Data::Dumper \
    Getopt::Long \
    Time::Local \
    Time::HiRes \
    FindBin \
    Parallel::ForkManager \
    File::Monitor \
    File::Spec \
    warnings::unused \
    Exporter \
    Storable \
    IO::File \
    POSIX \
    YAML::XS \
    DBI \
    DBD::SQLite \
    Config::IniFiles \
    JSON


###################################################
###################################################
# PYTHON PKG INSTALL
# python is alreay installed in slurm-docker-cluster
###################################################
###################################################

FROM perl-install AS python-dependencies

ENV LD_LIBRARY_PATH=""
ENV LIBRARY_PATH=""
ENV PYTHONPATH=""
ENV PYTHON_BASE=/usr

ENV PATH=${PYTHON_BASE}/bin:${PATH}
ENV LD_LIBRARY_PATH=${PYTHON_BASE}/lib64:${LD_LIBRARY_PATH}
ENV LIBRARY_PATH=${PYTHON_BASE}/lib64:${LIBRARY_PATH}
ENV PYTHONPATH=${PYTHON_BASE}/lib64/python3.10/site-packages:${PYTHONPATH}


RUN pip3 install pyyaml

CMD [ "crond -n" ]