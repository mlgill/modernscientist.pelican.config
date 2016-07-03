Title: Automated Notifications of Experiment Progress: Prowl Extra Credit
Date: 2013-10-19 15:19
Author: Michelle Gill
Slug: automated_notifications_of_experiment_progress_part_2
Tags: science, shell, automation, mac, ios


Previously, I [posted](http://themodernscientist.com/posts/2013/2013-10-12-automated_notifications_of_experiment_progress/) about using [Growl](http://growl.info/) in combination with [Prowl](http://www.prowlapp.com/) to get remote notifications of experiment progress on both a Mac and iPhone. Later that day, I started thinking about some improvements to the script after a brief Twitter [conversation](https://twitter.com/modernscientist/status/389159633753210880) with [Seth Brown](https://twitter.com/DrBunsen).[^follow] 

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

[gist:id=7060718,file=Improved_Growl_Experiment_Status.sh]

Have fun!

[image1]: {filename}/images/2013-10-19_automated_notifications_of_experiment_progress_part_2_1.png "Prowl API Key Generation"

[^follow]: If you are interested in python, data visualization, R, and pretty much every other cool thing on the internet, you should definitely follow him and read his [blog](http://www.drbunsen.org/).

[^alt]: This alternative could be also be used exclusively instead of Growl. However, I prefer receiving notifications on my Mac if I am actively using it.

[^api]: I set up my Prowl account so long ago, that I don't recall if the initial API key was active or if I generated it.