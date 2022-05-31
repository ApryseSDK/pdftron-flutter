module.exports = {
    prompt: ({ inquirer }) => {
      // defining questions in arrays ensures all questions are asked before next prompt is executed
      const questions = [
        {
          type: 'input',
          name: 'name',
          message: 'Name of method?',
        },
        {
          type: 'input',
          name: 'params',
          message: 'Parameter list of Flutter method (comma separated)? (ex: List<String> fieldNames, int flag, bool flagValue)'
        },
        {
          type: 'input',
          name: 'returnType',
          message: 'Return type of Flutter method? (ex: void, int, bool?, String?, List<String>?)',
        },
        {
          type: 'input',
          name: 'paramName',
          message: 'Parameter Name?',
        },
        {
          type: 'input',
          name: 'androidParam',
          message: 'Android Parameter Type? (ex: boolean,int,.. )',
        },
        {
          type: 'input',
          name: 'iOSParam',
          message: 'iOS Parameter Type? ( ex: BOOL, NSNumber.. )',
        }
      ]

      return inquirer
        .prompt(questions)
    },
  }
