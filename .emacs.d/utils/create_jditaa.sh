cp ditaa0.9.jar jditaa.jar
javac -cp jditaa.jar Jditaa.java
echo "Main-Class: Jditaa" > manifest
jar umf manifest jditaa.jar Jditaa.class
