FROM openlink/virtuoso-opensource-7:7.2.6-r10-g5a27710
ENV DBA_PASSWORD="dba" \
    DEFAULT_GRAPH="http://example.com"

COPY ./scripts/* /opt/virtuoso-opensource/initdb.d/
RUN mkdir /opt/virtuoso-opensource/database/dumps

