import fs from "fs";
import { join } from "path";

interface IDecouverte {
   idDecouverte: number;
   syntheseDecouverte: string;
   idCoordonnees_localise: number;
   idOperation_decouvre: number;
   idAdresse_situe: number;
}
const parseFile = (): IDecouverte[] => {
   const file = join(__dirname, "../assets/csv", "Decouverte.csv");
   const data = fs.readFileSync(file, "utf8").split("\n");
   data.shift();
   const decouverte = data.map((line, i) => {
      const output: IDecouverte = {
         idDecouverte: 0,
         syntheseDecouverte: "",
         idCoordonnees_localise: 0,
         idOperation_decouvre: 0,
         idAdresse_situe: 0,
      };
      if (line) {
         const currLine = line.split(";", 2);
         if (i === 0) {
            console.log(currLine);
            console.log(line);
         }
         if (currLine.length === 1) {
            const elt = currLine[0].replace("\r", "");
            if (Number.isNaN(Number(elt))) {
               output.syntheseDecouverte = elt;
            } else {
               output.idDecouverte = Number(elt);
            }
         } else {
            if (isNaN(Number(currLine[0]))) {
               output.syntheseDecouverte = currLine.join(";");
            }
            const id = Number(currLine[0].replace("\r", ""));
            const synthese = currLine[1].replace("\r", "");
            output.idDecouverte = id;
            output.syntheseDecouverte = synthese;
         }
         output.idAdresse_situe = i;
         output.idCoordonnees_localise = i;
         output.idOperation_decouvre = i;
      }
      return output;
   });
   return decouverte;
};

const writeFile = (): void => {
   fs.writeFile(
      join(__dirname, "../assets/json/decouverte.json"),
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

