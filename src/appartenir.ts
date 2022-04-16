import fs from "fs";
import { join } from "path";

interface IAppartenir {
   idEpoque_appartient: number;
   idDecouverte_a_appartenu: number;
}

const mapEpoque = (epoque: string): number => {
   switch (epoque) {
      case "Préhistoire":
         return 0;
      case "Protohistoire":
         return 1;
      case "Antiquité":
         return 2;
      case "Moyen-Age":
         return 3;
      case "Temps modernes":
         return 4;
      case "Epoque contemporaine":
         return 5;
      default:
         return -1;
   }
};

const parseFile = (): IAppartenir[] => {
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
   const appartenir: IAppartenir[] = [];
   epoque.forEach((elt, i) => {
      console.log(elt);
      if (elt.length > 0) {
         elt.forEach((elt) => {
            appartenir.push({
               idEpoque_appartient: mapEpoque(elt),
               idDecouverte_a_appartenu: i,
            });
         });
      }
   });
   console.log(epoque);

   return appartenir;
};

const writeFile = (): void => {
   fs.writeFile(
      join(__dirname, "../assets/json/appartenir.json"),
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

