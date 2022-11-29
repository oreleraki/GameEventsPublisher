class GameEventArgs extends Object;

var String Name;
var String IP;
var String GameType;
var String Map;
var String GamePassword;
var int TimeSeconds;
var int GoalTeamScore;
var int TimeLimit;
var int FragLimit;
var int MaxPlayers;
var int NumPlayers;
var int RemainingTime;
var byte MaxTeams;
var String Pauser;
// var bool PlayersReady;
var bool MatchStarted;
var bool MatchEnded;
var GameEventsTeamInfo Teams[4];
var GameEventsPlayerInfo Players[32];
var GameEventsPlayerInfo Spectators[6];

function GameEventsPlayerInfo GetPlayer(int index) {
    return Players[index];
}

function string ConvertToJson(String teamInfoJson, String playerInfoJson) {
    local class<GameEventsPublisherHelper> helper;
    local string str;
    local int i;

    local string teamStr;
    local string teamsStr;
    local GameEventsTeamInfo teamInfo;

    local string playerStr;
    local string playersStr;
    local GameEventsPlayerInfo playerInfo;

    helper = class'GameEventsPublisherHelper';

    str = str$"\"Name\":"$helper.static.WrapIntoJsonString(Name);
    str = str$",\"IP\":"$helper.static.WrapIntoJsonString(IP);
    str = str$",\"GameType\":"$helper.static.WrapIntoJsonString(GameType);
    str = str$",\"Map\":"$helper.static.WrapIntoJsonString(Map);
    str = str$",\"GamePassword\":"$helper.static.WrapIntoJsonString(GamePassword);
    str = str$",\"TimeSeconds\":"$TimeSeconds;
    str = str$",\"TimeLimit\":"$TimeLimit;
    str = str$",\"FragLimit\":"$FragLimit;
    str = str$",\"RemainingTime\":"$RemainingTime;
    str = str$",\"GoalTeamScore\":"$GoalTeamScore;
    str = str$",\"MaxPlayers\":"$MaxPlayers;
    str = str$",\"NumPlayers\":"$NumPlayers;
    str = str$",\"MaxTeams\":"$MaxTeams;
    str = str$",\"Pauser\":"$helper.static.WrapIntoJsonString(Pauser);
    // str = str$",\"PlayersReady\":"$helper.static.ConvertIntoJsonBool(PlayersReady);
    str = str$",\"MatchStarted\":"$helper.static.ConvertIntoJsonBool(MatchStarted);
    str = str$",\"MatchEnded\":"$helper.static.ConvertIntoJsonBool(MatchEnded);

    for (i = 0; i < MaxTeams; i++) {
        teamInfo = Teams[i];
        teamStr = teamInfoJson;
        teamStr = helper.static.Replace(teamStr, "%Name%", helper.static.CreateJsonPairAsString("Name", teamInfo.Name));
        teamStr = helper.static.Replace(teamStr, "%Index%", helper.static.CreateJsonPairAsInt("Index", teamInfo.Index));
        teamStr = helper.static.Replace(teamStr, "%Score%", helper.static.CreateJsonPairAsInt("Score", teamInfo.Score));
        teamsStr = teamsStr$Helper.static.WrapIntoJsonString(teamInfo.Name)$": {"$teamStr$"},";
    }
    teamsStr = "\"Teams\": {"$Mid(teamsStr, 0, Len(teamsStr)-1)$"}";

    for (i = 0; i < NumPlayers; i++) {
        playerInfo = GetPlayer(i);
        playerStr = playerInfoJson;
        playerStr = Helper.static.Replace(playerStr, "%Name%", Helper.static.CreateJsonPairAsString("Name", playerInfo.Name));
        playerStr = Helper.static.Replace(playerStr, "%Id%", Helper.static.CreateJsonPairAsInt("Id", playerInfo.Id));
        playerStr = Helper.static.Replace(playerStr, "%Index%", Helper.static.CreateJsonPairAsInt("Index", playerInfo.Index));
        playerStr = Helper.static.Replace(playerStr, "%Password%", Helper.static.CreateJsonPairAsString("Password", playerInfo.Password));
        playerStr = Helper.static.Replace(playerStr, "%Score%", Helper.static.CreateJsonPairAsInt("Score", playerInfo.Score));
        playerStr = Helper.static.Replace(playerStr, "%Ready%", Helper.static.CreateJsonPairAsBool("Ready", playerInfo.Ready));
        playerStr = Helper.static.Replace(playerStr, "%Team%", Helper.static.CreateJsonPairAsInt("Team", playerInfo.Team));
        playersStr = playersStr$"{"$playerStr$"},";
    }
    playersStr = "\"Players\": ["$Mid(playersStr, 0, Len(playersStr)-1)$"]";

    str = "{"$str$","$teamsStr$", "$playersStr$"}";
    return str;
}

