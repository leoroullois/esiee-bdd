import fs from "fs";
import { join } from "path";

const parseFile = (): string => {
   const file = join(__dirname, "../assets/csv", "Operation.csv");
   const data = fs.readFileSync(file, "utf8").split("\n");
   data.shift();
   console.log(data);
   return JSON.stringify(data);
};

export default parseFile;

