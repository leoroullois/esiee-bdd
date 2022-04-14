import fs from "fs";
import { join } from "path";

interface IEpoque {
   libelleEpoque: string;
}
const parseFile = (): any => {
   const file = join(__dirname, "../assets/csv", "Epoque.csv");
   const data = fs.readFileSync(file, "utf8").split("\n");
   data.shift();
   const epoque = data.map((line, i) => {
      const output: string[] = [];
      if (line) {
         const currLine = line.split(";");
         const parsedLine = currLine.map((elt) => {
            if (elt === "Oui") {
               return true;
            } else {
               return false;
            }
         });
         console.log(parsedLine);
         parsedLine.forEach((epoque, i) => {
            if (epoque) {
               switch (i) {
                  case 0:
                     output.push("Préhistoire");
                     break;
                  case 1:
                     output.push("Protohistoire");
                     break;
                  case 2:
                     output.push("Antiquité");
                     break;
                  case 3:
                     output.push("Moyen-Age");
                     break;
                  case 4:
                     output.push("Temps modernes");
                     break;
                  case 5:
                     output.push("Epoque contemporaine");
                     break;

                  default:
                     break;
               }
            }
         });
      }
      return output;
   });
   console.log(epoque);

   return epoque;
};

const writeFile = (): void => {
   fs.writeFile(
      join(__dirname, "../assets/json/epoque.json"),
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

