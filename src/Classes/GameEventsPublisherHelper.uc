class GameEventsPublisherHelper extends Object;

static function string CreateJsonPairAsInt(string key, int value) {
    return "\""$key$"\":"@value;
}

static function string CreateJsonPairAsBool(string key, bool value) {
    return "\""$key$"\":"@ConvertIntoJsonBool(value);
}

static function string CreateJsonPairAsString(string key, string value) {
    return "\""$key$"\":"@WrapIntoJsonString(value);
}

static function string CreateJsonPairAsStringWithEscape(string key, string value) {
	local string escapedValue;
	escapedValue = Replace(value, "\\", "\\b"); // Escapes backslashes.
	escapedValue = Replace(value, "\"", "\\\""); // Escapes double quotes.
	escapedValue = Replace(value, "\n", "\\n"); // Escapes newlines.
	escapedValue = Replace(value, "\r", "\\r"); // Escapes carriage returns.
	escapedValue = Replace(value, "\t", "\\t"); // Escapes tabs.
	escapedValue = Replace(value, "\b", "\\b"); // Escapes backspaces.
	escapedValue = Replace(value, "\f", "\\f"); // Escapes form feeds.

    return "\""$key$"\":"@WrapIntoJsonString(escapedValue);
}

static function string WrapIntoJsonString(string value) {
    return "\""$Replace(value, "\\", "\\\\")$"\"";
}

static function string ConvertIntoJsonBool(bool value) {
    local string temp;
    temp = "false";
    if (value) {
        temp = "true";
    }
    return temp;
}

static function string Replace(string Text, string Match, string Replacement)
{
	local int i;
	
	i = InStr(Text, Match);	

	if(i != -1)
		return Left(Text, i) $ Replacement $ Replace(Mid(Text, i+Len(Match)), Match, Replacement);
	else
		return Text;
}

//
// Returns the string representation of the name of an object without the package
// prefixes.
//
static function String GetItemName( string FullName )
{
	local int pos;

	pos = InStr(FullName, ".");
	While ( pos != -1 )
	{
		FullName = Right(FullName, Len(FullName) - pos - 1);
		pos = InStr(FullName, ".");
	}

	return FullName;
}