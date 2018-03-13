# MLH Localhost - Introduction to Docker (2018-03-13)

## Slides

* <a href="https://docs.google.com/presentation/d/1Dck8hbcFyFOPaBuKkK0bhRjlcOMdvZp9LGT3Yd1pr48/edit?usp=sharing">Main slides (From MLH)</a>
* <a href="https://docs.google.com/presentation/d/114e221XtaWTJBm7ccR2kuiwi_448aX85m6ugrtsHOwU/edit?usp=sharing">My extra content</a>

## Overview

The MLH slides mostly give context to Docker and some basic usages. Ideal introduction for beginners. The real point to stress
with Docker is the value of all the community tools.

If you are using Windows 10, but not the Professional edition, Docker is a pain to get running. Ideal solution is just install
Ubuntu in a VM, or setup a RancherOS machine on a cloud provider. (My backup solution)

My extra slides where more just areas to go look into further, with some stupid stuff thrown it because I liked it.

`docker system prune` will come in handy one day though.

## Pain Points

Main issues I encounted when giving this was:
* Docker container naming. How tags, usernames and the differences between running containers and images.
* Build syntax. People tended to forget the `.` at the end.
* Lack of familarity with UNIX conventions.
