FROM openlink/virtuoso-opensource-7:7.2.8-r14-geef1fc5-ubuntu
ENV DBA_PASSWORD="dba" \
    DEFAULT_GRAPH="http://example.com" \
    VIRT_PARAMETERS_DIRSALLOWED="., ../vad, /usr/share/proj, /database/toLoad"

COPY ./scripts/* /opt/virtuoso-opensource/initdb.d/

