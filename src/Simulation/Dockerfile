FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env
WORKDIR /app

# Copy necessary files and restore as distinct layer
COPY Simulation.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish --configuration Release --output out Simulation.csproj

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0
COPY --from=build-env /app/out .

# Expose ports
EXPOSE 6004/tcp
ENV ASPNETCORE_URLS http://*:6004

# Start
ENTRYPOINT ["dotnet", "Simulation.dll"]
