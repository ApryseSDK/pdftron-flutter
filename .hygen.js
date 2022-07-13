module.exports = {
    helpers: {
        /**
         * Converts the Flutter config type to an Android type extracted from decoding JSON.
         * @param config Flutter config type
         * @returns {*|string} Android config type from JSON; returns given param if no match is found
         */
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
        /**
         * Converts the Flutter config type to an iOS type extracted from decoding JSON.
         * @param config iOS config type
         * @returns {*|string} iOS config type from JSON; returns given param if no match is found
         */
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
