# This dockerfile builds the Server Version of LLView
# .ie https://apps.fz-juelich.de/jsc/llview/docu/install/server_install/
# Author : Matthias LAPU (CEA)

###################################################
###################################################
# CRON
###################################################
###################################################

FROM almalinux:9@sha256:375aa0df1af54a6ad8f4dec9ec3e0df16feec385c4fb761ac5c5ccdd829d0170 AS cron

RUN set -ex \
    && dnf -y install \
    cronie \
    zlib \
    zlib-devel \
    libpng \
    libpng-devel

###################################################
###################################################
# PERL5 INSTALL
###################################################
###################################################

FROM  cron AS perl-install

# PERL
ENV PERL_LOCAL_LIB_ROOT=/opt/perl5
ENV PERL_MB_OPT="--install_base /opt/perl5"
ENV PERL_MM_OPT="INSTALL_BASE=/opt/perl5"
ENV PERL5LIB=/opt/perl5/lib/perl5
ENV PATH=/opt/perl5/bin:$PATH

RUN set -ex \
    && dnf -y install \
    perl \
    perl-core \
    perl-CPAN

RUN curl -L https://cpanmin.us | perl - App::cpanminus

RUN cpanm --local-lib=/opt/perl5 \
    Data::Dumper \
    Getopt::Long \
    Time::Local \
    Time::HiRes \
    Time::Zone \
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
    DBD::SQLite \
    DBD::SQLite::BundledExtensions \
    Config::IniFiles \
    JSON \
    Compress::Zlib \
    Archive::Tar \
    LWP::Simple \
    LWP::UserAgent \
    LWP::Protocol::https \
    SVG \
    SVG::TT::Graph::Line

RUN set -ex \
    && dnf -y install \
    libX11 \
    libX11-devel

RUN cpanm --verbose --local-lib=/opt/perl5 \
    Tk \
    Tk::NoteBook \
    Tk::Table \
    Cwd

###################################################
###################################################
# PYTHON INSTALL
###################################################
###################################################

FROM perl-install AS python-dependencies

# Python
RUN dnf -y install \
    python3 python3-pip python3-devel

ENV LD_LIBRARY_PATH=""
ENV LIBRARY_PATH=""
ENV PYTHONPATH=""
ENV PYTHON_BASE=/usr

ENV PATH=${PYTHON_BASE}/bin:${PATH}
ENV LD_LIBRARY_PATH=${PYTHON_BASE}/lib64:${LD_LIBRARY_PATH}
ENV LIBRARY_PATH=${PYTHON_BASE}/lib64:${LIBRARY_PATH}
ENV PYTHONPATH=${PYTHON_BASE}/lib64/python3.10/site-packages:${PYTHONPATH}

RUN pip3 install \
    matplotlib \
    numpy \
    pandas \
    pyyaml \
    plotly \
    cmcrameri \
    requests

###################################################
###################################################
# SQLITE3
###################################################
###################################################

FROM python-dependencies AS sqlite

RUN set -ex \
    && dnf -y install \
    sqlite \
    sqlite-devel

###################################################
###################################################
# fonts
###################################################
###################################################

FROM sqlite AS fonts

RUN set -ex \
    && dnf -y install \
    liberation-sans-fonts \
    liberation-mono-fonts

###################################################
###################################################
# additionnal lib
###################################################
###################################################

FROM fonts AS additionnal-packages

RUN set -ex \
    && dnf -y install \
    procps