# Virtuoso Open Source 7

This Docker image is based on the [official Docker image by OpenLink](https://hub.docker.com/r/openlink/virtuoso-opensource-7).
It makes use of the [Bulk RDF Loader](http://vos.openlinksw.com/owiki/wiki/VOS/VirtBulkRDFLoader) to import RDF data on the initial startup of the container.
It will load your data if it is mounted to ``/database/toLoad``. By default, all data will be loaded into the named graph ``http://example.com``.
You can set the name of the default graph via the environment variable ``DEFAULT_GRAPH``.
Due to the entrypoint of the official image, this is only triggered if no ``virtuoso.ini`` is present.
So if you want to use the auto-loading functionallity, configure your instance via environment variables.

### Updating virtuoso.ini via environment settings
> [!NOTE]
> This is taken from the documentation of the official Docker image by OpenLink!

Using environment variables when creating the Virtuoso docker instance via the command-line options ``-e``, ``--env``, ``--env-file`` or via the **``environment``** section in a ``.yml`` file, you can add or overrule any parameter within the ``virtuoso.ini`` file.

These environment variables must be named like:

```bash
VIRT_SECTION_KEY=VALUE
```

where
- VIRT is common prefix to group such variables together (always in upper case)
- SECTION is the name of the [section] in virtuoso.ini (case insensitive)
- KEY is the name of a key within the section (case insensitive)
- VALUE is the text to be written into the key (case sensitive)

The ``SECTION`` and ``KEY`` parts of these variable names can be written in either uppercase (most commonly used) or mixed case, without having to exactly match the case used inside the virtuoso.ini file. There is no validation on the ``SECTION`` and ``KEY`` name parts, so any mistake may result in a non-functional setting.

The following names all refer to the same setting:

- ``VIRT_Parameters_NumberOfBuffers`` (case matching the section and key name in virtuoso.ini)
- ``VIRT_PARAMETERS_NUMBEROFBUFFERS`` (recommended way to name environment variables)
- ``VIRT_parameters_numberofbuffers`` (optional)

The ``VALUE`` is case sensitive string and should be surrounded by either single (\') or double (") quotes in case there are spaces or other special characters in the string.

Example:
```bash
$ docker create .... \
  ... \
  -e VIRT_PARAMETERS_NUMBEROFBUFFERS=1000000 \
  -e VIRT_HTTPSERVER_MaxClientConnections=100 \
  -e VIRT_HTTPSERVER_SSL_PROTOCOLS="TLS1.1, TLS1.2" \
  ...
```

Please note that **all** path settings in ``virtuoso.ini`` should be based on the _internal_ filesystem structure of the docker image, and cannot directly refer to directory paths on the host system. It is possible to bind additional directories from the host system into the docker instance using ``bind mounts`` using command-line options such as ``--mount``.

See also:
- [docker bind mound](https://docs.docker.com/storage/bind-mounts/)
