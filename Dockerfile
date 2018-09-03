
# neo4j
FROM centos/base-centos7

# TODO: Put the maintainer name in the image metadata
MAINTAINER James Read <contact@jread.com>

# TODO: Rename the builder environment variable to inform users about application you provide them
ENV HOME=/opt/app-root/src \
    JAVA_VERSION=1.8.0 \
    NEO4J_VERSION=3.1.1 \
    NEO4J_HOME=/opt/app-root/src
 

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Platform for building neo4j" \
      io.k8s.display-name="builder 1.0.0" \
      io.openshift.expose-services="7474:http,7473:https,7687:cluster" \
      io.openshift.tags="builder,neo4j,graph,database"

# TODO: Install required packages here:
RUN yum install -y --setopt=tsflags=nodocs java-${JAVA_VERSION}-openjdk && \
    wget -q "https://neo4j.com/artifact.php?name=neo4j-community-${NEO4J_VERSION}-unix.tar.gz" -O neo4j-community-${NEO4J_VERSION}-unix.tar.gz && \
    mkdir -p ${NEO4J_HOME} && tar -zxvf neo4j-community-${NEO4J_VERSION}-unix.tar.gz -C ${NEO4J_HOME} --strip-components=1 && \
    rm -f neo4j-community-${NEO4J_VERSION}-unix.tar.gz && \
    yum clean all -y && \
    chown -R 1001:0 ${NEO4J_HOME}


# TODO (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/

# TODO: Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/libexec/s2i

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001

# TODO: Set the default port for applications built using this image
EXPOSE 7474 7473 7687


# TODO: Set the default CMD for the image
CMD ["/usr/libexec/s2i/run"]
