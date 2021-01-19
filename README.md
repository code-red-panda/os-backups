# os-backups
Generate GPG keys for the OS user

Configure rclone for "Dropbox"

Configure joplin terminal and grant access via Dropbox
```
/usr/local/bin/joplin sync
```
Create the log directory for backup scripts
```
sudo mkdir /var/log/coderedpanda
sudo chown jake:jake -R /var/log/coderedpanda
```
Create the bin directory for backup scripts
```
sudo mkdir -p /usr/local/coderedpanda/bin/
sudo chown jake:jake -R /usr/local/coderedpanda
```
Copy the backup scripts into place
```
cp backup-* /usr/local/coderedpanda/bin/
```
Copy the crontab into place (then edit as needed)
```
cp crontab /etc/cron.d/coderedpanda
```
Copy the logrotate config into place (then edit as needed)
```
cp logrotate /etc/logrotate.d/coderedpanda
```
Or for mac
```
brew install logrotate
brew services start logrotate
sudo mkdir /etc/logrotate.d/
sudo cp logrotate /etc/logrotate.d/coderedpanda
- change group to staff
update cron path to /usr/local/sbin/logrotate
```

