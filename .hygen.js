module.exports = {
    helpers: {
        javaConstants: (params) => {
            arr = params.split(/(?=[A-Z])/);
            arr = arr.map(element => {
                return element.toUpperCase();
              });
            return arr.join('_')  
        } 
    }
}