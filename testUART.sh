

# VAR1=0
# while true
# do 
# VAR1 = VAR1+1
# echo $VAR1
# if [ $VAR1 == 5 ]
# then
# break
# fi
# done 

while true
do 
echo -en '\xa5' > /dev/ttyUSB1
sleep .1 # Waits 0.5 second.
done

# echo -en '\x00' > /dev/ttyUSB1
# sleep .5 # Waits 0.5 second.
# echo -en '\x01' > /dev/ttyUSB1
# sleep .5 # Waits 0.5 second.
# echo -en '\x02' > /dev/ttyUSB1
# sleep .5 # Waits 0.5 second.
# echo -en '\x03' > /dev/ttyUSB1
# sleep .5 # Waits 0.5 second.
# echo -en '\x04' > /dev/ttyUSB1
# sleep .5 # Waits 0.5 second.
# echo -en '\x05' > /dev/ttyUSB1
# sleep .5 # Waits 0.5 second.
# echo -en '\x06' > /dev/ttyUSB1
# sleep .5 # Waits 0.5 second.
# echo -en '\x07' > /dev/ttyUSB1
# sleep .5 # Waits 0.5 second.
# echo -en '\x08' > /dev/ttyUSB1
# sleep .5 # Waits 0.5 second.
# echo -en '\x09' > /dev/ttyUSB1
# sleep .5 # Waits 0.5 second.
# echo -en '\x0A' > /dev/ttyUSB1
# sleep .5 # Waits 0.5 second.
# echo -en '\xff' > /dev/ttyUSB1
