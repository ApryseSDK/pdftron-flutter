module.exports = {
    helpers: {
        javaConstants: params => {
            let arr = params.split(/(?=[A-Z])/);
            arr = arr.map(element => {
                return element.toUpperCase();
              });
            return arr.join('_')
        },
        getJavaConfigValue: config => {
            let dict = {
                "bool" : "boolean",
                "List" : "JSONArray",
                "Map" : "JSONObject"
            };
            for (const [key, value] of Object.entries(dict)) {
                if (key.includes(config))
                    return value;
            }
            return config
        },
        getIOSConfigValue: config => {
            let dict = {
                "bool" : "NSNumber",
                "List" : "NSArray",
                "Map" : "NSDictionary"
            };
            for (const [key, value] of Object.entries(dict)) {
                if (key.includes(config))
                    return value;
            }
            return config
        },
    }
}
