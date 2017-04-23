Title: Automated Notifications of Experiment Progress: Combining Shell, SSH, Growl, and Prowl
Date: 2013-10-12 15:19
Author: Michelle Gill
Slug: automated_notifications_of_experiment_progress
Tags: science, shell, automation, mac, ios

In addition to covering my use of python in research, one of my goals for this blog is to share ways I use various other computational tools to automate basic research tasks. Such an opportunity arose this week with the onset of hardware issues causing one of our laboratory's NMR spectrometers to periodically stop running during a series of multiple day experiments. The instrument is still useable while waiting for a replacement part to arrive, but periodic reboots of the hardware are necessary for the experiment to continue where it left off. Thus, it is critical to know when such a reboot is necessary. Rather than make constant trips to the building where the instrument is located, I rigged up a notification system using some basic unix and Mac tools. 

The instrument periodically writes data to a file when an experiment is running. So, my solution is a shell script that periodically monitors this file for updates and then sends [Growl](http://growl.info/) notifications to my Mac, which is located in another building.[^vnc] Because Growl on my Mac is configured to work with [Prowl](http://www.prowlapp.com/), a complimentary iOS notification system,[^boxcar] I also receive notifications on my phone whenever the remote Mac is idle. As a bonus, I added the option to send the experimental data to my Mac for processing.

This solution requires [SSH keys](http://sshkeychain.sourceforge.net/mirrors/SSH-with-Keys-HOWTO/SSH-with-Keys-HOWTO-4.html) to be setup so the spectrometer's computer can login to my Mac when necessary. It also requires the installation of [growlnotify](http://growl.info/downloads#growlnotify), a command line accessory to Growl.


```bash
#!/bin/zsh

#### BEGIN USER CONFIG OPTIONS ####

# Path to the data file to watch for modifications
local_progress_file="/path/to/file_that_is_periodically_modified"

# Interval in minutes to wait between queries
# Must be an integer
interval_min=30

# User account and hostname of Mac where you will be notified
dest_user=your_login_name
dest_address=your_mac_hostname

# Set to 1 to enable data synchronization or 0 to disable
data_sync=1

# Paths for data synchronization
local_data_path="/path/to/local/data/directory"
remote_data_path="/path/to/remote/data/directory"

#### END USER CONFIG OPTIONS ####

# Calculate time to wait between checks in seconds
(( sleep_sec = $interval_min * 60 ))

# Check if the progress file exists
if [[ -f ${local_progress_file} ]]; then
        # Perform checks until the script is killed
        while ((1)); do

          	# Synchronize the data if appropriate
        	if (($data_sync)); then
        		rsync --recursive --update --delete --owner --group \
        		--perms --times --compress --rsh=ssh \
			${local_data_path} ${dest_user}@${dest_address}:${remote_data_path}
        	fi

                # Check if the data file has been modified within the time period
                mod_file=`find ${local_progress_file} -mmin -${interval_min}`

                # Set notification message based on modification time of data file
                if [[ $mod_file == "" ]]; then
                        message_string="NOTE: Experiment is stalled or complete"
                else
                        message_string="OK: Experiment still running"
                fi
                
                # Send the notification to your Mac
                ssh ${dest_user}@${dest_address} 'echo `/usr/local/bin/growlnotify \
                -p high -m "'$message_string'" -t "Experiment Update"`'

                # Wait until it's time to check again
                sleep $sleep_sec
        done
else
        # Data file not found
        echo "File ${local_progress_file} not found."
fi
```


The script is written in the Z-shell[^zsh] and can be downloaded [here](https://gist.github.com/mlgill/6951180). It asks for several configuration options, ensures the file that is used to track experiment progress exists, and then performs periodic checks on the modification time of this file until the script is halted. The optional transfer of data takes place via rsync[^rsync]. The interval time must be adjusted so that the data file is written to more frequently than it is polled for modifications, otherwise the script will incorrectly indicate the experiment has stalled.

There are a few nuances associated with the encoding of the growlnotify string. First, the entire command has to be enclosed in quotes because it is sent through ssh to the remote Mac. Additionally, each of the arguments passed to growlnotify, such as the contents of the `$message_string` variable, must themselves be enclosed in quotes when executed on the remote Mac. I prefer to use single quotes for the growlnotify command and double quotes for the individual arguments. However, variables, such as `$message_string`, are not expanded within single quotes, so they must appear outside of the single quotes, as can be seen above. The contents of `$message_string` must still be enclosed in double quotes, which appear before and after the respective single quotes flanking `$message_string`.

Once I start my experiment on the spectrometer, I setup this script to run indefinitely. An added bonus is that it will notify you when the experiment has finished. If the instrument writes progress information to a plain text log file, this file can be queried and more detailed status information that can be included in the `$message_string`.

Here is an example[^secret] of the Prowl status updates I receive on my iPhone. The actual script I use derives additional information from the log file of the NMR spectrometer.

!["Prowl Status Updates"][image1]

This is a script I have been meaning to write for quite some time and I plan to use it, perhaps with less frequent notification times, even after the spectrometer is repaired.

[image1]: {filename}/images/2013-10-12_automated_notifications_of_experiment_progress_1.jpg "Prowl Status Updates"

[^vnc]: VNC could also be used to to check on the experiment, but I prefer a method that also notifies me when I am away from my computer.

[^boxcar]: There are other notification systems that will also work with Growl. I've also used [Boxcar](http://boxcar.io/download_mac), but I switched to Prowl after Boxcar became unreliable at times.

[^zsh]: I believe it will run in Bash with minimal or no modifications; however, if you're not using the Z-shell, you [should be](http://scottlab.ucsc.edu/~wgscott/xtal/wiki/index.php/ZSH_on_OS_X).

[^rsync]: When using rsync in a script, I prefer the long version of argument names for readability because I never remember what the short versions mean.

[^secret]: With super secret science stuff obscured.