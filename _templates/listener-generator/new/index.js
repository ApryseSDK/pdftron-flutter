module.exports = {
    prompt: ({ inquirer }) => {
      // defining questions in arrays ensures all questions are asked before next prompt is executed
      const questions = [
        {
          type: 'input',
          name: 'name',
          message: 'Name of event listener? (ex: zoomChanged, annotationsSelected)',
        },
        {
          type: 'input',
          name: 'params',
          message: 'Parameter list of Flutter listener (comma separated, only names)? (ex: previousPageNumber, pageNumber)'
        }
      ]

      // returning the answers to the prompt
      return inquirer
        .prompt(questions)
    },
}
