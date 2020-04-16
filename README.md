Future Gadget Lab Invention 4444: File Request Unified Gateway (Name STC)
===

The general idea
----------------
There will be three directories created, r, w, and x. The idea is that files you want clients to read only go in r, w is a space for uploads, and x is where you put scripts to run on the host, such as php files. Revolutionary, I know.

For each service, docker will spin up a container to run it, all the ports get forwarded to the right place, and thanks to volume mounts, you only need to worry about the three directories. that is, there is no seperate directory for web read only vs SMB real only vs... etc.

Must have docker and docker-compose ready to go.

Running the thing
-----------------
Set everything up with the prepear.sh script. There are a couple of variables that must be in order such as IP address. This script will create all the extra folders you need. To change variable in future, check the .env file, which is used by docker to set environment variables, or the relevant conf files.

Docker will use some environemnt variables in .env. Check that they make sense. The default creds are those that will be used to access the services.

Then just run (from here):

    docker-compose up

If you would like to only run specific services, just add them to the end of the command, e.g.:

    docker-compose up sftp

You may also add the -d flag to have everything run in the background. When you are done, run:

    docker-compose down

Note that in order to write to the w directory, you'll need to explicitly give it universal write permissions. I have not explicitly enabled it, as such a thing can be dangerous.

Also note, each service will bind to its "usual" port (apart from SSH/SFTP which binds to 2222). Hence if these ports are already in use, you won't be able to start the service.

Services
--------
There's a lot to list here, best to just check the docker-compose file to figure out what's being run.

However, there are a few specifics that are worth knowing.

The nginx web server is essentially acting as a gateway, so can be tweaked to forward certain requests to Empire/Metasploit. A guide to follow to enable that is here: https://ionize.com.au/reverse-https-meterpreter-and-empire-behind-nginx/. Additionally:
- In meterpreter, set up a persistent HTTP listener by setting ExitOnSession to false, and running with exploit -j -z
- You can still fire off active remote exploits, just make sure your payload options are the same as the listener, but then set DisablePayloadHandler to true
- For Empire, ensure the Host setting is exactly what you expect, it might get cheeky and try to change the port

Look at the nginx config file for specifics, the ports and URIs are hard coded in there.

The SFTP (essentially SSH) service can also be configured to allow both forward and reverse port forwarding. Look in the docker-compose file, you'll see a script which can be run to enable it.

TODO (I mean, I probably won't do it, but these would be nice to have):
---
 - WebDAV?
 - SCP? Don't really see the point, we have SFTP
 - Different creds for different services (docker compose sucks at recursive bash substitution)
 - Different creds for read and write access
 - Replace the SSH creds CMD with crypt version of the password
