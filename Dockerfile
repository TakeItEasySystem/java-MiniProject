FROM tomcat:9.0-jdk17-temurin

# Remove default Tomcat webapps
RUN rm -rf /usr/local/tomcat/webapps/ROOT \
    && rm -rf /usr/local/tomcat/webapps/examples \
    && rm -rf /usr/local/tomcat/webapps/docs \
    && rm -rf /usr/local/tomcat/webapps/host-manager \
    && rm -rf /usr/local/tomcat/webapps/manager

# Copy WebContent into Tomcat ROOT so the app is accessible directly at /
COPY WebContent /usr/local/tomcat/webapps/ROOT

# Expose standard Tomcat HTTP port
EXPOSE 8080

CMD ["catalina.sh", "run"]