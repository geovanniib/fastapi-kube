import http from 'k6/http';
import { check, sleep } from 'k6';


const BASE_URL = 'http://localhost:3030';
const NAMES = ["white", "black", "gray", "red", "pink", "grape", "violet", "indigo", "blue", "cyan", "teal", "green", "lime", "yellow", "orange"];

// See https://k6.io/docs/using-k6/k6-options/
export const options = {
  vus: 10,
  duration: '3m',
  ext: {
    loadimpact: {
      name: 'Smoke Test',
    },
  },
};

export default function () {
  // Health check for /worker
  let workerHealthCheck = http.get(`${BASE_URL}/worker`);
  check(workerHealthCheck, {
    'worker is healthy': (r) => r.status === 200,
  });

  // Health check for /color
  let colorHealthCheck = http.get(`${BASE_URL}/color`);
  check(colorHealthCheck, {
    'color service is healthy': (r) => r.status === 200,
  });

  // Randomly pick a color name from the list
  let randomIndex = Math.floor(Math.random() * NAMES.length); // Random index
  let randomName = NAMES[randomIndex]; // Get the color name from the list

  // Request to /color/match with the randomly selected name
  let matchResponse = http.get(`${BASE_URL}/color/match?name=${randomName}`);
  check(matchResponse, {
    'match request successful': (r) => r.status === 200,
  });

  // Sleep for 1 second before the next iteration
  sleep(1);
}