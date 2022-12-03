class GameEventsMutator extends Mutator;

var GameEventsConfig Config;
var GameEventsManager Manager;
var GameEventsMessagingSpectator MessagingSpectator;

function PreBeginPlay() {
    // local bool bIsTournament;

    super.PreBeginPlay();

    Config = new class'GameEventsConfig'();
    Config.SaveConfig();

    // bIsTournament = DeathMatchPlus(Level.Game).Default.bTournament;
    PrintHello();
    // Log("[GameEvents]: Is Tournament ? "$bIsTournament);
    if (Config.bEnabled)
    {
        Manager = Level.Spawn(class'GameEventsManager', Self, 'EndGame');
        Manager.Setup(Config);

        MessagingSpectator = Level.Game.Spawn(class'GameEventsMessagingSpectator', Manager);
        // Level.Game.RegisterMessageMutator(MessagingSpectator);
        if (Manager != None && MessagingSpectator != None)
        {
            Log(Self$" Initialized!", class.Name);
        }
    }
}

function PrintHello() {
    Log("");
    Log(" :=================================================:");
    Log(" :    GameEventsMutator v0.2-alpha");
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