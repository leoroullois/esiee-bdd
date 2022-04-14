import fs from "fs";
import { join } from "path";

const parseFile = (): string => {
   const file = join(__dirname, "../assets/csv", "Responsable.csv");
   const data = fs.readFileSync(file, "utf8").split("\n");
   data.shift();
   const responsable = data.map((line) => {
      const output = {
         nomResponsable: "",
         prenomResponsable: "",
      };
      if (line) {
         const currLine = line.split(" ");
         const prenom = currLine.pop();
         const nom = currLine.join(" ");
         output.nomResponsable = nom.replace("\r", "");
         if (prenom) {
            output.prenomResponsable = prenom.replace("\r", "");
         }
      }
      return output;
   });
   console.log(responsable);
   fs.writeFile(
      join(__dirname, "../assets/json/responsable.json"),
      JSON.stringify(responsable),
      (err) => {
         if (err) {
            console.error("Error writing file", err);
         } else {
            console.log("Successfully wrote file");
         }
      }
   );
   return JSON.stringify(responsable);
};
export default parseFile;

