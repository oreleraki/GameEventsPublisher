class GameEventsConfig extends Object
    config;

var() globalconfig bool     bEnabled;
var() globalconfig string   Host;
var() globalconfig int      Port;
var() globalconfig string   Path;
var() globalconfig string   PasswordHeaderName;
var() globalconfig string   Password;
var() globalconfig bool     Debug;
var() globalconfig string 	TeamInfoJson;
var() globalconfig string 	PlayerInfoJson;
var() globalconfig int      WaitingPlayersIntervalInSecs;
var() globalconfig int      WaitingPlayersIntervalInSecsExpired;

DefaultProperties {
	bEnabled=true
	Host="localhost"
	Port=7790
	Path=""
	PasswordHeaderName="Authorization"
	Password=""
	Debug=false
    TeamInfoJson="%Name%,%Index%,%Score%"
    PlayerInfoJson="%Name%,%Index%,%Id%,%Ready%,%Password%,%Team%"
	WaitingPlayersIntervalInSecs=60
	WaitingPlayersIntervalInSecsExpired=600
}