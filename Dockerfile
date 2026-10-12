FROM tomcat:9.0-jdk17-temurin

# Optimize JVM memory footprint for Render Free Tier (512MB limit)
ENV CATALINA_OPTS="-Xms128m -Xmx320m -XX:+UseG1GC"

# Remove default Tomcat webapps
RUN rm -rf /usr/local/tomcat/webapps/ROOT \
    && rm -rf /usr/local/tomcat/webapps/examples \
    && rm -rf /usr/local/tomcat/webapps/docs \
    && rm -rf /usr/local/tomcat/webapps/host-manager \
    && rm -rf /usr/local/tomcat/webapps/manager

# Disable Tomcat shutdown port (port -1) to prevent probe conflicts and invalid command warnings
RUN sed -i 's/port="8005"/port="-1"/' /usr/local/tomcat/conf/server.xml

# Copy WebContent into Tomcat ROOT so the app is accessible directly at /
COPY WebContent /usr/local/tomcat/webapps/ROOT

EXPOSE 8080 10000

# Dynamically bind to Render's $PORT (default 10000) or fallback to 8080, then start Tomcat
CMD ["sh", "-c", "sed -i \"s/port=\\\"8080\\\"/port=\\\"${PORT:-8080}\\\"/g\" /usr/local/tomcat/conf/server.xml && catalina.sh run"]