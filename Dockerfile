# Use an official Tomcat runtime as a parent image
FROM tomcat:9.0

# Set the working directory
WORKDIR /usr/local/tomcat

# Copy the WAR file to the webapps directory of Tomcat
COPY target/helloworld-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/

# Expose port 8080 to the outside world
EXPOSE 8080

# Run Tomcat
CMD ["catalina.sh", "run"]

