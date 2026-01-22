# start with dotnet cli
FROM mcr.microsoft.com/dotnet/sdk:10.0

# get the code in here
WORKDIR /app
COPY . .

# build it
RUN dotnet build

# turn on the website
# ENTRYPOINT dotnet run
CMD dotnet run