const Cloudant = require("@cloudant/cloudant");

const getCloudantInstance = () => {
  return new Cloudant({
    url: process.env.CLOUDANT_HOST,
    plugins: {
      iamauth: {
        iamApiKey: process.env.CLOUDANT_APIKEY,
      },
    },
  });
};
const useLocalDb = true;
const dbHandler = useLocalDb ? require('nano')(process.env.LOCAL_DB_HOST) : getCloudantInstance();

const wwtbca_db = dbHandler.db.use("wwtbca");

wwtbca_db.update = function (obj, key) {
  var db = this;
  return db.get(key).then((item) => {
    obj._rev = item._rev;
    db.insert(obj, key);
  });
};

module.exports = wwtbca_db;