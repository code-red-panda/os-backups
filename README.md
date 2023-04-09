# os-backups

# Mac -> iCloud Instructions
Install https://brew.sh
Install `rclone`
```
brew install rclone
```
Install and create `gpg` keys
```
brew install gnupg

gpg --full-generate-key
```
Install and set up `logrotate`
```
brew install logrotate
brew services start logrotate
sudo mkdir /etc/logrotate.d/ && sudo cp logrotate-mac /etc/logrotate.d/os-backups
```
Update both `__USER__` in logrotate
```
sudo vim /etc/logrotate.d/os-backups
```
Create the log directory
```
sudo mkdir /var/log/os-backups && sudo chown $USER /var/log/os-backups
```
Create an iCloud symlink and make the `Backups` directory
```
ln -s ~/iCloud Library/Mobile Documents/com~apple~CloudDocs
mkdir ~/iCloud/Backups
```
Copy the backup scripts into bin
```
cp backup-mac.sh backup-logger.sh /usr/local/bin
```
Review and edit `backup-mac.sh`
```
vim /usr/local/bin/backup-mac.sh

# Set a unique name for this mac
BACKUP=mac -> MBP13

# Set the GPG key email to use
EMAIL=mygpg@email.com

# Adjust retention if needed
RETENTION=7d

# Edit the exclude-list.txt step as needed
TASK_NAME="Create exclude list"

# Remove the SSH step completely if not needed
TASK_NAME="Copy SSH configs"
```
Add the backup and logrotate cron and set the `__USER__`
```
crontab -e

12 11 * * * __USER__ /usr/local/bin/backup-mac.sh >> /var/log/os-backups/backup-mac.log 2>&1
52 * * * * __USER__ /usr/local/sbin/logrotate -s /var/log/os-backups/logrotate.log /etc/logrotate.d/os-backups
```
Test it
```
/usr/local/bin/backup-mac.sh >> /var/log/os-backups/backup-mac.log 2>&1
/usr/local/sbin/logrotate -s /var/log/os-backups/logrotate.log /etc/logrotate.d/os-backups
```

# Linux (outdated)
Create the log directory for backup scripts
```
sudo mkdir /var/log/coderedpanda ; sudo chown jake. -R /var/log/coderedpanda
```
Create the bin directory for backup scripts
```
sudo mkdir -p /usr/local/coderedpanda/bin/ ; sudo chown jake:jake -R /usr/local/coderedpanda
```
Copy the backup scripts into place
```
cp backup-* /usr/local/coderedpanda/bin/
```
Copy the crontab into place (then edit as needed)
```
cp crontab /etc/cron.d/coderedpanda
```
Linux - copy the logrotate config into place (then edit as needed)
```
cp logrotate /etc/logrotate.d/coderedpanda
```