// Creator
static function GameEventArgs Create(LevelInfo Level, Name stateName) {
    local GameEventArgs arg;
    local TournamentGameReplicationInfo tgri;
    local DeathMatchPlus deathMatchGameInfo;
    local Pawn p;
    local GameEventsPlayerInfo playerInfo;
    local GameEventsTeamInfo teamInfo;
    local TeamGamePlus teamGame;
    local int i;

	arg = new class'GameEventArgs';
    arg.Name = CAPS(stateName);
    arg.IP = Level.GetAddressURL();
    arg.MaxPlayers = Level.Game.MaxPlayers;
    arg.Map = Left(string(Level), InStr(string(Level), ".")); // Level.GetMapName(Level.Game.Default.MapPrefix, "", 0);
    arg.GameType = class'GameEventsPublisherHelper'.static.GetItemName(string(Level.Game.Class));
    deathMatchGameInfo = DeathMatchPlus(Level.Game); // should be TeamGamePlus?
    arg.FragLimit = deathMatchGameInfo.FragLimit;
    arg.TimeLimit = deathMatchGameInfo.TimeLimit;
    arg.NumPlayers = deathMatchGameInfo.NumPlayers;
    arg.RemainingTime = deathMatchGameInfo.RemainingTime;
    tgri = TournamentGameReplicationInfo(Level.Game.GameReplicationInfo);
    arg.GoalTeamScore = tgri.GoalTeamScore;
    arg.GamePassword = Level.ConsoleCommand("get Engine.GameInfo GamePassword");
    arg.TimeSeconds = Level.TimeSeconds;
    arg.Pauser = Level.Pauser;
    arg.MatchStarted = Level.Game.GameReplicationInfo.RemainingMinute > 0;
    arg.MatchEnded = deathMatchGameInfo.bGameEnded;

    i = 0;
    foreach Level.AllActors(class'Pawn', p)
    {
        // Log("AllActors[Pawn]: "$p.PlayerReplicationInfo.PlayerName);
        playerInfo = new class'GameEventsPlayerInfo'();
        if (p.bIsPlayer)
        {
            playerInfo.Id = p.PlayerReplicationInfo.PlayerID;
            playerInfo.Index = i;
            playerInfo.Team = p.PlayerReplicationInfo.Team;
            playerInfo.Name = p.PlayerReplicationInfo.PlayerName;
            playerInfo.Score = p.PlayerReplicationInfo.Score;
            if (PlayerPawn(p) != None) {
                playerInfo.Ready = PlayerPawn(p).bReadyToPlay;
                playerInfo.Password = PlayerPawn(p).Password;
            }
            arg.Players[i] = playerInfo;
            i++;
        }
    }

    teamGame = TeamGamePlus(Level.Game);
    arg.MaxTeams = teamGame.MaxTeams;
    for (i = 0; i < arg.MaxTeams; i++) {
        teamInfo = new class'GameEventsTeamInfo'();
        teamInfo.Name = teamGame.Teams[i].TeamName;
        teamInfo.Score = teamGame.Teams[i].Score;
        teamInfo.Index = teamGame.Teams[i].TeamIndex;
        teamInfo.Size = teamGame.Teams[i].Size;
        arg.Teams[i] = teamInfo;
    }
    return arg;
}

function static PrintPlayers(GameEventArgs arg) {
    local GameEventsPlayerInfo p;
    local int i;

    for (i = 0; i < arg.NumPlayers; i++) // Bad way to figure out number of populated array size;
    {
        p = arg.GetPlayer(i);
        Log(i$"."@p.Name$": Ready:"$p.Ready$", Team:"$p.Team$", Password:"$p.Password);
    }
}