import fs from "fs";
import { join } from "path";

interface IOperation {
   dateOperation: number;
   natureOperation: string;
   idResponsable_organise: number;
}
const parseFile = (): IOperation[] => {
   const file = join(__dirname, "../assets/csv", "Operation.csv");
   const data = fs.readFileSync(file, "utf8").split("\n");
   data.shift();
   const operation = data.map((line, i) => {
      const output = {
         dateOperation: 2000,
         natureOperation: "",
         idResponsable_organise: i+1,
      };
      if (line) {
         const currLine = line.split(";");
         const date = Number(currLine[0].replace("\r", ""));
         const nature = currLine[1].replace("\r", "");
         if (date) {
            output.dateOperation = date;
         } else {
            output.dateOperation = 9999;
         }
         output.natureOperation = nature;
      }
      return output;
   });
   return operation;
};

const writeFile = (): void => {
   fs.writeFile(
      join(__dirname, "../assets/json/operation.json"),
      JSON.stringify(parseFile()),
      (err) => {
         if (err) {
            console.error("Error writing file", err);
         } else {
            console.log("Successfully wrote file");
         }
      }
   );
};

export default writeFile;

