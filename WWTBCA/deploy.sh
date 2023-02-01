echo changing to server
cd server 
echo running npm
npm install
echo changing to client
cd ../client
echo running npm
npm install
#npm run-script build
#cp -R ./build ../server/public
echo changing back to server
cd ../server
echo running node to background
node server.js &
echo changing back to client
cd ../client
echo running npm to background
npm start 