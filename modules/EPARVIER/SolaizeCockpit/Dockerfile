FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copier les csproj
COPY Solaize.Shared/Solaize.Shared.csproj Solaize.Shared/
COPY SolaizeCockpit/SolaizeCockpit.csproj SolaizeCockpit/

# Restore
RUN dotnet restore SolaizeCockpit/SolaizeCockpit.csproj

# Copier tout le code (IMPORTANT)
COPY . .

# Publish
RUN dotnet publish SolaizeCockpit/SolaizeCockpit.csproj -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:80
EXPOSE 80

ENTRYPOINT ["dotnet", "SolaizeCockpit.dll"]