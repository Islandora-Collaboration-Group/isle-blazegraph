# ISLE Blazegraph

## Part of the ISLE Islandora 7.x Docker Images
An alternative graph database server to ISLE Fedora's default [Resource Index](https://wiki.duraspace.org/display/FEDORA38/Resource+Index) module configuration usage of [Mulgara](http://www.mulgara.org/download.html), "_a RDF database written entirely in Java._"

Blazegraph is a ultra high-performance triplestore and graph database which can performantly support higher levels of triples than Mulgara.

**Please note:** This image is designed to be opt-in for usage by an enduser and not forced by default ISLE.

Based on:
* [ISLE-tomcat](https://cloud.docker.com/u/islandoracollabgroup/repository/docker/islandoracollabgroup/isle-tomcat)
  * Ubuntu 18.04 "Bionic" (@see [ISLE-ubuntu-basebox](https://cloud.docker.com/u/islandoracollabgroup/repository/docker/islandoracollabgroup/isle-ubuntu-basebox)
    * General Dependencies
    * Oracle Java 8 Server JRE
    * Tomcat 8.5.x

Contains and Includes:
* [Blazegraph](https://www.blazegraph.com/) 2.1.5 an ultra high-performance graph database / server
* [Discovery Garden's](https://www.discoverygarden.ca/) [Blazegraph Configurations](https://github.com/discoverygarden/blazegraph_conf) _"Supporting config files for blazegraph install"_

## Generic Usage

```
docker run -it -p "8084:8084" --rm islandoracollabgroup/isle-blazegraph bash
```

### Default Login information

* Review the `Tomcat Admin` & `Tomcat Manager` Usernames and passwords found in your environment (e.g. local, staging, production etc.) .env files