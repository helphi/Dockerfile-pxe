# Dockerfile-pxe
docker run -it --rm --net host -p 67:67 -p 69:69 -p 80:80 -v /pxe:/pxe helphi/pxe 
