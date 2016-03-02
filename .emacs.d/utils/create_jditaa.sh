JAVADIR='/c/Program Files (x86)/Java/jdk1.8.0_74/bin'
cp ditaa0_9.jar jditaa.jar
"$JAVADIR"/javac -cp jditaa.jar Jditaa.java
echo "Main-Class: Jditaa" > manifest
"$JAVADIR"/jar umf manifest jditaa.jar Jditaa.class
