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

fs.readdir('../' + DEFINITION_DIR, async (err, items) => {
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

    let mainResponses = items.filter(i => i != 'fields' && i.includes('.json'));
    let allSchemas = [];
    mainResponses.forEach(async (i) => {
      allSchemas.push(generateSchema(i, PARENT_FULL_DIR() + '/' + DEFINITION_DIR + '/' + i, DEFINITION_OUTPUT_DIR, { cwd: PARENT_FULL_DIR() + '/' + DEFINITION_DIR, }));
    });

    let result = await Promise.all(allSchemas);

    if (result) {
      cleanAndImportDefs();
    }
  }
});

async function generateSchema(file, inputDir, outputDir, opts) {
  const filename = file.replace('.json', '') + '.d.ts';

  try {
    const schema = await jsonSchema.compileFromFile(inputDir, opts);
    fs.writeFile(outputDir + filename, schema, (err) => {
      if (err) throw err;
    });
  } catch(e) {
    console.log("error is " + e);
  }
}

function cleanAndImportDefs() {
  fs.readdir(DEFINITION_OUTPUT_DIR, (err, items) => {
    items.forEach(def => {
      fs.readFile(DEFINITION_OUTPUT_DIR + def, (err, file) => {
        if (Buffer.isBuffer(file)) {
          let className = def.replace('.d.ts','')
          let filePerLine = file.toString().trim().split('\n');
          let mainClassIndex = filePerLine.findIndex(s =>  s.includes('interface ' +  className) || s.includes('type ' + className));
          let finalOutput = '';
          for (let i = mainClassIndex; i < filePerLine.length; i++) {
            finalOutput += filePerLine[i] + '\n'
            if (filePerLine[i] && filePerLine[i].match(/\??: [A-Z]/g)) {
              let foundClass = filePerLine[i].split(':')[1].trim();
              if (items.includes(foundClass.replace(';', '.d.ts'))) {
                  finalOutput = 'import { ' + foundClass.replace(';', '') + ' } from \'' + './' + foundClass.replace(';', '.d\';') + '\n' + finalOutput;
              } else {
                finalOutput = 'import { ' + foundClass.replace(';', '') + ' } from \'' + './fields/' + foundClass.replace(';', '.d\';') + '\n' + finalOutput;
              }
            }
            if ((filePerLine[i+1] && filePerLine[i+1].includes('/')) || i == filePerLine.length) {
              break;
            }
          }
          fs.writeFile(DEFINITION_OUTPUT_DIR + def, finalOutput, (err) => {
            if (err) console.log('Failed to add imports' + err);
          });
        }

      });

    });
  });
}
