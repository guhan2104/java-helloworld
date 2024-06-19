# HelloWorld Java Web Application

This is a simple Java HelloWorld web application using Maven and Docker. The application displays "Hello, World!" on the main page and has a servlet that responds with "Hello, World!" at the `/hello` endpoint.

## Prerequisites

- Java Development Kit (JDK) 8 or later
- Apache Maven
- Docker

## Project Structure

helloworld/
├── Dockerfile
├── pom.xml
├── src/
│ └── main/
│ └── java/
│ └── com/
│ └── example/
│ └── HelloWorldServlet.java
│ └── webapp/
│ ├── index.jsp
│ └── WEB-INF/
│ └── web.xml
└── target/
└── helloworld-1.0-SNAPSHOT.war


## Building and Running the Application

### Step 1: Modify `index.jsp`

Make any necessary changes to the `src/main/webapp/index.jsp` file. For example, update the message:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Hello World</title>
</head>
<body>
    <h1>Hello, Updated World!</h1> <!-- Change your message here -->
</body>
</html>

Step 2: Rebuild the WAR File

mvn clean package


Step 3: Build the Docker Image

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


docker build -t helloworld .
docker run -p 8080:8080 helloworld
Notes
If you want to make further changes to the index.jsp file, you only need to repeat Steps 1, 2, 3, and 4.
There is no need to modify the HelloWorldServlet.java file unless you want to change the servlet's response.
Troubleshooting
If you encounter any issues, check the Docker container logs for more information:
docker logs <container_id>

