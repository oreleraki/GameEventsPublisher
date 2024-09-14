# Game Events Publisher

UnrealTournament package for publishing selected game events to an HTTP Endpoint.

Version: 0.3.2-alpha<br>
Author: Orel Eraki<br>
Email: orel.eraki@gmail.com<br>

## Change Log
Can be found at [*changelog.txt*](changelog.txt)

## Dependencies
- Core
- Engine
- IpDrv
- Botpack
- UBrowser

## Installations
First copy *GameEventsPublisher.u* and *GameEventsPublisher.int* into *System* folder.

There are 2 options for loading the package.

1. ServerActor: For always loading when game starts, add it to ServerActors as follow
Under `[Engine.GameEngine]` add a new line.
Should look like this
```ini
[Engine.GameEngine]
# All existing lines of code..
ServerActors=GameEventsPublisher.GameEventsPublisherSA
```

2. Mutator: For only loading it when you want to.
Name: `GameEventsPublisher.GameEventsMutator`

## Upgrade from..
### 0.3.1-alpha
- Remove or Replace configuration properties of ***TeamInfoJson*** and ***PlayerInfoJson*** as below. [Configuration](#Configuration)

## Configuration
The following are the default configuration which will be saved at initial loading.

```ini
[GameEventsPublisher.GameEventsConfig]
bEnabled=True
Host=localhost
Port=7790
Path=
PasswordHeaderName=Authorization
Password=
Debug=False
WaitingPlayersIntervalInSecs=60
WaitingPlayersIntervalInSecsExpired=600
TeamInfoJson=%Index%,%Name%,%Score%
PlayerInfoJson=%Id%,%Index%,%Name%,%Score%,%Ready%,%Password%,%Team%,%DieCount%,%KillCount%,%Spree%
```

## Requests
Request are sent in the form of HTTP/1.0 POST request with payload body in JSON format.
They will be sent to "http://Host:Port/Path"

## Events Names
| Name                  | Description |
| -----------           | ----------- |
| WaitingPlayers        | When map is loaded and every `WaitingPlayersIntervalInSecs` Interval.
| WaitingPlayersEnd     | After configuration(`WaitingPlayersIntervalInSecsExpired`) has reached.
| MatchStarted          | Players started playing.
| FlagCapture          	| Flag has been captured. When occur `InstigatorId` will be populated with PlayerId.
| MatchEnded            | Match ended.

Note: All events are sent in capital letters.

## Examples

```json
{
	"Name": "MATCHENDED",
	"InstigatorId": -1,
	"IP": "0.0.0.0:7777",
	"GameType": "CTFGame",
	"Map": "CTF-NaliTown",
	"GamePassword": "",
	"TimeSeconds": 120,
	"TimeLimit": 1,
	"FragLimit": 0,
	"RemainingTime": 0,
	"GoalTeamScore": 3,
	"MaxPlayers": 10,
	"NumPlayers": 2,
	"MaxTeams": 2,
	"Pauser": "",
	"MatchStarted": false,
	"MatchEnded": true,
	"Teams": {
		"Red": {
			"Index": 0,
			"Name": "Red",
			"Score": 1
		},
		"Blue": {
			"Index": 1,
			"Name": "Blue",
			"Score": 0
		}
	},
	"Players": [
		{
			"Id": 0,
			"Index": 0,
			"Name": "Player1",
			"Score": 8,
			"Ready": false,
			"Password": "",
			"Team": 0,
			"DieCount": 0,
			"KillCount": 1,
			"Spree": 1
		},
		{
			"Id": 1,
			"Index": 1,
			"Name": "Player2",
			"Score": -1,
			"Ready": false,
			"Password": "",
			"Team": 1,
			"DieCount": 2,
			"KillCount": 0,
			"Spree": 0
		}
	]
}
```