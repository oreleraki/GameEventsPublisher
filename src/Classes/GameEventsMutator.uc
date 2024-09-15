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
    // Log("++ [GameEndPublisher] Is Tournament ? "$bIsTournament);
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
    Log(" :============================================================:");
    Log(" :    GameEventsMutator v0.3.2-alpha");
    Log(" :");
    Log(" :       ***  SETTINGS  ***");
    Log(" : bEnabled                            = " $ string(Config.bEnabled));
    Log(" : Debug                               = " $ string(Config.Debug));
    Log(" : Host                                = " $ Config.Host);
    Log(" : Port                                = " $ string(Config.Port));
    Log(" : Path                                = " $ Config.Path);
    Log(" : PasswordHeaderName                  = " $ Config.PasswordHeaderName);
    Log(" : Password                            = " $ Config.Password);
    Log(" : WaitingPlayersIntervalInSecs        = " $ string(Config.WaitingPlayersIntervalInSecs));
    Log(" : WaitingPlayersIntervalInSecsExpired = " $ string(Config.WaitingPlayersIntervalInSecsExpired));
    Log(" : TeamInfoJson                        = " $ Config.TeamInfoJson);
    Log(" : PlayerInfoJson                      = " $ Config.PlayerInfoJson);
    Log(" :============================================================:");
    Log("");
}