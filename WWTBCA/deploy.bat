@echo off

echo change into server folder
cd server
echo run npm install
npm install
echo change into client folder
cd %CD%.\client
echo run npm install
npm install
npm run-script build
COPY  %CD%\build %CD%.\server\public
echo run npm start
%CD%.\server
START /B nodemon server.js 
