# at-time-sync
Script to sync time on OpenWrt based on AT+CCLK command on modem.

# Installation

- Install wget & curl
  ```
  opkg update && opkg install curl wget
  ```
- Download & Install script
  
  using **`wget`**
  ```
  wget --no-check-certificate "https://raw.githubusercontent.com/simcave/at-time-sync/main/attime.sh" -O /usr/bin/attime.sh && chmod +x /usr/bin/attime.sh
  ```
  using **`curl`**
  ```
  curl -sL raw.githubusercontent.com/simcave/at-time-sync/main/attime.sh > /usr/bin/attime.sh && chmod +x /usr/bin/attime.sh
  ```
# Usage
  1. Open **``LuCI -> Modem -> AT Command ``** , type AT+CCLK? if the time data output does not match your timezone, edit the code on line 25 by changing the
     variable from 0 to 1
  2. Edit your modem port (on line 4)
  3. For manual use, type ``attime.sh`` on terminal
  4. For startup use, ``sleep 10 && /bin/attime.sh`` put it on rc.local or **``LuCI -> System -> Startup -> Local Startup``**
     
# Tested On
  1. DW5821e-eSIM
  2. Fibocom L850
  
