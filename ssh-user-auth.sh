#!/bin/bash
/bin/grep -w "$1" /etc/ssh/config/authorized_keys | cut -d: -f2 
