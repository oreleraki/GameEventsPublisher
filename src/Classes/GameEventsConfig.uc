class GameEventsConfig extends Object
    config;

var() globalconfig bool     bEnabled;
var() globalconfig string   Host;
var() globalconfig int      Port;
var() globalconfig string   Path;
var() globalconfig string   PasswordHeaderName;
var() globalconfig string   Password;
var() globalconfig bool     Debug;
var() globalconfig int      WaitingPlayersIntervalInSecs;
var() globalconfig int      WaitingPlayersIntervalInSecsExpired;
var() globalconfig string 	TeamInfoJson;
var() globalconfig string 	PlayerInfoJson;

DefaultProperties {
	bEnabled=true
	Host="localhost"
	Port=7790
	Path=""
	PasswordHeaderName="Authorization"
	Password=""
	Debug=false
	WaitingPlayersIntervalInSecs=60
	WaitingPlayersIntervalInSecsExpired=600
	TeamInfoJson="%Index%,%Name%,%Score%"
    PlayerInfoJson="%Id%,%Index%,%Name%,%Score%,%Ready%,%Password%,%Team%,%DieCount%,%KillCount%,%Spree%"
}