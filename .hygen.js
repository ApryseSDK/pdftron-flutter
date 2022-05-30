module.exports = {
    helpers: {
        getJavaConfigValue: config => {
            let dict = {
                "bool" : "boolean",
                "List" : "JSONArray",
                "Map" : "JSONObject"
            };
            for (const [key, value] of Object.entries(dict)) {
                if (config.includes(key))
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
                if (config.includes(key))
                    return value;
            }
            return config
        },
    }
}
