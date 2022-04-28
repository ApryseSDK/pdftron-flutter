module.exports = {
    prompt: ({ inquirer }) => {
      // defining questions in arrays ensures all questions are asked before next prompt is executed
      const questions = [
        {
          type: 'input',
          name: 'name',
          message: 'Name of Method?',
        },
        {
          type: 'input',
          name: 'flutterReturnType',
          message: 'Return Type of Flutter method? (ex: String?, int?)',
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