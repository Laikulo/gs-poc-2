#!/usr/bin/env bash
NB_URL='https://github.com/raspberrypi/firmware/archive/refs/heads/master.tar.gz'
curl -L# "$NB_URL" | tar -xz -C scratch/pi-fw --strip-components 2 firmware-master/boot/
