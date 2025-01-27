Title: Torrential File Synchronization
Date: 2014-02-06 19:48
Author: Michelle Gill
Slug: torrential_file_synchronization
Tags: mac, shell, automation, openscience


My research requires that I work in multiple locations: in the lab, at a multi-institution shared instrument facility, and sometimes in my fuzzy slippers at home. Having my data and processing scripts updated on whatever computer I happen to be using is critical to my ability to get work done. Since these files are too large for Dropbox storage to be economical, I have previously relied on programs such as [Unison](http://www.cis.upenn.edu/~bcpierce/unison/) and [ChronoSync](http://www.econtechnologies.com/pages/cs/chrono_overview.html). Unfortunately, these tools require some manual effort[^auto] to ensure my ever-growing research directory is updated when switching computers, a process that sometimes happens multiple times per day. 

Having endured this daily nuisance of file synchronization for several years, I was thrilled to discover the recent release of [BitTorrent Sync](http://www.bittorrent.com/sync), which relies on the BitTorrent protocol. I used torrents in my graduate school days to download Linux distributions because I found this method was generally faster than using a web browser. Applying this protocol to the synchronization of files is, to me, a natural extension of its powerful feature set.

Before delving further into the setup of BitTorrent Sync, it is important to understand how the BitTorrent protocol works. Traditional cloud storage systems, such as Dropbox, utilize a centralized, master server to which all clients upload and download files. The BitTorrent protocol instead allows every client to upload and download to all other clients. This decentralized, peer-to-peer model requires the user to provide the devices that will serve as synchronization points (peers), but that requirement also has many advantages. In situations where large file sets are synchronized, it is often more cost efficient to provide your own hardware, which you may already own, than pay the fee for increased cloud storage. The BitTorrent protocol also allows users to avoid storing data on servers belonging to someone else, potentially making BitTorrent Sync more private.

BitTorrent Sync has been robust and very fast based on my experience thus far. It has tremendous potential for the synchronization and sharing of large data sets, such as those generated by scientists, within a single research group. Perhaps more importantly, BitTorrent Sync can make sharing data with other research groups through open data initiatives, such as [Academic Torrents](http://academictorrents.com), much easier.

## BitTorrent Sync Setup on a Mac

The Mac BitTorrent Sync application is simple to setup. The first time a folder to be synchronized is added to your list of torrents, BitTorrent Sync has to generate a shared secret code. Anyone who has this code can download and modify files in the torrent, so guard it carefully. Additional instances of this torrent should use the previously generated shared secret. Based on my experience, BitTorrent Sync will try to use existing files for the initial synchronization, so it is possible to speed up this process by pre-populating peer directories with updated copies of the file set.

There are some additional options for controlling BitTorrent Sync that don't reside within the application. Inside each synchronized folder is a file called `.SyncIgnore` and a directory called `.SyncArchive`. The former contains a list of files and folders that will be ignored during synchronization, with support for basic file globbing, such as '`*`' and '`?`'. The `.SyncArchive` directory contains old versions of all files that have been changed or deleted. The `.SyncArchive` option seems to keep versions indefinitely and can optionally be disabled within the application on each of the peers.

## Other Features and Comparison to Dropbox

The features offered by BitTorrent Sync are similar to those of Dropbox in more ways than just the real-time synchronization of files. And there are also some important differences. The previously mentioned options to exclude files from synchronization and store modified or deleted files are similar to Dropbox's selective synchronization and versions features, respectively. The inclusion of file globbing in BitTorrent Sync's file exclusion implementation makes it more powerful than Dropbox's. On the other hand, I think Dropbox's file versioning system, which includes a web browser component, is more user friendly.

Like Dropbox, files can also be shared with others using BitTorrent Sync, but it is only possible to do so as a torrent--there is no official option for downloading files through a web browser. Additionally, a share from BitTorrent Sync must include the entire contents of the torrent. However it is possible to restrict these shares to read-only access and set a time limit of 24 hours for downloading.

Perhaps the most important--and very subtle--difference between BitTorrent Sync and Dropbox is that BitTorrent Sync *does not* support extended attributes. This is not an issue for me as most of my research files are generated on Linux filesystems, which do not regularly use extended attributes. Those files that do have extended attributes, mostly generated by Microsoft Office and iWork, don't seem to actually use them. I have verified this through years of synchronizing files using methods that do not support extended attributes. Usage scenarios differ, however, so this issue should be tested carefully. For example, heavy users of file tagging in Mavericks or PDF annotations in [Skim](http://skim-app.sourceforge.net), both of which rely on extended attributes, may find that BitTorrent Sync does not suit their needs.

## Additional BitTorrent Sync Servers

Though my primary need is the synchronization of files between two Macs, there are advantages to having additional file servers. A minimum of one fully updated peer is required for synchronization, so increasing the number of servers adds robustness to the system. Similarly, additional peers provide more download sources during synchronization, which can make this process faster. For these reasons, I am also running BitTorrent Sync on a web server and on a Drobo 5N. The setup of BitTorrent Sync on these two clients is more complicated than on the Mac, so I have outlined both processes below.

#### Setup on a Web Server

Based on the recommendation of several users on the BitTorrent Sync forums, I purchased a virtual private server from a backup-focused service called [Backupsy](https://backupsy.com/aff.php?aff=210). The service offers a variety of configurations at a very reasonable cost.[^promo]

I decided to use the default BitTorrent Sync command line program for [Linux](http://www.bittorrent.com/sync/downloads) so I could configure everything exactly as I wished. Those who are familiar with the Debian package management system might prefer the user-maintained [package](http://forum.bittorrent.com/topic/18974-debian-and-ubuntu-server-unofficial-packages-for-bittorrent-sync/). The BitTorrent Sync program, called `btsync` on Linux, can create a default text configuration file. I used this as well as [online resources](http://blog.bittorrent.com/2013/09/17/sync-hacks-how-to-set-up-bittorrent-sync-on-ubuntu-server-13-04/) to get started. 

The Linux version of BitTorrent Sync comes with a web interface enabled by default, which provides a convenient GUI for managing torrents. However, I opted to disable it since the only available security settings are a username and password, which could theoretically be determined by brute force methods.[^sshsec]

There were two "gotchas" I discovered while setting up my web server:

* First, it seems the destination directory must exist before starting BitTorrent Sync otherwise no files will be downloaded.
* Second, the BitTorrent Sync web interface cannot be run if the `shared_folders` option is used within the configuration file. It is possible to switch between the two methods without resetting the synchronization state by modifying the configuration file (see below) and restarting BitTorrent Sync. Both options cannot be run at once, though.[^manual]

Here is my configuration file for BitTorrent Sync on my Backupsy server. The first line of the file contains an example of how the configuration file is loaded as a BitTorrent Sync instance. The web interface is setup in the `webui` section. Alternatively, the `shared_folders` section is used if `webui` is disabled, as has been setup below.

```
// /home/user/btsync/bin/btsync --nodaemon --log file --config /home/user/btsync/conf/my_btsync.conf
// web interface is disabled
{
        "device_name": "Phog",
        "storage_path" : "/home/user/btsync/sync",
        "listening_port" : 0,
        "check_for_updates" : false,
        "use_upnp" : false,
        "download_limit" : 0,
        "upload_limit" : 0,
        "disk_low_priority" : true,
        "lan_encrypt_data" : true,
        "lan_use_tcp" : true,
        "rate_limit_local_peers" : false,
        "folder_rescan_interval" : 600,
        "webui" :
        {
                // "listen" : "0.0.0.0:8888",
                // "login" : "xxx",
                // "password" : "xxx"
        },
        "shared_folders":
        [
                {
                        "secret":"xxx",
                        "dir":"/home/user/research",
                        "use_relay_server":true,
                        "use_dht":false,
                        "search_lan":false,
                        "use_sync_trash":true
                }
          ]
}
```

#### Setup on a Drobo 5N

BitTorrent Sync is also compiled for ARM processors, which means it will run on Drobo storage devices. Setting up BitTorrent Sync on a Drobo is a little more complicated than a Linux server since the Drobo operating system doesn't have ssh and various unix utilities installed out of the box. The [DroboPorts website](http://www.droboports.com/using-command-line-apps) contains good instructions for setting up [dropbear](http://www.drobo.com/products/professionals/drobo-fs/apps/) for ssh access, and [vim](http://www.droboports.com/app-repository/vim-7-3/) for remotely editing text files. To setup BitTorrent Sync, I roughly followed [these](http://forum.bittorrent.com/topic/8578-supported-nas/page-6#entry62610) instructions. Since the Drobo is only accessible within my home network, I am using the BitTorrent Sync web interface for now. 

## Other BitTorrent Sync Notes

There are mobile (iOS and Android) versions of BitTorrent Sync available. Much like their Dropbox counterparts, these applications refresh a file listing for associated torrents when opened but only download files on demand. Torrents can be added by scanning a QR code generated by the desktop application, which is both an awesome use of QR codes and easier than typing the shared secret on a mobile device. The mobile BitTorrent Sync application has an option to automatically backup pictures from the device.

Currently, it is not possible to check the status of torrents from the command line. This can only be done using the BitTorrent Sync web interface. In the future, I'd love to see a command line option added so I can create an automated method to check the status of BitTorrent Sync on my web server.

I currently use a derivation of an rsync-based script, called [rsnapshot](http://www.rsnapshot.org), to imitate the incremental backups created by Apple's Time Machine because I have had many issues with Time Machine in the past. This script was formerly used to synchronize files from my laptop to the Drobo when I was at home. Now that the Drobo always contains an updated copy of my files, I am experimenting with running rsnapshot directly on the Drobo and synchronizing files directly from my torrent directory.

[^auto]: Various automation programs could be used to run these programs at regular intervals. However, ssh tunneling to my computer in lab is sometimes problematic due to university-imposed firewall rules, so I do not feel comfortable assuming an automated synchronization method completed successfully.
[^promo]: There is a promotion code (GOTMEADEAL) which offers a significant discount for the lifetime of the virtual machine.
[^sshsec]: I can't stress how important security is for a web-accessible server. In the approximately 20 minutes from when Backupsy provisioned my server to the time that I disabled ssh access for root, there were over 50 attempts from a foreign IP address to determine the root password by brute force methods.
[^manual]: The inability to use `shared_folders` and `webui` at the same time is mentioned in the BitTorrent Sync [manual](http://btsync.s3-website-us-east-1.amazonaws.com/BitTorrentSyncUserGuide.pdf), but I didn't discover this until after puzzling over the issue for some time. RTFM.
