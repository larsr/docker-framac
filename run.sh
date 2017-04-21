docker build -t frama . || exit

XSOCK=/tmp/.X11-unix
#XAUTH=/tmp/.docker.xauth
#touch $XAUTH
#xauth nlist :0 | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
#docker run -ti -v $XSOCK:$XSOCK -v $XAUTH:$XAUTH -e XAUTHORITY=$XAUTH --rm -ti frama

# * socat-hack to get x11 working on mac
#   Expose my X11 DISPLAY on port 'hostname':6000 (!dangerous!)
#   but only allow connections from 'hostname'
HOSTIP=$(host -t A $(hostname) | awk '{print$(NF)}')
socat TCP-LISTEN:6000,reuseaddr,fork,bind=$HOSTIP,range=$HOSTIP/32 UNIX-CLIENT:\"$DISPLAY\" &
# kill child process when this script ends
trap 'trap - SIGTERM && kill -- -$$' SIGINT SIGTERM EXIT

docker run -ti -P -e DISPLAY=$HOSTIP:0 --rm -v $(pwd)/files:/home/user/files -ti frama
