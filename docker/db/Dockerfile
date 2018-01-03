FROM postgres:alpine

WORKDIR /

RUN apk add --update coreutils

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Install pgTAP and pg_prove -- needs optimization

# update/synchronize apk database and install all dependencies (state 1)
RUN echo "============================== Updating APKINDEX ===============================" && \
    apk update                                                                              && \
    echo "========================= Installing APK dependencies ==========================" && \
    apk add wget make gcc libc-dev pkgconfig uriparser-dev ca-certificates abuild perl-dev     \
            apkbuild-cpan                                                                   && \
    echo "================================== Updating CA =================================" && \
    update-ca-certificates                                                                  && \
    echo "============================= Installing cpanminus =============================" && \
    cpan App::cpanminus                                                                     && \
    echo "===================== Installing second grade dependencies =====================" && \
    cpanm PAR::Dist                                                                         && \
    cpanm Archive::Zip                                                                      && \
    echo "===================== Installing first grade dependencies ======================" && \
    cpanm inc::latest                                                                       && \
    cpanm Test::Pod                                                                         && \
    cpanm Test::Pod::Coverage                                                               && \
    echo "=============================== Installing pgTAP ===============================" && \
    cpanm TAP::Parser::SourceHandler::pgTAP

# download and extract the pgTAP dependency (state 2)
RUN echo "============================== Downloading pgTAP ===============================" && \
    wget -O pgTAP.tar.gz https://github.com/theory/pgtap/archive/v0.97.0.tar.gz             && \
    tar xzfv pgTAP.tar.gz -C tmp                                                            && \
    mv tmp/pgtap-* pgTAP                                                                    && \
    rm -rf tmp pgTAP.tar.gz

# compile and install pgTAP (state 3)
RUN echo "=============================== Installing pgTAP ===============================" && \
    cd pgTAP                                                                                && \
    make                                                                                    && \
    make install                                                                            && \
    cd ..                                                                                   && \
    rm -rf pgTAP

# download and extract the pguri dependency (state 4)
RUN echo "============================== Downloading pguri ===============================" && \
    wget -O pguri.tar.gz https://github.com/petere/pguri/archive/1.20151224.tar.gz          && \
    tar xzfv pguri.tar.gz -C tmp                                                            && \
    mv tmp/pguri-* pguri                                                                    && \
    rm -rf tmp pguri.tar.gz

# compile and install pguri (state 4)
RUN echo "=============================== Installing pguri ===============================" && \
    cd pguri                                                                                && \
    make                                                                                    && \
    make install                                                                            && \
    cd ..                                                                                   && \
    rm -rf pguri

RUN apk add nodejs

WORKDIR /code
