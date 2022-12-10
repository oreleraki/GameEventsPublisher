# Game Events Publisher

UnrealTournament package for publishing selected game events to an HTTP Endpoint.

Version: 0.3.1-alpha<br>
Author: Orel Eraki<br>
Email: orel.eraki@gmail.com<br>

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
	"GameType": "TeamGamePlus",
	"Map": "DM-Deck16][",
	"GamePassword": "testpass",
	"TimeSeconds": 120,
	"TimeLimit": 3,
	"FragLimit": 2,
	"RemainingTime": 100,
	"GoalTeamScore": 2,
	"MaxPlayers": 2,
	"NumPlayers": 2,
	"MaxTeams": 4,
	"Pauser": "",
	"PlayersReady": false,
	"MatchStarted": true,
	"MatchEnded": true,
	"Teams": {
		"Red": {
			"Name": "Red",
			"Index": 0,
			"Score": 2
		},
		"Blue": {
			"Name": "Blue",
			"Index": 1,
			"Score": 0
		},
		"Green": {
			"Name": "Green",
			"Index": 2,
			"Score": 0
		},
		"Gold": {
			"Name": "Gold",
			"Index": 3,
			"Score": 0
		}
	},
	"Players": [
		{
			"Name": "Nighthawk",
			"Index": 0,
			"Id": 0,
			"Ready": true,
			"Password": "testpass",
			"Team": 0
		},
		{
			"Name": "foobar",
			"Index": 1,
			"Id": 1,
			"Ready": true,
			"Password": "testpass",
			"Team": 1
		}
	]
}
```