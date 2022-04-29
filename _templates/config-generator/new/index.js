module.exports = {
    prompt: ({ inquirer }) => {
      // defining questions in arrays ensures all questions are asked before next prompt is executed
      const questions = [
        {
          type: 'input',
          name: 'name',
          message: 'Name of Config?',
        },
        {
          type: 'input',
          name: 'config',
          message: 'Config Value? (ex: String, int)',
        }
      ]
  
      return inquirer
        .prompt(questions)
    },
  }