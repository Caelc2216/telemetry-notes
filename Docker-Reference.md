# FROM
```FROM [--platform=<platform>] <image> [AS <name>]```
```FROM [--platform=<platform>] <image>[:<tag>] [AS <name>]```
```FROM [--platform=<platform>] <image>[@<digest>] [AS <name>]```

The FROM instruction initializes a new build stage. Valid Dockerfiles start with a FROM instruction  
- FROM can be used multiple times in a Dockerfile to create multiple images or use one build stage as a dependency for another.
- A name can be given using the AS name.
- tag or digest is also optional, the builder assumes a latest tag by default.

# WORKDIR
```WORKDIR /path/to/workdir```
The WORKDIR instruction sets the working directory for any RUN, CMD, ENTRYPOINT, COPY, and ADD instructions that follow it in the Dockerfile. If the WORKDIR doesn't exist, it will be created.  

If there are multiple WORKDIR instructions each additional one will be added to the path of the previous for example:
```
WORKDIR /a
WORKDIR b
WORKDRI c
RUN pwd
```
The output of the pwd command would be /a/b/c  

You can use environment variable ENV to set the WORKDIR
```
ENV DIRPATH=/path
WORKDIR $DIRPATH/$DIRNAME
RUN pwd
```
the output would be /path/$DIRNAME

# COPY
```COPY [OPTIONS] <src> ... <dest>```
```COPY [OPTIONS] ["<src>", ... "<dest>"]```

**Available Options**  
- ```--from```
- ```--chown```
- ```--chmod```
- ```--link```
- ```--parents```
- ```--exclude```
COPY copies new files or directories from <src> and adds them to the filesystem of the image at the path <dest>. You can specify multiple source files or directories with COPY. The last argument must always be the destination, for example:
```COPY file1.txt file2.txt /usr/src/things/``` This will copy both file1 and file2 to the path /usr/src/things/.  
- * is a wildcard
- ? is a single character wildcard
- when adding files or directories with special characters like [ or ] they need to be escaped for ```arr[0].txt``` it would be ```COPY arr[[]0].txt /dest/```

**COPY --from**  
COPY--from is used to copy files from an image, a build stage or a named context  
```COPY [--from=<image|stage|context>] <src> ... <dest>```
use the name specified after the AS keyword in the FROM instruction  

**COPY --chown --chmod**  
```COPY [--chown=<user>:<group>] [--chmod=<perms> ...] <src> ... <dest>```
the --chown flag specifies a specific username and groupname that you want it to be grouped by in the /etc directory.  

**COPY --link**  
```COPY [--link[=<boolean>]] <src> ... <dest>```
link is used to reuse already built layers in subsequent builds.  

**COPY --parents**  
```COPY [--parents[=<boolean>]] <src> ... <dest>```  
this flag preserves parent directories for src entries, it defaults to false.  

**COPY --exclude**  
```COPY [--exclude=<path> ...] <src> ... <dest>```  
exclude flag lets you specify a path expression for files to be excluded

# ENV
```ENV <key>=<value> [<key>=<value>...]```  
The ENV instructions sets the environment variable <key> to the value <value>. You can view the vaalues using ```docker inspect``` and change them using ```docker run --env <key>=<value>```  

# RUN
```RUN [OPTIONS] <commaand> ...```
```RUN [OPTIONS] ["<command>", ...]```
 **Options**  
 - ```--device``` allows buid to request CDI devices to be available to the build step
 - ```--mount``` allows you to create filesystem mounts that the build can access ```RUN --moung=[type=[bind|cache|tmpfs|secret|ssh]][option=<value>[option=<value>]...]```
 - ```--network``` allows control over which networking environment the command is run in (default, none, or host)
 - ```--security``` the default security mode is sandbox. With --security=insecure

 # CMD
 ```CMD command param1 param2```
 - There can only be one CMD instruction in a Dockerfile, if more are listed the last one takes effect
 - If the user specifies arguments to docker run then they will override the default specified in CMD, but still use the default ENTRYPOINT

 # ENTRYPOINT
 allows you to configure a container that will run as an executable
 ```ENTRYPOINT ["executable", "param1", "param2"]```
 ```ENTRYPOINT command param1 param2```
 - Only the last ENTRYPOINT instruction in the Dockerfile will have an effect

 **Understand how CMD and ENTRYPOINT interact**  
 1. Dockerfile should specify at least one of CMD or ENTRYPOINT commmands
 2. ENTRYPOINT should be defined when using the container as an executable
 3. CMD should be used as a way of defining default arguments for an ENTRYPOINT command or for executing an ad-hoc command in a container
 4. CMD will be overridden when running the container with alternative arguments

```
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build-env  # uses the dotnet sdk image and sets an alias as build-env
WORKDIR /App # this specifies the working directory for other commands
COPY . ./ # this copies everything into a new subdirectory of the App directory
RUN dotnet restore # runs this command to restore dependencies
RUN dotnet publish -c Release -o out # runs this command

FROM mcr.microsoft.com/dotnet/aspnet:9.0 # starts a new build using the image aspnet
WORKDIR /App # again sets the working directory to App so that other commands can run here
COPY --from=build-env /App/out . # copies out files from the previous build (build-env) and puts them in the directory /App/out
ENTRYPOINT ["dotnet", "DotNet.Docker.dll"] # runs command `dotnet DotNet.Docker.dll`, there can only be one ENTRYPOINT in a Dockerfile
```
