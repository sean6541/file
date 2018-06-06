import tuyaapi

input('This script will assist you in setting up your Tuya device for use with tuyaapi. You must have an active internet connection and a working WiFi card on the device running this script. If these requirements are met, press enter to continue...')
email = input('Enter your Tuya account email (if you haven\'t run this script before, your account will be created): ')
passwd = input('Enter your Tuya account password: ')
ssid = input('Enter the SSID of the WiFi network your device should connect to: ')
passw = input('Enter the password of the WiFi network your device should connect to: ')
tapi = tuyaapi.TuyaAPI(email, passwd)
tset = tuyaapi.DevSetup(tapi, ssid, passw)
input('Now put your Tuya device in AP setup mode by holding the power switch until blue light blinks fast. When it is blinking fast, let go, wait 3 seconds, then hold it again until the blue light blinks slowly. Once in AP mode, connect to your devices AP (usually named SmartLife_xxxx). Press enter when done...')
tset.setupdev()
input('Now reconnect to the internet. Press enter when done...')
devid = None
done = False
while done == False:
    try:
        devid = tset.ldevbytok()
        done = True
    except IndexError:
        done = False
        time.sleep(1.5)
print('Device ID: ' + devid)
print('Username: ' + email)
print('Password: ' + passwd)
print('Done! Your device is now registered under the username and password above. You can now use the tuyaapi library or Home Assistant to control it.')
