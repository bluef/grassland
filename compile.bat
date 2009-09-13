@echo off
echo ^<?xml version="1.0" encoding="UTF-8" standalone="no" ?^>^<application xmlns="http://ns.adobe.com/air/application/1.5"^> > Grassland-app.xml
echo ^<id^>net.dormforce.Grassland^</id^> >> Grassland-app.xml
echo ^<version^>build %date:~0,10%^</version^> >> Grassland-app.xml
echo ^<filename^>Grassland^</filename^> >> Grassland-app.xml
echo ^<description^>a simple xmpp implement^</description^> >> Grassland-app.xml
echo ^<name^>Grassland^</name^> >> Grassland-app.xml
echo ^<copyright^>BlueF^</copyright^> >> Grassland-app.xml
echo ^<initialWindow^> >> Grassland-app.xml
echo ^<content^>Grassland.swf^</content^> >> Grassland-app.xml
echo ^<systemChrome^>none^</systemChrome^> >> Grassland-app.xml
echo ^<transparent^>true^</transparent^> >> Grassland-app.xml
echo ^<visible^>false^</visible^> >> Grassland-app.xml
echo ^<maximizable^>false^</maximizable^> >> Grassland-app.xml
echo ^<minimizable^>true^</minimizable^> >> Grassland-app.xml
echo ^<resizable^>false^</resizable^> >> Grassland-app.xml
echo ^</initialWindow^> >> Grassland-app.xml
echo ^<icon^> >> Grassland-app.xml
echo ^<image128x128^>appIcons/AIRApp_128.png^</image128x128^> >> Grassland-app.xml
echo ^<image48x48^>appIcons/AIRApp_48.png^</image48x48^> >> Grassland-app.xml
echo ^<image32x32^>appIcons/AIRApp_32.png^</image32x32^> >> Grassland-app.xml
echo ^<image16x16^>appIcons/AIRApp_16.png^</image16x16^> >> Grassland-app.xml
echo ^</icon^> >> Grassland-app.xml
echo ^<customUpdateUI^>false^</customUpdateUI^> >> Grassland-app.xml
echo ^<allowBrowserInvocation^>false^</allowBrowserInvocation^> >> Grassland-app.xml
echo ^</application^> >> Grassland-app.xml

echo ^<?xml version="1.0" encoding="utf-8"?^> >update.xml
echo ^<update xmlns="http://ns.adobe.com/air/framework/update/description/1.0"^> >>update.xml
echo ^<version^>build %date:~0,10%^</version^> >>update.xml
echo ^<url^>http://202.115.22.207/grassland/Grassland.air^</url^> >>update.xml
echo ^<description^>This is the latest version of Grassland.^</description^> >>update.xml
echo ^</update^> >>update.xml

start "D:/Program Files/Adobe/Adobe Flash CS4/Flash.exe" tempPublish.jsfl