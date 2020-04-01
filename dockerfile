FROM openshift/base-centos7

EXPOSE 8080

# Install Java
RUN INSTALL_PKGS="tar unzip bc which lsof java-1.8.0-openjdk java-1.8.0-openjdk-devel maven" && \
    yum install -y $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y && \
    mkdir -p /opt/s2i/destination

USER 1001

# add application source

ADD mvnw /opt/app-root/
ADD mvnw.cmd /opt/app-root/
ADD pom.xml /opt/app-root/
ADD src /opt/app-root/src

WORKDIR /opt/app-root/
# build
RUN mvn package
# copy to correct location
RUN cp -a  /opt/app-root/target/*.jar /opt/app-root/selfinformation.jar

CMD java -Xmx64m -Xss1024k -jar /opt/app-root/selfinformation.jar