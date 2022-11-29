class GameEventsConfig extends Object
    config;

var() globalconfig bool     bEnabled;
var() globalconfig int      WaitingPlayersDuration;
var() globalconfig string   Host;
var() globalconfig int      Port;
var() globalconfig string   Path;
var() globalconfig string   PasswordHeaderName;
var() globalconfig string   Password;
var() globalconfig bool     Debug;

var() string TeamInfoJson;
var() string PlayerInfoJson;

DefaultProperties {
	bEnabled=true
    WaitingPlayersDuration=300
	Host="localhost"
	Port=7790
	Path=""
	PasswordHeaderName="Authorization"
	Password=""
	Debug=false
    TeamInfoJson="%Name%,%Index%,%Score%"
    PlayerInfoJson="%Name%,%Index%,%Id%,%Ready%,%Password%,%Team%"
}