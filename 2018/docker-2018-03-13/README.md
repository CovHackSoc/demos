# MLH Localhost - Introduction to Docker (2018-03-13)

## Slides

* <a href="https://docs.google.com/presentation/d/1Dck8hbcFyFOPaBuKkK0bhRjlcOMdvZp9LGT3Yd1pr48/edit?usp=sharing">Main slides (From MLH)</a>
* <a href="https://docs.google.com/presentation/d/114e221XtaWTJBm7ccR2kuiwi_448aX85m6ugrtsHOwU/edit?usp=sharing">My extra content</a>

## Overview

The MLH slides mostly give context to Docker and some basic usages. Ideal introduction for beginners. The real point to stress
with Docker is the value of it is with all the community tools.

If you are using Windows 10, but not the Professional edition, Docker is a pain to get running. Ideal solution is just install
Ubuntu in a VM, or setup a RancherOS machine on a cloud provider. (My backup solution)

My extra slides where more just areas to go look into further, with some stupid stuff thrown it because I liked it.

`docker system prune` will come in handy one day though.

## Pain Points

Topic areas that tended to cause issues were:
* Docker container naming. How tags, usernames and the differences between running containers and images.
* Build syntax. People tended to forget the `.` at the end.
* Lack of familiarity with UNIX conventions.

Docker works with images which are constructed from Dockerfiles. This images are stored with the docker daemon, which
on request converts them into active and running containers. Images are basically the snapshots containers are based on.

These images are named in the following format `<USER>/<IMAGE>:<TAG>`. e.g `bahorn/static-site:latest`. `USER` and `TAG` can
generally be omitted for local builds, but if you want to push your image to a registary such as Docker Hub, you need to  
include your username.

Builds are done by: `docker build -t <IMAGE NAME> <PATH TO DOCKERFILE>`. If the Dockerfile is in the current directory, you 
just need to make it `.`. This is a standard UNIX conventions.

Most of Dockers commands come from the names of UNIX commands that do the same thing, such as `ls` listing, `rm` removing and 
`ps` showing running processes.
