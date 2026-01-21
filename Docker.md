`docker run <image name>`

# Flags
- `-d` is the detatched flag this means it will start up in the background
- `--name` can be used to name the container
- `--restart` is used to specify the restart configuration
- `-p` is used to specify which port

- `docker ps` lists all running containers. Add the `-a` flag to show all containers including the inactive ones  
- `docker stop <container name>` is the command to stop a container
- `docker rm <container name>` is used to delete a container
- `docker image rm <<image_name>>` is used to remove an image. This can only be done if no running containers are using that image

# Restart
- **no** - Never restart containers. You must always manually start them. This is Docker's default behavior
- **on-failure** - Restart when the container exited with a non-zero exis status. You may add a number of maximum tries, for example, on-failure, to try five times.
- **always** - Always restart the container when it stops
- **unless-stopped** - Always restart unless manually stopped