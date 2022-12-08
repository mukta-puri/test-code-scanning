FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine3.14 as netCoreBuild
ARG NUGET_VERSION
ARG CONFIGURATION=Release
ARG ARTIFACTORY_USERNAME
ARG ARTIFACTORY_PASSWORD
ENV ARTIFACTORY_USERNAME ${ARTIFACTORY_USERNAME}
ENV ARTIFACTORY_PASSWORD ${ARTIFACTORY_PASSWORD}
WORKDIR /build
COPY . test-code-scanning
WORKDIR /build/test-code-scanning
RUN dotnet publish -c Release -o out -v normal

FROM tylertech-docker.jfrog.io/tyler-apm-aspnetcore:6.0-3.3-alpine
ARG VERSION="0.0.0"
ENV VERSION ${VERSION}
WORKDIR /app
EXPOSE 8080
COPY --from=netCoreBuild build/test-code-scanning/out .
ENV ASPNETCORE_URLS "http://*:8080"
ENTRYPOINT ["dotnet", "test-code-scanning.dll"]
