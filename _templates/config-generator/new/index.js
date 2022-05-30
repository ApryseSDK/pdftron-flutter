module.exports = {
    prompt: ({ inquirer }) => {
      // defining questions in arrays ensures all questions are asked before next prompt is executed
      const questions = [
        {
          type: 'input',
          name: 'name',
          message: 'Name of config?',
        },
        {
          type: 'input',
          name: 'type',
          message: 'Type of config? (ex: bool, int, String, List, Map<String, String>)',
        }
      ]

      return inquirer
        .prompt(questions)
    },
  }
