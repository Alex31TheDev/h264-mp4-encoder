const fs = require("fs");
const path = require("path");

const args = process.argv.slice(2);

const dirpath = args[0] ?? "",
    filename = args[1] ?? "script.js";

const filepath = path.resolve(dirpath, filename);

let code = fs.readFileSync(filepath, "ascii");
code = code.replace(/(var\swasmExports)=(createWasm\(\)(;))/, "$1$3$2");

fs.writeFileSync(filepath, code, "ascii");