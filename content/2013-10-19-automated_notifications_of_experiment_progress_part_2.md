Title: Automated Notifications of Experiment Progress: Prowl Extra Credit
Date: 2013-10-19 15:19
Author: Michelle Gill
Slug: automated_notifications_of_experiment_progress_part_2
Tags: science, shell, automation, mac, ios


Previously, I [posted](http://modernscientist.com/posts/2013/2013-10-12-automated_notifications_of_experiment_progress/) about using [Growl](http://growl.info/) in combination with [Prowl](http://www.prowlapp.com/) to get remote notifications of experiment progress on both a Mac and iPhone. Later that day, I started thinking about some improvements to the script after a brief Twitter [conversation](https://twitter.com/modernscientist/status/389159633753210880) with [Seth Brown](https://twitter.com/DrBunsen).[^follow] 

The script depends on the remote Mac being always on and reachable from the internet. This is true for my Mac desktop, but it may not be in many other situations, such as when a laptop is involved. In cases such as these, the notification can be sent directly to Prowl from the shell script itself.[^alt] 

Posting to Prowl requires only one additional piece of information: a Prowl API key. The API key can be generated and accessed from Prowl's [website](https://www.prowlapp.com/api_settings.php) after logging in. The API key is circled in red below. If there are no active keys,[^api] they can be generated on this page as well.

!["Prowl API Key Generation"][image1]

Posting to Prowl using an API key is described in the [documentation](http://www.prowlapp.com/api.php), but it is quite simple and can be accomplished from the command line with `curl` like this:

```text
curl -s --data \
"apikey=enter_your_api_key_here&application=Command Line&event=Posting to Prowl" \
https://api.prowlapp.com/publicapi/add
```

Prowl's API then returns an xml string containing [information](http://www.prowlapp.com/api.php#return) about the success or failure of the post attempt:

```text
<?xml version="1.0" encoding="UTF-8"?>
<prowl>
<success code="200" remaining="993" resetdate="1382212452" />
</prowl>
```

According to Prowl's documentation, 1,000 API calls are allowed per hour from a single IP address. That should be plenty for simple status posts.

I have also created a new version of the associated shell script that will attempt to ping the remote computer before synchronizing data and sending a Growl notification. If the remote computer is not available, the notification will be posted directly to Prowl.

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

# Prowl API key
prowl_api_key="enter_your_api_key"

#### END USER CONFIG OPTIONS ####

# Calculate time to wait between checks in seconds
(( sleep_sec = $interval_min * 60 ))

# Check if the progress file exists
if [[ -f ${local_progress_file} ]]; then
    # Perform checks until the script is killed
    while ((1)); do

        # Check if the data file has been modified within the time period
        mod_file=`find ${local_progress_file} -mmin -${interval_min}`

        # Set notification message based on modification time of data file
        if [[ $mod_file == "" ]]; then
            message_string="NOTE: Experiment is stalled or complete."
        else
            message_string="OK: Experiment still running."
        fi
        
        # See if the remote computer is accessible
        ping -c 1 ${dest_address} >| /dev/null 2>&1
        ping_result=$? # Result will be 0 if computer is accessible

        if [[ $ping_result -eq 0 ]]; then

            # Synchronize the data if appropriate
            if (($data_sync)); then
                rsync --recursive --update --delete --owner --group \
                --perms --times --compress --rsh=ssh \
                ${local_data_path} ${dest_user}@${dest_address}:${remote_data_path}
            fi

            # Send the notification to your Mac
            ssh ${dest_user}@${dest_address} 'echo `/usr/local/bin/growlnotify \
            -p high -m "'$message_string'" -t "Experiment Update"`'

        else

            # Update notification if data could not be synchronized.
            if (($data_sync)); then
                message_string="$message_string Data not synchronized."
            fi

            # Send the notification directly to Prowl
            prowl_output=$(curl -s --data \
            "apikey=${prowl_api_key}&application=Experiment Update&event=${message_string}" \
            https://api.prowlapp.com/publicapi/add)
            
            # Parse the output to get the success/error code
            # Successive grep commands are used in lieu of other methods for BSD/GNU compatibility
            prowl_output_code=$(echo $prowl_output | grep -oE 'code="[0-9]+"' | grep -oE '[0-9]+')

            # Print a message if an error code was returned
            if [[ $prowl_output_code -ne 200 ]]; then
                echo "There was an error posting to Prowl: ${prowl_output_code}"
            fi
        fi

        # Wait until it's time to check again
        sleep $sleep_sec

    done
else
    # Data file not found
    echo "File ${local_progress_file} not found."
fi
```

Have fun!

[image1]: {static}/images/2013-10-19_automated_notifications_of_experiment_progress_part_2_1.png "Prowl API Key Generation"

[^follow]: If you are interested in python, data visualization, R, and pretty much every other cool thing on the internet, you should definitely follow him and read his [blog](http://www.drbunsen.org/).

[^alt]: This alternative could be also be used exclusively instead of Growl. However, I prefer receiving notifications on my Mac if I am actively using it.

[^api]: I set up my Prowl account so long ago, that I don't recall if the initial API key was active or if I generated it.