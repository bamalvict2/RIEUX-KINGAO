FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copier les csproj
COPY Solaize.Shared/Solaize.Shared.csproj Solaize.Shared/
COPY SolaizeApi/SolaizeApi.csproj SolaizeApi/

# Restore
RUN dotnet restore SolaizeApi/SolaizeApi.csproj

# Copier tout le code (IMPORTANT)
COPY . .

# Publish
RUN dotnet publish SolaizeApi/SolaizeApi.csproj -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

ENTRYPOINT ["dotnet", "SolaizeApi.dll"]