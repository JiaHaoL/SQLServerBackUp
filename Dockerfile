FROM mcr.microsoft.com/dotnet/aspnet:6.0

WORKDIR /app

EXPOSE 80

COPY ./ /app

ENV TZ=Asia/Shanghai

ENTRYPOINT ["dotnet", "Powers.DbBackup.SqlServer.Sample.dll", "--urls","http://*:8088"]
