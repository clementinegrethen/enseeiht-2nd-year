
# script pour install reasteasy dans votre installation de Tomcat
# à utiliser si vous voulez installer sur votre propre machine
# adapter les 2 variables d'environnement ci-dessous

TOMCAT_HOME=$HOME/install/apache-tomcat-8.5.47
RESTEASY_HOME=$HOME/install/resteasy-jaxrs-3.0.9.Final

cp $RESTEASY_HOME/lib/activation-1.1.jar $TOMCAT_HOME/lib/.
cp $RESTEASY_HOME/lib/commons-codec-1.6.jar $TOMCAT_HOME/lib/.
cp $RESTEASY_HOME/lib/commons-io-2.1.jar $TOMCAT_HOME/lib/.
cp $RESTEASY_HOME/lib/commons-logging-1.1.1.jar $TOMCAT_HOME/lib/.
cp $RESTEASY_HOME/lib/httpclient-4.2.6.jar $TOMCAT_HOME/lib/.
cp $RESTEASY_HOME/lib/httpcore-4.2.5.jar $TOMCAT_HOME/lib/.
cp $RESTEASY_HOME/lib/jackson-core-asl-1.9.12.jar $TOMCAT_HOME/lib/.
cp $RESTEASY_HOME/lib/jackson-jaxrs-1.9.12.jar $TOMCAT_HOME/lib/.
cp $RESTEASY_HOME/lib/jackson-mapper-asl-1.9.12.jar $TOMCAT_HOME/lib/.
cp $RESTEASY_HOME/lib/jackson-xc-1.9.12.jar $TOMCAT_HOME/lib/.
cp $RESTEASY_HOME/lib/jaxrs-api-3.0.9.Final.jar $TOMCAT_HOME/lib/.
cp $RESTEASY_HOME/lib/jboss-annotations-api_1.1_spec-1.0.1.Final.jar $TOMCAT_HOME/lib/.
cp $RESTEASY_HOME/lib/jcip-annotations-1.0.jar $TOMCAT_HOME/lib/.
cp $RESTEASY_HOME/lib/resteasy-client-3.0.9.Final.jar $TOMCAT_HOME/lib/.
cp $RESTEASY_HOME/lib/resteasy-jackson-provider-3.0.9.Final.jar $TOMCAT_HOME/lib/.
cp $RESTEASY_HOME/lib/resteasy-jaxrs-3.0.9.Final.jar $TOMCAT_HOME/lib/.
cp $RESTEASY_HOME/lib/resteasy-jaxb-provider-3.0.9.Final.jar $TOMCAT_HOME/lib/.
cp $RESTEASY_HOME/lib/resteasy-servlet-initializer-3.0.9.Final.jar $TOMCAT_HOME/lib/.


