# docker-Backdrop
A Docker image build of Backdrop CMS.

To build (run as root): docker build -t backdrop .

You can run it with Docker-Compose file with:
docker-compose up -d

You do need a database (not included).  You can setup one up (or restore from a backup); and then make sure you create a user that can access the database via:
CREATE USER 'backdropuser'@'%' IDENTIFIED BY 'changeme';
GRANT ALL PRIVILEGES ON backdrop.* TO 'backdropuser'@'%';
FLUSH PRIVILEGES;

Hope that help!
