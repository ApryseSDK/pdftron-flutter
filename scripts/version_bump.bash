VERSION=$1
IFS='.' 
read -a TOKENS <<< "$VERSION"
v="$VERSION"
UPDATE=$(expr ${TOKENS[3]} + 1) 
IFS=''
NEW_VERSION="${TOKENS[0]}.${TOKENS[1]}.${TOKENS[2]}.$UPDATE" 
RESULT="$NEW_VERSION"
echo "::debug::\$RESULT: $RESULT"
echo ::set-output name=result::"$RESULT"