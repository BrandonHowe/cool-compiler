import * as fs from "fs/promises";

function generatePairs(n) {
    let pairs = [];
    for (let i = 1; i <= n; i++) {
        for (let j = i + 1; j <= n; j++) {
            pairs.push([i, j]);
            pairs.push([j, i]);
        }
    }
  return pairs;
}

const pairs = generatePairs(250);
let str = "";
for (const pair of pairs) {
    str += `${pair[0]}\n${pair[1]}\n`;
}
fs.writeFile("testcase.list", str);
