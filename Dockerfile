# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy solution and project
COPY dotnet-core-api-master.sln ./
COPY dotnet-core-api-master/ ./dotnet-core-api-master/

# Restore NuGet packages
RUN dotnet restore dotnet-core-api-master.sln

# Build the project
RUN dotnet build dotnet-core-api-master.sln -c Release -o /app/build

# Publish the API project
RUN dotnet publish dotnet-core-api-master/dotnet-core-api-master.csproj -c Release -o /app/publish

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

# Copy published output
COPY --from=build /app/publish .

# Expose HTTP
EXPOSE 80

# Run the API
ENTRYPOINT ["dotnet", "dotnet-core-api-master.dll"]
