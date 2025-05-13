const fs = require("fs");

let str = `class Main inherits IO {
    main() : Object {{
`;
for (let i = 0; i < 500; i++) {
    str += `        out_int(${i});\n`;
    str += `        out_string("asdf${i}");\n`;
}
str += `    }};
};`;

fs.writeFileSync("./benchmark1.cl", str);

str = `class Main inherits IO {
`;

for (let i = 0; i < 640; i++) {
    str += `    blah${i} : String <- "blah${i}";\n`;
}

str += `
    main() : Object {{
`;
for (let i = 0; i < 640; i++) {
    str += `        out_string(blah${i});\n`;
}
str += `    }};
};`;

fs.writeFileSync("./benchmark2.cl", str);
