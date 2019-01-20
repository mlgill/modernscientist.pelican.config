Title: Encryption of BitTorrent Sync Peers
Date: 2014-02-21 19:48
Author: Michelle Gill
Slug: encryption_of_bittorrent_sync_peers
Tags: mac, automation



I'd like to follow up on a previous [post](https://modernscientist.com/posts/2014/2014-02-06-torrential_file_synchronization/) covering [BitTorrent Sync](http://www.bittorrent.com/sync). In this post, I mentioned privacy is one of the advantages afforded by BitTorrent Sync over traditional cloud storage options, such as Dropbox. Like most cloud storage options, data are encrypted during transmission with BitTorrent Sync.[^caveat] Once written to a hard drive, though, these files are often not encrypted. This is the case for BitTorrent Sync and many other cloud storage options.[^exceptions] For BitTorrent Sync, this issue is of limited concern if all peers are under your control. However, it may be desirable to utilize peers to which others may have access, such as a virtual private server (VPS). In the previous post, I mentioned using a VPS to help guarantee a synchronized peer was always accessible. In these situations, it is desirable to add additional privacy by selectively encrypting data on such peers.

Previously, I didn't think peer data encryption was possible (yet). As I have since discovered, the recently added [BitTorrent Sync API](http://www.bittorrent.com/sync/developers/api) enables the encryption of torrent data on selected peers. The BitTorrent forums also [describe](http://forum.bittorrent.com/topic/25823-generate-encrypted-read-only-secret-without-api-key/?p=76262) how to enable this encryption without using the API, which eliminates the need to be issued an API key.

## Encryption for Existing Torrents

I won't repeat the above forum instructions for encrypting torrents without using the API, but it is useful to describe how *existing* torrents were converted to encrypted versions. I would also like to share some observations about how various BitTorrent Sync features apply to encrypted peers.

Broadly, the conversion process involves removing existing torrents and then reinstating them with an adjusted shared secret. For unencrypted peers, the existing torrent files will be reindexed automatically so minimal synchronization is required. Torrents on encrypted peers will need to be resynchronized since the existing files are not encrypted.

### Unencrypted Peer Setup

Before torrent conversion, all peers were fully synchronized and an unsynchronized backup of each of the torrents was created.[^notbackup] After backing up the files, the existing shared secret was noted for each of the torrents that would be encrypted. Then the torrent instances—but not the files themselves—were deleted from each of the peers. For each unencrypted peer, the torrent instance was recreated with the first letter of the shared secret changed from an `A` to a `D`, as described in the aforementioned forum directions. Each peer was allowed to completely reindex all files associated with a torrent before adding another peer into the mix.

### Encrypted Peer Setup

The process was slightly more complicated for peers that contained an encrypted version of the torrent. First, the existing unencrypted files were moved to a different location, as a temporary backup, and empty destination directories were created for the torrents. By definition, encrypted peers contain read-only copies of the torrent. So, generating the correct shared secret required noting the read-only shared secret from one of the existing unencrypted peers. To convert this to an *encrypted* read-only secret, the first letter was changed from an `E` to an `F` and only the first 33 characters were used.

After setup, the encrypted peer was allowed to synchronize the torrent. Unlike the unencrypted peers, quite a few errors were generated during this process in the log file of the encrypted peer. However, synchronization did complete, and the encrypted torrent was successfully used as the sole restore point to an unencrypted torrent on a new peer. Thus, the log errors likely refer to recoverable issues that may even be sorted out as this feature matures.

## Other Notes About Encryption

I didn't measure the time required for the encrypted peer to fully synchronize, but I don't think the process took longer than it previously had for the same unencrypted torrent on this machine.[^lotsoffactors] According to forum [discussion](http://forum.bittorrent.com/topic/25854-read-only-encrypted-peers/?hl=encrypt%2A), this process may take 2–3 times longer for lower end hardware, such as that containing an ARM processor, but little difference is noted for higher end computers. Torrent encryption may also slow down the listing of files on mobile devices.

The resulting encrypted torrent maintained the same folder structure as the unencrypted peers, except that all file contents and file/directory names were encrypted. I suspect the directory structure is maintained in effort to keep encrypted peers compatible with other API features, such as selective file synchronization. File exclusion entries in `.SyncIgnore` don't seem to work, which I assume is because the file and directory names can't be matched since they are encrypted. Because the nature of the files cannot be discerned, I decided there was no point in enabling the archive feature on the encrypted peer.

One concern with utilizing a seemingly unsanctioned method is that future software updates may disable loopholes allowing encryption to work without requiring the API. It is even possible such updates could cause file corruption. There are three reasons I'm not worried about either of these scenarios. First, I make incremental *unsynchronized* backups of all my files using an `rsync`-based script,[^future] so there is always a recent, working copy to roll back to. Second, the forums mention encryption will eventually be added to the main program once the aforementioned speed issues are addressed. Third, the encrypted peer is by definition read-only, so (in theory) it can't make any changes to files in the torrents. Thus, I suspect it would, at worst, stop being able to connect to other peers if such software changes were made. As always, you should make your own decision about how to proceed.

Happy *encrypted* synchronizing!

[^caveat]: According to the web site, BitTorrent Sync uses [AES-128](http://www.bittorrent.com/sync/technology) in counter mode. Security and encryption aren't my areas of expertise. Constructive, informative comments on this topic are welcome.
[^exceptions]: Some cloud services do offer end-to-end encryption, such as [SpiderOak](https://spideroak.com/). However, these services still use a fee schedule similar to that of Dropbox, making them very expensive for storing large amounts of data.
[^notbackup]: Remember that synchronization is not the same thing as backup. If error(s) are introduced to a set of synchronized files, such as those in a torrent, they will be propagated across all synchronization sources resulting in file corruption.
[^lotsoffactors]: There are many factors that affect this rate, including the fact that three peers were already synchronized when the encrypted peer was setup. Thus, I didn't feel it was worth timing the encrypted synchronization.
[^future]: I plan to cover this `rsync` script in a blog post in the near future.
