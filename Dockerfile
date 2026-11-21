
FROM tomcat:9.0-jdk8-temurin

# Remove default Tomcat applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy CampusCrave website into Tomcat
COPY build/web/ /usr/local/tomcat/webapps/ROOT/

# Render port
EXPOSE 10000

# Start Tomcat on Render's assigned port
CMD sh -c 'sed -i "s/port=\"8080\"/port=\"${PORT:-10000}\"/" "$CATALINA_HOME/conf/server.xml" && catalina.sh run'
