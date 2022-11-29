class GameEventsMutator extends Mutator;

var GameEventsConfig Config;
var GameEventsManager Manager;

function PreBeginPlay() {
    local bool bIsTournament;

    super.PreBeginPlay();

    Config = new class'GameEventsConfig'();
    Config.SaveConfig();

    bIsTournament = DeathMatchPlus(Level.Game).Default.bTournament;
    PrintHello();
    Log("[GameEvents]: Is Tournament ? "$bIsTournament);
    if (bIsTournament && Config.bEnabled)
    {
        Manager = Level.Spawn(class'GameEventsManager', Self, 'EndGame');
        Manager.Setup(Config);
    }
}

function PrintHello() {
    Log("");
    Log(" :=================================================:");
    Log(" :    GameEventsMutator has Initialized!");
    Log(" :");
    Log(" :       ***  SETTINGS  ***");
    Log(" : bEnabled                = " $ string(Config.bEnabled));
    Log(" : Debug                   = " $ string(Config.Debug));
    Log(" : WaitingPlayersDuration  = " $ string(Config.WaitingPlayersDuration));
    Log(" : Host                    = " $ Config.Host);
    Log(" : Path                    = " $ Config.Path);
    Log(" : PasswordHeaderName      = " $ Config.PasswordHeaderName);
    Log(" : Password                = " $ Config.Password);
    Log(" :=================================================:");
    Log("");
}