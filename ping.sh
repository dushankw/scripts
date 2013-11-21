#!/bin/bash

# Ping a Class A, B or C Network
# Dushan (http://dushan.it)

# Number of times to ping each address, change if needed
count=1

# Inputs and checks
start()
{
    echo "Enter an IP Address and Subnet Mask"
    echo "EG: 10.0.0.1 255.255.255.0"
    read ip snm

    # Read IP address into Array for later use
    IFS='.' read -a IPARRAY <<< "${ip}"

    # Check for valid IPv4 Address
    for i in {0..3}
    do
        # Check for integers by doing mathematical comparison
        if [ ${IPARRAY[$i]} -eq ${IPARRAY[$i]} 2> /dev/null ]
        then
            # Boundary check (lower)
            if [ ${IPARRAY[$i]} -lt 0 ]
            then
                echo "Invalid IP"
                start
            else
                # Boundary check (upper)
                if [ ${IPARRAY[$i]} -gt 255 ]
                then
                    echo "Invalid IP"
                    start
                else
                    if [ $i -eq 3 ]
                    then
                        checkClass
                    fi
                fi
            fi
        else
            echo "Invalid IP"
            start
        fi
    done
}

# Work out network class and filter out invalid SNM
checkClass()
{
    case $snm in
        255.0.0.0) classA ;;
        255.255.0.0) classB ;;
        255.255.255.0) classC ;;
        *) echo "Invalid SNM" && start ;;
    esac
}

# Ping the Class A
classA()
{
    for a in {0..255}
    do
        for b in {0..255}
        do
            for c in {0..254}
            do
                ping -c $count ${IPARRAY[0]}.$a.$b.$c
            done
        done
    done
}

# Ping the Class B
classB()
{
    for a in {0..255}
    do
        for b in {0..254}
        do
            ping -c $count ${IPARRAY[0]}.${IPARRAY[1]}.$a.$b
        done
    done
}

# Ping the Class C
classC()
{
    for a in {1..254}
    do
        ping -c $count ${IPARRAY[0]}.${IPARRAY[1]}.${IPARRAY[2]}.$a
    done
}

# Start the program
start
