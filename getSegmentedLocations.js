const axios = require('axios');
const fs = require('fs');
const readline = require('readline');

locations = [];

const getLocations = (url) => {
  axios
    .get(url)
    .then((res) => {
      const location = res.data.response.location
      for (loc of location) {
        console.log(`${loc.prefecture}${loc.city}${loc.town}`);
      }
      // return res.data;
    })
    .catch((error) => {
      console.log(error);
    });

  // encodeURI('https://geoapi.heartrails.com/api/json?method=getTowns&prefecture=東京都&city=港区')
};

const getRawLocations = () => {
  const urls = []
  const data = fs.readFileSync('segmented_locations.csv', 'utf8')
  const rows = data.split('\n')
  for (const row of rows) {
    const prefectureAndCity = row.split(',')
    const url = `https://geoapi.heartrails.com/api/json?method=getTowns&prefecture=${prefectureAndCity[0]}&city=${prefectureAndCity[1]}`;
    urls.push(encodeURI(url));
  }
  return urls
};


const urls = getRawLocations();
for (const url of urls) {
  setTimeout(function(){ getLocations(url) }, 3000);
}