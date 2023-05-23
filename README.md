# PSUS
Můj soubor PS a cizojazyčných skritpů které se můžou hodit.

My useful scripts repository.

## Winrm

- windows remote management
- soap via http/s: wmi for data and ipmi for hw mgmt
- ver 1 works on 80/443 (staré), ver 2+ on **5985/6**
<u>Components and requirements </u>
```
1. winrm service/server and client
2. listener in http.sys
3. domain/private networks, firewall enabled and non-blank password
```
WinRM je potřeba pro jakoukoliv formu PS Remotingu (Wmi)
