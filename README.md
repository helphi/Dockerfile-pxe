# Dockerfile-pxe
docker run -it --rm --net host -p 67:67 -p 69:69 -p 80:80 -p 111:111 -p 2049:2049 --privi -v /pxe:/pxe helphi/pxe 
