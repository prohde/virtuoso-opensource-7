FROM openlink/virtuoso-opensource-7:7.2.14-r21-g092d7fb-ubuntu
ENV DBA_PASSWORD="dba" \
    DEFAULT_GRAPH="http://example.com" \
    VIRT_PARAMETERS_DIRSALLOWED="., ../vad, /usr/share/proj, /database/toLoad"

COPY ./scripts/* /opt/virtuoso-opensource/initdb.d/

