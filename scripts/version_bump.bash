VERSION=$(yq '.version' pubspec.yaml)
IFS='.' 
read -a TOKENS <<< "$VERSION"
v="$VERSION"
UPDATE=$(expr ${TOKENS[3]} + 1) 
IFS=''
NEW_VERSION="${TOKENS[0]}.${TOKENS[1]}.${TOKENS[2]}.$UPDATE" 
echo $NEW_VERSION
# yq -i '.version = strenv(NEW_VERSION)' pubspec.yaml
