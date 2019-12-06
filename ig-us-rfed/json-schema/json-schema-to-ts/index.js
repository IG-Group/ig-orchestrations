const jsonSchema = require('json-schema-to-typescript');
const fs = require('fs');
const path = require('path');

const DEFINITION_DIR = 'target/generated-resources/definitions';
const DEFINITION_FIELDS_DIR = DEFINITION_DIR + '/fields';
const DEFINITION_OUTPUT_DIR = 'fix.d/';
const DEFINITION_FIELDS_OUTPUT_DIR = DEFINITION_OUTPUT_DIR + 'fields/';
const PARENT_FULL_DIR = () => {
  const cwd = process.cwd().split(path.sep);
  cwd.pop();
  return cwd.join(path.sep);
}

if (!fs.existsSync(DEFINITION_OUTPUT_DIR)){
    fs.mkdirSync(DEFINITION_OUTPUT_DIR);
    fs.mkdirSync(DEFINITION_FIELDS_OUTPUT_DIR);
}

 fs.readdir('../' + DEFINITION_DIR, (err, items) => {
   if (err) {
     console.log(err);
   } else {
     items.forEach(async (i) => {
       if (i == 'fields') {
         fs.readdir('../' + DEFINITION_DIR + '/' + i, (err, fields) => {
           if (err) {
             console.log(err);
           } else {
             fields.forEach(async (i) => {
               await generateSchema(i, PARENT_FULL_DIR() + '/' + DEFINITION_FIELDS_DIR + '/' + i, DEFINITION_FIELDS_OUTPUT_DIR);
             });
           }
         });
       }
     });

     items.forEach(async (i) => {
       if (i != 'fields' && i.includes('.json')) {
         await generateSchema(i, PARENT_FULL_DIR() + '/' + DEFINITION_DIR + '/' + i, DEFINITION_OUTPUT_DIR, DEFINITION_OUTPUT_DIR, { cwd: PARENT_FULL_DIR() + '/' + DEFINITION_DIR });
       }
     });
   }
 });

async function generateSchema(file, inputDir, outputDir, opts) {
  const filename = file.replace('.json', '') + '.d.ts';

  try {
    const schema = await jsonSchema.compileFromFile(inputDir, opts);
    fs.writeFileSync(outputDir + filename, schema);
  } catch(e) {
    console.log("error is " + e);
  }
}
