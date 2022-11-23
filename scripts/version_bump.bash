VERSION=$(yq '.version' pubspec.yaml)
IFS='-' 
read -a TOKENS <<< "$VERSION"
v="$VERSION"
UPDATE=$(expr ${TOKENS[1]} + 1) 
IFS=''
NEW_VERSION="${TOKENS[0]}-$UPDATE" yq -i '.version = strenv(NEW_VERSION)' pubspec.yaml
